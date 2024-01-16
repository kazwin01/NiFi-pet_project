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
-- Data for Name: mrr_dim_customers; Type: TABLE DATA; Schema: mrr; Owner: postgres
--

COPY mrr.mrr_dim_customers (id, name, country) FROM stdin;
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
-- Data for Name: mrr_dim_products; Type: TABLE DATA; Schema: mrr; Owner: postgres
--

COPY mrr.mrr_dim_products (id, name, groupname) FROM stdin;
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
-- Data for Name: mrr_fct_sales; Type: TABLE DATA; Schema: mrr; Owner: postgres
--

COPY mrr.mrr_fct_sales (customer_id, product_id, qty, invoice_dt) FROM stdin;
30	10	9	2023-11-25
23	12	6	2023-02-22
49	2	6	2023-03-19
3	8	5	2023-05-30
29	16	9	2023-03-26
17	16	1	2023-02-03
34	17	5	2023-05-31
26	17	9	2023-06-27
45	1	3	2023-08-18
36	2	6	2023-10-23
1	20	3	2023-03-27
24	13	4	2023-04-25
37	11	2	2023-09-28
9	17	6	2023-05-12
28	11	3	2023-04-18
32	20	6	2023-09-10
1	11	4	2023-12-01
22	15	9	2023-04-05
34	9	3	2023-07-08
46	15	9	2023-04-14
29	8	1	2023-11-01
13	12	8	2023-09-16
47	3	3	2023-05-29
32	4	3	2023-03-26
5	15	2	2023-10-09
16	18	9	2023-01-12
4	5	6	2023-02-04
46	8	8	2023-02-02
5	11	10	2023-04-06
37	16	9	2023-09-27
39	6	8	2023-03-23
1	16	5	2023-04-26
35	8	7	2023-05-29
49	3	1	2023-10-22
46	16	7	2023-09-05
28	9	8	2023-01-27
7	11	5	2023-11-19
18	19	4	2023-02-26
31	3	5	2023-11-19
38	13	10	2023-02-21
33	11	6	2023-01-26
11	20	10	2023-07-15
38	19	7	2024-01-02
17	18	4	2023-07-27
13	13	1	2023-09-19
49	2	6	2024-01-06
5	12	8	2023-02-16
30	1	9	2023-11-10
41	5	4	2023-09-06
27	7	10	2023-10-26
44	20	5	2023-10-08
16	5	5	2023-05-09
3	18	6	2023-08-19
12	17	6	2023-10-12
31	5	9	2023-10-06
9	19	4	2023-09-01
45	1	9	2023-08-17
27	9	10	2023-08-30
18	16	10	2023-06-04
43	9	3	2023-05-16
31	6	3	2023-05-13
5	8	3	2023-07-15
22	20	6	2023-01-21
46	16	9	2023-03-19
28	3	7	2023-08-22
42	7	9	2023-07-16
9	5	1	2023-08-19
23	19	5	2023-02-12
35	5	5	2023-06-11
39	14	6	2023-09-18
2	11	6	2023-05-10
40	4	5	2023-04-13
20	7	6	2023-05-11
30	4	10	2023-12-26
31	13	6	2023-03-03
21	13	7	2023-07-28
32	16	8	2023-08-27
6	2	2	2023-03-02
41	4	6	2023-08-08
5	12	8	2024-01-03
10	14	10	2023-08-12
5	2	3	2023-11-19
20	11	7	2023-12-24
36	3	5	2023-03-15
43	4	6	2023-07-09
4	5	3	2023-06-11
31	13	4	2023-12-07
47	10	4	2023-01-25
3	15	4	2023-08-29
48	16	10	2023-12-28
21	16	7	2023-10-03
42	3	9	2023-07-18
39	4	7	2023-01-27
49	14	1	2023-05-13
45	2	3	2023-03-10
18	14	3	2023-08-27
43	13	9	2023-12-02
41	5	6	2023-11-13
36	3	10	2023-12-30
16	13	1	2024-01-01
45	9	3	2023-08-04
20	15	7	2023-01-27
49	8	6	2023-06-11
7	7	10	2023-04-12
11	17	2	2023-10-29
15	3	2	2023-08-12
6	14	9	2023-09-06
48	1	4	2023-09-09
17	6	1	2023-06-05
37	3	5	2023-01-21
22	2	2	2023-03-14
37	4	2	2023-05-16
5	16	2	2023-05-15
11	15	3	2023-03-05
10	1	8	2024-01-09
7	14	2	2023-03-20
26	15	5	2023-11-20
36	9	4	2023-04-24
13	16	4	2023-07-06
46	9	10	2023-08-30
37	8	10	2023-10-02
16	6	8	2023-05-20
9	4	10	2023-04-09
8	14	9	2023-08-23
24	14	9	2023-09-05
9	7	6	2023-09-06
30	13	8	2023-12-22
25	8	1	2023-11-29
29	15	3	2023-01-18
25	11	6	2023-05-01
11	9	2	2023-02-06
26	12	4	2023-05-27
20	11	6	2023-12-07
32	2	9	2023-06-03
40	17	6	2023-12-12
19	4	6	2023-01-15
43	16	7	2023-11-23
32	17	8	2023-05-23
5	6	1	2023-12-24
4	6	2	2023-03-22
31	10	6	2023-09-16
37	14	7	2023-05-14
45	5	8	2023-01-17
10	5	5	2023-12-18
35	18	2	2023-07-17
43	10	6	2023-02-15
37	4	9	2023-12-30
48	20	3	2023-12-24
15	14	10	2023-10-31
48	2	7	2023-12-28
7	19	3	2023-10-27
13	16	6	2023-08-20
13	6	4	2023-08-22
13	17	3	2023-07-03
17	20	2	2023-10-30
36	5	5	2023-05-28
22	10	7	2023-01-27
18	14	5	2023-02-14
37	6	8	2023-05-13
45	8	3	2023-07-30
26	7	6	2023-07-31
21	10	9	2023-12-09
26	19	10	2023-04-14
34	17	1	2023-12-03
31	13	2	2023-10-23
49	20	1	2023-04-30
20	18	1	2023-03-21
48	2	3	2023-10-16
33	20	1	2023-07-05
32	4	6	2023-09-14
23	1	5	2023-09-25
16	19	1	2023-05-12
11	14	9	2023-11-19
34	13	8	2023-06-12
17	10	3	2023-04-11
23	18	1	2023-01-22
8	9	7	2023-12-26
18	5	5	2023-08-18
43	20	2	2023-01-31
6	6	8	2023-03-15
34	14	2	2023-09-14
41	20	2	2023-03-17
47	19	6	2023-07-25
35	18	6	2023-06-06
17	10	9	2023-04-08
47	8	9	2023-06-15
6	13	2	2023-12-29
10	5	7	2023-10-18
7	12	2	2023-07-23
24	6	10	2023-03-14
31	13	7	2023-04-27
10	5	1	2023-05-19
29	5	2	2023-10-01
18	1	5	2024-01-04
48	5	7	2023-06-06
47	3	1	2023-05-01
7	12	1	2023-12-14
35	12	8	2023-09-16
23	2	5	2023-11-08
48	4	5	2023-03-15
41	10	2	2023-03-18
13	20	1	2023-02-18
10	10	1	2023-11-10
12	4	6	2023-09-16
4	2	9	2023-08-20
33	20	2	2023-12-22
14	4	3	2023-05-08
16	19	1	2023-10-04
19	16	8	2023-01-10
16	9	5	2023-11-17
16	6	1	2023-04-16
15	20	8	2023-06-07
27	5	10	2023-03-27
45	13	3	2023-02-19
47	11	3	2023-06-03
5	15	10	2023-09-15
16	16	6	2023-09-20
16	10	3	2023-07-03
30	18	2	2023-05-07
2	12	7	2023-03-03
20	1	2	2023-08-28
27	19	7	2023-02-18
27	18	4	2023-06-08
11	1	5	2023-07-10
36	4	7	2023-12-27
28	6	1	2023-04-16
12	9	10	2023-12-26
22	16	8	2023-01-12
41	17	5	2023-09-23
39	5	7	2023-04-04
15	7	10	2023-09-22
7	19	4	2023-09-12
5	3	10	2023-12-04
16	4	5	2023-06-14
5	7	10	2023-10-25
11	8	5	2023-05-17
43	19	1	2023-04-20
28	1	9	2023-10-19
40	2	1	2023-04-23
47	15	8	2023-01-28
24	1	7	2023-02-24
16	14	1	2023-06-11
37	3	1	2023-02-07
2	2	5	2023-12-19
8	16	3	2023-05-22
31	13	5	2023-07-19
49	14	1	2023-12-18
17	16	10	2023-12-24
31	4	1	2023-01-10
33	18	8	2023-07-07
49	12	4	2023-11-03
33	17	8	2023-07-30
43	13	7	2023-09-11
11	3	3	2023-04-18
28	18	5	2023-10-22
33	7	2	2023-01-29
14	6	4	2023-11-19
6	14	4	2023-01-29
36	20	8	2023-05-24
29	2	3	2023-12-11
48	5	7	2023-12-10
8	12	10	2023-06-25
21	16	2	2023-07-14
19	11	9	2023-06-26
7	2	4	2023-09-22
27	2	6	2023-08-16
11	9	3	2023-05-13
47	19	2	2023-04-28
50	1	5	2023-12-14
13	16	5	2023-06-05
37	18	4	2023-10-31
12	8	1	2023-05-22
6	15	1	2023-03-24
24	20	4	2023-01-20
1	19	5	2023-10-27
16	7	8	2023-06-07
25	8	5	2023-09-10
47	13	9	2023-08-16
41	13	9	2023-10-10
36	19	3	2023-03-05
50	19	5	2023-02-07
24	17	10	2023-09-19
21	11	6	2023-09-17
17	6	8	2023-08-25
46	18	7	2023-03-10
17	11	1	2024-01-03
2	19	7	2023-01-28
38	3	9	2023-05-13
10	18	6	2023-08-13
9	6	5	2023-03-17
43	12	7	2023-01-29
21	16	3	2024-01-09
39	20	5	2023-09-30
10	11	4	2023-08-24
6	9	1	2023-07-11
43	19	8	2023-03-17
43	17	9	2023-04-04
32	15	6	2023-08-03
48	9	5	2023-06-28
15	5	3	2023-03-27
9	5	6	2023-01-27
4	19	9	2023-05-13
37	14	7	2023-12-30
2	11	2	2023-07-02
23	19	2	2023-12-10
30	11	7	2023-10-05
21	11	6	2023-01-28
14	13	9	2023-01-17
3	9	2	2023-07-16
34	1	7	2023-03-12
26	17	10	2023-07-12
33	19	6	2023-12-05
47	8	8	2023-10-12
16	10	9	2023-05-14
15	5	1	2023-04-20
1	13	9	2023-09-01
29	20	10	2023-11-20
33	3	9	2023-02-19
20	16	3	2023-10-17
4	20	3	2023-07-27
3	9	7	2023-01-17
14	3	6	2023-04-20
8	1	6	2023-03-03
33	17	7	2023-01-17
28	17	5	2023-07-04
14	3	4	2023-03-26
29	9	5	2023-12-08
12	18	5	2023-11-20
20	6	9	2023-09-24
3	3	6	2023-07-04
39	3	8	2023-08-22
44	15	9	2023-02-06
26	2	5	2023-02-08
39	20	5	2023-06-24
36	3	8	2023-10-10
2	8	5	2023-01-24
6	5	1	2023-02-15
6	17	5	2023-12-14
12	19	10	2023-03-12
13	18	4	2023-03-28
2	14	1	2023-08-08
3	7	6	2023-12-02
2	4	1	2023-10-15
22	11	1	2023-09-13
43	14	8	2023-04-04
1	7	5	2023-08-22
42	20	8	2023-04-29
50	20	1	2023-05-22
39	6	3	2023-09-29
1	10	6	2023-01-13
3	3	8	2023-10-04
47	18	2	2023-10-06
31	10	8	2023-09-13
41	10	9	2023-09-21
4	1	3	2023-02-19
5	1	3	2023-06-17
37	19	7	2023-09-14
30	9	6	2023-02-01
24	1	7	2023-02-06
42	12	7	2023-09-12
9	12	1	2023-11-10
38	2	5	2023-05-28
49	18	4	2023-01-31
43	15	9	2023-08-24
10	3	4	2023-05-04
50	20	8	2023-02-18
15	7	3	2023-12-24
37	11	4	2023-07-21
18	3	10	2023-12-23
34	18	3	2023-03-07
5	4	4	2023-03-18
27	14	9	2024-01-05
23	17	4	2023-12-01
29	5	2	2023-07-05
5	15	10	2023-04-21
4	6	5	2023-09-26
25	10	10	2024-01-05
39	3	10	2023-05-30
14	7	1	2023-01-20
32	1	7	2023-05-27
38	3	1	2023-03-30
37	9	6	2023-07-07
8	17	10	2023-01-26
37	11	10	2023-12-08
24	14	6	2023-04-28
20	1	8	2023-07-17
42	13	7	2023-06-26
7	12	9	2023-11-18
8	7	6	2023-10-01
46	15	10	2023-12-12
13	4	6	2023-05-09
11	4	8	2023-02-19
29	19	1	2024-01-03
35	13	9	2023-07-27
22	10	1	2023-10-23
39	11	2	2023-09-10
35	8	10	2023-10-18
15	19	8	2023-09-30
47	18	10	2023-11-07
7	3	1	2023-01-24
14	11	7	2023-09-25
15	10	5	2023-05-19
46	9	9	2023-05-02
20	13	1	2023-02-23
27	16	4	2023-09-08
26	17	9	2023-11-05
44	16	3	2023-12-21
48	9	10	2023-02-05
2	19	10	2023-06-03
21	17	8	2023-07-20
40	18	9	2023-11-18
44	20	8	2023-11-25
28	2	3	2023-07-25
41	18	4	2023-06-07
44	20	4	2023-01-11
9	19	8	2023-09-24
36	3	7	2023-03-25
5	1	9	2023-02-05
4	9	6	2023-07-04
47	14	4	2023-06-08
17	19	1	2023-02-11
43	18	7	2023-08-13
17	13	9	2023-08-19
29	17	4	2023-04-29
8	17	10	2023-07-18
13	5	7	2023-05-30
17	10	3	2023-03-14
14	5	8	2023-03-24
36	3	4	2023-05-15
41	2	7	2023-11-10
46	16	9	2023-02-14
49	3	8	2023-07-11
44	15	8	2023-11-15
22	6	10	2023-04-08
28	9	9	2023-02-04
45	4	2	2023-09-25
32	17	10	2023-10-07
42	20	4	2023-04-28
47	12	3	2023-04-28
28	7	2	2023-03-22
28	8	1	2023-11-01
42	11	1	2023-05-16
1	5	8	2024-01-04
32	14	7	2023-04-22
42	2	10	2023-06-24
40	10	9	2023-05-21
2	2	3	2023-09-08
50	4	2	2023-01-20
25	12	8	2023-08-08
31	5	1	2023-11-21
15	20	10	2023-08-21
17	4	7	2023-07-17
12	10	5	2024-01-06
41	20	5	2023-11-15
38	12	1	2023-05-03
10	9	1	2023-04-05
45	5	10	2023-04-10
22	12	1	2023-08-17
24	8	3	2023-09-29
47	2	2	2023-09-09
46	2	8	2023-10-07
33	1	1	2023-05-04
15	9	8	2023-11-19
48	14	1	2023-10-05
36	3	10	2023-07-04
11	1	2	2023-11-09
39	1	10	2023-07-21
18	1	1	2024-01-01
21	14	1	2023-08-04
15	13	3	2023-04-20
42	18	4	2023-12-12
31	9	10	2023-01-21
27	11	9	2023-10-04
17	19	6	2023-11-18
50	14	2	2023-09-24
16	3	1	2023-09-22
15	19	7	2023-05-09
22	9	3	2023-06-17
17	4	7	2023-08-12
29	12	2	2023-03-05
30	3	2	2023-09-16
6	16	10	2023-02-22
25	13	10	2023-08-03
50	11	9	2023-04-02
7	15	2	2023-04-09
33	20	2	2023-04-07
32	6	2	2023-06-18
39	14	1	2024-01-02
21	9	9	2023-02-11
19	11	7	2023-08-28
3	11	9	2024-01-06
27	11	9	2023-02-16
6	15	8	2023-11-26
7	5	7	2023-06-02
15	6	6	2023-10-04
28	14	7	2023-03-23
22	4	5	2023-08-24
47	2	8	2023-01-25
9	5	2	2023-05-21
10	13	9	2023-01-27
26	1	4	2023-03-10
12	11	7	2023-01-25
45	1	5	2023-09-06
37	13	8	2023-02-20
25	19	6	2023-09-30
40	10	9	2023-01-11
17	8	3	2023-04-19
15	20	2	2023-07-21
29	2	8	2023-10-30
42	11	2	2023-08-14
26	20	2	2023-07-11
25	8	3	2023-12-05
9	16	7	2023-06-09
29	7	10	2023-02-17
37	18	8	2023-05-06
9	13	4	2023-07-01
49	6	4	2023-05-13
35	14	6	2023-01-21
16	7	8	2023-05-31
34	6	5	2023-01-10
44	1	8	2023-04-19
28	8	2	2023-12-02
35	8	10	2023-06-06
5	1	8	2023-05-01
30	18	9	2023-09-01
9	19	7	2023-12-15
15	1	9	2023-01-15
30	11	4	2023-10-19
42	14	5	2023-01-22
8	10	2	2023-11-21
33	5	7	2023-01-18
29	7	8	2023-07-22
47	8	5	2023-05-04
41	6	5	2023-01-24
12	2	5	2023-09-08
50	11	7	2023-09-20
42	12	5	2023-04-29
44	13	3	2023-01-26
1	6	5	2023-12-06
26	4	5	2023-05-08
20	14	4	2023-05-17
27	10	1	2023-12-14
18	16	7	2023-11-24
40	10	2	2023-03-18
11	16	3	2023-08-21
12	14	4	2023-08-30
32	8	10	2023-12-06
46	12	1	2023-05-22
4	6	4	2023-12-09
41	15	1	2023-06-08
29	12	3	2023-09-26
12	14	4	2023-01-26
42	5	7	2023-12-18
26	2	3	2023-05-15
9	15	3	2023-09-25
36	6	6	2023-10-30
13	19	5	2023-11-28
33	8	10	2023-05-25
21	11	9	2023-10-10
45	20	4	2023-04-12
18	7	3	2023-06-07
32	20	3	2023-09-02
23	11	6	2023-04-24
46	6	7	2023-09-28
18	13	4	2023-12-16
19	20	8	2023-07-17
25	17	5	2023-04-10
10	10	8	2023-11-09
28	15	8	2023-01-11
34	3	4	2023-02-23
9	11	9	2023-10-01
28	16	6	2023-11-19
43	19	2	2023-06-07
7	4	10	2023-11-22
45	6	8	2023-06-03
8	14	4	2023-07-06
30	6	5	2023-10-26
15	5	6	2023-06-04
27	9	8	2023-09-06
21	1	6	2023-01-23
18	8	6	2023-12-25
21	1	6	2023-07-19
26	11	9	2023-01-31
9	17	1	2023-05-26
1	12	6	2023-07-15
8	12	7	2023-03-13
35	2	3	2023-08-21
47	9	4	2023-11-06
23	7	6	2023-12-04
23	2	9	2023-08-11
49	12	3	2023-06-12
15	11	3	2023-12-05
37	14	4	2023-08-26
27	17	5	2023-03-04
22	9	3	2023-04-10
31	17	6	2023-03-30
26	4	3	2023-10-21
28	20	7	2023-08-27
22	17	1	2023-03-05
27	13	9	2023-02-13
3	1	7	2023-09-24
31	1	1	2023-10-21
16	11	8	2023-11-09
31	4	10	2023-08-04
16	19	6	2023-09-12
23	18	4	2023-06-25
46	10	4	2023-10-17
23	15	7	2023-07-09
6	15	1	2023-01-15
18	19	6	2023-06-16
8	15	2	2023-09-27
6	8	2	2023-10-23
3	8	3	2023-08-19
35	1	8	2023-02-28
50	7	7	2023-07-07
32	3	1	2023-12-29
43	2	4	2023-06-08
49	4	2	2023-06-08
7	20	1	2023-03-01
22	1	1	2023-04-10
46	2	6	2023-05-01
32	11	5	2023-03-13
1	16	6	2023-12-31
46	4	7	2023-11-21
46	12	5	2023-05-06
8	18	5	2023-09-30
48	6	9	2023-05-25
42	12	7	2023-12-04
47	19	8	2023-06-01
43	20	6	2023-02-27
18	3	7	2023-12-05
32	14	9	2023-03-19
19	7	5	2024-01-06
6	5	3	2023-12-11
42	20	10	2023-02-09
6	5	1	2023-11-28
3	20	10	2023-12-24
48	6	10	2023-12-19
46	2	7	2023-04-03
29	6	1	2023-03-12
36	15	10	2024-01-03
46	2	3	2023-01-27
16	15	2	2023-03-11
4	14	2	2023-02-04
44	10	2	2023-01-31
11	10	9	2023-09-19
13	16	8	2023-10-17
28	5	6	2023-11-05
28	6	5	2023-10-13
48	10	4	2024-01-09
10	16	3	2023-02-05
11	11	9	2023-06-22
30	17	4	2023-11-04
40	10	4	2023-01-28
8	14	1	2023-08-14
27	18	3	2024-01-09
43	1	6	2023-07-28
46	7	8	2023-04-02
31	9	8	2023-08-07
45	8	9	2023-09-21
38	13	2	2023-02-05
3	15	1	2023-02-17
12	3	3	2023-09-15
38	7	5	2023-05-24
44	17	7	2023-05-23
17	5	10	2023-02-04
27	11	8	2023-01-23
33	6	8	2023-02-04
19	14	6	2023-03-30
19	4	2	2023-08-31
9	2	6	2023-10-23
6	8	1	2023-12-09
13	5	9	2023-03-05
8	16	8	2023-12-24
41	2	2	2023-04-15
29	8	8	2023-08-07
10	9	8	2023-03-07
32	11	8	2023-12-02
24	6	4	2023-09-21
39	3	7	2023-06-24
40	2	10	2023-08-18
37	1	5	2023-02-11
25	2	7	2023-10-30
9	8	3	2023-05-18
19	12	9	2023-02-04
8	8	1	2023-11-03
34	6	6	2023-08-11
25	20	10	2023-11-17
26	5	4	2023-06-26
39	16	1	2023-12-22
34	7	6	2023-02-08
18	7	9	2023-08-10
40	9	7	2023-05-20
42	3	6	2023-07-28
35	3	5	2023-09-10
41	9	2	2023-03-19
26	19	9	2023-09-20
21	17	9	2023-05-01
19	5	4	2023-03-01
21	11	3	2023-11-17
18	6	10	2023-02-09
5	9	8	2023-02-09
24	4	10	2023-04-16
31	2	3	2023-10-24
25	1	10	2023-11-10
29	8	7	2023-01-12
18	14	1	2023-01-24
22	2	2	2023-03-12
45	3	2	2023-07-27
17	5	9	2023-12-12
20	12	8	2023-10-21
36	18	2	2023-04-16
31	11	2	2023-06-04
16	7	3	2023-11-11
1	19	8	2023-01-30
2	1	1	2023-06-17
24	2	3	2023-11-20
10	1	8	2023-05-27
24	15	4	2023-11-02
33	17	1	2023-08-23
41	11	3	2023-03-31
19	17	10	2023-03-24
6	12	6	2023-07-17
42	18	1	2024-01-01
39	12	7	2023-03-25
40	6	8	2023-03-30
30	1	10	2023-04-28
19	5	3	2023-03-14
20	4	3	2023-07-29
5	12	7	2023-12-10
10	6	1	2023-03-24
37	15	9	2023-03-06
32	18	1	2023-01-17
50	12	9	2023-09-16
45	1	6	2023-08-14
5	19	8	2023-12-09
2	17	7	2023-10-20
17	13	8	2023-08-21
4	15	7	2023-06-28
47	8	1	2023-12-16
37	19	7	2023-03-23
22	4	3	2023-06-16
28	12	3	2023-06-07
44	3	3	2023-05-18
50	5	8	2023-10-26
10	20	1	2023-05-25
19	10	1	2023-07-07
3	9	6	2023-11-04
50	14	7	2023-03-05
13	3	8	2023-10-29
33	3	3	2023-08-24
1	12	6	2023-05-04
50	4	8	2023-12-16
46	20	3	2023-01-17
36	18	2	2023-02-23
3	18	2	2023-03-16
17	6	1	2023-03-26
35	2	5	2023-06-11
29	6	3	2023-09-14
36	6	8	2023-06-10
15	15	4	2023-03-28
32	4	5	2023-02-23
28	3	4	2024-01-07
23	16	6	2023-03-15
8	15	2	2023-12-18
22	18	1	2023-08-06
37	15	9	2023-11-09
5	4	4	2023-04-22
44	19	8	2023-04-27
30	6	4	2023-10-08
34	5	8	2023-10-14
1	3	6	2023-07-03
44	20	6	2023-05-08
40	4	7	2023-07-05
39	9	5	2023-05-16
35	5	5	2023-11-12
32	14	6	2023-02-19
44	7	2	2023-02-28
44	20	4	2023-09-07
38	9	2	2023-08-02
41	14	4	2023-09-09
15	9	3	2023-08-26
13	17	4	2023-03-13
46	20	8	2023-01-14
21	3	5	2023-06-19
26	10	9	2023-08-30
30	2	10	2023-10-11
5	15	4	2023-10-15
8	5	5	2023-04-21
42	6	3	2024-01-03
21	7	8	2023-06-24
38	3	7	2023-05-19
12	13	1	2023-03-07
21	15	3	2023-11-27
30	6	8	2023-08-14
40	2	5	2023-04-27
49	19	3	2023-03-14
23	16	1	2023-06-17
27	15	7	2023-08-15
6	15	7	2023-07-04
39	5	9	2023-04-13
10	19	8	2023-01-23
50	5	8	2023-07-30
43	10	8	2023-04-01
22	1	6	2023-06-04
16	13	7	2023-03-23
47	1	6	2023-02-19
15	9	10	2023-09-03
11	6	7	2023-04-15
4	4	6	2023-05-05
20	1	10	2023-01-22
38	15	6	2023-12-22
19	18	4	2023-11-28
16	7	8	2023-06-10
44	16	7	2023-03-09
20	7	2	2023-05-20
48	14	9	2023-08-26
6	4	6	2023-10-31
36	9	1	2023-11-02
42	16	10	2023-12-28
50	4	10	2023-04-13
25	1	1	2023-06-18
3	10	5	2023-12-04
22	3	5	2023-12-29
10	4	5	2023-03-02
32	5	4	2023-05-28
18	7	3	2023-11-04
40	9	2	2023-05-23
13	12	4	2023-03-18
30	9	5	2023-03-03
5	4	9	2023-02-23
49	17	10	2023-09-06
21	5	2	2023-12-14
25	7	6	2023-12-21
20	10	8	2023-01-13
38	2	7	2023-12-01
7	4	7	2023-03-27
8	16	7	2023-07-14
39	19	7	2023-08-06
33	20	2	2023-08-15
25	5	8	2023-07-30
36	13	6	2023-09-06
32	4	2	2023-11-02
23	16	10	2023-07-18
30	5	1	2023-05-17
36	8	3	2023-12-24
19	20	7	2023-08-30
33	5	9	2023-12-08
23	8	5	2023-04-25
23	17	5	2023-04-01
38	8	9	2023-07-04
1	3	7	2023-04-29
43	2	1	2023-08-10
29	2	10	2023-11-30
17	20	9	2023-03-15
46	10	9	2023-11-30
35	9	3	2023-12-15
4	9	10	2023-05-12
41	13	4	2023-06-03
12	1	9	2023-08-24
48	20	2	2023-08-26
20	15	7	2023-11-08
3	10	10	2023-03-28
40	4	8	2023-11-11
11	10	5	2023-05-19
45	4	5	2023-02-18
11	4	10	2023-04-02
7	19	3	2023-04-08
42	5	5	2023-09-12
5	8	3	2023-04-02
20	5	8	2023-02-10
18	7	2	2023-11-19
8	1	7	2023-11-22
6	17	1	2024-01-01
22	5	1	2023-10-05
17	9	2	2023-03-22
12	5	8	2023-11-28
2	1	1	2023-03-19
16	16	4	2023-04-27
12	5	4	2023-03-24
1	8	2	2023-02-14
13	12	8	2023-10-01
29	20	6	2023-08-06
7	19	3	2023-11-29
44	19	4	2023-11-23
49	16	8	2023-02-06
18	11	4	2023-12-01
12	11	3	2023-08-10
17	20	9	2023-05-27
11	10	1	2023-02-10
45	17	5	2023-04-15
37	2	1	2023-06-03
9	18	7	2023-01-29
50	1	6	2023-07-15
12	20	8	2023-09-26
31	2	2	2023-08-11
45	6	1	2023-09-19
14	14	6	2023-08-24
28	19	9	2023-09-13
24	18	2	2023-10-02
48	2	7	2023-11-01
30	16	9	2023-03-23
27	12	6	2023-07-05
21	13	3	2023-09-10
6	17	2	2023-12-13
27	7	2	2023-10-02
44	8	2	2023-05-05
22	17	5	2024-01-02
39	5	6	2023-04-29
22	3	10	2023-03-01
34	5	4	2023-03-07
31	9	9	2023-12-16
43	1	6	2023-06-09
34	4	4	2023-01-16
15	17	7	2023-12-11
49	15	3	2023-10-18
7	5	9	2023-11-02
6	5	4	2023-11-26
37	7	4	2023-11-07
13	8	9	2023-07-05
16	15	7	2023-09-12
28	7	10	2023-04-14
38	16	7	2023-09-20
24	20	1	2023-12-03
11	2	1	2023-03-03
7	20	2	2023-05-04
42	16	8	2023-02-13
33	13	2	2023-10-04
1	4	5	2023-08-17
4	8	3	2023-05-22
15	9	1	2023-10-25
23	15	9	2023-11-17
29	11	6	2023-03-26
34	9	7	2023-08-05
25	17	9	2023-01-20
12	9	8	2023-05-14
27	7	10	2023-10-18
7	4	5	2023-06-16
50	20	1	2023-10-31
17	11	5	2023-10-26
31	10	1	2023-12-06
41	13	4	2023-04-10
9	13	8	2023-04-19
41	8	4	2023-09-26
40	15	2	2023-06-13
34	8	8	2023-03-07
27	2	6	2023-03-12
22	1	4	2023-12-05
21	15	5	2023-08-14
8	20	3	2023-11-20
12	16	7	2023-01-15
20	13	3	2023-12-11
4	15	8	2023-04-27
14	5	5	2023-01-22
42	14	10	2023-07-26
46	4	10	2023-02-16
29	12	1	2023-07-08
35	14	1	2023-07-15
16	18	4	2023-12-10
17	12	8	2023-01-18
17	2	8	2023-12-05
35	6	5	2023-05-24
45	14	3	2023-06-13
20	1	10	2023-01-19
34	7	2	2024-01-09
49	8	2	2023-10-31
19	1	9	2023-04-11
45	11	8	2023-09-21
42	15	8	2023-10-17
40	5	1	2023-04-25
31	14	2	2023-02-16
6	15	8	2023-08-30
48	17	4	2023-10-07
3	6	1	2023-02-05
20	19	1	2023-06-04
1	5	5	2023-09-24
26	16	1	2023-09-26
13	9	2	2023-03-02
21	14	7	2023-12-03
17	12	8	2023-03-14
1	1	5	2023-06-05
27	17	9	2023-07-29
49	3	4	2023-02-12
33	1	1	2023-03-27
25	8	3	2023-09-22
20	9	10	2023-02-08
32	15	3	2023-04-16
22	20	4	2023-03-07
10	6	10	2023-06-09
7	15	8	2024-01-06
12	9	3	2023-10-13
1	13	9	2023-08-05
28	10	9	2023-04-03
19	8	3	2024-01-09
13	8	6	2023-06-23
19	15	1	2023-10-10
16	11	5	2023-04-09
36	14	7	2023-02-27
14	4	7	2023-06-21
17	4	10	2023-12-05
1	1	1	2025-11-25
\.


--
-- Data for Name: watermarktable; Type: TABLE DATA; Schema: mrr; Owner: postgres
--

COPY mrr.watermarktable (table_name, watermark_value) FROM stdin;
customers	2010-01-01 00:00:00
products	2010-01-01 00:00:00
sales	2025-11-25 00:00:00
\.


--
-- PostgreSQL database dump complete
--

