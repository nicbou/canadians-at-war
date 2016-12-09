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

DROP DATABASE IF EXISTS canadiansatwar;
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

SET default_tablespace = '';

SET default_with_oids = false;

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
-- Name: cemeteries; Type: TABLE; Schema: public; Owner: nicolas
--

CREATE TABLE cemeteries (
    id integer NOT NULL,
    name text,
    country character varying(90),
    locality character varying(90),
    casualties_ww1 integer,
    casualties_ww2 integer,
    casualties_total integer,
    dataset_id integer,
    microsite_url text,
    type character varying(100),
    latitude real,
    longitude real,
    location_information text,
    visiting_information text,
    historical_information text
);


ALTER TABLE cemeteries OWNER TO nicolas;

--
-- Name: cemeteries_id_seq; Type: SEQUENCE; Schema: public; Owner: nicolas
--

CREATE SEQUENCE cemeteries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE cemeteries_id_seq OWNER TO nicolas;

--
-- Name: cemeteries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nicolas
--

ALTER SEQUENCE cemeteries_id_seq OWNED BY cemeteries.id;


--
-- Name: cvwm_cemetery_localities; Type: TABLE; Schema: public; Owner: nicolas
--

CREATE TABLE cvwm_cemetery_localities (
    id integer NOT NULL,
    name text
);


ALTER TABLE cvwm_cemetery_localities OWNER TO nicolas;

--
-- Name: cvwm_cemetery_localities_id_seq; Type: SEQUENCE; Schema: public; Owner: nicolas
--

CREATE SEQUENCE cvwm_cemetery_localities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE cvwm_cemetery_localities_id_seq OWNER TO nicolas;

--
-- Name: cvwm_cemetery_localities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nicolas
--

ALTER SEQUENCE cvwm_cemetery_localities_id_seq OWNED BY cvwm_cemetery_localities.id;


--
-- Name: cvwm_countries; Type: TABLE; Schema: public; Owner: nicolas
--

CREATE TABLE cvwm_countries (
    id integer NOT NULL,
    name text
);


ALTER TABLE cvwm_countries OWNER TO nicolas;

--
-- Name: cvwm_countries_id_seq; Type: SEQUENCE; Schema: public; Owner: nicolas
--

CREATE SEQUENCE cvwm_countries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE cvwm_countries_id_seq OWNER TO nicolas;

--
-- Name: cvwm_countries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nicolas
--

ALTER SEQUENCE cvwm_countries_id_seq OWNED BY cvwm_countries.id;


--
-- Name: cvwm_forces; Type: TABLE; Schema: public; Owner: nicolas
--

CREATE TABLE cvwm_forces (
    id integer NOT NULL,
    name text
);


ALTER TABLE cvwm_forces OWNER TO nicolas;

--
-- Name: cvwm_forces_id_seq; Type: SEQUENCE; Schema: public; Owner: nicolas
--

CREATE SEQUENCE cvwm_forces_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE cvwm_forces_id_seq OWNER TO nicolas;

--
-- Name: cvwm_forces_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nicolas
--

ALTER SEQUENCE cvwm_forces_id_seq OWNED BY cvwm_forces.id;


--
-- Name: cvwm_ranks; Type: TABLE; Schema: public; Owner: nicolas
--

CREATE TABLE cvwm_ranks (
    id integer NOT NULL,
    name text
);


ALTER TABLE cvwm_ranks OWNER TO nicolas;

--
-- Name: cvwm_ranks_id_seq; Type: SEQUENCE; Schema: public; Owner: nicolas
--

CREATE SEQUENCE cvwm_ranks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE cvwm_ranks_id_seq OWNER TO nicolas;

--
-- Name: cvwm_ranks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nicolas
--

ALTER SEQUENCE cvwm_ranks_id_seq OWNED BY cvwm_ranks.id;


--
-- Name: cvwm_regiments; Type: TABLE; Schema: public; Owner: nicolas
--

CREATE TABLE cvwm_regiments (
    id integer NOT NULL,
    name text
);


ALTER TABLE cvwm_regiments OWNER TO nicolas;

--
-- Name: cvwm_regiments_id_seq; Type: SEQUENCE; Schema: public; Owner: nicolas
--

CREATE SEQUENCE cvwm_regiments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE cvwm_regiments_id_seq OWNER TO nicolas;

--
-- Name: cvwm_regiments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nicolas
--

ALTER SEQUENCE cvwm_regiments_id_seq OWNED BY cvwm_regiments.id;


--
-- Name: cvwm_war_dead; Type: TABLE; Schema: public; Owner: nicolas
--

