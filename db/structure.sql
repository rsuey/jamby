--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: group_sessions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE group_sessions (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    description text NOT NULL,
    starts_at timestamp without time zone NOT NULL,
    price numeric(5,2) DEFAULT 0 NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    deleted_at timestamp without time zone,
    host_id integer,
    live_url character varying(255),
    broadcast_id character varying(255),
    ended_at timestamp without time zone,
    hashed_id uuid DEFAULT uuid_generate_v4(),
    completion_job_id character varying(255),
    paid_out_at timestamp without time zone,
    remote_id character varying(255)
);


--
-- Name: group_sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE group_sessions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: group_sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE group_sessions_id_seq OWNED BY group_sessions.id;


--
-- Name: group_sessions_users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE group_sessions_users (
    id integer NOT NULL,
    user_id integer,
    group_session_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: group_sessions_users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE group_sessions_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: group_sessions_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE group_sessions_users_id_seq OWNED BY group_sessions_users.id;


--
-- Name: payment_methods; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE payment_methods (
    id integer NOT NULL,
    last4 integer NOT NULL,
    exp_month integer NOT NULL,
    exp_year integer NOT NULL,
    remote_id character varying(255) NOT NULL,
    account_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    name_on_card character varying(255),
    brand character varying(255)
);


--
-- Name: payment_methods_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE payment_methods_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: payment_methods_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE payment_methods_id_seq OWNED BY payment_methods.id;


--
-- Name: payments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE payments (
    id integer NOT NULL,
    amount integer,
    currency character varying(255),
    account_id integer,
    group_session_id integer,
    remote_id character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    payment_method_id integer,
    deleted_at timestamp without time zone,
    remote_refund_id character varying(255)
);


--
-- Name: payments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE payments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: payments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE payments_id_seq OWNED BY payments.id;


--
-- Name: payout_accounts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE payout_accounts (
    id integer NOT NULL,
    name character varying(255),
    bank_name character varying(255),
    last4 integer,
    account_type character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    account_id integer,
    remote_id character varying(255)
);


--
-- Name: payout_accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE payout_accounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: payout_accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE payout_accounts_id_seq OWNED BY payout_accounts.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    email character varying(255),
    password_digest character varying(255),
    deleted_at timestamp without time zone,
    first_name character varying(255) NOT NULL,
    last_name character varying(255) NOT NULL,
    auth_token uuid DEFAULT uuid_generate_v4(),
    time_zone character varying(255) DEFAULT 'Pacific Time (US & Canada)'::character varying,
    password_reset_token uuid DEFAULT uuid_generate_v4(),
    avatar_file_name character varying(255),
    avatar_content_type character varying(255),
    avatar_file_size integer,
    avatar_updated_at timestamp without time zone,
    access_token character varying(255)
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY group_sessions ALTER COLUMN id SET DEFAULT nextval('group_sessions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY group_sessions_users ALTER COLUMN id SET DEFAULT nextval('group_sessions_users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY payment_methods ALTER COLUMN id SET DEFAULT nextval('payment_methods_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY payments ALTER COLUMN id SET DEFAULT nextval('payments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY payout_accounts ALTER COLUMN id SET DEFAULT nextval('payout_accounts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: group_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY group_sessions
    ADD CONSTRAINT group_sessions_pkey PRIMARY KEY (id);


--
-- Name: group_sessions_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY group_sessions_users
    ADD CONSTRAINT group_sessions_users_pkey PRIMARY KEY (id);


--
-- Name: payment_methods_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY payment_methods
    ADD CONSTRAINT payment_methods_pkey PRIMARY KEY (id);


--
-- Name: payments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (id);


--
-- Name: payout_accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY payout_accounts
    ADD CONSTRAINT payout_accounts_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_group_sessions_on_completion_job_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_group_sessions_on_completion_job_id ON group_sessions USING btree (completion_job_id);


--
-- Name: index_group_sessions_on_deleted_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_group_sessions_on_deleted_at ON group_sessions USING btree (deleted_at);


--
-- Name: index_group_sessions_on_ended_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_group_sessions_on_ended_at ON group_sessions USING btree (ended_at);


--
-- Name: index_group_sessions_on_hashed_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_group_sessions_on_hashed_id ON group_sessions USING btree (hashed_id);


--
-- Name: index_group_sessions_on_host_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_group_sessions_on_host_id ON group_sessions USING btree (host_id);


--
-- Name: index_group_sessions_on_remote_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_group_sessions_on_remote_id ON group_sessions USING btree (remote_id);


--
-- Name: index_group_sessions_users_on_group_session_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_group_sessions_users_on_group_session_id ON group_sessions_users USING btree (group_session_id);


--
-- Name: index_group_sessions_users_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_group_sessions_users_on_user_id ON group_sessions_users USING btree (user_id);


--
-- Name: index_payment_methods_on_account_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_payment_methods_on_account_id ON payment_methods USING btree (account_id);


--
-- Name: index_payment_methods_on_remote_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_payment_methods_on_remote_id ON payment_methods USING btree (remote_id);


--
-- Name: index_payments_on_account_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_payments_on_account_id ON payments USING btree (account_id);


--
-- Name: index_payments_on_deleted_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_payments_on_deleted_at ON payments USING btree (deleted_at);


--
-- Name: index_payments_on_group_session_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_payments_on_group_session_id ON payments USING btree (group_session_id);


--
-- Name: index_payments_on_payment_method_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_payments_on_payment_method_id ON payments USING btree (payment_method_id);


--
-- Name: index_payments_on_remote_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_payments_on_remote_id ON payments USING btree (remote_id);


--
-- Name: index_payout_accounts_on_account_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_payout_accounts_on_account_id ON payout_accounts USING btree (account_id);


--
-- Name: index_users_on_access_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_access_token ON users USING btree (access_token);


--
-- Name: index_users_on_auth_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_auth_token ON users USING btree (auth_token);


--
-- Name: index_users_on_deleted_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_deleted_at ON users USING btree (deleted_at);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_password_reset_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_password_reset_token ON users USING btree (password_reset_token);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20140905001726');

INSERT INTO schema_migrations (version) VALUES ('20140905141330');

INSERT INTO schema_migrations (version) VALUES ('20140906210853');

INSERT INTO schema_migrations (version) VALUES ('20140906211718');

INSERT INTO schema_migrations (version) VALUES ('20140910134103');

INSERT INTO schema_migrations (version) VALUES ('20140913191933');

INSERT INTO schema_migrations (version) VALUES ('20140914232043');

INSERT INTO schema_migrations (version) VALUES ('20140918000946');

INSERT INTO schema_migrations (version) VALUES ('20140918001417');

INSERT INTO schema_migrations (version) VALUES ('20140921043635');

INSERT INTO schema_migrations (version) VALUES ('20140921162711');

INSERT INTO schema_migrations (version) VALUES ('20140921211244');

INSERT INTO schema_migrations (version) VALUES ('20140921211516');

INSERT INTO schema_migrations (version) VALUES ('20140921211717');

INSERT INTO schema_migrations (version) VALUES ('20140922030547');

INSERT INTO schema_migrations (version) VALUES ('20140922031543');

INSERT INTO schema_migrations (version) VALUES ('20140922221049');

INSERT INTO schema_migrations (version) VALUES ('20140923034617');

INSERT INTO schema_migrations (version) VALUES ('20140928183854');

INSERT INTO schema_migrations (version) VALUES ('20141001030446');

INSERT INTO schema_migrations (version) VALUES ('20141002021031');

INSERT INTO schema_migrations (version) VALUES ('20141002030555');

INSERT INTO schema_migrations (version) VALUES ('20141003020547');

INSERT INTO schema_migrations (version) VALUES ('20141006163018');

INSERT INTO schema_migrations (version) VALUES ('20141006163340');

INSERT INTO schema_migrations (version) VALUES ('20141006171132');

INSERT INTO schema_migrations (version) VALUES ('20141007223929');

INSERT INTO schema_migrations (version) VALUES ('20141009042323');

INSERT INTO schema_migrations (version) VALUES ('20141011173853');

INSERT INTO schema_migrations (version) VALUES ('20141013232902');

INSERT INTO schema_migrations (version) VALUES ('20141015061337');

INSERT INTO schema_migrations (version) VALUES ('20141103065201');

INSERT INTO schema_migrations (version) VALUES ('20141103071815');

INSERT INTO schema_migrations (version) VALUES ('20141104055333');

