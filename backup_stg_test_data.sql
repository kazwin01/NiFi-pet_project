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
-- Name: stg; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA stg;


ALTER SCHEMA stg OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: stg_dim_customers; Type: TABLE; Schema: stg; Owner: postgres
--

CREATE TABLE stg.stg_dim_customers (
    id integer NOT NULL,
    name character varying(255),
    country character varying(100)
);


ALTER TABLE stg.stg_dim_customers OWNER TO postgres;

--
-- Name: stg_dim_products; Type: TABLE; Schema: stg; Owner: postgres
--

CREATE TABLE stg.stg_dim_products (
    id integer NOT NULL,
    name character varying(255),
    groupname character varying(100)
);


ALTER TABLE stg.stg_dim_products OWNER TO postgres;

--
-- Name: stg_fct_sales; Type: TABLE; Schema: stg; Owner: postgres
--

CREATE TABLE stg.stg_fct_sales (
    customer_id integer,
    product_id integer,
    qty integer,
    invoice_dt date
);


ALTER TABLE stg.stg_fct_sales OWNER TO postgres;

--
-- Data for Name: stg_dim_customers; Type: TABLE DATA; Schema: stg; Owner: postgres
--

COPY stg.stg_dim_customers (id, name, country) FROM stdin;
1	Customer 1	Country 1
2	Customer 2	Country 6
3	Customer 3	Country 10
4	Amir	Country 8
5	Customer 5	Country 7
6	Customer 6	Country 10
7	Customer 7	Country 5
8	Customer 8	Country 2
9	Customer 9	Country 10
10	Customer 10	Country 9
11	Customer 11	Country 6
12	Customer 12	Country 2
13	Customer 13	Country 2
14	Customer 14	Country 6
15	Customer 15	Country 7
16	Customer 16	Country 6
17	Customer 17	Country 3
18	Customer 18	Country 8
19	Customer 19	Country 1
20	Customer 20	Country 3
21	Customer 21	Country 3
22	Customer 22	Country 4
23	Customer 23	Country 6
24	Customer 24	Country 8
25	Customer 25	Country 1
26	Customer 26	Country 2
27	Customer 27	Country 9
28	Customer 28	Country 4
29	Customer 29	Country 7
30	Customer 30	Country 9
31	Customer 31	Country 5
32	Customer 32	Country 5
33	Customer 33	Country 8
34	Customer 34	Country 9
35	Customer 35	Country 7
36	Customer 36	Country 1
37	Customer 37	Country 8
38	Customer 38	Country 10
39	Customer 39	Country 1
40	Customer 40	Country 3
41	Customer 41	Country 1
42	Customer 42	Country 3
43	Customer 43	Country 2
44	Customer 44	Country 6
45	Customer 45	Country 5
46	Customer 46	Country 9
47	Customer 47	Country 5
48	Customer 48	Country 5
49	Customer 49	Country 3
50	Customer 50	Country 6
\.


--
-- Data for Name: stg_dim_products; Type: TABLE DATA; Schema: stg; Owner: postgres
--

COPY stg.stg_dim_products (id, name, groupname) FROM stdin;
1	Product 1	Group 5
2	Product 2	Group 4
3	Product 3	Group 1
4	Product 4	Group 1
5	Product 5	Group 3
6	Product 6	Group 5
7	Product 7	Group 2
8	Product 8	Group 5
9	Product 9	Group 5
10	Product 10	Group 5
11	Product 11	Group 4
12	Product 12	Group 2
13	Product 13	Group 4
14	Milk	Group 1
15	Product 15	Group 4
16	Product 16	Group 3
17	Product 17	Meat
18	Product 18	Group 3
19	Product 19	Group 1
20	Product 20	Group 1
\.


--
-- Data for Name: stg_fct_sales; Type: TABLE DATA; Schema: stg; Owner: postgres
--

COPY stg.stg_fct_sales (customer_id, product_id, qty, invoice_dt) FROM stdin;
1	1	1	2025-11-25
\.


--
-- PostgreSQL database dump complete
--