CREATE TABLE cvwm_war_dead (
    id integer NOT NULL,
    additional_information text,
    birth_date_year smallint,
    birth_date_month smallint,
    birth_date_day smallint,
    birth_place character varying(100),
    birth_province character(2),
    book_of_rememberence_page character varying(30),
    casualty_type_id integer,
    dataset_id integer,
    citation_text text,
    country_id integer,
    death_age smallint,
    death_date_year text,
    death_date_month text,
    death_date_day text,
    death_country_id integer,
    death_place character varying(100),
    death_province character(2),
    enlistment_date date,
    enlistment_date_year smallint,
    enlistment_date_month smallint,
    enlistment_date_day smallint,
    enlistment_place character varying(100),
    enlistment_province character(2),
    enlistment_country_id integer,
    force_id integer,
    given_name text,
    surname text,
    image_cemetery_plan text,
    initials character varying(20),
    rank_id integer,
    regiment_id integer,
    regimental_number character varying(30),
    unit_text text,
    war_graves_id integer,
    birth_country_id integer,
    cemetery_localities_id integer
);


ALTER TABLE cvwm_war_dead OWNER TO nicolas;

--
-- Name: cvwm_war_dead_id_seq; Type: SEQUENCE; Schema: public; Owner: nicolas
--

CREATE SEQUENCE cvwm_war_dead_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE cvwm_war_dead_id_seq OWNER TO nicolas;

--
-- Name: cvwm_war_dead_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nicolas
--

ALTER SEQUENCE cvwm_war_dead_id_seq OWNED BY cvwm_war_dead.id;


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
    gravereference text,
    additional_info text,
    id integer NOT NULL,
    date_of_death1 date,
    date_of_death2 date,
    age smallint,
    cemeteries_id integer,
    cef_enlistees_id integer,
    dataset_id integer
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
-- Name: cemeteries id; Type: DEFAULT; Schema: public; Owner: nicolas
--

ALTER TABLE ONLY cemeteries ALTER COLUMN id SET DEFAULT nextval('cemeteries_id_seq'::regclass);


--
-- Name: cvwm_cemetery_localities id; Type: DEFAULT; Schema: public; Owner: nicolas
--

ALTER TABLE ONLY cvwm_cemetery_localities ALTER COLUMN id SET DEFAULT nextval('cvwm_cemetery_localities_id_seq'::regclass);


--
-- Name: cvwm_countries id; Type: DEFAULT; Schema: public; Owner: nicolas
--

ALTER TABLE ONLY cvwm_countries ALTER COLUMN id SET DEFAULT nextval('cvwm_countries_id_seq'::regclass);


--
-- Name: cvwm_forces id; Type: DEFAULT; Schema: public; Owner: nicolas
--

ALTER TABLE ONLY cvwm_forces ALTER COLUMN id SET DEFAULT nextval('cvwm_forces_id_seq'::regclass);


--
-- Name: cvwm_ranks id; Type: DEFAULT; Schema: public; Owner: nicolas
--

ALTER TABLE ONLY cvwm_ranks ALTER COLUMN id SET DEFAULT nextval('cvwm_ranks_id_seq'::regclass);


--
-- Name: cvwm_regiments id; Type: DEFAULT; Schema: public; Owner: nicolas
--

ALTER TABLE ONLY cvwm_regiments ALTER COLUMN id SET DEFAULT nextval('cvwm_regiments_id_seq'::regclass);


--
-- Name: cvwm_war_dead id; Type: DEFAULT; Schema: public; Owner: nicolas
--

ALTER TABLE ONLY cvwm_war_dead ALTER COLUMN id SET DEFAULT nextval('cvwm_war_dead_id_seq'::regclass);


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
-- Name: cemeteries cemeteries_pkey; Type: CONSTRAINT; Schema: public; Owner: nicolas
--

ALTER TABLE ONLY cemeteries
    ADD CONSTRAINT cemeteries_pkey PRIMARY KEY (id);


--
-- Name: cvwm_cemetery_localities cvwm_cemetery_localities_pkey; Type: CONSTRAINT; Schema: public; Owner: nicolas
--

ALTER TABLE ONLY cvwm_cemetery_localities
    ADD CONSTRAINT cvwm_cemetery_localities_pkey PRIMARY KEY (id);


--
-- Name: cvwm_countries cvwm_countries_pkey; Type: CONSTRAINT; Schema: public; Owner: nicolas
--

ALTER TABLE ONLY cvwm_countries
    ADD CONSTRAINT cvwm_countries_pkey PRIMARY KEY (id);


--
-- Name: cvwm_forces cvwm_forces_pkey; Type: CONSTRAINT; Schema: public; Owner: nicolas
--

ALTER TABLE ONLY cvwm_forces
    ADD CONSTRAINT cvwm_forces_pkey PRIMARY KEY (id);


--
-- Name: cvwm_ranks cvwm_ranks_pkey; Type: CONSTRAINT; Schema: public; Owner: nicolas
--

ALTER TABLE ONLY cvwm_ranks
    ADD CONSTRAINT cvwm_ranks_pkey PRIMARY KEY (id);


--
-- Name: cvwm_regiments cvwm_regiments_pkey; Type: CONSTRAINT; Schema: public; Owner: nicolas
--

ALTER TABLE ONLY cvwm_regiments
    ADD CONSTRAINT cvwm_regiments_pkey PRIMARY KEY (id);


--
-- Name: cvwm_war_dead cvwm_war_dead_pkey; Type: CONSTRAINT; Schema: public; Owner: nicolas
--

ALTER TABLE ONLY cvwm_war_dead
    ADD CONSTRAINT cvwm_war_dead_pkey PRIMARY KEY (id);


