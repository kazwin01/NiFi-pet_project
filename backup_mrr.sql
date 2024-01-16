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
-- Name: mrr; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA mrr;


ALTER SCHEMA mrr OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: mrr_dim_customers; Type: TABLE; Schema: mrr; Owner: postgres
--

CREATE TABLE mrr.mrr_dim_customers (
    id integer NOT NULL,
    name character varying(255),
    country character varying(100)
);


ALTER TABLE mrr.mrr_dim_customers OWNER TO postgres;

--
-- Name: mrr_dim_products; Type: TABLE; Schema: mrr; Owner: postgres
--

CREATE TABLE mrr.mrr_dim_products (
    id integer NOT NULL,
    name character varying(255),
    groupname character varying(100)
);


ALTER TABLE mrr.mrr_dim_products OWNER TO postgres;

--
-- Name: mrr_fct_sales; Type: TABLE; Schema: mrr; Owner: postgres
--

CREATE TABLE mrr.mrr_fct_sales (
    customer_id integer,
    product_id integer,
    qty integer,
    invoice_dt date
);


ALTER TABLE mrr.mrr_fct_sales OWNER TO postgres;

--
-- Name: watermarktable; Type: TABLE; Schema: mrr; Owner: postgres
--

CREATE TABLE mrr.watermarktable (
    table_name character varying(255),
    watermark_value timestamp without time zone
);


ALTER TABLE mrr.watermarktable OWNER TO postgres;

--
-- PostgreSQL database dump complete
--

