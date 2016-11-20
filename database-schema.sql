--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.1
-- Dumped by pg_dump version 9.6.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

DROP DATABASE canadiansatwar;
--
-- Name: canadiansatwar; Type: DATABASE; Schema: -; Owner: nicolas
--

CREATE DATABASE canadiansatwar WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.UTF-8' LC_CTYPE = 'en_US.UTF-8';


ALTER DATABASE canadiansatwar OWNER TO nicolas;

\connect canadiansatwar

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: fuzzystrmatch; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS fuzzystrmatch WITH SCHEMA public;


--
-- Name: EXTENSION fuzzystrmatch; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION fuzzystrmatch IS 'determine similarities and distance between strings';


SET search_path = public, pg_catalog;

--
-- Name: cef_enlistees; Type: TABLE; Schema: public; Owner: nicolas
--

CREATE TABLE cef_enlistees (
    id integer NOT NULL,
    reference_en text,
    reference_fr text,
    document_number character varying(12),
    given_name text,
    surname text,
    dataset_id integer
);


ALTER TABLE cef_enlistees OWNER TO nicolas;

--
-- Name: COLUMN cef_enlistees.dataset_id; Type: COMMENT; Schema: public; Owner: nicolas
--

COMMENT ON COLUMN cef_enlistees.dataset_id IS 'ID in the original dataset';


--
-- Name: cef_enlistees_birth_dates; Type: TABLE; Schema: public; Owner: nicolas
--

CREATE TABLE cef_enlistees_birth_dates (
    id integer NOT NULL,
    cef_enlistees_id integer,
    raw_date text,
    year smallint,
    month smallint,
    day smallint
);


ALTER TABLE cef_enlistees_birth_dates OWNER TO nicolas;

--
-- Name: cef_enlistees_birth_dates_id_seq; Type: SEQUENCE; Schema: public; Owner: nicolas
--

CREATE SEQUENCE cef_enlistees_birth_dates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE cef_enlistees_birth_dates_id_seq OWNER TO nicolas;

--
-- Name: cef_enlistees_birth_dates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nicolas
--

ALTER SEQUENCE cef_enlistees_birth_dates_id_seq OWNED BY cef_enlistees_birth_dates.id;


--
-- Name: cef_enlistees_images; Type: TABLE; Schema: public; Owner: nicolas
--

CREATE TABLE cef_enlistees_images (
    id integer NOT NULL,
    cef_enlistees_id integer,
    url text
);


ALTER TABLE cef_enlistees_images OWNER TO nicolas;

--
-- Name: cef_enlistees_images_id_seq; Type: SEQUENCE; Schema: public; Owner: nicolas
--

CREATE SEQUENCE cef_enlistees_images_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE cef_enlistees_images_id_seq OWNER TO nicolas;

--
-- Name: cef_enlistees_images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nicolas
--

ALTER SEQUENCE cef_enlistees_images_id_seq OWNED BY cef_enlistees_images.id;


--
-- Name: cef_enlistees_regimental_numbers; Type: TABLE; Schema: public; Owner: nicolas
--

CREATE TABLE cef_enlistees_regimental_numbers (
    id integer NOT NULL,
    cef_enlistees_id integer,
    regimental_number character varying(30)
);


ALTER TABLE cef_enlistees_regimental_numbers OWNER TO nicolas;

--
-- Name: cef_enlistees_regimental_numbers_id_seq; Type: SEQUENCE; Schema: public; Owner: nicolas
--

CREATE SEQUENCE cef_enlistees_regimental_numbers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE cef_enlistees_regimental_numbers_id_seq OWNER TO nicolas;

--
-- Name: cef_enlistees_regimental_numbers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nicolas
--

ALTER SEQUENCE cef_enlistees_regimental_numbers_id_seq OWNED BY cef_enlistees_regimental_numbers.id;


--
-- Name: people; Type: TABLE; Schema: public; Owner: nicolas
--

CREATE TABLE people (
    id integer NOT NULL,
    cef_enlistees_id integer,
    war_graves_id integer
);


ALTER TABLE people OWNER TO nicolas;

--
-- Name: people_id_seq; Type: SEQUENCE; Schema: public; Owner: nicolas
--

CREATE SEQUENCE people_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE people_id_seq OWNER TO nicolas;

--
-- Name: people_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nicolas
--

ALTER SEQUENCE people_id_seq OWNED BY cef_enlistees.id;


--
-- Name: people_id_seq1; Type: SEQUENCE; Schema: public; Owner: nicolas
--

CREATE SEQUENCE people_id_seq1
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE people_id_seq1 OWNER TO nicolas;

--
-- Name: people_id_seq1; Type: SEQUENCE OWNED BY; Schema: public; Owner: nicolas
--

ALTER SEQUENCE people_id_seq1 OWNED BY people.id;


--
-- Name: war_graves; Type: TABLE; Schema: public; Owner: nicolas
--

CREATE TABLE war_graves (
    surname text NOT NULL,
    given_name text,
    initials character varying(10),
    honours_awards text,
    rank text,
    regiment text,
    unitshipsquadron text,
    country text,
    servicenumberexport character varying(12),
    cemeterymemorial text,
    gravereference text,
    additional_info text,
    id integer NOT NULL,
    date_of_death1 date,
    date_of_death2 date,
    age smallint
);


ALTER TABLE war_graves OWNER TO nicolas;

--
-- Name: war_graves_id_seq; Type: SEQUENCE; Schema: public; Owner: nicolas
--