--
-- Name: cef_enlistees people_pkey; Type: CONSTRAINT; Schema: public; Owner: nicolas
--

ALTER TABLE ONLY cef_enlistees
    ADD CONSTRAINT people_pkey PRIMARY KEY (id);


--
-- Name: war_graves war_graves_pkey; Type: CONSTRAINT; Schema: public; Owner: nicolas
--

ALTER TABLE ONLY war_graves
    ADD CONSTRAINT war_graves_pkey PRIMARY KEY (id);


--
-- Name: cemeteries_name; Type: INDEX; Schema: public; Owner: nicolas
--

CREATE UNIQUE INDEX cemeteries_name ON cemeteries USING btree (name);


--
-- Name: cef_enlistees_birth_dates cef_enlistees_id; Type: FK CONSTRAINT; Schema: public; Owner: nicolas
--

ALTER TABLE ONLY cef_enlistees_birth_dates
    ADD CONSTRAINT cef_enlistees_id_fkey FOREIGN KEY (cef_enlistees_id) REFERENCES cef_enlistees(id) ON DELETE CASCADE;


--
-- Name: cef_enlistees_images cef_enlistees_id; Type: FK CONSTRAINT; Schema: public; Owner: nicolas
--

ALTER TABLE ONLY cef_enlistees_images
    ADD CONSTRAINT cef_enlistees_id_fkey FOREIGN KEY (cef_enlistees_id) REFERENCES cef_enlistees(id) ON DELETE CASCADE;


--
-- Name: cef_enlistees_regimental_numbers cef_enlistees_id; Type: FK CONSTRAINT; Schema: public; Owner: nicolas
--

ALTER TABLE ONLY cef_enlistees_regimental_numbers
    ADD CONSTRAINT cef_enlistees_id_fkey FOREIGN KEY (cef_enlistees_id) REFERENCES cef_enlistees(id) ON DELETE CASCADE;


--
-- Name: war_graves cef_enlistees_id; Type: FK CONSTRAINT; Schema: public; Owner: nicolas
--

ALTER TABLE ONLY war_graves
    ADD CONSTRAINT cef_enlistees_id_fkey FOREIGN KEY (cef_enlistees_id) REFERENCES cef_enlistees(id);


--
-- Name: war_graves cemeteries_id; Type: FK CONSTRAINT; Schema: public; Owner: nicolas
--

ALTER TABLE ONLY war_graves
    ADD CONSTRAINT cemeteries_id_fkey FOREIGN KEY (cemeteries_id) REFERENCES cemeteries(id);


--
-- Name: cvwm_war_dead cvwm_war_dead_birth_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: nicolas
--

ALTER TABLE ONLY cvwm_war_dead
    ADD CONSTRAINT cvwm_war_dead_birth_country_id_fkey FOREIGN KEY (birth_country_id) REFERENCES cvwm_countries(id);


--
-- Name: cvwm_war_dead cvwm_war_dead_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: nicolas
--

ALTER TABLE ONLY cvwm_war_dead
    ADD CONSTRAINT cvwm_war_dead_country_id_fkey FOREIGN KEY (country_id) REFERENCES cvwm_countries(id);


--
-- Name: cvwm_war_dead cvwm_war_dead_death_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: nicolas
--

ALTER TABLE ONLY cvwm_war_dead
    ADD CONSTRAINT cvwm_war_dead_death_country_id_fkey FOREIGN KEY (death_country_id) REFERENCES cvwm_countries(id);


--
-- Name: cvwm_war_dead cvwm_war_dead_enlistment_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: nicolas
--

ALTER TABLE ONLY cvwm_war_dead
    ADD CONSTRAINT cvwm_war_dead_enlistment_country_id_fkey FOREIGN KEY (enlistment_country_id) REFERENCES cvwm_countries(id);


--
-- Name: cvwm_war_dead cvwm_war_dead_force_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: nicolas
--

ALTER TABLE ONLY cvwm_war_dead
    ADD CONSTRAINT cvwm_war_dead_force_id_fkey FOREIGN KEY (force_id) REFERENCES cvwm_forces(id);


--
-- Name: cvwm_war_dead cvwm_war_dead_rank_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: nicolas
--

ALTER TABLE ONLY cvwm_war_dead
    ADD CONSTRAINT cvwm_war_dead_rank_id_fkey FOREIGN KEY (rank_id) REFERENCES cvwm_ranks(id);


--
-- Name: cvwm_war_dead cvwm_war_dead_regiment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: nicolas
--

ALTER TABLE ONLY cvwm_war_dead
    ADD CONSTRAINT cvwm_war_dead_regiment_id_fkey FOREIGN KEY (regiment_id) REFERENCES cvwm_regiments(id);


--
-- Name: cvwm_war_dead cvwm_war_dead_war_graves_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: nicolas
--

ALTER TABLE ONLY cvwm_war_dead
    ADD CONSTRAINT cvwm_war_dead_war_graves_id_fkey FOREIGN KEY (war_graves_id) REFERENCES war_graves(id);


--
-- PostgreSQL database dump complete
--

