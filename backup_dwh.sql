--
-- PostgreSQL database dump
--

-- Dumped from database version 14.7
-- Dumped by pg_dump version 14.7

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: dwh; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA dwh;


ALTER SCHEMA dwh OWNER TO postgres;

--
-- Name: ext; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA ext;


ALTER SCHEMA ext OWNER TO postgres;

--
-- Name: postgres_fdw; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgres_fdw WITH SCHEMA public;


--
-- Name: EXTENSION postgres_fdw; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgres_fdw IS 'foreign-data wrapper for remote PostgreSQL servers';


--
-- Name: get_total_sales(integer); Type: FUNCTION; Schema: dwh; Owner: postgres
--

CREATE FUNCTION dwh.get_total_sales(customer_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
    total_sales INT;
BEGIN
    SELECT COALESCE(SUM(qty), 0) INTO total_sales
    FROM dwh.dwh_fct_sales
    WHERE customer_id = $1;

    RETURN total_sales;
END;
$_$;


ALTER FUNCTION dwh.get_total_sales(customer_id integer) OWNER TO postgres;

--
-- Name: pop_dim_tables(); Type: PROCEDURE; Schema: dwh; Owner: postgres
--

CREATE PROCEDURE dwh.pop_dim_tables()
    LANGUAGE plpgsql
    AS $$
DECLARE
    customer_data RECORD;
    product_group_name VARCHAR(255);
    product_data RECORD;
    all_inserts_succeeded BOOLEAN := TRUE; -- Переменная-флаг для отслеживания успешности всех вставок
BEGIN
    -- Курсор для данных о клиентах
    FOR customer_data IN (SELECT id, "name", country FROM ext.ext_dim_customers) LOOP
        BEGIN
            INSERT INTO dwh.dwh_dim_customers (id, "name", country, created_dt) 
            VALUES (customer_data.id, customer_data."name", customer_data.country, CURRENT_TIMESTAMP)
            ON CONFLICT (id) DO UPDATE 
                SET "name" = EXCLUDED."name", country = EXCLUDED.country, modified_dt = CURRENT_TIMESTAMP
            WHERE 
                dwh.dwh_dim_customers."name" <> EXCLUDED."name" OR dwh.dwh_dim_customers.country <> EXCLUDED.country;
        EXCEPTION
            WHEN OTHERS THEN
                INSERT INTO dwh.error_logs (component, error_timestamp, error_description, layer)
                VALUES ('pop_dim_tables/dwh_dim_customers', CURRENT_TIMESTAMP, sqlerrm,'dwh');
                all_inserts_succeeded := FALSE; -- Устанавливаем флаг в FALSE при возникновении ошибки
                CONTINUE;
        END;
    END LOOP;

    -- Курсор для данных о группах продуктов
    FOR product_group_name IN (SELECT DISTINCT groupname FROM ext.ext_dim_products) LOOP
        BEGIN
            INSERT INTO dwh.dwh_dim_product_groups ("name", created_dt)
            VALUES (product_group_name, CURRENT_TIMESTAMP)
            ON CONFLICT DO NOTHING;
        EXCEPTION
            WHEN OTHERS THEN
                INSERT INTO dwh.error_logs (component, error_timestamp, error_description, layer)
                VALUES ('pop_dim_tables/dwh_dim_product_groups', CURRENT_TIMESTAMP, sqlerrm, 'dwh');
                all_inserts_succeeded := FALSE; -- Устанавливаем флаг в FALSE при возникновении ошибки
                CONTINUE;
        END;
    END LOOP;

    -- Курсор для данных о продуктах
    FOR product_data IN (SELECT p.id, p."name", ddpg.id as product_group_id FROM ext.ext_dim_products p
                         INNER JOIN dwh.dwh_dim_product_groups ddpg ON ddpg."name" = p.groupname) LOOP
        BEGIN
            INSERT INTO dwh.dwh_dim_products (id, "name", product_group_id, created_dt)
            VALUES (product_data.id, product_data."name", product_data.product_group_id, CURRENT_TIMESTAMP)
            ON CONFLICT (id) DO UPDATE 
                SET "name" = EXCLUDED."name", product_group_id = EXCLUDED.product_group_id, modified_dt = CURRENT_TIMESTAMP
            WHERE 
                dwh.dwh_dim_products."name" <> EXCLUDED."name" OR dwh.dwh_dim_products.product_group_id <> EXCLUDED.product_group_id;
        EXCEPTION
            WHEN OTHERS THEN
                INSERT INTO dwh.error_logs (component, error_timestamp, error_description, layer)
                VALUES ('pop_dim_tables/dwh_dim_products', CURRENT_TIMESTAMP, sqlerrm, 'dwh');
                all_inserts_succeeded := FALSE; -- Устанавливаем флаг в FALSE при возникновении ошибки
                CONTINUE;
        END;
    END LOOP;

    -- Вставляем запись в pipelines_logs со статусом "SUCCEED", если все вставки прошли успешно
	IF all_inserts_succeeded THEN
	    INSERT INTO dwh.pipelines_logs (stop_dt, last_layer, status) 
	    VALUES (CURRENT_TIMESTAMP, 'dwh/pop_dim_tables', 'Succeed');
	ELSE
	    INSERT INTO dwh.pipelines_logs (stop_dt, last_layer, status) 
	    VALUES (CURRENT_TIMESTAMP, 'dwh/pop_dim_tables', 'Failed');
	END IF;
END;
$$;


ALTER PROCEDURE dwh.pop_dim_tables() OWNER TO postgres;

--
-- Name: pop_dim_tables_short(); Type: PROCEDURE; Schema: dwh; Owner: postgres
--

CREATE PROCEDURE dwh.pop_dim_tables_short()
    LANGUAGE plpgsql
    AS $$
begin
	---Customers---
    INSERT INTO dwh.dwh_dim_customers (id, "name", country, created_dt) 
    SELECT
        src.id,
        src."name",
        src.country,
        CURRENT_TIMESTAMP
    FROM ext.ext_dim_customers src
    ON CONFLICT (id) 
    DO UPDATE 
        SET "name" = EXCLUDED."name", country = EXCLUDED.country, modified_dt = CURRENT_TIMESTAMP
    WHERE 
        dwh.dwh_dim_customers."name" <> EXCLUDED."name" OR dwh.dwh_dim_customers.country <> EXCLUDED.country;
	---Products groups--- 
    INSERT INTO dwh.dwh_dim_product_groups ("name", created_dt)
    SELECT DISTINCT 
        src.groupname,
        CURRENT_TIMESTAMP
    FROM ext.ext_dim_products src
    ON CONFLICT DO NOTHING;
	---Products--- 
    INSERT INTO dwh.dwh_dim_products (id, "name", product_group_id, created_dt)
    SELECT
        src.id,
        src."name",
        ddpg.id as product_group_id,
        CURRENT_TIMESTAMP
    FROM ext.ext_dim_products src
    INNER JOIN dwh.dwh_dim_product_groups ddpg ON ddpg."name" = src.groupname 
    ON CONFLICT (id) 
    DO UPDATE 
        SET "name" = EXCLUDED."name", product_group_id = EXCLUDED.product_group_id, modified_dt = CURRENT_TIMESTAMP
    WHERE 
        dwh.dwh_dim_products."name" <> EXCLUDED."name" OR dwh.dwh_dim_products.product_group_id <> EXCLUDED.product_group_id;
END;
$$;


ALTER PROCEDURE dwh.pop_dim_tables_short() OWNER TO postgres;

--
-- Name: pop_fct_tables(); Type: PROCEDURE; Schema: dwh; Owner: postgres
--

CREATE PROCEDURE dwh.pop_fct_tables()
    LANGUAGE plpgsql
    AS $$
DECLARE
    sales RECORD;
    all_inserts_succeeded BOOLEAN := TRUE; -- Переменная-флаг для отслеживания успешности всех вставок

BEGIN
    -- Курсор для данных о продуктах
    FOR sales IN (SELECT p.customer_id, p.product_id, p.qty, p.invoice_dt FROM ext.ext_fct_sales p
                         INNER JOIN dwh.dwh_dim_customers ddc on ddc.id = p.customer_id
                         INNER JOIN dwh.dwh_dim_products ddp on ddp.id = p.product_id) LOOP
        BEGIN
			INSERT INTO dwh.dwh_fct_sales (customer_id, product_id, qty, invoice_dt)
            VALUES (sales.customer_id, sales.product_id, sales.qty, sales.invoice_dt)
            ON CONFLICT (customer_id, product_id, qty, invoice_dt) DO NOTHING;
        EXCEPTION
            WHEN OTHERS THEN
                INSERT INTO dwh.error_logs (component, error_timestamp, error_description, layer)
                VALUES ('pop_fct_tables/dwh_fct_sales', CURRENT_TIMESTAMP, sqlerrm, 'dwh/pop_fct_tables');
                all_inserts_succeeded := FALSE; -- Устанавливаем флаг в FALSE при возникновении ошибки
                CONTINUE;
        END;
    END LOOP;
   	IF all_inserts_succeeded THEN
	    INSERT INTO dwh.pipelines_logs (stop_dt, last_layer, status) 
	    VALUES (CURRENT_TIMESTAMP, 'dwh/pop_fct_tables', 'Succeed');
	ELSE
	    INSERT INTO dwh.pipelines_logs (stop_dt, last_layer, status) 
	    VALUES (CURRENT_TIMESTAMP, 'dwh/pop_fct_tables', 'Failed');
	END IF;
END;
$$;


ALTER PROCEDURE dwh.pop_fct_tables() OWNER TO postgres;

--
-- Name: stg_wrapper; Type: SERVER; Schema: -; Owner: postgres
--

CREATE SERVER stg_wrapper FOREIGN DATA WRAPPER postgres_fdw OPTIONS (
    dbname 'stg',
    host 'localhost'
);


ALTER SERVER stg_wrapper OWNER TO postgres;

--
-- Name: USER MAPPING postgres SERVER stg_wrapper; Type: USER MAPPING; Schema: -; Owner: postgres
--

CREATE USER MAPPING FOR postgres SERVER stg_wrapper OPTIONS (
    password 'ASD12asd',
    "user" 'postgres'
);


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: dwh_dim_customers; Type: TABLE; Schema: dwh; Owner: postgres
--

CREATE TABLE dwh.dwh_dim_customers (
    id integer NOT NULL,
    name character varying(255),
    country character varying(100),
    created_dt timestamp without time zone,
    modified_dt timestamp without time zone
);


ALTER TABLE dwh.dwh_dim_customers OWNER TO postgres;

--
-- Name: dwh_dim_date; Type: TABLE; Schema: dwh; Owner: postgres
--

CREATE TABLE dwh.dwh_dim_date (
    id date NOT NULL,
    epoch bigint NOT NULL,
    day_suffix character varying(4) NOT NULL,
    day_name character varying(9) NOT NULL,
    day_of_week integer NOT NULL,
    day_of_month integer NOT NULL,
    day_of_quarter integer NOT NULL,
    day_of_year integer NOT NULL,
    week_of_month integer NOT NULL,
    week_of_year integer NOT NULL,
    week_of_year_iso character(10) NOT NULL,
    month_actual integer NOT NULL,
    month_name character varying(9) NOT NULL,
    month_name_abbreviated character(3) NOT NULL,
    quarter_actual integer NOT NULL,
    quarter_name character varying(9) NOT NULL,
    year_actual integer NOT NULL,
    first_day_of_week date NOT NULL,
    last_day_of_week date NOT NULL,
    first_day_of_month date NOT NULL,
    last_day_of_month date NOT NULL,
    first_day_of_quarter date NOT NULL,
    last_day_of_quarter date NOT NULL,
    first_day_of_year date NOT NULL,
    last_day_of_year date NOT NULL,
    mmyyyy character(6) NOT NULL,
    mmddyyyy character(10) NOT NULL,
    weekend_indr boolean NOT NULL
);


ALTER TABLE dwh.dwh_dim_date OWNER TO postgres;

--
-- Name: dwh_dim_product_groups; Type: TABLE; Schema: dwh; Owner: postgres
--

CREATE TABLE dwh.dwh_dim_product_groups (
    id integer NOT NULL,
    name character varying(255),
    created_dt timestamp without time zone,
    modified_dt timestamp without time zone
);


ALTER TABLE dwh.dwh_dim_product_groups OWNER TO postgres;

--
-- Name: dwh_dim_product_groups_id_seq; Type: SEQUENCE; Schema: dwh; Owner: postgres
--

CREATE SEQUENCE dwh.dwh_dim_product_groups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE dwh.dwh_dim_product_groups_id_seq OWNER TO postgres;

--
-- Name: dwh_dim_product_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: dwh; Owner: postgres
--

ALTER SEQUENCE dwh.dwh_dim_product_groups_id_seq OWNED BY dwh.dwh_dim_product_groups.id;


--
-- Name: dwh_dim_products; Type: TABLE; Schema: dwh; Owner: postgres
--

CREATE TABLE dwh.dwh_dim_products (
    id integer NOT NULL,
    name character varying(255),
    product_group_id integer,
    created_dt timestamp without time zone,
    modified_dt timestamp without time zone
);


ALTER TABLE dwh.dwh_dim_products OWNER TO postgres;

--
-- Name: dwh_fct_sales; Type: TABLE; Schema: dwh; Owner: postgres
--

CREATE TABLE dwh.dwh_fct_sales (
    customer_id integer,
    product_id integer,
    qty integer,
    invoice_dt date
);


ALTER TABLE dwh.dwh_fct_sales OWNER TO postgres;

--
-- Name: error_logs; Type: TABLE; Schema: dwh; Owner: postgres
--

CREATE TABLE dwh.error_logs (
    log_id integer NOT NULL,
    error_timestamp timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    error_description text,
    component character varying,
    layer text
);


ALTER TABLE dwh.error_logs OWNER TO postgres;

--
-- Name: error_logs_log_id_seq; Type: SEQUENCE; Schema: dwh; Owner: postgres
--

CREATE SEQUENCE dwh.error_logs_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE dwh.error_logs_log_id_seq OWNER TO postgres;

--
-- Name: error_logs_log_id_seq; Type: SEQUENCE OWNED BY; Schema: dwh; Owner: postgres
--

ALTER SEQUENCE dwh.error_logs_log_id_seq OWNED BY dwh.error_logs.log_id;


--
-- Name: pipelines_logs; Type: TABLE; Schema: dwh; Owner: postgres
--

CREATE TABLE dwh.pipelines_logs (
    id integer NOT NULL,
    stop_dt timestamp without time zone,
    last_layer text,
    status text
);


ALTER TABLE dwh.pipelines_logs OWNER TO postgres;

--
-- Name: pipelines_logs_id_seq; Type: SEQUENCE; Schema: dwh; Owner: postgres
--

CREATE SEQUENCE dwh.pipelines_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE dwh.pipelines_logs_id_seq OWNER TO postgres;

--
-- Name: pipelines_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: dwh; Owner: postgres
--

ALTER SEQUENCE dwh.pipelines_logs_id_seq OWNED BY dwh.pipelines_logs.id;


--
-- Name: temp_d; Type: TABLE; Schema: dwh; Owner: postgres
--

CREATE TABLE dwh.temp_d (
    stop_dt timestamp without time zone,
    last_layer text,
    status text
);


ALTER TABLE dwh.temp_d OWNER TO postgres;

--
-- Name: ext_dim_customers; Type: FOREIGN TABLE; Schema: ext; Owner: postgres
--

CREATE FOREIGN TABLE ext.ext_dim_customers (
    id integer NOT NULL,
    name character varying(255),
    country character varying(100)
)
SERVER stg_wrapper
OPTIONS (
    schema_name 'stg',
    table_name 'stg_dim_customers'
);


ALTER FOREIGN TABLE ext.ext_dim_customers OWNER TO postgres;

--
-- Name: ext_dim_products; Type: FOREIGN TABLE; Schema: ext; Owner: postgres
--

CREATE FOREIGN TABLE ext.ext_dim_products (
    id integer NOT NULL,
    name character varying(255),
    groupname character varying(100)
)
SERVER stg_wrapper
OPTIONS (
    schema_name 'stg',
    table_name 'stg_dim_products'
);


ALTER FOREIGN TABLE ext.ext_dim_products OWNER TO postgres;

--
-- Name: ext_fct_sales; Type: FOREIGN TABLE; Schema: ext; Owner: postgres
--

CREATE FOREIGN TABLE ext.ext_fct_sales (
    customer_id integer,
    product_id integer,
    qty integer,
    invoice_dt date
)
SERVER stg_wrapper
OPTIONS (
    schema_name 'stg',
    table_name 'stg_fct_sales'
);


ALTER FOREIGN TABLE ext.ext_fct_sales OWNER TO postgres;

--
-- Name: dwh_dim_product_groups id; Type: DEFAULT; Schema: dwh; Owner: postgres
--

ALTER TABLE ONLY dwh.dwh_dim_product_groups ALTER COLUMN id SET DEFAULT nextval('dwh.dwh_dim_product_groups_id_seq'::regclass);


--
-- Name: error_logs log_id; Type: DEFAULT; Schema: dwh; Owner: postgres
--

ALTER TABLE ONLY dwh.error_logs ALTER COLUMN log_id SET DEFAULT nextval('dwh.error_logs_log_id_seq'::regclass);


--
-- Name: pipelines_logs id; Type: DEFAULT; Schema: dwh; Owner: postgres
--

ALTER TABLE ONLY dwh.pipelines_logs ALTER COLUMN id SET DEFAULT nextval('dwh.pipelines_logs_id_seq'::regclass);


--
-- Name: dwh_dim_customers dwh_dim_customers_pk; Type: CONSTRAINT; Schema: dwh; Owner: postgres
--

ALTER TABLE ONLY dwh.dwh_dim_customers
    ADD CONSTRAINT dwh_dim_customers_pk PRIMARY KEY (id);


--
-- Name: dwh_dim_date dwh_dim_date_pk; Type: CONSTRAINT; Schema: dwh; Owner: postgres
--

ALTER TABLE ONLY dwh.dwh_dim_date
    ADD CONSTRAINT dwh_dim_date_pk PRIMARY KEY (id);


--
-- Name: dwh_dim_product_groups dwh_dim_product_groups_pk; Type: CONSTRAINT; Schema: dwh; Owner: postgres
--

ALTER TABLE ONLY dwh.dwh_dim_product_groups
    ADD CONSTRAINT dwh_dim_product_groups_pk PRIMARY KEY (id);


--
-- Name: dwh_dim_product_groups dwh_dim_product_groups_un; Type: CONSTRAINT; Schema: dwh; Owner: postgres
--

ALTER TABLE ONLY dwh.dwh_dim_product_groups
    ADD CONSTRAINT dwh_dim_product_groups_un UNIQUE (name);


--
-- Name: dwh_dim_products dwh_dim_products_pk; Type: CONSTRAINT; Schema: dwh; Owner: postgres
--

ALTER TABLE ONLY dwh.dwh_dim_products
    ADD CONSTRAINT dwh_dim_products_pk PRIMARY KEY (id);


--
-- Name: dwh_fct_sales dwh_fact_sales_un; Type: CONSTRAINT; Schema: dwh; Owner: postgres
--

ALTER TABLE ONLY dwh.dwh_fct_sales
    ADD CONSTRAINT dwh_fact_sales_un UNIQUE (customer_id, product_id, qty, invoice_dt);


--
-- Name: error_logs error_logs_pkey; Type: CONSTRAINT; Schema: dwh; Owner: postgres
--

ALTER TABLE ONLY dwh.error_logs
    ADD CONSTRAINT error_logs_pkey PRIMARY KEY (log_id);


--
-- Name: dwh_dim_products dwh_dim_products_fk; Type: FK CONSTRAINT; Schema: dwh; Owner: postgres
--

ALTER TABLE ONLY dwh.dwh_dim_products
    ADD CONSTRAINT dwh_dim_products_fk FOREIGN KEY (product_group_id) REFERENCES dwh.dwh_dim_product_groups(id);


--
-- Name: dwh_fct_sales dwh_fact_sales_fk; Type: FK CONSTRAINT; Schema: dwh; Owner: postgres
--

ALTER TABLE ONLY dwh.dwh_fct_sales
    ADD CONSTRAINT dwh_fact_sales_fk FOREIGN KEY (customer_id) REFERENCES dwh.dwh_dim_customers(id);


--
-- Name: dwh_fct_sales dwh_fact_sales_fk3; Type: FK CONSTRAINT; Schema: dwh; Owner: postgres
--

ALTER TABLE ONLY dwh.dwh_fct_sales
    ADD CONSTRAINT dwh_fact_sales_fk3 FOREIGN KEY (product_id) REFERENCES dwh.dwh_dim_products(id);


--
-- Name: dwh_fct_sales dwh_fact_sales_fk_2; Type: FK CONSTRAINT; Schema: dwh; Owner: postgres
--

ALTER TABLE ONLY dwh.dwh_fct_sales
    ADD CONSTRAINT dwh_fact_sales_fk_2 FOREIGN KEY (invoice_dt) REFERENCES dwh.dwh_dim_date(id);


--
-- PostgreSQL database dump complete
--