CREATE SEQUENCE war_graves_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE war_graves_id_seq OWNER TO nicolas;

--
-- Name: war_graves_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nicolas
--

ALTER SEQUENCE war_graves_id_seq OWNED BY war_graves.id;


--
-- Name: cef_enlistees id; Type: DEFAULT; Schema: public; Owner: nicolas
--

ALTER TABLE ONLY cef_enlistees ALTER COLUMN id SET DEFAULT nextval('people_id_seq'::regclass);


--
-- Name: cef_enlistees_birth_dates id; Type: DEFAULT; Schema: public; Owner: nicolas
--

ALTER TABLE ONLY cef_enlistees_birth_dates ALTER COLUMN id SET DEFAULT nextval('cef_enlistees_birth_dates_id_seq'::regclass);


--
-- Name: cef_enlistees_images id; Type: DEFAULT; Schema: public; Owner: nicolas
--

ALTER TABLE ONLY cef_enlistees_images ALTER COLUMN id SET DEFAULT nextval('cef_enlistees_images_id_seq'::regclass);


--
-- Name: cef_enlistees_regimental_numbers id; Type: DEFAULT; Schema: public; Owner: nicolas
--

ALTER TABLE ONLY cef_enlistees_regimental_numbers ALTER COLUMN id SET DEFAULT nextval('cef_enlistees_regimental_numbers_id_seq'::regclass);


--
-- Name: people id; Type: DEFAULT; Schema: public; Owner: nicolas
--

ALTER TABLE ONLY people ALTER COLUMN id SET DEFAULT nextval('people_id_seq1'::regclass);


--
-- Name: war_graves id; Type: DEFAULT; Schema: public; Owner: nicolas
--

ALTER TABLE ONLY war_graves ALTER COLUMN id SET DEFAULT nextval('war_graves_id_seq'::regclass);


--
-- Name: cef_enlistees_birth_dates cef_enlistees_birth_dates_pkey; Type: CONSTRAINT; Schema: public; Owner: nicolas
--

ALTER TABLE ONLY cef_enlistees_birth_dates
    ADD CONSTRAINT cef_enlistees_birth_dates_pkey PRIMARY KEY (id);


--
-- Name: cef_enlistees_images cef_enlistees_images_pkey; Type: CONSTRAINT; Schema: public; Owner: nicolas
--

ALTER TABLE ONLY cef_enlistees_images
    ADD CONSTRAINT cef_enlistees_images_pkey PRIMARY KEY (id);


--
-- Name: cef_enlistees_regimental_numbers cef_enlistees_regimental_numbers_pkey; Type: CONSTRAINT; Schema: public; Owner: nicolas
--

ALTER TABLE ONLY cef_enlistees_regimental_numbers
    ADD CONSTRAINT cef_enlistees_regimental_numbers_pkey PRIMARY KEY (id);


--
-- Name: cef_enlistees people_pkey; Type: CONSTRAINT; Schema: public; Owner: nicolas
--

ALTER TABLE ONLY cef_enlistees
    ADD CONSTRAINT people_pkey PRIMARY KEY (id);


--
-- Name: people people_pkey1; Type: CONSTRAINT; Schema: public; Owner: nicolas
--

ALTER TABLE ONLY people
    ADD CONSTRAINT people_pkey1 PRIMARY KEY (id);


--
-- Name: war_graves war_graves_pkey; Type: CONSTRAINT; Schema: public; Owner: nicolas
--

ALTER TABLE ONLY war_graves
    ADD CONSTRAINT war_graves_pkey PRIMARY KEY (id);


--
-- Name: people cef_enlistees_id; Type: FK CONSTRAINT; Schema: public; Owner: nicolas
--

ALTER TABLE ONLY people
    ADD CONSTRAINT cef_enlistees_id FOREIGN KEY (cef_enlistees_id) REFERENCES cef_enlistees(id) ON DELETE SET NULL;


--
-- Name: cef_enlistees_birth_dates cef_enlistees_id; Type: FK CONSTRAINT; Schema: public; Owner: nicolas
--

ALTER TABLE ONLY cef_enlistees_birth_dates
    ADD CONSTRAINT cef_enlistees_id FOREIGN KEY (cef_enlistees_id) REFERENCES cef_enlistees(id) ON DELETE CASCADE;


--
-- Name: cef_enlistees_images cef_enlistees_id; Type: FK CONSTRAINT; Schema: public; Owner: nicolas
--

ALTER TABLE ONLY cef_enlistees_images
    ADD CONSTRAINT cef_enlistees_id FOREIGN KEY (cef_enlistees_id) REFERENCES cef_enlistees(id) ON DELETE CASCADE;

--
-- Name: cef_enlistees_regimental_numbers cef_enlistees_id; Type: FK CONSTRAINT; Schema: public; Owner: nicolas
--

ALTER TABLE ONLY cef_enlistees_regimental_numbers
    ADD CONSTRAINT cef_enlistees_id FOREIGN KEY (cef_enlistees_id) REFERENCES cef_enlistees(id) ON DELETE CASCADE;


--
-- Name: people war_graves_id; Type: FK CONSTRAINT; Schema: public; Owner: nicolas
--

ALTER TABLE ONLY people
    ADD CONSTRAINT war_graves_id FOREIGN KEY (war_graves_id) REFERENCES war_graves(id) ON DELETE SET NULL;


--
-- PostgreSQL database dump complete
--

