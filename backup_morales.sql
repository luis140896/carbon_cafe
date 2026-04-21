--
-- PostgreSQL database dump
--

\restrict D0gvNniZ9HC3Cya8GMDUojJCbuKkdIefidliE8eDif4YvWZLMKTBpiGGQwDK124

-- Dumped from database version 18.1
-- Dumped by pg_dump version 18.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO postgres;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS '';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: audit_logs; Type: TABLE; Schema: public; Owner: morales_user
--

CREATE TABLE public.audit_logs (
    id bigint NOT NULL,
    user_id bigint,
    action character varying(50) NOT NULL,
    entity_type character varying(50) NOT NULL,
    entity_id bigint,
    old_values jsonb,
    new_values jsonb,
    ip_address character varying(50),
    user_agent text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.audit_logs OWNER TO morales_user;

--
-- Name: audit_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: morales_user
--

CREATE SEQUENCE public.audit_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.audit_logs_id_seq OWNER TO morales_user;

--
-- Name: audit_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: morales_user
--

ALTER SEQUENCE public.audit_logs_id_seq OWNED BY public.audit_logs.id;


--
-- Name: categories; Type: TABLE; Schema: public; Owner: morales_user
--

CREATE TABLE public.categories (
    id bigint NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    image_url text,
    parent_id bigint,
    display_order integer DEFAULT 0,
    is_active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.categories OWNER TO morales_user;

--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: morales_user
--

CREATE SEQUENCE public.categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.categories_id_seq OWNER TO morales_user;

--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: morales_user
--

ALTER SEQUENCE public.categories_id_seq OWNED BY public.categories.id;


--
-- Name: company_config; Type: TABLE; Schema: public; Owner: morales_user
--

CREATE TABLE public.company_config (
    id bigint NOT NULL,
    company_name character varying(200) NOT NULL,
    legal_name character varying(200),
    tax_id character varying(50),
    logo_url text,
    primary_color character varying(7) DEFAULT '#9b87f5'::character varying,
    secondary_color character varying(7) DEFAULT '#7c3aed'::character varying,
    accent_color character varying(7) DEFAULT '#c4b5fd'::character varying,
    background_color character varying(7) DEFAULT '#f3e8ff'::character varying,
    business_type character varying(50) DEFAULT 'GENERAL'::character varying,
    currency character varying(3) DEFAULT 'COP'::character varying,
    tax_rate numeric(5,2) DEFAULT 19.00,
    address text,
    phone character varying(50),
    email character varying(100),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    card_color character varying(7) DEFAULT '#ffffff'::character varying,
    sidebar_color character varying(7) DEFAULT '#ffffff'::character varying
);


ALTER TABLE public.company_config OWNER TO morales_user;

--
-- Name: company_config_id_seq; Type: SEQUENCE; Schema: public; Owner: morales_user
--

CREATE SEQUENCE public.company_config_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.company_config_id_seq OWNER TO morales_user;

--
-- Name: company_config_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: morales_user
--

ALTER SEQUENCE public.company_config_id_seq OWNED BY public.company_config.id;


--
-- Name: customers; Type: TABLE; Schema: public; Owner: morales_user
--

CREATE TABLE public.customers (
    id bigint NOT NULL,
    document_type character varying(10) DEFAULT 'CC'::character varying,
    document_number character varying(20),
    full_name character varying(200) NOT NULL,
    email character varying(100),
    phone character varying(50),
    address text,
    city character varying(100),
    notes text,
    credit_limit numeric(12,2) DEFAULT 0,
    current_balance numeric(12,2) DEFAULT 0,
    is_active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.customers OWNER TO morales_user;

--
-- Name: customers_id_seq; Type: SEQUENCE; Schema: public; Owner: morales_user
--

CREATE SEQUENCE public.customers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.customers_id_seq OWNER TO morales_user;

--
-- Name: customers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: morales_user
--

ALTER SEQUENCE public.customers_id_seq OWNED BY public.customers.id;


--
-- Name: flyway_schema_history; Type: TABLE; Schema: public; Owner: morales_user
--

CREATE TABLE public.flyway_schema_history (
    installed_rank integer NOT NULL,
    version character varying(50),
    description character varying(200) NOT NULL,
    type character varying(20) NOT NULL,
    script character varying(1000) NOT NULL,
    checksum integer,
    installed_by character varying(100) NOT NULL,
    installed_on timestamp without time zone DEFAULT now() NOT NULL,
    execution_time integer NOT NULL,
    success boolean NOT NULL
);


ALTER TABLE public.flyway_schema_history OWNER TO morales_user;

--
-- Name: inventory; Type: TABLE; Schema: public; Owner: morales_user
--

CREATE TABLE public.inventory (
    id bigint NOT NULL,
    product_id bigint,
    quantity numeric(12,2) DEFAULT 0,
    min_stock numeric(12,2) DEFAULT 0,
    max_stock numeric(12,2) DEFAULT 0,
    location character varying(100),
    last_restock_date timestamp without time zone,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.inventory OWNER TO morales_user;

--
-- Name: inventory_id_seq; Type: SEQUENCE; Schema: public; Owner: morales_user
--

CREATE SEQUENCE public.inventory_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.inventory_id_seq OWNER TO morales_user;

--
-- Name: inventory_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: morales_user
--

ALTER SEQUENCE public.inventory_id_seq OWNED BY public.inventory.id;


--
-- Name: inventory_movements; Type: TABLE; Schema: public; Owner: morales_user
--

CREATE TABLE public.inventory_movements (
    id bigint NOT NULL,
    product_id bigint,
    movement_type character varying(20) NOT NULL,
    quantity numeric(12,2) NOT NULL,
    previous_quantity numeric(12,2),
    new_quantity numeric(12,2),
    reference_type character varying(50),
    reference_id bigint,
    reason text,
    user_id bigint,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.inventory_movements OWNER TO morales_user;

--
-- Name: inventory_movements_id_seq; Type: SEQUENCE; Schema: public; Owner: morales_user
--

CREATE SEQUENCE public.inventory_movements_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.inventory_movements_id_seq OWNER TO morales_user;

--
-- Name: inventory_movements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: morales_user
--

ALTER SEQUENCE public.inventory_movements_id_seq OWNED BY public.inventory_movements.id;


--
-- Name: invoice_details; Type: TABLE; Schema: public; Owner: morales_user
--

CREATE TABLE public.invoice_details (
    id bigint NOT NULL,
    invoice_id bigint,
    product_id bigint,
    product_name character varying(200),
    quantity numeric(12,2) NOT NULL,
    unit_price numeric(12,2) NOT NULL,
    cost_price numeric(12,2) NOT NULL,
    discount_amount numeric(12,2) DEFAULT 0,
    tax_amount numeric(12,2) DEFAULT 0,
    subtotal numeric(12,2) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    notes character varying(500),
    kitchen_status character varying(30) DEFAULT 'PENDIENTE'::character varying
);


ALTER TABLE public.invoice_details OWNER TO morales_user;

--
-- Name: invoice_details_id_seq; Type: SEQUENCE; Schema: public; Owner: morales_user
--

CREATE SEQUENCE public.invoice_details_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.invoice_details_id_seq OWNER TO morales_user;

--
-- Name: invoice_details_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: morales_user
--

ALTER SEQUENCE public.invoice_details_id_seq OWNED BY public.invoice_details.id;


--
-- Name: invoices; Type: TABLE; Schema: public; Owner: morales_user
--

CREATE TABLE public.invoices (
    id bigint NOT NULL,
    invoice_number character varying(50) NOT NULL,
    invoice_type character varying(20) DEFAULT 'VENTA'::character varying,
    customer_id bigint,
    user_id bigint,
    subtotal numeric(12,2) DEFAULT 0 NOT NULL,
    tax_amount numeric(12,2) DEFAULT 0,
    discount_amount numeric(12,2) DEFAULT 0,
    discount_percent numeric(5,2) DEFAULT 0,
    total numeric(12,2) DEFAULT 0 NOT NULL,
    payment_method character varying(50),
    payment_status character varying(20) DEFAULT 'PAGADO'::character varying,
    amount_received numeric(12,2) DEFAULT 0,
    change_amount numeric(12,2) DEFAULT 0,
    status character varying(20) DEFAULT 'COMPLETADA'::character varying,
    notes text,
    voided_by bigint,
    voided_at timestamp without time zone,
    void_reason text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    service_charge_percent numeric(5,2) DEFAULT 0,
    service_charge_amount numeric(12,2) DEFAULT 0,
    delivery_charge_amount numeric(12,2) DEFAULT 0
);


ALTER TABLE public.invoices OWNER TO morales_user;

--
-- Name: invoices_id_seq; Type: SEQUENCE; Schema: public; Owner: morales_user
--

CREATE SEQUENCE public.invoices_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.invoices_id_seq OWNER TO morales_user;

--
-- Name: invoices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: morales_user
--

ALTER SEQUENCE public.invoices_id_seq OWNED BY public.invoices.id;


--
-- Name: kitchen_orders; Type: TABLE; Schema: public; Owner: morales_user
--

CREATE TABLE public.kitchen_orders (
    id bigint NOT NULL,
    table_id bigint NOT NULL,
    invoice_detail_id bigint NOT NULL,
    order_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    sequence_number integer NOT NULL,
    status character varying(20) DEFAULT 'PENDIENTE'::character varying NOT NULL,
    is_urgent boolean DEFAULT false,
    urgency_reason character varying(200),
    notes text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.kitchen_orders OWNER TO morales_user;

--
-- Name: kitchen_orders_id_seq; Type: SEQUENCE; Schema: public; Owner: morales_user
--

CREATE SEQUENCE public.kitchen_orders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.kitchen_orders_id_seq OWNER TO morales_user;

--
-- Name: kitchen_orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: morales_user
--

ALTER SEQUENCE public.kitchen_orders_id_seq OWNED BY public.kitchen_orders.id;


--
-- Name: notifications; Type: TABLE; Schema: public; Owner: morales_user
--

CREATE TABLE public.notifications (
    id bigint NOT NULL,
    type character varying(50) NOT NULL,
    title character varying(200) NOT NULL,
    message text,
    severity character varying(20) DEFAULT 'INFO'::character varying,
    target_roles jsonb DEFAULT '[]'::jsonb,
    reference_type character varying(50),
    reference_id bigint,
    is_read boolean DEFAULT false,
    read_by bigint,
    read_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.notifications OWNER TO morales_user;

--
-- Name: notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: morales_user
--

CREATE SEQUENCE public.notifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.notifications_id_seq OWNER TO morales_user;

--
-- Name: notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: morales_user
--

ALTER SEQUENCE public.notifications_id_seq OWNED BY public.notifications.id;


--
-- Name: payments; Type: TABLE; Schema: public; Owner: morales_user
--

CREATE TABLE public.payments (
    id bigint NOT NULL,
    invoice_id bigint,
    payment_method character varying(50) NOT NULL,
    amount numeric(12,2) NOT NULL,
    reference character varying(100),
    notes text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.payments OWNER TO morales_user;

--
-- Name: payments_id_seq; Type: SEQUENCE; Schema: public; Owner: morales_user
--

CREATE SEQUENCE public.payments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.payments_id_seq OWNER TO morales_user;

--
-- Name: payments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: morales_user
--

ALTER SEQUENCE public.payments_id_seq OWNED BY public.payments.id;


--
-- Name: products; Type: TABLE; Schema: public; Owner: morales_user
--

CREATE TABLE public.products (
    id bigint NOT NULL,
    code character varying(50) NOT NULL,
    barcode character varying(50),
    name character varying(200) NOT NULL,
    description text,
    category_id bigint,
    image_url text,
    cost_price numeric(12,2) DEFAULT 0 NOT NULL,
    sale_price numeric(12,2) DEFAULT 0 NOT NULL,
    unit character varying(20) DEFAULT 'UNIDAD'::character varying,
    tax_rate numeric(5,2) DEFAULT 0,
    is_active boolean DEFAULT true,
    created_by bigint,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.products OWNER TO morales_user;

--
-- Name: products_id_seq; Type: SEQUENCE; Schema: public; Owner: morales_user
--

CREATE SEQUENCE public.products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.products_id_seq OWNER TO morales_user;

--
-- Name: products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: morales_user
--

ALTER SEQUENCE public.products_id_seq OWNED BY public.products.id;


--
-- Name: promotions; Type: TABLE; Schema: public; Owner: morales_user
--

CREATE TABLE public.promotions (
    id bigint NOT NULL,
    name character varying(100) NOT NULL,
    description character varying(500),
    discount_percent numeric(5,2) NOT NULL,
    schedule_type character varying(20) NOT NULL,
    days_of_week character varying(50),
    start_date date,
    end_date date,
    is_active boolean DEFAULT true NOT NULL,
    apply_to_all_products boolean DEFAULT true NOT NULL,
    priority integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.promotions OWNER TO morales_user;

--
-- Name: promotions_id_seq; Type: SEQUENCE; Schema: public; Owner: morales_user
--

CREATE SEQUENCE public.promotions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.promotions_id_seq OWNER TO morales_user;

--
-- Name: promotions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: morales_user
--

ALTER SEQUENCE public.promotions_id_seq OWNED BY public.promotions.id;


--
-- Name: restaurant_tables; Type: TABLE; Schema: public; Owner: morales_user
--

CREATE TABLE public.restaurant_tables (
    id bigint NOT NULL,
    table_number integer NOT NULL,
    name character varying(100),
    capacity integer DEFAULT 4,
    status character varying(30) DEFAULT 'DISPONIBLE'::character varying,
    zone character varying(50) DEFAULT 'INTERIOR'::character varying,
    display_order integer DEFAULT 0,
    is_active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.restaurant_tables OWNER TO morales_user;

--
-- Name: restaurant_tables_id_seq; Type: SEQUENCE; Schema: public; Owner: morales_user
--

CREATE SEQUENCE public.restaurant_tables_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.restaurant_tables_id_seq OWNER TO morales_user;

--
-- Name: restaurant_tables_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: morales_user
--

ALTER SEQUENCE public.restaurant_tables_id_seq OWNED BY public.restaurant_tables.id;


--
-- Name: roles; Type: TABLE; Schema: public; Owner: morales_user
--

CREATE TABLE public.roles (
    id bigint NOT NULL,
    name character varying(50) NOT NULL,
    description text,
    permissions jsonb DEFAULT '[]'::jsonb,
    is_system boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.roles OWNER TO morales_user;

--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: morales_user
--

CREATE SEQUENCE public.roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.roles_id_seq OWNER TO morales_user;

--
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: morales_user
--

ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;


--
-- Name: suppliers; Type: TABLE; Schema: public; Owner: morales_user
--

CREATE TABLE public.suppliers (
    id bigint NOT NULL,
    name character varying(200) NOT NULL,
    contact_name character varying(200),
    email character varying(100),
    phone character varying(50),
    address text,
    tax_id character varying(50),
    notes text,
    is_active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.suppliers OWNER TO morales_user;

--
-- Name: suppliers_id_seq; Type: SEQUENCE; Schema: public; Owner: morales_user
--

CREATE SEQUENCE public.suppliers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.suppliers_id_seq OWNER TO morales_user;

--
-- Name: suppliers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: morales_user
--

ALTER SEQUENCE public.suppliers_id_seq OWNED BY public.suppliers.id;


--
-- Name: table_sessions; Type: TABLE; Schema: public; Owner: morales_user
--

CREATE TABLE public.table_sessions (
    id bigint NOT NULL,
    table_id bigint NOT NULL,
    invoice_id bigint,
    opened_by bigint NOT NULL,
    closed_by bigint,
    opened_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    closed_at timestamp without time zone,
    guest_count integer DEFAULT 1,
    notes text,
    status character varying(20) DEFAULT 'ABIERTA'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.table_sessions OWNER TO morales_user;

--
-- Name: table_sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: morales_user
--

CREATE SEQUENCE public.table_sessions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.table_sessions_id_seq OWNER TO morales_user;

--
-- Name: table_sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: morales_user
--

ALTER SEQUENCE public.table_sessions_id_seq OWNED BY public.table_sessions.id;


--
-- Name: user_sessions; Type: TABLE; Schema: public; Owner: morales_user
--

CREATE TABLE public.user_sessions (
    id bigint NOT NULL,
    user_id bigint,
    refresh_token_hash character varying(255) NOT NULL,
    ip_address character varying(50),
    user_agent text,
    expires_at timestamp without time zone NOT NULL,
    is_valid boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.user_sessions OWNER TO morales_user;

--
-- Name: user_sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: morales_user
--

CREATE SEQUENCE public.user_sessions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.user_sessions_id_seq OWNER TO morales_user;

--
-- Name: user_sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: morales_user
--

ALTER SEQUENCE public.user_sessions_id_seq OWNED BY public.user_sessions.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: morales_user
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    username character varying(50) NOT NULL,
    email character varying(100) NOT NULL,
    password_hash character varying(255) NOT NULL,
    full_name character varying(200),
    role_id bigint,
    avatar_url text,
    is_active boolean DEFAULT true,
    must_change_password boolean DEFAULT false,
    last_login timestamp without time zone,
    failed_login_attempts integer DEFAULT 0,
    locked_until timestamp without time zone,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.users OWNER TO morales_user;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: morales_user
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO morales_user;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: morales_user
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: audit_logs id; Type: DEFAULT; Schema: public; Owner: morales_user
--

ALTER TABLE ONLY public.audit_logs ALTER COLUMN id SET DEFAULT nextval('public.audit_logs_id_seq'::regclass);


--
-- Name: categories id; Type: DEFAULT; Schema: public; Owner: morales_user
--

ALTER TABLE ONLY public.categories ALTER COLUMN id SET DEFAULT nextval('public.categories_id_seq'::regclass);


--
-- Name: company_config id; Type: DEFAULT; Schema: public; Owner: morales_user
--

ALTER TABLE ONLY public.company_config ALTER COLUMN id SET DEFAULT nextval('public.company_config_id_seq'::regclass);


--
-- Name: customers id; Type: DEFAULT; Schema: public; Owner: morales_user
--

ALTER TABLE ONLY public.customers ALTER COLUMN id SET DEFAULT nextval('public.customers_id_seq'::regclass);


--
-- Name: inventory id; Type: DEFAULT; Schema: public; Owner: morales_user
--

ALTER TABLE ONLY public.inventory ALTER COLUMN id SET DEFAULT nextval('public.inventory_id_seq'::regclass);


--
-- Name: inventory_movements id; Type: DEFAULT; Schema: public; Owner: morales_user
--

ALTER TABLE ONLY public.inventory_movements ALTER COLUMN id SET DEFAULT nextval('public.inventory_movements_id_seq'::regclass);


--
-- Name: invoice_details id; Type: DEFAULT; Schema: public; Owner: morales_user
--

ALTER TABLE ONLY public.invoice_details ALTER COLUMN id SET DEFAULT nextval('public.invoice_details_id_seq'::regclass);


--
-- Name: invoices id; Type: DEFAULT; Schema: public; Owner: morales_user
--

ALTER TABLE ONLY public.invoices ALTER COLUMN id SET DEFAULT nextval('public.invoices_id_seq'::regclass);


--
-- Name: kitchen_orders id; Type: DEFAULT; Schema: public; Owner: morales_user
--

ALTER TABLE ONLY public.kitchen_orders ALTER COLUMN id SET DEFAULT nextval('public.kitchen_orders_id_seq'::regclass);


--
-- Name: notifications id; Type: DEFAULT; Schema: public; Owner: morales_user
--

ALTER TABLE ONLY public.notifications ALTER COLUMN id SET DEFAULT nextval('public.notifications_id_seq'::regclass);


--
-- Name: payments id; Type: DEFAULT; Schema: public; Owner: morales_user
--

ALTER TABLE ONLY public.payments ALTER COLUMN id SET DEFAULT nextval('public.payments_id_seq'::regclass);


--
-- Name: products id; Type: DEFAULT; Schema: public; Owner: morales_user
--

ALTER TABLE ONLY public.products ALTER COLUMN id SET DEFAULT nextval('public.products_id_seq'::regclass);


--
-- Name: promotions id; Type: DEFAULT; Schema: public; Owner: morales_user
--

ALTER TABLE ONLY public.promotions ALTER COLUMN id SET DEFAULT nextval('public.promotions_id_seq'::regclass);


--
-- Name: restaurant_tables id; Type: DEFAULT; Schema: public; Owner: morales_user
--

ALTER TABLE ONLY public.restaurant_tables ALTER COLUMN id SET DEFAULT nextval('public.restaurant_tables_id_seq'::regclass);


--
-- Name: roles id; Type: DEFAULT; Schema: public; Owner: morales_user
--

ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);


--
-- Name: suppliers id; Type: DEFAULT; Schema: public; Owner: morales_user
--

ALTER TABLE ONLY public.suppliers ALTER COLUMN id SET DEFAULT nextval('public.suppliers_id_seq'::regclass);


--
-- Name: table_sessions id; Type: DEFAULT; Schema: public; Owner: morales_user
--

ALTER TABLE ONLY public.table_sessions ALTER COLUMN id SET DEFAULT nextval('public.table_sessions_id_seq'::regclass);


--
-- Name: user_sessions id; Type: DEFAULT; Schema: public; Owner: morales_user
--

ALTER TABLE ONLY public.user_sessions ALTER COLUMN id SET DEFAULT nextval('public.user_sessions_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: morales_user
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: audit_logs; Type: TABLE DATA; Schema: public; Owner: morales_user
--

COPY public.audit_logs (id, user_id, action, entity_type, entity_id, old_values, new_values, ip_address, user_agent, created_at) FROM stdin;
\.


--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: morales_user
--

COPY public.categories (id, name, description, image_url, parent_id, display_order, is_active, created_at, updated_at) FROM stdin;
7	AL BARRIL	Carnes	🥩	\N	2	t	2026-01-30 09:09:13.821854	2026-02-09 19:28:40.201749
10	Menu infantil	nuggets , salchipapas	🥔	\N	10	t	2026-01-30 15:26:17.89199	2026-02-10 06:52:16.553192
11	Asados	carnes	🍗	\N	11	t	2026-01-30 15:26:28.189977	2026-02-10 06:53:07.776016
12	Adiciones	papas, arepas		\N	12	t	2026-01-30 15:26:33.823252	2026-02-10 06:53:31.970382
15	Gaseosas		🍷	2	109	t	2026-02-10 06:55:24.924973	2026-02-10 06:55:24.924973
16	Sodas Saborizadas	sodas		2	110	t	2026-02-10 06:56:30.786973	2026-02-10 06:56:30.786973
18	Limonadas		🍜	2	112	t	2026-02-10 06:57:37.350986	2026-02-10 06:57:52.936957
19	Cervezas	licor	🍜	2	113	t	2026-02-10 06:58:20.045296	2026-02-10 06:58:20.045296
13	Cocteles	licor	🍜	2	13	t	2026-01-30 15:26:38.195712	2026-02-10 06:58:49.835872
21	Bebidas Calientes	cafe	🍵	20	115	t	2026-02-10 07:00:06.237706	2026-02-10 07:00:26.671179
23	Tortas	tortas	🍰	\N	117	t	2026-02-10 07:01:27.019805	2026-02-10 07:01:27.019805
17	Jugos	jugos	🍜	2	111	t	2026-02-10 06:57:10.339074	2026-02-11 19:57:46.366136
24	Shots	licor	🍷	\N	118	t	2026-02-10 19:54:54.469221	2026-02-11 20:13:30.479329
20	Coffee	cafe	☕	\N	114	t	2026-02-10 06:59:29.128013	2026-02-16 08:01:02.246251
22	Bebidas Frias	Cafe	☕	20	116	t	2026-02-10 07:00:54.049789	2026-02-16 08:03:57.628432
25	COMBOS			\N	119	t	2026-02-22 02:25:24.372841	2026-02-22 02:25:24.372841
8	DELICIAS AL CARBON Y CAFE	Papas	🧸	\N	1	t	2026-01-30 09:12:28.568496	2026-02-27 09:24:30.598953
2	BEBIDAS	Bebidas y refrescos	🥛	\N	4	t	2026-01-27 11:29:59.946047	2026-02-27 09:24:44.492097
5	ENTRADAS	Entradas	🍖	\N	8	t	2026-01-27 11:29:59.946047	2026-02-27 09:24:54.129939
9	ARTESANALES	hamburguesas	🍔	\N	9	t	2026-01-30 09:34:05.263592	2026-02-27 09:27:02.368997
\.


--
-- Data for Name: company_config; Type: TABLE DATA; Schema: public; Owner: morales_user
--

COPY public.company_config (id, company_name, legal_name, tax_id, logo_url, primary_color, secondary_color, accent_color, background_color, business_type, currency, tax_rate, address, phone, email, created_at, updated_at, card_color, sidebar_color) FROM stdin;
1	Al Carbon y Cafe			data:image/jpeg;base64,/9j/4AAQSkZJRgABAQEAYABgAAD/2wBDAAMCAgMCAgMDAwMEAwMEBQgFBQQEBQoHBwYIDAoMDAsKCwsNDhIQDQ4RDgsLEBYQERMUFRUVDA8XGBYUGBIUFRT/2wBDAQMEBAUEBQkFBQkUDQsNFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBT/wAARCAGOAYADASIAAhEBAxEB/8QAHwAAAQUBAQEBAQEAAAAAAAAAAAECAwQFBgcICQoL/8QAtRAAAgEDAwIEAwUFBAQAAAF9AQIDAAQRBRIhMUEGE1FhByJxFDKBkaEII0KxwRVS0fAkM2JyggkKFhcYGRolJicoKSo0NTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uHi4+Tl5ufo6erx8vP09fb3+Pn6/8QAHwEAAwEBAQEBAQEBAQAAAAAAAAECAwQFBgcICQoL/8QAtREAAgECBAQDBAcFBAQAAQJ3AAECAxEEBSExBhJBUQdhcRMiMoEIFEKRobHBCSMzUvAVYnLRChYkNOEl8RcYGRomJygpKjU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6goOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4uPk5ebn6Onq8vP09fb3+Pn6/9oADAMBAAIRAxEAPwD4yopdtG2quQJRS7aNtFwG7aTYPen7aNtMBmwe9N21JSbaq4Eewe9M2D3qfbTNtFybEW2mbal203ZRcLEewe9N21Ntpm2i4WIttM21Ltpu2i4LUZtpm2pKTbQC1I6TbTymPVvoKY2R0B/EYqrgNpNtRPe20fWZPwaqz69p8fW6X8qLodmXKTbWV/wlFh/z0P5Uz/hLdP8A70n/AHxS5kPlZr0m2sj/AISqw9ZP++Kd/wAJNZf33/74o5kPkZp0yqqa1ZSdJx+VTpcQydJU/Fqd0TZj6bTypHUH8Bmo2Podv1FO4noNoopu6nYBKKKKQBTaXdSUAFFFN3UAJRRRQAUyl3UlABTadTaACmUu6koAZRRRQB6Fto20tFc1y7CbaNtLRRcLCbaNtLRV3CxHto20/bRtouFiOk207bRtouIi20tO20baYyHbTdtS7ahkdYUZ5HVEH8THFLYBu2muu3+Ej61zOqfEGwtG2Wqm6b+8W2rXOXPjy7uvvDZ/u/8A66LlQjc767vrex/10gX6c1hXnjFE/wCPa0ln/SuPPiVj1RT9WzTv+Eof/nnWfNI6Y06fc15vE+qXX3R5f+4p/wAay57i9uf9YZX/ABNMPiiU9Bj6Ck/4SSf+8KXNIfJTIyjnrEx/Om+W56x5+tO/t6T++fypn9tH+6v51F5DtENsvoPypPLf0P60v9rFvuw/pTl1lz/y6r+v+FVqFokflTf3H/Jv8Kd5E/8Azzb8m/wqf+2p/wDnk3/fT07+17n/AJ95v++2/wAaLl2RUFtcDorj6Z/wqQWM46CQfSpvt9x/z6v/AN/m/wAaj+23H/Psn/fZ/wAaPeItEWNr63+5KyfRzWjB4jvYP9Y0cn+9j/GsZ7iWTrGg+mf8aCWPWND/ANsx/hTvIlxizqoPFNvL96N0+taFvew3X+qkVvrxXDhx3DN9amjff91ZZf8Ad+WtPasj2SO6xxnGR7U3dXM2mq38cezygg9ZXzWkmv2gVRLcRJIeuDkVpzo53Bo06bupEk38qQ6/3l6UVa1IsLupKKbuoEtR1N3UbqSgYUUUm6gA3UlFN3UAJTd1G6koAKKTdRuoA9G20baWiuO5tYTbRtp22jbTCw3bRtp22jbVXCw3bRtp22kouIj20bafto20xWbIdtCqz7QFLE+lE++KLdHE8x/2aypY9XuZA8enXURHZHA/pXPVrwh1OyjhKlaW2havhfoNlpYy3En94odtc3d+DNd1hy13Gyqf+WbqQv8AOukgs9fY82Oo49PtVXRoOtyf6zSb1/8AeuRXmyxc+6PoqWW0lumziR8OrtFw0USj0Cx/1eh/h/Mn/LOD/gXlrXcHwtqD/wDMEP43ZqrN4Svh93QbUfWQn+dYLFN/aOh4KEfsnEzeDDF1eyT6zKf6VSbwvAv/AC9ad/4EH/Cu2m8Lap/DpFlH9CWqpL4d1NfvWdp+ANdEKz6yOSphUtonHPoFqv8Ay2sP+/h/wqH+xrT/AJ6Wf/fTV10uh3q/eht/wb/69V30p4/vRr+H/wC1WntX3OZ4dR3Ryv8AZsH/AEw/KT/4ioms0/hcH8v8K6z7Gf8AnhD/AN8ikME0fSGE/XFaqq2YukkckbNz0Zh9GH+FNWzlX/lsf+//AP8AWrrC8g+8lqn1Oag+0H0t/wDv1V+1YvZI5v8As8/89k/7/mhdKX+IxD/tqa6TzH/uJ/4Dj/GoyXboof8A3Y1H9KXMyPZowv7JT/npH/30aYdNhT7zr+AP+NbwUd0YfUKKcsY/iOf+BD/Cnzsn2ZgtbRr90SS/7qYpNp/59Jf++h/hXQNDu5IKj/ephUDoqn8xWnMHIrXMMRXT/dhi/EH/ABpwtLqX705X/dwK2vLcnGBn24p0enTXHEMTyn/pmNwpuSW5Ki5OyRhDRYz98NJ/vNT106JSCIlBHfaK6yPwndKN1zIlsv8AtHJqJrTTbc7Wmnum/wCmS7P5g1HtUaKg3uYVsZ7XiNzt/uFeP51pR6gjfe4+lWFtYZuI9PZP9p2JH6VMulyHrFEPoD/jVKu0RLDKRDvPtSbqs/2fJ6iq8iGIsGB4/iYbRXXCrCezOGrQlSV2hN1G6mbqN1a3OQfupm6jdTN1MB+6mbqN1N3UAG6jdSU3dQAbqN1M3UbqAPTttG2n7aNtcR02DbRtpaKdxCbaNtLRTuAm2k2D3p1BZUTLZz7UPQVtbDGjxwDk1WmvFg+9G5+lS2PifRYZN8srufRUNakfjvwyPvxTN9YDXkYjFzi+SnG59Bg8vi1z1nbyMQ+LDEm2G2Kj/dNT23izUX+5pU7fSJv8a24/iD4Tj6WUp+sBrRh+Mug2/wDq7S5X/tia8qcpvamfSQhBbVEZFrqviab/AFWgSf8AAmP+Na9rH4vl/wCYUif7wFWYPjno0f3bS7H0iNSf8L60rvZXR/7ZmuBqu/8Al2d0JUY71SlJa+Jm/wBfPaWv1bNVZtN1Wb/W+IYE/wCuasf/AGStCf43aRJ9/T52+sFYd78VNBuf+YYw+keK0jCv/IEquHW0xJfCV3L/AMxuO4/65zMP6imHwNMeryH/ALev/r1nTePdMbrFKfrCT/Og+PdKHW1f/v1XSoV1ujmdWg92THwJj70Xmf7s4/wqB/As462Mp+pj/wAasp8ULCL/AFdiP+BRN/jTpPi0v/QPh/8AAYU7YjsZP6n1kZ0ng10+8Iof+ulwP6A1SfwnpifflaT/AK4RE/8AoTLWs/xcbOI7KP8A3jbFR+lVv+FwNCVAs7SIn+9Esf8AU1sniF0MpPB9ylF4XSf/AI9rCc/XA/pVmH4f3s43CBo1/wBtealk+M2py/djiP8AuL/9as64+KevTHpOB6CNsfyrVSrv/hzF/U13HN4Stbd9jpdTt/sRhP5g1CfDqn7ml7P+vlif5YqCT4l62DkPcA+vkk/0pn/C0NT/AOW7D/tvHit17Z7HI54Vf8MSjw5KP9XbQp/1zjz/ADzWjYeCrrUWUBGAP92H/HFY8PxGu2OIkt8+zZ/kTV2P4kamjgCYROO0rH+ZzWc1X7FwqYTqy3rOg6T4clVJhNeXR/gVgq/yrHtwdQvEt7O1gsy/3Tyf5k1o3vi2PXIgup2XmyD/AJbW5y/51kPbQyjzLG6D+m75XFbUufl97czrRhz81LVHbaZ4AjiTzb7Mkn9w4/nVDX9Tt9IZra14kXqYwAayNO8baxpA8q4Ju4f7kgwfzrM1O9hvbiS6gY5k6q3UVEKNSU/fd0aTr0o0/wB2rMbK8l8/zNlfTJq1ZWUcjOypthiVTIwPJz6ZrOST5cZx9K0dN1OOzjmjnUtBKACU+8uPSu2UHGOh50JqUve2Lt1ZS2L+VJtiYrnZF/D9c5qk0bt/E1bsd/BqZ+YpPIRgvGfnP/ATVaS1VfusT9VrnjJrc65QT2MGWGWPo7VUluJkyA5Kn+FuRWxcRH+8Ky5lib/loPyreDTOGcXfUp7z7Ubz7U51Re5qHdXpQlfc8arR/lJN59qTdSUV07nJYXdSU3dRuoAN1M3UbqSgApN1G6mbqAPV6dto207bXDc6hu2jbTttG2i4rDdtG2nbaCAqMxOAKLhbWwx8IuT1rmbzxiI5WjgiR0Hd8k1o3Ov2TrgS/pVP+2NNyTgZP+wP8K5ak76JHp4ehb32zPHjGUdLK1H0Q/40DxRdTdIIh/2zP+NXW1vTv4WU/wDbMVC2u2ifdUt/upWFuqR380tLyGjUtVf7sC/jEf8AGn+fq/8AcT/v2f8AGmHXoz0WUfQGmf203/PCelr2NYyS6k63OsL/AAp/37P+ND3OsL/yxT/vg/41X/tp/wDnlN+tMOpyN/yxl/M1Vn2G6iX2mTSXusf88R/3wf8AGoHuNQb/AFkTr/uoKja7mb/lnP8AmaZ5tzIdojmZz90c5b/gPWmo21OVyu7JikXTf89v++h/hTLiCbPMMyj/AGmAP5V7L8M/2WvHHxCEdzPD/YOmH71zfHaf++etfQ2n/Bf4RfAawF94rvra7ul+++qSY/JBzXDVxkIPlj7z8jphh5zjzS0XmfHHhP4R+NPH7oNB8PajeI/SUjy1/UV9A+Cv+CefijVkWbxP4jtNCXvb2atdv/30MD9K1vGv/BQzRtDDWPgPw++pAdJ5l8iEfgMH9a+fPGP7YXxg8cOw/tx9Gtm/5Z6ZH5I/mTWcYY6v8KUEROphqL1bkz7J0v8AYi+EfgpFn8S65fX79/7Q1CO2j/75UA/rWmNX/Zd8BRmNpvCKY6HP2k/qK/MjUZNT1+VpdU1O7v5W/juJmc/qarLoEC55U59RmtP7NlU/i1mZfX+T+HTR+ll7+1z+zXoB/wBG+zXP/Xrof+IrNb9vf4FRfc8N6nN9NDgH83r86hpCr0Yr9HYf1o/sWP5f3SPn0Aq1lGHW7k/mS8yrPZL7j9Ev+G9vgfJ18Maqn10SA/8As1TW/wC1t+zT4iOL2zt7b/r50EH+WK/OZdOiT7tuF+gFONmjfeLt9aTynD/ZlJfMFj63VL7j9J5IP2UPiPGEV/C0ee0cr2Tf+O4qhqH7Bfwm8VQ+b4V8QahYMei2d3FdRf8AfJG79a/OM6ZAcEqSR324P6Vd0rUr/wAPXCT6Tql9p0ydHtp3Un9azeW1YfwazXrqX9chP+JTR9a+NP8Agnn4v0YNL4Z1/TtfTtb3Aa0l/UkV4D4x+GXjbwFcuPEfhi8s406zFDIv/juK6jwl+2Z8WfBu1H15NftR/wAsdSQSH8xg/rXvXg//AIKC+HvEEK2XjPQ5NMJ6zxqLiE/gcn9axf1/D6zipr8Toh9UrO0HyM+OodQDIwEroo/5ZkeYPz4p4COu5ov+2sByv5V9vap8H/g78d7N73w89pb3T/cn0x9p/GOvnz4lfsqeK/ADzXemZ8QafH957VSJF/4B3rahj6U3yy91+egVMHViuaPvLyPIQpH+rYP+lOXk85HsKjExEvlSACQfeSVCjL+FTeeD98IP91q9ZTbWp5yjbYTagGADj3Of1PNL9pk/56t/30afgf3R+dDKF/5Zj86FysG2upC9zI/Vm/Coy5arDNEvaonuVX+EVqrLYybb3KrIzdc09YWbuq/7xx/LNI+oFeiL+VRtfznoSn+4oX+VN36Eq3UmaGT+EF/+A4qPJPTFV5TcN97c31ei3SReo/Wtqc2viOSrT/lJd1G6kyKTdXWcPWwtJuo3UzdQAbqSim7qAPXttP20baWvPOoTbTal20zbQAbc8jp71z/iPWkRvssbfMP9YR2+lWPE2tR6VYqocLPJ/q1YcfjXnsl1LKSXu7dmPVjG2f50WN4Q1uzR8xP7w/Kmeev94f8AfNUd8v8Az/W3/ftv8ai3y/8AP9bf9+2/xo+R1X6Gotwi/wDLRD9cf4VKuqBPuyIPoR/hWJvuP+fy2/74P+FG+4/5+7X/AL9tSegrm3/bD/8APZf0/wAKd/bc3/PwPzH+FYXm3f8Az3tPyP8AhTftV1/z0g/79n/CkrPYOZm7/bLf8/H/AI7Txq0zAkT7SOOxBP1rnlvJ2lESpGz9MKjElvQDHNfX/wCzt+x1f+IoLfxD8QbdNN0hf3sWmt8juPV89BXPWrwoR5ps2pQlVdkeRfCz4TeMfi7qIh0WBlsl5n1G4GyCAe7EfN+FfWmkfD74afszeHf7V8U6jBeahEPmu7xAZHP/AEzjxn881yPxw/bN8M/Cmyfwn8NrS11C5tl2LLCv+iw/QDBb8Sa+GfFHjnXfiDrj6t4i1C41S9Y5V5ySE/3V6V5cKVfGvmn7kO3VnVKtSwukPekfS/xX/bs8T+LA2neArH+wNP8A4b+ch7qT6L90f98182anHrPiO9N5q99PqN2eTNdSGQ/rkfpVKHWfs6sqRgbup7/nU58Qt6L+dexQw9KgrQX+Z59SrUrazf8AkSx6ZLEpC9D681OsN0vqR6Gqn/CR/wCyPyNL/wAJH7j8jW129GYqMVqiy4uB0H6VD+89T+VRt4hDdcflUL60i9hQVoWc+1egXHwzkvfhlbeK9NDyPGz/AGu3BzgDptGP55rzhNYikcKoXJYKBjk5r7W+Fnho6H8O9M0+8iHmvDmdSOCW65rzsfiHhoxl1uevlmFWKnOL2SPi5ZwcZZxngD3qdJFbrN+lbPxR8PN4H8d6jppUNBvEkBPUqa5xboL6flXfTftIKcdmeVUi6c3CW6LW4f8APwv5ULuX+JT9RUH2iP2o+0R1oQWB5gOSkbH1IFRtAzAD7NGAOwyKi8yH1P50/dH6n86ei2Dmvqx+n3GoaBei80qaXTrsdJrWUoR+AOP0r6E+Gn7aXiPQBHYeMrVtdsF63sPy3Uf1GcH8q+dw6Dv+tRkodv8As9Dzn8646+FpYnSor/mdNHFVcPK9OX+R9z6/4L+Hf7Q2irqei3FtFeSDi5tQBID/ALaY/livmL4hfC7X/hpeMuoQRz2JP7q+j5ilH1/h/GuA0LxLqXhLVhqWjX81hd5yWhO0N9R0r6W+H/7RekfEGzGheL7e3gvZBtaR0/0ef8CTj868d0MRl8rwfPDt1R7cK2Hx65Zrkqd+jPnf7TFsDbYiDwCGJ5/KnM0Ddz+del/Fn4Fz6MJNV8Llrm1ZvMa0VySo9Qe4rxBby43MrR7WX7wPBX6ivVw9SFdXgzyMTRqYeXLNHQsEb+MflTSkLf8ALdf++TWMl3dt/wAs2/75pyXV63/LF/8AvmuuxyqSZoSRQ/8APdf++TUGU/56n8qps+oN/wAu8v8A37pN2pf88Z/++BTFctGEt/z0/Kj7DJ/eT/v5VHZff88pv++D/jTMXn/PrN/3xTsS9TUwg/5aq3+6KTdWTi6HS3mX6YrQtZHmiy8flt7mumnK+5wVIWd0TbqSm7qN1a3MQ3U3dRupKYHstO202n151zrsFRTyJBC8rHCJ96pa57xJqW51tYxwfvc0xxTbsjldWvLnVr+SaSFm9ASML9KqbJf+eLf98VrlVwf3CjPo1Jlf+ef/AI8alzaO5QSMjyJv+fZ/++RR5M3/AD6yf98itny4/wDngf8Avs0/y4/+eMn6/wCNL2jK5EY6QSN1gl/M1J9kl/59Zv8AvutNYYl/5Yv+v+NJ5Ef/AD7Tf99GspSHymekM7f8sZv+/i/4VastD1PUruG2s7C+uriZtscELhnf6DFXbPSpb64ht7WxmuLiZvLSFJMuW9Md6+6vgZ8FPDX7Nvg2f4h+OmjttVSHzNtw+fsg/uKD1k/T2rixGJ9grr4nsjro0eczvgX+y9oXwc8ON45+JN1BHqECea0F6w8rT/Y/33+hx7V8/ftNfto6t8V5p/D/AINkn0bwqP3TzKds95/gvsPzrj/2j/2mNd/aJ19oVlfSvCFq/wDo2mmQ/P8A7T/3jXlVvpaqu1XidcYxuxx9etGHwrlL2uJd5duiIrYh29nRVl+ZTs7EL1XJ7EyLkfpWiIGHS1l/76SnDSj2MI+sgpP7Gm/55xf99r/jXpu19zhV1sg8mb/n2m/74So/Kl/597j/AMBR/jTv7Kvf+eX/AI+KX+y77/nnJ+dGhWvYqbY/+eL/APfg/wCNRYi/55N/34b/ABq39jvP+ec35n/Go/Jvf7k35GqMyrlP+eX/AJCP+NIyq3/LIf8Afo/41bf7UvQSUkS3c06Qp5rSStsjUDqS2BQ9NQ8j139m/wCEn/Ce69Lrd1ZING0g72LL/rpP4V9/evrJodi7QoxgAe2K6j4c/C6P4bfCTR9GCg3IiE90xX5mlbr09O1YsqYdgR0r86x+MeKruz0Wx+k5Vho4eiu7Pj/9rq0jt/Gmh3KLtMtiQ3vjoa4CP4bXt18NU8V2xaZI53WeIHpGOhHvXZ/tU3ra18UNO0i0Uzz21ssSxoMszP0X619G+Fvh1H4Y+H1l4buY1d/soiuCBwXb71fS/W3g8JRvu7HzssIsdja3ZXPgxI5mpPLuP7prZ1/SZ9A8Q6lpb7Q9pM0fzdSBUUSSyf8ALaIfhX0MZcyUkfLyhytxfQyGSZe1Jmf+8PyNdCdOdv8AlrH/AN8H/GnHSFX71yPwWi6J5Dm/MuP7y/kaXzbj++1dKdIgT708n4Kv+NNOl2Sfed/wdf8AClzIfszmvMuP+ehpBBcjo7j3A5rp/I070/8AIq/4VEx0pf8A9o0OdwVO1tTvvhN8d7zw80OleIZXu9NP+quSctGP7v0/Cun+K/wkt/FFsPEPhryxckbikR+Scf7PvXiE0+mhcCME+pBya7X4bfF1vCFxHY3TSz6MxyqnJaH2Q/45ry6lBwn7agrPt3Pew2KhVh9WxOsej6o81lFxbTNE4kjkU7WRycq3vUsdxP6v/wB9Gvffid8NLXxfY/2/oDo1xjc8UY4lHqPevB9yrIYw+xwdpDj7re9dtCvGvHbU87FYWeFlZ6p7Mk8y4/55S/8Afbf40/F1/wA8Lj82/wAaiQhu6f8Aj3+NP8tfRf8Avt//AIquixx3JUi1KTpZXH5SU5NJ1WTpZyD/AH5Nv/s1QhIh0WEfQN/8VRGqdjEP+Asf5mp1GXG0LU16i0T/AK6X8Sf+hOKhFjJb/wCvvbD/AIBdLJ/6BupV0+ST7ikf9c7ZV/pVm30+9j/1a3n4kJ/MU1K2xTgmrEbEfw0m6pZrCe15ki8se8gb+VQ12x95XR5UouDswpu6nUyrJPaKfTKXdXm2O0ivrtbK2aUkY7A1wkryzOztGu5u+a2vFV6JrhbVXA2jnB71hY/2o/8AvqqN4JJBn/p2H5mjzf8Apj+tOx7p/wB907YPVP8Avuk0mdN0M83/AKZt+dM8+P8A55Tf991Z2j/pn/31Tto/6Zf99VGhVyn9oX/n3n/77pBdwgbnhnVRhT85yWPpV78Yv++q+h/2QPgP/wALW8ZDWNTtkfw3pTl5OMrNMOie9c9epCjBzlsXCLqSUUesfsifs96b4I8LN8UvG8S2lwkXnW0d6cLZxf8APRgf4/fp7V8pftXftNaj+0B4sNnYPLF4SsH/ANFtjkee3/PRvU17R/wUE/aVOt36/C/wrdBdMs9x1WWA4WXH/LMEHGz26+9fG9lD9kiIK5BPILDken0rhwWHlOX1ustXsuyLxNX/AJc03ot/MbZ3bWQGIoc469TV1dXf+O1gP1YU4ahFF962RvypjajZt/y6p+dew9dziEbUoJfvWSr/ALppPtVt/wA+0n/fK/4U1p7Bv+WQH41D5mn+n/jxquRdieZ9yU3tqPvean1Un+tL9ri/5+Zf++W/xquPs6/dd1+jVHug/wCe7fnRyIOdlz7cn/P2360n29f+ftv++6qK0bD5bgOT0CLk0zP/AE1i/wC+RT5eoc5oNqBb/l6b/vsf4V2PwXtE1z4veELF7hmjk1GIMCByM59K883D+/D/AN8113ws8RJ4X+JPhnVpWjWK11CJ39QKzrJ+ylbsXTkvaK+x+u3ia0L2Thcr9K8M1FVhlnL/AConLH2HWvoe/wBl7paTRkMkqq4ccgg186/Fj/iT6Nr1w3ybLWVxj1r8gwzbrcj7n6hSqKNNy7HzV+zp4OPxc/aB13xheR+Zp2kTtMhb7pkHQc54r6j8S2JjdmVcFuorhf2K/DX9ifCOC5liAm1W4e7kJ6sn8NeseKoNqO5HAUtj0xXr5lXdTFezjtGyRz5dR9nQ9pLeWrPzf+P1slt8Y9dROAz+acf3j1H0rhxFG/qv0NdF8UtcTxL8U9dv4yPJa42RnPXHTNYcbw/89BX6PQi1RinvZH5xiJc1abW12V/s6f35P++qBboOrSH6tV9ILeTpdR/iKe1lGoz9qtxhctvfaRWuhitdjMFtGOqA/Wmi3Uf8s8/XP+Nag0wN0uYqd/Zzf8/Nv+v+NHMHKZHkL/zzj/KntAjf8s1rW/skf8/MH+fxpP7LH/P7B+R/xp3DlZneStKIiBjBx6cVqppELf8AMQh/KnnSrRfvamv4ClzIOV6M6z4TfEl/Cl7Hpl/IzaZK21CefKPpn0rV+NHw4QK3iHSowYyN1zbxYxt/vLXnzaVpyqFe/JAGOo59+ler/DDxfZ3lmvh27uDcFV8uAznOR/dz6V5NeDo1PbU/n5n0GEqxxFF4Wu79meExyQnAUu2eA3GM/lUyiNvWun+JngV/CGuNJAD/AGbct5kRPY/3T71zsNsG6zQ/99V6cKkakVKJ4dSlKlN05boZm3HUyfgtPiurJPvfaZP91lX+amrcdv5f8dk31Y/41MIpU/1d9ZR/7oz/ADzVEFJdRt36W163/bYt/JRUgld/uaXM3/XSR6tb5h/rNcUf7oxULtZN/rtZnk/3dw/rU2NbobsuxHsXSViHq5I/m5qF1ZPQ/jUckelj7jXU/wDn3FNiaFnwkbD/AK6NXRTbi9TirpNEm6mbqN1JXUcR7RvPtTJ5/s9vJI2Bt6Um6sbxLLJ9jWFMAyHnJ7V552r3tEcXcWE1zcvO8ke9zuOJOKgOlsPvTxJ9XzWj/ZEv99Pzoj0Bu1xGv0xSudMUZ/8AZMH/AD+R/r/jR/Z1t/z9f+On/GtZPDW7/l5X9KmTwsjf8vQpOSRooSfQx/sVj/z8y/8AfH/2VN+y2P8AfuP+/X/2Vbf/AAiUP/P0v/fIpy+DrVv+Xn+VRzRNFCTIPCfg1vGnibTNA0uOe41HUJhBCixk/N3PXpX6GfF3xnov7F37OFj4c0B0PiC9i+yW2zh5Jv4rhumfbpXCfsE/Ayy0ZtR+I9+d6wKbbTi7/KgX/WTZ9fQ/zr5i/aW+Kc/7QHxo1LUBcFtC09vslgm7AWJe/wBT3NeJN/XsT7L7ENX5s69aFO/WR5DFbHU7ma7vLsyXEzl5JCSS+exqf+zrPbjcx+rV0kHhK3Awboj6AVN/wiVl/wA/TfmP8K91VIrY4fZSOUNnZjo276mmm1tE+9EfwjP+NdgnhbSY/v3B/wC/i/4UjaHoC/8ALTP1lNL2qK9iziylmv3o3/CoGigHRG/76Fdw1h4dX/nkfqx/xppl8NR9FhP1B/xqlVv0JdG3U4jyI/7n/jw/xpvlp/dT/vquzk1XQl+7Zxn6xr/hUEmu6Yv3bIH6qKr2nkT7OP8AMe4/s2/BjwT8bvh/qFrqtpJZa3YThBeWzbXMZ6E5BGfwrzv43/s5a/8ABO7jlu4k1HQ7httvqcAOwn0b0Nes/sU+MbYfEfUtIjX7OL6z3oo4BdDyPyr7L+Ivga38ffDHxHodxCkwmtJJIUcfdkC5BX0r5KvmFXCY7km/dZ6awlOrQut0fkL5A/55L+deraN8D59W/Z78Q+PVjcNZX8cMYA6xD77euR69K84e4uo5pYmZd8TMjAKOCGxX6h/sx+EtP1z9nHw7pV7Asllf2UqzxgD5jJ1bp1Hb+texmWM+p04z7tHDhcOq0mvIwv2KPjhB8Tvhevhu/nB8SaGghdHb5riIf8tFB5P4VL+0baEeB/ELLkubSUCvkj4ufCPxt+yD8UbbV9HuJkshLu0vWoc+VJH/AM83xxj619A+H/jRY/H34Zasxg+x6zBbOt5aKeAT/Euc8fUmvl8VgowrxxlDWLep9Tl+Kc4PD1NJI7/4LWaaT4B8P2ifKsVnEuD6VwP7XXxltvhz4Qk0+2mT+3tRUxww/wAcanqzYPFUfHPxqs/gr8ObC6ZVu9UltkS0tTwGI/ibvt+mK+afA3w+8Q/HLxRP4x8YTSyWLt5jSTcGf/ZQHOFqcFgoyrSxmI0inp5noY3FSVOODw+s2tfIy9J+GLj4H6rrt3bk6hLKLqMt94IDz+nNeYQ2rMqkxjJ96+2fH1tBZfDrxBEqLHBHpkyqB2Pl8frXxRpkJvDDGgJd2CqB719bgcVKvCc/PQ+XzPCRwrpwjvY9W+C37PWq/Fe6Nwx/s3Q4W2y3rf8ALQ/7H/1816R+0h4I8HfBH4e6bpGhaRCda1SUr9uuh5kqxDuDwM/hX0j8MfDsPhfwZo+lQR7EhgXKnux7mvkT9tPxH/bHxgtdMV8xabZLHtzwHP3q8XC42rj8fyJ2hEmthoYXDc1veZ4XChXsD9ad5Tf3KnUlegFG9/U19hc8OxF5B9B+tHlN7VLRS0HzDFhVe1SBB35+tJUu2lYZEIAOwP1qa1layuYriFjHNG29GB5Bpu33NI3FN2d00Cbi00e/wC1+L/w/kjkCm8xtOeDFN6/SvnyWwm027ntbmMJcQSGOSPHK+ldt8KvFh8M+JUimfFnfHy5Ceit61vfHrwwLPUrbX4E2R3f7q5I6Bx0Jry6S+r1/Y/Zke9iF9ewqxEfijv5nlXlJ/dH5UeUvoPyFCOGp1eq0keBqRmBW6jNRFB24+lW9h9DUbWz/AMKMaWgrFLyx7/maSJTnJ5+tT+Xj72U+opFBXtVmbjfctUUxXJ9KdurpTucbi07M9i31yGvrNd6gVRGCRjAxmukkmEaMzdFXJrknuriSRne6cFuu0j/CuA9CmlcYmi3T9VZPqP8A69TQ6DKP9ZcRp9XquhiPW5lb6vS7LD+ImX86g60ki2mnWqfevh+BpottKX/l5H/fw1Aslkv/AC6yH6oak+0w/wDPi3/fIrNq5snYd/xKf+e//j5rU8L+H7PxTr+l6PYSmS81C4S3iXcerdzWb9vX/oHt/wB8D/Cvpz9g/wADr4s+Kk+vTWG230SEsoKDHm+vTt2rkr1PY0pTfQ2pe/NJHrn7Wvi6y/Zw/Zj03wVocgttS1OJdNt1U4cRqP30pxjknoentX516FY6dDbI0roHOc4Y859a9r/bl+JZ+JX7Q9/aJm50vw8o0+EA8FxzIT2OTxxivIYrqIAD7DwP93/CpwVD2VBN/FLVmOIqKpVfZFrdpP8Az3H/AH0aZjRP+eq/99tTPtq/8+I/8d/wpjXpX/mHj/x3/Cu7kZPtEOK6Iesyn/gRqKRNG/vr+ZpPtj/8+Kf+O0xrx2/5dY/0o9mxe0GTJpP8LZ/4Cagk+wf3P/HaVrqRcZhQfdBBx1NfUHwE/Yi8Q/HDwuniBvE+j6LZSNtW2x51wPqMj+VKpUjQjzVHoSrzdkfLHnQf88j/AN8GmfaF/wCeR/75r7p8Sf8ABMXxJYWUr6X48025uU/5ZXts8Cn/AIFyK+Rvij8LfF/wd119L8T2Elo4+5cRjfFL/ukVlQx+HxEuWnJXFKjOCu1oUPh742uPh9410bxBBE2+ynWVkH8aEYYfSv1y8B61Y+IdGsdTtZBc2V3GXil6qyEYwfevxl+0tkHzjkdOOntX13+w/wDtJR+GdSi8CeI7to7C4bOn3MzfLC391j/d/wA5rx86wTxNNVoLWJ3YKsqb5ZdTwj9oPwWfh58afFejbCkaXrSw4/ijc5zX3p+wn4ui8UfBrT7MH9/o8rWcgB7fwk15l/wUS+DU11a6X8RtNiLrboLXUvLGR5Y+5MMDOPXmvCv2QPj/ABfBP4hiHV5Cvh7VNkVyeSIH/hf/ABrKvD+0ctTjrJBRf1bE67M/VrxZ4D0P4leEL3w74gsI77TLpNrIwG5D/eQ9jX5q6N8NdR/Z0/aWvPBl67PpmpW0iW1welxCfufVvX+VfqBoGpW2q6dDeWU6XNtMuY5YzuR/oRXzp+2T4FTWJvA/iuGHffaPqiRtOPvCF+oP07V8zl2JnSk8NP4ZL8T2ZU+apGrDdM+VfEfwwb4p/FtpdVBfw34dt47VYicCaTuB7V6o9rHZwxQ28awxRDEUaDCx/QV0U1tDbq4jiVd7+YTj+L1rB1m8t9Ms5bu8cW9vGuWkc4A/GumeJnWcaa2XQ+lo0IYdyq9Xuzx/9o7xMnh/4dXVsCPtGpH7OiHrtPU187/CPQ217xvolggzmYOxHYCpvjJ8RH+Jvi55rdSmlWgMduueTnue2fpivTv2Z/CDW88/iKddoAMcIPGFH3mzX1sYfUcC7/Ez4fFVvr+O934UfW83iWz8M+Hr3Vr6VYrKxh82ZzxgDoBX5teJfFF3498Zav4huVBkvp/MCk/d9hntXr/7TPxzPiUr4S0SUtZRMDeTIeJ2H8Of7vt+teD28flgbQeOhrLJ8F9Vg6lRe9I5cfilXmoR2iamG/2aTJ9q9F+CH7O/jT4+6m9r4bstttF/r9QuW2QxH0/2j9K+q7H/AIJXXQ07zdR+IttBcY5EGntJEh933DNenVxtChLknLU4oUak1dI+D8f7Qox/tCvbv2gv2W734DpbXJ8T6L4jsp5Cv+gS/v0AXJJj5NeIo9u3WZfyrpp1Y1Y80HcxlCUHZi7afkUZg/5+P/HD/jT/AC7b/n5P/fFahYbTDzVj/Rf+e7f98Uu6x9bj8h/hQIqq23GDwOfx9a960CSL4l/DRrWZxLceX9nkz18wdG5rw57rT16QXH/fQ/wr0H4K+Jre31650xIniS8QFN7dHHevPxsXKCnHdHs5dNQqckn7stDzE2j29y8EjqsiMysPcVZFoW+7ND+LV03xa0GLQPGU7eU5iuj54KkYweoHFckr2zf3x9Mf4V10pqpSUkefiKXsKsoPoWPsdx/eX/vtf8aj8u7h++si/hmoha2cn3Zwn+9DUsdhIf8AVXkbf9tCP51ocxD58w/1mT/vrUW72q48N4v3sv8AUg/yqtv2N8wG3/dIqrisIOKfSBd33f1pa6YO5yVVZ3PSNbuFgsJixILjBx2rkEltV7g/UGuj8SOFtEQkfP1rnty/3VrjsdkHYcL22TpCX+gp41Nj9yyZaj+2JH/y0Vf90VEb9D/GR9BU2ZtzFoX95J92JV/3if8AGl+2X3/PVPy/+vVI3Bbqjn/gVGX/ALv/AI+KLBeRd+1X/wDz9R/lX3/+y6zfB79ljX/G2oOvn3MM94rH+ID/AFQ9cHv+mK/Pq1s5Lu5ghRFZ5pFjUBuSS2K+6P2xNa/4Vp+ynonhK1CwTXYtrJkHUhVy1eNj0pypUF9p/kd+H92E6j6I+A47iTWL271O7mY3F1K00rseWYnJqyscS9LiqVrausWCUYehqx9mb+8n517ySPLW92P2x/8APc/rSMkTdZf1NR+Sf+ei0vlP/eFLQd2M8mP/AJ6/zqPEfq351L5b+35VE6MvYU7Cuy5pL2UOoWctwnmRRyoZQxPI71+kOv8Awe0bXr0+J/DFvDf2moILpILbVZbFsHtGVO0fiDX5n7Bz6HrXt3wQ/au1/wCEtnHot+G1bw4pBjh37pIAOyE9B9Qa8XMqFacFOg9V0O7C1acHao9D6qtNe8ReA75bfS/Fev8Ag+9BwmkeLyLrTpz/AHRcDp9SaXx/4itfjj4A8ReGfFWmLoXinTbVrj7O7B1QBcrJDJ/FGfXnFYFv+1h8NPGWlPbahqsC27ja1tfQfKR6YPT8K+efjh8bNBitotG8C6nPexKjRJcMhzaxMMNHG2c7D6Nur57D4ariKi56bjJdT1KtSlRi2pqS7HhChG63A/KgRhX3q+xgcqVOCp9qjt03feGPpU+xfQV9ykkrI+bu27n2N+zp+2Fp9/4f/wCFe/FBlutKuoWt01WcFlMZ/hlBPIHbGK8Y/aM/Z3vPg9rP2yxkbVPBmoEvp+pwjfHj+6zAYBHvXjMsO7OVUk9Sa9R+Fn7RPiX4b6dJoV1FD4q8HXB2XGgamS0YH96M5BU/jj2rzfqn1eq6tDruuj8zt9qqkVGrv3Ow/Z2/bL8W/s/zw6Xd79f8LH72nXEhDRL/ANM27H6g1+hMnxK8N/Hj4QT63oN0LiyZY5nQ8tbyD+Bx61+YPjaH4ba7azan4S1S78PXGN8nh7Vo2fB9I5RwB9c163+wP4snsPGHiXw6sxWw1PTXn8kngyp0bHTNeRmeBpVKUsTCPLJHpYHESp1Y0nqme2/EDxxo/gDRJNU1e5EUIO1EH3pW/wBmvif4r/HTWPincvZ2itp2hqdotkYkyf7xzz+GK639rzxBPrfxItND+0YtLG3RhE3QMeua8qtW0LR1zcyf2tIDmO1g+SM/Vq6MrwNOjRjWkryZtmmY1K1R4eDtFb+Zo+Avh+3iC4E9xILLSIDmW7l+Vfwz1rp/H/xmiXSh4b8JZhsEUI1zHkEj0X61wGteLdS8Sxx20kgtNNj+5aQArGPwyT+tULezhjyVGD6+lex7D2s1OtrbZHge25FyUiKyslRizLuYnJLHvWlbRCW4iiwB5jAA/WowiDox/OmtMqYwxBBBB7jFdbRlFJH6daT8Srb4N+DdH8BeAbKzutat7KO4vry6YRWenIesty/HP+znNcn5N748uxd3WoeJPiFclsyXrXDaZpSe8YABYfhXz38Efjl4Mg02LSvHMtwLiCUPmVd0Ezj/AJaSjq59idvtXtHiL9sf4e+HrENbahLrFwvCQ2cWAo9BngCviMRQrUqjjTg3J9T6GlOlKN5Ssuxu+M/Bnhz4efD3xT4q1+3smkXS57aC3jQlPMcYQguWYt7g1+dNtErrk/pXo/xm/aC8Q/G69WG8xpmhwMGt9MhfIPu3qa89gVUGATX0eXYaph6Vqz1Z4+LrRrT9zZEn2WL0P5mneRF6fqaTIoyK9SxyXHeWnp+ppf3XofzplLSKHN5TdjVrQdQ/sjWLO8GP3M24MeuKo7vYU3I596UoKUWmXCTpyTXQ9s+OulpeeGdN1iCMMsLLlh3Ruua8VjmH/PFa9/sv+Kt+CTqP3jiyKEdw6dK+eYP3i/KE3enNedgZe7Km+jPYzWKlUhWX2kT5jP3kd/8AdamOsD/xkf7y05ePvxH/ALZH/Gp1ZW6m4X/fRX/kRXpHiEI3xf6mYf8AATTzqEqp++hW4T3HNQPCrHERB/658N/3ycVFmZTlHOPTtRYLl0tbOuAzwv8A7RBH6CoqR0dbfzEjEsR/jj6r9RQhWRNwYYHWtqbSdjKtHS52HieNpZo13HAXPFY/9nr6Vq625N6FHICVS3msbFxIhZxDqFP1qbyUpMD0FLRY0uHlw+h/Oj7La/8APP8AWinbhU2Lud18DvDVp4n+LfhPTzbhlfUInkAz91fmavX/APgol4ia+8S+ENGRiywwvcsvfcRgVxn7IVuknxt02c5ItrW4lz7ldv8AKs39srW31b48zruDLY2UMSgep65rxWnUzCK6JHo/Dg2+7PHobUFcLaj8c16Fpv7PfjfV7GK7tdDsZIZlDozatbLwfUGSuGSaY9wPpVK4tb2dgUuDHjAARiAoHYDbXqyVR/C7HnxcOqPUH/Zh+JK9PDlt/wCDS2/+Lpv/AAzB8Tv+hcg/8Gdt/wDHK8ik0WcEA3DZPRTgfrUZ0Iltq3UjN0IU5wfc0Wq/zD/d9j1//hmD4of9C5B/4M7b/wCLph/Zc+KDf8y7D/4M7b/45Xkv9ht/z8Sf98t/hSnRWVgpncE9Dnj86P3ncPc7Hq//AAyx8Uv+hcg/8Gdt/wDHKY37K/xSJP8AxTNuM+mp2v8A8XXlX9kP/wA/Tf8AfVJ/Yzf8/B/76p/vNrkv2b3TPTn/AGSPijJ97wvbk+p1K1z/AOh06P8AZI+KUWQvhq1APUDVrb/4uvLf7Hf/AJ+D/wB9GgaPMw+WbcPUH/61D9p3RPLTeyPWR+yn8VR08OWn/g2tf/jlP/4ZO+Lf/Qs2v/g2tP8A47XkSaJNJuxOTjsM1E+iSjpIfxA/wqrT/mI91dD18/snfFtv+Zatv/Bra/8AxyvM9Y8Ka1o2tT6Nd2Jj1CCb7O8SFZPmLYG0qTms1tLmXb+9ZgfQDH51paHc3+gaxY6rauxubWdbhQykksDkZ45FO9RbMtWZ0/xG+AHj74U6JZan4o8O3GlWV5gxFnDkZ9QDXdfsR3JX44Q5BAbTbrI+ke4frVP47ftOan8ZdJS31GOcTnGFf/Vx4/ujtWT+zJ460j4b/E2DXPEFw1pp62dxCWSMu+5o8fdArgm6tXDTU46s9CKpUcTD2crooftOS+f8cteB/hKIPoKq+AvgB44+I/hrUPEXh7w7PqOk2DFJbsEIuR6A8VW+MfiOw8b/ABS1rWtIdp7CcgxySIyZx7EV6B8L/wBpnWfhx8Pr3wk8l5/ZckxmVbYYEhPZuBkflVXq0sNBU17ySM+WlWxMvaS0uzx3SvD1/q+s2+lwWjyXtxMLeNHZYxv3YOSx4FeqL+yX8VF/5lqH/wAG1p/8crx7UL2417Vry/dWiaaQynjoxOcjPSmDTp2BId8Dq2z+mK7Pf01OFuMG+U9k/wCGSPiv/wBCxF/4NLT/AOOUjfsh/Fhv+ZYi/wDBpaf/AB2vHP7Ll/56P+R/woOmyKfmmKexz/PFO1TuLTseuP8AsgfFd0CHwvFtHb+1bX/47US/sf8AxUUnHhmIA9hqdoP5S15N/Zzf893qT+zZBtBmbJ9MUr1O4Wi+h62n7JfxTTGPDEIwNo/4mVp/8cpV/ZU+KK/8y5D/AODO2/8Ai68nGjN3mZj7JipDpDLgtPKAei9/zp2qXtcdo9j1X/hlb4of9C7F/wCDK1/+O0v/AAyp8Uv+hbi/8GVr/wDHa8l/s1c4805+lC6ave4f8Iz/APE1Fqncdodj1v8A4ZY+Kf8A0Llv/wCDS1/+O07/AIZY+KP/AELsH/g0tf8A45Xkf9nwngTyZ94x/hTxp9ucf6Q7E9Fjh3H+VFp9x6Hperfs3/EPQtNu7+/0W2t7a0jMkzf2paMVA9AJTmvL6tC3iRCv2mdVIKnMRwQexHel+zwf3pv+/Y/xqoqS3YNp6o92/Z9uFvvC2o2LnKxz/dHo3WvCb6z/ALN1i9tGG1reV48Hrx0zXsf7N80aX2uW6sSTGsgB9a83+KNr9i+JniKMDAa48wD/AH1zXnYf3cXUh5XPbxXv4ClN7rQwAoHTj6U4xqew/AAUlLvr1bHgjJl3jDgOP9rn9etRRqVk2n7vrVhpA3ao5CMVRIW9y9jcM8Rwe4PQ/Wrs1nDsW6tmBt5xyG6ofes08sT3NXtOtZPsMkwGIGkC4b7uT/SlF+8EtYO5v6nIf7QbpwMVT3VY1Rv+Jg9VqYLQk3n+6aXLf88z+dN3+7U3d/smgok2v7Unlv7Unmt/dNN89v7pqSrnuX7IqtF8RL6TjKaZJg/VlB/9CNeeftA3Rv8A44+KJWOSs0ajHoFyK7n9lW7MXjfUun/IOYf+Px15v8YGL/F7xMz9WuFz+WK8immsfJ+R6tZWwULdzng+3vX6n/AT9gX4EfHb4R+HvGlnb65brqUAaRFv8KkgOGABUnGemT+NflWvzuiL95ioHvlsV+9PwAisvgv8J/hT4Ku1Ftd3tgkbRnAzMy7z+px9K9Z6bnizv0PyC/bS+A2nfs+fHG98OaNFP/YckCy2xuX3sSfcAD9K8U0Wews9XspdVspLzTEuEa6ihfYzxnrj3r9Lf+CwHw1Mth4b8Z20Tb4P3E7rjG38s5/GvzDMu6PJ5/pUQd7+Rrf3VLufsN4T/wCCZ37P3jTwZpfiXTo9cfT9QtUu4nOpnBRlz/dr80f2nvAPhX4cfFS50bwg040to94gmlDtHk8ZOB2r9ov2SZjJ+x78N5Op/wCEcgH5JivxK/aWZn+PfiwAkYliAI7DylOP1qZX9qooKbvSk35HnGPY0Y9jU2T60ZPrW9iTU8H+D9Y+IHirTvDnh/T5b/V9Rl8m3gQZO71PtX6kfBv/AIJe/Dv4aeGI9a+LmpjVNQ2bp4fPMVrEfT1J+hrkv+CQHwTtrq38T/EzUbdZbhZBp2mSsoIQAfO4yD83bPTnpTf+CoH7Suo+G7yPwppFwYrskqoHITH8QGcZ+uawrT5LRitWEI88mr2SPZ7T9kn9ln4q+bo2gWlva3qkKfsF06yk+24kfpXwp+3D+yhpH7L95pUek61c6ul6GJFyqll/u/dAr51+Hfxg8Y/DXxnpniXTdbvFvbScXA+c7HYdmA6ivq7/AIKEfHvwz+0D4V8L+JPDd8kwmS382zJxLbyFcsG56VLlUSS8zWMYuT5b2t1PmH4QX/g6D4iaIvj2ynvPCk84ivI7VtskanhWXqOvqDX6z6r/AMErvgxLpF3LY2+src+WzRFtQOCw6Z+Wvy9/ZD+HX/C2f2jfAPh6WEzWUl/Hc3qEZBgjbcQfav3203xhaan4q1bw/C6/atPjikcD0etzmm3fQ/nQ+Ivht/BHjbWNAmUu9lcNECe6jufeuh/Z9g8E6v8AFjQNM8f2t3P4Y1KYWcj2cxikjZ/lRgeeK9s/4KX/AA1/4QL9oS7v7eBoLDU2MmQBjJ9OK+Z/Ac6/8J54bc8t/adscn/rt0+lTTk2jWpofsFq3/BL/wDZ98PaXJqWorq1vaxhS88moHCgkD+76n9a55/+CZHwI8d6XO/g3X76O5QY8+G7W5VT7qVr6h/aHCyfAbWw/wAwaC3zn3ljr80/+CYXxN8ZeIf2r77SbjU7q70M2d21xAQFRCv3CQOM5FRzSdXkSVkiFFOg6jbvc+ff2mP2eNc/Zk8fHw9r6JcWsq+fZ6hCuI54/b/ar6Q/YF/Zr+DH7UXg/U7XxFa6mvizR5R9oWG62I0Z74IJz+Ne3f8ABXzQ7C6+FGjai0ca39hJm3kA+dR6fSvH/wDgjGzzfEfx/wCYxbdpcDMT1JLDmtU7tpdByvyKXc+gdd/4J2/s2+GtTh07VLvULG9mAKRzaiRkflXkv7S3/BLyz8G+D77xP8NtQu71bCLz5tHvG3tKgGTsYAdq2v8Agq/c61ZT6I/h77a2rOERBYQs8mM98V9h/CO51jwr+yx4W/4TeSQaza+GoRqT3By5l8nBBz1NZRm25OWyHOKioOL1Z+ADapZqzqyyIVbYVaPkEda+vP2O/wBgnVf2jtOj8V6xcP4d8HBv3c5T99dr6xZBA+pBrwrS/hunxU/att/BWmoY4tY14W58k48qI8yMOoBC9M5/Gv23+L2saf8AAj4HSwaIsejWVjbLa2scKgCBcclfcD1yPahyShz9C5xfP7NbnhMP7GP7K3hdl8O36QS3/c3N+3m/99DArxP9pr/gl0fC2g3niX4U3U+pxwR+Y+hXBBkkH/TNwAPzzX5/fEb4wa78Q/Ft7qkd9cWtkZmWCOF2Vtg6Ekk81+tX/BLP9ojUvjJ8IdU8N+I71r3WPDEwtxPMSZJbcj5S7EnJB4zxWlPnavMio4ws6bZ+Pct/Fa33lz28sciSlZYyMMAPvDpwfrX6sfBv/gnn+z98c/hnovjPw/ca41jqVuHVTf8AMcgOGU/L2PavmX/gqT8B7P4UfF6HxRotqLbRvEg8yaKIAIJR1wAOM19uf8EqrtLP9jPS5pnCQw6lfuSeiqHz+QoTT1MptqzXU/KL9pP4L6j+z58XNY8JanHIYLdjJZXbdLqEenTLf5xXsf7Anwj+Efx98Wat4O8eHUY/EUqrJpbW1z5aSrty+QQckdsEV+iX/BQX9lmL9oT4XPqmjWyDxnoKm5spFUFp4wPmjPHPtX5l/wDBPieaz/bM8C20tsYbmG4nhkWUYZQVxiqWrsHN7p6v+3z+yn8Lv2cPDlr/AMItFqUWrzdGu73f+gAr4UWUnsv5V+iH/BZOZx4u8LRBiEdeQPpX53RyR/8APOT/AL6H+FZwu73Omdko27Hrn7NEgPju9i7SWhbH06Vznx8hWz+K+phQfnjhfn1wBXTfsx7JviXhAT/oUmfwrJ/aWEdt8YLtGHS2gJrzU7Y5pfynryallq8pHm/mkdVJ+gpPMTsGf/dqWOe3j/5hyN9XP+NWItUlX/V2lmPqT/jXsHiWiVQ8kn+rhLVZi0a6mG6VVtl/6aHmgavqT/duYYP91QarPbXF6f3l49wPRImI/XFRqXyl02djbf6+783/AK4//XzSnW/tsi2kcSw2q4OPcd6rx6Iy9I5D/vusX881LbWUED4Mtu7f3VkLn9AKcfiRM21Bo2tUUfbifWqtXdUX/SlPquaqJtbrmmndXIDd7CkyfU07avvSfL70yriZPqaZk+pqX936mmPsXuakD1T9mu5Ft47u1zzLYSDn1BB/9lFch8bYTD8WddPOZHjk5961vgdeJZ/Eezy2FmikiP1K5FN/aGtDa/Er7QBxc2yNz6j0ryl7uNd+qPbfv5f6M0/2Vvh2Pir+0J4I8OSxs9pdahHNOF/hgQ5Y9DX6pftb+Dvifr3xV+G2o+BtAl1HT9Dvobi5aKTYAmfmH4V8pf8ABIn4aNq/xH8V+OrlcWuiWY0+CRhwJpTk4+ig19AeOf8Agpro3hDxVqejtZ6SXtZmjUyaiRkD1wtd1WUY25zxqUKlVvkWx7X+218OV+Jv7OniGz2hJoIRcqXH3Mda/AuSCSB5YZgVkiYoy+hFf0PfCL4l6R+0l8G7bX7Xy7jT9Vgmt54lHAfoVwSa/CX9ovwZP8OvjZ4r0SaMoYboygEcEH0px+NW2ZMV7ji90z9tv2QWA/Y1+Gx7f8I7CP8Ax2vxM/aJbf8AHfxWw5JeI/8AkKOv2y/ZA2n9jP4bE5x/wj0P8jX4l/tAsB8cfFRJRW3pgFxzhVX+QFD/AI8X5Dp/wpLzOE20zdWxJ4W1qHwpH4mk0u5i0CS5+xx6i6EQyShckK3esdMNXQLY/br/AIJgwwJ+x74cNrtEj3Fy0mP+em7nP6V+a3/BRppp/wBpO/E+75VYpmvr3/gj98YLa68F+JvhpdyhdRsLltTtBu/1kEnXaPY159/wVi/Z+1ex8TWHxH020lvNJnBjvfKTJgJ7nArCcbzjLtcKUlFTi+p+dUcR5+fAPaka1jYYyACQWAPDHGOatRxqdu3lS2N5GP8Ax3rXW+JfhD4q8IeEdG8S6tod3Z6Vq/mNZySREGVE6sR/CPrXRdNJityuyPtX/gj18NW1n4k+MPG00bC20qzGn2suOPNkOZO3bHGP1r6s8CaF8U9K/bM1LXrrwxdr4H1K2lt5b0yrsRh/qzjNYX7BGlxfAj9iNfFVxADc3/n6uythfN3fcGfSuct/+Cqnh99WhtZ7HR4YWkVXk/tIn5T3+7XJUnHnV90XTp1JqXKtGZ//AAV2+Gn9sfDnS/FUKEvYMRKwA6D14r8rvAQB8ceGcDrqVt/6Or99/wBpbwlZ/Fn9n3X4VVLu3nsvtMZAzlcZbH4dK/BDwdZS6T8R9Esrhdtza6xBC65yNwm9aqm+WbTJ+Kmn20P6I/H/AILi+IHw9n0Ga7NlFdRwhp0A4CsrcZ+grzT4Dfsn/Dr9lXTdX1XQbeebUZY3kvNUu2DzbQMsBgAY/Cuy+N9w9r8E9WmjkeKRLWIq6MVIyyjII+tZH7Nnxbtvj58EtP1mVlluQsmmamqj/lvGNsvHPXr+NVzL2jSWplyyVFO/u3Py7/4KNftT23xh1oeH9GkMltBKVIHRVHrz1r0P/gjOgj+JHj0eulW//oQr5b/bJ+E8vwh/aJ8TaTLDsguJTc27twJoz/dr6o/4I3gj4nePhjhdLgGf+BCilHkXmbV5c+i2R+gXxY+N/wAP/hXr1nD4tAS+eMPHP9mEhGPQnpVb4jaRa/tK/CKb/hDPFCwrdpm3uYWDRlx/DIBzj2GK+Hf+Cxk8tpN4elgkeGXYE3o23IP411//AARnfxFJ8NfG8l81w/h438Y09pc7C2079mewOKmKc+bmHPloRpyhfm3Pm39h/wCG2sfDL/gohpPh3xkmzWbD7cxkcfLK5gwpGfzr75/4KVyTWv7OWpzw7vl3byvbcu2vmP8Abb+IWmfB39tT4f8Aj5ML/ZmoJFfNGPmeJl2yE47gdP6194ftFfD+P48/AXXdH0mVLo6jZiexmjYFJSRlcH0waH+9pWQfw68ZS66/efzxWaf6OnJHGK/QD/gjrfTJ8cvF9kjt9km0ON5U7M24cmvhLV9AvvCus3mi6lbva6hYzGKaGYbGBHoDX6Y/8EdvhVe2sXi/4h3UMkNhdRR6ZYOV2+eoOWfn6D863TstTKorKx1P/BX+xgm+Fmku2DPDL5ie3/1q2v8Agngzn/gnhqLI7IyTaoVZevBrxX/grL8WbLXJofDtrMsvkyCEbDks3f2xXt3/AATkhMn/AAT0v4+fnm1QD8a5KcuaNRo0rQcHTg97L8Tq/wDgnr+1jF8bPDmpeDdduv8AisfD8zw/P9+5gB4k5Jyeua5Tx3+yGfh3+2/8O/ir4Wts6BqeoNDqlugAW1nYH5lAAwh98/Wvy38BfFTXfgj8bpPF/h+Vo77TtUkMluzFVuId2DG3Iyvtmv39+C3xb0D4+fDXQfGWgsJbG/iE3lsQWt5B1RvRhk11R1SZzVFyyZ+Z/wDwWTb/AIrjwqvYKP5V+d0a+361+h3/AAWSLHx94WUY+4P5V+eYwv8AyzX9ain19WdU9VH0R7t+x9p5uviRfSBMpFZNk/XrXI/tOyK/xz12PgrCkMQ/79qx/UmvYP2ENDkvNY8T3rD92kKQhh6nrXh3x/u49S+N/jGZW3ImoPb5HQ7cJ/JR+NeTSfPmE/KJ6tVqOXwj3Zwfmxf3P50GdT/AB9BU+2L0NOxF/wA8n/P/AOtXtni3K6XM6/6vC/QCkmnun/1s7t/21Y/1q2JYY/uwqfrmnHUJYfuLGn+6o/rU2GUvspl/h/76XP8AOtHSbcw3bNhgwXOVNV3nmf8A5aMv0xV/RlkMspYngYrSKV0RU2NXXpnhliZIi4IxwazF1GVelm/51u6rAZoFKAKV6Vl/Ypf+eTfl/wDXrGDTVjSzIP7Qn/58z+Ypv9oy/wDPm/5irH2Kb/ni/wCVH2OX/ng/5f8A16u4crKn9oy/8+b/APfVIdSZv+XZ/wA6t/YZf+eL077BP/zxf8qRVmWfAevvpnjHSLk27hEulLEnsRivUf2ldOL3+h36kKpZrVmbpz0NeSJaXCMrLE4ZWDAgdxXu/wAVbIeL/g/a6hGN0sCR3AP/AKFXk4l8lenU+R7eDTqYWrT67n3X+yb8QPhR8AP2cW8LQeONPu/E1/HNe3cyocNMwxjp0Xtk59zX5U/FnTYYfiBqjy3LXj3LGVnI6E+mc8VhW2jaleTqLWa8V3zt8okgZ7da6yP4F+PZJvObwp4iuZMY3SWEjGu5u0uaTPLajyuMU9WfpN/wTf8AjX4B+CnwCj0rxJ43sY7rUL972KxwQ9qrYyDz04rwr/goP4d8IfFn4i6f4v8AA/iWxuY70eVfbgU8k/3jxyK+UH+B3xDkB8vwj4iXI2tjTpPmHvxQfgh8UWR0PhLxQY2GChs5sYqXNN35kKnGEL3T1P2W+Df7TPwU+Gfwl8L+Df8AhO7SaPStOjtN7o2SoGOcDGa5a/uP2Odd1SbUbzTvD9zeSkF5JFfJx/wKvyRX4G/FBc48H+KecD/kHzdvwoHwS+Kg6eEfFI/7hkv+FDnd35kHs6a0SZ+hP7dnxA+HviH4L2Xh7wAbFtE0iG4uFtbOIIkUoGFZR69eua/L+2vg8SsY3yfSu8/4Ux8V5YHgfwl4tMLrtaP+zpdrD34pY/gh8QrdAp8DeIyB/wBQuX/CtISSvzSCqk1GNNWsZvws+LuufBrx7pHjDw3LLZalYuCOpSRf+ebgYyvtkfWv2M+FX7fHwm+P3g1bPxQkOmy3MX+l6dqCh4yfpX5CP8G/HmCP+EK8Qkf9g2X/AAqlffC/xh4W0SDxI2m6hptjcSPGs5jI+YdBnGKcpx25iI01LWSZ+tU/w9/ZE8I6y2v2mhadeXg5EMYkePP0NeF/tL/tJ+HvjTr1p4JGrWPh2yuv9FSR0DJawH7xOOA3uOPavzym8R+LZ4DC2s3/AJZ/hWUj+VYg0ubzPMIdpSSWdjktn1rGVOpVa55aLsaxnTo/w4tt9z9ivjX8Z/hncfsvP8Pfh94utPPt7COztYznhU6Z46nv/Svx3s9CQeJBpV1dR2jC6FtJPINyRkNjccdRThaagrbhczhvUSsP61HFpkyksWYtnO48knOa6Iwad2zCU04KKWx+6Xwj/ad+E/hT4R+HPCmrePrLVbmy02KyubkxOFlO3ac57mvzt8Rfs36ZB+0pba1aa/FD8MbjUlv110wSeWqBtwydvXNfL/gt3tPGnh+a/gvNT05dRg86xhdmM6b/AJkUDndtr9uPitr9z8NrfxV4z8Wazp0fwQPh1I9P8OnTsT/a2Hpj5fyp8kr3uSpwgnFLcu+PP2nvg3438D3vh7/hO7SBLmBY1cI24FSCO3+yK+EP2CP2qbD9m34q+KfBHjC/z4b125+1298hLJBP/F3wA3f6V8W+LPBPjHRoYdfu9E1vRNG1R2l06a4jZEnT/Zya5N4LmWQyO0jyHq7cmpUJKTlcvnpun7NXtufr9+3jc/B/44/Dy51Ow1KzufGFrB5dlqIGFUe/c15T/wAEwvGXw7+Cvh7XfFfinxla2er67stItOCkmKJTkFuOvH0r85Zr3WJ7UWzXl7JAw4jLEDFImmapFYpcLHfxWjN5a3G1ghYdRnofwpJTTu2Nuk4qKTP2++KXxE/Za+OM9pL401HTNdNqR5a3HmAceuMVleJf20vhF8EPAv8AZHw/traO3gDeTaRL5MKE9Tyc5r8V1g1U/cuLwf8AAzS/2BqmoyKjLe3bOwCRjL7s/jQ1N7OxSVJNNpux3v7R3xtuPjV42e/LvcQxOx3N/G7dx/SvsH9gr/gpDB8LPDtl8PviOLiXQ7cbNO1Yks0Cf3HyeVHbpXx/rn7OXjvw1Pp9qPDWpXs9zZR3aJaWkjsobqSNtUD8C/iEwOfA3iIk9SdMm5/8dqYTpwjZMmop1Z81RH6+fEDR/wBk7496nH4o8Qro+o6gWLSXALRvKf8Abx1rm/i7+274D+EXw/Hh74f28Wm2McJhhmRPKjiz/Eqjnd7n8q/LKD4WfFaxiEdv4b8UxRj+FdNmx/6DVS7+C/xH1CUy3XhXxLdSHvNYTt+hXFZOcpaOasawjRp+9ytsx/ir8TL34o+MJ9WnaT7P5h8kOSW57n3r9Zv2TPjB8HPgv+zNpPgG9+INpPqE1vPcXZCHCyy/eC8dB2zn61+WK/BXx4hBTwPr6Y6Y02b/AOJqI/Bb4iByyeE/E0RP9zTbj8ulaKUIx5YuyMpc1SfPU1E+M+i2fhH4l6/bWd6usabLdSTwXcSkKyMc8ZzX01/wTh/bFt/gH48vPDHie4lj8G66Q6u2WW1uR/EBnAB718yR/BP4hK+6Twh4hkIAA3abOcAf8Bp5+DPjzjHgzX1YYO4aZNnI7/d61rGcEkmyJQcm3Y+rP+CqPxO8O/E7xZ4Y1Xw5qMepWcagOYjkjFfDn23/AKZtXW3fwp8bW9vm68L6+sNvklprKYIoHrlK5swOxCrnf93B7selFNqz1JqX0t5H3v8AsEeGlsPg7rviO5jMUM9y8pduB5Ua5BH9a+CNe1qTVvEerXrxM7Xd1LOWz3Y5Nfp/4jsU+A37A80ThYL2TRhBg/eM0ww/THTt+ua/LazjBVQcnGee5zXj5b+8rVq3Ruy+R34uXLTp0uyuH2pv+eDfnS/bG/59z+dTAqeiNSIrv92Pd9M17tzyrMauoqv/AC6ufqalTV4k/wCYYW+rU5NNun/5YOP+Amn/ANiX3/PlN/3yaCrSIf7dk/58E/X/ABrY8OzvdR3Ekkfl/NgcVnnSL9etpL+VdJotnLbaeFljIYnJ3Grhq7mcm0rSLt5GWiYDIArFx/tN/wB9GugPKkdjWK8MaOymZcj2rkpvodrViH5v77/99GnfL/z0k/76qTy7f/n7T/vk0vkwf8/sH5N/hWwiP5P+ekv/AH1Rug/57y/99VL9kg/5/wC3/JqT7JD/ANBC1/M/4Urml2Q4i/57z/ka94+DFzD4n8B32hSy+aYS6ZYfwN1/LtXhH2e2/wCgjF+Tf4V3vwS8RweHPG0UL6hF9lvlMOMHG7t2rz8XS5qba3R6WXVPZ11fZ6HnFxYXOiateWDSyQ3FtIY+HI57d60X8e+OY/8AV+MNdX6apP8A/F13n7RXhIaL42i1Rf3drqa7w2OA69R9a8yQwH/lr+lb0ZKvTUrHFiYSw9eUC8PiV8RR08beIx/3Frj/AOLp3/C0PiX/AND34l/8G1x/8XVD91/z1P5Ueanqa25F2OS7NH/havxJ/wCh88Tf+Di4/wDi6k/4Wr8Tf+h+8T/+De4/+LrJ3xf3z+VL5sP/AD0b8qORdgu+5qj4s/E9enxA8Tf+De4/+LpB8X/if/0UHxKfrq0//wAVWVui/wCeg/Kj/R/75/74quWPYLvudPp3j/4t6zZX11aeN/Ek0VmqtKV1WbOGBZcDdydoPHrWfL8VfGV/4NtfDF1rFzc6NbXJu0ikmc7ieoyW6Vv/AA0u7dl1HSLW5WHU7zybnTXY4VrqMl0Rv99HdfYge4Ob4y0vT7C7i1GGB4rK+zIIGG020nR4iOxX73PUVgpR5uVxNnGVtGcz/bU/9xPyP+NJ/acpCsFQJ0JbjJ9qsebY+kn/AHxX2d/wTs/ZY0D40+IdU8a+K7YX3hTw/wALby/dnmC5YNxyo9sH3ro6XMG2j5As/D3iLU7E3tloGo3Vj2uo7R2Q/pWRLdyozRyRiOReCHUqcjrwa/Qn43f8FN774d+PJvDXgPw7p1toemymP7Olqm18ev8A9bFeW/8ABQ7xno3jmP4UeL9K0Wy0U67oq3lxDaIg2yN94Pt9O3es1O+qLdOa3PLP2QvH+ieAP2ivBXiPxXaiTw/bXL+dcLA08SSMm3eQB1HWv001DV9PtviN421zxn8WvCPiT4M+I4ld/D2pXO+e0x0ES5BUfUGvJf8AgklYHUPhx4yuNds9Pn0RtShisnubWNnErDDAEjpu7V82f8FPPBEfhb9pC4vYLWC2s7+3XaqRBY+PRQAKtzSdjmcXJ6Haf8FLtf8A+Enk8D3XhLWdJ1X4a2liINNtdMuWbymPDF8ZyeBjpXw0bi5SJpHSRERdzu8TKB+lfq5/wT2161k/Y01zVr/Q9K1e60C8nSA3llG4OMdeP5YrzjxV+3X4I+K3w2+IPhvU/Bum+FNVFtJHpl3BpqFLiVGwyh8EUnUinylwpSaueC/spfAb4efErwrrmv8AxM8ZjwtamVdO023hyZXmP/LRgUOU+mD713n7Yf7RvgPSvhZpnwW8CaBa3Oj2EcajU5k2OrD+PzMD5j3NfZHwJ8fQX37DmifES78PaJd6xZ2hy0+nxlGKy7MkADnHv1r5m+Kv7Ufw/wD2m/2dvHFrZ+FtL0bxDpiRzq0FkiPIu7DbW5rKdTVJnVTpymro/PBZJm/iYfQmnxXl9BLHJFPJFJGQUZHIK4/Gpba5hdFJzzUomhIYYPHGR/e9Md66NzG2tjqNd+PPxL1m/sb9/GGtRXttapYpNBfzK8ir0zhsZq7q3xB+MGh6Vaahd+PvE6Q3EjQ7BrFxuSRRGxQ/P12v+YNWvCnhGa3urAtZi98Q36f8S7SZflWJf+e05/hX2yD71o/E20tpfASvaXgv7G01SOxi1CT5fttwI5XuJwP7uZFA9lXOcZPK3TjJRSNuScouUmcYfjX8U26/EPxL/wCDe4/+Lo/4XX8U/wDoofiT/wAG0/8A8VXMeQf+ekX/AH1S/Z29vzrp5Idjk97udL/wuz4pf9FE8Tf+Daf/AOKo/wCF4fFL/oofib/wbT//ABdc15R9B+dM8r6U+SHYV5dzqF+OHxTX/moniU/XVZ//AIqk/wCF2/FT/ooXiT/waz//ABVcv5Teg/OjyH/2fzpckew/e7nS3Hxj+Jl1BLDN488QSxSqVdH1OYhgf+BVqfs9+Abn4m/GXwt4eOXjur1JJmH8MQ71wfkyf3R+dfcP/BNz4bGC68QeP7+EJEiDTrBpOct/G4+nY1xY2rHD4eU4q3T5nRQpyqTSOl/4Kg+PotN8K+E/BVm6q1xKLyeJeoRfuDr09a/PSCPZ0P5163+1p8SZvi98dvEGp25Mmn2T/YbTaDjZH1PXqfavLYtFv3+7byfiG/8AianLqH1fDRi99/mFeftKug1Ll4+iKfrVoeIL1PumJPogpv8AwjOrf8+sv/fP/wBan/8ACL6l/wA8G/Nf8a77mWor+IdUb/l6VfoKr/2zqf8Az8v+ZqT/AIRjUv8AniP++1/xp3/CNaj/AHY/+/gpaF6lV7y/l2j7VJk+jGu3srcpYxI5Mh25JY81y1n4cvTexB/LVc84mBOK7sQhQQOhGK3pa6nNWb2Ke2sy+hhScO+4buuMVqVV1Fd8BO0Er0rzacrO53NXMz/RP7z/AKf4Uf6J/fl/76qD5P7hpd0P/PGX9P8ACu0yuWM2f9+b/vqm77P/AJ6Tf981B+5/55S/p/hSYT/njP8A99f/AFqmxXMyfFp/z8TflTYRBbyxyRXcsbxsGVlByCKr4j/55yf99/8A1qbiP/nmf++qUo8yaKVS2qR9S6zpsfxz+C6zWm1tRhXzFz1SdfvL+NfLMcdshdXkkjkjba6tHyDXsP7MvxCj8OeMv7DvXEen6qfleRuIp/X0APemftOfCx/Bnica3aQEaVqjD5QDiOY/w/T/ADmvIw0/qld0JbPVHs4pfW8PHEparRnk/l2n/PZ/++KZ5dr/AM9HqoJc9E/U0fan/uD/AL6/+tXs3PC5ixti/wCex/Ko8R/89T+VRee//PM/lUm9v+edMkPk/wCeg/Kk2L6n86k8wf3G/Kk8wf3B+RoHqdr4U+C3jDxdbJe6NpP2mHOQ6XCKV69Ocjls/gK9WvvCD6h4Xu7bxelvJr5RX2WUoZrtl4DsduBJjjIwMdq+dre/urPH2e7mtwO0MjIP0NXv+Eq1wrtbVLpxnJ3ybiT9TXHUp1JO6Z005wirOIzWfDl/oZzdW1zDHuxuZD/jX6u/8E0Wgu/2LfE8Vj/x/C+vRKo+9uKDZX5NX+sajqq7by8nuUznbI5Ir6+/4Ju/tWaT8CvHGpeFfFc62vhbxIVf7XKSUtrhRjnsFPfjNdEbpWZzTTfwnyP4+SYePfEJuBmdL+QMfpWVeX19eWdtaXF3PJaWuRDDISyRJ3Cg8hfQZr9Hf2g/+CZuqfEb4g3/AIx+F3ijw5JoOqSmeSK+uiiox6hWRWGK83v/ANhbSdH/ALD8I6R4jtvGnxBvdQg/tGfTnVbGztB98B2I3H8fwojKMUrltubdj3vwn4D8bfDT9gHwZb+DdDvL7xPd3cWtyw264fcZlYBsH7uGPHX3rJ/4K5+CW1bwX4S8Yx2jQPGojnR1wyg+taX7dH7VPjr9mfWPDOh+BrmKDSbexity8apJH8oGO3Xj+ddp41i8Q/tW/wDBPi11DXbTZ4vmtmn+zYVWYrJgYUtnlMHk5zXO3eXMPlcXG/U5r/gmLeaVZ/sieOJtYhNxpkOpzvcRjuNgY14T+3x4s+F/iv4NeHoPhjZ2enWOm38ontrZQro7HJJPWve/2AvBOseGP2NfHmm6zYGxu7ye5liikkTLrsx03e3evyi8WaVquha/rOkXpltXivHWe33cZ7HjNaNc9S8X2HBKEXKa6n7F/shyaHB/wTj0lvEhl/sRoZluTb4DhTcdiQRn8K+IP2y9V+Gmn+BPA1t8Hkaw0+1hlsrt9o8+6DHOZSMBj9AK+4/2bPh9qGtf8E+9J8Dz3NtpOsXtowjjvZEXaTJv+YbvX6V8q2//AAS+Pw+8NeIPEHj/AMf6df2GnWD3Frp+kzne03oQ2cj6c1U1712Z0rJWsz4QgQRgADp617F8I/hVeazoZ8XSR2/2CK4a1hurrJiilXqzIBk/nXlEtn5NzPEjiQxOynnHArd0Hxp4j8NWE1jp2qXEFhM297XzMxlu7YPeiopOPu7mkWoP3j1fU7SRLS6trZ7nQ9Du3xqGvammL/VR/cjiHIT2GPrXC/FzxBbtFonh+ygFlZ6XCZRbBg5gMgA2sehcbeTgdT0rCuPF+tzM8pRnunGPtUhaSQe67mIX8BXNtY3DSNI0MrOzF2ZuSzHqT71lTpNNOZcqujSItp9vypfK+n50/wCyXH/POT/vmmbJf7rf98t/hXZc5BfL9h+Zp+D601I5W/gf/vlv8Kjw3o35H/Ci4aD9g/uik8sf5NM2N6t/3yabn3f8qYeZf0bQ7zxDrNpplhC0t3dyCGJAckt3/Cv0R+I/iuz/AGW/2XYNH051OqG3NhbMvV7iT78nGOR2P55r5+/Y0+HCTarL4zv0Agtt0VkZRxuH3pPp6V59+1T8YD8V/iM9taTL/YWjk29uNxIkk/jk9/avn66+vYqNBfBHV+p6sI/V8O6r+KWx4zCkrMzHeWZtzNk5Y9yfrU4QjpGw/A1LFLKvRj/n8KX7RL/z1b8v/rV9BZaI8q3Ug2/9Mm/75FGR/t/man+1S/33/L/61R+dL/eb8v8A61LQrUi3L/cf86XMP92b/vs0/wCf++f++TTQXbgA5+lGhLbR0vgiwSW+luArlETBBORmu22VQ8KaYbPSYwwKvJ87/WtryR71vG0Ucsm5MwdtRugdCp6GpttN214MZWPZsc9LGyS7QDimeY/98/lWzfDyQsxVSveqS3ob/nnXpxkpK6OdqxT8xv75/Kl86T/nq35Vc8weqU/DeifmKq4crKP2qf8A56N/3wP8KZ9suP7x/wC+BWpt/wBpf++hUkduzfeOPoRS5kVyGPHfXcLo6NtdCGVwnII719v/AAk1nSv2lfg/c+HtZYf2zaReXMzgb938MyZz+PWvkDyYv74/Sun+Gfj+8+F3i+z1qwdHjQ7Z4EkAWaI9Vx7dq8rHUXiYXj8S1TPUwVb6vJqXwvRo4/xn4W8SfD/xVqGganGkN7aORtZB+8Qfxr7Vkpdam38S/wDftf8ACv0C+L3wy0T9pn4d2Hi3wu8U2uJGzWsqEf6QB96CT0Pp0r4buriDS7qe0v2jsLyB/Klt7k7XRvcelLB4x142a95bojE4X2M20/dexgfaNR9V/wC+RR9o1L++P++R/hWt/bOm/wDP9af990z+3dN/5/bT/vuvT5mcFo9zL+16r/z1/wDHV/wpG1HU16Mf++B/hWn/AG7pn/P9b1E3iLTG/wCXy3ov5Csu5jvqWor0Zv8Avgf4Uf2lfD725fqB/hXrHw+8N+GfHOkysL27bUYm2Nb2apJI5P3fLiOPMJ/uhx9a1pvC3geOym1BbbWb/REO2TVbSeKY2h/vXFt5aug/GsHiYp2aKjQlJXUjw46neDuzfQL/AIVBJd3MqlWyQeSNo5Pr0616dr/h3w7ovli/S9jtLtfMsdZ091mtZ09dpUMD/sk7vauN1nTRpMiYkF1byjdDcwLuSVfUdMfStYVFPYidOUN2VtN+Inizw/bC203XL22t16RByyj8DkVRn8c+J7jVItRbWbkXkIIjlRipQH0xih7hUQsCxUfxMMA1ELhGJI+6OpwCPzFbcqX2THmktmM1vxb4i8SwrFq2qXWoorBgLly/Srtv8SvGVhDHFB4j1GNI12oqzuAoxjAGcVU+1L6n9K9P+GX7Pnir4qeH9U8RWMC6f4a01T9p1e9G2IN2VB/GfpUSlThG8gXtJvRnnkHxT8aWyhI/EF6kfP7sOQvPXisS61fUdU1Ge/u7yWW8nbdLMeGc+pxXtPiz9mXxp4T8BQ+L5ILe+0mSPzpFtj+9t0HUuvf8K8iEqnB3Kq8EHGcjvipp1KVTWnqOSqR0mywvjTxHaoqQ61eCNRtVDKxCj25q1bfEvxlDkLrt8VbIZXmZgwPYgk1mK+cASpnsCp5+lPV+Rt2tnttxj8c1rZPdDUmldMo4naRnlkLszFifUmpx5jHCncR1xW74Y0efxNqsGn2iQtJLy0sh2xxIOrsewr0fwx8M28aGWLwn4PuvE2n26/6Zrl5FJHbhvVFTt/wI1EqsYfFoONKVTY8bV5F6Fnx1wT/jTjPL2lZv90sa+jbz9nmx0+1iXUNE1+yuJF3FYNPlmnm/3LdVO38ZDWZ4u+Fvhr4c+Hv7R1bRPEVlNdJt0yy1iZEu71/+ehgRQ0Uf+8SfesliqcnZMqWGqR3PBftF1/z3b8j/AI0n226/5+H/AO+2/wAatedef3H/AO+D/hR9qu/7v/kKukws+5XW/u1/5eH/AO/hp/8AaV9/z8t+f/16k+1y/wDPOP8AIUnnzf8APKD/AL9CkFmhn9qXn95f++a6LwB4c1Hx14kg02FUWEnM0wXiJfc+tZFgl5qt7Da2lkk1xL92MA5H15r6L0a20z4L+DJb2+Mf2krumYD/AFz/ANxfauLFV3TjyQ+Jno4PD+1lzzdoo0fjX8Sbf4XfD2HwxoTeVfXkYhiSLhoY/U/7R9f0r5OszLFGNrAYGPujn1zV/wAQ+JdQ8a6/c6rfkPLN/qwx4X2HNMSR0XAhhx7yCqwuH9hCz3erMsZX+sVLrZaIVdTu1/5aD/vgUf2td/8APX/xxf8ACnfa2/594v8AP40z7e//AD7Rfr/jXccNvMX+17z/AJ7H/vhf8KT+2r3/AJ6/+OD/AApP7QP/ADxh/I/403+0D/zxh/I/41Nir+Y/+3L7/n5/8cStDw7c3+r6tDCsuAT852LwPyrL/tJ/+eFv/wB+hXo3w90pjZNqEsUcZm+WPaMcetVZkSfmdIIQq7QMDGOKd5I96s+SfQ0/yT6GtbnMcdsHvUeyrOwe9N2183c+h5SpLAs0bI2drVinR44mxs/Wui2D3qnfRNjcvWumlU1MnG5lrpMbdj+dP/saP+6fzqxDJubGat5969C5gtTK/seL/nn+ppn9jQ/88z/323+Nbe4eg/Kjb9KkvlOebSLZf+WJ/wC+2/xqGXSbQknyTnnGGPGe1dLJEP7tRyJH/d/SquLlPRf2aPjzN8FPER0+7eSbwtqEgF1BknyJP+eq88Zr3j9qP9nHTvijpB8f+EYbe61URebOsIBF3H/eUY+/79PavjqaAMCPL2j2HQV7d+zb+0nL8LNRTQPEDyXHhuV9qzHJNn7Dn7ntjPvXg43D1KcvrWG+Jbruevh61OcPq1fbo+x80y6dDBK8UluI5V4KugBDehGOKT7FB/z7R/8AfAr7p/aO/ZhtPiBZyeMvAohOpSr5s1pAR5d4v95CBw34/hXxJcW89pczW08bQXUR2yQSjayN7ivTweMp4qHMnZ9jzMTg54WVpap9Sj9ji/54r/3yKb9jj/54J/3yKvbT60m8+or0E77HFpexZ8Na03h3UUufspa3Y+XNEvykr2IxjaR2Iwa9pstRt/EM8Grw6ibTUWTadbhgzHdD+5ewjnd74A9q8JPUHdgj070ttf3VnOJoLiSKVejo5DY9Cc5b8c1zVKHOjalW9mz3yPw+9tHdRwvppsLlt9zZQ3sN7YTN/eCs6vE3+0Du965jxn4F8PaNoN9M9zLp+8ebbaerecPO9FBwQvtmuDT4geIowQurTgn+IkFvzPJ/GsO7vp9QlMt1PJcyH+KVixrKFCcHe5tOvCUdtT3L4DfCfTrzRrfxvr+ljxBplvffZ5NLDEZjC5J+v+cV9K+MP2Wfhj8bPCD6h4LitdG1MR5t7iyzHGZP7kkfJB/KvJf2OPHOn3eiap4LvdkV4JPtNurtjz1YYIH+1XrGlXdx8JviBBc20rNp2osEukQDbKpO0yFcjEgbqRgY7V8xjK2I+sNRbUlquzR61ClTdFNLfc+Grb4Zau3xMs/A9xbmHWbjU49NKkYAd32g/lX6h/GnQ9M+H2g/B/4baJCLfQxq0UTWy/8ALRIo925/7xJ65GPYV8XfFv4haPp37aGh+IYXj+yaZq2nyXsw5VmSTLNxX2P+1DerbeLvhfrJYLbW2ozgyKeCGgYhvp8orXGVqlV0HNWTTdvM56NOMXNrocd8G9UOueBJra7C3EEd5d2jxOuVeJJNoU9+lfnz8R/A/wDwjPxW1zw1psbS+RqBgtY15PzfdFffnwbtl8N/DGO71FxaxStcalLLJwIkdt2GP1r4h8MfEvT9S/aZtvGF8i/2TLrouSr9PK34GfwrPK1OFavOn8JpjuWUKaluz7D+GH7F3w5+Efw//wCEp+LHl6rqJjEkttNMwigJH3FUEMWz7186/Hz4P6Xa+FH+Ivh3Rz4W0K8vjDDpUpJPk/wvg8g19WeNdXl+NPxUjs2PmeF9JXei7spIB91vQszdO2O3evJP28fHVnpfw/sPC8cifb76VJGhA+aKJegx2pYfE4h4qEZO8pavskXUoU4Um2tEjz74QeHfAnhH4d6hq2tano+uarqCpHLZtdFY4EX+GRVG5ge+1hU1z+1Hb6HqenCOfV7m1sH3RxWEZ03TYR/dSCPBI/3y1fLUEUsT744pIn/vRrt/lxV9NU1eMYV7jH+0u7+ea+klhFNtzd7nmRxcoJKCPaPEPxp8ca9JPrFz8VNQm0+Zt39m6bfy20j+yoMbRXk3iTxR4g8X61Nqup6nc3d5IvlmSWdmIT+4CSSB+NUP7R1GVizozk92TJ/PFOTU72PpDn6xH/Ct4Uo00uRGMqjn8TGeZqH/AD8Tf99mm/atQ/57n8qmOtTJ963T8Fal/ts/8+0f5GtdTEj+3XX9+L8hUsCXd5OsNvEk0zfdjVTlvpzU1heXmq3qWlpY+dcv92IR81794Q8EWfgHS/7V1z7PDexLukYjiH2Hqa5a+IVCNup24XCyxL391dSL4feB7T4d6O+t620Md8o3ynH+pX0HvXiXxM+Id18SNdzGxh0iBttvEMj/AIEc96ufFP4r3Xj27a0tC8OjxHKxjgsf9r1rjIbeRFCiFwo7YqcNh3zOrV+J/gaY3Ex5VhqPwr8QW2Rup/Adqk8iP+6KesLL/wAsn/Kk2H2r0jyRmI/9r86MReh/OlwKNh9qCOUNq+ppPLX1NLsPtS+UwzuAXHBGe9APQv6FosmuanFaRn7x5I7Cvc4LKO2tooI02xxDaoFc18MvCp03Tft86EXM4yEPVU9veu3+zj3qrkN3Knl0/wAurf2ce9O+zj3pmdjzrbTNtWfKHqah2V8xc+lsR7B71G6hxg1Y21HsHvVJtbC5TFaymgm+UAr70/y7n+6n5H/GtOaMsOprNM5R9jPhvpXp0qvOrdTmlHlDZc/9M/yP+NL5dx/z1i/I/wCNPWaFv+Wg/OpfMj/56j862uSU5La7/wCfmL8j/jTGhn/iuv0q8xt2/wCW4/Oq7pBJ1uXH0FMqxWFtM33r2QfQj/Cqk2mu4+a+JGMYJHT8qsyWkL/duz/3yaqyaeP71CuZt3seyfAD9pDVPg/PDo+qTyar4UZtvkliZLI/7DZ+79Qa91+Lfwb8L/H/AEZfFXha6t4NXdNyXMIAW5PpIOx/Kvh6XT2PUZ4wMntXT/Dj4qeJfhNqPnaXO09i5xcWEhJic+uMgg/Q15OIwLc3Xw75Z/gz0cPi4uKo4hXj+Rh+K/Cur+CdWl03WbOSxu4+iOPlk/3W6VhbJPWvtjSvHHgb9o7QvsN7DCupKPmtbkhZ0P8Assf/AK9eA/E79njxB4LeW80nOtaSnUxoTOn1TjP4Vphsw5peyrLlkTisucY+1oPmiePOZV7/AKGofOl/vD8jVl7i4b/Zx94EfMv4dai82X/Z/wC+a9lNM8OzvYj82b0FI9069Nv5VNvb/Z/75NI0Jb+5+RqgGWWt32kahBfWNw1rdwOHimiJDIR6e1ei+Jv2m/Gvi3QrbT9QktWnt87b2OHbMcjnJzjk89Otedtbbv4Vpv8AZ4/uj61hOnTqSUpRu11Gp1Yrli7JlOa9muJZJZZpJJZCWd2OSxJzk179Y/tb6h4g8M+FvDfjK2l1Cw0ScTLe2rk3E6BCm0hjjox7V4V/Zw96Z/Zy4AKBucncckn1zRUo06luZXtsKE6sL2Z7X8bP2tdY+KGi/wDCP6LY/wDCP+HCuySJH3SSr/dYg4x9BXhMO1eAz47c9KuLp+05CgfQU8WxXooopUqdGPJBWQ5yqVXzTZ6p8Of2qPGfwy0e7sLFLO/MgRVkvI2d0CLhQCGH1571534k8V6x4+8Qza3r99Jf6hK24ySHhfYDsKz0hKY2oox35qVGCdEWpjRpQk5wjq92N1KsoqMpXRJGx/56y1NvH/PzN+VQxzRf8+y/m3+NSefF/wA8F/M/41vZgTRuB1vZ/wDvo/40yS7lX7t9KfrIaiZ7dv8Al3I+jU+2gguZ0hitbiWdukScs36cVm9FdmkfedluMGo3i7SblyD/ALVbXhLw9rvjTUFtNOBfd/y2KDYv1OK9N8D/ALN02qpHfa0JNMhb/V2gIaV/0wv410fi/wCKnhf4S6adG0GCK7vh1jg5Qf7xHP6151XF8z9nQV2erRwfLH2mJdl+Je03SPD3wZ0BdQ1O4jlvVTP2kgeY5/2RXgfxH+KGqfEe7MeXs9IT/V2+eWPq3qazNd1jXvHWpG+1OSS5mz8oB2qn0Bog8M30hJEEcefWUcVrh8N7OXtamsmZ4rGusvY0Fyw/MxktWjGAxx6VMAy/xN/30a34/CNw33riAfRxUw8LRL9/U7f8DXa5LoeV7OXQ57aPf/vo0v4mtyXRtNt/v6oj/wC5UP2fRf8An9m/74/+tT50V7NmPg0n4mtUjSz9xrt/+AqKqSwJ/wAsopj/ALzLVXE42Kv4mun+Hng5vEurCWbmztm8yU+p/u/WsjR9Du9b1CKztYvNmbqFbpX0L4d8O2/h3SobGKPB6u5+8x9T70XMXqWhCqgBVC4GBjsKf5X1qx5X1qTyR70zOxX8ke9P8ke9WfK+tO8r61VwseV7KZsqzg1HzXyfMfU8pX8r60zyvrVrBqPmruRZlZgW7VSv7Vpo90f3/etLBpvlc962hNwdzNwvucyDep1J/wC+R/hS+de+rf8AfI/wrW1FJlXMQB+orKOo3OcCMk/7tepGopq6OKUeXcb5l56H/vkf4VHvu/7j/kKsm8ux1T9KBNfn+D8xj+taptmdl3KDPeN/G4+iio2iuW6yS/lWh594eyr/ALzik+03Q+88SfVxWmpOnczjZXJ/iem/2bORhtznOST1NXTqDL964tvwlFQPrQT/AJfLU/8AAqV2LQqx6dd2l3HdW7yW91E2Uniba617Z4D/AGodX0ZYLPxhBJqMI+7fRjEn/Aux/KvD5PEoHWeP8Af8ao3PiSOYHMhcnqVQ1zVqEMQrTj/mjrw+KqYV3py/yZ9da18Pvh98atP+3aZPBFfOOLqwIRyf9tSD+gFeHeMf2evFnhl5JLPZrdoPutanEh/4Ca8us/Et3pN4LrTLu4sp87t0OVz+A4r1nwh+1X4g0yMW+uWg1eEf8tFG2T8xXBGhisN/Blddmek8RgsbpXjyy7o8suILqzdluoprQj/nrGRUfnSYyWbHsM19P2vxg+HXxAiEepeRBM3UX0W39RVfUvgB4S8TJ52lXb2zf9OjiVfy61pHMLO1eDiZyytVFfD1FI+afMP900vmr/eb8q9k1j9mfV7fmw1e0m/2LgFD+dcve/Azx5Yt/wAgn7Uv/TCRT/WuqOMoT2mjgqYHE0/igzhd6/3j+VHmRf8APQ/9810Fx8NfGFr9/QNRP+7Bmqb+CvE6f8wTVT/26GuhVab+0jn9hV/lZn+fH6n8qj82L+9J/wB8Vqw+A/E83TQ9W/8AAQ1qWnwf8ZX3+p8Oas31gIpOtTW8kJUaj+yzmFNv/E04/wC2VP8ALsv711/35H+Nek6T+y98Q9aOTpBsI/793dKn6ZrutB/Yq1Kcq2reILeD1isozM3/AH10rlnj8NT+KaOungMRU+GDPn9VsgVG+6BPrCP8a0dJ8OS65Ksen2t/eOf+eMG4fnmvqWx/Z9+Gfw8tzPr11DdMvR9RuEjX/vkc/rWV4h/aY+H/AIGj+yeGLAajIOhs4ljT9Rn9a5XmEqzth4Nncsup0o82IqKJxHhb9lm91OOKbV7qXTY2/wCWSxhpG+gzx+Ndy138OPgPZl4hENQ7kETTt+OMfpXinjb9ovxf4zEkFsV0e0PVYBhz+OTXmD2s13cm4nuGnmP8ch3H9aawlfEP/aJ2XZGcsZh8Ov8AZoXfdnp/xG/aK17xws9npO7RtJb76o+JZPq3+GK8uWBVJOCzHqzHJNTLA6kEM3H+wKXI/vCvWpU6dGPLTVjyKlariJc9VjQg/uk/8Cb/ABpW8tuqt/303+NSKQ3Y/p/jUqvGe3/oP/xVVch36MrYi/uH/vs0h8g9Vc/8Cq1vtv7g/T/4qmqls/3QT9MH+tLQV5FYW8I/5Y/+RR/hUosmb7q/nKP8KfttOyhvof8A61NKQt0YrTENGnS94w31xToNPkkmWNIS7sdqoqjLN7U6O3Ezqsd1lmO1Uxyze1e4fCz4by6Iseo6mPNvHG5I2wRGPXHrRclpMufDfwDD4T0wTTIH1Cb7zg/d+ldqYQ2c5ye9T+WB0GPpUvlfWi4rFbyR71J5X1qbym9DUnlfWquRYr+V9al8ke9WPJHvT/K+tFwseQbai2Vb8oepqLBr5DmR9XYr4NM2Va20zbV8xFing0nNWdg96j21pcmxAEwMdfrWLrGj3Vw++3vHjP8AsgY/lXQ7abyO5ranUdN3RlKCkcK2m3Lff1ScfQj/AAqrLoAn/wBZqV0/1b/61dhqWls0eYBlvQ1hyR3SHaWw3vjFexSqqotDhnT5dzG/4RaA/eublvq//wBal/4RCwP3jO/+9mtIxzJ965T8Kbj/AKej+RrW7RjaJUHhHTV6xSVKmg6Sv/LBW+pFJNBE3/LWUfQH/Gm+Rb+rfnTHZdh6WOnL/wAusLfV6PPtU+4luPwP+FR+XB/zzb8x/hTN0MfQE/Vj/jQGg438P+wP+2J/xqFrmFuxX6Af4U7cn/PNf1/xpPNX+4n5U7Et31M+eCC4ADRnA7AD/Cm2dze6NJv0/Ubu0b1ilZav7wOsbfgtIzyL/wAsj+IosrWaFzNO9zodK+OXjzRuBq5u0/uXUSuP5V01l+1P4ntV23Wj6bcj/YV4/wCprzZllbqR+a/40eU398f995rmlhaE94I6qeNxFPabPabP9sCSD/XeFX/7ZX5/qprct/2yrZP9b4WvT9Lkf4V88G2m9SKjOns3Uiud5dhpbxOn+1MV/N+B9Lf8NtWEX3fCd6P+3lf8KrT/ALdcu3/RfCUgP+3qH+C183NpCt2H51INNVW3Dj6NU/2ZhOsb/Ml5pi39r8D2nU/21vGF6+bHQ9GtV/vSI8rf+hY/SuJ8RftF/EbxXuW68TyWsLf8srOMRKPyGf1rjTYRH/lp+AYijyof76/lXVTweGp/DBHLUxmJqfFNlC68zVJzPeX891Kf45m3n9aWO0tYwQscgz3yAf5VdHkr/F+lJ+5/uNXWnyqyOJrm+IgPlx5KwNk991PEwX/lmn5GnEwt/C1O3J/zzb8xTuFhnmr/AM8Ivzb/ABp32hf+eMX/AHyf8ad5sX/PvF/33Svcxr3gX6k/4UiloPGqsv8Ayxt/+/QpRrki/wDLC0/8Bk/wpi3EQ+80H4K1L5kH/PWH/v2f8ag017j/APhIX/59bH/wFT/CkbWoZP8AWaXp8n1iI/kwpnmW/wDfi/79n/Gmf6P/AM9Y/wDvg/40D97uMa+tX/5httH/ALjSf/F0wCO6dY1t3Z2+75Z+99BVmx06XV71LW0CTzt/BGCTXuvw5+Flv4bVb7UVjudQ/hJGVX6CndGdjK+Gfwsi05Y9V1KHdeMP3dvJjEfv0r1VE3HJ65yT6+1SCLjByV7qe9SrHtqbk2IfJHvUnlfWp0i3U/yvrTEReXTvJHvVnyvrTvK+tVcmxX8r60/yvrVhIt1P8r60XEeK7KbsHvVnbTNg96+Luj6yxU2D3pmwe9TuhWmba15kTZkOwe9R+UPU1PtpNg96rmM7FbbSbB71LsHvTdtXzE2ZDtwepqhqGkR30OR8j/7JrT21HsGemK3hJw1RMoKRxdxp8to+14txqEwXSvgq3/fNds8SyJtb5v8AaPWue1TQp4jvhLSL/vGvUpYnn+I4KlG2xjNaTN/EP++qabFh96aFPq2abInknDqwb+73pQAv3QF+gruWuxy3D7FD/wA/Sf8AfJoayhb/AJaSf9+//r0u4+35VDn/AGP0FFhiulsv/PT8x/hUbC3X/lnN/wB9D/ClkX2NDKW/g/WqIuMWRIekBb/eY0xp0b/lhH+bf40rRBqZ5Y/vCgLj/tR/55xf9+xTPtM39/8AQUm1fU0vFBI3zZP75pPm/vN+dLup32hv7i/lRYLke2X/AG6bs9v1qf7VJ6LUPmN6CgBmP9kUuPc07dTN1AC7G/vUvlf7YpuT6mm8UALsH9407y4/7kn/AH0KjpdoHVl/A0ASYg/uL/38H/xNO820TrFC/wDvStVdjGn3rjH1yKaJIm+9cMPoppXAtLdW6/8ALrbH6mT/AOLo+2Qf8+dp/wB8v/8AFVW3Qf3pP++ant4lupFiiimllP8AyzQZP8qbsgsxpuIx/wAutqQejeW4H/oVbXhTwnfeLr3yLPToPKX/AFlwyvsX/wAe5ruPB/wRN4IrnW90US/8u4bmvZNL0q10q2S3s7dLaFOixjFZcyNLMxfBnw/0zwhDm1iia9K5e4VeV+ma6hEJAHpUsUfPPIxgjsaljiqboLEXlfWpUi3VL5X1qZY9tFyLEMcVS+SPepo4ql8r61dybFfyvrUvkj3qx5I96f5X1ouIrRwj3p/kj3qyse2n+V9aLk2PCdg96hwatbKjwa+Juj62xXYFu1R+UPU1Ypm2tBFbYPem7an2D3qLBrS6IsyHYPeo9tT4NR7K0uSR7B70zYPep9tM21fMTYh2D3pm3nIJA9B0qXBpuDWqdzNpPcoXml29799drf314Nc1qOh3Vod0aebH+tdpsHvTAGAxk49K64VpQMJUoyPOBMxONuG/usMGm+Y3rXeXmkWt/wAyxjd/fHBrEufCPlf6uQyfQivRhXUtzhnRl0ObO9u5/OosH2/Ort7CLD/XWUq/TmqwnaT7ljj8C39a6E0zFxaIky/8RFOyPWP86klkuD/y7xL9M/41H5lx6J+QqlqJqw3Z7/pTto9DTcyf891qMxbfvXA/CgB2RS76Rfsw+9OfwWk8yzH8cjf7q07k2H7qTI9P1pv2u29JPzFH2m1/54n/AL7/APrVNy7MbvX+8KT5f75/74p/nxf8+9M81P8Angv5n/GmKw/EXrL/AN8D/GonaNf+WT/8ClVf6Uvmj/n3j/75qMtn/lmg/DP86LCuSZH/ADx/8jr/AIUsbiP/AJY2jfWQ1ESyD5go9zgfpWnpnh7VdYdRZ2Lzqf4vLCj9RQ9AKUcrr9yO1j+hJ/mTTka4upFSJ45HP8Kc16T4f+Ct1NtbVLmODP8Ayyt1DN+fIr0nQfBekaDGFtbGIOP+WjqC1YOpFmnIzyXw18JNd1hlmvZBptke7gF69i8MeCNK8LxgWdsGlH/LeUBn/PAH6VuRIVYMpIYd6sxpWTk2acokcZBDZO4d6sRxU6OKrEcVFwEjSp44qdHFViOKmSRJFuqVIt1TRxVLHFVXJsRLHtqXyvrUqRbqm8r61VyLEGypEi3VP5I96kWPbRcmxX8r607yvrU+ypPK+tFwsfP1R7an2D3pmwe9fD8yPrbFV4ttR7Ktt81RVpzEWKuDTdtWNtRba0uhEGDTcGrO2oq1uiLMrbabsqfYPekq7klek20/bRtrZOxnYh20bafto21qncixBsoCbenH0qWirvbYlpMjeNX+8oP1FZt74bsL770Ri/65MVrV20ba2jOSM3FM5C58Aj/lleSH/eI/wrKufBmoW3S1km/3Jl/wr0fHvSj5fu/L9K6I1pIydFM8jfSbmPrp11+BH+FQG2x/y6SD/fb/AOtXsxyepz9aGtIX+9EjfVRW31h9jL2PmeLeXGn/AC6IP9+X/wCvT2m2fdgtl+jH/GvY20TT3+9ZW7fWJf8ACkbw7pbf8uMP/fNV7ePYn2Mu544lwW/hi/79D/CnJPI3eP8AKvZh4d0xf+XKL8qux6LYf8+cP/fAqvbrsT7B9zw9EuJPuoz/AEQ1dt9B1W6/1VjM3/ACK9sgtIIvuQxr9FFXcCl9Y8g9h5nkFl8M9fvescVt/wBdHBrotO+DSEKb7UW5/hgTB/XNeixKF6AVZiwpBx8w/izzU+1kX7OJz2kfD7Q9KO6OxSSX/npN8zf4V1VvCkSBUjVFHZRiiNBVmNRWTk2VYfGh49B2HFWI0pI1FTx0XFYfGD6VajSo41q7GgqriCMH0qzGlJGgqzGtMmwRpViNKI1qxGtVcmwkcVTLHtp8a1LtpiGLHtqTZUm2pdg96q5NiPZT9lPqbYPei5Fiv5X1qTZUu2nbaYWP/9k=	#b19203	#3a2957	#c4b5fd	#9b4212	GENERAL	COP	19.00				2026-01-27 11:29:59.946047	2026-02-10 09:11:31.874445	#ffffff	#ffffff
\.


--
-- Data for Name: customers; Type: TABLE DATA; Schema: public; Owner: morales_user
--

COPY public.customers (id, document_type, document_number, full_name, email, phone, address, city, notes, credit_limit, current_balance, is_active, created_at, updated_at) FROM stdin;
1	CC	10001	Cliente General	p@hotmail.com	3140000000	zsacsdf	medellin		0.00	0.00	t	2026-01-27 11:29:59.946047	2026-01-27 21:53:32.872473
2	CC	sdf	sdfsdf	s@sad.com	sdf	sdf	sdf		0.00	0.00	f	2026-01-27 21:53:51.677871	2026-01-27 21:53:56.469973
3	CC	1000003s	german otoniel	s@asd.com	301234567	carreta 39a # 86 - 09	Medellín, Antioquia, Colombia		0.00	0.00	t	2026-01-30 08:55:12.547615	2026-01-30 08:56:22.674825
5	CC	123456789	josue	g@dsad.com	3214859	carreta 39a # 86 - 09	Medellín, Antioquia, Colombia		0.00	0.00	t	2026-01-30 13:15:24.072932	2026-01-30 13:15:24.072932
4	CC	65468498	german	t@h.com	314000000	carreta 39a # 86 - 09	Medellín, Antioquia, Colombia		0.00	0.00	t	2026-01-30 13:12:33.079368	2026-01-30 13:59:23.550634
6	CC	100002323	wilson morales	\N	3216546984	\N	\N	\N	0.00	0.00	t	2026-01-30 14:43:44.656133	2026-01-30 14:43:44.656133
7	CC	1214732164	tatiana agudelo	\N	300121135465	\N	\N	\N	0.00	0.00	t	2026-02-10 19:25:25.673553	2026-02-10 19:25:25.673553
8	CC	94365464	blanca nelly gomez	\N	654321654	\N	\N	\N	0.00	0.00	t	2026-02-11 13:40:35.323525	2026-02-11 13:40:35.323525
\.


--
-- Data for Name: flyway_schema_history; Type: TABLE DATA; Schema: public; Owner: morales_user
--

COPY public.flyway_schema_history (installed_rank, version, description, type, script, checksum, installed_by, installed_on, execution_time, success) FROM stdin;
1	2	create initial schema	SQL	V2__create_initial_schema.sql	554740671	morales_user	2026-01-27 11:29:59.893674	258	t
2	3	create tables notifications schema	SQL	V3__create_tables_notifications_schema.sql	-1275269783	morales_user	2026-02-09 20:50:57.903925	114	t
3	4	add card sidebar color to company config	SQL	V4__add_card_sidebar_color_to_company_config.sql	329238838	morales_user	2026-02-09 23:03:53.084016	13	t
4	5	add service charge to invoices	SQL	V5__add_service_charge_to_invoices.sql	-1505425378	morales_user	2026-02-11 12:18:32.745462	18	t
5	6	add kitchen notes roles	SQL	V6__add_kitchen_notes_roles.sql	-950690022	morales_user	2026-02-11 12:43:51.069089	24	t
6	7	fix kitchen status existing data	SQL	V7__fix_kitchen_status_existing_data.sql	2068183943	morales_user	2026-02-11 13:37:38.372871	26	t
7	8	add delivery charge to invoices	SQL	V8__add_delivery_charge_to_invoices.sql	1388628008	morales_user	2026-02-15 20:46:47.119936	20	t
8	9	create promotions table	SQL	V9__create_promotions_table.sql	-1771422801	morales_user	2026-02-16 09:36:46.717685	64	t
9	10	add performance indexes	SQL	V10__add_performance_indexes.sql	1855408053	morales_user	2026-02-16 10:46:47.760432	100	t
10	11	create kitchen orders table	SQL	V11__create_kitchen_orders_table.sql	-910818306	morales_user	2026-02-19 20:11:37.311688	44	t
11	12	add missing indexes	SQL	V12__add_missing_indexes.sql	606694259	morales_user	2026-02-21 23:44:25.602146	186	t
\.


--
-- Data for Name: inventory; Type: TABLE DATA; Schema: public; Owner: morales_user
--

COPY public.inventory (id, product_id, quantity, min_stock, max_stock, location, last_restock_date, updated_at) FROM stdin;
46	46	43.00	5.00	999999.00	\N	2026-03-07 22:20:13.630676	2026-03-07 22:20:13.633199
8	8	87.00	5.00	100.00	\N	2026-03-07 23:26:44.564049	2026-03-09 21:44:23.001519
23	23	28.00	5.00	999999.00	\N	2026-03-07 22:17:54.11172	2026-03-08 21:37:06.35742
2	2	99.00	5.00	100.00	\N	2026-03-09 21:41:33.364837	2026-03-09 21:44:23.010459
84	84	99.00	5.00	999999.00	\N	\N	2026-03-01 20:25:22.816103
48	48	37.00	5.00	999999.00	\N	2026-03-07 22:49:25.880472	2026-03-09 23:36:30.034885
28	28	41.00	5.00	999999.00	\N	\N	2026-03-08 21:38:56.039655
73	73	47.00	5.00	999999.00	\N	\N	2026-03-01 20:32:54.000145
62	62	48.00	5.00	999999.00	\N	2026-03-04 13:48:49.781483	2026-03-08 21:40:37.774411
61	61	50.00	5.00	999999.00	\N	2026-02-20 20:05:43.205336	2026-02-20 20:05:43.213777
29	29	47.00	5.00	999999.00	\N	2026-02-22 00:15:23.805891	2026-03-07 19:39:10.829445
14	14	48.00	5.00	100.00	\N	2026-03-02 21:58:29.236115	2026-03-02 21:58:29.255288
21	21	34.00	5.00	999999.00	\N	2026-03-07 22:18:03.703009	2026-03-08 21:49:04.095908
53	53	50.00	5.00	999999.00	\N	2026-02-20 20:06:03.894423	2026-02-20 20:06:03.899426
26	26	50.00	5.00	999999.00	\N	2026-02-20 20:06:05.557943	2026-02-20 20:06:05.566163
39	39	50.00	5.00	999999.00	\N	2026-02-16 17:18:43.973058	2026-02-16 17:18:44.000384
83	83	91.00	10.00	999999.00	\N	2026-03-07 23:26:44.580531	2026-03-08 21:49:04.118139
47	47	41.00	5.00	999999.00	\N	2026-03-07 22:50:00.451424	2026-03-08 21:49:04.127733
69	69	50.00	5.00	999999.00	\N	2026-02-20 20:06:25.470992	2026-02-20 20:06:25.4784
13	13	49.00	5.00	100.00	\N	2026-03-04 13:48:47.281428	2026-03-04 13:48:47.295205
55	55	50.00	5.00	999999.00	\N	2026-02-20 20:06:36.314071	2026-02-20 20:06:36.317623
81	81	95.00	5.00	999999.00	\N	2026-03-07 23:26:44.57626	2026-03-08 21:49:04.143175
17	17	46.00	5.00	999999.00	\N	2026-03-07 20:53:42.931032	2026-03-08 21:54:33.587367
12	12	10.00	3.00	100.00	\N	\N	\N
42	42	50.00	5.00	999999.00	\N	2026-02-22 19:31:05.408197	2026-02-22 19:31:05.412959
18	18	41.00	5.00	999999.00	\N	2026-02-27 21:59:53.045576	2026-03-01 21:04:52.443062
65	65	47.00	5.00	999999.00	\N	2026-02-20 19:45:29.911362	2026-03-04 18:14:24.344676
54	54	49.00	5.00	999999.00	\N	\N	2026-02-27 19:58:41.339276
41	41	50.00	5.00	999999.00	\N	2026-02-22 19:31:06.752044	2026-02-22 19:31:06.756805
33	33	50.00	5.00	999999.00	\N	\N	\N
86	86	99.00	5.00	999999.00	\N	\N	2026-03-04 18:50:22.063664
16	16	50.00	5.00	100.00	\N	2026-02-22 00:15:08.566227	2026-02-22 00:15:08.574316
82	82	93.00	10.00	999999.00	\N	\N	2026-03-08 21:56:03.103787
32	32	37.00	5.00	999999.00	\N	2026-03-01 19:55:27.087281	2026-03-08 21:56:03.116285
85	85	98.00	5.00	999999.00	\N	2026-03-08 21:58:34.078163	2026-03-08 21:58:34.085752
50	50	43.00	5.00	999999.00	\N	2026-03-07 22:47:51.222492	2026-03-07 22:47:51.227162
9	9	7.00	5.00	100.00	\N	2026-02-22 18:49:17.697743	2026-03-08 22:08:32.191657
3	3	92.00	2.00	100.00	\N	2026-03-07 20:48:55.156463	2026-03-08 22:08:32.206114
27	27	42.00	5.00	999999.00	\N	2026-03-07 22:31:22.36154	2026-03-08 22:08:32.218268
31	31	34.00	5.00	999999.00	\N	2026-03-07 22:17:59.209981	2026-03-08 22:08:32.228616
24	24	49.00	5.00	999999.00	\N	2026-02-20 12:34:33.204321	2026-02-28 19:53:08.021318
59	59	45.00	5.00	999999.00	\N	2026-03-07 22:17:53.586909	2026-03-08 22:12:58.472039
7	7	10.00	5.00	100.00	\N	2026-03-02 21:34:42.85067	2026-03-08 22:12:58.495459
11	11	199.00	5.00	100.00	\N	2026-03-08 19:37:25.607141	2026-03-08 19:38:58.156344
5	5	19.00	3.00	50.00	\N	2026-02-18 09:37:33.421673	2026-03-01 19:23:27.40919
57	57	45.00	5.00	999999.00	\N	\N	2026-03-08 22:12:58.533644
6	6	94.00	4.00	100.00	\N	2026-02-28 20:01:06.195148	2026-03-08 22:32:54.741157
52	52	38.00	5.00	999999.00	\N	2026-02-18 09:37:32.507511	2026-03-08 19:38:58.2378
58	58	50.00	5.00	999999.00	\N	\N	\N
51	51	42.00	5.00	999999.00	\N	2026-03-07 22:17:52.649612	2026-03-07 22:56:28.349417
60	60	50.00	5.00	999999.00	\N	\N	\N
37	37	32.00	5.00	999999.00	\N	2026-03-07 22:17:54.476778	2026-03-08 22:32:54.783669
56	56	49.00	5.00	999999.00	\N	\N	2026-03-07 22:56:39.604434
64	64	50.00	5.00	999999.00	\N	\N	\N
40	40	49.00	5.00	999999.00	\N	2026-02-16 17:18:44.006921	2026-03-08 22:32:54.793456
67	67	50.00	5.00	999999.00	\N	\N	\N
78	78	33.00	5.00	999999.00	\N	2026-02-22 19:31:04.705262	2026-03-08 22:32:54.805262
71	71	50.00	5.00	999999.00	\N	\N	\N
72	72	50.00	5.00	999999.00	\N	\N	\N
4	4	100.00	3.00	50.00	\N	2026-02-18 18:36:39.191755	2026-03-07 23:10:03.650067
44	44	45.00	5.00	999999.00	\N	2026-02-20 20:06:45.095384	2026-03-08 22:41:07.986342
34	34	42.00	5.00	999999.00	\N	2026-02-20 20:06:51.787961	2026-03-05 19:52:29.45743
43	43	22.00	5.00	999999.00	\N	2026-03-07 23:26:44.585563	2026-03-08 22:41:08.000534
25	25	48.00	5.00	999999.00	\N	2026-02-20 20:06:45.114655	2026-02-28 20:50:45.687291
38	38	43.00	5.00	999999.00	\N	2026-03-07 22:17:54.698435	2026-03-08 19:39:38.74805
10	10	96.00	5.00	100.00	\N	2026-03-01 21:12:56.229528	2026-03-08 22:41:08.013923
77	77	37.00	5.00	999999.00	\N	2026-02-27 22:15:51.52192	2026-03-06 23:03:13.423927
20	20	199.00	5.00	999999.00	\N	2026-03-08 22:41:22.012248	2026-03-08 22:41:35.438679
76	76	41.00	5.00	999999.00	\N	\N	2026-03-08 23:00:45.588225
66	66	30.00	5.00	999999.00	\N	2026-02-22 00:15:22.339927	2026-03-08 23:18:46.266278
79	79	89.00	6.00	999999.00	\N	2026-03-08 23:33:08.407359	2026-03-09 20:32:51.95738
19	19	7.00	5.00	999999.00	\N	2026-03-07 23:26:44.572109	2026-03-09 20:33:27.901275
45	45	46.00	5.00	999999.00	\N	\N	2026-03-09 20:33:27.919006
35	35	19.00	5.00	999999.00	\N	2026-03-07 22:49:32.365465	2026-03-09 20:34:37.5536
36	36	40.00	5.00	999999.00	\N	2026-02-20 20:14:51.328004	2026-03-09 20:34:37.572603
63	63	41.00	5.00	999999.00	\N	2026-02-19 16:46:00.517331	2026-03-07 21:27:42.305673
1	1	8.00	5.00	100.00	\N	2026-02-10 19:49:33.782219	2026-02-15 21:42:57.509002
68	68	49.00	5.00	999999.00	\N	2026-02-20 20:06:36.825152	2026-03-08 20:34:35.879345
80	80	98.00	5.00	999999.00	\N	\N	2026-03-07 19:05:20.468896
22	22	39.00	5.00	999999.00	\N	2026-03-04 13:48:49.154752	2026-03-09 20:34:37.613197
74	74	39.00	5.00	999999.00	\N	2026-03-02 21:11:57.138906	2026-03-09 21:38:48.906227
75	75	41.00	5.00	999999.00	\N	2026-02-20 20:05:49.925685	2026-03-09 21:38:48.918177
49	49	48.00	5.00	999999.00	\N	2026-02-22 19:30:42.173588	2026-03-07 19:33:24.182353
87	87	99.00	5.00	999999.00	\N	2026-03-08 20:39:08.628156	2026-03-08 20:40:13.034284
30	30	46.00	5.00	999999.00	\N	\N	2026-03-07 22:08:59.278053
15	15	46.00	5.00	100.00	\N	2026-03-04 18:14:34.843239	2026-03-07 22:09:08.95465
70	70	39.00	5.00	999999.00	\N	2026-03-01 19:55:28.549952	2026-03-07 22:09:31.214922
\.


--
-- Data for Name: inventory_movements; Type: TABLE DATA; Schema: public; Owner: morales_user
--

COPY public.inventory_movements (id, product_id, movement_type, quantity, previous_quantity, new_quantity, reference_type, reference_id, reason, user_id, created_at) FROM stdin;
1	1	SALIDA	1.00	20.00	19.00	\N	\N	Venta - Factura FAC20260127-0001	1	2026-01-27 21:52:01.973288
2	1	ENTRADA	20.00	19.00	39.00	\N	\N	\N	1	2026-01-28 07:36:59.203543
3	1	SALIDA	2.00	39.00	37.00	\N	\N	Venta - Factura FAC20260128-0001	1	2026-01-28 09:28:32.547333
4	2	SALIDA	1.00	50.00	49.00	\N	\N	Venta - Factura FAC20260128-0001	1	2026-01-28 09:28:32.590976
5	2	SALIDA	1.00	49.00	48.00	\N	\N	Venta - Factura FAC20260128-0002	1	2026-01-28 09:30:12.37465
6	1	SALIDA	1.00	37.00	36.00	\N	\N	Venta - Factura FAC20260128-0002	1	2026-01-28 09:30:12.437179
7	1	SALIDA	2.00	36.00	34.00	\N	\N	Venta - Factura FAC20260128-0003	1	2026-01-28 11:34:50.857239
8	2	SALIDA	1.00	48.00	47.00	\N	\N	Venta - Factura FAC20260128-0003	1	2026-01-28 11:34:50.885749
9	2	SALIDA	4.00	47.00	43.00	\N	\N	Venta - Factura FAC20260128-0004	1	2026-01-28 11:36:58.903494
10	1	SALIDA	2.00	34.00	32.00	\N	\N	Venta - Factura FAC20260128-0005	1	2026-01-28 18:39:26.145397
11	2	SALIDA	2.00	43.00	41.00	\N	\N	Venta - Factura FAC20260128-0005	1	2026-01-28 18:39:26.186441
12	1	SALIDA	6.00	32.00	26.00	\N	\N	Venta - Factura FAC20260130-0001	1	2026-01-30 08:41:49.940112
13	1	SALIDA	3.00	26.00	23.00	\N	\N	Venta - Factura FAC20260130-0002	1	2026-01-30 09:03:07.357506
14	2	SALIDA	2.00	41.00	39.00	\N	\N	Venta - Factura FAC20260130-0002	1	2026-01-30 09:03:07.398593
15	1	SALIDA	3.00	23.00	20.00	\N	\N	Venta - Factura FAC20260130-0003	1	2026-01-30 09:03:43.583007
16	2	SALIDA	1.00	39.00	38.00	\N	\N	Venta - Factura FAC20260130-0003	1	2026-01-30 09:03:43.616391
17	2	SALIDA	4.00	38.00	34.00	\N	\N	Venta - Factura FAC20260130-0004	1	2026-01-30 09:04:15.444842
18	1	SALIDA	1.00	20.00	19.00	\N	\N	Venta - Factura FAC20260130-0004	1	2026-01-30 09:04:15.5122
19	2	ENTRADA	4.00	34.00	38.00	\N	\N	Anulación - Factura FAC20260130-0004	1	2026-01-30 09:06:05.086405
20	1	ENTRADA	1.00	19.00	20.00	\N	\N	Anulación - Factura FAC20260130-0004	1	2026-01-30 09:06:05.115453
21	2	ENTRADA	1.00	38.00	39.00	\N	\N	Anulación - Factura FAC20260128-0002	1	2026-01-30 09:06:51.478461
22	1	ENTRADA	1.00	20.00	21.00	\N	\N	Anulación - Factura FAC20260128-0002	1	2026-01-30 09:06:51.496618
23	1	ENTRADA	3.00	21.00	24.00	\N	\N	Anulación - Factura FAC20260130-0003	1	2026-01-30 09:07:13.320509
24	2	ENTRADA	1.00	39.00	40.00	\N	\N	Anulación - Factura FAC20260130-0003	1	2026-01-30 09:07:13.351741
25	3	SALIDA	1.00	20.00	19.00	\N	\N	Venta - Factura FAC20260130-0005	1	2026-01-30 09:14:11.938974
26	1	SALIDA	1.00	24.00	23.00	\N	\N	Venta - Factura FAC20260130-0005	1	2026-01-30 09:14:11.986946
27	2	SALIDA	1.00	40.00	39.00	\N	\N	Venta - Factura FAC20260130-0005	1	2026-01-30 09:14:12.028578
28	3	SALIDA	5.00	19.00	14.00	\N	\N	Venta - Factura FAC20260130-0006	1	2026-01-30 10:11:31.488947
29	1	SALIDA	2.00	23.00	21.00	\N	\N	Venta - Factura FAC20260130-0006	1	2026-01-30 10:11:31.512463
30	2	SALIDA	1.00	39.00	38.00	\N	\N	Venta - Factura FAC20260130-0006	1	2026-01-30 10:11:31.537171
31	4	SALIDA	1.00	10.00	9.00	\N	\N	Venta - Factura FAC20260130-0006	1	2026-01-30 10:11:31.560314
32	5	SALIDA	1.00	10.00	9.00	\N	\N	Venta - Factura FAC20260130-0006	1	2026-01-30 10:11:31.588618
33	4	SALIDA	1.00	9.00	8.00	\N	\N	Venta - Factura FAC20260130-0007	1	2026-01-30 13:12:39.378028
34	3	SALIDA	1.00	14.00	13.00	\N	\N	Venta - Factura FAC20260130-0007	1	2026-01-30 13:12:39.417975
35	1	SALIDA	1.00	21.00	20.00	\N	\N	Venta - Factura FAC20260130-0007	1	2026-01-30 13:12:39.4423
36	5	SALIDA	1.00	9.00	8.00	\N	\N	Venta - Factura FAC20260130-0007	1	2026-01-30 13:12:39.471707
37	2	SALIDA	1.00	38.00	37.00	\N	\N	Venta - Factura FAC20260130-0007	1	2026-01-30 13:12:39.502104
38	4	SALIDA	3.00	8.00	5.00	\N	\N	Venta - Factura FAC20260130-0008	1	2026-01-30 13:16:08.259297
39	3	SALIDA	4.00	13.00	9.00	\N	\N	Venta - Factura FAC20260130-0008	1	2026-01-30 13:16:08.282833
40	1	SALIDA	2.00	20.00	18.00	\N	\N	Venta - Factura FAC20260130-0008	1	2026-01-30 13:16:08.307901
41	5	SALIDA	2.00	8.00	6.00	\N	\N	Venta - Factura FAC20260130-0008	1	2026-01-30 13:16:08.326277
42	2	SALIDA	2.00	37.00	35.00	\N	\N	Venta - Factura FAC20260130-0008	1	2026-01-30 13:16:08.346392
43	3	SALIDA	1.00	9.00	8.00	\N	\N	Venta - Factura FAC20260130-0009	1	2026-01-30 14:15:05.331918
44	1	SALIDA	1.00	18.00	17.00	\N	\N	Venta - Factura FAC20260130-0009	1	2026-01-30 14:15:05.36751
45	4	SALIDA	2.00	5.00	3.00	\N	\N	Venta - Factura FAC20260130-0009	1	2026-01-30 14:15:05.398269
46	5	SALIDA	1.00	6.00	5.00	\N	\N	Venta - Factura FAC20260130-0009	1	2026-01-30 14:15:05.43401
47	4	SALIDA	3.00	3.00	0.00	\N	\N	Venta - Factura FAC20260130-0010	1	2026-01-30 14:24:55.902327
48	5	SALIDA	1.00	5.00	4.00	\N	\N	Venta - Factura FAC20260130-0010	1	2026-01-30 14:24:55.929585
49	3	SALIDA	5.00	8.00	3.00	\N	\N	Venta - Factura FAC20260130-0011	1	2026-01-30 14:26:01.893813
50	1	SALIDA	4.00	17.00	13.00	\N	\N	Venta - Factura FAC20260130-0012	1	2026-01-30 14:26:22.277372
51	5	SALIDA	1.00	4.00	3.00	\N	\N	Venta - Factura FAC20260130-0013	1	2026-01-30 14:37:22.564967
52	4	ENTRADA	15.00	0.00	15.00	\N	\N	se compro mas	1	2026-01-30 14:41:35.07553
53	2	SALIDA	3.00	35.00	32.00	\N	\N	Venta - Factura FAC20260130-0014	1	2026-01-30 14:45:27.224612
54	1	SALIDA	1.00	13.00	12.00	\N	\N	Venta - Factura FAC20260130-0014	1	2026-01-30 14:45:27.2501
55	3	SALIDA	1.00	3.00	2.00	\N	\N	Venta - Factura FAC20260130-0014	1	2026-01-30 14:45:27.28058
56	2	ENTRADA	3.00	32.00	35.00	\N	\N	Anulación - Factura FAC20260130-0014	1	2026-01-30 14:46:26.859222
57	1	ENTRADA	1.00	12.00	13.00	\N	\N	Anulación - Factura FAC20260130-0014	1	2026-01-30 14:46:26.886427
58	3	ENTRADA	1.00	2.00	3.00	\N	\N	Anulación - Factura FAC20260130-0014	1	2026-01-30 14:46:26.90272
59	3	SALIDA	1.00	3.00	2.00	\N	\N	Venta - Factura FAC20260130-0015	1	2026-01-30 15:35:35.760236
60	4	SALIDA	1.00	15.00	14.00	\N	\N	Venta - Factura FAC20260130-0015	1	2026-01-30 15:35:35.854836
61	1	SALIDA	1.00	13.00	12.00	\N	\N	Venta - Factura FAC20260130-0015	1	2026-01-30 15:35:35.924091
62	1	SALIDA	1.00	12.00	11.00	\N	\N	Venta - Factura FAC20260130-0016	1	2026-01-30 15:36:06.347119
63	3	SALIDA	1.00	2.00	1.00	\N	\N	Venta - Factura FAC20260130-0016	1	2026-01-30 15:36:06.368656
64	4	SALIDA	2.00	14.00	12.00	\N	\N	Venta - Factura FAC20260130-0016	1	2026-01-30 15:36:06.387714
65	2	SALIDA	1.00	35.00	34.00	\N	\N	Venta - Factura FAC20260130-0016	1	2026-01-30 15:36:06.41232
66	1	SALIDA	1.00	11.00	10.00	\N	\N	Venta - Factura FAC20260204-0001	1	2026-02-04 18:39:38.598707
67	3	SALIDA	1.00	1.00	0.00	\N	\N	Venta - Factura FAC20260204-0001	1	2026-02-04 18:39:38.653744
68	4	SALIDA	1.00	12.00	11.00	\N	\N	Venta - Factura FAC20260204-0001	1	2026-02-04 18:39:38.685996
69	3	ENTRADA	50.00	0.00	50.00	\N	\N	ajuste	1	2026-02-09 17:39:55.668005
70	5	ENTRADA	50.00	3.00	53.00	\N	\N	\N	1	2026-02-09 17:40:27.369662
71	1	SALIDA	1.00	10.00	9.00	\N	\N	Venta - Factura FAC20260209-0001	1	2026-02-09 17:42:15.66944
72	4	SALIDA	1.00	11.00	10.00	\N	\N	Venta - Factura FAC20260209-0002	1	2026-02-09 17:42:53.745995
73	3	SALIDA	4.00	50.00	46.00	\N	\N	Venta - Factura FAC20260209-0002	1	2026-02-09 17:42:53.764259
74	1	SALIDA	3.00	9.00	6.00	\N	\N	Venta - Factura FAC20260209-0003	1	2026-02-09 17:45:08.922538
75	5	SALIDA	1.00	53.00	52.00	\N	\N	Venta - Factura FAC20260209-0003	1	2026-02-09 17:45:08.939118
76	3	SALIDA	4.00	46.00	42.00	\N	\N	Venta - Factura FAC20260209-0003	1	2026-02-09 17:45:08.954207
77	2	SALIDA	1.00	34.00	33.00	\N	\N	Venta - Factura FAC20260209-0003	1	2026-02-09 17:45:08.968739
78	1	SALIDA	1.00	6.00	5.00	\N	\N	Venta - Factura FAC20260209-0004	1	2026-02-09 18:59:34.449366
79	4	SALIDA	1.00	10.00	9.00	\N	\N	Venta - Factura FAC20260209-0004	1	2026-02-09 18:59:34.484393
80	3	SALIDA	1.00	42.00	41.00	\N	\N	Venta - Factura FAC20260209-0004	1	2026-02-09 18:59:34.51598
81	2	SALIDA	1.00	33.00	32.00	\N	\N	Venta - Factura FAC20260209-0004	1	2026-02-09 18:59:34.536363
82	3	SALIDA	1.00	41.00	40.00	\N	\N	Venta - Factura FAC20260209-0005	1	2026-02-09 19:01:26.837227
83	1	SALIDA	1.00	5.00	4.00	\N	\N	Venta - Factura FAC20260209-0005	1	2026-02-09 19:01:26.85839
84	4	SALIDA	1.00	9.00	8.00	\N	\N	Venta - Factura FAC20260209-0005	1	2026-02-09 19:01:26.88038
85	3	SALIDA	1.00	40.00	39.00	\N	\N	Venta - Factura FAC20260209-0006	1	2026-02-09 19:30:26.004076
86	4	SALIDA	1.00	8.00	7.00	\N	\N	Venta - Factura FAC20260209-0006	1	2026-02-09 19:30:26.025123
87	5	SALIDA	1.00	52.00	51.00	\N	\N	Venta - Factura FAC20260209-0006	1	2026-02-09 19:30:26.039099
88	3	SALIDA	1.00	39.00	38.00	\N	\N	Venta - Factura FAC20260209-0007	1	2026-02-09 19:34:41.245364
89	1	SALIDA	1.00	4.00	3.00	\N	\N	Venta - Factura FAC20260209-0007	1	2026-02-09 19:34:41.266334
90	2	SALIDA	1.00	32.00	31.00	\N	\N	Venta - Factura FAC20260209-0007	1	2026-02-09 19:34:41.284061
91	1	SALIDA	1.00	3.00	2.00	\N	\N	Venta - Factura FAC20260209-0008	1	2026-02-09 21:02:47.529646
92	3	SALIDA	1.00	38.00	37.00	\N	\N	Venta - Factura FAC20260209-0008	1	2026-02-09 21:02:47.594899
93	4	SALIDA	1.00	7.00	6.00	\N	\N	Venta - Factura FAC20260209-0008	1	2026-02-09 21:02:47.622342
94	1	SALIDA	1.00	2.00	1.00	\N	\N	Mesa #3 - MESA20260209-T3-0001	1	2026-02-09 21:06:48.975326
95	2	SALIDA	1.00	31.00	30.00	\N	\N	Mesa #3 - MESA20260209-T3-0001	1	2026-02-09 21:06:49.01637
96	3	SALIDA	1.00	37.00	36.00	\N	\N	Mesa #3 - MESA20260209-T3-0001	1	2026-02-09 21:06:49.045878
97	5	SALIDA	1.00	51.00	50.00	\N	\N	Mesa #3 - MESA20260209-T3-0001	1	2026-02-09 21:06:49.079353
98	2	SALIDA	1.00	30.00	29.00	\N	\N	Mesa #3 - MESA20260209-T3-0001	1	2026-02-09 21:07:03.317154
99	2	SALIDA	1.00	29.00	28.00	\N	\N	Mesa #1 - MESA20260209-T1-0002	1	2026-02-09 21:13:20.948767
100	3	SALIDA	1.00	36.00	35.00	\N	\N	Mesa #1 - MESA20260209-T1-0002	1	2026-02-09 21:13:20.996318
101	5	SALIDA	4.00	50.00	46.00	\N	\N	Mesa #1 - MESA20260209-T1-0002	1	2026-02-09 21:13:21.028435
102	2	SALIDA	1.00	28.00	27.00	\N	\N	Mesa #1 - MESA20260209-T1-0002	1	2026-02-09 21:13:29.141169
104	2	SALIDA	1.00	27.00	26.00	\N	\N	Mesa #2 - MESA20260209-T2-0003	1	2026-02-09 21:49:11.440027
105	3	SALIDA	1.00	35.00	34.00	\N	\N	Mesa #2 - MESA20260209-T2-0003	1	2026-02-09 21:49:17.832346
106	5	SALIDA	1.00	46.00	45.00	\N	\N	Mesa #2 - MESA20260209-T2-0003	1	2026-02-09 21:49:25.667686
107	3	SALIDA	1.00	34.00	33.00	\N	\N	Mesa #5 - MESA20260209-T5-0004	1	2026-02-09 21:50:53.935533
108	3	SALIDA	1.00	33.00	32.00	\N	\N	Mesa #5 - MESA20260209-T5-0004	1	2026-02-09 21:51:01.07057
109	3	SALIDA	1.00	32.00	31.00	\N	\N	Venta - Factura FAC20260209-0009	1	2026-02-09 22:07:51.87521
110	3	SALIDA	4.00	31.00	27.00	\N	\N	Mesa #7 - MESA20260209-T7-0006	1	2026-02-09 22:27:15.312861
111	5	SALIDA	3.00	45.00	42.00	\N	\N	Mesa #3 - MESA20260209-T3-0007	1	2026-02-09 22:28:29.917823
112	5	SALIDA	4.00	42.00	38.00	\N	\N	Mesa #4 - MESA20260209-T4-0008	1	2026-02-09 22:31:39.400301
113	2	SALIDA	4.00	26.00	22.00	\N	\N	Mesa #5 - MESA20260209-T5-0009	1	2026-02-09 22:39:18.691345
114	3	SALIDA	1.00	27.00	26.00	\N	\N	Mesa #1 - MESA20260209-T1-0005	1	2026-02-09 22:39:40.334326
115	3	SALIDA	1.00	26.00	25.00	\N	\N	Mesa #1 - MESA20260209-T1-0010	1	2026-02-09 22:52:48.071119
116	5	SALIDA	1.00	38.00	37.00	\N	\N	Mesa #1 - MESA20260209-T1-0010	1	2026-02-09 22:52:48.371328
117	5	SALIDA	2.00	37.00	35.00	\N	\N	Mesa #7 - MESA20260209-T7-0011	1	2026-02-09 22:53:38.120468
118	5	SALIDA	1.00	35.00	34.00	\N	\N	Mesa #6 - MESA20260209-T6-0012	2	2026-02-09 23:06:43.340693
119	5	SALIDA	1.00	34.00	33.00	\N	\N	Mesa #8 - MESA20260209-T8-0013	1	2026-02-09 23:10:59.58726
120	5	SALIDA	2.00	33.00	31.00	\N	\N	Mesa #4 - MESA20260209-T4-0014	1	2026-02-09 23:13:36.031127
121	5	SALIDA	1.00	31.00	30.00	\N	\N	Mesa #5 - MESA20260209-T5-0015	2	2026-02-09 23:15:34.262327
122	4	SALIDA	1.00	6.00	5.00	\N	\N	Mesa #2 - MESA20260210-T2-0001	1	2026-02-10 08:52:12.974648
123	7	SALIDA	1.00	20.00	19.00	\N	\N	Mesa #2 - MESA20260210-T2-0001	1	2026-02-10 08:52:13.008177
124	9	SALIDA	1.00	20.00	19.00	\N	\N	Mesa #3 - MESA20260210-T3-0002	1	2026-02-10 08:53:39.155534
125	8	SALIDA	1.00	20.00	19.00	\N	\N	Mesa #3 - MESA20260210-T3-0002	1	2026-02-10 08:53:39.174478
126	5	SALIDA	1.00	30.00	29.00	\N	\N	Mesa #3 - MESA20260210-T3-0002	1	2026-02-10 08:53:39.193693
127	10	SALIDA	1.00	20.00	19.00	\N	\N	Mesa #4 - MESA20260210-T4-0003	1	2026-02-10 08:55:47.995936
128	11	SALIDA	1.00	20.00	19.00	\N	\N	Mesa #4 - MESA20260210-T4-0003	1	2026-02-10 08:55:48.015854
129	2	SALIDA	1.00	22.00	21.00	\N	\N	Mesa #7 - MESA20260210-T7-0004	1	2026-02-10 08:58:58.309803
130	3	SALIDA	1.00	25.00	24.00	\N	\N	Mesa #7 - MESA20260210-T7-0004	1	2026-02-10 08:58:58.324025
131	8	SALIDA	1.00	19.00	18.00	\N	\N	Mesa #7 - MESA20260210-T7-0004	1	2026-02-10 08:58:58.339066
132	1	ENTRADA	10.00	1.00	11.00	\N	\N	Se compraron papas	1	2026-02-10 09:17:14.095359
133	3	SALIDA	1.00	24.00	23.00	\N	\N	Mesa #6 - MESA20260210-T6-0006	1	2026-02-10 09:20:49.176296
134	2	SALIDA	1.00	21.00	20.00	\N	\N	Mesa #1 - MESA20260210-T1-0007	1	2026-02-10 09:22:36.015606
135	11	SALIDA	1.00	19.00	18.00	\N	\N	Mesa #1 - MESA20260210-T1-0007	1	2026-02-10 09:22:36.03398
136	3	SALIDA	1.00	23.00	22.00	\N	\N	Mesa #5 - MESA20260210-T5-0005	1	2026-02-10 09:23:09.161607
137	4	SALIDA	1.00	5.00	4.00	\N	\N	Mesa #5 - MESA20260210-T5-0005	1	2026-02-10 09:23:09.193533
138	6	SALIDA	1.00	10.00	9.00	\N	\N	Mesa #5 - MESA20260210-T5-0005	1	2026-02-10 09:23:09.212047
139	3	SALIDA	1.00	22.00	21.00	\N	\N	Mesa #8 - MESA20260210-T8-0008	1	2026-02-10 09:26:00.665164
140	2	SALIDA	1.00	20.00	19.00	\N	\N	Mesa #8 - MESA20260210-T8-0008	1	2026-02-10 09:26:00.685842
141	8	SALIDA	1.00	18.00	17.00	\N	\N	Mesa #8 - MESA20260210-T8-0008	1	2026-02-10 09:26:00.701508
142	2	SALIDA	1.00	19.00	18.00	\N	\N	Mesa #3 - MESA20260210-T3-0009	1	2026-02-10 09:33:55.287369
143	3	SALIDA	1.00	21.00	20.00	\N	\N	Mesa #3 - MESA20260210-T3-0009	1	2026-02-10 09:33:55.307763
144	4	SALIDA	1.00	4.00	3.00	\N	\N	Mesa #3 - MESA20260210-T3-0009	1	2026-02-10 09:33:55.325166
145	4	ENTRADA	3.00	3.00	6.00	\N	\N	se compraron mas papas	1	2026-02-10 19:24:05.558725
146	2	SALIDA	1.00	18.00	17.00	\N	\N	Mesa #6 - MESA20260210-T6-0010	1	2026-02-10 19:27:17.262052
147	3	SALIDA	2.00	20.00	18.00	\N	\N	Mesa #6 - MESA20260210-T6-0010	1	2026-02-10 19:27:17.313882
148	9	SALIDA	1.00	19.00	18.00	\N	\N	Mesa #6 - MESA20260210-T6-0010	1	2026-02-10 19:27:17.354215
149	10	SALIDA	1.00	19.00	18.00	\N	\N	Mesa #3 - MESA20260210-T3-0011	1	2026-02-10 19:28:34.612037
150	11	SALIDA	1.00	18.00	17.00	\N	\N	Mesa #3 - MESA20260210-T3-0011	1	2026-02-10 19:28:34.646662
151	11	SALIDA	2.00	17.00	15.00	\N	\N	Mesa #3 - MESA20260210-T3-0011	1	2026-02-10 19:34:56.912043
152	1	ENTRADA	1.00	11.00	12.00	\N	\N	Anulación - Factura FAC20260127-0001	1	2026-02-10 19:49:33.783001
153	2	SALIDA	3.00	17.00	14.00	\N	\N	Error contando las sangrias	1	2026-02-10 19:58:20.167665
154	9	SALIDA	1.00	18.00	17.00	\N	\N	Mesa #2 - MESA20260210-T2-0012	2	2026-02-10 20:09:46.503203
155	2	SALIDA	1.00	14.00	13.00	\N	\N	Mesa #2 - MESA20260210-T2-0012	2	2026-02-10 20:09:46.529008
156	3	SALIDA	1.00	18.00	17.00	\N	\N	Mesa #2 - MESA20260210-T2-0012	2	2026-02-10 20:09:46.55674
157	8	SALIDA	1.00	17.00	16.00	\N	\N	Mesa #2 - MESA20260210-T2-0012	2	2026-02-10 20:09:46.580474
158	6	SALIDA	1.00	9.00	8.00	\N	\N	Mesa #2 - MESA20260210-T2-0012	2	2026-02-10 20:09:46.608061
159	5	SALIDA	1.00	29.00	28.00	\N	\N	Mesa #2 - MESA20260210-T2-0012	2	2026-02-10 20:09:46.636504
160	11	SALIDA	1.00	15.00	14.00	\N	\N	Mesa #2 - MESA20260210-T2-0012	2	2026-02-10 20:09:46.667286
161	10	SALIDA	1.00	18.00	17.00	\N	\N	Mesa #4 - MESA20260210-T4-0013	2	2026-02-10 20:10:20.658072
162	11	SALIDA	1.00	14.00	13.00	\N	\N	Mesa #4 - MESA20260210-T4-0013	2	2026-02-10 20:10:20.687336
163	6	SALIDA	1.00	8.00	7.00	\N	\N	Mesa #4 - MESA20260210-T4-0013	2	2026-02-10 20:11:16.622314
164	7	SALIDA	1.00	19.00	18.00	\N	\N	Mesa #4 - MESA20260210-T4-0013	2	2026-02-10 20:11:16.646847
165	4	SALIDA	1.00	6.00	5.00	\N	\N	Venta - Factura FAC20260211-0001	1	2026-02-11 12:21:37.952693
166	6	SALIDA	2.00	7.00	5.00	\N	\N	Mesa #1 - MESA20260211-T1-0001	1	2026-02-11 12:22:19.323568
167	4	SALIDA	1.00	5.00	4.00	\N	\N	Mesa #3 - MESA20260211-T3-0002	1	2026-02-11 12:27:55.3111
168	6	SALIDA	1.00	5.00	4.00	\N	\N	Venta - Factura FAC20260211-0002	1	2026-02-11 12:29:00.474068
169	9	SALIDA	2.00	17.00	15.00	\N	\N	Venta - Factura FAC20260211-0002	1	2026-02-11 12:29:00.504685
170	2	SALIDA	1.00	13.00	12.00	\N	\N	Mesa #4 - MESA20260211-T4-0003	1	2026-02-11 12:31:19.465579
171	7	SALIDA	1.00	18.00	17.00	\N	\N	Mesa #4 - MESA20260211-T4-0003	1	2026-02-11 12:31:19.497852
172	4	SALIDA	1.00	4.00	3.00	\N	\N	Mesa #1 - MESA20260211-T1-0004	1	2026-02-11 13:31:48.134402
173	3	SALIDA	1.00	17.00	16.00	\N	\N	Mesa #1 - MESA20260211-T1-0004	1	2026-02-11 13:31:48.18277
174	3	SALIDA	2.00	16.00	14.00	\N	\N	Mesa #7 - MESA20260211-T7-0005	1	2026-02-11 13:40:52.667346
175	2	SALIDA	1.00	12.00	11.00	\N	\N	Mesa #7 - MESA20260211-T7-0005	1	2026-02-11 13:40:52.706645
176	11	SALIDA	1.00	13.00	12.00	\N	\N	Mesa #7 - MESA20260211-T7-0005	1	2026-02-11 13:40:52.737848
177	8	SALIDA	1.00	16.00	15.00	\N	\N	Mesa #3 - MESA20260211-T3-0006	2	2026-02-11 17:12:40.628802
178	3	SALIDA	1.00	14.00	13.00	\N	\N	Mesa #3 - MESA20260211-T3-0006	2	2026-02-11 17:12:40.656039
179	9	SALIDA	2.00	15.00	13.00	\N	\N	Mesa #3 - MESA20260211-T3-0006	2	2026-02-11 17:12:40.674059
180	10	SALIDA	2.00	17.00	15.00	\N	\N	Mesa #4 - MESA20260211-T4-0007	2	2026-02-11 17:14:46.01209
181	11	SALIDA	1.00	12.00	11.00	\N	\N	Mesa #4 - MESA20260211-T4-0007	2	2026-02-11 17:14:46.033019
182	4	ENTRADA	1.00	3.00	4.00	\N	\N	Anulación - Factura FAC20260211-0001	1	2026-02-11 19:32:55.888277
183	3	ENTRADA	2.00	13.00	15.00	\N	\N	Anulación - Factura MESA20260211-T7-0005	1	2026-02-11 19:33:01.814646
184	11	ENTRADA	1.00	11.00	12.00	\N	\N	Anulación - Factura MESA20260211-T7-0005	1	2026-02-11 19:33:01.838102
185	2	ENTRADA	1.00	11.00	12.00	\N	\N	Anulación - Factura MESA20260211-T7-0005	1	2026-02-11 19:33:01.854551
186	4	ENTRADA	1.00	4.00	5.00	\N	\N	Anulación - Factura MESA20260211-T1-0004	1	2026-02-11 19:33:06.975359
187	3	ENTRADA	1.00	15.00	16.00	\N	\N	Anulación - Factura MESA20260211-T1-0004	1	2026-02-11 19:33:07.001624
188	7	ENTRADA	1.00	17.00	18.00	\N	\N	Anulación - Factura MESA20260211-T4-0003	1	2026-02-11 19:33:12.346958
189	2	ENTRADA	1.00	12.00	13.00	\N	\N	Anulación - Factura MESA20260211-T4-0003	1	2026-02-11 19:33:12.368227
190	9	ENTRADA	2.00	13.00	15.00	\N	\N	Anulación - Factura FAC20260211-0002	1	2026-02-11 19:33:17.304455
191	6	ENTRADA	1.00	4.00	5.00	\N	\N	Anulación - Factura FAC20260211-0002	1	2026-02-11 19:33:17.34696
192	4	ENTRADA	1.00	5.00	6.00	\N	\N	Anulación - Factura MESA20260211-T3-0002	1	2026-02-11 19:33:21.336346
193	6	ENTRADA	2.00	5.00	7.00	\N	\N	Anulación - Factura MESA20260211-T1-0001	1	2026-02-11 19:33:25.365858
194	10	ENTRADA	2.00	15.00	17.00	\N	\N	Anulación - Factura MESA20260211-T4-0007	1	2026-02-11 19:34:51.728286
195	11	ENTRADA	1.00	12.00	13.00	\N	\N	Anulación - Factura MESA20260211-T4-0007	1	2026-02-11 19:34:51.74541
196	8	ENTRADA	1.00	15.00	16.00	\N	\N	Anulación - Factura MESA20260211-T3-0006	1	2026-02-11 19:34:55.838112
197	9	ENTRADA	2.00	15.00	17.00	\N	\N	Anulación - Factura MESA20260211-T3-0006	1	2026-02-11 19:34:55.854461
198	3	ENTRADA	1.00	16.00	17.00	\N	\N	Anulación - Factura MESA20260211-T3-0006	1	2026-02-11 19:34:55.869313
199	13	ENTRADA	50.00	0.00	50.00	\N	\N	\N	1	2026-02-11 19:38:42.304586
200	78	SALIDA	2.00	50.00	48.00	\N	\N	Venta - Factura FAC20260211-0003	1	2026-02-11 20:34:31.443875
201	66	SALIDA	2.00	50.00	48.00	\N	\N	Venta - Factura FAC20260211-0004	1	2026-02-11 20:35:21.114867
202	20	SALIDA	1.00	50.00	49.00	\N	\N	Venta - Factura FAC20260211-0005	1	2026-02-11 20:38:42.814102
203	19	SALIDA	1.00	50.00	49.00	\N	\N	Venta - Factura FAC20260211-0006	1	2026-02-11 21:25:58.341525
204	74	SALIDA	1.00	50.00	49.00	\N	\N	Venta - Factura FAC20260211-0006	1	2026-02-11 21:25:58.363779
205	78	SALIDA	1.00	48.00	47.00	\N	\N	Venta - Factura FAC20260211-0007	1	2026-02-11 22:26:13.06393
206	23	SALIDA	1.00	50.00	49.00	\N	\N	Venta - Factura FAC20260211-0007	1	2026-02-11 22:26:13.092946
207	20	SALIDA	2.00	49.00	47.00	\N	\N	Mesa #8 - MESA20260213-T8-0001	1	2026-02-13 17:27:44.336447
208	19	SALIDA	2.00	49.00	47.00	\N	\N	Mesa #8 - MESA20260213-T8-0001	1	2026-02-13 17:27:44.377666
209	1	SALIDA	2.00	12.00	10.00	\N	\N	Mesa #8 - MESA20260213-T8-0001	1	2026-02-13 17:27:44.406277
210	9	SALIDA	1.00	17.00	16.00	\N	\N	Mesa #8 - MESA20260213-T8-0001	1	2026-02-13 17:27:44.434437
211	3	SALIDA	1.00	17.00	16.00	\N	\N	Mesa #8 - MESA20260213-T8-0001	1	2026-02-13 17:27:44.467048
212	8	SALIDA	2.00	16.00	14.00	\N	\N	Mesa #4 - MESA20260214-T4-0001	1	2026-02-14 20:13:59.348723
213	9	SALIDA	1.00	16.00	15.00	\N	\N	Mesa #4 - MESA20260214-T4-0001	1	2026-02-14 20:13:59.386625
214	48	SALIDA	1.00	50.00	49.00	\N	\N	Mesa #4 - MESA20260214-T4-0001	1	2026-02-14 20:13:59.408056
215	52	SALIDA	3.00	50.00	47.00	\N	\N	Mesa #4 - MESA20260214-T4-0001	1	2026-02-14 20:18:09.754904
216	52	SALIDA	1.00	47.00	46.00	\N	\N	Venta - Factura FAC20260215-0001	1	2026-02-15 19:28:03.967335
217	4	SALIDA	1.00	6.00	5.00	\N	\N	Venta - Factura FAC20260215-0001	1	2026-02-15 19:28:03.997243
218	5	SALIDA	1.00	28.00	27.00	\N	\N	Venta - Factura FAC20260215-0001	1	2026-02-15 19:28:04.014492
219	5	SALIDA	1.00	27.00	26.00	\N	\N	Mesa #4 - MESA20260215-T4-0001	1	2026-02-15 19:28:39.597593
220	10	SALIDA	1.00	17.00	16.00	\N	\N	Mesa #4 - MESA20260215-T4-0001	1	2026-02-15 19:28:39.634121
221	4	SALIDA	1.00	5.00	4.00	\N	\N	Mesa #4 - MESA20260215-T4-0001	1	2026-02-15 19:28:39.66897
222	52	SALIDA	1.00	46.00	45.00	\N	\N	Mesa #4 - MESA20260215-T4-0001	1	2026-02-15 19:28:39.704388
223	1	SALIDA	1.00	10.00	9.00	\N	\N	Mesa #4 - MESA20260215-T4-0001	1	2026-02-15 19:28:39.736061
224	5	SALIDA	1.00	26.00	25.00	\N	\N	Mesa #1 - M1-0215-0001	1	2026-02-15 21:36:47.534342
225	10	SALIDA	1.00	16.00	15.00	\N	\N	Mesa #1 - M1-0215-0001	1	2026-02-15 21:36:47.583891
226	52	SALIDA	1.00	45.00	44.00	\N	\N	Mesa #1 - M1-0215-0002	1	2026-02-15 21:41:27.425037
227	4	SALIDA	1.00	4.00	3.00	\N	\N	Mesa #1 - M1-0215-0002	1	2026-02-15 21:41:27.461187
228	10	SALIDA	1.00	15.00	14.00	\N	\N	Mesa #1 - M1-0215-0002	1	2026-02-15 21:41:27.492813
229	10	SALIDA	2.00	14.00	12.00	\N	\N	Mesa #3 - M3-0215-0001	1	2026-02-15 21:42:57.423571
230	1	SALIDA	1.00	9.00	8.00	\N	\N	Mesa #3 - M3-0215-0001	1	2026-02-15 21:42:57.472409
231	6	SALIDA	1.00	7.00	6.00	\N	\N	Mesa #3 - M3-0215-0001	1	2026-02-15 21:42:57.541179
232	5	SALIDA	2.00	25.00	23.00	\N	\N	Venta - Factura V0215-0001	1	2026-02-15 22:27:53.469131
233	10	SALIDA	1.00	12.00	11.00	\N	\N	Venta - Factura V0215-0001	1	2026-02-15 22:27:53.500999
234	4	SALIDA	1.00	3.00	2.00	\N	\N	Venta - Factura V0215-0001	1	2026-02-15 22:27:53.521354
235	52	SALIDA	3.00	44.00	41.00	\N	\N	Mesa #3 - M3-0215-0002	1	2026-02-15 22:48:57.22267
236	5	SALIDA	2.00	23.00	21.00	\N	\N	Mesa #3 - M3-0215-0003	1	2026-02-15 22:58:25.851995
237	3	SALIDA	1.00	16.00	15.00	\N	\N	Venta - Factura V0216-0001	1	2026-02-16 08:31:00.368796
238	9	SALIDA	1.00	15.00	14.00	\N	\N	Venta - Factura V0216-0001	1	2026-02-16 08:31:00.432773
239	39	SALIDA	1.00	50.00	49.00	\N	\N	Venta - Factura V0216-0001	1	2026-02-16 08:31:00.489755
240	40	SALIDA	1.00	50.00	49.00	\N	\N	Venta - Factura V0216-0001	1	2026-02-16 08:31:00.523995
241	42	SALIDA	1.00	50.00	49.00	\N	\N	Venta - Factura V0216-0001	1	2026-02-16 08:31:00.555822
242	42	SALIDA	5.00	49.00	44.00	\N	\N	Mesa #7 - M7-0216-0001	1	2026-02-16 08:31:16.222364
243	41	SALIDA	1.00	50.00	49.00	\N	\N	Mesa #7 - M7-0216-0001	1	2026-02-16 08:31:16.286508
244	40	SALIDA	1.00	49.00	48.00	\N	\N	Mesa #7 - M7-0216-0001	1	2026-02-16 08:31:16.324419
245	4	SALIDA	1.00	2.00	1.00	\N	\N	Mesa #5 - M5-0216-0001	1	2026-02-16 09:11:46.534714
246	13	SALIDA	1.00	50.00	49.00	\N	\N	Mesa #5 - M5-0216-0001	1	2026-02-16 09:11:47.298444
247	5	SALIDA	2.00	21.00	19.00	\N	\N	Mesa #1 - M1-0216-0001	1	2026-02-16 09:47:00.614237
248	52	SALIDA	1.00	41.00	40.00	\N	\N	Mesa #1 - M1-0216-0001	1	2026-02-16 09:50:37.575543
249	16	SALIDA	1.00	50.00	49.00	\N	\N	Mesa #4 - M4-0216-0001	9	2026-02-16 13:31:08.112456
250	5	SALIDA	1.00	19.00	18.00	\N	\N	Mesa #4 - M4-0216-0001	9	2026-02-16 13:51:03.538335
251	31	SALIDA	1.00	50.00	49.00	\N	\N	Venta - Factura V0216-0002	9	2026-02-16 13:51:49.215048
252	32	SALIDA	1.00	50.00	49.00	\N	\N	Venta - Factura V0216-0002	9	2026-02-16 13:51:49.23613
253	31	ENTRADA	1.00	49.00	50.00	\N	\N	Anulación - Factura V0216-0002	9	2026-02-16 17:18:22.47371
254	32	ENTRADA	1.00	49.00	50.00	\N	\N	Anulación - Factura V0216-0002	9	2026-02-16 17:18:22.546233
255	5	ENTRADA	1.00	18.00	19.00	\N	\N	Anulación - Factura M4-0216-0001	9	2026-02-16 17:18:28.288839
256	16	ENTRADA	1.00	49.00	50.00	\N	\N	Anulación - Factura M4-0216-0001	9	2026-02-16 17:18:28.307232
257	5	ENTRADA	2.00	19.00	21.00	\N	\N	Anulación - Factura M1-0216-0001	9	2026-02-16 17:18:33.212446
258	52	ENTRADA	1.00	40.00	41.00	\N	\N	Anulación - Factura M1-0216-0001	9	2026-02-16 17:18:33.244164
259	42	ENTRADA	5.00	44.00	49.00	\N	\N	Anulación - Factura M7-0216-0001	9	2026-02-16 17:18:39.405751
260	41	ENTRADA	1.00	49.00	50.00	\N	\N	Anulación - Factura M7-0216-0001	9	2026-02-16 17:18:39.452206
261	40	ENTRADA	1.00	48.00	49.00	\N	\N	Anulación - Factura M7-0216-0001	9	2026-02-16 17:18:39.489588
262	3	ENTRADA	1.00	15.00	16.00	\N	\N	Anulación - Factura V0216-0001	9	2026-02-16 17:18:43.896345
263	9	ENTRADA	1.00	14.00	15.00	\N	\N	Anulación - Factura V0216-0001	9	2026-02-16 17:18:43.937472
264	39	ENTRADA	1.00	49.00	50.00	\N	\N	Anulación - Factura V0216-0001	9	2026-02-16 17:18:43.974054
265	40	ENTRADA	1.00	49.00	50.00	\N	\N	Anulación - Factura V0216-0001	9	2026-02-16 17:18:44.006921
266	42	ENTRADA	1.00	49.00	50.00	\N	\N	Anulación - Factura V0216-0001	9	2026-02-16 17:18:44.041764
267	4	ENTRADA	1.00	1.00	2.00	\N	\N	Anulación - Factura M5-0216-0001	9	2026-02-16 17:18:48.490516
268	13	ENTRADA	1.00	49.00	50.00	\N	\N	Anulación - Factura M5-0216-0001	9	2026-02-16 17:18:48.524996
269	19	SALIDA	1.00	47.00	46.00	\N	\N	Mesa #6 - M6-0216-0001	1	2026-02-16 20:58:48.80567
270	19	ENTRADA	1.00	46.00	47.00	\N	\N	Anulación - Factura M6-0216-0001	1	2026-02-16 20:59:15.79105
271	9	SALIDA	1.00	15.00	14.00	\N	\N	Venta - Factura V0216-0003	9	2026-02-16 21:05:05.305505
272	8	SALIDA	1.00	14.00	13.00	\N	\N	Venta - Factura V0216-0003	9	2026-02-16 21:05:05.331828
273	7	SALIDA	1.00	18.00	17.00	\N	\N	Venta - Factura V0216-0003	9	2026-02-16 21:05:05.350894
274	9	ENTRADA	1.00	14.00	15.00	\N	\N	Anulación - Factura V0216-0003	9	2026-02-16 21:09:43.322818
275	8	ENTRADA	1.00	13.00	14.00	\N	\N	Anulación - Factura V0216-0003	9	2026-02-16 21:09:43.339013
276	7	ENTRADA	1.00	17.00	18.00	\N	\N	Anulación - Factura V0216-0003	9	2026-02-16 21:09:43.35235
277	11	SALIDA	1.00	13.00	12.00	\N	\N	Venta - Factura V0216-0004	9	2026-02-16 21:20:16.023595
278	19	SALIDA	1.00	47.00	46.00	\N	\N	Venta - Factura V0216-0004	9	2026-02-16 21:20:16.049805
279	29	SALIDA	2.00	50.00	48.00	\N	\N	Venta - Factura V0216-0004	9	2026-02-16 21:20:16.066679
280	11	ENTRADA	1.00	12.00	13.00	\N	\N	Anulación - Factura V0216-0004	9	2026-02-16 21:20:31.17044
281	19	ENTRADA	1.00	46.00	47.00	\N	\N	Anulación - Factura V0216-0004	9	2026-02-16 21:20:31.183418
282	29	ENTRADA	2.00	48.00	50.00	\N	\N	Anulación - Factura V0216-0004	9	2026-02-16 21:20:31.19284
283	19	SALIDA	1.00	47.00	46.00	\N	\N	Venta - Factura V0216-0005	9	2026-02-16 21:22:19.978376
284	11	SALIDA	1.00	13.00	12.00	\N	\N	Venta - Factura V0216-0005	9	2026-02-16 21:22:19.997819
285	37	SALIDA	2.00	50.00	48.00	\N	\N	Venta - Factura V0216-0005	9	2026-02-16 21:22:20.015285
286	38	SALIDA	1.00	50.00	49.00	\N	\N	Venta - Factura V0216-0006	9	2026-02-16 21:25:00.137695
287	35	SALIDA	1.00	50.00	49.00	\N	\N	Venta - Factura V0216-0006	9	2026-02-16 21:25:00.169174
288	11	SALIDA	2.00	12.00	10.00	\N	\N	Venta - Factura V0216-0006	9	2026-02-16 21:25:00.209135
289	37	SALIDA	1.00	48.00	47.00	\N	\N	Venta - Factura V0216-0007	9	2026-02-16 21:45:08.044407
290	15	SALIDA	1.00	50.00	49.00	\N	\N	Venta - Factura V0216-0008	9	2026-02-16 21:45:35.347927
291	5	ENTRADA	2.00	21.00	23.00	\N	\N	Anulación - Factura M3-0215-0003	9	2026-02-16 21:48:18.237834
292	20	SALIDA	2.00	47.00	45.00	\N	\N	Mesa #3 - M3-0216-0001	6	2026-02-16 23:08:27.996726
293	52	SALIDA	1.00	41.00	40.00	\N	\N	Mesa #3 - M3-0216-0001	6	2026-02-16 23:08:28.040614
294	51	SALIDA	1.00	50.00	49.00	\N	\N	Mesa #3 - M3-0216-0001	6	2026-02-16 23:08:28.068878
295	48	SALIDA	1.00	49.00	48.00	\N	\N	Mesa #3 - M3-0216-0001	6	2026-02-16 23:08:28.100288
296	5	SALIDA	1.00	23.00	22.00	\N	\N	Mesa #3 - M3-0216-0001	6	2026-02-16 23:08:28.151388
297	20	SALIDA	1.00	45.00	44.00	\N	\N	Mesa #4 - M4-0216-0002	6	2026-02-16 23:30:16.339684
298	9	SALIDA	1.00	15.00	14.00	\N	\N	Mesa #4 - M4-0216-0002	6	2026-02-16 23:30:16.366847
299	46	SALIDA	1.00	50.00	49.00	\N	\N	Mesa #4 - M4-0216-0002	6	2026-02-16 23:30:16.391733
300	17	SALIDA	1.00	50.00	49.00	\N	\N	Mesa #4 - M4-0216-0002	9	2026-02-16 23:33:22.173778
301	17	SALIDA	1.00	49.00	48.00	\N	\N	Mesa #3 - M3-0216-0001	9	2026-02-16 23:33:41.076519
302	18	SALIDA	1.00	50.00	49.00	\N	\N	Mesa #3 - M3-0216-0001	9	2026-02-16 23:33:41.166459
303	9	ENTRADA	1.00	14.00	15.00	\N	\N	Eliminado de Mesa #4	1	2026-02-18 09:37:18.978682
304	17	ENTRADA	1.00	48.00	49.00	\N	\N	Eliminado de Mesa #4	1	2026-02-18 09:37:20.370178
305	46	ENTRADA	1.00	49.00	50.00	\N	\N	Eliminado de Mesa #4	1	2026-02-18 09:37:21.448013
306	20	ENTRADA	1.00	44.00	45.00	\N	\N	Eliminado de Mesa #4	1	2026-02-18 09:37:22.746408
307	20	ENTRADA	2.00	45.00	47.00	\N	\N	Eliminado de Mesa #3	1	2026-02-18 09:37:30.127469
308	51	ENTRADA	1.00	49.00	50.00	\N	\N	Eliminado de Mesa #3	1	2026-02-18 09:37:31.334466
309	52	ENTRADA	1.00	40.00	41.00	\N	\N	Eliminado de Mesa #3	1	2026-02-18 09:37:32.507511
310	5	ENTRADA	1.00	22.00	23.00	\N	\N	Eliminado de Mesa #3	1	2026-02-18 09:37:33.422689
311	48	ENTRADA	1.00	48.00	49.00	\N	\N	Eliminado de Mesa #3	1	2026-02-18 09:37:34.878887
312	18	ENTRADA	1.00	49.00	50.00	\N	\N	Eliminado de Mesa #3	1	2026-02-18 09:37:35.93311
313	17	ENTRADA	1.00	49.00	50.00	\N	\N	Eliminado de Mesa #3	1	2026-02-18 09:37:37.219399
314	4	ENTRADA	100.00	2.00	102.00	\N	\N	p\n	1	2026-02-18 18:36:39.19329
315	19	SALIDA	1.00	46.00	45.00	\N	\N	Venta - Factura V0218-0001	9	2026-02-18 20:19:15.751095
316	35	SALIDA	2.00	49.00	47.00	\N	\N	Venta - Factura V0218-0001	9	2026-02-18 20:19:15.793119
317	5	SALIDA	1.00	23.00	22.00	\N	\N	Venta - Factura V0218-0001	9	2026-02-18 20:19:15.819404
318	20	SALIDA	1.00	47.00	46.00	\N	\N	Mesa #1 - M1-0218-0001	9	2026-02-18 20:38:13.623277
319	20	ENTRADA	1.00	46.00	47.00	\N	\N	Eliminado de Mesa #1	9	2026-02-18 20:44:31.964114
320	66	SALIDA	1.00	48.00	47.00	\N	\N	Mesa #6 - M6-0218-0001	9	2026-02-18 20:47:03.953739
321	63	SALIDA	1.00	50.00	49.00	\N	\N	Venta - Factura V0219-0001	1	2026-02-19 16:45:30.681858
322	63	ENTRADA	1.00	49.00	50.00	\N	\N	Anulación - Factura V0219-0001	1	2026-02-19 16:46:00.517331
323	63	SALIDA	2.00	50.00	48.00	\N	\N	Mesa #1 - M1-0219-0001	9	2026-02-19 18:11:02.191522
324	23	SALIDA	1.00	49.00	48.00	\N	\N	Mesa #1 - M1-0219-0002	9	2026-02-19 18:20:44.783024
325	25	SALIDA	1.00	50.00	49.00	\N	\N	Mesa #1 - M1-0219-0002	9	2026-02-19 18:20:44.8476
326	50	SALIDA	1.00	50.00	49.00	\N	\N	Mesa #3 - M3-0220-0001	1	2026-02-20 00:10:33.073174
327	77	SALIDA	1.00	50.00	49.00	\N	\N	Mesa #3 - M3-0220-0001	1	2026-02-20 08:22:24.758474
328	24	SALIDA	1.00	50.00	49.00	\N	\N	Mesa #3 - M3-0220-0001	1	2026-02-20 12:27:57.140383
329	66	SALIDA	1.00	47.00	46.00	\N	\N	Mesa #3 - M3-0220-0001	1	2026-02-20 12:27:57.267792
330	46	SALIDA	1.00	50.00	49.00	\N	\N	Mesa #1 - M1-0220-0001	1	2026-02-20 12:28:29.214503
331	2	SALIDA	1.00	13.00	12.00	\N	\N	Mesa #1 - M1-0220-0001	1	2026-02-20 12:28:29.274499
332	9	SALIDA	1.00	15.00	14.00	\N	\N	Mesa #3 - M3-0220-0001	1	2026-02-20 12:28:59.902565
333	77	ENTRADA	1.00	49.00	50.00	\N	\N	Eliminado de Mesa #3	1	2026-02-20 12:34:21.739456
334	9	ENTRADA	1.00	14.00	15.00	\N	\N	Eliminado de Mesa #3	1	2026-02-20 12:34:23.08415
335	66	ENTRADA	1.00	46.00	47.00	\N	\N	Eliminado de Mesa #3	1	2026-02-20 12:34:24.439033
336	24	ENTRADA	1.00	49.00	50.00	\N	\N	Eliminado de Mesa #3	1	2026-02-20 12:34:33.204321
338	2	ENTRADA	1.00	12.00	13.00	\N	\N	Eliminado de Mesa #1	1	2026-02-20 12:35:23.54776
337	50	ENTRADA	1.00	49.00	50.00	\N	\N	Eliminado de Mesa #3	1	2026-02-20 12:34:33.284269
339	46	ENTRADA	1.00	49.00	50.00	\N	\N	Eliminado de Mesa #1	1	2026-02-20 12:35:24.006377
340	3	SALIDA	1.00	16.00	15.00	\N	\N	Mesa #1 - M1-0220-0002	1	2026-02-20 19:24:22.179033
341	65	SALIDA	1.00	50.00	49.00	\N	\N	Mesa #3 - M3-0220-0002	1	2026-02-20 19:24:25.03016
342	3	SALIDA	1.00	15.00	14.00	\N	\N	Mesa #1 - M1-0220-0002	1	2026-02-20 19:24:28.264925
343	38	SALIDA	1.00	49.00	48.00	\N	\N	Mesa #1 - M1-0220-0002	1	2026-02-20 19:25:42.462203
344	44	SALIDA	1.00	50.00	49.00	\N	\N	Mesa #6 - M6-0220-0001	1	2026-02-20 19:31:00.383914
345	16	SALIDA	1.00	50.00	49.00	\N	\N	Mesa #6 - M6-0220-0001	1	2026-02-20 19:31:00.431475
346	3	SALIDA	1.00	14.00	13.00	\N	\N	Mesa #6 - M6-0220-0001	1	2026-02-20 19:32:04.641116
347	2	SALIDA	2.00	13.00	11.00	\N	\N	Mesa #6 - M6-0220-0001	1	2026-02-20 19:32:04.664384
348	52	SALIDA	1.00	41.00	40.00	\N	\N	Venta - Factura V0220-0001	9	2026-02-20 19:41:31.355045
349	3	ENTRADA	1.00	13.00	14.00	\N	\N	Eliminado de Mesa #1	1	2026-02-20 19:44:28.264601
350	3	ENTRADA	1.00	14.00	15.00	\N	\N	Eliminado de Mesa #1	1	2026-02-20 19:44:29.787485
351	38	ENTRADA	1.00	48.00	49.00	\N	\N	Eliminado de Mesa #1	1	2026-02-20 19:44:31.683592
352	65	ENTRADA	1.00	49.00	50.00	\N	\N	Eliminado de Mesa #3	1	2026-02-20 19:45:29.911362
353	3	ENTRADA	1.00	15.00	16.00	\N	\N	Eliminado de Mesa #6	1	2026-02-20 19:45:38.429707
354	16	ENTRADA	1.00	49.00	50.00	\N	\N	Eliminado de Mesa #6	1	2026-02-20 19:45:40.603814
355	44	ENTRADA	1.00	49.00	50.00	\N	\N	Eliminado de Mesa #6	1	2026-02-20 19:45:42.332626
356	2	ENTRADA	2.00	11.00	13.00	\N	\N	Eliminado de Mesa #6	1	2026-02-20 19:45:44.146832
357	9	SALIDA	1.00	15.00	14.00	\N	\N	Mesa #10 - M10-0220-0001	1	2026-02-20 19:53:31.939692
358	3	SALIDA	1.00	16.00	15.00	\N	\N	Mesa #10 - M10-0220-0001	1	2026-02-20 19:53:31.963139
359	70	SALIDA	1.00	50.00	49.00	\N	\N	Mesa #11 - M11-0220-0001	1	2026-02-20 19:56:31.996306
360	9	SALIDA	1.00	14.00	13.00	\N	\N	Mesa #11 - M11-0220-0001	1	2026-02-20 19:56:32.017595
361	37	SALIDA	1.00	47.00	46.00	\N	\N	Mesa #11 - M11-0220-0001	1	2026-02-20 19:56:32.036933
362	22	SALIDA	1.00	50.00	49.00	\N	\N	Mesa #11 - M11-0220-0001	1	2026-02-20 19:56:32.05962
363	61	SALIDA	1.00	50.00	49.00	\N	\N	Mesa #11 - M11-0220-0001	1	2026-02-20 19:56:32.082047
364	70	SALIDA	1.00	49.00	48.00	\N	\N	Mesa #11 - M11-0220-0001	1	2026-02-20 19:58:31.862195
365	75	SALIDA	1.00	50.00	49.00	\N	\N	Mesa #11 - M11-0220-0001	1	2026-02-20 19:58:31.883823
366	35	SALIDA	1.00	47.00	46.00	\N	\N	Mesa #11 - M11-0220-0001	1	2026-02-20 19:58:31.909725
367	69	SALIDA	1.00	50.00	49.00	\N	\N	Mesa #11 - M11-0220-0001	1	2026-02-20 19:58:31.938499
368	21	SALIDA	1.00	50.00	49.00	\N	\N	Mesa #11 - M11-0220-0001	1	2026-02-20 19:58:31.962116
369	42	SALIDA	1.00	50.00	49.00	\N	\N	Mesa #11 - M11-0220-0001	1	2026-02-20 19:58:31.979361
370	10	SALIDA	1.00	11.00	10.00	\N	\N	Mesa #11 - M11-0220-0001	1	2026-02-20 19:58:32.002594
371	77	SALIDA	1.00	50.00	49.00	\N	\N	Mesa #11 - M11-0220-0001	1	2026-02-20 19:58:32.019902
372	44	SALIDA	1.00	50.00	49.00	\N	\N	Mesa #11 - M11-0220-0001	1	2026-02-20 19:58:32.043417
373	23	SALIDA	1.00	48.00	47.00	\N	\N	Mesa #11 - M11-0220-0001	1	2026-02-20 19:58:32.088153
374	25	SALIDA	1.00	49.00	48.00	\N	\N	Mesa #11 - M11-0220-0001	1	2026-02-20 19:58:32.109981
375	34	SALIDA	1.00	50.00	49.00	\N	\N	Mesa #11 - M11-0220-0001	1	2026-02-20 19:58:32.134375
376	17	SALIDA	1.00	50.00	49.00	\N	\N	Mesa #11 - M11-0220-0001	1	2026-02-20 19:58:32.154432
377	20	SALIDA	1.00	47.00	46.00	\N	\N	Mesa #11 - M11-0220-0001	1	2026-02-20 19:58:32.185975
378	68	SALIDA	1.00	50.00	49.00	\N	\N	Mesa #11 - M11-0220-0001	1	2026-02-20 19:58:32.212739
379	41	SALIDA	1.00	50.00	49.00	\N	\N	Mesa #11 - M11-0220-0001	1	2026-02-20 19:58:32.237045
380	26	SALIDA	1.00	50.00	49.00	\N	\N	Mesa #11 - M11-0220-0001	1	2026-02-20 19:58:32.260384
381	15	SALIDA	1.00	49.00	48.00	\N	\N	Mesa #11 - M11-0220-0001	1	2026-02-20 19:58:32.282446
382	55	SALIDA	1.00	50.00	49.00	\N	\N	Mesa #11 - M11-0220-0001	1	2026-02-20 19:58:32.304747
383	53	SALIDA	2.00	50.00	48.00	\N	\N	Mesa #11 - M11-0220-0001	1	2026-02-20 19:58:32.329521
384	78	SALIDA	1.00	47.00	46.00	\N	\N	Mesa #5 - M5-0220-0001	10	2026-02-20 20:04:26.383325
385	7	SALIDA	1.00	18.00	17.00	\N	\N	Mesa #5 - M5-0220-0001	10	2026-02-20 20:04:26.413721
386	20	SALIDA	1.00	46.00	45.00	\N	\N	Mesa #5 - M5-0220-0001	10	2026-02-20 20:04:26.432506
387	46	SALIDA	1.00	50.00	49.00	\N	\N	Mesa #5 - M5-0220-0001	10	2026-02-20 20:04:26.451752
388	36	SALIDA	1.00	50.00	49.00	\N	\N	Mesa #5 - M5-0220-0001	10	2026-02-20 20:04:26.474904
389	3	ENTRADA	1.00	15.00	16.00	\N	\N	Eliminado de Mesa #10	1	2026-02-20 20:05:28.42353
390	9	ENTRADA	1.00	13.00	14.00	\N	\N	Eliminado de Mesa #10	1	2026-02-20 20:05:29.212905
391	22	ENTRADA	1.00	49.00	50.00	\N	\N	Eliminado de Mesa #11	1	2026-02-20 20:05:40.942587
392	61	ENTRADA	1.00	49.00	50.00	\N	\N	Eliminado de Mesa #11	1	2026-02-20 20:05:43.205336
393	70	ENTRADA	1.00	48.00	49.00	\N	\N	Eliminado de Mesa #11	1	2026-02-20 20:05:46.865696
394	75	ENTRADA	1.00	49.00	50.00	\N	\N	Eliminado de Mesa #11	1	2026-02-20 20:05:49.927196
395	37	ENTRADA	1.00	46.00	47.00	\N	\N	Eliminado de Mesa #11	1	2026-02-20 20:05:53.919734
396	9	ENTRADA	1.00	14.00	15.00	\N	\N	Eliminado de Mesa #11	1	2026-02-20 20:05:54.793972
397	70	ENTRADA	1.00	49.00	50.00	\N	\N	Eliminado de Mesa #11	1	2026-02-20 20:05:56.043647
398	53	ENTRADA	2.00	48.00	50.00	\N	\N	Eliminado de Mesa #11	1	2026-02-20 20:06:03.894423
399	26	ENTRADA	1.00	49.00	50.00	\N	\N	Eliminado de Mesa #11	1	2026-02-20 20:06:05.561146
400	35	ENTRADA	1.00	46.00	47.00	\N	\N	Eliminado de Mesa #11	1	2026-02-20 20:06:11.033902
401	21	ENTRADA	1.00	49.00	50.00	\N	\N	Eliminado de Mesa #11	1	2026-02-20 20:06:12.196167
402	10	ENTRADA	1.00	10.00	11.00	\N	\N	Eliminado de Mesa #11	1	2026-02-20 20:06:13.691129
403	69	ENTRADA	1.00	49.00	50.00	\N	\N	Eliminado de Mesa #11	1	2026-02-20 20:06:25.473005
404	77	ENTRADA	1.00	49.00	50.00	\N	\N	Eliminado de Mesa #11	1	2026-02-20 20:06:26.191369
405	23	ENTRADA	1.00	47.00	48.00	\N	\N	Eliminado de Mesa #11	1	2026-02-20 20:06:27.767075
406	55	ENTRADA	1.00	49.00	50.00	\N	\N	Eliminado de Mesa #11	1	2026-02-20 20:06:36.314071
407	68	ENTRADA	1.00	49.00	50.00	\N	\N	Eliminado de Mesa #11	1	2026-02-20 20:06:36.825152
408	17	ENTRADA	1.00	49.00	50.00	\N	\N	Eliminado de Mesa #11	1	2026-02-20 20:06:38.453254
412	20	ENTRADA	1.00	45.00	46.00	\N	\N	Eliminado de Mesa #11	1	2026-02-20 20:06:51.787961
416	13	SALIDA	1.00	50.00	49.00	\N	\N	Mesa #6 - M6-0220-0002	10	2026-02-20 20:07:08.714227
417	20	SALIDA	1.00	46.00	45.00	\N	\N	Mesa #6 - M6-0220-0002	10	2026-02-20 20:07:08.740548
418	32	SALIDA	1.00	50.00	49.00	\N	\N	Mesa #6 - M6-0220-0002	10	2026-02-20 20:07:08.759731
419	43	SALIDA	1.00	50.00	49.00	\N	\N	Mesa #6 - M6-0220-0002	10	2026-02-20 20:07:08.779667
409	42	ENTRADA	1.00	49.00	50.00	\N	\N	Eliminado de Mesa #11	1	2026-02-20 20:06:44.81265
410	44	ENTRADA	1.00	49.00	50.00	\N	\N	Eliminado de Mesa #11	1	2026-02-20 20:06:45.095384
411	25	ENTRADA	1.00	48.00	49.00	\N	\N	Eliminado de Mesa #11	1	2026-02-20 20:06:45.114655
413	34	ENTRADA	1.00	49.00	50.00	\N	\N	Eliminado de Mesa #11	1	2026-02-20 20:06:51.787961
414	41	ENTRADA	1.00	49.00	50.00	\N	\N	Eliminado de Mesa #11	1	2026-02-20 20:07:02.582946
415	15	ENTRADA	1.00	48.00	49.00	\N	\N	Eliminado de Mesa #11	1	2026-02-20 20:07:06.344259
420	7	SALIDA	1.00	17.00	16.00	\N	\N	Mesa #1 - M1-0220-0003	10	2026-02-20 20:13:47.219721
421	36	SALIDA	1.00	49.00	48.00	\N	\N	Mesa #1 - M1-0220-0003	10	2026-02-20 20:13:47.72516
422	43	SALIDA	1.00	49.00	48.00	\N	\N	Mesa #1 - M1-0220-0003	10	2026-02-20 20:14:26.282717
423	7	ENTRADA	1.00	16.00	17.00	\N	\N	Eliminado de Mesa #1	9	2026-02-20 20:14:47.414331
424	36	ENTRADA	1.00	48.00	49.00	\N	\N	Eliminado de Mesa #1	9	2026-02-20 20:14:51.328004
425	43	ENTRADA	1.00	48.00	49.00	\N	\N	Eliminado de Mesa #1	9	2026-02-20 20:14:52.537034
426	70	SALIDA	1.00	50.00	49.00	\N	\N	Mesa #6 - M6-0220-0002	1	2026-02-20 20:28:49.843007
427	70	ENTRADA	1.00	49.00	50.00	\N	\N	Eliminado de Mesa #6	1	2026-02-20 20:28:56.226222
428	31	SALIDA	1.00	50.00	49.00	\N	\N	Mesa #7 - M7-0220-0001	9	2026-02-20 20:38:21.955317
429	63	SALIDA	1.00	48.00	47.00	\N	\N	Mesa #8 - M8-0220-0001	9	2026-02-20 21:08:55.301373
430	32	SALIDA	1.00	49.00	48.00	\N	\N	Mesa #6 - M6-0220-0002	9	2026-02-20 21:11:06.254401
431	73	SALIDA	1.00	50.00	49.00	\N	\N	Mesa #3 - M3-0220-0003	9	2026-02-20 21:30:58.659056
432	74	SALIDA	1.00	49.00	48.00	\N	\N	Mesa #3 - M3-0220-0003	9	2026-02-20 21:30:58.686611
433	5	SALIDA	1.00	22.00	21.00	\N	\N	Mesa #3 - M3-0220-0003	9	2026-02-20 21:30:58.704505
434	75	SALIDA	1.00	50.00	49.00	\N	\N	Mesa #3 - M3-0220-0003	9	2026-02-20 21:49:58.976147
435	19	SALIDA	1.00	45.00	44.00	\N	\N	Venta - Factura V0220-0002	9	2026-02-20 22:01:32.007309
436	8	SALIDA	3.00	14.00	11.00	\N	\N	Venta - Factura V0220-0002	9	2026-02-20 22:01:32.026877
437	19	ENTRADA	1.00	44.00	45.00	\N	\N	Anulación - Factura V0220-0002	9	2026-02-20 22:02:12.722238
438	8	ENTRADA	3.00	11.00	14.00	\N	\N	Anulación - Factura V0220-0002	9	2026-02-20 22:02:12.729741
439	7	SALIDA	1.00	17.00	16.00	\N	\N	Mesa #10 - M10-0220-0002	1	2026-02-20 22:48:07.353298
440	3	SALIDA	1.00	16.00	15.00	\N	\N	Mesa #10 - M10-0220-0002	1	2026-02-20 22:48:07.382269
441	7	ENTRADA	1.00	16.00	17.00	\N	\N	Eliminado de Mesa #10	1	2026-02-20 22:49:29.332428
442	3	ENTRADA	1.00	15.00	16.00	\N	\N	Eliminado de Mesa #10	1	2026-02-20 22:49:30.614772
443	74	SALIDA	1.00	48.00	47.00	\N	\N	Venta - Factura V0221-0001	9	2026-02-21 18:31:05.727162
444	3	SALIDA	1.00	16.00	15.00	\N	\N	Venta - Factura V0221-0002	9	2026-02-21 19:31:45.391975
445	2	SALIDA	1.00	13.00	12.00	\N	\N	Venta - Factura V0221-0002	9	2026-02-21 19:31:45.414108
446	3	ENTRADA	1.00	15.00	16.00	\N	\N	Anulación - Factura V0221-0002	9	2026-02-21 19:32:00.303419
447	2	ENTRADA	1.00	12.00	13.00	\N	\N	Anulación - Factura V0221-0002	9	2026-02-21 19:32:00.313492
448	3	SALIDA	1.00	16.00	15.00	\N	\N	Venta - Factura V0221-0003	9	2026-02-21 19:32:44.549123
449	2	SALIDA	1.00	13.00	12.00	\N	\N	Venta - Factura V0221-0003	9	2026-02-21 19:32:44.589075
450	11	SALIDA	1.00	10.00	9.00	\N	\N	Mesa #10 - M10-0221-0001	1	2026-02-21 23:57:31.185133
451	78	SALIDA	1.00	46.00	45.00	\N	\N	Mesa #10 - M10-0221-0001	1	2026-02-21 23:57:31.215953
452	15	SALIDA	1.00	49.00	48.00	\N	\N	Mesa #10 - M10-0221-0001	1	2026-02-21 23:57:31.24359
453	11	SALIDA	2.00	9.00	7.00	\N	\N	Mesa #10 - M10-0221-0001	1	2026-02-21 23:57:37.931121
454	3	SALIDA	1.00	15.00	14.00	\N	\N	Mesa #8 - M8-0222-0001	1	2026-02-22 00:11:02.965563
455	2	SALIDA	1.00	12.00	11.00	\N	\N	Mesa #8 - M8-0222-0001	1	2026-02-22 00:11:03.01981
456	46	SALIDA	1.00	49.00	48.00	\N	\N	Mesa #8 - M8-0222-0002	1	2026-02-22 00:14:03.947871
457	9	SALIDA	1.00	15.00	14.00	\N	\N	Mesa #8 - M8-0222-0002	1	2026-02-22 00:14:03.967017
458	70	SALIDA	1.00	50.00	49.00	\N	\N	Mesa #8 - M8-0222-0002	1	2026-02-22 00:14:03.987815
459	66	SALIDA	1.00	47.00	46.00	\N	\N	Mesa #8 - M8-0222-0002	1	2026-02-22 00:14:04.005087
460	11	SALIDA	1.00	7.00	6.00	\N	\N	Mesa #10 - M10-0221-0001	1	2026-02-22 00:14:25.68634
461	78	SALIDA	1.00	45.00	44.00	\N	\N	Mesa #10 - M10-0221-0001	1	2026-02-22 00:14:25.707782
462	16	SALIDA	1.00	50.00	49.00	\N	\N	Mesa #10 - M10-0221-0001	1	2026-02-22 00:14:25.726913
463	29	SALIDA	1.00	50.00	49.00	\N	\N	Mesa #8 - M8-0222-0002	1	2026-02-22 00:14:41.782203
464	22	SALIDA	1.00	50.00	49.00	\N	\N	Mesa #8 - M8-0222-0002	1	2026-02-22 00:14:41.803113
465	11	ENTRADA	1.00	6.00	7.00	\N	\N	Eliminado de Mesa #10	1	2026-02-22 00:15:06.748001
466	78	ENTRADA	1.00	44.00	45.00	\N	\N	Eliminado de Mesa #10	1	2026-02-22 00:15:07.212281
467	78	ENTRADA	1.00	45.00	46.00	\N	\N	Eliminado de Mesa #10	1	2026-02-22 00:15:08.042856
468	16	ENTRADA	1.00	49.00	50.00	\N	\N	Eliminado de Mesa #10	1	2026-02-22 00:15:08.567741
469	11	ENTRADA	2.00	7.00	9.00	\N	\N	Eliminado de Mesa #10	1	2026-02-22 00:15:09.526109
470	15	ENTRADA	1.00	48.00	49.00	\N	\N	Eliminado de Mesa #10	1	2026-02-22 00:15:10.231025
471	11	ENTRADA	1.00	9.00	10.00	\N	\N	Eliminado de Mesa #10	1	2026-02-22 00:15:13.620128
472	70	ENTRADA	1.00	49.00	50.00	\N	\N	Eliminado de Mesa #8	1	2026-02-22 00:15:19.602771
473	9	ENTRADA	1.00	14.00	15.00	\N	\N	Eliminado de Mesa #8	1	2026-02-22 00:15:19.987515
474	46	ENTRADA	1.00	48.00	49.00	\N	\N	Eliminado de Mesa #8	1	2026-02-22 00:15:20.713379
475	66	ENTRADA	1.00	46.00	47.00	\N	\N	Eliminado de Mesa #8	1	2026-02-22 00:15:22.339927
476	22	ENTRADA	1.00	49.00	50.00	\N	\N	Eliminado de Mesa #8	1	2026-02-22 00:15:22.719388
477	29	ENTRADA	1.00	49.00	50.00	\N	\N	Eliminado de Mesa #8	1	2026-02-22 00:15:23.805891
478	3	ENTRADA	1.00	14.00	15.00	\N	\N	Anulación - Factura M8-0222-0001	1	2026-02-22 00:17:10.853514
479	2	ENTRADA	1.00	11.00	12.00	\N	\N	Anulación - Factura M8-0222-0001	1	2026-02-22 00:17:10.864638
480	51	SALIDA	1.00	50.00	49.00	\N	\N	Mesa #10 - M10-0222-0001	1	2026-02-22 00:52:36.598588
481	47	SALIDA	1.00	50.00	49.00	\N	\N	Mesa #10 - M10-0222-0001	1	2026-02-22 00:52:36.694433
482	51	SALIDA	1.00	49.00	48.00	\N	\N	Mesa #8 - M8-0222-0003	1	2026-02-22 01:00:58.597298
483	14	SALIDA	1.00	50.00	49.00	\N	\N	Mesa #8 - M8-0222-0003	1	2026-02-22 01:01:09.685641
484	51	ENTRADA	1.00	48.00	49.00	\N	\N	Eliminado de Mesa #10	1	2026-02-22 01:33:12.264571
485	47	ENTRADA	1.00	49.00	50.00	\N	\N	Eliminado de Mesa #10	1	2026-02-22 01:33:13.240783
486	51	ENTRADA	1.00	49.00	50.00	\N	\N	Eliminado de Mesa #8	1	2026-02-22 01:33:18.286913
487	14	ENTRADA	1.00	49.00	50.00	\N	\N	Eliminado de Mesa #8	1	2026-02-22 01:33:19.258534
488	46	SALIDA	1.00	49.00	48.00	\N	\N	Mesa #10 - M10-0222-0002	1	2026-02-22 01:38:20.368165
489	47	SALIDA	1.00	50.00	49.00	\N	\N	Mesa #10 - M10-0222-0002	1	2026-02-22 01:38:20.413159
490	51	SALIDA	1.00	50.00	49.00	\N	\N	Mesa #10 - M10-0222-0002	1	2026-02-22 02:15:48.686501
491	51	SALIDA	1.00	49.00	48.00	\N	\N	Mesa #10 - M10-0222-0002	1	2026-02-22 02:15:57.078277
492	51	SALIDA	1.00	48.00	47.00	\N	\N	Mesa #10 - M10-0222-0002	1	2026-02-22 02:17:58.827099
493	47	SALIDA	1.00	49.00	48.00	\N	\N	Mesa #10 - M10-0222-0002	1	2026-02-22 02:17:58.854526
494	9	SALIDA	1.00	15.00	14.00	\N	\N	Mesa #1 - M1-0222-0001	1	2026-02-22 02:20:54.889715
495	3	SALIDA	1.00	15.00	14.00	\N	\N	Mesa #1 - M1-0222-0001	1	2026-02-22 02:20:54.910158
496	21	SALIDA	1.00	50.00	49.00	\N	\N	Mesa #1 - M1-0222-0001	1	2026-02-22 02:20:54.932314
497	22	SALIDA	5.00	50.00	45.00	\N	\N	Mesa #1 - M1-0222-0001	1	2026-02-22 02:20:54.953803
498	21	SALIDA	2.00	49.00	47.00	\N	\N	Mesa #2 - M2-0222-0001	1	2026-02-22 02:21:09.18294
499	3	SALIDA	1.00	14.00	13.00	\N	\N	Mesa #1 - M1-0222-0001	1	2026-02-22 02:22:00.21609
500	18	SALIDA	1.00	50.00	49.00	\N	\N	Mesa #1 - M1-0222-0001	1	2026-02-22 02:22:56.179805
501	79	SALIDA	1.00	100.00	99.00	\N	\N	Mesa #3 - M3-0222-0001	1	2026-02-22 02:29:04.882015
502	78	SALIDA	1.00	46.00	45.00	\N	\N	Venta - Factura V0222-0001	9	2026-02-22 17:42:42.022347
503	14	SALIDA	1.00	50.00	49.00	\N	\N	Venta - Factura V0222-0001	9	2026-02-22 17:42:42.037764
504	19	SALIDA	1.00	45.00	44.00	\N	\N	Venta - Factura V0222-0001	9	2026-02-22 17:42:42.051684
505	20	SALIDA	1.00	45.00	44.00	\N	\N	Venta - Factura V0222-0001	9	2026-02-22 17:42:42.065796
506	9	ENTRADA	1.00	14.00	15.00	\N	\N	Eliminado de Mesa #1	9	2026-02-22 18:49:17.697743
507	21	ENTRADA	1.00	47.00	48.00	\N	\N	Eliminado de Mesa #1	9	2026-02-22 18:49:19.034397
508	3	ENTRADA	2.00	13.00	15.00	\N	\N	Eliminado de Mesa #1	9	2026-02-22 18:49:20.1896
509	22	ENTRADA	5.00	45.00	50.00	\N	\N	Eliminado de Mesa #1	9	2026-02-22 18:49:20.909849
510	18	ENTRADA	1.00	49.00	50.00	\N	\N	Eliminado de Mesa #1	9	2026-02-22 18:49:21.799135
511	21	ENTRADA	2.00	48.00	50.00	\N	\N	Eliminado de Mesa #2	9	2026-02-22 18:49:26.473786
512	79	ENTRADA	1.00	99.00	100.00	\N	\N	Eliminado de Mesa #3	9	2026-02-22 18:49:37.108424
513	51	SALIDA	1.00	47.00	46.00	\N	\N	Mesa #10 - M10-0222-0003	9	2026-02-22 18:50:00.625633
514	51	ENTRADA	1.00	46.00	47.00	\N	\N	Anulación - Factura M10-0222-0003	9	2026-02-22 18:54:48.308398
515	46	ENTRADA	1.00	48.00	49.00	\N	\N	Anulación - Factura M10-0222-0002	9	2026-02-22 18:55:36.378997
516	47	ENTRADA	2.00	48.00	50.00	\N	\N	Anulación - Factura M10-0222-0002	9	2026-02-22 18:55:36.385173
517	51	ENTRADA	3.00	47.00	50.00	\N	\N	Anulación - Factura M10-0222-0002	9	2026-02-22 18:55:36.392479
518	19	SALIDA	1.00	44.00	43.00	\N	\N	Mesa #3 - M3-0222-0002	9	2026-02-22 18:58:26.265546
519	34	SALIDA	1.00	50.00	49.00	\N	\N	Mesa #3 - M3-0222-0002	9	2026-02-22 18:58:26.287099
520	21	SALIDA	1.00	50.00	49.00	\N	\N	Mesa #3 - M3-0222-0002	9	2026-02-22 18:58:26.301249
521	49	SALIDA	1.00	50.00	49.00	\N	\N	Mesa #3 - M3-0222-0002	9	2026-02-22 18:58:26.313198
522	70	SALIDA	2.00	50.00	48.00	\N	\N	Mesa #2 - M2-0222-0002	9	2026-02-22 19:01:35.452208
523	20	SALIDA	1.00	44.00	43.00	\N	\N	Mesa #6 - M6-0222-0001	9	2026-02-22 19:02:57.241954
524	70	SALIDA	1.00	48.00	47.00	\N	\N	Mesa #4 - M4-0222-0001	10	2026-02-22 19:17:51.00506
525	19	SALIDA	1.00	43.00	42.00	\N	\N	Mesa #4 - M4-0222-0001	10	2026-02-22 19:17:51.023534
526	10	SALIDA	1.00	11.00	10.00	\N	\N	Mesa #4 - M4-0222-0001	10	2026-02-22 19:17:51.036949
527	49	SALIDA	1.00	49.00	48.00	\N	\N	Mesa #4 - M4-0222-0001	10	2026-02-22 19:17:51.05002
528	3	SALIDA	1.00	15.00	14.00	\N	\N	Mesa #4 - M4-0222-0001	10	2026-02-22 19:17:51.06706
529	78	SALIDA	1.00	45.00	44.00	\N	\N	Mesa #10 - M10-0222-0004	1	2026-02-22 19:21:17.823181
530	11	SALIDA	1.00	10.00	9.00	\N	\N	Mesa #10 - M10-0222-0004	1	2026-02-22 19:21:17.834291
531	41	SALIDA	1.00	50.00	49.00	\N	\N	Mesa #10 - M10-0222-0004	1	2026-02-22 19:21:17.845908
532	42	SALIDA	1.00	50.00	49.00	\N	\N	Mesa #10 - M10-0222-0004	1	2026-02-22 19:21:17.857453
533	49	ENTRADA	1.00	48.00	49.00	\N	\N	Eliminado de Mesa #4	1	2026-02-22 19:30:42.173588
534	19	ENTRADA	1.00	42.00	43.00	\N	\N	Eliminado de Mesa #4	1	2026-02-22 19:30:43.657758
535	3	ENTRADA	1.00	14.00	15.00	\N	\N	Eliminado de Mesa #4	1	2026-02-22 19:30:44.621914
536	10	ENTRADA	1.00	10.00	11.00	\N	\N	Eliminado de Mesa #4	1	2026-02-22 19:30:45.26363
537	70	ENTRADA	1.00	47.00	48.00	\N	\N	Eliminado de Mesa #4	1	2026-02-22 19:30:45.921963
538	78	ENTRADA	1.00	44.00	45.00	\N	\N	Eliminado de Mesa #10	1	2026-02-22 19:31:04.705262
539	42	ENTRADA	1.00	49.00	50.00	\N	\N	Eliminado de Mesa #10	1	2026-02-22 19:31:05.409843
540	11	ENTRADA	1.00	9.00	10.00	\N	\N	Eliminado de Mesa #10	1	2026-02-22 19:31:05.992323
541	41	ENTRADA	1.00	49.00	50.00	\N	\N	Eliminado de Mesa #10	1	2026-02-22 19:31:06.753112
542	20	SALIDA	1.00	43.00	42.00	\N	\N	Venta - Factura V0222-0002	1	2026-02-22 19:37:31.562969
543	18	SALIDA	1.00	50.00	49.00	\N	\N	Venta - Factura V0222-0003	9	2026-02-22 20:16:44.445164
544	73	SALIDA	1.00	49.00	48.00	\N	\N	Mesa #6 - M6-0222-0002	9	2026-02-22 20:28:28.916376
545	74	SALIDA	1.00	47.00	46.00	\N	\N	Mesa #6 - M6-0222-0002	9	2026-02-22 20:28:28.933147
546	77	SALIDA	2.00	50.00	48.00	\N	\N	Mesa #6 - M6-0222-0002	9	2026-02-22 20:28:28.94711
547	19	SALIDA	1.00	43.00	42.00	\N	\N	Mesa #3 - M3-0222-0004	10	2026-02-22 21:01:56.481432
548	29	SALIDA	2.00	50.00	48.00	\N	\N	Mesa #3 - M3-0222-0004	10	2026-02-22 21:01:56.496478
549	63	SALIDA	2.00	47.00	45.00	\N	\N	Mesa #3 - M3-0222-0004	10	2026-02-22 21:01:56.51006
550	28	SALIDA	1.00	50.00	49.00	\N	\N	Mesa #7 - M7-0222-0001	9	2026-02-22 21:12:58.304363
551	51	SALIDA	1.00	50.00	49.00	\N	\N	Mesa #7 - M7-0222-0001	9	2026-02-22 21:12:58.320633
552	8	SALIDA	1.00	14.00	13.00	\N	\N	Mesa #7 - M7-0222-0001	9	2026-02-22 21:12:58.331926
553	80	SALIDA	1.00	100.00	99.00	\N	\N	Mesa #4 - M4-0222-0002	9	2026-02-22 21:44:39.649188
554	32	SALIDA	1.00	48.00	47.00	\N	\N	Mesa #4 - M4-0222-0002	9	2026-02-22 21:44:39.669608
555	10	SALIDA	1.00	11.00	10.00	\N	\N	Mesa #7 - M7-0222-0002	10	2026-02-22 22:01:34.539542
556	21	SALIDA	1.00	49.00	48.00	\N	\N	Mesa #7 - M7-0222-0002	10	2026-02-22 22:01:34.556818
557	35	SALIDA	2.00	47.00	45.00	\N	\N	Mesa #7 - M7-0222-0002	10	2026-02-22 22:01:34.568519
558	21	SALIDA	1.00	48.00	47.00	\N	\N	Mesa #7 - M7-0222-0002	10	2026-02-22 22:07:55.565289
559	35	SALIDA	1.00	45.00	44.00	\N	\N	Mesa #7 - M7-0222-0002	10	2026-02-22 22:07:55.585825
560	10	SALIDA	1.00	10.00	9.00	\N	\N	Mesa #7 - M7-0222-0002	10	2026-02-22 22:24:49.803096
561	19	SALIDA	1.00	42.00	41.00	\N	\N	Mesa #3 - M3-0222-0005	9	2026-02-22 22:29:36.630054
562	3	SALIDA	1.00	15.00	14.00	\N	\N	Mesa #3 - M3-0222-0005	9	2026-02-22 22:29:36.645759
563	31	SALIDA	1.00	49.00	48.00	\N	\N	Mesa #3 - M3-0222-0005	9	2026-02-22 22:29:36.659606
564	43	SALIDA	1.00	49.00	48.00	\N	\N	Mesa #3 - M3-0222-0005	9	2026-02-22 23:03:27.092048
565	79	SALIDA	1.00	100.00	99.00	\N	\N	Mesa #8 - M8-0223-0001	9	2026-02-23 18:54:25.014728
566	3	SALIDA	1.00	14.00	13.00	\N	\N	Mesa #8 - M8-0223-0001	9	2026-02-23 18:54:25.062008
567	10	SALIDA	1.00	9.00	8.00	\N	\N	Mesa #8 - M8-0223-0001	9	2026-02-23 18:54:25.086997
568	20	SALIDA	2.00	42.00	40.00	\N	\N	Venta - Factura V0223-0001	9	2026-02-23 20:37:40.238573
569	11	SALIDA	1.00	10.00	9.00	\N	\N	Venta - Factura V0223-0001	9	2026-02-23 20:37:40.260101
570	19	SALIDA	1.00	41.00	40.00	\N	\N	Venta - Factura V0223-0001	9	2026-02-23 20:37:40.272645
571	23	SALIDA	1.00	48.00	47.00	\N	\N	Venta - Factura V0223-0002	9	2026-02-23 22:33:12.67696
572	34	SALIDA	1.00	49.00	48.00	\N	\N	Venta - Factura V0223-0002	9	2026-02-23 22:33:12.722955
573	76	SALIDA	1.00	50.00	49.00	\N	\N	Venta - Factura V0223-0003	9	2026-02-23 22:34:12.770708
574	66	SALIDA	1.00	47.00	46.00	\N	\N	Venta - Factura V0223-0003	9	2026-02-23 22:34:12.791355
575	3	ENTRADA	1.00	13.00	14.00	\N	\N	Anulación - Factura M8-0223-0001	9	2026-02-23 22:40:48.736612
576	10	ENTRADA	1.00	8.00	9.00	\N	\N	Anulación - Factura M8-0223-0001	9	2026-02-23 22:40:48.747749
577	79	ENTRADA	1.00	99.00	100.00	\N	\N	Anulación - Factura M8-0223-0001	9	2026-02-23 22:40:48.753749
578	3	SALIDA	1.00	14.00	13.00	\N	\N	Venta - Factura V0223-0004	9	2026-02-23 22:42:09.819779
579	10	SALIDA	1.00	9.00	8.00	\N	\N	Venta - Factura V0223-0004	9	2026-02-23 22:42:09.838782
580	79	SALIDA	1.00	100.00	99.00	\N	\N	Venta - Factura V0223-0004	9	2026-02-23 22:42:09.852829
581	20	SALIDA	2.00	40.00	38.00	\N	\N	Venta - Factura V0225-0001	9	2026-02-25 18:43:36.384418
582	18	SALIDA	1.00	49.00	48.00	\N	\N	Venta - Factura V0225-0001	9	2026-02-25 18:43:36.423571
583	43	SALIDA	1.00	48.00	47.00	\N	\N	Venta - Factura V0225-0001	9	2026-02-25 18:43:36.44912
584	31	SALIDA	1.00	48.00	47.00	\N	\N	Venta - Factura V0225-0001	9	2026-02-25 18:43:36.495816
585	20	SALIDA	2.00	38.00	36.00	\N	\N	Venta - Factura V0225-0002	9	2026-02-25 18:45:37.600455
586	18	SALIDA	1.00	48.00	47.00	\N	\N	Venta - Factura V0225-0002	9	2026-02-25 18:45:37.619344
587	43	SALIDA	1.00	47.00	46.00	\N	\N	Venta - Factura V0225-0002	9	2026-02-25 18:45:37.66362
588	6	SALIDA	1.00	6.00	5.00	\N	\N	Venta - Factura V0225-0002	9	2026-02-25 18:45:37.692186
589	31	SALIDA	1.00	47.00	46.00	\N	\N	Venta - Factura V0225-0002	9	2026-02-25 18:45:37.732598
590	20	SALIDA	1.00	36.00	35.00	\N	\N	Venta - Factura V0225-0003	9	2026-02-25 18:46:48.058963
591	3	SALIDA	1.00	13.00	12.00	\N	\N	Venta - Factura V0225-0003	9	2026-02-25 18:46:48.075304
592	20	ENTRADA	2.00	35.00	37.00	\N	\N	Anulación - Factura V0225-0002	9	2026-02-25 19:01:44.249052
593	18	ENTRADA	1.00	47.00	48.00	\N	\N	Anulación - Factura V0225-0002	9	2026-02-25 19:01:44.271797
594	43	ENTRADA	1.00	46.00	47.00	\N	\N	Anulación - Factura V0225-0002	9	2026-02-25 19:01:44.280252
595	6	ENTRADA	1.00	5.00	6.00	\N	\N	Anulación - Factura V0225-0002	9	2026-02-25 19:01:44.292106
596	31	ENTRADA	1.00	46.00	47.00	\N	\N	Anulación - Factura V0225-0002	9	2026-02-25 19:01:44.298944
597	20	ENTRADA	2.00	37.00	39.00	\N	\N	Anulación - Factura V0225-0001	9	2026-02-25 19:02:13.603806
598	18	ENTRADA	1.00	48.00	49.00	\N	\N	Anulación - Factura V0225-0001	9	2026-02-25 19:02:13.61724
599	43	ENTRADA	1.00	47.00	48.00	\N	\N	Anulación - Factura V0225-0001	9	2026-02-25 19:02:13.626263
600	31	ENTRADA	1.00	47.00	48.00	\N	\N	Anulación - Factura V0225-0001	9	2026-02-25 19:02:13.63634
601	20	SALIDA	2.00	39.00	37.00	\N	\N	Venta - Factura V0225-0004	9	2026-02-25 19:03:33.998894
602	18	SALIDA	1.00	49.00	48.00	\N	\N	Venta - Factura V0225-0004	9	2026-02-25 19:03:34.011716
603	6	SALIDA	1.00	6.00	5.00	\N	\N	Venta - Factura V0225-0004	9	2026-02-25 19:03:34.02218
604	31	SALIDA	1.00	48.00	47.00	\N	\N	Venta - Factura V0225-0004	9	2026-02-25 19:03:34.039327
605	43	SALIDA	1.00	48.00	47.00	\N	\N	Venta - Factura V0225-0004	9	2026-02-25 19:03:34.049609
606	2	SALIDA	1.00	12.00	11.00	\N	\N	Mesa #8 - M8-0225-0001	9	2026-02-25 19:06:48.4419
607	30	SALIDA	1.00	50.00	49.00	\N	\N	Mesa #8 - M8-0225-0001	9	2026-02-25 19:06:48.493614
608	79	SALIDA	1.00	99.00	98.00	\N	\N	Mesa #8 - M8-0225-0001	9	2026-02-25 19:06:48.538056
609	36	SALIDA	1.00	49.00	48.00	\N	\N	Mesa #8 - M8-0225-0001	9	2026-02-25 19:06:48.628911
610	75	SALIDA	1.00	49.00	48.00	\N	\N	Mesa #8 - M8-0225-0001	9	2026-02-25 19:06:48.663476
611	81	SALIDA	1.00	100.00	99.00	\N	\N	Venta - Factura V0225-0005	9	2026-02-25 19:28:51.868394
612	21	SALIDA	1.00	47.00	46.00	\N	\N	Venta - Factura V0225-0005	9	2026-02-25 19:28:51.900962
613	20	SALIDA	1.00	37.00	36.00	\N	\N	Venta - Factura V0225-0005	9	2026-02-25 19:28:51.94571
614	63	SALIDA	1.00	45.00	44.00	\N	\N	Venta - Factura V0225-0005	9	2026-02-25 19:28:51.971087
615	79	SALIDA	1.00	98.00	97.00	\N	\N	Mesa #7 - M7-0225-0001	9	2026-02-25 19:54:52.414077
616	51	SALIDA	1.00	49.00	48.00	\N	\N	Mesa #7 - M7-0225-0001	9	2026-02-25 19:54:52.493897
617	3	SALIDA	1.00	12.00	11.00	\N	\N	Mesa #6 - M6-0225-0001	9	2026-02-25 19:58:52.531708
618	7	SALIDA	1.00	17.00	16.00	\N	\N	Mesa #6 - M6-0225-0001	9	2026-02-25 19:58:52.601652
619	70	SALIDA	2.00	48.00	46.00	\N	\N	Mesa #6 - M6-0225-0001	9	2026-02-25 19:58:52.646346
620	8	SALIDA	1.00	13.00	12.00	\N	\N	Mesa #3 - M3-0225-0002	9	2026-02-25 20:31:13.662374
621	43	SALIDA	1.00	47.00	46.00	\N	\N	Mesa #3 - M3-0225-0002	9	2026-02-25 20:31:13.792043
622	20	SALIDA	1.00	36.00	35.00	\N	\N	Mesa #8 - M8-0225-0002	9	2026-02-25 21:34:49.966517
623	3	SALIDA	1.00	11.00	10.00	\N	\N	Mesa #6 - M6-0226-0001	9	2026-02-26 21:01:34.751601
624	35	SALIDA	1.00	44.00	43.00	\N	\N	Mesa #6 - M6-0226-0001	9	2026-02-26 21:01:34.776554
625	2	SALIDA	1.00	11.00	10.00	\N	\N	Venta - Factura V0226-0001	9	2026-02-26 21:01:51.123891
626	19	SALIDA	1.00	40.00	39.00	\N	\N	Mesa #3 - M3-0226-0001	9	2026-02-26 21:23:35.275742
627	21	SALIDA	1.00	46.00	45.00	\N	\N	Mesa #3 - M3-0226-0001	9	2026-02-26 21:23:35.298501
628	37	SALIDA	1.00	47.00	46.00	\N	\N	Mesa #3 - M3-0226-0001	9	2026-02-26 21:23:35.330205
629	82	SALIDA	1.00	100.00	99.00	\N	\N	Mesa #3 - M3-0226-0001	9	2026-02-26 21:50:28.862179
630	77	SALIDA	1.00	48.00	47.00	\N	\N	Mesa #6 - M6-0226-0001	9	2026-02-26 21:50:43.469604
631	19	SALIDA	1.00	39.00	38.00	\N	\N	Mesa #8 - M8-0226-0001	9	2026-02-26 21:52:14.0765
632	31	SALIDA	1.00	47.00	46.00	\N	\N	Mesa #8 - M8-0226-0001	9	2026-02-26 21:54:47.363655
633	19	ENTRADA	1.00	38.00	39.00	\N	\N	Anulación - Factura M8-0226-0001	9	2026-02-26 21:56:38.349952
634	31	ENTRADA	1.00	46.00	47.00	\N	\N	Anulación - Factura M8-0226-0001	9	2026-02-26 21:56:38.358762
635	19	SALIDA	1.00	39.00	38.00	\N	\N	Venta - Factura V0226-0002	9	2026-02-26 22:03:59.422119
636	31	SALIDA	1.00	47.00	46.00	\N	\N	Venta - Factura V0226-0002	9	2026-02-26 22:03:59.440146
637	18	SALIDA	1.00	48.00	47.00	\N	\N	Mesa #8 - M8-0226-0002	9	2026-02-26 22:11:32.415595
638	18	ENTRADA	1.00	47.00	48.00	\N	\N	Anulación - Factura M8-0226-0002	9	2026-02-26 22:25:08.313648
639	18	SALIDA	1.00	48.00	47.00	\N	\N	Venta - Factura V0226-0003	9	2026-02-26 22:25:15.865425
640	6	SALIDA	1.00	5.00	4.00	\N	\N	Mesa #6 - M6-0227-0001	9	2026-02-27 18:38:32.873771
641	76	SALIDA	1.00	49.00	48.00	\N	\N	Mesa #6 - M6-0227-0001	9	2026-02-27 18:38:32.958693
642	38	SALIDA	1.00	49.00	48.00	\N	\N	Mesa #6 - M6-0227-0001	9	2026-02-27 18:38:33.040199
643	28	SALIDA	1.00	49.00	48.00	\N	\N	Mesa #6 - M6-0227-0001	9	2026-02-27 18:38:33.126524
644	7	SALIDA	1.00	16.00	15.00	\N	\N	Mesa #7 - M7-0227-0001	9	2026-02-27 19:43:49.821363
645	38	SALIDA	1.00	48.00	47.00	\N	\N	Mesa #7 - M7-0227-0001	9	2026-02-27 19:43:49.881514
646	19	SALIDA	1.00	38.00	37.00	\N	\N	Mesa #7 - M7-0227-0001	9	2026-02-27 19:43:49.910677
647	20	SALIDA	1.00	35.00	34.00	\N	\N	Mesa #7 - M7-0227-0001	9	2026-02-27 19:43:49.937757
648	77	SALIDA	1.00	47.00	46.00	\N	\N	Mesa #7 - M7-0227-0001	9	2026-02-27 19:43:49.965271
649	66	SALIDA	1.00	46.00	45.00	\N	\N	Mesa #7 - M7-0227-0001	9	2026-02-27 19:43:49.991828
650	54	SALIDA	1.00	50.00	49.00	\N	\N	Mesa #7 - M7-0227-0001	9	2026-02-27 19:58:41.328076
651	8	SALIDA	1.00	12.00	11.00	\N	\N	Mesa #6 - M6-0227-0002	10	2026-02-27 20:16:08.977845
652	6	SALIDA	1.00	4.00	3.00	\N	\N	Mesa #6 - M6-0227-0002	10	2026-02-27 20:16:09.006356
653	50	SALIDA	1.00	50.00	49.00	\N	\N	Mesa #6 - M6-0227-0002	10	2026-02-27 20:16:09.036756
654	70	SALIDA	1.00	46.00	45.00	\N	\N	Mesa #6 - M6-0227-0002	10	2026-02-27 20:16:09.056614
655	74	SALIDA	1.00	46.00	45.00	\N	\N	Mesa #8 - M8-0227-0001	9	2026-02-27 20:41:01.547109
656	74	SALIDA	1.00	45.00	44.00	\N	\N	Mesa #8 - M8-0227-0001	9	2026-02-27 20:41:28.589206
657	78	SALIDA	1.00	45.00	44.00	\N	\N	Mesa #7 - M7-0227-0002	9	2026-02-27 21:00:25.65849
658	18	SALIDA	1.00	47.00	46.00	\N	\N	Mesa #4 - M4-0227-0001	9	2026-02-27 21:58:23.060202
659	18	SALIDA	1.00	46.00	45.00	\N	\N	Mesa #4 - M4-0227-0001	9	2026-02-27 21:58:57.217478
660	23	SALIDA	1.00	47.00	46.00	\N	\N	Mesa #4 - M4-0227-0001	9	2026-02-27 21:58:57.233696
661	35	SALIDA	1.00	43.00	42.00	\N	\N	Mesa #3 - M3-0227-0001	9	2026-02-27 21:59:40.965161
662	31	SALIDA	1.00	46.00	45.00	\N	\N	Mesa #3 - M3-0227-0001	9	2026-02-27 21:59:40.981527
663	11	SALIDA	2.00	9.00	7.00	\N	\N	Mesa #3 - M3-0227-0001	9	2026-02-27 21:59:41.001817
664	18	ENTRADA	2.00	45.00	47.00	\N	\N	Eliminado de Mesa #4	9	2026-02-27 21:59:53.045576
665	23	ENTRADA	1.00	46.00	47.00	\N	\N	Eliminado de Mesa #4	9	2026-02-27 21:59:56.188639
666	18	SALIDA	1.00	47.00	46.00	\N	\N	Mesa #4 - M4-0227-0002	9	2026-02-27 22:01:08.618045
667	22	SALIDA	1.00	50.00	49.00	\N	\N	Mesa #4 - M4-0227-0002	9	2026-02-27 22:01:08.639734
668	77	SALIDA	2.00	46.00	44.00	\N	\N	Mesa #4 - M4-0227-0002	9	2026-02-27 22:01:08.657517
669	66	SALIDA	1.00	45.00	44.00	\N	\N	Mesa #4 - M4-0227-0002	9	2026-02-27 22:01:08.673626
670	34	SALIDA	1.00	48.00	47.00	\N	\N	Mesa #4 - M4-0227-0002	9	2026-02-27 22:01:08.696985
671	6	SALIDA	1.00	3.00	2.00	\N	\N	Mesa #6 - M6-0227-0003	9	2026-02-27 22:02:03.354425
672	23	SALIDA	1.00	47.00	46.00	\N	\N	Mesa #6 - M6-0227-0003	9	2026-02-27 22:02:03.373512
673	8	SALIDA	1.00	11.00	10.00	\N	\N	Mesa #6 - M6-0227-0003	9	2026-02-27 22:02:03.388225
674	47	SALIDA	1.00	50.00	49.00	\N	\N	Mesa #6 - M6-0227-0003	9	2026-02-27 22:02:03.403086
675	34	SALIDA	1.00	47.00	46.00	\N	\N	Mesa #6 - M6-0227-0003	9	2026-02-27 22:02:03.419599
676	43	SALIDA	1.00	46.00	45.00	\N	\N	Mesa #6 - M6-0227-0003	9	2026-02-27 22:02:03.435065
677	51	SALIDA	1.00	48.00	47.00	\N	\N	Mesa #7 - M7-0227-0002	9	2026-02-27 22:02:32.415557
678	77	SALIDA	1.00	44.00	43.00	\N	\N	Mesa #7 - M7-0227-0002	9	2026-02-27 22:02:53.633713
679	77	SALIDA	1.00	43.00	42.00	\N	\N	Mesa #6 - M6-0227-0003	9	2026-02-27 22:03:12.099006
680	77	ENTRADA	1.00	42.00	43.00	\N	\N	Eliminado de Mesa #7	9	2026-02-27 22:03:16.815247
681	77	ENTRADA	1.00	43.00	44.00	\N	\N	Eliminado de Mesa #6	9	2026-02-27 22:15:51.52192
682	19	SALIDA	1.00	37.00	36.00	\N	\N	Mesa #8 - M8-0227-0002	9	2026-02-27 22:50:01.234006
683	57	SALIDA	2.00	50.00	48.00	\N	\N	Mesa #5 - M5-0227-0001	9	2026-02-27 22:50:48.655753
684	5	SALIDA	1.00	21.00	20.00	\N	\N	Mesa #5 - M5-0227-0001	9	2026-02-27 22:50:48.679959
685	74	SALIDA	1.00	44.00	43.00	\N	\N	Mesa #7 - M7-0227-0002	9	2026-02-27 22:57:11.93506
686	8	SALIDA	1.00	10.00	9.00	\N	\N	Venta - Factura V0227-0001	9	2026-02-27 23:20:46.246452
687	6	SALIDA	1.00	2.00	1.00	\N	\N	Venta - Factura V0227-0001	9	2026-02-27 23:20:46.264107
688	50	SALIDA	1.00	49.00	48.00	\N	\N	Venta - Factura V0227-0001	9	2026-02-27 23:20:46.278972
689	70	SALIDA	1.00	45.00	44.00	\N	\N	Venta - Factura V0227-0001	9	2026-02-27 23:20:46.291587
690	8	ENTRADA	1.00	9.00	10.00	\N	\N	Anulación - Factura M6-0227-0002	9	2026-02-27 23:20:59.271659
691	6	ENTRADA	1.00	1.00	2.00	\N	\N	Anulación - Factura M6-0227-0002	9	2026-02-27 23:20:59.278068
692	50	ENTRADA	1.00	48.00	49.00	\N	\N	Anulación - Factura M6-0227-0002	9	2026-02-27 23:20:59.28921
693	70	ENTRADA	1.00	44.00	45.00	\N	\N	Anulación - Factura M6-0227-0002	9	2026-02-27 23:20:59.299193
694	27	SALIDA	1.00	50.00	49.00	\N	\N	Venta - Factura V0228-0001	9	2026-02-28 17:15:26.284425
695	6	SALIDA	1.00	2.00	1.00	\N	\N	Mesa #5 - M5-0228-0001	10	2026-02-28 17:29:48.368727
696	18	SALIDA	1.00	46.00	45.00	\N	\N	Mesa #5 - M5-0228-0001	10	2026-02-28 17:29:48.405803
697	46	SALIDA	1.00	49.00	48.00	\N	\N	Mesa #5 - M5-0228-0001	10	2026-02-28 17:29:48.433163
698	23	SALIDA	1.00	46.00	45.00	\N	\N	Mesa #6 - M6-0228-0001	1	2026-02-28 18:11:20.274566
699	20	SALIDA	1.00	34.00	33.00	\N	\N	Mesa #6 - M6-0228-0001	1	2026-02-28 18:11:20.313038
700	43	SALIDA	1.00	45.00	44.00	\N	\N	Mesa #6 - M6-0228-0001	1	2026-02-28 18:11:20.339972
701	48	SALIDA	1.00	49.00	48.00	\N	\N	Mesa #6 - M6-0228-0001	1	2026-02-28 18:11:20.364832
702	21	SALIDA	2.00	45.00	43.00	\N	\N	Mesa #7 - M7-0228-0001	1	2026-02-28 18:17:03.525811
703	9	SALIDA	1.00	15.00	14.00	\N	\N	Mesa #7 - M7-0228-0001	1	2026-02-28 18:17:03.561839
704	50	SALIDA	3.00	49.00	46.00	\N	\N	Mesa #7 - M7-0228-0001	1	2026-02-28 18:17:03.587568
705	77	SALIDA	1.00	44.00	43.00	\N	\N	Mesa #5 - M5-0228-0001	1	2026-02-28 18:22:25.993565
706	78	SALIDA	1.00	44.00	43.00	\N	\N	Mesa #5 - M5-0228-0001	9	2026-02-28 18:28:31.371249
707	28	SALIDA	1.00	48.00	47.00	\N	\N	Mesa #5 - M5-0228-0001	9	2026-02-28 18:28:50.106442
708	19	SALIDA	1.00	36.00	35.00	\N	\N	Mesa #8 - M8-0228-0001	9	2026-02-28 18:40:42.687356
709	8	SALIDA	1.00	10.00	9.00	\N	\N	Mesa #3 - M3-0228-0001	10	2026-02-28 18:47:44.129294
710	78	SALIDA	1.00	43.00	42.00	\N	\N	Mesa #3 - M3-0228-0001	10	2026-02-28 18:47:44.160639
711	51	SALIDA	2.00	47.00	45.00	\N	\N	Mesa #3 - M3-0228-0001	10	2026-02-28 18:47:44.182927
712	6	SALIDA	1.00	1.00	0.00	\N	\N	Mesa #5 - M5-0228-0002	10	2026-02-28 18:49:39.603194
713	70	SALIDA	2.00	45.00	43.00	\N	\N	Mesa #5 - M5-0228-0002	10	2026-02-28 18:49:39.639894
714	10	SALIDA	1.00	8.00	7.00	\N	\N	Mesa #5 - M5-0228-0002	10	2026-02-28 18:49:39.665086
715	8	SALIDA	1.00	9.00	8.00	\N	\N	Mesa #10 - M10-0228-0001	1	2026-02-28 19:14:21.172504
716	8	SALIDA	1.00	8.00	7.00	\N	\N	Mesa #8 - M8-0228-0002	1	2026-02-28 19:30:26.326054
717	10	SALIDA	1.00	7.00	6.00	\N	\N	Mesa #8 - M8-0228-0002	1	2026-02-28 19:30:26.35801
718	11	SALIDA	1.00	7.00	6.00	\N	\N	Mesa #8 - M8-0228-0002	1	2026-02-28 19:30:26.379889
719	20	SALIDA	1.00	33.00	32.00	\N	\N	Mesa #8 - M8-0228-0002	1	2026-02-28 19:30:26.412288
720	76	SALIDA	1.00	48.00	47.00	\N	\N	Mesa #6 - M6-0228-0001	1	2026-02-28 19:36:54.674384
721	48	SALIDA	1.00	48.00	47.00	\N	\N	Mesa #6 - M6-0228-0001	10	2026-02-28 19:41:43.99028
722	19	SALIDA	1.00	35.00	34.00	\N	\N	Mesa #8 - M8-0228-0003	1	2026-02-28 19:52:02.027123
723	3	SALIDA	1.00	10.00	9.00	\N	\N	Mesa #8 - M8-0228-0003	1	2026-02-28 19:52:02.050454
724	24	SALIDA	1.00	50.00	49.00	\N	\N	Mesa #8 - M8-0228-0003	1	2026-02-28 19:53:08.016999
725	6	ENTRADA	100.00	0.00	100.00	\N	\N	ajuste\n	1	2026-02-28 20:01:06.195597
726	3	SALIDA	1.00	9.00	8.00	\N	\N	Mesa #7 - M7-0228-0002	10	2026-02-28 20:10:17.758318
727	23	SALIDA	1.00	45.00	44.00	\N	\N	Mesa #7 - M7-0228-0002	10	2026-02-28 20:10:17.783017
728	37	SALIDA	1.00	46.00	45.00	\N	\N	Mesa #7 - M7-0228-0002	10	2026-02-28 20:10:17.805099
729	35	SALIDA	1.00	42.00	41.00	\N	\N	Mesa #7 - M7-0228-0002	10	2026-02-28 20:10:17.823862
730	3	SALIDA	1.00	8.00	7.00	\N	\N	Mesa #5 - M5-0228-0003	1	2026-02-28 20:36:19.578289
731	22	SALIDA	1.00	49.00	48.00	\N	\N	Mesa #5 - M5-0228-0003	1	2026-02-28 20:36:19.603398
732	47	SALIDA	4.00	49.00	45.00	\N	\N	Mesa #5 - M5-0228-0003	1	2026-02-28 20:36:19.618931
733	83	SALIDA	2.00	100.00	98.00	\N	\N	Mesa #5 - M5-0228-0003	1	2026-02-28 20:36:34.337334
734	47	ENTRADA	4.00	45.00	49.00	\N	\N	Eliminado de Mesa #5	1	2026-02-28 20:36:46.638753
735	46	SALIDA	4.00	48.00	44.00	\N	\N	Mesa #5 - M5-0228-0003	1	2026-02-28 20:37:19.275955
736	25	SALIDA	1.00	49.00	48.00	\N	\N	Mesa #5 - M5-0228-0003	1	2026-02-28 20:50:45.681493
737	8	SALIDA	1.00	7.00	6.00	\N	\N	Mesa #6 - M6-0228-0002	1	2026-02-28 21:05:28.354553
738	2	SALIDA	1.00	10.00	9.00	\N	\N	Mesa #6 - M6-0228-0002	1	2026-02-28 21:05:28.380828
739	32	SALIDA	2.00	47.00	45.00	\N	\N	Mesa #6 - M6-0228-0002	1	2026-02-28 21:05:28.41725
740	17	SALIDA	1.00	50.00	49.00	\N	\N	Mesa #7 - M7-0228-0003	1	2026-02-28 21:32:53.378181
741	23	SALIDA	1.00	44.00	43.00	\N	\N	Mesa #7 - M7-0228-0003	1	2026-02-28 21:32:53.407654
742	8	SALIDA	1.00	6.00	5.00	\N	\N	Mesa #7 - M7-0228-0003	1	2026-02-28 21:32:53.44032
743	34	SALIDA	1.00	46.00	45.00	\N	\N	Mesa #7 - M7-0228-0003	1	2026-02-28 21:32:53.477203
744	35	SALIDA	1.00	41.00	40.00	\N	\N	Mesa #7 - M7-0228-0003	1	2026-02-28 21:32:53.510519
745	22	SALIDA	1.00	48.00	47.00	\N	\N	Mesa #2 - M2-0228-0001	1	2026-02-28 21:40:00.134355
746	2	SALIDA	1.00	9.00	8.00	\N	\N	Mesa #2 - M2-0228-0001	1	2026-02-28 21:40:00.159348
747	28	SALIDA	2.00	47.00	45.00	\N	\N	Mesa #2 - M2-0228-0001	1	2026-02-28 21:40:00.178683
748	19	SALIDA	1.00	34.00	33.00	\N	\N	Mesa #3 - M3-0228-0002	1	2026-02-28 21:50:14.143769
749	9	SALIDA	1.00	14.00	13.00	\N	\N	Mesa #3 - M3-0228-0002	1	2026-02-28 21:50:14.192893
750	27	SALIDA	2.00	49.00	47.00	\N	\N	Mesa #3 - M3-0228-0002	1	2026-02-28 21:50:14.223572
751	3	SALIDA	2.00	7.00	5.00	\N	\N	Mesa #4 - M4-0228-0001	1	2026-02-28 21:52:39.289762
752	2	SALIDA	1.00	8.00	7.00	\N	\N	Mesa #4 - M4-0228-0001	1	2026-02-28 21:52:39.312361
753	20	SALIDA	2.00	32.00	30.00	\N	\N	Mesa #4 - M4-0228-0001	1	2026-02-28 21:52:39.338084
754	19	SALIDA	1.00	33.00	32.00	\N	\N	Mesa #4 - M4-0228-0001	1	2026-02-28 21:52:39.35988
755	21	SALIDA	1.00	43.00	42.00	\N	\N	Mesa #4 - M4-0228-0001	1	2026-02-28 21:52:39.385337
756	37	SALIDA	2.00	45.00	43.00	\N	\N	Mesa #4 - M4-0228-0001	1	2026-02-28 21:52:39.406826
757	35	SALIDA	1.00	40.00	39.00	\N	\N	Mesa #4 - M4-0228-0001	1	2026-02-28 21:52:39.425733
758	31	SALIDA	1.00	45.00	44.00	\N	\N	Mesa #4 - M4-0228-0001	1	2026-02-28 21:52:39.44249
759	50	SALIDA	1.00	46.00	45.00	\N	\N	Mesa #4 - M4-0228-0001	1	2026-02-28 21:52:39.461004
760	48	SALIDA	2.00	47.00	45.00	\N	\N	Mesa #4 - M4-0228-0001	1	2026-02-28 21:52:39.478491
761	6	SALIDA	1.00	100.00	99.00	\N	\N	Mesa #5 - M5-0228-0004	1	2026-02-28 21:53:57.067217
762	23	SALIDA	2.00	43.00	41.00	\N	\N	Mesa #5 - M5-0228-0004	1	2026-02-28 21:53:57.088307
763	37	SALIDA	2.00	43.00	41.00	\N	\N	Mesa #5 - M5-0228-0004	1	2026-02-28 21:53:57.12568
764	43	SALIDA	1.00	44.00	43.00	\N	\N	Mesa #5 - M5-0228-0004	1	2026-02-28 21:53:57.146394
765	18	SALIDA	2.00	45.00	43.00	\N	\N	Mesa #1 - M1-0228-0001	1	2026-02-28 21:54:47.806313
766	27	SALIDA	1.00	47.00	46.00	\N	\N	Mesa #1 - M1-0228-0001	1	2026-02-28 21:54:47.821217
767	37	SALIDA	1.00	41.00	40.00	\N	\N	Mesa #1 - M1-0228-0001	1	2026-02-28 21:54:47.836388
768	19	SALIDA	1.00	32.00	31.00	\N	\N	Mesa #6 - M6-0228-0003	1	2026-02-28 21:58:06.633548
769	20	SALIDA	1.00	30.00	29.00	\N	\N	Mesa #6 - M6-0228-0003	1	2026-02-28 21:58:06.655541
770	37	SALIDA	1.00	40.00	39.00	\N	\N	Mesa #6 - M6-0228-0003	1	2026-02-28 21:58:06.671299
771	35	SALIDA	1.00	39.00	38.00	\N	\N	Mesa #6 - M6-0228-0003	1	2026-02-28 21:58:06.684741
772	37	SALIDA	1.00	39.00	38.00	\N	\N	Mesa #8 - M8-0228-0004	1	2026-02-28 22:29:25.63653
773	8	SALIDA	2.00	5.00	3.00	\N	\N	Mesa #1 - M1-0228-0002	1	2026-02-28 22:46:46.932934
774	27	SALIDA	1.00	46.00	45.00	\N	\N	Mesa #1 - M1-0228-0002	1	2026-02-28 22:46:46.954772
775	34	SALIDA	1.00	45.00	44.00	\N	\N	Mesa #1 - M1-0228-0002	1	2026-02-28 22:46:46.972274
776	48	SALIDA	3.00	45.00	42.00	\N	\N	Mesa #4 - M4-0228-0001	1	2026-02-28 22:49:13.65792
777	43	ENTRADA	1.00	43.00	44.00	\N	\N	Eliminado de Mesa #5	1	2026-02-28 22:51:19.039613
778	23	SALIDA	1.00	41.00	40.00	\N	\N	Mesa #3 - M3-0228-0003	1	2026-02-28 22:54:00.821216
779	30	SALIDA	1.00	49.00	48.00	\N	\N	Mesa #3 - M3-0228-0003	1	2026-02-28 22:54:00.836594
780	21	SALIDA	1.00	42.00	41.00	\N	\N	Mesa #3 - M3-0228-0003	1	2026-02-28 22:54:00.86134
781	35	SALIDA	1.00	38.00	37.00	\N	\N	Mesa #3 - M3-0228-0003	1	2026-02-28 22:54:00.883899
782	3	SALIDA	1.00	5.00	4.00	\N	\N	Mesa #9 - M9-0228-0001	1	2026-02-28 23:02:59.37733
783	21	SALIDA	1.00	41.00	40.00	\N	\N	Mesa #8 - M8-0228-0004	1	2026-02-28 23:03:18.489507
784	19	SALIDA	1.00	31.00	30.00	\N	\N	Mesa #6 - M6-0228-0004	1	2026-02-28 23:20:47.35234
785	20	SALIDA	1.00	29.00	28.00	\N	\N	Mesa #6 - M6-0228-0004	1	2026-02-28 23:20:47.408939
786	31	SALIDA	2.00	44.00	42.00	\N	\N	Mesa #6 - M6-0228-0004	1	2026-02-28 23:20:47.432737
787	21	ENTRADA	1.00	40.00	41.00	\N	\N	Eliminado de Mesa #8	1	2026-02-28 23:29:29.523947
788	37	ENTRADA	1.00	38.00	39.00	\N	\N	Eliminado de Mesa #8	1	2026-02-28 23:29:30.536445
789	37	SALIDA	1.00	39.00	38.00	\N	\N	Mesa #8 - M8-0228-0005	1	2026-02-28 23:29:59.135655
790	75	SALIDA	1.00	48.00	47.00	\N	\N	Mesa #6 - M6-0301-0001	10	2026-03-01 18:41:07.01283
791	70	SALIDA	1.00	43.00	42.00	\N	\N	Mesa #6 - M6-0301-0001	10	2026-03-01 18:41:07.133079
792	23	SALIDA	1.00	40.00	39.00	\N	\N	Mesa #6 - M6-0301-0001	10	2026-03-01 18:41:07.256828
793	34	SALIDA	1.00	44.00	43.00	\N	\N	Mesa #6 - M6-0301-0001	10	2026-03-01 18:41:07.428813
794	3	SALIDA	1.00	4.00	3.00	\N	\N	Mesa #5 - M5-0301-0001	1	2026-03-01 19:20:56.529745
795	15	SALIDA	1.00	49.00	48.00	\N	\N	Mesa #3 - M3-0301-0001	10	2026-03-01 19:23:22.526784
796	7	SALIDA	1.00	15.00	14.00	\N	\N	Mesa #3 - M3-0301-0001	10	2026-03-01 19:23:22.628828
797	57	SALIDA	1.00	48.00	47.00	\N	\N	Mesa #3 - M3-0301-0001	10	2026-03-01 19:23:22.715788
798	35	SALIDA	1.00	37.00	36.00	\N	\N	Mesa #3 - M3-0301-0001	10	2026-03-01 19:23:22.815388
799	5	SALIDA	1.00	20.00	19.00	\N	\N	Mesa #4 - M4-0301-0001	1	2026-03-01 19:23:27.37695
800	43	SALIDA	1.00	44.00	43.00	\N	\N	Mesa #4 - M4-0301-0001	1	2026-03-01 19:23:27.535069
801	65	SALIDA	1.00	50.00	49.00	\N	\N	Mesa #4 - M4-0301-0001	1	2026-03-01 19:23:27.610963
802	32	SALIDA	1.00	45.00	44.00	\N	\N	Mesa #4 - M4-0301-0001	1	2026-03-01 19:23:27.675666
803	45	SALIDA	1.00	50.00	49.00	\N	\N	Mesa #4 - M4-0301-0001	1	2026-03-01 19:23:48.317423
804	77	SALIDA	1.00	43.00	42.00	\N	\N	Mesa #4 - M4-0301-0001	1	2026-03-01 19:40:25.843081
805	75	SALIDA	1.00	47.00	46.00	\N	\N	Mesa #4 - M4-0301-0001	1	2026-03-01 19:40:25.880633
806	47	SALIDA	1.00	49.00	48.00	\N	\N	Mesa #6 - M6-0301-0002	10	2026-03-01 19:45:35.781983
807	32	SALIDA	1.00	44.00	43.00	\N	\N	Mesa #6 - M6-0301-0002	10	2026-03-01 19:45:35.811929
808	70	SALIDA	1.00	42.00	41.00	\N	\N	Mesa #6 - M6-0301-0002	10	2026-03-01 19:45:35.84185
809	35	SALIDA	1.00	36.00	35.00	\N	\N	Mesa #6 - M6-0301-0002	10	2026-03-01 19:45:35.866632
810	43	SALIDA	1.00	43.00	42.00	\N	\N	Mesa #6 - M6-0301-0002	10	2026-03-01 19:45:35.899845
811	47	SALIDA	1.00	48.00	47.00	\N	\N	Mesa #7 - M7-0301-0001	1	2026-03-01 19:53:15.004024
812	32	SALIDA	1.00	43.00	42.00	\N	\N	Mesa #7 - M7-0301-0001	1	2026-03-01 19:53:15.033076
813	70	SALIDA	1.00	41.00	40.00	\N	\N	Mesa #7 - M7-0301-0001	1	2026-03-01 19:53:15.056668
814	35	SALIDA	1.00	35.00	34.00	\N	\N	Mesa #7 - M7-0301-0001	1	2026-03-01 19:53:15.081966
815	43	SALIDA	1.00	42.00	41.00	\N	\N	Mesa #7 - M7-0301-0001	1	2026-03-01 19:53:15.102042
816	47	ENTRADA	1.00	47.00	48.00	\N	\N	Eliminado de Mesa #6	1	2026-03-01 19:55:26.38178
817	32	ENTRADA	1.00	42.00	43.00	\N	\N	Eliminado de Mesa #6	1	2026-03-01 19:55:27.088297
818	70	ENTRADA	1.00	40.00	41.00	\N	\N	Eliminado de Mesa #6	1	2026-03-01 19:55:28.549952
819	35	ENTRADA	1.00	34.00	35.00	\N	\N	Eliminado de Mesa #6	1	2026-03-01 19:55:29.366401
820	43	ENTRADA	1.00	41.00	42.00	\N	\N	Eliminado de Mesa #6	1	2026-03-01 19:55:30.469396
821	19	SALIDA	1.00	30.00	29.00	\N	\N	Mesa #2 - M2-0301-0001	1	2026-03-01 19:56:32.83757
822	21	SALIDA	1.00	41.00	40.00	\N	\N	Mesa #2 - M2-0301-0001	1	2026-03-01 19:56:32.857623
823	31	SALIDA	2.00	42.00	40.00	\N	\N	Mesa #2 - M2-0301-0001	1	2026-03-01 19:56:32.884654
824	10	SALIDA	1.00	6.00	5.00	\N	\N	Mesa #9 - M9-0301-0001	1	2026-03-01 20:11:57.075131
825	2	SALIDA	1.00	7.00	6.00	\N	\N	Mesa #1 - M1-0301-0001	10	2026-03-01 20:18:11.043219
826	31	SALIDA	1.00	40.00	39.00	\N	\N	Mesa #1 - M1-0301-0001	10	2026-03-01 20:18:11.081614
827	23	SALIDA	1.00	39.00	38.00	\N	\N	Mesa #1 - M1-0301-0001	10	2026-03-01 20:18:11.116805
828	52	SALIDA	1.00	40.00	39.00	\N	\N	Mesa #1 - M1-0301-0001	10	2026-03-01 20:18:11.139715
829	83	SALIDA	1.00	98.00	97.00	\N	\N	Mesa #1 - M1-0301-0001	10	2026-03-01 20:18:11.160413
830	47	SALIDA	1.00	48.00	47.00	\N	\N	Mesa #7 - M7-0301-0001	1	2026-03-01 20:23:02.293918
831	84	SALIDA	1.00	100.00	99.00	\N	\N	Mesa #7 - M7-0301-0001	1	2026-03-01 20:25:22.808146
832	3	SALIDA	1.00	3.00	2.00	\N	\N	Mesa #6 - M6-0301-0003	1	2026-03-01 20:32:53.925824
833	30	SALIDA	1.00	48.00	47.00	\N	\N	Mesa #6 - M6-0301-0003	1	2026-03-01 20:32:53.967249
834	73	SALIDA	1.00	48.00	47.00	\N	\N	Mesa #6 - M6-0301-0003	1	2026-03-01 20:32:53.990527
835	4	SALIDA	1.00	102.00	101.00	\N	\N	Mesa #6 - M6-0301-0003	1	2026-03-01 20:32:54.014968
836	21	SALIDA	1.00	40.00	39.00	\N	\N	Mesa #6 - M6-0301-0003	1	2026-03-01 20:32:54.034171
837	44	SALIDA	1.00	50.00	49.00	\N	\N	Mesa #4 - M4-0301-0001	1	2026-03-01 20:36:56.98277
838	18	SALIDA	1.00	43.00	42.00	\N	\N	Mesa #8 - M8-0301-0001	1	2026-03-01 20:40:55.045135
839	79	SALIDA	1.00	97.00	96.00	\N	\N	Mesa #5 - M5-0301-0002	1	2026-03-01 20:52:22.201633
840	43	SALIDA	1.00	42.00	41.00	\N	\N	Mesa #8 - M8-0301-0001	1	2026-03-01 20:54:37.85587
841	19	SALIDA	4.00	29.00	25.00	\N	\N	Mesa #4 - M4-0301-0001	1	2026-03-01 21:03:53.496048
842	43	SALIDA	2.00	41.00	39.00	\N	\N	Mesa #4 - M4-0301-0001	1	2026-03-01 21:03:53.547621
843	35	SALIDA	1.00	35.00	34.00	\N	\N	Mesa #4 - M4-0301-0001	1	2026-03-01 21:03:53.582374
844	8	SALIDA	1.00	3.00	2.00	\N	\N	Mesa #4 - M4-0301-0001	1	2026-03-01 21:03:53.624596
845	62	SALIDA	1.00	50.00	49.00	\N	\N	Mesa #4 - M4-0301-0001	1	2026-03-01 21:03:53.680064
846	3	SALIDA	1.00	2.00	1.00	\N	\N	Mesa #4 - M4-0301-0001	1	2026-03-01 21:03:53.700751
847	75	SALIDA	1.00	46.00	45.00	\N	\N	Mesa #4 - M4-0301-0001	1	2026-03-01 21:03:53.730875
848	20	SALIDA	1.00	28.00	27.00	\N	\N	Mesa #4 - M4-0301-0001	1	2026-03-01 21:03:53.753092
849	18	SALIDA	1.00	42.00	41.00	\N	\N	Mesa #4 - M4-0301-0001	1	2026-03-01 21:04:52.437411
850	35	SALIDA	1.00	34.00	33.00	\N	\N	Mesa #4 - M4-0301-0001	1	2026-03-01 21:09:09.338544
851	19	SALIDA	1.00	25.00	24.00	\N	\N	Mesa #4 - M4-0301-0001	1	2026-03-01 21:09:33.847819
852	8	ENTRADA	100.00	2.00	102.00	\N	\N	ajuste	1	2026-03-01 21:12:43.900052
853	10	ENTRADA	100.00	5.00	105.00	\N	\N	ajuste	1	2026-03-01 21:12:56.229528
854	3	ENTRADA	100.00	1.00	101.00	\N	\N	\N	1	2026-03-01 21:13:50.313964
855	65	SALIDA	1.00	49.00	48.00	\N	\N	Mesa #4 - M4-0301-0001	1	2026-03-01 21:16:04.421378
856	78	SALIDA	1.00	42.00	41.00	\N	\N	Mesa #4 - M4-0301-0001	1	2026-03-01 21:49:44.844186
857	66	SALIDA	2.00	44.00	42.00	\N	\N	Mesa #5 - M5-0301-0003	1	2026-03-01 21:56:10.028243
858	20	SALIDA	1.00	27.00	26.00	\N	\N	Mesa #6 - M6-0301-0004	10	2026-03-01 22:02:49.824591
859	32	SALIDA	2.00	43.00	41.00	\N	\N	Mesa #6 - M6-0301-0004	10	2026-03-01 22:02:49.861595
860	21	SALIDA	1.00	39.00	38.00	\N	\N	Mesa #6 - M6-0301-0004	10	2026-03-01 22:02:49.894162
861	6	SALIDA	1.00	99.00	98.00	\N	\N	Mesa #6 - M6-0301-0004	1	2026-03-01 22:05:16.659336
862	45	SALIDA	1.00	49.00	48.00	\N	\N	Mesa #8 - M8-0301-0001	1	2026-03-01 22:16:40.102195
863	76	SALIDA	2.00	47.00	45.00	\N	\N	Mesa #4 - M4-0301-0001	1	2026-03-01 22:32:24.148067
864	77	SALIDA	1.00	42.00	41.00	\N	\N	Mesa #5 - M5-0301-0004	1	2026-03-01 23:02:39.660319
865	76	SALIDA	1.00	45.00	44.00	\N	\N	Mesa #5 - M5-0301-0004	1	2026-03-01 23:02:39.684621
866	66	SALIDA	2.00	42.00	40.00	\N	\N	Mesa #5 - M5-0301-0004	1	2026-03-01 23:02:39.705374
867	66	SALIDA	2.00	40.00	38.00	\N	\N	Venta - Factura V0301-0001	1	2026-03-01 23:38:39.821469
868	63	SALIDA	1.00	44.00	43.00	\N	\N	Venta - Factura V0301-0001	1	2026-03-01 23:38:39.848553
869	66	SALIDA	1.00	38.00	37.00	\N	\N	Mesa #5 - M5-0301-0004	1	2026-03-01 23:39:02.460242
870	50	SALIDA	1.00	45.00	44.00	\N	\N	Venta - Factura V0302-0001	1	2026-03-02 18:05:18.357834
871	46	SALIDA	1.00	44.00	43.00	\N	\N	Venta - Factura V0302-0001	1	2026-03-02 18:05:18.374144
872	46	SALIDA	1.00	43.00	42.00	\N	\N	Venta - Factura V0302-0002	1	2026-03-02 18:05:52.071765
873	50	SALIDA	1.00	44.00	43.00	\N	\N	Venta - Factura V0302-0002	1	2026-03-02 18:05:52.086084
874	50	ENTRADA	1.00	43.00	44.00	\N	\N	Anulación - Factura V0302-0001	1	2026-03-02 18:06:18.586146
875	46	ENTRADA	1.00	42.00	43.00	\N	\N	Anulación - Factura V0302-0001	1	2026-03-02 18:06:18.594567
876	74	SALIDA	1.00	43.00	42.00	\N	\N	Mesa #4 - M4-0302-0001	1	2026-03-02 18:57:18.721331
877	10	SALIDA	4.00	105.00	101.00	\N	\N	Mesa #4 - M4-0302-0001	1	2026-03-02 18:57:56.415917
878	21	SALIDA	1.00	38.00	37.00	\N	\N	Mesa #4 - M4-0302-0001	1	2026-03-02 18:58:16.083235
879	35	SALIDA	1.00	33.00	32.00	\N	\N	Venta - Factura V0302-0003	1	2026-03-02 19:46:57.250339
880	74	SALIDA	1.00	42.00	41.00	\N	\N	Venta - Factura V0302-0004	1	2026-03-02 19:49:28.182998
881	8	SALIDA	1.00	102.00	101.00	\N	\N	Mesa #5 - M5-0302-0001	10	2026-03-02 20:49:59.101546
882	7	SALIDA	1.00	14.00	13.00	\N	\N	Mesa #5 - M5-0302-0001	10	2026-03-02 20:49:59.130879
883	36	SALIDA	1.00	48.00	47.00	\N	\N	Mesa #5 - M5-0302-0001	10	2026-03-02 20:49:59.151191
884	82	SALIDA	1.00	99.00	98.00	\N	\N	Mesa #5 - M5-0302-0001	10	2026-03-02 20:49:59.167498
885	74	ENTRADA	1.00	41.00	42.00	\N	\N	Eliminado de Mesa #4	1	2026-03-02 21:11:57.139416
886	74	SALIDA	1.00	42.00	41.00	\N	\N	Mesa #4 - M4-0302-0002	1	2026-03-02 21:13:59.649535
887	35	SALIDA	1.00	32.00	31.00	\N	\N	Mesa #3 - M3-0302-0001	1	2026-03-02 21:26:25.203146
888	8	SALIDA	1.00	101.00	100.00	\N	\N	Mesa #3 - M3-0302-0001	1	2026-03-02 21:26:44.857529
889	7	SALIDA	1.00	13.00	12.00	\N	\N	Mesa #6 - M6-0302-0001	1	2026-03-02 21:28:49.587285
890	11	SALIDA	1.00	6.00	5.00	\N	\N	Mesa #6 - M6-0302-0001	1	2026-03-02 21:29:27.947712
891	51	SALIDA	1.00	45.00	44.00	\N	\N	Mesa #6 - M6-0302-0001	1	2026-03-02 21:30:46.547798
892	57	SALIDA	1.00	47.00	46.00	\N	\N	Mesa #6 - M6-0302-0001	1	2026-03-02 21:30:46.567177
893	43	SALIDA	1.00	39.00	38.00	\N	\N	Mesa #7 - M7-0302-0001	1	2026-03-02 21:33:33.898237
894	79	SALIDA	1.00	96.00	95.00	\N	\N	Mesa #7 - M7-0302-0001	1	2026-03-02 21:33:33.91938
895	14	SALIDA	1.00	49.00	48.00	\N	\N	Mesa #7 - M7-0302-0001	1	2026-03-02 21:33:33.936638
896	79	SALIDA	1.00	95.00	94.00	\N	\N	Mesa #8 - M8-0302-0001	1	2026-03-02 21:34:28.381689
897	7	SALIDA	1.00	12.00	11.00	\N	\N	Mesa #8 - M8-0302-0001	1	2026-03-02 21:34:28.397681
898	43	SALIDA	1.00	38.00	37.00	\N	\N	Mesa #8 - M8-0302-0001	1	2026-03-02 21:34:28.412973
899	62	SALIDA	1.00	49.00	48.00	\N	\N	Mesa #8 - M8-0302-0001	1	2026-03-02 21:34:28.428483
900	62	ENTRADA	1.00	48.00	49.00	\N	\N	Eliminado de Mesa #8	1	2026-03-02 21:34:42.359194
901	7	ENTRADA	1.00	11.00	12.00	\N	\N	Eliminado de Mesa #8	1	2026-03-02 21:34:42.85067
902	79	ENTRADA	1.00	94.00	95.00	\N	\N	Eliminado de Mesa #8	1	2026-03-02 21:34:44.006314
903	43	ENTRADA	1.00	37.00	38.00	\N	\N	Eliminado de Mesa #8	1	2026-03-02 21:34:45.220533
904	85	SALIDA	1.00	100.00	99.00	\N	\N	Venta - Factura V0302-0005	1	2026-03-02 21:46:10.754076
905	79	SALIDA	1.00	95.00	94.00	\N	\N	Venta - Factura V0302-0005	1	2026-03-02 21:46:10.775419
906	14	SALIDA	1.00	48.00	47.00	\N	\N	Venta - Factura V0302-0005	1	2026-03-02 21:46:10.787582
907	43	SALIDA	1.00	38.00	37.00	\N	\N	Venta - Factura V0302-0005	1	2026-03-02 21:46:10.800069
908	66	SALIDA	1.00	37.00	36.00	\N	\N	Mesa #6 - M6-0302-0001	1	2026-03-02 21:47:58.820544
909	43	ENTRADA	1.00	37.00	38.00	\N	\N	Anulación - Factura M7-0302-0001	1	2026-03-02 21:58:29.215371
910	79	ENTRADA	1.00	94.00	95.00	\N	\N	Anulación - Factura M7-0302-0001	1	2026-03-02 21:58:29.229986
911	14	ENTRADA	1.00	47.00	48.00	\N	\N	Anulación - Factura M7-0302-0001	1	2026-03-02 21:58:29.236115
912	51	SALIDA	1.00	44.00	43.00	\N	\N	Mesa #9 - M9-0304-0001	1	2026-03-04 13:48:17.255806
913	13	SALIDA	1.00	49.00	48.00	\N	\N	Mesa #9 - M9-0304-0001	1	2026-03-04 13:48:17.329601
914	46	SALIDA	1.00	43.00	42.00	\N	\N	Mesa #9 - M9-0304-0001	1	2026-03-04 13:48:41.256799
915	22	SALIDA	1.00	47.00	46.00	\N	\N	Mesa #9 - M9-0304-0001	1	2026-03-04 13:48:41.320702
916	62	SALIDA	1.00	49.00	48.00	\N	\N	Mesa #9 - M9-0304-0001	1	2026-03-04 13:48:41.392623
917	23	SALIDA	1.00	38.00	37.00	\N	\N	Mesa #9 - M9-0304-0001	1	2026-03-04 13:48:41.45075
918	51	ENTRADA	1.00	43.00	44.00	\N	\N	Eliminado de Mesa #9	1	2026-03-04 13:48:46.772019
919	13	ENTRADA	1.00	48.00	49.00	\N	\N	Eliminado de Mesa #9	1	2026-03-04 13:48:47.282466
920	46	ENTRADA	1.00	42.00	43.00	\N	\N	Eliminado de Mesa #9	1	2026-03-04 13:48:47.689177
921	22	ENTRADA	1.00	46.00	47.00	\N	\N	Eliminado de Mesa #9	1	2026-03-04 13:48:49.155353
922	62	ENTRADA	1.00	48.00	49.00	\N	\N	Eliminado de Mesa #9	1	2026-03-04 13:48:49.781483
923	23	ENTRADA	1.00	37.00	38.00	\N	\N	Eliminado de Mesa #9	1	2026-03-04 13:48:51.003405
924	15	SALIDA	2.00	48.00	46.00	\N	\N	Mesa #1 - M1-0304-0001	1	2026-03-04 18:14:24.245465
925	65	SALIDA	1.00	48.00	47.00	\N	\N	Mesa #1 - M1-0304-0001	1	2026-03-04 18:14:24.333467
926	15	ENTRADA	2.00	46.00	48.00	\N	\N	Eliminado de Mesa #1	1	2026-03-04 18:14:34.843239
927	15	SALIDA	1.00	48.00	47.00	\N	\N	Mesa #1 - M1-0304-0001	1	2026-03-04 18:14:49.640194
928	86	SALIDA	1.00	100.00	99.00	\N	\N	Mesa #1 - M1-0304-0001	1	2026-03-04 18:50:22.051256
929	77	SALIDA	1.00	41.00	40.00	\N	\N	Mesa #1 - M1-0304-0001	1	2026-03-04 18:50:38.674151
930	20	SALIDA	1.00	26.00	25.00	\N	\N	Venta - Factura V0304-0001	1	2026-03-04 19:28:44.51572
931	79	SALIDA	1.00	95.00	94.00	\N	\N	Mesa #6 - M6-0304-0001	1	2026-03-04 19:46:32.165635
932	2	SALIDA	1.00	6.00	5.00	\N	\N	Mesa #7 - M7-0304-0001	10	2026-03-04 20:04:29.197676
933	19	SALIDA	1.00	24.00	23.00	\N	\N	Mesa #7 - M7-0304-0001	10	2026-03-04 20:04:29.24546
934	36	SALIDA	1.00	47.00	46.00	\N	\N	Mesa #7 - M7-0304-0001	10	2026-03-04 20:04:29.273753
935	81	SALIDA	1.00	99.00	98.00	\N	\N	Mesa #7 - M7-0304-0001	10	2026-03-04 20:04:29.299246
936	83	SALIDA	1.00	97.00	96.00	\N	\N	Mesa #7 - M7-0304-0001	10	2026-03-04 20:04:29.323342
937	6	SALIDA	1.00	98.00	97.00	\N	\N	Mesa #7 - M7-0304-0001	10	2026-03-04 20:04:29.342688
938	8	SALIDA	1.00	100.00	99.00	\N	\N	Mesa #4 - M4-0304-0001	10	2026-03-04 20:43:25.088148
939	10	SALIDA	1.00	101.00	100.00	\N	\N	Mesa #4 - M4-0304-0001	10	2026-03-04 20:43:25.116502
940	82	SALIDA	1.00	98.00	97.00	\N	\N	Mesa #4 - M4-0304-0001	10	2026-03-04 20:43:25.139331
941	37	SALIDA	1.00	38.00	37.00	\N	\N	Mesa #4 - M4-0304-0001	10	2026-03-04 20:43:25.160063
942	7	SALIDA	1.00	12.00	11.00	\N	\N	Mesa #4 - M4-0304-0001	10	2026-03-04 20:43:25.180947
943	77	SALIDA	2.00	40.00	38.00	\N	\N	Venta - Factura V0304-0002	1	2026-03-04 22:21:59.004628
944	21	SALIDA	1.00	37.00	36.00	\N	\N	Venta - Factura V0305-0001	1	2026-03-05 19:02:12.936186
945	3	SALIDA	1.00	101.00	100.00	\N	\N	Mesa #5 - M5-0305-0001	1	2026-03-05 19:52:29.32534
946	6	SALIDA	1.00	97.00	96.00	\N	\N	Mesa #5 - M5-0305-0001	1	2026-03-05 19:52:29.377421
947	20	SALIDA	1.00	25.00	24.00	\N	\N	Mesa #5 - M5-0305-0001	1	2026-03-05 19:52:29.40733
948	35	SALIDA	1.00	31.00	30.00	\N	\N	Mesa #5 - M5-0305-0001	1	2026-03-05 19:52:29.43115
949	34	SALIDA	1.00	43.00	42.00	\N	\N	Mesa #5 - M5-0305-0001	1	2026-03-05 19:52:29.453468
950	37	SALIDA	1.00	37.00	36.00	\N	\N	Venta - Factura V0306-0001	1	2026-03-06 20:06:04.310303
951	20	SALIDA	1.00	24.00	23.00	\N	\N	Venta - Factura V0306-0001	1	2026-03-06 20:06:04.337906
952	70	SALIDA	1.00	41.00	40.00	\N	\N	Venta - Factura V0306-0002	1	2026-03-06 20:28:00.823203
953	77	SALIDA	1.00	38.00	37.00	\N	\N	Venta - Factura V0306-0003	1	2026-03-06 23:03:13.408068
954	20	SALIDA	1.00	23.00	22.00	\N	\N	Venta - Factura V0306-0003	1	2026-03-06 23:03:13.432021
955	20	SALIDA	1.00	22.00	21.00	\N	\N	Venta - Factura V0306-0004	1	2026-03-06 23:03:59.95293
956	78	SALIDA	1.00	41.00	40.00	\N	\N	Venta - Factura V0307-0001	1	2026-03-07 18:15:00.757452
957	11	SALIDA	1.00	5.00	4.00	\N	\N	Venta - Factura V0307-0001	1	2026-03-07 18:15:00.785396
958	20	SALIDA	1.00	21.00	20.00	\N	\N	Venta - Factura V0307-0001	1	2026-03-07 18:15:00.83179
959	78	SALIDA	1.00	40.00	39.00	\N	\N	Mesa #9 - M9-0307-0001	1	2026-03-07 18:58:49.666462
960	11	SALIDA	1.00	4.00	3.00	\N	\N	Mesa #9 - M9-0307-0001	1	2026-03-07 18:58:49.690961
961	46	SALIDA	3.00	43.00	40.00	\N	\N	Mesa #5 - M5-0307-0001	1	2026-03-07 19:00:57.507551
962	48	SALIDA	1.00	42.00	41.00	\N	\N	Mesa #5 - M5-0307-0001	1	2026-03-07 19:00:57.526094
963	83	SALIDA	1.00	96.00	95.00	\N	\N	Mesa #5 - M5-0307-0001	1	2026-03-07 19:00:57.543916
964	50	SALIDA	1.00	44.00	43.00	\N	\N	Mesa #5 - M5-0307-0001	1	2026-03-07 19:00:57.560031
965	35	SALIDA	1.00	30.00	29.00	\N	\N	Mesa #5 - M5-0307-0001	1	2026-03-07 19:00:57.575421
966	35	SALIDA	1.00	29.00	28.00	\N	\N	Mesa #5 - M5-0307-0001	1	2026-03-07 19:01:26.800967
967	80	SALIDA	1.00	99.00	98.00	\N	\N	Venta - Factura V0307-0002	1	2026-03-07 19:05:20.462774
968	3	SALIDA	1.00	100.00	99.00	\N	\N	Mesa #8 - M8-0307-0001	1	2026-03-07 19:26:43.184673
969	78	SALIDA	1.00	39.00	38.00	\N	\N	Mesa #7 - M7-0307-0001	1	2026-03-07 19:32:01.872847
970	36	SALIDA	1.00	46.00	45.00	\N	\N	Mesa #7 - M7-0307-0001	1	2026-03-07 19:32:35.994315
971	49	SALIDA	1.00	49.00	48.00	\N	\N	Mesa #7 - M7-0307-0001	1	2026-03-07 19:33:24.17831
972	20	SALIDA	2.00	20.00	18.00	\N	\N	Mesa #7 - M7-0307-0001	1	2026-03-07 19:36:12.337798
973	28	SALIDA	1.00	45.00	44.00	\N	\N	Mesa #7 - M7-0307-0001	1	2026-03-07 19:38:29.699959
974	44	SALIDA	1.00	49.00	48.00	\N	\N	Mesa #7 - M7-0307-0001	1	2026-03-07 19:38:46.679383
975	22	SALIDA	1.00	47.00	46.00	\N	\N	Mesa #7 - M7-0307-0001	1	2026-03-07 19:38:56.889433
976	29	SALIDA	1.00	48.00	47.00	\N	\N	Mesa #7 - M7-0307-0001	1	2026-03-07 19:39:10.827444
977	8	SALIDA	1.00	99.00	98.00	\N	\N	Mesa #7 - M7-0307-0001	1	2026-03-07 19:39:23.085816
978	11	SALIDA	1.00	3.00	2.00	\N	\N	Mesa #4 - M4-0307-0001	1	2026-03-07 19:39:58.860134
979	19	SALIDA	1.00	23.00	22.00	\N	\N	Mesa #4 - M4-0307-0001	1	2026-03-07 19:40:08.447178
980	59	SALIDA	1.00	50.00	49.00	\N	\N	Mesa #4 - M4-0307-0001	1	2026-03-07 19:40:34.9975
981	48	SALIDA	1.00	41.00	40.00	\N	\N	Mesa #4 - M4-0307-0001	1	2026-03-07 19:40:47.568888
982	19	SALIDA	1.00	22.00	21.00	\N	\N	Mesa #6 - M6-0307-0001	1	2026-03-07 19:46:27.212508
983	21	SALIDA	1.00	36.00	35.00	\N	\N	Mesa #6 - M6-0307-0001	1	2026-03-07 19:48:01.099662
984	43	SALIDA	1.00	38.00	37.00	\N	\N	Mesa #6 - M6-0307-0001	1	2026-03-07 19:48:11.192556
985	21	SALIDA	1.00	35.00	34.00	\N	\N	Mesa #6 - M6-0307-0001	1	2026-03-07 19:48:23.84209
986	31	SALIDA	1.00	39.00	38.00	\N	\N	Mesa #6 - M6-0307-0001	1	2026-03-07 19:48:33.44927
987	20	SALIDA	1.00	18.00	17.00	\N	\N	Mesa #6 - M6-0307-0001	1	2026-03-07 19:49:15.657204
988	38	SALIDA	1.00	47.00	46.00	\N	\N	Mesa #6 - M6-0307-0001	1	2026-03-07 19:49:30.57269
989	19	SALIDA	1.00	21.00	20.00	\N	\N	Mesa #6 - M6-0307-0001	1	2026-03-07 19:50:10.98442
990	37	SALIDA	1.00	36.00	35.00	\N	\N	Mesa #6 - M6-0307-0001	1	2026-03-07 19:50:20.649944
991	23	SALIDA	1.00	38.00	37.00	\N	\N	Mesa #6 - M6-0307-0001	1	2026-03-07 19:50:30.371275
992	59	SALIDA	1.00	49.00	48.00	\N	\N	Mesa #6 - M6-0307-0001	1	2026-03-07 19:50:44.455298
993	21	SALIDA	1.00	34.00	33.00	\N	\N	Mesa #6 - M6-0307-0001	1	2026-03-07 19:50:59.458858
994	43	SALIDA	1.00	37.00	36.00	\N	\N	Mesa #6 - M6-0307-0001	1	2026-03-07 19:51:09.411544
995	19	SALIDA	1.00	20.00	19.00	\N	\N	Mesa #6 - M6-0307-0001	1	2026-03-07 19:51:20.495935
996	59	SALIDA	1.00	48.00	47.00	\N	\N	Mesa #6 - M6-0307-0001	1	2026-03-07 19:51:31.993474
997	2	SALIDA	1.00	5.00	4.00	\N	\N	Mesa #6 - M6-0307-0001	1	2026-03-07 19:51:42.465361
998	51	SALIDA	1.00	44.00	43.00	\N	\N	Mesa #6 - M6-0307-0001	1	2026-03-07 19:51:55.168848
999	8	SALIDA	1.00	98.00	97.00	\N	\N	Mesa #9 - M9-0307-0002	1	2026-03-07 19:52:47.199698
1000	17	SALIDA	1.00	49.00	48.00	\N	\N	Mesa #9 - M9-0307-0002	1	2026-03-07 19:52:55.297435
1001	23	SALIDA	1.00	37.00	36.00	\N	\N	Mesa #9 - M9-0307-0002	1	2026-03-07 19:53:06.086176
1002	11	SALIDA	1.00	2.00	1.00	\N	\N	Mesa #9 - M9-0307-0002	1	2026-03-07 19:53:20.010066
1003	35	SALIDA	1.00	28.00	27.00	\N	\N	Mesa #9 - M9-0307-0002	1	2026-03-07 19:53:35.705804
1004	48	SALIDA	1.00	40.00	39.00	\N	\N	Mesa #4 - M4-0307-0001	1	2026-03-07 20:01:37.867465
1005	78	SALIDA	1.00	38.00	37.00	\N	\N	Mesa #9 - M9-0307-0003	1	2026-03-07 20:03:57.789008
1006	22	SALIDA	2.00	46.00	44.00	\N	\N	Mesa #9 - M9-0307-0004	1	2026-03-07 20:29:32.293929
1007	17	SALIDA	1.00	48.00	47.00	\N	\N	Mesa #9 - M9-0307-0004	1	2026-03-07 20:29:46.160095
1008	23	SALIDA	1.00	36.00	35.00	\N	\N	Mesa #9 - M9-0307-0004	1	2026-03-07 20:29:58.251887
1009	11	SALIDA	1.00	1.00	0.00	\N	\N	Mesa #9 - M9-0307-0004	1	2026-03-07 20:30:10.334064
1010	8	SALIDA	1.00	97.00	96.00	\N	\N	Mesa #9 - M9-0307-0004	1	2026-03-07 20:30:30.127114
1011	35	SALIDA	1.00	27.00	26.00	\N	\N	Mesa #9 - M9-0307-0004	1	2026-03-07 20:35:25.662791
1012	35	SALIDA	1.00	26.00	25.00	\N	\N	Mesa #9 - M9-0307-0004	1	2026-03-07 20:35:41.566956
1013	35	ENTRADA	2.00	25.00	27.00	\N	\N	Eliminado de Mesa #9	1	2026-03-07 20:43:27.344867
1014	35	SALIDA	1.00	27.00	26.00	\N	\N	Mesa #9 - M9-0307-0004	1	2026-03-07 20:43:42.707471
1015	3	SALIDA	1.00	99.00	98.00	\N	\N	Mesa #1 - M1-0307-0001	1	2026-03-07 20:46:28.0358
1016	38	SALIDA	1.00	46.00	45.00	\N	\N	Mesa #1 - M1-0307-0001	1	2026-03-07 20:46:37.490774
1017	78	SALIDA	1.00	37.00	36.00	\N	\N	Mesa #1 - M1-0307-0001	1	2026-03-07 20:46:45.121427
1018	19	SALIDA	1.00	19.00	18.00	\N	\N	Mesa #1 - M1-0307-0001	1	2026-03-07 20:47:01.379237
1019	43	SALIDA	2.00	36.00	34.00	\N	\N	Mesa #1 - M1-0307-0001	1	2026-03-07 20:47:19.14229
1020	3	SALIDA	1.00	98.00	97.00	\N	\N	Mesa #1 - M1-0307-0001	1	2026-03-07 20:47:25.5396
1021	3	ENTRADA	1.00	97.00	98.00	\N	\N	Eliminado de Mesa #8	1	2026-03-07 20:48:55.156849
1022	8	ENTRADA	1.00	96.00	97.00	\N	\N	Anulación - Factura M9-0307-0002	1	2026-03-07 20:53:42.921898
1023	17	ENTRADA	1.00	47.00	48.00	\N	\N	Anulación - Factura M9-0307-0002	1	2026-03-07 20:53:42.931032
1024	23	ENTRADA	1.00	35.00	36.00	\N	\N	Anulación - Factura M9-0307-0002	1	2026-03-07 20:53:42.936108
1025	11	ENTRADA	1.00	0.00	1.00	\N	\N	Anulación - Factura M9-0307-0002	1	2026-03-07 20:53:42.941561
1026	35	ENTRADA	1.00	26.00	27.00	\N	\N	Anulación - Factura M9-0307-0002	1	2026-03-07 20:53:42.94761
1027	23	SALIDA	1.00	36.00	35.00	\N	\N	Mesa #8 - M8-0307-0002	1	2026-03-07 21:09:06.352886
1028	20	SALIDA	1.00	17.00	16.00	\N	\N	Mesa #8 - M8-0307-0002	1	2026-03-07 21:09:15.84247
1029	63	SALIDA	2.00	43.00	41.00	\N	\N	Mesa #4 - M4-0307-0001	1	2026-03-07 21:27:42.300962
1030	20	SALIDA	1.00	16.00	15.00	\N	\N	Mesa #1 - M1-0307-0002	1	2026-03-07 21:48:20.39461
1031	19	SALIDA	1.00	18.00	17.00	\N	\N	Mesa #1 - M1-0307-0002	1	2026-03-07 21:48:20.408923
1032	35	SALIDA	2.00	27.00	25.00	\N	\N	Mesa #1 - M1-0307-0002	1	2026-03-07 21:48:33.657269
1033	27	SALIDA	1.00	45.00	44.00	\N	\N	Mesa #1 - M1-0307-0002	1	2026-03-07 21:48:56.752877
1034	20	SALIDA	1.00	15.00	14.00	\N	\N	Mesa #2 - M2-0307-0001	1	2026-03-07 22:04:49.842727
1037	15	SALIDA	1.00	47.00	46.00	\N	\N	Mesa #3 - M3-0307-0001	1	2026-03-07 22:09:08.951973
1035	20	SALIDA	1.00	14.00	13.00	\N	\N	Mesa #3 - M3-0307-0001	1	2026-03-07 22:08:51.00472
1036	30	SALIDA	1.00	47.00	46.00	\N	\N	Mesa #3 - M3-0307-0001	1	2026-03-07 22:08:59.275184
1038	70	SALIDA	1.00	40.00	39.00	\N	\N	Mesa #3 - M3-0307-0001	1	2026-03-07 22:09:31.212522
1039	51	ENTRADA	1.00	43.00	44.00	\N	\N	Eliminado de Mesa #6	1	2026-03-07 22:17:52.649612
1040	59	ENTRADA	2.00	47.00	49.00	\N	\N	Eliminado de Mesa #6	1	2026-03-07 22:17:53.586909
1041	23	ENTRADA	1.00	35.00	36.00	\N	\N	Eliminado de Mesa #6	1	2026-03-07 22:17:54.11172
1042	37	ENTRADA	1.00	35.00	36.00	\N	\N	Eliminado de Mesa #6	1	2026-03-07 22:17:54.476778
1043	38	ENTRADA	1.00	45.00	46.00	\N	\N	Eliminado de Mesa #6	1	2026-03-07 22:17:54.698435
1044	2	ENTRADA	1.00	4.00	5.00	\N	\N	Eliminado de Mesa #6	1	2026-03-07 22:17:56.148173
1045	20	ENTRADA	1.00	13.00	14.00	\N	\N	Eliminado de Mesa #6	1	2026-03-07 22:17:57.850426
1046	31	ENTRADA	1.00	38.00	39.00	\N	\N	Eliminado de Mesa #6	1	2026-03-07 22:17:59.209981
1047	43	ENTRADA	2.00	34.00	36.00	\N	\N	Eliminado de Mesa #6	1	2026-03-07 22:18:01.418705
1048	19	ENTRADA	3.00	17.00	20.00	\N	\N	Eliminado de Mesa #6	1	2026-03-07 22:18:02.701571
1049	21	ENTRADA	3.00	33.00	36.00	\N	\N	Eliminado de Mesa #6	1	2026-03-07 22:18:03.703009
1050	46	ENTRADA	3.00	40.00	43.00	\N	\N	Eliminado de Mesa #5	1	2026-03-07 22:20:13.630676
1051	47	SALIDA	3.00	47.00	44.00	\N	\N	Mesa #5 - M5-0307-0001	1	2026-03-07 22:20:25.143775
1052	20	SALIDA	3.00	14.00	11.00	\N	\N	Mesa #4 - M4-0307-0002	1	2026-03-07 22:24:07.370655
1053	8	SALIDA	1.00	97.00	96.00	\N	\N	Mesa #4 - M4-0307-0002	1	2026-03-07 22:24:17.288399
1054	27	SALIDA	1.00	44.00	43.00	\N	\N	Mesa #4 - M4-0307-0002	1	2026-03-07 22:24:40.324294
1055	37	SALIDA	1.00	36.00	35.00	\N	\N	Mesa #4 - M4-0307-0002	1	2026-03-07 22:24:50.016352
1056	43	SALIDA	1.00	36.00	35.00	\N	\N	Mesa #4 - M4-0307-0002	1	2026-03-07 22:24:57.773067
1057	3	SALIDA	1.00	98.00	97.00	\N	\N	Mesa #8 - M8-0307-0003	1	2026-03-07 22:27:28.880499
1058	27	ENTRADA	1.00	43.00	44.00	\N	\N	Eliminado de Mesa #1	1	2026-03-07 22:31:22.362593
1059	28	SALIDA	1.00	44.00	43.00	\N	\N	Mesa #1 - M1-0307-0002	1	2026-03-07 22:31:31.022484
1060	79	SALIDA	2.00	94.00	92.00	\N	\N	Mesa #7 - M7-0307-0002	1	2026-03-07 22:32:54.013279
1061	21	SALIDA	1.00	36.00	35.00	\N	\N	Mesa #3 - M3-0307-0002	1	2026-03-07 22:34:46.494783
1062	43	SALIDA	1.00	35.00	34.00	\N	\N	Mesa #3 - M3-0307-0002	1	2026-03-07 22:34:52.759811
1063	20	SALIDA	1.00	11.00	10.00	\N	\N	Mesa #3 - M3-0307-0003	1	2026-03-07 22:39:07.880871
1064	45	SALIDA	1.00	48.00	47.00	\N	\N	Mesa #3 - M3-0307-0003	1	2026-03-07 22:39:15.928736
1065	19	SALIDA	1.00	20.00	19.00	\N	\N	Mesa #3 - M3-0307-0004	1	2026-03-07 22:41:16.938374
1066	43	SALIDA	2.00	34.00	32.00	\N	\N	Mesa #3 - M3-0307-0004	1	2026-03-07 22:41:24.259064
1067	35	SALIDA	1.00	25.00	24.00	\N	\N	Mesa #3 - M3-0307-0004	1	2026-03-07 22:41:36.610099
1068	20	SALIDA	1.00	10.00	9.00	\N	\N	Mesa #3 - M3-0307-0005	1	2026-03-07 22:43:03.777332
1069	43	SALIDA	1.00	32.00	31.00	\N	\N	Mesa #3 - M3-0307-0005	1	2026-03-07 22:43:11.056336
1070	43	SALIDA	1.00	31.00	30.00	\N	\N	Mesa #3 - M3-0307-0005	1	2026-03-07 22:43:18.394963
1071	23	SALIDA	1.00	36.00	35.00	\N	\N	Mesa #3 - M3-0307-0005	1	2026-03-07 22:43:25.009055
1072	35	SALIDA	2.00	24.00	22.00	\N	\N	Mesa #3 - M3-0307-0005	1	2026-03-07 22:43:37.552617
1073	50	SALIDA	1.00	43.00	42.00	\N	\N	Mesa #3 - M3-0307-0005	1	2026-03-07 22:43:47.578327
1074	8	SALIDA	1.00	96.00	95.00	\N	\N	Mesa #3 - M3-0307-0006	1	2026-03-07 22:44:44.865744
1075	27	SALIDA	1.00	44.00	43.00	\N	\N	Mesa #3 - M3-0307-0006	1	2026-03-07 22:45:30.940627
1076	37	SALIDA	1.00	35.00	34.00	\N	\N	Mesa #3 - M3-0307-0006	1	2026-03-07 22:45:40.71753
1077	20	SALIDA	1.00	9.00	8.00	\N	\N	Mesa #3 - M3-0307-0007	1	2026-03-07 22:46:19.478313
1078	38	SALIDA	1.00	46.00	45.00	\N	\N	Mesa #3 - M3-0307-0007	1	2026-03-07 22:46:37.181443
1079	47	SALIDA	1.00	44.00	43.00	\N	\N	Mesa #3 - M3-0307-0007	1	2026-03-07 22:46:55.780498
1080	50	ENTRADA	1.00	42.00	43.00	\N	\N	Eliminado de Mesa #5	1	2026-03-07 22:47:51.222492
1081	83	ENTRADA	1.00	95.00	96.00	\N	\N	Eliminado de Mesa #5	1	2026-03-07 22:49:23.707059
1082	48	ENTRADA	1.00	39.00	40.00	\N	\N	Eliminado de Mesa #5	1	2026-03-07 22:49:25.880472
1083	35	ENTRADA	2.00	22.00	24.00	\N	\N	Eliminado de Mesa #5	1	2026-03-07 22:49:32.365465
1084	47	ENTRADA	3.00	43.00	46.00	\N	\N	Eliminado de Mesa #5	1	2026-03-07 22:50:00.451424
1085	47	SALIDA	2.00	46.00	44.00	\N	\N	Mesa #7 - M7-0307-0003	1	2026-03-07 22:51:56.651398
1086	83	SALIDA	1.00	96.00	95.00	\N	\N	Mesa #7 - M7-0307-0003	1	2026-03-07 22:51:56.661574
1087	8	SALIDA	1.00	95.00	94.00	\N	\N	Mesa #7 - M7-0307-0003	1	2026-03-07 22:52:04.009807
1088	19	SALIDA	1.00	19.00	18.00	\N	\N	Mesa #3 - M3-0307-0008	1	2026-03-07 22:53:08.131793
1089	59	SALIDA	1.00	49.00	48.00	\N	\N	Mesa #3 - M3-0307-0008	1	2026-03-07 22:53:25.681043
1090	48	SALIDA	1.00	40.00	39.00	\N	\N	Mesa #3 - M3-0307-0008	1	2026-03-07 22:53:41.830643
1091	83	SALIDA	1.00	95.00	94.00	\N	\N	Mesa #3 - M3-0307-0008	1	2026-03-07 22:53:54.167533
1092	2	SALIDA	1.00	5.00	4.00	\N	\N	Mesa #4 - M4-0307-0003	1	2026-03-07 22:56:12.063999
1093	51	SALIDA	2.00	44.00	42.00	\N	\N	Mesa #4 - M4-0307-0003	1	2026-03-07 22:56:28.345873
1094	56	SALIDA	1.00	50.00	49.00	\N	\N	Mesa #4 - M4-0307-0003	1	2026-03-07 22:56:39.60287
1095	44	SALIDA	1.00	48.00	47.00	\N	\N	Mesa #4 - M4-0307-0003	1	2026-03-07 22:56:53.085475
1096	20	SALIDA	1.00	8.00	7.00	\N	\N	Mesa #3 - M3-0307-0009	1	2026-03-07 23:09:03.777899
1097	2	SALIDA	1.00	4.00	3.00	\N	\N	Mesa #3 - M3-0307-0009	1	2026-03-07 23:09:15.092011
1098	20	ENTRADA	1.00	7.00	8.00	\N	\N	Eliminado de Mesa #2	1	2026-03-07 23:09:46.222556
1099	4	SALIDA	1.00	101.00	100.00	\N	\N	Mesa #2 - M2-0307-0001	1	2026-03-07 23:10:03.647406
1100	3	SALIDA	1.00	97.00	96.00	\N	\N	Mesa #2 - M2-0307-0001	1	2026-03-07 23:10:09.006561
1101	2	SALIDA	1.00	3.00	2.00	\N	\N	Mesa #2 - M2-0307-0001	1	2026-03-07 23:10:15.988385
1102	35	SALIDA	1.00	24.00	23.00	\N	\N	Mesa #2 - M2-0307-0001	1	2026-03-07 23:10:25.318683
1103	38	SALIDA	1.00	45.00	44.00	\N	\N	Mesa #2 - M2-0307-0001	1	2026-03-07 23:10:36.47207
1104	20	ENTRADA	1.00	8.00	9.00	\N	\N	Eliminado de Mesa #3	1	2026-03-07 23:16:32.221096
1105	2	ENTRADA	1.00	2.00	3.00	\N	\N	Eliminado de Mesa #3	1	2026-03-07 23:16:33.709487
1106	20	SALIDA	1.00	9.00	8.00	\N	\N	Mesa #4 - M4-0307-0004	1	2026-03-07 23:16:53.929363
1107	2	SALIDA	1.00	3.00	2.00	\N	\N	Mesa #4 - M4-0307-0004	1	2026-03-07 23:17:03.459914
1108	59	SALIDA	1.00	48.00	47.00	\N	\N	Mesa #4 - M4-0307-0004	1	2026-03-07 23:17:22.679136
1109	47	SALIDA	2.00	44.00	42.00	\N	\N	Mesa #4 - M4-0307-0004	1	2026-03-07 23:17:37.48944
1110	23	SALIDA	1.00	35.00	34.00	\N	\N	Mesa #4 - M4-0307-0004	1	2026-03-07 23:17:58.814156
1111	59	SALIDA	1.00	47.00	46.00	\N	\N	Mesa #4 - M4-0307-0004	1	2026-03-07 23:18:17.457556
1112	8	SALIDA	1.00	94.00	93.00	\N	\N	Mesa #3 - M3-0307-0010	1	2026-03-07 23:24:04.470257
1113	20	SALIDA	1.00	8.00	7.00	\N	\N	Mesa #3 - M3-0307-0010	1	2026-03-07 23:24:29.502433
1114	19	SALIDA	1.00	18.00	17.00	\N	\N	Mesa #3 - M3-0307-0010	1	2026-03-07 23:24:45.557406
1115	81	SALIDA	1.00	98.00	97.00	\N	\N	Mesa #3 - M3-0307-0010	1	2026-03-07 23:25:01.039527
1116	83	SALIDA	1.00	94.00	93.00	\N	\N	Mesa #3 - M3-0307-0010	1	2026-03-07 23:25:10.816758
1117	43	SALIDA	1.00	30.00	29.00	\N	\N	Mesa #3 - M3-0307-0010	1	2026-03-07 23:25:19.835304
1118	8	ENTRADA	1.00	93.00	94.00	\N	\N	Anulación - Factura M3-0307-0010	1	2026-03-07 23:26:44.564049
1119	20	ENTRADA	1.00	7.00	8.00	\N	\N	Anulación - Factura M3-0307-0010	1	2026-03-07 23:26:44.568999
1120	19	ENTRADA	1.00	17.00	18.00	\N	\N	Anulación - Factura M3-0307-0010	1	2026-03-07 23:26:44.572109
1121	81	ENTRADA	1.00	97.00	98.00	\N	\N	Anulación - Factura M3-0307-0010	1	2026-03-07 23:26:44.57626
1122	83	ENTRADA	1.00	93.00	94.00	\N	\N	Anulación - Factura M3-0307-0010	1	2026-03-07 23:26:44.580531
1123	43	ENTRADA	1.00	29.00	30.00	\N	\N	Anulación - Factura M3-0307-0010	1	2026-03-07 23:26:44.585563
1124	20	SALIDA	1.00	8.00	7.00	\N	\N	Mesa #3 - M3-0307-0011	1	2026-03-07 23:27:13.366727
1125	19	SALIDA	1.00	18.00	17.00	\N	\N	Mesa #3 - M3-0307-0011	1	2026-03-07 23:27:13.376855
1126	83	SALIDA	1.00	94.00	93.00	\N	\N	Mesa #3 - M3-0307-0011	1	2026-03-07 23:27:38.818793
1127	81	SALIDA	1.00	98.00	97.00	\N	\N	Mesa #3 - M3-0307-0011	1	2026-03-07 23:27:38.830706
1128	43	SALIDA	1.00	30.00	29.00	\N	\N	Mesa #3 - M3-0307-0011	1	2026-03-07 23:27:38.841607
1129	20	SALIDA	1.00	7.00	6.00	\N	\N	Mesa #4 - M4-0307-0006	1	2026-03-07 23:30:59.859473
1130	81	SALIDA	1.00	97.00	96.00	\N	\N	Mesa #4 - M4-0307-0006	1	2026-03-07 23:30:59.870831
1131	11	SALIDA	1.00	1.00	0.00	\N	\N	Mesa #7 - M7-0307-0005	1	2026-03-07 23:32:36.607944
1132	8	SALIDA	1.00	94.00	93.00	\N	\N	Mesa #7 - M7-0307-0005	1	2026-03-07 23:32:36.632729
1133	43	SALIDA	1.00	29.00	28.00	\N	\N	Mesa #7 - M7-0307-0005	1	2026-03-07 23:32:36.648267
1134	31	SALIDA	1.00	39.00	38.00	\N	\N	Mesa #7 - M7-0307-0005	1	2026-03-07 23:32:36.662292
1135	75	SALIDA	1.00	45.00	44.00	\N	\N	Mesa #7 - M7-0307-0005	1	2026-03-07 23:39:51.369717
1136	20	SALIDA	1.00	6.00	5.00	\N	\N	Mesa #4 - M4-0308-0001	1	2026-03-08 00:09:19.271616
1137	19	SALIDA	1.00	17.00	16.00	\N	\N	Mesa #4 - M4-0308-0001	1	2026-03-08 00:09:19.304546
1138	32	SALIDA	2.00	41.00	39.00	\N	\N	Mesa #4 - M4-0308-0001	1	2026-03-08 00:09:19.319617
1139	74	SALIDA	1.00	41.00	40.00	\N	\N	Venta - Factura V0308-0001	1	2026-03-08 18:59:05.958878
1140	75	SALIDA	1.00	44.00	43.00	\N	\N	Venta - Factura V0308-0001	1	2026-03-08 18:59:05.983129
1141	66	SALIDA	1.00	36.00	35.00	\N	\N	Venta - Factura V0308-0001	1	2026-03-08 18:59:06.003925
1142	23	SALIDA	1.00	34.00	33.00	\N	\N	Mesa #3 - M3-0308-0001	1	2026-03-08 18:59:30.952795
1143	3	SALIDA	1.00	96.00	95.00	\N	\N	Mesa #3 - M3-0308-0001	1	2026-03-08 18:59:30.976642
1144	43	SALIDA	2.00	28.00	26.00	\N	\N	Mesa #3 - M3-0308-0001	1	2026-03-08 18:59:30.996033
1145	8	SALIDA	1.00	93.00	92.00	\N	\N	Mesa #1 - M1-0308-0001	1	2026-03-08 19:00:54.050785
1146	3	SALIDA	1.00	95.00	94.00	\N	\N	Mesa #1 - M1-0308-0001	1	2026-03-08 19:00:54.071703
1147	82	SALIDA	1.00	97.00	96.00	\N	\N	Mesa #1 - M1-0308-0001	1	2026-03-08 19:00:54.089565
1148	36	SALIDA	1.00	45.00	44.00	\N	\N	Mesa #1 - M1-0308-0001	1	2026-03-08 19:00:54.11157
1149	8	SALIDA	1.00	92.00	91.00	\N	\N	Mesa #8 - M8-0308-0001	1	2026-03-08 19:16:51.614945
1150	19	SALIDA	1.00	16.00	15.00	\N	\N	Mesa #9 - M9-0308-0001	1	2026-03-08 19:18:21.049677
1151	8	SALIDA	1.00	91.00	90.00	\N	\N	Mesa #3 - M3-0308-0002	1	2026-03-08 19:26:10.319833
1152	23	SALIDA	1.00	33.00	32.00	\N	\N	Mesa #3 - M3-0308-0002	1	2026-03-08 19:26:10.339742
1153	31	SALIDA	2.00	38.00	36.00	\N	\N	Mesa #3 - M3-0308-0002	1	2026-03-08 19:26:10.357558
1154	11	ENTRADA	200.00	0.00	200.00	\N	\N	\N	1	2026-03-08 19:37:25.607141
1155	11	SALIDA	1.00	200.00	199.00	\N	\N	Mesa #7 - M7-0308-0001	1	2026-03-08 19:38:58.151106
1156	78	SALIDA	1.00	36.00	35.00	\N	\N	Mesa #7 - M7-0308-0001	1	2026-03-08 19:38:58.166533
1157	10	SALIDA	1.00	100.00	99.00	\N	\N	Mesa #7 - M7-0308-0001	1	2026-03-08 19:38:58.179452
1158	23	SALIDA	1.00	32.00	31.00	\N	\N	Mesa #7 - M7-0308-0001	1	2026-03-08 19:38:58.198736
1159	43	SALIDA	2.00	26.00	24.00	\N	\N	Mesa #7 - M7-0308-0001	1	2026-03-08 19:38:58.215505
1160	52	SALIDA	1.00	39.00	38.00	\N	\N	Mesa #7 - M7-0308-0001	1	2026-03-08 19:38:58.232386
1161	44	SALIDA	1.00	47.00	46.00	\N	\N	Mesa #7 - M7-0308-0001	1	2026-03-08 19:38:58.249977
1162	22	SALIDA	1.00	44.00	43.00	\N	\N	Mesa #2 - M2-0308-0001	1	2026-03-08 19:39:38.704576
1163	8	SALIDA	1.00	90.00	89.00	\N	\N	Mesa #2 - M2-0308-0001	1	2026-03-08 19:39:38.718672
1164	37	SALIDA	1.00	34.00	33.00	\N	\N	Mesa #2 - M2-0308-0001	1	2026-03-08 19:39:38.729856
1165	38	SALIDA	1.00	44.00	43.00	\N	\N	Mesa #2 - M2-0308-0001	1	2026-03-08 19:39:38.744207
1166	76	SALIDA	1.00	44.00	43.00	\N	\N	Mesa #3 - M3-0308-0002	1	2026-03-08 19:40:53.678797
1167	79	SALIDA	1.00	92.00	91.00	\N	\N	Mesa #8 - M8-0308-0002	1	2026-03-08 20:10:34.654632
1168	79	SALIDA	1.00	91.00	90.00	\N	\N	Mesa #7 - M7-0308-0002	1	2026-03-08 20:15:30.66624
1169	22	SALIDA	1.00	43.00	42.00	\N	\N	Mesa #7 - M7-0308-0002	1	2026-03-08 20:15:30.680992
1170	17	SALIDA	1.00	48.00	47.00	\N	\N	Mesa #7 - M7-0308-0002	1	2026-03-08 20:15:30.692778
1171	19	SALIDA	3.00	15.00	12.00	\N	\N	Mesa #7 - M7-0308-0002	1	2026-03-08 20:15:30.706306
1172	3	SALIDA	1.00	94.00	93.00	\N	\N	Mesa #7 - M7-0308-0002	1	2026-03-08 20:15:30.720936
1173	78	SALIDA	1.00	35.00	34.00	\N	\N	Mesa #7 - M7-0308-0002	1	2026-03-08 20:15:30.734057
1174	20	SALIDA	1.00	5.00	4.00	\N	\N	Mesa #7 - M7-0308-0002	1	2026-03-08 20:15:30.748448
1175	75	SALIDA	1.00	43.00	42.00	\N	\N	Venta - Factura V0308-0002	1	2026-03-08 20:30:53.701118
1176	23	SALIDA	1.00	31.00	30.00	\N	\N	Mesa #1 - M1-0308-0002	1	2026-03-08 20:34:35.837091
1177	20	SALIDA	1.00	4.00	3.00	\N	\N	Mesa #1 - M1-0308-0002	1	2026-03-08 20:34:35.857812
1178	68	SALIDA	1.00	50.00	49.00	\N	\N	Mesa #1 - M1-0308-0002	1	2026-03-08 20:34:35.87451
1179	66	SALIDA	1.00	35.00	34.00	\N	\N	Mesa #1 - M1-0308-0002	1	2026-03-08 20:34:35.889576
1180	43	SALIDA	1.00	24.00	23.00	\N	\N	Mesa #1 - M1-0308-0002	1	2026-03-08 20:34:35.90344
1181	87	SALIDA	1.00	100.00	99.00	\N	\N	Mesa #7 - M7-0308-0002	1	2026-03-08 20:39:00.644339
1182	87	ENTRADA	1.00	99.00	100.00	\N	\N	Eliminado de Mesa #7	1	2026-03-08 20:39:08.628156
1183	79	ENTRADA	1.00	90.00	91.00	\N	\N	Eliminado de Mesa #7	1	2026-03-08 20:39:25.192843
1184	87	SALIDA	1.00	100.00	99.00	\N	\N	Mesa #7 - M7-0308-0002	1	2026-03-08 20:40:13.03212
1185	79	SALIDA	1.00	91.00	90.00	\N	\N	Venta - Factura V0308-0003	1	2026-03-08 20:50:21.28959
1186	23	SALIDA	2.00	30.00	28.00	\N	\N	Mesa #4 - M4-0308-0002	1	2026-03-08 21:37:06.351258
1187	9	SALIDA	1.00	13.00	12.00	\N	\N	Mesa #4 - M4-0308-0002	1	2026-03-08 21:37:06.369567
1188	19	SALIDA	1.00	12.00	11.00	\N	\N	Mesa #4 - M4-0308-0002	1	2026-03-08 21:38:04.577997
1189	31	SALIDA	1.00	36.00	35.00	\N	\N	Mesa #4 - M4-0308-0002	1	2026-03-08 21:38:04.589956
1190	32	SALIDA	1.00	39.00	38.00	\N	\N	Mesa #4 - M4-0308-0002	1	2026-03-08 21:38:04.60122
1191	28	SALIDA	2.00	43.00	41.00	\N	\N	Mesa #4 - M4-0308-0002	1	2026-03-08 21:38:56.037124
1192	62	SALIDA	1.00	49.00	48.00	\N	\N	Mesa #4 - M4-0308-0002	1	2026-03-08 21:40:37.772199
1193	85	SALIDA	1.00	99.00	98.00	\N	\N	Mesa #2 - M2-0308-0002	1	2026-03-08 21:44:04.137694
1194	20	SALIDA	1.00	3.00	2.00	\N	\N	Mesa #2 - M2-0308-0002	1	2026-03-08 21:44:04.15179
1195	10	SALIDA	1.00	99.00	98.00	\N	\N	Mesa #2 - M2-0308-0002	1	2026-03-08 21:44:04.163775
1196	21	SALIDA	1.00	35.00	34.00	\N	\N	Mesa #1 - M1-0308-0003	1	2026-03-08 21:49:04.089885
1197	22	SALIDA	1.00	42.00	41.00	\N	\N	Mesa #1 - M1-0308-0003	1	2026-03-08 21:49:04.105395
1198	83	SALIDA	2.00	93.00	91.00	\N	\N	Mesa #1 - M1-0308-0003	1	2026-03-08 21:49:04.114917
1199	47	SALIDA	1.00	42.00	41.00	\N	\N	Mesa #1 - M1-0308-0003	1	2026-03-08 21:49:04.125949
1200	81	SALIDA	1.00	96.00	95.00	\N	\N	Mesa #1 - M1-0308-0003	1	2026-03-08 21:49:04.139928
1201	9	SALIDA	4.00	12.00	8.00	\N	\N	Mesa #6 - M6-0308-0001	1	2026-03-08 21:54:33.568242
1202	17	SALIDA	1.00	47.00	46.00	\N	\N	Mesa #6 - M6-0308-0001	1	2026-03-08 21:54:33.583216
1203	85	SALIDA	2.00	98.00	96.00	\N	\N	Mesa #6 - M6-0308-0001	1	2026-03-08 21:54:33.5958
1204	36	SALIDA	1.00	44.00	43.00	\N	\N	Mesa #6 - M6-0308-0001	1	2026-03-08 21:54:33.607345
1205	82	SALIDA	1.00	96.00	95.00	\N	\N	Mesa #6 - M6-0308-0001	1	2026-03-08 21:54:33.61994
1206	10	SALIDA	1.00	98.00	97.00	\N	\N	Mesa #3 - M3-0308-0003	1	2026-03-08 21:56:03.055441
1207	19	SALIDA	1.00	11.00	10.00	\N	\N	Mesa #3 - M3-0308-0003	1	2026-03-08 21:56:03.065981
1208	20	SALIDA	1.00	2.00	1.00	\N	\N	Mesa #3 - M3-0308-0003	1	2026-03-08 21:56:03.075164
1209	2	SALIDA	1.00	2.00	1.00	\N	\N	Mesa #3 - M3-0308-0003	1	2026-03-08 21:56:03.087051
1210	82	SALIDA	2.00	95.00	93.00	\N	\N	Mesa #3 - M3-0308-0003	1	2026-03-08 21:56:03.099998
1211	32	SALIDA	1.00	38.00	37.00	\N	\N	Mesa #3 - M3-0308-0003	1	2026-03-08 21:56:03.112224
1212	36	SALIDA	1.00	43.00	42.00	\N	\N	Mesa #3 - M3-0308-0003	1	2026-03-08 21:56:03.123269
1213	85	ENTRADA	2.00	96.00	98.00	\N	\N	Eliminado de Mesa #6	1	2026-03-08 21:58:34.078163
1214	9	SALIDA	1.00	8.00	7.00	\N	\N	Mesa #5 - M5-0308-0001	1	2026-03-08 22:08:32.183577
1215	3	SALIDA	1.00	93.00	92.00	\N	\N	Mesa #5 - M5-0308-0001	1	2026-03-08 22:08:32.201579
1216	27	SALIDA	1.00	43.00	42.00	\N	\N	Mesa #5 - M5-0308-0001	1	2026-03-08 22:08:32.214827
1217	31	SALIDA	1.00	35.00	34.00	\N	\N	Mesa #5 - M5-0308-0001	1	2026-03-08 22:08:32.226581
1218	59	SALIDA	1.00	46.00	45.00	\N	\N	Mesa #7 - M7-0308-0004	1	2026-03-08 22:12:58.466296
1219	36	SALIDA	1.00	42.00	41.00	\N	\N	Mesa #7 - M7-0308-0004	1	2026-03-08 22:12:58.476507
1220	7	SALIDA	1.00	11.00	10.00	\N	\N	Mesa #7 - M7-0308-0004	1	2026-03-08 22:12:58.491906
1221	2	SALIDA	1.00	1.00	0.00	\N	\N	Mesa #7 - M7-0308-0004	1	2026-03-08 22:12:58.50296
1222	6	SALIDA	1.00	96.00	95.00	\N	\N	Mesa #7 - M7-0308-0004	1	2026-03-08 22:12:58.520788
1223	57	SALIDA	1.00	46.00	45.00	\N	\N	Mesa #7 - M7-0308-0004	1	2026-03-08 22:12:58.526485
1224	66	SALIDA	1.00	34.00	33.00	\N	\N	Mesa #7 - M7-0308-0004	1	2026-03-08 22:12:58.541868
1225	6	SALIDA	1.00	95.00	94.00	\N	\N	Mesa #6 - M6-0308-0002	1	2026-03-08 22:32:54.734803
1226	20	SALIDA	1.00	1.00	0.00	\N	\N	Mesa #6 - M6-0308-0002	1	2026-03-08 22:32:54.749279
1227	35	SALIDA	1.00	23.00	22.00	\N	\N	Mesa #6 - M6-0308-0002	1	2026-03-08 22:32:54.768176
1228	37	SALIDA	1.00	33.00	32.00	\N	\N	Mesa #6 - M6-0308-0002	1	2026-03-08 22:32:54.777631
1229	40	SALIDA	1.00	50.00	49.00	\N	\N	Mesa #6 - M6-0308-0002	1	2026-03-08 22:32:54.789609
1230	78	SALIDA	1.00	34.00	33.00	\N	\N	Mesa #6 - M6-0308-0002	1	2026-03-08 22:32:54.803605
1231	44	SALIDA	1.00	46.00	45.00	\N	\N	Mesa #3 - M3-0308-0004	1	2026-03-08 22:41:07.975821
1232	43	SALIDA	1.00	23.00	22.00	\N	\N	Mesa #3 - M3-0308-0004	1	2026-03-08 22:41:07.995863
1233	10	SALIDA	1.00	97.00	96.00	\N	\N	Mesa #3 - M3-0308-0004	1	2026-03-08 22:41:08.01023
1234	22	SALIDA	1.00	41.00	40.00	\N	\N	Mesa #3 - M3-0308-0004	1	2026-03-08 22:41:08.024139
1235	20	ENTRADA	200.00	0.00	200.00	\N	\N	\N	1	2026-03-08 22:41:22.012248
1236	20	SALIDA	1.00	200.00	199.00	\N	\N	Mesa #3 - M3-0308-0004	1	2026-03-08 22:41:35.436518
1237	76	SALIDA	2.00	43.00	41.00	\N	\N	Mesa #5 - M5-0308-0002	1	2026-03-08 23:00:45.581691
1238	66	SALIDA	2.00	33.00	31.00	\N	\N	Mesa #5 - M5-0308-0002	1	2026-03-08 23:00:45.598294
1239	66	SALIDA	1.00	31.00	30.00	\N	\N	Mesa #5 - M5-0308-0002	1	2026-03-08 23:18:46.260926
1240	79	ENTRADA	1.00	90.00	91.00	\N	\N	Anulación - Factura V0308-0003	1	2026-03-08 23:33:08.407359
1241	79	SALIDA	2.00	91.00	89.00	\N	\N	Mesa #8 - M8-0309-0001	1	2026-03-09 20:32:51.950149
1242	19	SALIDA	3.00	10.00	7.00	\N	\N	Mesa #6 - M6-0309-0001	1	2026-03-09 20:33:27.895951
1243	45	SALIDA	1.00	47.00	46.00	\N	\N	Mesa #6 - M6-0309-0001	1	2026-03-09 20:33:27.914069
1244	35	SALIDA	2.00	22.00	20.00	\N	\N	Mesa #6 - M6-0309-0001	1	2026-03-09 20:33:27.93066
1245	35	SALIDA	1.00	20.00	19.00	\N	\N	Mesa #5 - M5-0309-0001	1	2026-03-09 20:34:37.547307
1246	36	SALIDA	1.00	41.00	40.00	\N	\N	Mesa #5 - M5-0309-0001	1	2026-03-09 20:34:37.566117
1247	8	SALIDA	1.00	89.00	88.00	\N	\N	Mesa #5 - M5-0309-0001	1	2026-03-09 20:34:37.590335
1248	22	SALIDA	1.00	40.00	39.00	\N	\N	Mesa #5 - M5-0309-0001	1	2026-03-09 20:34:37.610043
1251	74	SALIDA	1.00	40.00	39.00	\N	\N	Venta - Factura V0309-0001	1	2026-03-09 21:38:48.898371
1252	75	SALIDA	1.00	42.00	41.00	\N	\N	Venta - Factura V0309-0001	1	2026-03-09 21:38:48.912513
1253	2	ENTRADA	100.00	0.00	100.00	\N	\N	\N	1	2026-03-09 21:41:33.364837
1254	8	SALIDA	1.00	88.00	87.00	\N	\N	Venta - Factura V0309-0002	1	2026-03-09 21:44:22.99521
1255	2	SALIDA	1.00	100.00	99.00	\N	\N	Venta - Factura V0309-0002	1	2026-03-09 21:44:23.007297
1256	48	SALIDA	1.00	39.00	38.00	\N	\N	Venta - Factura V0309-0003	1	2026-03-09 23:20:02.174389
1257	48	SALIDA	1.00	38.00	37.00	\N	\N	Venta - Factura V0309-0004	1	2026-03-09 23:36:30.026289
\.


--
-- Data for Name: invoice_details; Type: TABLE DATA; Schema: public; Owner: morales_user
--

COPY public.invoice_details (id, invoice_id, product_id, product_name, quantity, unit_price, cost_price, discount_amount, tax_amount, subtotal, created_at, notes, kitchen_status) FROM stdin;
244	108	19	Papas al carbón supreme	1.00	25000.00	16000.00	0.00	0.00	25000.00	2026-02-18 20:19:15.700942	\N	ENTREGADO
245	108	35	Coco	2.00	10000.00	5000.00	0.00	0.00	20000.00	2026-02-18 20:19:15.770288	\N	ENTREGADO
246	108	5	Picadita De La Casa	1.00	25000.00	15000.00	0.00	0.00	25000.00	2026-02-18 20:19:15.803757	\N	ENTREGADO
249	111	63	Americano	1.00	5500.00	3000.00	0.00	0.00	5500.00	2026-02-19 16:45:30.654073	\N	ENTREGADO
310	127	63	Americano	1.00	5500.00	3000.00	0.00	0.00	5500.00	2026-02-20 21:08:55.266609	\N	ENTREGADO
252	114	25	Papas Francesas	1.00	8000.00	4000.00	0.00	0.00	8000.00	2026-02-19 18:20:44.814385	\N	ENTREGADO
311	124	32	Jugos en leche	1.00	10000.00	5000.00	0.00	0.00	10000.00	2026-02-20 21:11:06.2343	\N	ENTREGADO
157	67	3	Chicharron	2.00	27000.00	15000.00	0.00	0.00	54000.00	2026-02-11 13:40:52.645854	\N	ENTREGADO
159	67	11	Especial	1.00	27000.00	14000.00	0.00	0.00	27000.00	2026-02-11 13:40:52.726606	\N	ENTREGADO
158	67	2	Costilla	1.00	29000.00	15000.00	0.00	0.00	29000.00	2026-02-11 13:40:52.691569	\N	ENTREGADO
166	71	66	capuchino	2.00	7500.00	4500.00	0.00	0.00	15000.00	2026-02-11 20:35:21.104373	\N	ENTREGADO
771	272	38	Limonada de vino	1.00	12000.00	6000.00	0.00	0.00	12000.00	2026-03-07 20:46:37.485688	\N	ENTREGADO
383	155	51	3 Cordilleras	1.00	9000.00	7000.00	0.00	0.00	9000.00	2026-02-22 21:12:58.313133	\N	ENTREGADO
384	155	8	Mix de costilla, chicharrón y bondiola	1.00	38000.00	19000.00	0.00	0.00	38000.00	2026-02-22 21:12:58.327242	\N	ENTREGADO
315	128	75	Chocolate	1.00	11500.00	7000.00	0.00	0.00	11500.00	2026-02-20 21:49:58.93753	\N	ENTREGADO
321	132	3	Chicharron	1.00	30000.00	15000.00	0.00	0.00	30000.00	2026-02-21 19:31:45.376902	\N	ENTREGADO
322	132	2	Costilla	1.00	30000.00	15000.00	0.00	0.00	30000.00	2026-02-21 19:31:45.402027	\N	ENTREGADO
172	75	20	Papas al carbón mix	2.00	26000.00	13000.00	0.00	0.00	52000.00	2026-02-13 17:27:44.319687	Tomaré, 	ENTREGADO
379	154	19	Papas al carbón supreme	1.00	25000.00	16000.00	0.00	0.00	25000.00	2026-02-22 21:01:56.460813	Bbq 	ENTREGADO
380	154	29	Cereza	2.00	10000.00	5000.00	0.00	0.00	20000.00	2026-02-22 21:01:56.49205	\N	ENTREGADO
174	75	1	Salchipapas	2.00	25000.00	13000.00	0.00	0.00	50000.00	2026-02-13 17:27:44.396317	\N	ENTREGADO
173	75	19	Papas al carbón supreme	2.00	25000.00	16000.00	0.00	0.00	50000.00	2026-02-13 17:27:44.36955	\N	ENTREGADO
381	154	63	Americano	2.00	5500.00	3000.00	0.00	0.00	11000.00	2026-02-22 21:01:56.504054	\N	ENTREGADO
386	156	32	Jugos en leche	1.00	10000.00	5000.00	0.00	0.00	10000.00	2026-02-22 21:44:39.66294	\N	ENTREGADO
175	75	9	Bondiola	1.00	29000.00	13000.00	0.00	0.00	29000.00	2026-02-13 17:27:44.424296	\N	ENTREGADO
176	75	3	Chicharron	1.00	30000.00	15000.00	0.00	0.00	30000.00	2026-02-13 17:27:44.455191	\N	ENTREGADO
329	135	3	Chicharron	1.00	30000.00	15000.00	0.00	0.00	30000.00	2026-02-22 00:11:02.944468	con limon	ENTREGADO
189	79	5	Picadita De La Casa	1.00	25000.00	15000.00	0.00	0.00	25000.00	2026-02-15 21:36:47.512671	\N	ENTREGADO
190	79	10	Sencilla	1.00	22000.00	11000.00	0.00	0.00	22000.00	2026-02-15 21:36:47.570035	\N	ENTREGADO
330	135	2	Costilla	1.00	30000.00	15000.00	0.00	0.00	30000.00	2026-02-22 00:11:03.005397	\N	ENTREGADO
191	80	52	Corona	1.00	9000.00	7000.00	0.00	0.00	9000.00	2026-02-15 21:41:27.405737	\N	ENTREGADO
192	80	4	Entradas	1.00	10000.00	4000.00	0.00	0.00	10000.00	2026-02-15 21:41:27.448755	\N	ENTREGADO
193	80	10	Sencilla	1.00	22000.00	11000.00	0.00	0.00	22000.00	2026-02-15 21:41:27.479419	\N	ENTREGADO
201	84	5	Picadita De La Casa	2.00	25000.00	15000.00	0.00	0.00	50000.00	2026-02-15 22:58:25.81005	\N	ENTREGADO
212	88	5	Picadita De La Casa	2.00	25000.00	15000.00	0.00	0.00	50000.00	2026-02-16 09:47:00.585558	\N	ENTREGADO
388	157	21	Filete de Pechuga	2.00	26000.00	13000.00	0.00	0.00	52000.00	2026-02-22 22:01:34.550679	\N	ENTREGADO
216	90	31	Jugos en agua	1.00	8000.00	4000.00	0.00	0.00	8000.00	2026-02-16 13:51:49.205355	\N	ENTREGADO
217	90	32	Jugos en leche	1.00	10000.00	5000.00	0.00	0.00	10000.00	2026-02-16 13:51:49.225552	\N	ENTREGADO
215	89	5	Picadita De La Casa	1.00	25000.00	15000.00	0.00	0.00	25000.00	2026-02-16 13:51:03.511659	\N	ENTREGADO
228	96	38	Limonada de vino	1.00	12000.00	6000.00	0.00	0.00	12000.00	2026-02-16 21:25:00.129118	\N	ENTREGADO
229	96	35	Coco	1.00	10000.00	5000.00	0.00	0.00	10000.00	2026-02-16 21:25:00.150538	\N	ENTREGADO
230	96	11	Especial	2.00	32000.00	14000.00	0.00	0.00	64000.00	2026-02-16 21:25:00.185591	\N	ENTREGADO
389	157	35	Coco	3.00	10000.00	5000.00	0.00	0.00	30000.00	2026-02-22 22:01:34.562806	\N	ENTREGADO
390	158	19	Papas al carbón supreme	1.00	25000.00	16000.00	0.00	0.00	25000.00	2026-02-22 22:29:36.618873	Sin maizicitos	ENTREGADO
391	158	3	Chicharron	1.00	30000.00	15000.00	0.00	0.00	30000.00	2026-02-22 22:29:36.63954	Papas en casco	ENTREGADO
392	158	31	Jugos en agua	1.00	8000.00	4000.00	0.00	0.00	8000.00	2026-02-22 22:29:36.652798	\N	ENTREGADO
393	158	43	Coca-cola	1.00	7000.00	3500.00	0.00	0.00	7000.00	2026-02-22 23:03:27.081755	\N	ENTREGADO
395	159	3	Chicharron	1.00	30000.00	15000.00	0.00	0.00	30000.00	2026-02-23 18:54:25.044017	\N	ENTREGADO
344	139	46	Aguila Light	1.00	6000.00	4000.00	0.00	0.00	6000.00	2026-02-22 01:38:20.314776	\N	ENTREGADO
345	139	47	Aguila	2.00	7000.00	4000.00	0.00	0.00	14000.00	2026-02-22 01:38:20.399714	\N	ENTREGADO
358	144	51	3 Cordilleras	1.00	9000.00	7000.00	0.00	0.00	9000.00	2026-02-22 18:50:00.55613	\N	ENTREGADO
361	145	21	Filete de Pechuga	1.00	26000.00	13000.00	0.00	0.00	26000.00	2026-02-22 18:58:26.295041	\N	ENTREGADO
362	145	49	Heineken	1.00	8000.00	6000.00	0.00	0.00	8000.00	2026-02-22 18:58:26.306879	\N	ENTREGADO
363	146	70	Café Frappe	2.00	7800.00	4000.00	0.00	0.00	15600.00	2026-02-22 19:01:35.444081	\N	ENTREGADO
374	151	20	Papas al carbón mix	1.00	26000.00	13000.00	0.00	0.00	26000.00	2026-02-22 19:37:31.558272	\N	ENTREGADO
375	152	18	Salchipapas	1.00	17000.00	9000.00	0.00	0.00	17000.00	2026-02-22 20:16:44.438238	\N	ENTREGADO
376	153	73	Frappe Amaretto	1.00	13000.00	6000.00	0.00	0.00	13000.00	2026-02-22 20:28:28.907435	\N	ENTREGADO
378	153	77	Red Velvet	2.00	11500.00	7000.00	0.00	0.00	23000.00	2026-02-22 20:28:28.93957	\N	ENTREGADO
377	153	74	Frappe Baileys	1.00	13000.00	6000.00	0.00	0.00	13000.00	2026-02-22 20:28:28.927081	\N	ENTREGADO
316	129	19	Papas al carbón supreme	1.00	25000.00	16000.00	0.00	0.00	25000.00	2026-02-20 22:01:31.997767	\N	ENTREGADO
248	110	66	capuchino	1.00	7500.00	4500.00	0.00	0.00	7500.00	2026-02-18 20:47:03.934975	\N	ENTREGADO
160	68	8	mix de costilla y chicharron	1.00	35000.00	19000.00	0.00	0.00	35000.00	2026-02-11 17:12:40.616638	Sin arepa	ENTREGADO
162	68	9	Bondiola	2.00	28000.00	13000.00	0.00	0.00	56000.00	2026-02-11 17:12:40.668205	\N	ENTREGADO
161	68	3	Chicharron	1.00	27000.00	15000.00	0.00	0.00	27000.00	2026-02-11 17:12:40.648939	\N	ENTREGADO
167	72	20	Papas al carbón mix	1.00	26000.00	13000.00	0.00	0.00	26000.00	2026-02-11 20:38:42.805767	\N	ENTREGADO
317	129	8	Mix de costilla, chicharrón y bondiola	3.00	38000.00	19000.00	0.00	0.00	114000.00	2026-02-20 22:01:32.016304	\N	ENTREGADO
250	112	63	Americano	2.00	5500.00	3000.00	0.00	0.00	11000.00	2026-02-19 18:11:01.410685	\N	ENTREGADO
251	114	23	Punta de Anca	1.00	38000.00	19000.00	0.00	0.00	38000.00	2026-02-19 18:20:44.77373	\N	ENTREGADO
382	155	28	Maracuya	1.00	10000.00	5000.00	0.00	0.00	10000.00	2026-02-22 21:12:58.292449	\N	ENTREGADO
312	128	73	Frappe Amaretto	1.00	13000.00	6000.00	0.00	0.00	13000.00	2026-02-20 21:30:58.633088	\N	ENTREGADO
177	76	8	Mix de costilla, chicharrón y bondiola	2.00	38000.00	19000.00	0.00	0.00	76000.00	2026-02-14 20:13:59.334728	sin queso	ENTREGADO
385	156	80	Picada Grande	1.00	65000.00	35000.00	0.00	0.00	65000.00	2026-02-22 21:44:39.63988	\N	ENTREGADO
178	76	9	Bondiola	1.00	29000.00	13000.00	0.00	0.00	29000.00	2026-02-14 20:13:59.37173	\N	ENTREGADO
179	76	48	Pilsen	1.00	7000.00	4000.00	0.00	0.00	7000.00	2026-02-14 20:13:59.402716	\N	ENTREGADO
313	128	74	Frappe Baileys	1.00	13000.00	6000.00	0.00	0.00	13000.00	2026-02-20 21:30:58.67493	\N	ENTREGADO
314	128	5	Picadita De La Casa	1.00	25000.00	15000.00	0.00	0.00	25000.00	2026-02-20 21:30:58.694426	\N	ENTREGADO
194	81	10	Sencilla	2.00	22000.00	11000.00	0.00	0.00	44000.00	2026-02-15 21:42:57.411209	\N	ENTREGADO
195	81	1	Salchipapas	1.00	25000.00	13000.00	0.00	0.00	25000.00	2026-02-15 21:42:57.4577	\N	ENTREGADO
196	81	6	Patacones	1.00	12000.00	4500.00	0.00	0.00	12000.00	2026-02-15 21:42:57.522208	\N	ENTREGADO
202	86	3	Chicharron	1.00	30000.00	15000.00	0.00	0.00	30000.00	2026-02-16 08:31:00.291335	\N	ENTREGADO
203	86	9	Bondiola	1.00	29000.00	13000.00	0.00	0.00	29000.00	2026-02-16 08:31:00.404928	\N	ENTREGADO
204	86	39	Manzana	1.00	6000.00	4000.00	0.00	0.00	6000.00	2026-02-16 08:31:00.450717	\N	ENTREGADO
205	86	40	Colombiana	1.00	6000.00	4000.00	0.00	0.00	6000.00	2026-02-16 08:31:00.505359	\N	ENTREGADO
206	86	42	Uva	1.00	6000.00	4000.00	0.00	0.00	6000.00	2026-02-16 08:31:00.537626	\N	ENTREGADO
320	131	74	Frappe Baileys	1.00	13000.00	6000.00	0.00	0.00	13000.00	2026-02-21 18:31:05.672296	\N	ENTREGADO
268	120	52	Corona	1.00	9000.00	7000.00	0.00	0.00	9000.00	2026-02-20 19:41:31.346674	\N	ENTREGADO
323	133	3	Chicharron	1.00	30000.00	15000.00	0.00	0.00	30000.00	2026-02-21 19:32:44.507892	\N	ENTREGADO
207	87	42	Uva	5.00	6000.00	4000.00	0.00	0.00	30000.00	2026-02-16 08:31:16.203827	\N	ENTREGADO
208	87	41	Naranjada	1.00	6000.00	4000.00	0.00	0.00	6000.00	2026-02-16 08:31:16.261231	\N	ENTREGADO
209	87	40	Colombiana	1.00	6000.00	4000.00	0.00	0.00	6000.00	2026-02-16 08:31:16.307162	\N	ENTREGADO
324	133	2	Costilla	1.00	30000.00	15000.00	0.00	0.00	30000.00	2026-02-21 19:32:44.556655	\N	ENTREGADO
213	88	52	Corona	1.00	9000.00	7000.00	0.00	0.00	9000.00	2026-02-16 09:50:37.56127	\N	ENTREGADO
218	91	19	Papas al carbón supreme	1.00	25000.00	16000.00	0.00	0.00	25000.00	2026-02-16 20:58:48.790361	\N	ENTREGADO
219	93	9	Bondiola	1.00	29000.00	13000.00	0.00	0.00	29000.00	2026-02-16 21:05:05.292285	\N	ENTREGADO
220	93	8	Mix de costilla, chicharrón y bondiola	1.00	38000.00	19000.00	0.00	0.00	38000.00	2026-02-16 21:05:05.316451	\N	ENTREGADO
221	93	7	Ceviche de chicharron	1.00	25000.00	17000.00	0.00	0.00	25000.00	2026-02-16 21:05:05.33939	\N	ENTREGADO
231	97	37	Cereza	1.00	10000.00	5000.00	0.00	0.00	10000.00	2026-02-16 21:45:08.032993	\N	ENTREGADO
387	157	10	Sencilla	2.00	22000.00	11000.00	0.00	0.00	44000.00	2026-02-22 22:01:34.530044	\N	ENTREGADO
346	139	51	3 Cordilleras	3.00	9000.00	7000.00	0.00	0.00	27000.00	2026-02-22 02:15:48.637652	\N	ENTREGADO
296	123	78	Hamburguesa de chicharrón	1.00	32000.00	30000.00	0.00	0.00	32000.00	2026-02-20 20:04:26.310437	\N	ENTREGADO
354	143	78	Hamburguesa de chicharrón	1.00	32000.00	30000.00	0.00	0.00	32000.00	2026-02-22 17:42:42.012786	\N	ENTREGADO
355	143	14	Argentina	1.00	30000.00	15000.00	0.00	0.00	30000.00	2026-02-22 17:42:42.028199	\N	ENTREGADO
356	143	19	Papas al carbón supreme	1.00	25000.00	16000.00	0.00	0.00	25000.00	2026-02-22 17:42:42.044395	\N	ENTREGADO
357	143	20	Papas al carbón mix	1.00	26000.00	13000.00	0.00	0.00	26000.00	2026-02-22 17:42:42.058712	\N	ENTREGADO
364	147	20	Papas al carbón mix	1.00	26000.00	13000.00	0.00	0.00	26000.00	2026-02-22 19:02:57.234182	\N	ENTREGADO
359	145	19	Papas al carbón supreme	1.00	25000.00	16000.00	0.00	0.00	25000.00	2026-02-22 18:58:26.256778	\N	ENTREGADO
360	145	34	Natural	1.00	9000.00	4500.00	0.00	0.00	9000.00	2026-02-22 18:58:26.278442	\N	ENTREGADO
297	123	7	Ceviche de chicharron	1.00	25000.00	17000.00	0.00	0.00	25000.00	2026-02-20 20:04:26.398565	\N	ENTREGADO
299	123	46	Aguila Light	1.00	6000.00	4000.00	0.00	0.00	6000.00	2026-02-20 20:04:26.440622	\N	ENTREGADO
298	123	20	Papas al carbón mix	1.00	26000.00	13000.00	0.00	0.00	26000.00	2026-02-20 20:04:26.422871	\N	ENTREGADO
300	123	36	Hierbabuena	1.00	10000.00	5000.00	0.00	0.00	10000.00	2026-02-20 20:04:26.456318	\N	ENTREGADO
80	31	4	Entradas	1.00	10000.00	4000.00	0.00	0.00	10000.00	2026-02-09 21:02:47.60451	\N	ENTREGADO
79	31	3	Chicharron	1.00	27000.00	15000.00	0.00	0.00	27000.00	2026-02-09 21:02:47.562333	\N	ENTREGADO
301	124	13	Mini Picada	1.00	25000.00	15000.00	0.00	0.00	25000.00	2026-02-20 20:07:08.681591	\N	ENTREGADO
303	124	32	Jugos en leche	1.00	10000.00	5000.00	0.00	0.00	10000.00	2026-02-20 20:07:08.745552	\N	ENTREGADO
304	124	43	Coca-cola	1.00	7000.00	3500.00	0.00	0.00	7000.00	2026-02-20 20:07:08.769124	\N	ENTREGADO
302	124	20	Papas al carbón mix	1.00	26000.00	13000.00	0.00	0.00	26000.00	2026-02-20 20:07:08.727198	\N	ENTREGADO
309	126	31	Jugos en agua	1.00	8000.00	4000.00	0.00	0.00	8000.00	2026-02-20 20:38:21.918311	\N	ENTREGADO
155	66	4	Entradas	1.00	10000.00	4000.00	0.00	0.00	10000.00	2026-02-11 13:31:48.114645	sin cebolla	ENTREGADO
156	66	3	Chicharron	1.00	27000.00	15000.00	0.00	0.00	27000.00	2026-02-11 13:31:48.167428	con salsa de tomate	ENTREGADO
163	69	10	Sencilla	2.00	22000.00	11000.00	0.00	0.00	44000.00	2026-02-11 17:14:46.004384	\N	ENTREGADO
164	69	11	Especial	1.00	27000.00	14000.00	0.00	0.00	27000.00	2026-02-11 17:14:46.025747	\N	ENTREGADO
147	60	7	Ceviche de chicharron	1.00	22000.00	17000.00	0.00	0.00	22000.00	2026-02-10 20:11:16.636423	\N	LISTO
168	73	19	Papas al carbón supreme	1.00	25000.00	16000.00	0.00	0.00	25000.00	2026-02-11 21:25:58.330618	\N	ENTREGADO
169	73	74	Frappe Baileys	1.00	10800.00	6000.00	0.00	0.00	10800.00	2026-02-11 21:25:58.351803	\N	ENTREGADO
3	2	2	carne	1.00	20000.00	10000.00	0.00	0.00	20000.00	2026-01-28 09:28:32.562138	\N	ENTREGADO
2	2	1	salchipapas	2.00	25000.00	13000.00	0.00	0.00	50000.00	2026-01-28 09:28:32.519405	\N	ENTREGADO
7	4	2	carne	1.00	20000.00	10000.00	0.00	0.00	20000.00	2026-01-28 11:34:50.869557	\N	ENTREGADO
6	4	1	salchipapas	2.00	25000.00	13000.00	0.00	0.00	50000.00	2026-01-28 11:34:50.843514	\N	ENTREGADO
8	5	2	carne	4.00	20000.00	10000.00	0.00	0.00	80000.00	2026-01-28 11:36:58.858811	\N	ENTREGADO
10	6	2	carne	2.00	20000.00	10000.00	0.00	0.00	40000.00	2026-01-28 18:39:26.163895	\N	ENTREGADO
9	6	1	salchipapas	2.00	25000.00	13000.00	0.00	0.00	50000.00	2026-01-28 18:39:26.11362	\N	ENTREGADO
11	7	1	salchipapas	6.00	25000.00	13000.00	0.00	0.00	150000.00	2026-01-30 08:41:49.914326	\N	ENTREGADO
13	8	2	carne	2.00	20000.00	10000.00	0.00	0.00	40000.00	2026-01-30 09:03:07.375396	\N	ENTREGADO
12	8	1	salchipapas	3.00	25000.00	13000.00	0.00	0.00	75000.00	2026-01-30 09:03:07.330499	\N	ENTREGADO
54	22	2	Costilla	1.00	29000.00	15000.00	0.00	0.00	29000.00	2026-01-30 15:36:06.397867	\N	ENTREGADO
53	22	4	Entradas	2.00	10000.00	4000.00	0.00	0.00	20000.00	2026-01-30 15:36:06.378732	\N	ENTREGADO
52	22	3	Chicharron	1.00	27000.00	15000.00	0.00	0.00	27000.00	2026-01-30 15:36:06.354911	\N	ENTREGADO
51	22	1	salchipapas	1.00	25000.00	13000.00	0.00	0.00	25000.00	2026-01-30 15:36:06.335387	\N	ENTREGADO
20	11	2	Costilla	1.00	29000.00	15000.00	0.00	0.00	29000.00	2026-01-30 09:14:12.002067	\N	ENTREGADO
19	11	1	salchipapas	1.00	25000.00	13000.00	0.00	0.00	25000.00	2026-01-30 09:14:11.955217	\N	ENTREGADO
18	11	3	Chicharron	1.00	27000.00	15000.00	0.00	0.00	27000.00	2026-01-30 09:14:11.918531	\N	ENTREGADO
25	12	5	Picadita De La Casa	1.00	25000.00	15000.00	0.00	0.00	25000.00	2026-01-30 10:11:31.574848	\N	ENTREGADO
24	12	4	Entradas	1.00	10000.00	4000.00	0.00	0.00	10000.00	2026-01-30 10:11:31.542771	\N	ENTREGADO
23	12	2	Costilla	1.00	29000.00	15000.00	0.00	0.00	29000.00	2026-01-30 10:11:31.521495	\N	ENTREGADO
22	12	1	salchipapas	2.00	25000.00	13000.00	0.00	0.00	50000.00	2026-01-30 10:11:31.49935	\N	ENTREGADO
21	12	3	Chicharron	5.00	27000.00	15000.00	0.00	0.00	135000.00	2026-01-30 10:11:31.474422	\N	ENTREGADO
30	13	2	Costilla	1.00	29000.00	15000.00	0.00	0.00	29000.00	2026-01-30 13:12:39.479376	\N	ENTREGADO
29	13	5	Picadita De La Casa	1.00	25000.00	15000.00	0.00	0.00	25000.00	2026-01-30 13:12:39.451997	\N	ENTREGADO
28	13	1	salchipapas	1.00	25000.00	13000.00	0.00	0.00	25000.00	2026-01-30 13:12:39.427491	\N	ENTREGADO
27	13	3	Chicharron	1.00	27000.00	15000.00	0.00	0.00	27000.00	2026-01-30 13:12:39.394007	\N	ENTREGADO
26	13	4	Entradas	1.00	10000.00	4000.00	0.00	0.00	10000.00	2026-01-30 13:12:39.355779	\N	ENTREGADO
35	14	2	Costilla	2.00	29000.00	15000.00	0.00	0.00	58000.00	2026-01-30 13:16:08.332729	\N	ENTREGADO
34	14	5	Picadita De La Casa	2.00	25000.00	15000.00	0.00	0.00	50000.00	2026-01-30 13:16:08.313789	\N	ENTREGADO
33	14	1	salchipapas	2.00	25000.00	13000.00	0.00	0.00	50000.00	2026-01-30 13:16:08.291227	\N	ENTREGADO
32	14	3	Chicharron	4.00	27000.00	15000.00	0.00	0.00	108000.00	2026-01-30 13:16:08.268843	\N	ENTREGADO
31	14	4	Entradas	3.00	10000.00	4000.00	0.00	0.00	30000.00	2026-01-30 13:16:08.24668	\N	ENTREGADO
39	15	5	Picadita De La Casa	1.00	25000.00	15000.00	0.00	0.00	25000.00	2026-01-30 14:15:05.41412	\N	ENTREGADO
38	15	4	Entradas	2.00	10000.00	4000.00	0.00	0.00	20000.00	2026-01-30 14:15:05.380388	\N	ENTREGADO
37	15	1	salchipapas	1.00	25000.00	13000.00	0.00	0.00	25000.00	2026-01-30 14:15:05.34541	\N	ENTREGADO
36	15	3	Chicharron	1.00	27000.00	15000.00	0.00	0.00	27000.00	2026-01-30 14:15:05.317617	\N	ENTREGADO
41	16	5	Picadita De La Casa	1.00	25000.00	15000.00	0.00	0.00	25000.00	2026-01-30 14:24:55.911429	\N	ENTREGADO
40	16	4	Entradas	3.00	10000.00	4000.00	0.00	0.00	30000.00	2026-01-30 14:24:55.89224	\N	ENTREGADO
42	17	3	Chicharron	5.00	27000.00	15000.00	0.00	0.00	135000.00	2026-01-30 14:26:01.884964	\N	ENTREGADO
43	18	1	salchipapas	4.00	25000.00	13000.00	0.00	0.00	100000.00	2026-01-30 14:26:22.265465	\N	ENTREGADO
44	19	5	Picadita De La Casa	1.00	25000.00	15000.00	0.00	0.00	25000.00	2026-01-30 14:37:22.529599	\N	ENTREGADO
57	23	4	Entradas	1.00	10000.00	4000.00	0.00	0.00	10000.00	2026-02-04 18:39:38.670413	\N	ENTREGADO
56	23	3	Chicharron	1.00	27000.00	15000.00	0.00	0.00	27000.00	2026-02-04 18:39:38.618607	\N	ENTREGADO
55	23	1	salchipapas	1.00	25000.00	13000.00	0.00	0.00	25000.00	2026-02-04 18:39:38.555106	\N	ENTREGADO
50	21	1	salchipapas	1.00	25000.00	13000.00	0.00	0.00	25000.00	2026-01-30 15:35:35.89078	\N	ENTREGADO
49	21	4	Entradas	1.00	10000.00	4000.00	0.00	0.00	10000.00	2026-01-30 15:35:35.803087	\N	ENTREGADO
48	21	3	Chicharron	1.00	27000.00	15000.00	0.00	0.00	27000.00	2026-01-30 15:35:35.725696	\N	ENTREGADO
58	24	1	salchipapas	1.00	25000.00	13000.00	0.00	0.00	25000.00	2026-02-09 17:42:15.652913	\N	ENTREGADO
60	25	3	Chicharron	4.00	27000.00	15000.00	0.00	0.00	108000.00	2026-02-09 17:42:53.753213	\N	ENTREGADO
59	25	4	Entradas	1.00	10000.00	4000.00	0.00	0.00	10000.00	2026-02-09 17:42:53.734701	\N	ENTREGADO
64	26	2	Costilla	1.00	29000.00	15000.00	0.00	0.00	29000.00	2026-02-09 17:45:08.960813	\N	ENTREGADO
180	76	52	Corona	3.00	9000.00	7000.00	0.00	0.00	27000.00	2026-02-14 20:18:09.746377	al clima	ENTREGADO
197	82	5	Picadita De La Casa	2.00	25000.00	15000.00	0.00	0.00	50000.00	2026-02-15 22:27:53.453032	\N	ENTREGADO
198	82	10	Sencilla	1.00	22000.00	11000.00	0.00	0.00	22000.00	2026-02-15 22:27:53.483134	\N	ENTREGADO
199	82	4	Entradas	1.00	10000.00	4000.00	0.00	0.00	10000.00	2026-02-15 22:27:53.508043	\N	ENTREGADO
63	26	3	Chicharron	4.00	27000.00	15000.00	0.00	0.00	108000.00	2026-02-09 17:45:08.945184	\N	ENTREGADO
62	26	5	Picadita De La Casa	1.00	25000.00	15000.00	0.00	0.00	25000.00	2026-02-09 17:45:08.928286	\N	ENTREGADO
61	26	1	salchipapas	3.00	25000.00	13000.00	0.00	0.00	75000.00	2026-02-09 17:45:08.915014	\N	ENTREGADO
68	27	2	Costilla	1.00	29000.00	15000.00	0.00	0.00	29000.00	2026-02-09 18:59:34.52254	\N	ENTREGADO
67	27	3	Chicharron	1.00	27000.00	15000.00	0.00	0.00	27000.00	2026-02-09 18:59:34.496165	\N	ENTREGADO
66	27	4	Entradas	1.00	10000.00	4000.00	0.00	0.00	10000.00	2026-02-09 18:59:34.466315	\N	ENTREGADO
65	27	1	salchipapas	1.00	25000.00	13000.00	0.00	0.00	25000.00	2026-02-09 18:59:34.419227	\N	ENTREGADO
71	28	4	Entradas	1.00	10000.00	4000.00	0.00	0.00	10000.00	2026-02-09 19:01:26.867157	\N	ENTREGADO
70	28	1	salchipapas	1.00	25000.00	13000.00	0.00	0.00	25000.00	2026-02-09 19:01:26.846824	\N	ENTREGADO
69	28	3	Chicharron	1.00	27000.00	15000.00	0.00	0.00	27000.00	2026-02-09 19:01:26.828993	\N	ENTREGADO
74	29	5	Picadita De La Casa	1.00	25000.00	15000.00	0.00	0.00	25000.00	2026-02-09 19:30:26.03048	\N	ENTREGADO
73	29	4	Entradas	1.00	10000.00	4000.00	0.00	0.00	10000.00	2026-02-09 19:30:26.012925	\N	ENTREGADO
72	29	3	Chicharron	1.00	27000.00	15000.00	0.00	0.00	27000.00	2026-02-09 19:30:25.991952	\N	ENTREGADO
77	30	2	Costilla	1.00	29000.00	15000.00	0.00	0.00	29000.00	2026-02-09 19:34:41.272137	\N	ENTREGADO
76	30	1	salchipapas	1.00	25000.00	13000.00	0.00	0.00	25000.00	2026-02-09 19:34:41.252486	\N	ENTREGADO
75	30	3	Chicharron	1.00	27000.00	15000.00	0.00	0.00	27000.00	2026-02-09 19:34:41.235214	\N	ENTREGADO
78	31	1	salchipapas	1.00	25000.00	13000.00	0.00	0.00	25000.00	2026-02-09 21:02:47.468964	\N	ENTREGADO
85	32	2	Costilla	1.00	29000.00	15000.00	0.00	0.00	29000.00	2026-02-09 21:07:03.303896	\N	ENTREGADO
84	32	5	Picadita De La Casa	1.00	25000.00	15000.00	0.00	0.00	25000.00	2026-02-09 21:06:49.065502	\N	ENTREGADO
83	32	3	Chicharron	1.00	27000.00	15000.00	0.00	0.00	27000.00	2026-02-09 21:06:49.030001	\N	ENTREGADO
82	32	2	Costilla	1.00	29000.00	15000.00	0.00	0.00	29000.00	2026-02-09 21:06:49.006299	\N	ENTREGADO
81	32	1	salchipapas	1.00	25000.00	13000.00	0.00	0.00	25000.00	2026-02-09 21:06:48.952236	\N	ENTREGADO
96	37	3	Chicharron	1.00	27000.00	15000.00	0.00	0.00	27000.00	2026-02-09 22:07:51.865771	\N	ENTREGADO
93	34	5	Picadita De La Casa	1.00	25000.00	15000.00	0.00	0.00	25000.00	2026-02-09 21:49:25.656983	\N	ENTREGADO
92	34	3	Chicharron	1.00	27000.00	15000.00	0.00	0.00	27000.00	2026-02-09 21:49:17.817417	\N	ENTREGADO
91	34	2	Costilla	1.00	29000.00	15000.00	0.00	0.00	29000.00	2026-02-09 21:49:11.428759	\N	ENTREGADO
97	38	3	Chicharron	4.00	27000.00	15000.00	0.00	0.00	108000.00	2026-02-09 22:27:15.145444	\N	ENTREGADO
95	35	3	Chicharron	1.00	27000.00	15000.00	0.00	0.00	27000.00	2026-02-09 21:51:01.059636	\N	ENTREGADO
94	35	3	Chicharron	1.00	27000.00	15000.00	0.00	0.00	27000.00	2026-02-09 21:50:53.926954	\N	ENTREGADO
89	33	2	Costilla	1.00	29000.00	15000.00	0.00	0.00	29000.00	2026-02-09 21:13:29.127505	\N	ENTREGADO
88	33	5	Picadita De La Casa	4.00	25000.00	15000.00	0.00	0.00	100000.00	2026-02-09 21:13:21.013717	\N	ENTREGADO
87	33	3	Chicharron	1.00	27000.00	15000.00	0.00	0.00	27000.00	2026-02-09 21:13:20.984763	\N	ENTREGADO
86	33	2	Costilla	1.00	29000.00	15000.00	0.00	0.00	29000.00	2026-02-09 21:13:20.913902	\N	ENTREGADO
99	40	5	Picadita De La Casa	4.00	25000.00	15000.00	0.00	0.00	100000.00	2026-02-09 22:31:39.390456	\N	ENTREGADO
100	41	2	Costilla	4.00	29000.00	15000.00	0.00	0.00	116000.00	2026-02-09 22:39:18.680655	\N	ENTREGADO
101	36	3	Chicharron	1.00	27000.00	15000.00	0.00	0.00	27000.00	2026-02-09 22:39:40.32492	\N	ENTREGADO
98	39	5	Picadita De La Casa	3.00	25000.00	15000.00	0.00	0.00	75000.00	2026-02-09 22:28:29.910327	\N	ENTREGADO
103	42	5	Picadita De La Casa	1.00	25000.00	15000.00	0.00	0.00	25000.00	2026-02-09 22:52:48.364797	\N	ENTREGADO
102	42	3	Chicharron	1.00	27000.00	15000.00	0.00	0.00	27000.00	2026-02-09 22:52:48.060746	\N	ENTREGADO
104	43	5	Picadita De La Casa	2.00	25000.00	15000.00	0.00	0.00	50000.00	2026-02-09 22:53:38.113189	\N	ENTREGADO
108	47	5	Picadita De La Casa	1.00	25000.00	15000.00	0.00	0.00	25000.00	2026-02-09 23:15:34.254709	\N	ENTREGADO
105	44	5	Picadita De La Casa	1.00	25000.00	15000.00	0.00	0.00	25000.00	2026-02-09 23:06:42.310326	\N	ENTREGADO
107	46	5	Picadita De La Casa	2.00	25000.00	15000.00	0.00	0.00	50000.00	2026-02-09 23:13:36.002934	\N	ENTREGADO
106	45	5	Picadita De La Casa	1.00	25000.00	15000.00	0.00	0.00	25000.00	2026-02-09 23:10:59.579556	\N	ENTREGADO
113	49	5	Picadita De La Casa	1.00	25000.00	15000.00	0.00	0.00	25000.00	2026-02-10 08:53:39.187554	\N	ENTREGADO
112	49	8	mix de costilla y chicharron	1.00	35000.00	19000.00	0.00	0.00	35000.00	2026-02-10 08:53:39.168603	\N	ENTREGADO
111	49	9	Bondiola	1.00	28000.00	13000.00	0.00	0.00	28000.00	2026-02-10 08:53:39.149605	\N	ENTREGADO
150	63	4	Entradas	1.00	10000.00	4000.00	0.00	0.00	10000.00	2026-02-11 12:27:55.296027	\N	ENTREGADO
152	64	9	Bondiola	2.00	28000.00	13000.00	0.00	0.00	56000.00	2026-02-11 12:29:00.483334	\N	ENTREGADO
151	64	6	Patacones	1.00	9000.00	4500.00	0.00	0.00	9000.00	2026-02-11 12:29:00.45676	\N	ENTREGADO
124	52	6	Patacones	1.00	9000.00	4500.00	0.00	0.00	9000.00	2026-02-10 09:23:09.201572	\N	ENTREGADO
123	52	4	Entradas	1.00	10000.00	4000.00	0.00	0.00	10000.00	2026-02-10 09:23:09.182081	\N	ENTREGADO
122	52	3	Chicharron	1.00	27000.00	15000.00	0.00	0.00	27000.00	2026-02-10 09:23:09.159931	\N	ENTREGADO
154	65	7	Ceviche de chicharron	1.00	22000.00	17000.00	0.00	0.00	22000.00	2026-02-11 12:31:19.488496	\N	ENTREGADO
153	65	2	Costilla	1.00	29000.00	15000.00	0.00	0.00	29000.00	2026-02-11 12:31:19.45584	\N	ENTREGADO
121	54	11	Especial	1.00	27000.00	14000.00	0.00	0.00	27000.00	2026-02-10 09:22:36.029124	\N	ENTREGADO
120	54	2	Costilla	1.00	29000.00	15000.00	0.00	0.00	29000.00	2026-02-10 09:22:36.012406	\N	ENTREGADO
110	48	7	Ceviche de chicharron	1.00	22000.00	17000.00	0.00	0.00	22000.00	2026-02-10 08:52:13.000609	\N	ENTREGADO
109	48	4	Entradas	1.00	10000.00	4000.00	0.00	0.00	10000.00	2026-02-10 08:52:12.958457	\N	ENTREGADO
130	56	4	Entradas	1.00	10000.00	4000.00	0.00	0.00	10000.00	2026-02-10 09:33:55.320077	\N	ENTREGADO
129	56	3	Chicharron	1.00	27000.00	15000.00	0.00	0.00	27000.00	2026-02-10 09:33:55.302701	\N	ENTREGADO
128	56	2	Costilla	1.00	29000.00	15000.00	0.00	0.00	29000.00	2026-02-10 09:33:55.276429	\N	ENTREGADO
115	50	11	Especial	1.00	27000.00	14000.00	0.00	0.00	27000.00	2026-02-10 08:55:48.006505	\N	ENTREGADO
114	50	10	Sencilla	1.00	22000.00	11000.00	0.00	0.00	22000.00	2026-02-10 08:55:47.990264	\N	ENTREGADO
119	53	3	Chicharron	1.00	27000.00	15000.00	0.00	0.00	27000.00	2026-02-10 09:20:49.161603	\N	ENTREGADO
127	55	8	mix de costilla y chicharron	1.00	35000.00	19000.00	0.00	0.00	35000.00	2026-02-10 09:26:00.696235	\N	ENTREGADO
126	55	2	Costilla	1.00	29000.00	15000.00	0.00	0.00	29000.00	2026-02-10 09:26:00.679035	\N	ENTREGADO
125	55	3	Chicharron	1.00	27000.00	15000.00	0.00	0.00	27000.00	2026-02-10 09:26:00.659112	\N	ENTREGADO
118	51	8	mix de costilla y chicharron	1.00	35000.00	19000.00	0.00	0.00	35000.00	2026-02-10 08:58:58.331878	\N	ENTREGADO
117	51	3	Chicharron	1.00	27000.00	15000.00	0.00	0.00	27000.00	2026-02-10 08:58:58.316365	\N	ENTREGADO
116	51	2	Costilla	1.00	29000.00	15000.00	0.00	0.00	29000.00	2026-02-10 08:58:58.303388	\N	ENTREGADO
133	57	9	Bondiola	1.00	28000.00	13000.00	0.00	0.00	28000.00	2026-02-10 19:27:17.339676	\N	ENTREGADO
132	57	3	Chicharron	2.00	27000.00	15000.00	0.00	0.00	54000.00	2026-02-10 19:27:17.295912	\N	ENTREGADO
131	57	2	Costilla	1.00	29000.00	15000.00	0.00	0.00	29000.00	2026-02-10 19:27:17.24537	\N	ENTREGADO
136	58	11	Especial	2.00	27000.00	14000.00	0.00	0.00	54000.00	2026-02-10 19:34:56.895066	\N	ENTREGADO
135	58	11	Especial	1.00	27000.00	14000.00	0.00	0.00	27000.00	2026-02-10 19:28:34.632016	\N	ENTREGADO
134	58	10	Sencilla	1.00	22000.00	11000.00	0.00	0.00	22000.00	2026-02-10 19:28:34.600613	\N	ENTREGADO
146	60	6	Patacones	1.00	9000.00	4500.00	0.00	0.00	9000.00	2026-02-10 20:11:16.615781	\N	ENTREGADO
145	60	11	Especial	1.00	27000.00	14000.00	0.00	0.00	27000.00	2026-02-10 20:10:20.676471	\N	ENTREGADO
144	60	10	Sencilla	1.00	22000.00	11000.00	0.00	0.00	22000.00	2026-02-10 20:10:20.645438	\N	ENTREGADO
143	59	11	Especial	1.00	27000.00	14000.00	0.00	0.00	27000.00	2026-02-10 20:09:46.65356	\N	ENTREGADO
142	59	5	Picadita De La Casa	1.00	25000.00	15000.00	0.00	0.00	25000.00	2026-02-10 20:09:46.625071	\N	ENTREGADO
141	59	6	Patacones	1.00	9000.00	4500.00	0.00	0.00	9000.00	2026-02-10 20:09:46.597446	\N	ENTREGADO
140	59	8	mix de costilla y chicharron	1.00	35000.00	19000.00	0.00	0.00	35000.00	2026-02-10 20:09:46.572136	\N	ENTREGADO
139	59	3	Chicharron	1.00	27000.00	15000.00	0.00	0.00	27000.00	2026-02-10 20:09:46.547812	\N	ENTREGADO
138	59	2	Costilla	1.00	29000.00	15000.00	0.00	0.00	29000.00	2026-02-10 20:09:46.521713	\N	ENTREGADO
137	59	9	Bondiola	1.00	28000.00	13000.00	0.00	0.00	28000.00	2026-02-10 20:09:46.488298	\N	ENTREGADO
148	61	4	Entradas	1.00	10000.00	4000.00	0.00	0.00	10000.00	2026-02-11 12:21:37.93247	\N	ENTREGADO
149	62	6	Patacones	2.00	9000.00	4500.00	0.00	0.00	18000.00	2026-02-11 12:22:19.313006	\N	ENTREGADO
1	1	1	salchipapas	1.00	25000.00	13000.00	0.00	0.00	25000.00	2026-01-27 21:52:01.925819	\N	ENTREGADO
4	3	2	carne	1.00	20000.00	10000.00	0.00	0.00	20000.00	2026-01-28 09:30:12.346591	\N	ENTREGADO
5	3	1	salchipapas	1.00	25000.00	13000.00	0.00	0.00	25000.00	2026-01-28 09:30:12.403858	\N	ENTREGADO
14	9	1	salchipapas	3.00	25000.00	13000.00	0.00	0.00	75000.00	2026-01-30 09:03:43.557147	\N	ENTREGADO
15	9	2	carne	1.00	20000.00	10000.00	0.00	0.00	20000.00	2026-01-30 09:03:43.596678	\N	ENTREGADO
16	10	2	carne	4.00	20000.00	10000.00	0.00	0.00	80000.00	2026-01-30 09:04:15.426734	\N	ENTREGADO
17	10	1	salchipapas	1.00	25000.00	13000.00	0.00	0.00	25000.00	2026-01-30 09:04:15.476137	\N	ENTREGADO
45	20	2	Costilla	3.00	29000.00	15000.00	0.00	0.00	87000.00	2026-01-30 14:45:27.212507	\N	ENTREGADO
46	20	1	salchipapas	1.00	25000.00	13000.00	0.00	0.00	25000.00	2026-01-30 14:45:27.238713	\N	ENTREGADO
47	20	3	Chicharron	1.00	27000.00	15000.00	0.00	0.00	27000.00	2026-01-30 14:45:27.260706	\N	ENTREGADO
165	70	78	Hamburguesa de chicharrón	2.00	32000.00	32000.00	0.00	0.00	64000.00	2026-02-11 20:34:31.414858	\N	ENTREGADO
170	74	78	Hamburguesa de chicharrón	1.00	30000.00	30000.00	0.00	0.00	30000.00	2026-02-11 22:26:13.049883	\N	ENTREGADO
171	74	23	Punta de Anca	1.00	38000.00	19000.00	0.00	0.00	38000.00	2026-02-11 22:26:13.078198	\N	ENTREGADO
181	77	52	Corona	1.00	9000.00	7000.00	0.00	0.00	9000.00	2026-02-15 19:28:03.958653	\N	ENTREGADO
182	77	4	Entradas	1.00	10000.00	4000.00	0.00	0.00	10000.00	2026-02-15 19:28:03.981169	\N	ENTREGADO
183	77	5	Picadita De La Casa	1.00	25000.00	15000.00	0.00	0.00	25000.00	2026-02-15 19:28:04.00497	\N	ENTREGADO
557	210	37	Cereza	2.00	10000.00	5000.00	0.00	0.00	20000.00	2026-02-28 21:52:39.398831	\N	ENTREGADO
184	78	5	Picadita De La Casa	1.00	25000.00	15000.00	0.00	0.00	25000.00	2026-02-15 19:28:39.581981	\N	ENTREGADO
185	78	10	Sencilla	1.00	22000.00	11000.00	0.00	0.00	22000.00	2026-02-15 19:28:39.622698	\N	ENTREGADO
186	78	4	Entradas	1.00	10000.00	4000.00	0.00	0.00	10000.00	2026-02-15 19:28:39.657794	\N	ENTREGADO
187	78	52	Corona	1.00	9000.00	7000.00	0.00	0.00	9000.00	2026-02-15 19:28:39.689204	\N	ENTREGADO
188	78	1	Salchipapas	1.00	25000.00	13000.00	0.00	0.00	25000.00	2026-02-15 19:28:39.728839	\N	ENTREGADO
200	83	52	Corona	3.00	9000.00	7000.00	0.00	0.00	27000.00	2026-02-15 22:48:57.125507	\N	ENTREGADO
210	85	4	Entradas	1.00	10000.00	4000.00	0.00	0.00	10000.00	2026-02-16 09:11:46.44027	\N	ENTREGADO
211	85	13	Mini Picada	1.00	25000.00	15000.00	0.00	0.00	25000.00	2026-02-16 09:11:46.989479	\N	ENTREGADO
214	89	16	Sandwich chicharron	1.00	27000.00	16000.00	0.00	0.00	27000.00	2026-02-16 13:31:07.827999	\N	ENTREGADO
222	94	11	Especial	1.00	32000.00	14000.00	0.00	0.00	32000.00	2026-02-16 21:20:16.008868	\N	ENTREGADO
223	94	19	Papas al carbón supreme	1.00	25000.00	16000.00	0.00	0.00	25000.00	2026-02-16 21:20:16.035047	\N	ENTREGADO
224	94	29	Cereza	2.00	10000.00	5000.00	0.00	0.00	20000.00	2026-02-16 21:20:16.056787	\N	ENTREGADO
225	95	19	Papas al carbón supreme	1.00	25000.00	16000.00	0.00	0.00	25000.00	2026-02-16 21:22:19.965254	\N	ENTREGADO
226	95	11	Especial	1.00	32000.00	14000.00	0.00	0.00	32000.00	2026-02-16 21:22:19.986994	\N	ENTREGADO
227	95	37	Cereza	2.00	10000.00	5000.00	0.00	0.00	20000.00	2026-02-16 21:22:20.004408	\N	ENTREGADO
232	98	15	Sandwich	1.00	25000.00	16000.00	0.00	0.00	25000.00	2026-02-16 21:45:35.337035	\N	ENTREGADO
396	159	10	Hamburguesa Sencilla	1.00	22000.00	11000.00	0.00	0.00	22000.00	2026-02-23 18:54:25.077464	\N	ENTREGADO
394	159	79	1 Entradas Patacones-1 hamb sencilla-1 papas mix- 2 gaseosas	1.00	59000.00	40000.00	0.00	0.00	59000.00	2026-02-23 18:54:24.901128	\N	ENTREGADO
397	160	20	Papas al carbón mix	2.00	26000.00	13000.00	0.00	0.00	52000.00	2026-02-23 20:37:40.230038	\N	ENTREGADO
398	160	11	Especial	1.00	32000.00	14000.00	0.00	0.00	32000.00	2026-02-23 20:37:40.248578	\N	ENTREGADO
399	160	19	Papas al carbón supreme	1.00	25000.00	16000.00	0.00	0.00	25000.00	2026-02-23 20:37:40.266637	\N	ENTREGADO
400	161	23	Punta de Anca	1.00	38000.00	19000.00	0.00	0.00	38000.00	2026-02-23 22:33:12.662956	\N	ENTREGADO
401	161	34	Natural	1.00	9000.00	4500.00	0.00	0.00	9000.00	2026-02-23 22:33:12.700956	\N	ENTREGADO
402	162	76	Zanahoria	1.00	11500.00	7000.00	0.00	0.00	11500.00	2026-02-23 22:34:12.770708	\N	ENTREGADO
403	162	66	capuchino	1.00	7500.00	4500.00	0.00	0.00	7500.00	2026-02-23 22:34:12.770708	\N	ENTREGADO
404	163	3	Chicharron	1.00	30000.00	15000.00	0.00	0.00	30000.00	2026-02-23 22:42:09.807734	\N	ENTREGADO
405	163	10	Hamburguesa Sencilla	1.00	22000.00	11000.00	0.00	0.00	22000.00	2026-02-23 22:42:09.825237	\N	ENTREGADO
406	163	79	1 Entradas Patacones-1 hamb sencilla-1 papas mix- 2 gaseosas	1.00	59000.00	40000.00	0.00	0.00	59000.00	2026-02-23 22:42:09.842783	\N	ENTREGADO
407	164	20	Papas al carbón mix	2.00	26000.00	13000.00	0.00	0.00	52000.00	2026-02-25 18:43:36.369401	\N	ENTREGADO
408	164	18	Salchipapas	1.00	17000.00	9000.00	0.00	0.00	17000.00	2026-02-25 18:43:36.404627	\N	ENTREGADO
409	164	43	Coca-cola	1.00	7000.00	3500.00	0.00	0.00	7000.00	2026-02-25 18:43:36.428896	\N	ENTREGADO
410	164	31	Jugos en agua	1.00	8000.00	4000.00	0.00	0.00	8000.00	2026-02-25 18:43:36.456045	\N	ENTREGADO
411	165	20	Papas al carbón mix	2.00	26000.00	13000.00	0.00	0.00	52000.00	2026-02-25 18:45:37.58983	\N	ENTREGADO
412	165	18	Salchipapas	1.00	17000.00	9000.00	0.00	0.00	17000.00	2026-02-25 18:45:37.606114	\N	ENTREGADO
413	165	43	Coca-cola	1.00	7000.00	3500.00	0.00	0.00	7000.00	2026-02-25 18:45:37.642492	\N	ENTREGADO
414	165	6	Patacones	1.00	12000.00	4500.00	0.00	0.00	12000.00	2026-02-25 18:45:37.677957	\N	ENTREGADO
415	165	31	Jugos en agua	1.00	8000.00	4000.00	0.00	0.00	8000.00	2026-02-25 18:45:37.720399	\N	ENTREGADO
416	166	20	Papas al carbón mix	1.00	26000.00	13000.00	0.00	0.00	26000.00	2026-02-25 18:46:48.053376	\N	ENTREGADO
417	166	3	Chicharron	1.00	30000.00	15000.00	0.00	0.00	30000.00	2026-02-25 18:46:48.066013	\N	ENTREGADO
418	167	20	Papas al carbón mix	2.00	26000.00	13000.00	0.00	0.00	52000.00	2026-02-25 19:03:33.991177	\N	ENTREGADO
419	167	18	Salchipapas	1.00	17000.00	9000.00	0.00	0.00	17000.00	2026-02-25 19:03:34.003629	\N	ENTREGADO
420	167	6	Patacones	1.00	12000.00	4500.00	0.00	0.00	12000.00	2026-02-25 19:03:34.016374	\N	ENTREGADO
421	167	31	Jugos en agua	1.00	8000.00	4000.00	0.00	0.00	8000.00	2026-02-25 19:03:34.025316	\N	ENTREGADO
422	167	43	Coca-cola	1.00	7000.00	3500.00	0.00	0.00	7000.00	2026-02-25 19:03:34.043635	\N	ENTREGADO
558	210	35	Limonada de Coco	1.00	10000.00	5000.00	0.00	0.00	10000.00	2026-02-28 21:52:39.415078	\N	ENTREGADO
428	169	81	SODA	1.00	5000.00	2500.00	0.00	0.00	5000.00	2026-02-25 19:28:51.853865	\N	ENTREGADO
429	169	21	Filete de Pechuga	1.00	26000.00	13000.00	0.00	0.00	26000.00	2026-02-25 19:28:51.886247	\N	ENTREGADO
430	169	20	Papas al carbón mix	1.00	26000.00	13000.00	0.00	0.00	26000.00	2026-02-25 19:28:51.921385	\N	ENTREGADO
431	169	63	Americano	1.00	5500.00	3000.00	0.00	0.00	5500.00	2026-02-25 19:28:51.959344	\N	ENTREGADO
423	168	2	Costilla	1.00	30000.00	15000.00	0.00	0.00	30000.00	2026-02-25 19:06:47.228821	\N	ENTREGADO
424	168	30	Lychee	1.00	10000.00	5000.00	0.00	0.00	10000.00	2026-02-25 19:06:48.474535	\N	ENTREGADO
425	168	79	1 Entradas Patacones-1 hamb sencilla-1 papas mix- 2 gaseosas	1.00	59000.00	40000.00	0.00	0.00	59000.00	2026-02-25 19:06:48.514193	\N	ENTREGADO
426	168	36	Hierbabuena	1.00	10000.00	5000.00	0.00	0.00	10000.00	2026-02-25 19:06:48.609457	\N	ENTREGADO
427	168	75	Chocolate	1.00	11500.00	7000.00	0.00	0.00	11500.00	2026-02-25 19:06:48.645436	\N	ENTREGADO
434	171	3	Chicharron	1.00	30000.00	15000.00	0.00	0.00	30000.00	2026-02-25 19:58:52.488484	\N	ENTREGADO
435	171	7	Ceviche de chicharron	1.00	25000.00	17000.00	0.00	0.00	25000.00	2026-02-25 19:58:52.580935	\N	ENTREGADO
436	171	70	Café Frappe	2.00	7800.00	4000.00	0.00	0.00	15600.00	2026-02-25 19:58:52.621742	\N	ENTREGADO
432	170	79	1 Entradas Patacones-1 hamb sencilla-1 papas mix- 2 gaseosas	1.00	59000.00	40000.00	0.00	0.00	59000.00	2026-02-25 19:54:52.361028	\N	ENTREGADO
433	170	51	3 Cordilleras	1.00	9000.00	7000.00	0.00	0.00	9000.00	2026-02-25 19:54:52.46021	\N	ENTREGADO
437	173	8	Mix de costilla, chicharrón y bondiola	1.00	38000.00	19000.00	0.00	0.00	38000.00	2026-02-25 20:31:13.570049	\N	ENTREGADO
438	173	43	Coca-cola	1.00	7000.00	3500.00	0.00	0.00	7000.00	2026-02-25 20:31:13.748524	\N	ENTREGADO
439	174	20	Papas al carbón mix	1.00	26000.00	13000.00	0.00	0.00	26000.00	2026-02-25 21:34:49.943478	\N	ENTREGADO
442	176	2	Costilla	1.00	30000.00	15000.00	0.00	0.00	30000.00	2026-02-26 21:01:51.11725	\N	ENTREGADO
440	175	3	Chicharron	1.00	30000.00	15000.00	0.00	0.00	30000.00	2026-02-26 21:01:34.729551	\N	ENTREGADO
441	175	35	Limonada de Coco	1.00	10000.00	5000.00	0.00	0.00	10000.00	2026-02-26 21:01:34.768958	\N	ENTREGADO
447	175	77	Red Velvet	1.00	11500.00	7000.00	0.00	0.00	11500.00	2026-02-26 21:50:43.460613	\N	ENTREGADO
448	178	19	Papas al carbón supreme	1.00	25000.00	16000.00	0.00	0.00	25000.00	2026-02-26 21:52:14.06525	\N	ENTREGADO
449	178	31	Jugos en agua	1.00	8000.00	4000.00	0.00	0.00	8000.00	2026-02-26 21:54:47.35507	\N	ENTREGADO
443	177	19	Papas al carbón supreme	1.00	25000.00	16000.00	0.00	0.00	25000.00	2026-02-26 21:23:35.256997	\N	ENTREGADO
444	177	21	Filete de Pechuga	1.00	26000.00	13000.00	0.00	0.00	26000.00	2026-02-26 21:23:35.290889	\N	ENTREGADO
445	177	37	Cereza	1.00	10000.00	5000.00	0.00	0.00	10000.00	2026-02-26 21:23:35.319216	\N	ENTREGADO
446	177	82	SODA CEREZA	1.00	10000.00	5000.00	0.00	0.00	10000.00	2026-02-26 21:50:28.839569	\N	ENTREGADO
450	179	19	Papas al carbón supreme	1.00	25000.00	16000.00	0.00	0.00	25000.00	2026-02-26 22:03:59.413038	\N	ENTREGADO
451	179	31	Jugos en agua	1.00	8000.00	4000.00	0.00	0.00	8000.00	2026-02-26 22:03:59.42879	\N	ENTREGADO
452	180	18	Salchipapas	1.00	17000.00	9000.00	0.00	0.00	17000.00	2026-02-26 22:11:32.396455	\N	ENTREGADO
453	181	18	Salchipapas	1.00	17000.00	9000.00	0.00	0.00	17000.00	2026-02-26 22:25:15.855529	\N	ENTREGADO
559	210	31	Jugos en agua	1.00	8000.00	4000.00	0.00	0.00	8000.00	2026-02-28 21:52:39.435039	\N	ENTREGADO
560	210	50	Club Colombia	1.00	8000.00	6000.00	0.00	0.00	8000.00	2026-02-28 21:52:39.451792	\N	ENTREGADO
561	210	48	Pilsen	5.00	7000.00	4000.00	0.00	0.00	35000.00	2026-02-28 21:52:39.469004	\N	ENTREGADO
454	182	6	Patacones	1.00	12000.00	4500.00	0.00	0.00	12000.00	2026-02-27 18:38:32.842395	\N	ENTREGADO
455	182	76	Zanahoria	1.00	11500.00	7000.00	0.00	0.00	11500.00	2026-02-27 18:38:32.932243	\N	ENTREGADO
456	182	38	Limonada de vino	1.00	12000.00	6000.00	0.00	0.00	12000.00	2026-02-27 18:38:33.022438	\N	ENTREGADO
457	182	28	Soda Maracuya	1.00	10000.00	5000.00	0.00	0.00	10000.00	2026-02-27 18:38:33.10782	\N	ENTREGADO
742	267	11	Especial	1.00	32000.00	14000.00	0.00	0.00	32000.00	2026-03-07 19:39:58.851714	\N	ENTREGADO
458	183	7	Ceviche de chicharron	1.00	25000.00	17000.00	0.00	0.00	25000.00	2026-02-27 19:43:49.798041	\N	ENTREGADO
459	183	38	Limonada de vino	1.00	12000.00	6000.00	0.00	0.00	12000.00	2026-02-27 19:43:49.861772	\N	ENTREGADO
460	183	19	Papas al carbón supreme	1.00	25000.00	16000.00	0.00	0.00	25000.00	2026-02-27 19:43:49.896863	\N	ENTREGADO
461	183	20	Papas al carbón mix	1.00	26000.00	13000.00	0.00	0.00	26000.00	2026-02-27 19:43:49.92512	\N	ENTREGADO
462	183	77	Red Velvet	1.00	11500.00	7000.00	0.00	0.00	11500.00	2026-02-27 19:43:49.952002	\N	ENTREGADO
463	183	66	capuchino	1.00	7500.00	4500.00	0.00	0.00	7500.00	2026-02-27 19:43:49.980885	\N	ENTREGADO
464	183	54	Shot de ron	1.00	8000.00	6000.00	0.00	0.00	8000.00	2026-02-27 19:58:41.303592	\N	ENTREGADO
484	190	47	Aguila	1.00	7000.00	4000.00	0.00	0.00	7000.00	2026-02-27 22:02:03.39637	\N	ENTREGADO
469	185	74	Frappe Baileys	2.00	15000.00	6000.00	0.00	0.00	30000.00	2026-02-27 20:41:01.529509	\N	ENTREGADO
465	184	8	Mix de costilla, chicharrón y bondiola	1.00	38000.00	19000.00	0.00	0.00	38000.00	2026-02-27 20:16:08.958092	\N	ENTREGADO
466	184	6	Patacones	1.00	12000.00	4500.00	0.00	0.00	12000.00	2026-02-27 20:16:08.995513	\N	ENTREGADO
467	184	50	Club Colombia	1.00	8000.00	6000.00	0.00	0.00	8000.00	2026-02-27 20:16:09.026638	\N	ENTREGADO
468	184	70	Café Frappe	1.00	7800.00	4000.00	0.00	0.00	7800.00	2026-02-27 20:16:09.047976	\N	ENTREGADO
485	190	34	Natural	1.00	9000.00	4500.00	0.00	0.00	9000.00	2026-02-27 22:02:03.410822	\N	ENTREGADO
481	190	6	Patacones	1.00	12000.00	4500.00	0.00	0.00	12000.00	2026-02-27 22:02:03.34034	\N	ENTREGADO
482	190	23	Punta de Anca	1.00	38000.00	19000.00	0.00	0.00	38000.00	2026-02-27 22:02:03.367158	\N	ENTREGADO
483	190	8	Mix de costilla, chicharrón y bondiola	1.00	38000.00	19000.00	0.00	0.00	38000.00	2026-02-27 22:02:03.381611	\N	ENTREGADO
486	190	43	Coca-cola	1.00	7000.00	3500.00	0.00	0.00	7000.00	2026-02-27 22:02:03.428094	\N	ENTREGADO
473	188	35	Limonada de Coco	1.00	10000.00	5000.00	0.00	0.00	10000.00	2026-02-27 21:59:40.95579	\N	ENTREGADO
474	188	31	Jugos en agua	1.00	8000.00	4000.00	0.00	0.00	8000.00	2026-02-27 21:59:40.97341	\N	ENTREGADO
475	188	11	Especial	2.00	32000.00	14000.00	0.00	0.00	64000.00	2026-02-27 21:59:40.991975	\N	ENTREGADO
476	189	18	Salchipapas	1.00	17000.00	9000.00	0.00	0.00	17000.00	2026-02-27 22:01:08.601222	\N	ENTREGADO
477	189	22	Churrasco	1.00	36000.00	19000.00	0.00	0.00	36000.00	2026-02-27 22:01:08.63084	\N	ENTREGADO
478	189	77	Red Velvet	2.00	11500.00	7000.00	0.00	0.00	23000.00	2026-02-27 22:01:08.649343	\N	ENTREGADO
479	189	66	capuchino	1.00	7500.00	4500.00	0.00	0.00	7500.00	2026-02-27 22:01:08.66514	\N	ENTREGADO
480	189	34	Natural	1.00	9000.00	4500.00	0.00	0.00	9000.00	2026-02-27 22:01:08.685367	\N	ENTREGADO
490	191	19	Papas al carbón supreme	1.00	25000.00	16000.00	0.00	0.00	25000.00	2026-02-27 22:50:01.201539	\N	ENTREGADO
470	186	78	Hamburguesa de chicharrón	1.00	32000.00	30000.00	0.00	0.00	32000.00	2026-02-27 21:00:25.640086	\N	ENTREGADO
487	186	51	3 Cordilleras	1.00	9000.00	7000.00	0.00	0.00	9000.00	2026-02-27 22:02:32.405438	\N	ENTREGADO
493	186	74	Frappe Baileys	1.00	15000.00	6000.00	0.00	0.00	15000.00	2026-02-27 22:57:11.926217	\N	ENTREGADO
494	193	8	Mix de costilla, chicharrón y bondiola	1.00	38000.00	19000.00	0.00	0.00	38000.00	2026-02-27 23:20:46.240217	\N	ENTREGADO
495	193	6	Patacones	1.00	12000.00	4500.00	0.00	0.00	12000.00	2026-02-27 23:20:46.254753	\N	ENTREGADO
496	193	50	Club Colombia	1.00	8000.00	6000.00	0.00	0.00	8000.00	2026-02-27 23:20:46.271596	\N	ENTREGADO
497	193	70	Café Frappe	1.00	7800.00	4000.00	0.00	0.00	7800.00	2026-02-27 23:20:46.28426	\N	ENTREGADO
491	192	57	Copa de Sangria	2.00	16000.00	12000.00	0.00	0.00	32000.00	2026-02-27 22:50:48.641739	\N	ENTREGADO
492	192	5	Picadita De La Casa	1.00	25000.00	15000.00	0.00	0.00	25000.00	2026-02-27 22:50:48.670037	\N	ENTREGADO
498	194	27	Soda Michelada	1.00	8000.00	4000.00	0.00	0.00	8000.00	2026-02-28 17:15:26.262473	\N	ENTREGADO
499	195	6	Patacones	1.00	12000.00	4500.00	0.00	0.00	12000.00	2026-02-28 17:29:48.34386	\N	ENTREGADO
500	195	18	Salchipapas	1.00	17000.00	9000.00	0.00	0.00	17000.00	2026-02-28 17:29:48.389574	\N	ENTREGADO
501	195	46	Aguila Light	1.00	6000.00	4000.00	0.00	0.00	6000.00	2026-02-28 17:29:48.42191	\N	ENTREGADO
509	195	77	Red Velvet	1.00	11500.00	7000.00	0.00	0.00	11500.00	2026-02-28 18:22:25.97496	\N	ENTREGADO
510	195	78	Hamburguesa de chicharrón	1.00	32000.00	30000.00	0.00	0.00	32000.00	2026-02-28 18:28:31.351238	\N	ENTREGADO
511	195	28	Soda Maracuya	1.00	10000.00	5000.00	0.00	0.00	10000.00	2026-02-28 18:28:50.095881	\N	ENTREGADO
512	198	19	Papas al carbón supreme	1.00	25000.00	16000.00	0.00	0.00	25000.00	2026-02-28 18:40:42.669656	\N	ENTREGADO
516	200	6	Patacones	1.00	12000.00	4500.00	0.00	0.00	12000.00	2026-02-28 18:49:39.591526	\N	ENTREGADO
517	200	70	Café Frappe	2.00	7800.00	4000.00	0.00	0.00	15600.00	2026-02-28 18:49:39.630375	\N	ENTREGADO
513	199	8	Mix de costilla, chicharrón y bondiola	1.00	38000.00	19000.00	0.00	0.00	38000.00	2026-02-28 18:47:44.109229	Maiz,ajo	ENTREGADO
514	199	78	Hamburguesa de chicharrón	1.00	32000.00	30000.00	0.00	0.00	32000.00	2026-02-28 18:47:44.147753	Maiz, ajo,bbq	ENTREGADO
502	196	23	Punta de Anca	1.00	38000.00	19000.00	0.00	0.00	38000.00	2026-02-28 18:11:20.249191	\N	ENTREGADO
503	196	20	Papas al carbón mix	1.00	26000.00	13000.00	0.00	0.00	26000.00	2026-02-28 18:11:20.29919	\N	ENTREGADO
504	196	43	Coca-cola	1.00	7000.00	3500.00	0.00	0.00	7000.00	2026-02-28 18:11:20.326127	\N	ENTREGADO
505	196	48	Pilsen	2.00	7000.00	4000.00	0.00	0.00	14000.00	2026-02-28 18:11:20.354719	\N	ENTREGADO
546	208	22	Churrasco	1.00	36000.00	19000.00	0.00	0.00	36000.00	2026-02-28 21:40:00.110801	Termino medio	ENTREGADO
506	197	21	Filete de Pechuga	2.00	26000.00	13000.00	0.00	0.00	52000.00	2026-02-28 18:17:03.498458	\N	ENTREGADO
507	197	9	Bondiola	1.00	29000.00	13000.00	0.00	0.00	29000.00	2026-02-28 18:17:03.546562	\N	ENTREGADO
508	197	50	Club Colombia	3.00	8000.00	6000.00	0.00	0.00	24000.00	2026-02-28 18:17:03.575752	\N	ENTREGADO
547	208	2	Costilla	1.00	30000.00	15000.00	0.00	0.00	30000.00	2026-02-28 21:40:00.151528	Bbq	ENTREGADO
518	200	10	Hamburguesa Sencilla	1.00	22000.00	11000.00	0.00	0.00	22000.00	2026-02-28 18:49:39.650267	Ajo, maiz	ENTREGADO
548	208	28	Soda Maracuya	2.00	10000.00	5000.00	0.00	0.00	20000.00	2026-02-28 21:40:00.169409	\N	ENTREGADO
562	211	6	Patacones	1.00	12000.00	4500.00	0.00	0.00	12000.00	2026-02-28 21:53:57.058466	\N	ENTREGADO
552	210	3	Chicharron	2.00	30000.00	15000.00	0.00	0.00	60000.00	2026-02-28 21:52:39.281041	\N	ENTREGADO
553	210	2	Costilla	1.00	30000.00	15000.00	0.00	0.00	30000.00	2026-02-28 21:52:39.302284	\N	ENTREGADO
520	202	8	Mix de costilla, chicharrón y bondiola	1.00	38000.00	19000.00	0.00	0.00	38000.00	2026-02-28 19:30:26.297146	\N	ENTREGADO
521	202	10	Hamburguesa Sencilla	1.00	22000.00	11000.00	0.00	0.00	22000.00	2026-02-28 19:30:26.34646	\N	ENTREGADO
522	202	11	Especial	1.00	32000.00	14000.00	0.00	0.00	32000.00	2026-02-28 19:30:26.36989	\N	ENTREGADO
523	202	20	Papas al carbón mix	1.00	26000.00	13000.00	0.00	0.00	26000.00	2026-02-28 19:30:26.396508	\N	ENTREGADO
519	201	8	Mix de costilla, chicharrón y bondiola	1.00	38000.00	19000.00	0.00	0.00	38000.00	2026-02-28 19:14:21.150609	\N	ENTREGADO
554	210	20	Papas al carbón mix	2.00	26000.00	13000.00	0.00	0.00	52000.00	2026-02-28 21:52:39.326137	\N	ENTREGADO
515	199	51	3 Cordilleras	2.00	9000.00	7000.00	0.00	0.00	18000.00	2026-02-28 18:47:44.171504	\N	ENTREGADO
555	210	19	Papas al carbón supreme	1.00	25000.00	16000.00	0.00	0.00	25000.00	2026-02-28 21:52:39.351833	\N	ENTREGADO
556	210	21	Filete de Pechuga	1.00	26000.00	13000.00	0.00	0.00	26000.00	2026-02-28 21:52:39.375852	\N	ENTREGADO
563	211	23	Punta de Anca	2.00	38000.00	19000.00	0.00	0.00	76000.00	2026-02-28 21:53:57.076102	\N	ENTREGADO
524	196	76	Zanahoria	1.00	11500.00	7000.00	0.00	0.00	11500.00	2026-02-28 19:36:54.662357	\N	ENTREGADO
564	211	37	Cereza	2.00	10000.00	5000.00	0.00	0.00	20000.00	2026-02-28 21:53:57.106526	\N	ENTREGADO
569	213	19	Papas al carbón supreme	1.00	25000.00	16000.00	0.00	0.00	25000.00	2026-02-28 21:58:06.617888	\N	ENTREGADO
570	213	20	Papas al carbón mix	1.00	26000.00	13000.00	0.00	0.00	26000.00	2026-02-28 21:58:06.649617	\N	ENTREGADO
571	213	37	Cereza	1.00	10000.00	5000.00	0.00	0.00	10000.00	2026-02-28 21:58:06.661896	\N	ENTREGADO
525	203	19	Papas al carbón supreme	1.00	25000.00	16000.00	0.00	0.00	25000.00	2026-02-28 19:52:02.010424	\N	ENTREGADO
526	203	3	Chicharron	1.00	30000.00	15000.00	0.00	0.00	30000.00	2026-02-28 19:52:02.042803	\N	ENTREGADO
527	203	24	Arepa y queso Mozarella	1.00	4000.00	2000.00	0.00	0.00	4000.00	2026-02-28 19:53:08.008109	\N	ENTREGADO
572	213	35	Limonada de Coco	1.00	10000.00	5000.00	0.00	0.00	10000.00	2026-02-28 21:58:06.678056	\N	ENTREGADO
773	272	19	Papas al carbón supreme	1.00	25000.00	16000.00	0.00	0.00	25000.00	2026-03-07 20:47:01.374092	\N	ENTREGADO
577	216	23	Punta de Anca	1.00	38000.00	19000.00	0.00	0.00	38000.00	2026-02-28 22:54:00.813668	\N	ENTREGADO
528	204	3	Chicharron	1.00	30000.00	15000.00	0.00	0.00	30000.00	2026-02-28 20:10:17.739838	Casco, ajo rosada	ENTREGADO
529	204	23	Punta de Anca	1.00	38000.00	19000.00	0.00	0.00	38000.00	2026-02-28 20:10:17.775098	Francesa ajo,rosada	ENTREGADO
530	204	37	Cereza	1.00	10000.00	5000.00	0.00	0.00	10000.00	2026-02-28 20:10:17.794523	\N	ENTREGADO
531	204	35	Limonada de Coco	1.00	10000.00	5000.00	0.00	0.00	10000.00	2026-02-28 20:10:17.815634	\N	ENTREGADO
578	216	30	Lychee	1.00	10000.00	5000.00	0.00	0.00	10000.00	2026-02-28 22:54:00.829261	\N	ENTREGADO
579	216	21	Filete de Pechuga	1.00	26000.00	13000.00	0.00	0.00	26000.00	2026-02-28 22:54:00.85079	\N	ENTREGADO
580	216	35	Limonada de Coco	1.00	10000.00	5000.00	0.00	0.00	10000.00	2026-02-28 22:54:00.872972	\N	ENTREGADO
574	215	8	Mix de costilla, chicharrón y bondiola	2.00	38000.00	19000.00	0.00	0.00	76000.00	2026-02-28 22:46:46.925583	\N	ENTREGADO
532	205	3	Chicharron	1.00	30000.00	15000.00	0.00	0.00	30000.00	2026-02-28 20:36:19.561927	\N	ENTREGADO
533	205	22	Churrasco	1.00	36000.00	19000.00	0.00	0.00	36000.00	2026-02-28 20:36:19.594072	\N	ENTREGADO
535	205	83	Michelada	2.00	3000.00	1500.00	0.00	0.00	6000.00	2026-02-28 20:36:34.32773	\N	ENTREGADO
536	205	46	Aguila Light	4.00	6000.00	4000.00	0.00	0.00	24000.00	2026-02-28 20:37:19.267353	\N	ENTREGADO
537	205	25	Papas Francesas	1.00	8000.00	4000.00	0.00	0.00	8000.00	2026-02-28 20:50:45.667239	\N	ENTREGADO
575	215	27	Soda Michelada	1.00	8000.00	4000.00	0.00	0.00	8000.00	2026-02-28 22:46:46.94906	\N	ENTREGADO
576	215	34	Natural	1.00	9000.00	4500.00	0.00	0.00	9000.00	2026-02-28 22:46:46.964742	\N	ENTREGADO
774	272	43	Coca-cola	2.00	7000.00	3500.00	0.00	0.00	14000.00	2026-03-07 20:47:19.138121	\N	ENTREGADO
743	267	19	Papas al carbón supreme	1.00	25000.00	16000.00	0.00	0.00	25000.00	2026-03-07 19:40:08.440534	\N	ENTREGADO
744	267	59	Margarita	1.00	18000.00	12000.00	0.00	0.00	18000.00	2026-03-07 19:40:34.988268	\N	ENTREGADO
538	206	8	Mix de costilla, chicharrón y bondiola	1.00	38000.00	19000.00	0.00	0.00	38000.00	2026-02-28 21:05:28.336458	\N	ENTREGADO
539	206	2	Costilla	1.00	30000.00	15000.00	0.00	0.00	30000.00	2026-02-28 21:05:28.370014	\N	ENTREGADO
540	206	32	Jugos en leche	2.00	10000.00	5000.00	0.00	0.00	20000.00	2026-02-28 21:05:28.400638	\N	ENTREGADO
541	207	17	Nuggets	1.00	17000.00	8000.00	0.00	0.00	17000.00	2026-02-28 21:32:53.360877	\N	ENTREGADO
542	207	23	Punta de Anca	1.00	38000.00	19000.00	0.00	0.00	38000.00	2026-02-28 21:32:53.396935	\N	ENTREGADO
549	209	19	Papas al carbón supreme	1.00	25000.00	16000.00	0.00	0.00	25000.00	2026-02-28 21:50:14.117436	\N	ENTREGADO
550	209	9	Bondiola	1.00	29000.00	13000.00	0.00	0.00	29000.00	2026-02-28 21:50:14.182643	\N	ENTREGADO
551	209	27	Soda Michelada	2.00	8000.00	4000.00	0.00	0.00	16000.00	2026-02-28 21:50:14.205748	\N	ENTREGADO
566	212	18	Salchipapas	2.00	17000.00	9000.00	0.00	0.00	34000.00	2026-02-28 21:54:47.79618	\N	ENTREGADO
567	212	27	Soda Michelada	1.00	8000.00	4000.00	0.00	0.00	8000.00	2026-02-28 21:54:47.814036	\N	ENTREGADO
568	212	37	Cereza	1.00	10000.00	5000.00	0.00	0.00	10000.00	2026-02-28 21:54:47.830022	\N	ENTREGADO
543	207	8	Mix de costilla, chicharrón y bondiola	1.00	38000.00	19000.00	0.00	0.00	38000.00	2026-02-28 21:32:53.420525	\N	ENTREGADO
544	207	34	Natural	1.00	9000.00	4500.00	0.00	0.00	9000.00	2026-02-28 21:32:53.463988	\N	ENTREGADO
545	207	35	Limonada de Coco	1.00	10000.00	5000.00	0.00	0.00	10000.00	2026-02-28 21:32:53.495863	\N	ENTREGADO
772	272	78	Hamburguesa de chicharrón	1.00	32000.00	30000.00	0.00	0.00	32000.00	2026-03-07 20:46:45.115648	\N	ENTREGADO
770	272	3	Chicharron	2.00	30000.00	15000.00	0.00	0.00	60000.00	2026-03-07 20:46:28.030496	\N	ENTREGADO
581	217	3	Chicharron	1.00	30000.00	15000.00	0.00	0.00	30000.00	2026-02-28 23:02:59.353997	\N	ENTREGADO
952	321	66	capuchino	3.00	7500.00	4500.00	0.00	0.00	22500.00	2026-03-08 23:00:45.592969	\N	ENTREGADO
963	327	74	Frappe Baileys	1.00	15000.00	6000.00	0.00	0.00	15000.00	2026-03-09 21:38:48.890855	\N	ENTREGADO
964	327	75	Chocolate	1.00	11500.00	7000.00	0.00	0.00	11500.00	2026-03-09 21:38:48.903873	\N	ENTREGADO
965	328	8	Mix de costilla, chicharrón y bondiola	1.00	38000.00	19000.00	0.00	0.00	38000.00	2026-03-09 21:44:22.989709	\N	ENTREGADO
586	219	37	Cereza	1.00	10000.00	5000.00	0.00	0.00	10000.00	2026-02-28 23:29:59.117842	\N	ENTREGADO
583	218	19	Papas al carbón supreme	1.00	25000.00	16000.00	0.00	0.00	25000.00	2026-02-28 23:20:47.34017	\N	ENTREGADO
584	218	20	Papas al carbón mix	1.00	26000.00	13000.00	0.00	0.00	26000.00	2026-02-28 23:20:47.391054	\N	ENTREGADO
585	218	31	Jugos en agua	2.00	8000.00	4000.00	0.00	0.00	16000.00	2026-02-28 23:20:47.421267	\N	ENTREGADO
786	276	70	Café Frappe	1.00	7800.00	4000.00	0.00	0.00	7800.00	2026-03-07 22:09:31.208252	\N	ENTREGADO
966	328	2	Costilla	1.00	30000.00	15000.00	0.00	0.00	30000.00	2026-03-09 21:44:22.999502	\N	ENTREGADO
788	277	20	Papas al carbón mix	3.00	26000.00	13000.00	0.00	0.00	78000.00	2026-03-07 22:24:07.36348	\N	ENTREGADO
789	277	8	Mix de costilla, chicharrón y bondiola	1.00	38000.00	19000.00	0.00	0.00	38000.00	2026-03-07 22:24:17.283111	\N	ENTREGADO
790	277	27	Soda Michelada	1.00	8000.00	4000.00	0.00	0.00	8000.00	2026-03-07 22:24:40.319733	\N	ENTREGADO
591	221	3	Chicharron	1.00	30000.00	15000.00	0.00	0.00	30000.00	2026-03-01 19:20:56.464767	\N	ENTREGADO
587	220	75	Chocolate	1.00	11500.00	7000.00	0.00	0.00	11500.00	2026-03-01 18:41:06.929664	\N	ENTREGADO
588	220	70	Café Frappe	1.00	7800.00	4000.00	0.00	0.00	7800.00	2026-03-01 18:41:07.088951	\N	ENTREGADO
589	220	23	Punta de Anca	1.00	38000.00	19000.00	0.00	0.00	38000.00	2026-03-01 18:41:07.21483	Termino tres cuartos, francesa., rosada 	ENTREGADO
590	220	34	Natural	1.00	9000.00	4500.00	0.00	0.00	9000.00	2026-03-01 18:41:07.379482	\N	ENTREGADO
791	277	37	Cereza	1.00	10000.00	5000.00	0.00	0.00	10000.00	2026-03-07 22:24:50.010219	\N	ENTREGADO
778	274	20	Papas al carbón mix	1.00	26000.00	13000.00	0.00	0.00	26000.00	2026-03-07 21:48:20.385238	\N	ENTREGADO
779	274	19	Papas al carbón supreme	1.00	25000.00	16000.00	0.00	0.00	25000.00	2026-03-07 21:48:20.403235	\N	ENTREGADO
780	274	35	Limonada de Coco	2.00	10000.00	5000.00	0.00	0.00	20000.00	2026-03-07 21:48:33.652967	\N	ENTREGADO
592	222	15	Sandwich	1.00	25000.00	16000.00	0.00	0.00	25000.00	2026-03-01 19:23:22.442583	Rosada y maiz	ENTREGADO
593	222	7	Ceviche de chicharron	1.00	25000.00	17000.00	0.00	0.00	25000.00	2026-03-01 19:23:22.565818	\N	ENTREGADO
594	222	57	Copa de Sangria	1.00	16000.00	12000.00	0.00	0.00	16000.00	2026-03-01 19:23:22.693519	\N	ENTREGADO
595	222	35	Limonada de Coco	1.00	10000.00	5000.00	0.00	0.00	10000.00	2026-03-01 19:23:22.764414	\N	ENTREGADO
613	226	19	Papas al carbón supreme	1.00	25000.00	16000.00	0.00	0.00	25000.00	2026-03-01 19:56:32.808492	\N	ENTREGADO
608	225	47	Aguila	2.00	7000.00	4000.00	0.00	0.00	14000.00	2026-03-01 19:53:14.979291	\N	ENTREGADO
609	225	32	Jugos en leche	1.00	10000.00	5000.00	0.00	0.00	10000.00	2026-03-01 19:53:15.023399	\N	ENTREGADO
610	225	70	Café Frappe	1.00	7800.00	4000.00	0.00	0.00	7800.00	2026-03-01 19:53:15.042406	\N	ENTREGADO
611	225	35	Limonada de Coco	1.00	10000.00	5000.00	0.00	0.00	10000.00	2026-03-01 19:53:15.070945	\N	ENTREGADO
612	225	43	Coca-cola	1.00	7000.00	3500.00	0.00	0.00	7000.00	2026-03-01 19:53:15.093386	\N	ENTREGADO
622	225	84	Picada especial	1.00	85000.00	45000.00	0.00	0.00	85000.00	2026-03-01 20:25:22.792935	\N	ENTREGADO
616	227	10	Hamburguesa Sencilla	1.00	22000.00	11000.00	0.00	0.00	22000.00	2026-03-01 20:11:57.0575	\N	ENTREGADO
614	226	21	Filete de Pechuga	1.00	26000.00	13000.00	0.00	0.00	26000.00	2026-03-01 19:56:32.849808	\N	ENTREGADO
615	226	31	Jugos en agua	2.00	8000.00	4000.00	0.00	0.00	16000.00	2026-03-01 19:56:32.874963	\N	ENTREGADO
617	228	2	Costilla	1.00	30000.00	15000.00	0.00	0.00	30000.00	2026-03-01 20:18:11.028537	Casco, rosada ajo, chimichurri 	ENTREGADO
618	228	31	Jugos en agua	1.00	8000.00	4000.00	0.00	0.00	8000.00	2026-03-01 20:18:11.069724	Mango	ENTREGADO
619	228	23	Punta de Anca	1.00	38000.00	19000.00	0.00	0.00	38000.00	2026-03-01 20:18:11.101501	Francesa ajo, rosada,chimichurri 	ENTREGADO
620	228	52	Corona	1.00	9000.00	7000.00	0.00	0.00	9000.00	2026-03-01 20:18:11.130227	Michelada	ENTREGADO
621	228	83	Michelada	1.00	3000.00	1500.00	0.00	0.00	3000.00	2026-03-01 20:18:11.150519	\N	ENTREGADO
623	229	3	Chicharron	1.00	30000.00	15000.00	0.00	0.00	30000.00	2026-03-01 20:32:53.894329	\N	ENTREGADO
624	229	30	Lychee	1.00	10000.00	5000.00	0.00	0.00	10000.00	2026-03-01 20:32:53.957931	\N	ENTREGADO
625	229	73	Frappe Amaretto	1.00	13000.00	6000.00	0.00	0.00	13000.00	2026-03-01 20:32:53.981322	\N	ENTREGADO
626	229	4	Entradas	1.00	10000.00	4000.00	0.00	0.00	10000.00	2026-03-01 20:32:54.004207	\N	ENTREGADO
627	229	21	Filete de Pechuga	1.00	26000.00	13000.00	0.00	0.00	26000.00	2026-03-01 20:32:54.025614	\N	ENTREGADO
630	231	79	1 Entradas Patacones-1 hamb sencilla-1 papas mix- 2 gaseosas	1.00	59000.00	40000.00	0.00	0.00	59000.00	2026-03-01 20:52:22.181943	\N	ENTREGADO
640	232	66	capuchino	2.00	7500.00	4500.00	0.00	0.00	15000.00	2026-03-01 21:56:10.014949	\N	ENTREGADO
641	233	20	Papas al carbón mix	1.00	26000.00	13000.00	0.00	0.00	26000.00	2026-03-01 22:02:49.806123	Rosada bbq	ENTREGADO
642	233	32	Jugos en leche	2.00	10000.00	5000.00	0.00	0.00	20000.00	2026-03-01 22:02:49.848973	Guanabana, maracuyá	ENTREGADO
596	223	5	Picadita De La Casa	1.00	25000.00	15000.00	0.00	0.00	25000.00	2026-03-01 19:23:27.333962	\N	ENTREGADO
597	223	43	Coca-cola	3.00	7000.00	3500.00	0.00	0.00	21000.00	2026-03-01 19:23:27.501129	\N	ENTREGADO
951	321	76	Zanahoria	2.00	11500.00	7000.00	0.00	0.00	23000.00	2026-03-08 23:00:45.570014	\N	ENTREGADO
967	330	48	Pilsen	1.00	7000.00	4000.00	0.00	0.00	7000.00	2026-03-09 23:20:02.162402	\N	ENTREGADO
629	230	18	Salchipapas	1.00	17000.00	9000.00	0.00	0.00	17000.00	2026-03-01 20:40:55.020596	\N	ENTREGADO
631	230	43	Coca-cola	1.00	7000.00	3500.00	0.00	0.00	7000.00	2026-03-01 20:54:37.84514	\N	ENTREGADO
645	230	45	Premio	1.00	7000.00	3500.00	0.00	0.00	7000.00	2026-03-01 22:16:40.07166	\N	ENTREGADO
643	233	21	Filete de Pechuga	1.00	26000.00	13000.00	0.00	0.00	26000.00	2026-03-01 22:02:49.8782	Francesas	ENTREGADO
644	233	6	Patacones	1.00	12000.00	4500.00	0.00	0.00	12000.00	2026-03-01 22:05:16.647229	\N	ENTREGADO
598	223	65	Aromática frutos secos	2.00	7000.00	4500.00	0.00	0.00	14000.00	2026-03-01 19:23:27.587075	\N	ENTREGADO
599	223	32	Jugos en leche	1.00	10000.00	5000.00	0.00	0.00	10000.00	2026-03-01 19:23:27.64752	\N	ENTREGADO
600	223	45	Premio	1.00	7000.00	3500.00	0.00	0.00	7000.00	2026-03-01 19:23:48.247459	\N	ENTREGADO
601	223	77	Red Velvet	1.00	11500.00	7000.00	0.00	0.00	11500.00	2026-03-01 19:40:25.795902	\N	ENTREGADO
602	223	75	Chocolate	2.00	11500.00	7000.00	0.00	0.00	23000.00	2026-03-01 19:40:25.865928	\N	ENTREGADO
628	223	44	Quatro	1.00	7000.00	3500.00	0.00	0.00	7000.00	2026-03-01 20:36:56.959803	\N	ENTREGADO
632	223	19	Papas al carbón supreme	5.00	25000.00	16000.00	0.00	0.00	125000.00	2026-03-01 21:03:53.482685	\N	ENTREGADO
633	223	35	Limonada de Coco	2.00	10000.00	5000.00	0.00	0.00	20000.00	2026-03-01 21:03:53.563301	\N	ENTREGADO
634	223	8	Mix de costilla, chicharrón y bondiola	1.00	38000.00	19000.00	0.00	0.00	38000.00	2026-03-01 21:03:53.599033	\N	ENTREGADO
635	223	62	Jarra de Sangria	1.00	60000.00	30000.00	0.00	0.00	60000.00	2026-03-01 21:03:53.666106	\N	ENTREGADO
636	223	3	Chicharron	1.00	30000.00	15000.00	0.00	0.00	30000.00	2026-03-01 21:03:53.690687	\N	ENTREGADO
637	223	20	Papas al carbón mix	1.00	26000.00	13000.00	0.00	0.00	26000.00	2026-03-01 21:03:53.743508	\N	ENTREGADO
638	223	18	Salchipapas	1.00	17000.00	9000.00	0.00	0.00	17000.00	2026-03-01 21:04:52.423591	\N	ENTREGADO
639	223	78	Hamburguesa de chicharrón	1.00	32000.00	30000.00	0.00	0.00	32000.00	2026-03-01 21:49:44.807872	\N	ENTREGADO
646	223	76	Zanahoria	2.00	11500.00	7000.00	0.00	0.00	23000.00	2026-03-01 22:32:24.133893	\N	ENTREGADO
650	235	66	capuchino	2.00	7500.00	4500.00	0.00	0.00	15000.00	2026-03-01 23:38:39.80719	\N	ENTREGADO
651	235	63	Americano	1.00	5500.00	3000.00	0.00	0.00	5500.00	2026-03-01 23:38:39.837193	\N	ENTREGADO
647	234	77	Red Velvet	1.00	11500.00	7000.00	0.00	0.00	11500.00	2026-03-01 23:02:39.639823	\N	ENTREGADO
648	234	76	Zanahoria	1.00	11500.00	7000.00	0.00	0.00	11500.00	2026-03-01 23:02:39.675888	\N	ENTREGADO
649	234	66	capuchino	3.00	7500.00	4500.00	0.00	0.00	22500.00	2026-03-01 23:02:39.696107	\N	ENTREGADO
652	236	50	Club Colombia	1.00	8000.00	6000.00	0.00	0.00	8000.00	2026-03-02 18:05:18.347593	\N	ENTREGADO
653	236	46	Aguila Light	1.00	6000.00	4000.00	0.00	0.00	6000.00	2026-03-02 18:05:18.366423	\N	ENTREGADO
654	237	46	Aguila Light	1.00	6000.00	4000.00	0.00	0.00	6000.00	2026-03-02 18:05:52.065486	\N	ENTREGADO
655	237	50	Club Colombia	1.00	8000.00	6000.00	0.00	0.00	8000.00	2026-03-02 18:05:52.079518	\N	ENTREGADO
659	239	35	Limonada de Coco	1.00	10000.00	5000.00	0.00	0.00	10000.00	2026-03-02 19:46:57.239399	\N	ENTREGADO
660	240	74	Frappe Baileys	1.00	15000.00	6000.00	0.00	0.00	15000.00	2026-03-02 19:49:28.178316	\N	ENTREGADO
657	238	10	Hamburguesa Sencilla	4.00	22000.00	11000.00	0.00	0.00	88000.00	2026-03-02 18:57:56.405616	\N	ENTREGADO
658	238	21	Filete de Pechuga	1.00	26000.00	13000.00	0.00	0.00	26000.00	2026-03-02 18:58:16.074276	\N	ENTREGADO
665	242	74	Frappe Baileys	1.00	15000.00	6000.00	0.00	0.00	15000.00	2026-03-02 21:13:59.639628	\N	ENTREGADO
672	245	43	Coca-cola	1.00	7000.00	3500.00	0.00	0.00	7000.00	2026-03-02 21:33:33.885266	\N	ENTREGADO
673	245	79	1 Entradas Patacones-1 hamb sencilla-1 papas mix- 2 gaseosas	1.00	59000.00	40000.00	0.00	0.00	59000.00	2026-03-02 21:33:33.910435	\N	ENTREGADO
674	245	14	Argentina	1.00	30000.00	15000.00	0.00	0.00	30000.00	2026-03-02 21:33:33.928529	\N	ENTREGADO
679	247	85	AGUA	1.00	4000.00	2000.00	0.00	0.00	4000.00	2026-03-02 21:46:10.744982	\N	ENTREGADO
680	247	79	1 Entradas Patacones-1 hamb sencilla-1 papas mix- 2 gaseosas	1.00	59000.00	40000.00	0.00	0.00	59000.00	2026-03-02 21:46:10.763695	\N	ENTREGADO
681	247	14	Argentina	1.00	30000.00	15000.00	0.00	0.00	30000.00	2026-03-02 21:46:10.78166	\N	ENTREGADO
682	247	43	Coca-cola	1.00	7000.00	3500.00	0.00	0.00	7000.00	2026-03-02 21:46:10.792211	\N	ENTREGADO
661	241	8	Mix de costilla, chicharrón y bondiola	1.00	38000.00	19000.00	0.00	0.00	38000.00	2026-03-02 20:49:59.082688	Casco	ENTREGADO
662	241	7	Ceviche de chicharron	1.00	25000.00	17000.00	0.00	0.00	25000.00	2026-03-02 20:49:59.122517	\N	ENTREGADO
663	241	36	Hierbabuena	1.00	10000.00	5000.00	0.00	0.00	10000.00	2026-03-02 20:49:59.143117	\N	ENTREGADO
664	241	82	SODA CEREZA	1.00	10000.00	5000.00	0.00	0.00	10000.00	2026-03-02 20:49:59.159511	\N	ENTREGADO
666	243	35	Limonada de Coco	1.00	10000.00	5000.00	0.00	0.00	10000.00	2026-03-02 21:26:25.186917	\N	ENTREGADO
667	243	8	Mix de costilla, chicharrón y bondiola	1.00	38000.00	19000.00	0.00	0.00	38000.00	2026-03-02 21:26:44.847719	\N	ENTREGADO
668	244	7	Ceviche de chicharron	1.00	25000.00	17000.00	0.00	0.00	25000.00	2026-03-02 21:28:49.575249	\N	ENTREGADO
669	244	11	Especial	1.00	32000.00	14000.00	0.00	0.00	32000.00	2026-03-02 21:29:27.940882	\N	ENTREGADO
670	244	51	3 Cordilleras	1.00	9000.00	7000.00	0.00	0.00	9000.00	2026-03-02 21:30:46.537717	\N	ENTREGADO
671	244	57	Copa de Sangria	1.00	16000.00	12000.00	0.00	0.00	16000.00	2026-03-02 21:30:46.559544	\N	ENTREGADO
683	244	66	capuchino	1.00	7500.00	4500.00	0.00	0.00	7500.00	2026-03-02 21:47:58.808585	\N	ENTREGADO
691	249	65	Aromática frutos secos	1.00	7000.00	4500.00	0.00	0.00	7000.00	2026-03-04 18:14:24.301022	\N	ENTREGADO
692	249	15	Sandwich	1.00	25000.00	16000.00	0.00	0.00	25000.00	2026-03-04 18:14:49.608982	\N	ENTREGADO
693	249	86	LATTE	1.00	10000.00	5000.00	0.00	0.00	10000.00	2026-03-04 18:50:22.035162	\N	ENTREGADO
694	249	77	Red Velvet	1.00	11500.00	7000.00	0.00	0.00	11500.00	2026-03-04 18:50:38.658392	\N	ENTREGADO
695	250	20	Papas al carbón mix	1.00	26000.00	13000.00	0.00	0.00	26000.00	2026-03-04 19:28:44.504233	\N	ENTREGADO
697	252	2	Costilla	1.00	30000.00	15000.00	0.00	0.00	30000.00	2026-03-04 20:04:29.175741	\N	ENTREGADO
775	273	23	Punta de Anca	1.00	38000.00	19000.00	0.00	0.00	38000.00	2026-03-07 21:09:06.344066	\N	ENTREGADO
776	273	20	Papas al carbón mix	1.00	26000.00	13000.00	0.00	0.00	26000.00	2026-03-07 21:09:15.837763	\N	ENTREGADO
783	276	20	Papas al carbón mix	1.00	26000.00	13000.00	0.00	0.00	26000.00	2026-03-07 22:08:50.99823	\N	ENTREGADO
696	251	79	1 Entradas Patacones-1 hamb sencilla-1 papas mix- 2 gaseosas	1.00	59000.00	40000.00	0.00	0.00	59000.00	2026-03-04 19:46:32.147752	\N	ENTREGADO
954	323	19	Papas al carbón supreme	3.00	25000.00	16000.00	0.00	0.00	75000.00	2026-03-09 20:33:27.883402	\N	ENTREGADO
955	323	45	Premio	1.00	7000.00	3500.00	0.00	0.00	7000.00	2026-03-09 20:33:27.906344	\N	ENTREGADO
956	323	35	Limonada de Coco	2.00	10000.00	5000.00	0.00	0.00	20000.00	2026-03-09 20:33:27.923114	\N	ENTREGADO
698	252	19	Papas al carbón supreme	1.00	25000.00	16000.00	0.00	0.00	25000.00	2026-03-04 20:04:29.22876	\N	ENTREGADO
699	252	36	Hierbabuena	1.00	10000.00	5000.00	0.00	0.00	10000.00	2026-03-04 20:04:29.264826	\N	ENTREGADO
700	252	81	SODA	1.00	5000.00	2500.00	0.00	0.00	5000.00	2026-03-04 20:04:29.286672	\N	ENTREGADO
701	252	83	Michelada	1.00	3000.00	1500.00	0.00	0.00	3000.00	2026-03-04 20:04:29.310854	\N	ENTREGADO
702	252	6	Patacones	1.00	12000.00	4500.00	0.00	0.00	12000.00	2026-03-04 20:04:29.333851	\N	ENTREGADO
703	253	8	Mix de costilla, chicharrón y bondiola	1.00	38000.00	19000.00	0.00	0.00	38000.00	2026-03-04 20:43:25.073214	\N	ENTREGADO
704	253	10	Hamburguesa Sencilla	1.00	22000.00	11000.00	0.00	0.00	22000.00	2026-03-04 20:43:25.10675	\N	ENTREGADO
705	253	82	SODA CEREZA	1.00	10000.00	5000.00	0.00	0.00	10000.00	2026-03-04 20:43:25.128161	\N	ENTREGADO
706	253	37	Cereza	1.00	10000.00	5000.00	0.00	0.00	10000.00	2026-03-04 20:43:25.150474	\N	ENTREGADO
707	253	7	Ceviche de chicharron	1.00	25000.00	17000.00	0.00	0.00	25000.00	2026-03-04 20:43:25.170649	\N	ENTREGADO
708	254	77	Red Velvet	2.00	11500.00	7000.00	0.00	0.00	23000.00	2026-03-04 22:21:58.994371	\N	ENTREGADO
709	255	21	Filete de Pechuga	1.00	26000.00	13000.00	0.00	0.00	26000.00	2026-03-05 19:02:12.921974	\N	ENTREGADO
953	322	79	1 Entradas Patacones-1 hamb sencilla-1 papas mix- 2 gaseosas	2.00	59000.00	40000.00	0.00	0.00	118000.00	2026-03-09 20:32:51.920899	\N	ENTREGADO
968	331	48	Pilsen	1.00	7000.00	4000.00	0.00	0.00	7000.00	2026-03-09 23:36:30.018396	\N	ENTREGADO
710	256	3	Chicharron	1.00	30000.00	15000.00	0.00	0.00	30000.00	2026-03-05 19:52:29.297016	\N	ENTREGADO
711	256	6	Patacones	1.00	12000.00	4500.00	0.00	0.00	12000.00	2026-03-05 19:52:29.363394	\N	ENTREGADO
712	256	20	Papas al carbón mix	1.00	26000.00	13000.00	0.00	0.00	26000.00	2026-03-05 19:52:29.390989	\N	ENTREGADO
713	256	35	Limonada de Coco	1.00	10000.00	5000.00	0.00	0.00	10000.00	2026-03-05 19:52:29.418909	\N	ENTREGADO
714	256	34	Natural	1.00	9000.00	4500.00	0.00	0.00	9000.00	2026-03-05 19:52:29.443366	\N	ENTREGADO
715	257	37	Cereza	1.00	10000.00	5000.00	0.00	0.00	10000.00	2026-03-06 20:06:04.292787	\N	ENTREGADO
716	257	20	Papas al carbón mix	1.00	26000.00	13000.00	0.00	0.00	26000.00	2026-03-06 20:06:04.318574	\N	ENTREGADO
717	258	70	Café Frappe	1.00	7800.00	4000.00	0.00	0.00	7800.00	2026-03-06 20:28:00.812352	\N	ENTREGADO
718	259	77	Red Velvet	1.00	11500.00	7000.00	0.00	0.00	11500.00	2026-03-06 23:03:13.393635	\N	ENTREGADO
719	259	20	Papas al carbón mix	1.00	26000.00	13000.00	0.00	0.00	26000.00	2026-03-06 23:03:13.420914	\N	ENTREGADO
720	260	20	Papas al carbón mix	1.00	26000.00	13000.00	0.00	0.00	26000.00	2026-03-06 23:03:59.945917	\N	ENTREGADO
721	261	78	Hamburguesa de chicharrón	1.00	32000.00	30000.00	0.00	0.00	32000.00	2026-03-07 18:15:00.747332	\N	ENTREGADO
722	261	11	Especial	1.00	32000.00	14000.00	0.00	0.00	32000.00	2026-03-07 18:15:00.766884	\N	ENTREGADO
723	261	20	Papas al carbón mix	1.00	26000.00	13000.00	0.00	0.00	26000.00	2026-03-07 18:15:00.818699	\N	ENTREGADO
731	264	80	Picada Grande	1.00	65000.00	35000.00	0.00	0.00	65000.00	2026-03-07 19:05:20.457279	\N	ENTREGADO
724	262	78	Hamburguesa de chicharrón	1.00	32000.00	30000.00	0.00	0.00	32000.00	2026-03-07 18:58:49.648469	\N	ENTREGADO
725	262	11	Especial	1.00	32000.00	14000.00	0.00	0.00	32000.00	2026-03-07 18:58:49.681859	\N	ENTREGADO
733	266	78	Hamburguesa de chicharrón	1.00	32000.00	30000.00	0.00	0.00	32000.00	2026-03-07 19:32:01.849973	\N	ENTREGADO
734	266	36	Hierbabuena	1.00	10000.00	5000.00	0.00	0.00	10000.00	2026-03-07 19:32:35.983036	\N	ENTREGADO
735	266	49	Heineken	1.00	8000.00	6000.00	0.00	0.00	8000.00	2026-03-07 19:33:24.170673	\N	ENTREGADO
736	266	20	Papas al carbón mix	2.00	26000.00	13000.00	0.00	0.00	52000.00	2026-03-07 19:36:12.324041	\N	ENTREGADO
737	266	28	Soda Maracuya	1.00	10000.00	5000.00	0.00	0.00	10000.00	2026-03-07 19:38:29.684389	\N	ENTREGADO
738	266	44	Quatro	1.00	7000.00	3500.00	0.00	0.00	7000.00	2026-03-07 19:38:46.669708	\N	ENTREGADO
739	266	22	Churrasco	1.00	36000.00	19000.00	0.00	0.00	36000.00	2026-03-07 19:38:56.882606	\N	ENTREGADO
740	266	29	Cereza	1.00	10000.00	5000.00	0.00	0.00	10000.00	2026-03-07 19:39:10.818753	\N	ENTREGADO
741	266	8	Mix de costilla, chicharrón y bondiola	1.00	38000.00	19000.00	0.00	0.00	38000.00	2026-03-07 19:39:23.077773	\N	ENTREGADO
763	271	22	Churrasco	2.00	36000.00	19000.00	0.00	0.00	72000.00	2026-03-07 20:29:32.280123	\N	ENTREGADO
764	271	17	Nuggets	1.00	17000.00	8000.00	0.00	0.00	17000.00	2026-03-07 20:29:46.154649	\N	ENTREGADO
765	271	23	Punta de Anca	1.00	38000.00	19000.00	0.00	0.00	38000.00	2026-03-07 20:29:58.246237	\N	ENTREGADO
766	271	11	Especial	1.00	32000.00	14000.00	0.00	0.00	32000.00	2026-03-07 20:30:10.327985	\N	ENTREGADO
767	271	8	Mix de costilla, chicharrón y bondiola	1.00	38000.00	19000.00	0.00	0.00	38000.00	2026-03-07 20:30:30.120834	\N	ENTREGADO
757	269	8	Mix de costilla, chicharrón y bondiola	1.00	38000.00	19000.00	0.00	0.00	38000.00	2026-03-07 19:52:47.186626	\N	ENTREGADO
758	269	17	Nuggets	1.00	17000.00	8000.00	0.00	0.00	17000.00	2026-03-07 19:52:55.289566	\N	ENTREGADO
759	269	23	Punta de Anca	1.00	38000.00	19000.00	0.00	0.00	38000.00	2026-03-07 19:53:06.076916	\N	ENTREGADO
760	269	11	Especial	1.00	32000.00	14000.00	0.00	0.00	32000.00	2026-03-07 19:53:20.002753	\N	ENTREGADO
761	269	35	Limonada de Coco	1.00	10000.00	5000.00	0.00	0.00	10000.00	2026-03-07 19:53:35.696171	\N	ENTREGADO
769	271	35	Limonada de Coco	1.00	10000.00	5000.00	0.00	0.00	10000.00	2026-03-07 20:43:42.697615	\N	ENTREGADO
762	270	78	Hamburguesa de chicharrón	1.00	32000.00	30000.00	0.00	0.00	32000.00	2026-03-07 20:03:57.782738	\N	ENTREGADO
957	324	35	Limonada de Coco	1.00	10000.00	5000.00	0.00	0.00	10000.00	2026-03-09 20:34:37.537202	\N	ENTREGADO
958	324	36	Hierbabuena	1.00	10000.00	5000.00	0.00	0.00	10000.00	2026-03-09 20:34:37.557489	\N	ENTREGADO
959	324	8	Mix de costilla, chicharrón y bondiola	1.00	38000.00	19000.00	0.00	0.00	38000.00	2026-03-09 20:34:37.576342	\N	ENTREGADO
745	267	48	Pilsen	2.00	7000.00	4000.00	0.00	0.00	14000.00	2026-03-07 19:40:47.562291	\N	ENTREGADO
777	267	63	Americano	2.00	5500.00	3000.00	0.00	0.00	11000.00	2026-03-07 21:27:42.29237	\N	ENTREGADO
785	276	15	Sandwich	1.00	25000.00	16000.00	0.00	0.00	25000.00	2026-03-07 22:09:08.947698	\N	ENTREGADO
784	276	30	Lychee	1.00	10000.00	5000.00	0.00	0.00	10000.00	2026-03-07 22:08:59.266684	\N	ENTREGADO
792	277	43	Coca-cola	1.00	7000.00	3500.00	0.00	0.00	7000.00	2026-03-07 22:24:57.768473	\N	ENTREGADO
793	278	3	Chicharron	1.00	30000.00	15000.00	0.00	0.00	30000.00	2026-03-07 22:27:28.876362	\N	ENTREGADO
794	274	28	Soda Maracuya	1.00	10000.00	5000.00	0.00	0.00	10000.00	2026-03-07 22:31:31.018365	\N	ENTREGADO
796	280	21	Filete de Pechuga	1.00	26000.00	13000.00	0.00	0.00	26000.00	2026-03-07 22:34:46.49122	\N	ENTREGADO
797	280	43	Coca-cola	1.00	7000.00	3500.00	0.00	0.00	7000.00	2026-03-07 22:34:52.756248	\N	ENTREGADO
795	279	79	1 Entradas Patacones-1 hamb sencilla-1 papas mix- 2 gaseosas	2.00	59000.00	40000.00	0.00	0.00	118000.00	2026-03-07 22:32:54.009004	\N	ENTREGADO
798	281	20	Papas al carbón mix	1.00	26000.00	13000.00	0.00	0.00	26000.00	2026-03-07 22:39:07.873476	\N	ENTREGADO
799	281	45	Premio	1.00	7000.00	3500.00	0.00	0.00	7000.00	2026-03-07 22:39:15.923641	\N	ENTREGADO
800	282	19	Papas al carbón supreme	1.00	25000.00	16000.00	0.00	0.00	25000.00	2026-03-07 22:41:16.933151	\N	ENTREGADO
801	282	43	Coca-cola	2.00	7000.00	3500.00	0.00	0.00	14000.00	2026-03-07 22:41:24.251376	\N	ENTREGADO
802	282	35	Limonada de Coco	1.00	10000.00	5000.00	0.00	0.00	10000.00	2026-03-07 22:41:36.604999	\N	ENTREGADO
803	283	20	Papas al carbón mix	1.00	26000.00	13000.00	0.00	0.00	26000.00	2026-03-07 22:43:03.770722	\N	ENTREGADO
804	283	43	Coca-cola	2.00	7000.00	3500.00	0.00	0.00	14000.00	2026-03-07 22:43:11.050928	\N	ENTREGADO
805	283	23	Punta de Anca	1.00	38000.00	19000.00	0.00	0.00	38000.00	2026-03-07 22:43:25.004658	\N	ENTREGADO
806	283	35	Limonada de Coco	2.00	10000.00	5000.00	0.00	0.00	20000.00	2026-03-07 22:43:37.54715	\N	ENTREGADO
807	283	50	Club Colombia	1.00	8000.00	6000.00	0.00	0.00	8000.00	2026-03-07 22:43:47.57296	\N	ENTREGADO
808	284	8	Mix de costilla, chicharrón y bondiola	1.00	38000.00	19000.00	0.00	0.00	38000.00	2026-03-07 22:44:44.861649	\N	ENTREGADO
809	284	27	Soda Michelada	1.00	8000.00	4000.00	0.00	0.00	8000.00	2026-03-07 22:45:30.935228	\N	ENTREGADO
810	284	37	Cereza	1.00	10000.00	5000.00	0.00	0.00	10000.00	2026-03-07 22:45:40.713043	\N	ENTREGADO
811	285	20	Papas al carbón mix	1.00	26000.00	13000.00	0.00	0.00	26000.00	2026-03-07 22:46:19.470717	\N	ENTREGADO
812	285	38	Limonada de vino	1.00	12000.00	6000.00	0.00	0.00	12000.00	2026-03-07 22:46:37.176215	\N	ENTREGADO
813	285	47	Aguila	1.00	7000.00	4000.00	0.00	0.00	7000.00	2026-03-07 22:46:55.775267	\N	ENTREGADO
821	288	2	Costilla	1.00	30000.00	15000.00	0.00	0.00	30000.00	2026-03-07 22:56:12.058579	\N	ENTREGADO
822	288	51	3 Cordilleras	2.00	9000.00	7000.00	0.00	0.00	18000.00	2026-03-07 22:56:28.341302	\N	ENTREGADO
823	288	56	Copa vino	1.00	12000.00	9000.00	0.00	0.00	12000.00	2026-03-07 22:56:39.598214	\N	ENTREGADO
824	288	44	Quatro	1.00	7000.00	3500.00	0.00	0.00	7000.00	2026-03-07 22:56:53.081867	\N	ENTREGADO
814	286	47	Aguila	2.00	7000.00	4000.00	0.00	0.00	14000.00	2026-03-07 22:51:56.642708	\N	ENTREGADO
815	286	83	Michelada	1.00	3000.00	1500.00	0.00	0.00	3000.00	2026-03-07 22:51:56.65629	\N	ENTREGADO
816	286	8	Mix de costilla, chicharrón y bondiola	1.00	38000.00	19000.00	0.00	0.00	38000.00	2026-03-07 22:52:04.004579	\N	ENTREGADO
820	287	83	Michelada	1.00	3000.00	1500.00	0.00	0.00	3000.00	2026-03-07 22:53:54.162367	\N	ENTREGADO
817	287	19	Papas al carbón supreme	1.00	25000.00	16000.00	0.00	0.00	25000.00	2026-03-07 22:53:08.12726	\N	ENTREGADO
818	287	59	Margarita	1.00	18000.00	12000.00	0.00	0.00	18000.00	2026-03-07 22:53:25.675954	\N	ENTREGADO
819	287	48	Pilsen	1.00	7000.00	4000.00	0.00	0.00	7000.00	2026-03-07 22:53:41.82546	\N	ENTREGADO
827	275	4	Entradas	1.00	10000.00	4000.00	0.00	0.00	10000.00	2026-03-07 23:10:03.641136	\N	ENTREGADO
828	275	3	Chicharron	1.00	30000.00	15000.00	0.00	0.00	30000.00	2026-03-07 23:10:09.001943	\N	ENTREGADO
829	275	2	Costilla	1.00	30000.00	15000.00	0.00	0.00	30000.00	2026-03-07 23:10:15.981924	\N	ENTREGADO
830	275	35	Limonada de Coco	1.00	10000.00	5000.00	0.00	0.00	10000.00	2026-03-07 23:10:25.312129	\N	ENTREGADO
831	275	38	Limonada de vino	1.00	12000.00	6000.00	0.00	0.00	12000.00	2026-03-07 23:10:36.46493	\N	ENTREGADO
960	324	22	Churrasco	1.00	36000.00	19000.00	0.00	0.00	36000.00	2026-03-09 20:34:37.601623	\N	ENTREGADO
832	290	20	Papas al carbón mix	1.00	26000.00	13000.00	0.00	0.00	26000.00	2026-03-07 23:16:53.920639	\N	ENTREGADO
833	290	2	Costilla	1.00	30000.00	15000.00	0.00	0.00	30000.00	2026-03-07 23:17:03.456739	\N	ENTREGADO
834	290	59	Margarita	2.00	18000.00	12000.00	0.00	0.00	36000.00	2026-03-07 23:17:22.673416	\N	ENTREGADO
835	290	47	Aguila	2.00	7000.00	4000.00	0.00	0.00	14000.00	2026-03-07 23:17:37.484095	\N	ENTREGADO
836	290	23	Punta de Anca	1.00	38000.00	19000.00	0.00	0.00	38000.00	2026-03-07 23:17:58.808852	\N	ENTREGADO
837	292	8	Mix de costilla, chicharrón y bondiola	1.00	38000.00	19000.00	0.00	0.00	38000.00	2026-03-07 23:24:04.461563	\N	ENTREGADO
838	292	20	Papas al carbón mix	1.00	26000.00	13000.00	0.00	0.00	26000.00	2026-03-07 23:24:29.497618	\N	ENTREGADO
839	292	19	Papas al carbón supreme	1.00	25000.00	16000.00	0.00	0.00	25000.00	2026-03-07 23:24:45.550454	\N	ENTREGADO
840	292	81	SODA	1.00	5000.00	2500.00	0.00	0.00	5000.00	2026-03-07 23:25:01.034042	\N	ENTREGADO
841	292	83	Michelada	1.00	3000.00	1500.00	0.00	0.00	3000.00	2026-03-07 23:25:10.809955	\N	ENTREGADO
842	292	43	Coca-cola	1.00	7000.00	3500.00	0.00	0.00	7000.00	2026-03-07 23:25:19.828576	\N	ENTREGADO
843	293	20	Papas al carbón mix	1.00	26000.00	13000.00	0.00	0.00	26000.00	2026-03-07 23:27:13.361504	\N	ENTREGADO
844	293	19	Papas al carbón supreme	1.00	25000.00	16000.00	0.00	0.00	25000.00	2026-03-07 23:27:13.372316	\N	ENTREGADO
845	293	83	Michelada	1.00	3000.00	1500.00	0.00	0.00	3000.00	2026-03-07 23:27:38.81348	\N	ENTREGADO
846	293	81	SODA	1.00	5000.00	2500.00	0.00	0.00	5000.00	2026-03-07 23:27:38.823808	\N	ENTREGADO
847	293	43	Coca-cola	1.00	7000.00	3500.00	0.00	0.00	7000.00	2026-03-07 23:27:38.836864	\N	ENTREGADO
848	295	20	Papas al carbón mix	1.00	26000.00	13000.00	0.00	0.00	26000.00	2026-03-07 23:30:59.851386	\N	ENTREGADO
849	295	81	SODA	1.00	5000.00	2500.00	0.00	0.00	5000.00	2026-03-07 23:30:59.864796	\N	ENTREGADO
850	296	11	Especial	1.00	32000.00	14000.00	0.00	0.00	32000.00	2026-03-07 23:32:36.599232	\N	ENTREGADO
851	296	8	Mix de costilla, chicharrón y bondiola	1.00	38000.00	19000.00	0.00	0.00	38000.00	2026-03-07 23:32:36.623634	\N	ENTREGADO
852	296	43	Coca-cola	1.00	7000.00	3500.00	0.00	0.00	7000.00	2026-03-07 23:32:36.641483	\N	ENTREGADO
853	296	31	Jugos en agua	1.00	8000.00	4000.00	0.00	0.00	8000.00	2026-03-07 23:32:36.656052	\N	ENTREGADO
854	296	75	Chocolate	1.00	11500.00	7000.00	0.00	0.00	11500.00	2026-03-07 23:39:51.361521	\N	ENTREGADO
855	297	20	Papas al carbón mix	1.00	26000.00	13000.00	0.00	0.00	26000.00	2026-03-08 00:09:19.256127	\N	ENTREGADO
856	297	19	Papas al carbón supreme	1.00	25000.00	16000.00	0.00	0.00	25000.00	2026-03-08 00:09:19.297739	\N	ENTREGADO
857	297	32	Jugos en leche	2.00	10000.00	5000.00	0.00	0.00	20000.00	2026-03-08 00:09:19.312743	\N	ENTREGADO
858	298	74	Frappe Baileys	1.00	15000.00	6000.00	0.00	0.00	15000.00	2026-03-08 18:59:05.945962	\N	ENTREGADO
859	298	75	Chocolate	1.00	11500.00	7000.00	0.00	0.00	11500.00	2026-03-08 18:59:05.968775	\N	ENTREGADO
860	298	66	capuchino	1.00	7500.00	4500.00	0.00	0.00	7500.00	2026-03-08 18:59:05.990181	\N	ENTREGADO
861	299	23	Punta de Anca	1.00	38000.00	19000.00	0.00	0.00	38000.00	2026-03-08 18:59:30.939394	\N	ENTREGADO
862	299	3	Chicharron	1.00	30000.00	15000.00	0.00	0.00	30000.00	2026-03-08 18:59:30.968493	\N	ENTREGADO
863	299	43	Coca-cola	2.00	7000.00	3500.00	0.00	0.00	14000.00	2026-03-08 18:59:30.987228	\N	ENTREGADO
868	301	8	Mix de costilla, chicharrón y bondiola	1.00	38000.00	19000.00	0.00	0.00	38000.00	2026-03-08 19:16:51.600073	\N	ENTREGADO
870	303	8	Mix de costilla, chicharrón y bondiola	1.00	38000.00	19000.00	0.00	0.00	38000.00	2026-03-08 19:26:10.310236	\N	ENTREGADO
871	303	23	Punta de Anca	1.00	38000.00	19000.00	0.00	0.00	38000.00	2026-03-08 19:26:10.332097	\N	ENTREGADO
872	303	31	Jugos en agua	2.00	8000.00	4000.00	0.00	0.00	16000.00	2026-03-08 19:26:10.349574	\N	ENTREGADO
884	303	76	Zanahoria	1.00	11500.00	7000.00	0.00	0.00	11500.00	2026-03-08 19:40:53.669256	\N	ENTREGADO
864	300	8	Mix de costilla, chicharrón y bondiola	1.00	38000.00	19000.00	0.00	0.00	38000.00	2026-03-08 19:00:54.040458	\N	ENTREGADO
865	300	3	Chicharron	1.00	30000.00	15000.00	0.00	0.00	30000.00	2026-03-08 19:00:54.062708	\N	ENTREGADO
866	300	82	SODA CEREZA	1.00	10000.00	5000.00	0.00	0.00	10000.00	2026-03-08 19:00:54.080425	\N	ENTREGADO
867	300	36	Hierbabuena	1.00	10000.00	5000.00	0.00	0.00	10000.00	2026-03-08 19:00:54.099607	\N	ENTREGADO
873	304	11	Especial	1.00	32000.00	14000.00	0.00	0.00	32000.00	2026-03-08 19:38:58.139544	\N	ENTREGADO
874	304	78	Hamburguesa de chicharrón	1.00	32000.00	30000.00	0.00	0.00	32000.00	2026-03-08 19:38:58.15994	\N	ENTREGADO
875	304	10	Hamburguesa Sencilla	1.00	22000.00	11000.00	0.00	0.00	22000.00	2026-03-08 19:38:58.168577	\N	ENTREGADO
876	304	23	Punta de Anca	1.00	38000.00	19000.00	0.00	0.00	38000.00	2026-03-08 19:38:58.191446	\N	ENTREGADO
877	304	43	Coca-cola	2.00	7000.00	3500.00	0.00	0.00	14000.00	2026-03-08 19:38:58.207525	\N	ENTREGADO
878	304	52	Corona	1.00	9000.00	7000.00	0.00	0.00	9000.00	2026-03-08 19:38:58.223608	\N	ENTREGADO
880	305	22	Churrasco	1.00	36000.00	19000.00	0.00	0.00	36000.00	2026-03-08 19:39:38.693822	\N	ENTREGADO
881	305	8	Mix de costilla, chicharrón y bondiola	1.00	38000.00	19000.00	0.00	0.00	38000.00	2026-03-08 19:39:38.711389	\N	ENTREGADO
882	305	37	Cereza	1.00	10000.00	5000.00	0.00	0.00	10000.00	2026-03-08 19:39:38.720705	\N	ENTREGADO
883	305	38	Limonada de vino	1.00	12000.00	6000.00	0.00	0.00	12000.00	2026-03-08 19:39:38.737626	\N	ENTREGADO
869	302	19	Papas al carbón supreme	1.00	25000.00	16000.00	0.00	0.00	25000.00	2026-03-08 19:18:21.042521	\N	ENTREGADO
879	304	44	Quatro	1.00	7000.00	3500.00	0.00	0.00	7000.00	2026-03-08 19:38:58.240891	\N	ENTREGADO
893	308	75	Chocolate	1.00	11500.00	7000.00	0.00	0.00	11500.00	2026-03-08 20:30:53.69429	\N	ENTREGADO
887	307	22	Churrasco	1.00	36000.00	19000.00	0.00	0.00	36000.00	2026-03-08 20:15:30.675629	\N	ENTREGADO
888	307	17	Nuggets	1.00	17000.00	8000.00	0.00	0.00	17000.00	2026-03-08 20:15:30.688033	\N	ENTREGADO
889	307	19	Papas al carbón supreme	3.00	25000.00	16000.00	0.00	0.00	75000.00	2026-03-08 20:15:30.699595	\N	ENTREGADO
890	307	3	Chicharron	1.00	30000.00	15000.00	0.00	0.00	30000.00	2026-03-08 20:15:30.712551	\N	ENTREGADO
891	307	78	Hamburguesa de chicharrón	1.00	32000.00	30000.00	0.00	0.00	32000.00	2026-03-08 20:15:30.727453	\N	ENTREGADO
892	307	20	Papas al carbón mix	1.00	26000.00	13000.00	0.00	0.00	26000.00	2026-03-08 20:15:30.741952	\N	ENTREGADO
900	307	87	GASESEOSA 1.5	1.00	12000.00	7000.00	0.00	0.00	12000.00	2026-03-08 20:40:13.026089	\N	ENTREGADO
901	310	79	1 Entradas Patacones-1 hamb sencilla-1 papas mix- 2 gaseosas	1.00	59000.00	40000.00	0.00	0.00	59000.00	2026-03-08 20:50:21.285481	\N	ENTREGADO
894	309	23	Punta de Anca	1.00	38000.00	19000.00	0.00	0.00	38000.00	2026-03-08 20:34:35.825902	\N	ENTREGADO
895	309	20	Papas al carbón mix	1.00	26000.00	13000.00	0.00	0.00	26000.00	2026-03-08 20:34:35.850769	\N	ENTREGADO
896	309	68	Mocca	1.00	8500.00	4500.00	0.00	0.00	8500.00	2026-03-08 20:34:35.868929	\N	ENTREGADO
897	309	66	capuchino	1.00	7500.00	4500.00	0.00	0.00	7500.00	2026-03-08 20:34:35.883125	\N	ENTREGADO
898	309	43	Coca-cola	1.00	7000.00	3500.00	0.00	0.00	7000.00	2026-03-08 20:34:35.898716	\N	ENTREGADO
902	311	23	Punta de Anca	2.00	38000.00	19000.00	0.00	0.00	76000.00	2026-03-08 21:37:06.34191	\N	ENTREGADO
903	311	9	Bondiola	1.00	29000.00	13000.00	0.00	0.00	29000.00	2026-03-08 21:37:06.36259	\N	ENTREGADO
904	311	19	Papas al carbón supreme	1.00	25000.00	16000.00	0.00	0.00	25000.00	2026-03-08 21:38:04.571483	\N	ENTREGADO
905	311	31	Jugos en agua	1.00	8000.00	4000.00	0.00	0.00	8000.00	2026-03-08 21:38:04.584653	\N	ENTREGADO
906	311	32	Jugos en leche	1.00	10000.00	5000.00	0.00	0.00	10000.00	2026-03-08 21:38:04.59711	\N	ENTREGADO
907	311	28	Soda Maracuya	2.00	10000.00	5000.00	0.00	0.00	20000.00	2026-03-08 21:38:56.031492	\N	ENTREGADO
908	311	62	Jarra de Sangria	1.00	60000.00	30000.00	0.00	0.00	60000.00	2026-03-08 21:40:37.766798	\N	ENTREGADO
909	312	85	AGUA	1.00	4000.00	2000.00	0.00	0.00	4000.00	2026-03-08 21:44:04.126113	\N	ENTREGADO
910	312	20	Papas al carbón mix	1.00	26000.00	13000.00	0.00	0.00	26000.00	2026-03-08 21:44:04.146115	\N	ENTREGADO
911	312	10	Hamburguesa Sencilla	1.00	22000.00	11000.00	0.00	0.00	22000.00	2026-03-08 21:44:04.15731	\N	ENTREGADO
922	315	10	Hamburguesa Sencilla	1.00	22000.00	11000.00	0.00	0.00	22000.00	2026-03-08 21:56:03.047365	\N	ENTREGADO
923	315	19	Papas al carbón supreme	1.00	25000.00	16000.00	0.00	0.00	25000.00	2026-03-08 21:56:03.060669	\N	ENTREGADO
924	315	20	Papas al carbón mix	1.00	26000.00	13000.00	0.00	0.00	26000.00	2026-03-08 21:56:03.071117	\N	ENTREGADO
925	315	2	Costilla	1.00	30000.00	15000.00	0.00	0.00	30000.00	2026-03-08 21:56:03.07782	\N	ENTREGADO
926	315	82	SODA CEREZA	2.00	10000.00	5000.00	0.00	0.00	20000.00	2026-03-08 21:56:03.095924	\N	ENTREGADO
927	315	32	Jugos en leche	1.00	10000.00	5000.00	0.00	0.00	10000.00	2026-03-08 21:56:03.105901	\N	ENTREGADO
928	315	36	Hierbabuena	1.00	10000.00	5000.00	0.00	0.00	10000.00	2026-03-08 21:56:03.119059	\N	ENTREGADO
917	314	9	Bondiola	4.00	29000.00	13000.00	0.00	0.00	116000.00	2026-03-08 21:54:33.558674	\N	ENTREGADO
918	314	17	Nuggets	1.00	17000.00	8000.00	0.00	0.00	17000.00	2026-03-08 21:54:33.576578	\N	ENTREGADO
920	314	36	Hierbabuena	1.00	10000.00	5000.00	0.00	0.00	10000.00	2026-03-08 21:54:33.601532	\N	ENTREGADO
921	314	82	SODA CEREZA	1.00	10000.00	5000.00	0.00	0.00	10000.00	2026-03-08 21:54:33.614946	\N	ENTREGADO
929	316	9	Bondiola	1.00	29000.00	13000.00	0.00	0.00	29000.00	2026-03-08 22:08:32.175394	\N	ENTREGADO
930	316	3	Chicharron	1.00	30000.00	15000.00	0.00	0.00	30000.00	2026-03-08 22:08:32.196039	\N	ENTREGADO
931	316	27	Soda Michelada	1.00	8000.00	4000.00	0.00	0.00	8000.00	2026-03-08 22:08:32.207651	\N	ENTREGADO
932	316	31	Jugos en agua	1.00	8000.00	4000.00	0.00	0.00	8000.00	2026-03-08 22:08:32.220085	\N	ENTREGADO
933	318	59	Margarita	1.00	18000.00	12000.00	0.00	0.00	18000.00	2026-03-08 22:12:58.456833	\N	ENTREGADO
934	318	36	Hierbabuena	1.00	10000.00	5000.00	0.00	0.00	10000.00	2026-03-08 22:12:58.475388	\N	ENTREGADO
935	318	7	Ceviche de chicharron	1.00	25000.00	17000.00	0.00	0.00	25000.00	2026-03-08 22:12:58.486952	\N	ENTREGADO
936	318	2	Costilla	1.00	30000.00	15000.00	0.00	0.00	30000.00	2026-03-08 22:12:58.497277	\N	ENTREGADO
937	318	6	Patacones	1.00	12000.00	4500.00	0.00	0.00	12000.00	2026-03-08 22:12:58.515843	\N	ENTREGADO
938	318	57	Copa de Sangria	1.00	16000.00	12000.00	0.00	0.00	16000.00	2026-03-08 22:12:58.526485	\N	ENTREGADO
939	318	66	capuchino	1.00	7500.00	4500.00	0.00	0.00	7500.00	2026-03-08 22:12:58.538268	\N	ENTREGADO
885	306	79	1 Entradas Patacones-1 hamb sencilla-1 papas mix- 2 gaseosas	1.00	59000.00	40000.00	0.00	0.00	59000.00	2026-03-08 20:10:34.645933	\N	ENTREGADO
940	319	6	Patacones	1.00	12000.00	4500.00	0.00	0.00	12000.00	2026-03-08 22:32:54.727512	\N	ENTREGADO
912	313	21	Filete de Pechuga	1.00	26000.00	13000.00	0.00	0.00	26000.00	2026-03-08 21:49:04.08363	\N	ENTREGADO
913	313	22	Churrasco	1.00	36000.00	19000.00	0.00	0.00	36000.00	2026-03-08 21:49:04.099553	\N	ENTREGADO
914	313	83	Michelada	2.00	3000.00	1500.00	0.00	0.00	6000.00	2026-03-08 21:49:04.110622	\N	ENTREGADO
915	313	47	Aguila	1.00	7000.00	4000.00	0.00	0.00	7000.00	2026-03-08 21:49:04.120165	\N	ENTREGADO
916	313	81	SODA	1.00	5000.00	2500.00	0.00	0.00	5000.00	2026-03-08 21:49:04.134746	\N	ENTREGADO
941	319	20	Papas al carbón mix	1.00	26000.00	13000.00	0.00	0.00	26000.00	2026-03-08 22:32:54.744476	\N	ENTREGADO
942	319	35	Limonada de Coco	1.00	10000.00	5000.00	0.00	0.00	10000.00	2026-03-08 22:32:54.762196	\N	ENTREGADO
943	319	37	Cereza	1.00	10000.00	5000.00	0.00	0.00	10000.00	2026-03-08 22:32:54.775328	\N	ENTREGADO
944	319	40	Colombiana	1.00	6000.00	4000.00	0.00	0.00	6000.00	2026-03-08 22:32:54.783669	\N	ENTREGADO
945	319	78	Hamburguesa de chicharrón	1.00	32000.00	30000.00	0.00	0.00	32000.00	2026-03-08 22:32:54.79619	\N	ENTREGADO
946	320	44	Quatro	1.00	7000.00	3500.00	0.00	0.00	7000.00	2026-03-08 22:41:07.958936	\N	ENTREGADO
947	320	43	Coca-cola	1.00	7000.00	3500.00	0.00	0.00	7000.00	2026-03-08 22:41:07.990511	\N	ENTREGADO
948	320	10	Hamburguesa Sencilla	1.00	22000.00	11000.00	0.00	0.00	22000.00	2026-03-08 22:41:08.004059	\N	ENTREGADO
949	320	22	Churrasco	1.00	36000.00	19000.00	0.00	0.00	36000.00	2026-03-08 22:41:08.018059	\N	ENTREGADO
950	320	20	Papas al carbón mix	1.00	26000.00	13000.00	0.00	0.00	26000.00	2026-03-08 22:41:35.426159	\N	ENTREGADO
\.


--
-- Data for Name: invoices; Type: TABLE DATA; Schema: public; Owner: morales_user
--

COPY public.invoices (id, invoice_number, invoice_type, customer_id, user_id, subtotal, tax_amount, discount_amount, discount_percent, total, payment_method, payment_status, amount_received, change_amount, status, notes, voided_by, voided_at, void_reason, created_at, updated_at, service_charge_percent, service_charge_amount, delivery_charge_amount) FROM stdin;
93	V0216-0003	VENTA	\N	9	92000.00	0.00	0.00	0.00	92000.00	EFECTIVO	PAGADO	92000.00	0.00	ANULADA		9	2026-02-16 21:09:43.358604	prueba	2026-02-16 21:05:05.28108	2026-02-16 21:09:43.374848	0.00	0.00	0.00
2	FAC20260128-0001	VENTA	\N	1	70000.00	0.00	0.00	0.00	70000.00	EFECTIVO	PAGADO	100000.00	30000.00	COMPLETADA		\N	\N	\N	2026-01-28 09:28:32.44475	2026-01-28 09:28:32.598569	0.00	0.00	0.00
4	FAC20260128-0003	VENTA	\N	1	70000.00	0.00	0.00	0.00	70000.00	TARJETA_CREDITO	PAGADO	70000.00	0.00	COMPLETADA		\N	\N	\N	2026-01-28 11:34:50.828565	2026-01-28 11:34:50.888761	0.00	0.00	0.00
5	FAC20260128-0004	VENTA	\N	1	80000.00	0.00	0.00	0.00	80000.00	TARJETA_CREDITO	PAGADO	80000.00	0.00	COMPLETADA		\N	\N	\N	2026-01-28 11:36:58.809651	2026-01-28 11:36:58.956617	0.00	0.00	0.00
6	FAC20260128-0005	VENTA	\N	1	90000.00	0.00	0.00	0.00	90000.00	TARJETA_CREDITO	PAGADO	90000.00	0.00	COMPLETADA		\N	\N	\N	2026-01-28 18:39:26.04706	2026-01-28 18:39:26.199726	0.00	0.00	0.00
7	FAC20260130-0001	VENTA	\N	1	150000.00	0.00	0.00	0.00	150000.00	EFECTIVO	PAGADO	200000.00	50000.00	COMPLETADA		\N	\N	\N	2026-01-30 08:41:49.854409	2026-01-30 08:41:49.956415	0.00	0.00	0.00
8	FAC20260130-0002	VENTA	3	1	115000.00	0.00	0.00	0.00	115000.00	TARJETA_CREDITO	PAGADO	115000.00	0.00	COMPLETADA		\N	\N	\N	2026-01-30 09:03:07.294901	2026-01-30 09:03:07.405815	0.00	0.00	0.00
22	FAC20260130-0016	VENTA	6	1	101000.00	0.00	0.00	0.00	101000.00	TARJETA_CREDITO	PAGADO	101000.00	0.00	COMPLETADA		\N	\N	\N	2026-01-30 15:36:06.322746	2026-01-30 15:36:06.416377	0.00	0.00	0.00
10	FAC20260130-0004	VENTA	3	1	105000.00	0.00	0.00	0.00	105000.00	TARJETA_CREDITO	PAGADO	105000.00	0.00	ANULADA		1	2026-01-30 09:06:05.127669	error al facturar	2026-01-30 09:04:15.407545	2026-01-30 09:06:05.139237	0.00	0.00	0.00
3	FAC20260128-0002	VENTA	\N	1	45000.00	0.00	0.00	0.00	45000.00	EFECTIVO	PAGADO	55000.00	10000.00	ANULADA		1	2026-01-30 09:06:51.508017	error de prueba	2026-01-28 09:30:12.315567	2026-01-30 09:06:51.513905	0.00	0.00	0.00
9	FAC20260130-0003	VENTA	\N	1	95000.00	0.00	0.00	0.00	95000.00	TARJETA_CREDITO	PAGADO	95000.00	0.00	ANULADA		1	2026-01-30 09:07:13.373346	asd	2026-01-30 09:03:43.51957	2026-01-30 09:07:13.387714	0.00	0.00	0.00
11	FAC20260130-0005	VENTA	1	1	81000.00	0.00	0.00	0.00	81000.00	EFECTIVO	PAGADO	81000.00	0.00	COMPLETADA		\N	\N	\N	2026-01-30 09:14:11.899431	2026-01-30 09:14:12.03648	0.00	0.00	0.00
12	FAC20260130-0006	VENTA	\N	1	249000.00	0.00	0.00	0.00	249000.00	TARJETA_CREDITO	PAGADO	249000.00	0.00	COMPLETADA		\N	\N	\N	2026-01-30 10:11:31.4598	2026-01-30 10:11:31.592724	0.00	0.00	0.00
13	FAC20260130-0007	VENTA	4	1	116000.00	0.00	0.00	0.00	116000.00	TARJETA_CREDITO	PAGADO	116000.00	0.00	COMPLETADA		\N	\N	\N	2026-01-30 13:12:39.325787	2026-01-30 13:12:39.507493	0.00	0.00	0.00
14	FAC20260130-0008	VENTA	5	1	296000.00	0.00	0.00	0.00	296000.00	TARJETA_CREDITO	PAGADO	296000.00	0.00	COMPLETADA		\N	\N	\N	2026-01-30 13:16:08.238107	2026-01-30 13:16:08.350917	0.00	0.00	0.00
15	FAC20260130-0009	VENTA	4	1	97000.00	0.00	0.00	0.00	97000.00	TARJETA_CREDITO	PAGADO	97000.00	0.00	COMPLETADA		\N	\N	\N	2026-01-30 14:15:05.292034	2026-01-30 14:15:05.445645	0.00	0.00	0.00
16	FAC20260130-0010	VENTA	4	1	55000.00	0.00	0.00	0.00	55000.00	EFECTIVO	PAGADO	55000.00	0.00	COMPLETADA		\N	\N	\N	2026-01-30 14:24:55.882173	2026-01-30 14:24:55.933673	0.00	0.00	0.00
17	FAC20260130-0011	VENTA	\N	1	135000.00	0.00	0.00	0.00	135000.00	EFECTIVO	PAGADO	135000.00	0.00	COMPLETADA		\N	\N	\N	2026-01-30 14:26:01.865284	2026-01-30 14:26:01.906579	0.00	0.00	0.00
18	FAC20260130-0012	VENTA	3	1	100000.00	0.00	0.00	0.00	100000.00	EFECTIVO	PAGADO	100000.00	0.00	COMPLETADA		\N	\N	\N	2026-01-30 14:26:22.247299	2026-01-30 14:26:22.283239	0.00	0.00	0.00
19	FAC20260130-0013	VENTA	4	1	25000.00	0.00	0.00	0.00	25000.00	TARJETA_CREDITO	PAGADO	25000.00	0.00	COMPLETADA		\N	\N	\N	2026-01-30 14:37:22.499427	2026-01-30 14:37:22.585302	0.00	0.00	0.00
23	FAC20260204-0001	VENTA	\N	1	62000.00	0.00	0.00	0.00	62000.00	TARJETA_CREDITO	PAGADO	62000.00	0.00	COMPLETADA		\N	\N	\N	2026-02-04 18:39:38.483915	2026-02-04 18:39:38.701753	0.00	0.00	0.00
20	FAC20260130-0014	VENTA	6	1	139000.00	0.00	0.00	0.00	139000.00	EFECTIVO	PAGADO	200000.00	61000.00	ANULADA		1	2026-01-30 14:46:26.910385	se adicionaron producto que no eran\n	2026-01-30 14:45:27.198833	2026-01-30 14:46:26.919948	0.00	0.00	0.00
21	FAC20260130-0015	VENTA	\N	1	62000.00	0.00	0.00	0.00	62000.00	TARJETA_CREDITO	PAGADO	62000.00	0.00	COMPLETADA		\N	\N	\N	2026-01-30 15:35:35.690544	2026-01-30 15:35:35.936322	0.00	0.00	0.00
24	FAC20260209-0001	VENTA	\N	1	25000.00	0.00	0.00	0.00	25000.00	EFECTIVO	PAGADO	90000.00	65000.00	COMPLETADA		\N	\N	\N	2026-02-09 17:42:15.628938	2026-02-09 17:42:15.674126	0.00	0.00	0.00
25	FAC20260209-0002	VENTA	\N	1	118000.00	0.00	0.00	0.00	118000.00	EFECTIVO	PAGADO	200000.00	82000.00	COMPLETADA		\N	\N	\N	2026-02-09 17:42:53.727636	2026-02-09 17:42:53.767518	0.00	0.00	0.00
26	FAC20260209-0003	VENTA	\N	1	237000.00	0.00	0.00	0.00	237000.00	TARJETA_CREDITO	PAGADO	237000.00	0.00	COMPLETADA		\N	\N	\N	2026-02-09 17:45:08.907272	2026-02-09 17:45:08.973958	0.00	0.00	0.00
27	FAC20260209-0004	VENTA	5	1	91000.00	0.00	0.00	0.00	91000.00	EFECTIVO	PAGADO	100000.00	9000.00	COMPLETADA		\N	\N	\N	2026-02-09 18:59:34.34901	2026-02-09 18:59:34.544467	0.00	0.00	0.00
28	FAC20260209-0005	VENTA	5	1	62000.00	0.00	0.00	0.00	62000.00	EFECTIVO	PAGADO	62000.00	0.00	COMPLETADA		\N	\N	\N	2026-02-09 19:01:26.817754	2026-02-09 19:01:26.88491	0.00	0.00	0.00
29	FAC20260209-0006	VENTA	5	1	62000.00	0.00	0.00	0.00	62000.00	EFECTIVO	PAGADO	100000.00	38000.00	COMPLETADA		\N	\N	\N	2026-02-09 19:30:25.977808	2026-02-09 19:30:26.043666	0.00	0.00	0.00
30	FAC20260209-0007	VENTA	\N	1	81000.00	0.00	0.00	0.00	81000.00	EFECTIVO	PAGADO	81000.00	0.00	COMPLETADA		\N	\N	\N	2026-02-09 19:34:41.225257	2026-02-09 19:34:41.288753	0.00	0.00	0.00
31	FAC20260209-0008	VENTA	\N	1	62000.00	0.00	0.00	0.00	62000.00	EFECTIVO	PAGADO	62000.00	0.00	COMPLETADA		\N	\N	\N	2026-02-09 21:02:47.004718	2026-02-09 21:02:47.638127	0.00	0.00	0.00
32	MESA20260209-T3-0001	VENTA	\N	1	135000.00	0.00	0.00	0.00	135000.00	EFECTIVO	PAGADO	135000.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-02-09 21:06:03.489891	2026-02-09 21:07:30.432059	0.00	0.00	0.00
37	FAC20260209-0009	VENTA	\N	1	27000.00	0.00	0.00	0.00	27000.00	EFECTIVO	PAGADO	27000.00	0.00	COMPLETADA		\N	\N	\N	2026-02-09 22:07:51.84076	2026-02-09 22:07:51.881599	0.00	0.00	0.00
34	MESA20260209-T2-0003	VENTA	\N	1	81000.00	0.00	0.00	0.00	81000.00	TARJETA_CREDITO	PAGADO	81000.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-02-09 21:47:01.536051	2026-02-09 21:49:32.461039	0.00	0.00	0.00
38	MESA20260209-T7-0006	VENTA	\N	1	108000.00	0.00	0.00	0.00	108000.00	EFECTIVO	PAGADO	108000.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-02-09 22:27:13.817002	2026-02-09 22:27:15.832523	0.00	0.00	0.00
35	MESA20260209-T5-0004	VENTA	\N	1	54000.00	0.00	0.00	0.00	54000.00	EFECTIVO	PAGADO	80000.00	26000.00	COMPLETADA	\N	\N	\N	\N	2026-02-09 21:50:45.960512	2026-02-09 21:51:33.348004	0.00	0.00	0.00
33	MESA20260209-T1-0002	VENTA	\N	1	185000.00	0.00	0.00	0.00	185000.00	EFECTIVO	PAGADO	185000.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-02-09 21:13:01.560875	2026-02-09 21:57:47.434497	0.00	0.00	0.00
40	MESA20260209-T4-0008	VENTA	4	1	100000.00	0.00	0.00	0.00	100000.00	EFECTIVO	PAGADO	100000.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-02-09 22:31:22.9564	2026-02-09 22:54:45.618576	0.00	0.00	0.00
41	MESA20260209-T5-0009	VENTA	6	1	116000.00	0.00	0.00	0.00	116000.00	EFECTIVO	PAGADO	116000.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-02-09 22:38:57.230069	2026-02-09 22:55:03.399499	0.00	0.00	0.00
36	MESA20260209-T1-0005	VENTA	\N	1	27000.00	0.00	0.00	0.00	27000.00	EFECTIVO	PAGADO	50000.00	23000.00	COMPLETADA	\N	\N	\N	\N	2026-02-09 21:58:41.466706	2026-02-09 22:40:09.20769	0.00	0.00	0.00
39	MESA20260209-T3-0007	VENTA	\N	1	75000.00	0.00	0.00	0.00	75000.00	TARJETA_CREDITO	PAGADO	75000.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-02-09 22:28:15.295902	2026-02-09 22:54:35.325077	0.00	0.00	0.00
42	MESA20260209-T1-0010	VENTA	\N	1	52000.00	0.00	0.00	0.00	52000.00	EFECTIVO	PAGADO	60000.00	8000.00	COMPLETADA	\N	\N	\N	\N	2026-02-09 22:52:47.598288	2026-02-09 22:54:11.481684	0.00	0.00	0.00
43	MESA20260209-T7-0011	VENTA	\N	1	50000.00	0.00	0.00	0.00	50000.00	TARJETA_CREDITO	PAGADO	50000.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-02-09 22:53:37.694499	2026-02-09 22:53:38.681379	0.00	0.00	0.00
1	FAC20260127-0001	VENTA	\N	1	25000.00	0.00	0.00	0.00	25000.00	EFECTIVO	PAGADO	45000.00	20000.00	ANULADA		1	2026-02-10 19:49:33.797508	hubo un producto adicional de mas	2026-01-27 21:52:01.88849	2026-02-10 19:49:33.802553	0.00	0.00	0.00
47	MESA20260209-T5-0015	VENTA	\N	2	25000.00	0.00	0.00	0.00	25000.00	EFECTIVO	PAGADO	25000.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-02-09 23:15:24.838498	2026-02-09 23:21:04.9911	0.00	0.00	0.00
44	MESA20260209-T6-0012	VENTA	\N	2	25000.00	0.00	0.00	0.00	25000.00	EFECTIVO	PAGADO	25000.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-02-09 23:06:23.074621	2026-02-09 23:21:14.841885	0.00	0.00	0.00
46	MESA20260209-T4-0014	VENTA	5	1	50000.00	0.00	0.00	0.00	50000.00	EFECTIVO	PAGADO	50000.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-02-09 23:13:03.122279	2026-02-09 23:20:57.385704	0.00	0.00	0.00
45	MESA20260209-T8-0013	VENTA	6	1	25000.00	0.00	0.00	0.00	25000.00	TARJETA_CREDITO	PAGADO	25000.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-02-09 23:10:38.38956	2026-02-09 23:21:24.565814	0.00	0.00	0.00
142	M3-0222-0001	VENTA	\N	1	0.00	0.00	0.00	0.00	0.00	\N	PENDIENTE	0.00	0.00	ANULADA	\N	\N	\N	Mesa liberada sin pedido	2026-02-22 02:29:04.60734	2026-02-22 18:49:44.467606	0.00	0.00	0.00
69	MESA20260211-T4-0007	VENTA	\N	2	71000.00	0.00	0.00	0.00	71000.00	EFECTIVO	PAGADO	71000.00	0.00	ANULADA	\N	1	2026-02-11 19:34:51.754	s	2026-02-11 17:14:31.897345	2026-02-11 19:34:51.759891	0.00	0.00	0.00
49	MESA20260210-T3-0002	VENTA	5	1	88000.00	0.00	0.00	0.00	88000.00	TARJETA_CREDITO	PAGADO	88000.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-02-10 08:53:07.336331	2026-02-10 08:53:56.437933	0.00	0.00	0.00
96	V0216-0006	VENTA	\N	9	86000.00	0.00	0.00	0.00	94600.00	EFECTIVO	PAGADO	94600.00	0.00	COMPLETADA		\N	\N	\N	2026-02-16 21:25:00.117043	2026-02-16 21:25:00.21804	10.00	8600.00	0.00
68	MESA20260211-T3-0006	VENTA	\N	2	118000.00	0.00	0.00	0.00	118000.00	EFECTIVO	PAGADO	118000.00	0.00	ANULADA	\N	1	2026-02-11 19:34:55.87917	s	2026-02-11 17:12:40.305887	2026-02-11 19:34:55.885299	0.00	0.00	0.00
52	MESA20260210-T5-0005	VENTA	3	1	46000.00	0.00	0.00	0.00	46000.00	EFECTIVO	PAGADO	100000.00	54000.00	COMPLETADA	\N	\N	\N	\N	2026-02-10 09:08:21.703541	2026-02-10 09:24:20.051649	0.00	0.00	0.00
54	MESA20260210-T1-0007	VENTA	\N	1	56000.00	0.00	0.00	0.00	56000.00	TARJETA_CREDITO	PAGADO	56000.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-02-10 09:22:35.819641	2026-02-10 09:35:58.57946	0.00	0.00	0.00
48	MESA20260210-T2-0001	VENTA	6	1	32000.00	0.00	0.00	0.00	32000.00	EFECTIVO	PAGADO	32000.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-02-10 08:52:12.453256	2026-02-10 09:36:04.444469	0.00	0.00	0.00
56	MESA20260210-T3-0009	VENTA	3	1	66000.00	0.00	0.00	0.00	66000.00	TARJETA_CREDITO	PAGADO	66000.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-02-10 09:33:40.68905	2026-02-10 09:36:10.738235	0.00	0.00	0.00
50	MESA20260210-T4-0003	VENTA	\N	1	49000.00	0.00	0.00	0.00	49000.00	EFECTIVO	PAGADO	49000.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-02-10 08:55:47.699348	2026-02-10 09:36:16.629983	0.00	0.00	0.00
53	MESA20260210-T6-0006	VENTA	6	1	27000.00	0.00	0.00	0.00	27000.00	EFECTIVO	PAGADO	27000.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-02-10 09:20:48.797375	2026-02-10 09:36:21.895639	0.00	0.00	0.00
55	MESA20260210-T8-0008	VENTA	5	1	91000.00	0.00	0.00	0.00	91000.00	EFECTIVO	PAGADO	91000.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-02-10 09:25:43.671645	2026-02-10 09:36:26.811787	0.00	0.00	0.00
51	MESA20260210-T7-0004	VENTA	4	1	91000.00	0.00	0.00	0.00	91000.00	EFECTIVO	PAGADO	100000.00	9000.00	COMPLETADA	\N	\N	\N	\N	2026-02-10 08:58:38.209051	2026-02-10 09:36:44.231817	0.00	0.00	0.00
70	FAC20260211-0003	VENTA	\N	1	64000.00	0.00	0.00	0.00	64000.00	TRANSFERENCIA	PAGADO	64000.00	0.00	COMPLETADA		\N	\N	\N	2026-02-11 20:34:31.391675	2026-02-11 20:34:31.457863	0.00	0.00	0.00
57	MESA20260210-T6-0010	VENTA	7	1	111000.00	0.00	0.00	0.00	111000.00	EFECTIVO	PAGADO	150000.00	39000.00	COMPLETADA	\N	\N	\N	\N	2026-02-10 19:27:16.93959	2026-02-10 19:30:26.197374	0.00	0.00	0.00
58	MESA20260210-T3-0011	VENTA	\N	1	103000.00	0.00	0.00	0.00	103000.00	TARJETA_CREDITO	PAGADO	103000.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-02-10 19:28:34.476339	2026-02-10 19:35:30.551786	0.00	0.00	0.00
60	MESA20260210-T4-0013	VENTA	\N	2	80000.00	0.00	0.00	0.00	80000.00	EFECTIVO	PAGADO	80000.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-02-10 20:10:20.504819	2026-02-11 12:20:24.266485	0.00	0.00	0.00
59	MESA20260210-T2-0012	VENTA	\N	2	180000.00	0.00	0.00	0.00	198000.00	EFECTIVO	PAGADO	180000.00	-18000.00	COMPLETADA	\N	\N	\N	\N	2026-02-10 20:09:46.096995	2026-02-11 12:21:12.220721	10.00	18000.00	0.00
71	FAC20260211-0004	VENTA	\N	1	15000.00	0.00	0.00	0.00	15000.00	EFECTIVO	PAGADO	15000.00	0.00	COMPLETADA		\N	\N	\N	2026-02-11 20:35:21.090141	2026-02-11 20:35:21.125076	0.00	0.00	0.00
72	FAC20260211-0005	VENTA	\N	1	26000.00	0.00	0.00	0.00	26000.00	TRANSFERENCIA	PAGADO	26000.00	0.00	COMPLETADA		\N	\N	\N	2026-02-11 20:38:42.798696	2026-02-11 20:38:42.820335	0.00	0.00	0.00
61	FAC20260211-0001	VENTA	\N	1	10000.00	0.00	0.00	0.00	11000.00	TRANSFERENCIA	PAGADO	10000.00	-1000.00	ANULADA		1	2026-02-11 19:32:55.955317	p	2026-02-11 12:21:37.887989	2026-02-11 19:32:56.000377	10.00	1000.00	0.00
67	MESA20260211-T7-0005	VENTA	8	1	110000.00	0.00	0.00	0.00	110000.00	EFECTIVO	PAGADO	110000.00	0.00	ANULADA	\N	1	2026-02-11 19:33:01.864959	p	2026-02-11 13:40:52.289448	2026-02-11 19:33:01.874974	0.00	0.00	0.00
66	MESA20260211-T1-0004	VENTA	\N	1	37000.00	0.00	0.00	0.00	37000.00	EFECTIVO	PAGADO	37000.00	0.00	ANULADA	\N	1	2026-02-11 19:33:07.009733	p	2026-02-11 13:31:47.893361	2026-02-11 19:33:07.015653	0.00	0.00	0.00
65	MESA20260211-T4-0003	VENTA	\N	1	51000.00	0.00	0.00	0.00	56100.00	EFECTIVO	PAGADO	51000.00	-5100.00	ANULADA	\N	1	2026-02-11 19:33:12.377759	p	2026-02-11 12:31:11.432442	2026-02-11 19:33:12.384408	10.00	5100.00	0.00
64	FAC20260211-0002	VENTA	\N	1	65000.00	0.00	0.00	0.00	71500.00	EFECTIVO	PAGADO	100000.00	28500.00	ANULADA		1	2026-02-11 19:33:17.359786	p	2026-02-11 12:29:00.441522	2026-02-11 19:33:17.366543	10.00	6500.00	0.00
63	MESA20260211-T3-0002	VENTA	\N	1	10000.00	0.00	0.00	0.00	11000.00	TRANSFERENCIA	PAGADO	10000.00	-1000.00	ANULADA	\N	1	2026-02-11 19:33:21.343397	p	2026-02-11 12:27:55.131077	2026-02-11 19:33:21.350261	10.00	1000.00	0.00
62	MESA20260211-T1-0001	VENTA	\N	1	18000.00	0.00	0.00	0.00	19800.00	EFECTIVO	PAGADO	20000.00	200.00	ANULADA	\N	1	2026-02-11 19:33:25.377894	p	2026-02-11 12:22:19.162356	2026-02-11 19:33:25.380523	10.00	1800.00	0.00
73	FAC20260211-0006	VENTA	\N	1	35800.00	0.00	0.00	0.00	35800.00	TRANSFERENCIA	PAGADO	35800.00	0.00	COMPLETADA		\N	\N	\N	2026-02-11 21:25:58.318215	2026-02-11 21:25:58.367381	0.00	0.00	0.00
74	FAC20260211-0007	VENTA	\N	1	68000.00	0.00	0.00	0.00	68000.00	EFECTIVO	PAGADO	68000.00	0.00	COMPLETADA		\N	\N	\N	2026-02-11 22:26:13.027306	2026-02-11 22:26:13.096995	0.00	0.00	0.00
77	FAC20260215-0001	VENTA	\N	1	44000.00	0.00	0.00	0.00	48400.00	EFECTIVO	PAGADO	48400.00	0.00	COMPLETADA		\N	\N	\N	2026-02-15 19:28:03.935777	2026-02-15 19:28:04.018315	10.00	4400.00	0.00
76	MESA20260214-T4-0001	VENTA	6	1	139000.00	0.00	0.00	0.00	152900.00	TRANSFERENCIA	PAGADO	152900.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-02-14 20:13:59.06985	2026-02-14 20:20:43.640017	10.00	13900.00	0.00
75	MESA20260213-T8-0001	VENTA	\N	1	211000.00	0.00	0.00	0.00	211000.00	EFECTIVO	PAGADO	211000.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-02-13 17:27:43.930482	2026-02-14 20:23:13.984108	0.00	0.00	0.00
78	MESA20260215-T4-0001	VENTA	\N	1	91000.00	0.00	0.00	0.00	100100.00	EFECTIVO	PAGADO	200000.00	99900.00	COMPLETADA	\N	\N	\N	\N	2026-02-15 19:28:16.240847	2026-02-15 19:29:01.372031	10.00	9100.00	0.00
82	V0215-0001	VENTA	\N	1	82000.00	0.00	0.00	0.00	85000.00	TRANSFERENCIA	PAGADO	85000.00	0.00	COMPLETADA		\N	\N	\N	2026-02-15 22:27:53.431777	2026-02-15 22:27:53.524884	0.00	0.00	3000.00
79	M1-0215-0001	VENTA	\N	1	47000.00	0.00	0.00	0.00	47000.00	EFECTIVO	PAGADO	50000.00	3000.00	COMPLETADA	\N	\N	\N	\N	2026-02-15 21:36:46.992415	2026-02-15 21:37:22.06901	0.00	0.00	0.00
83	M3-0215-0002	VENTA	\N	1	27000.00	0.00	0.00	0.00	30000.00	TRANSFERENCIA	PAGADO	30000.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-02-15 22:48:56.183093	2026-02-15 22:57:30.939176	0.00	0.00	3000.00
81	M3-0215-0001	VENTA	\N	1	81000.00	0.00	0.00	0.00	81000.00	EFECTIVO	PAGADO	100000.00	19000.00	COMPLETADA	\N	\N	\N	\N	2026-02-15 21:42:57.202228	2026-02-15 22:30:33.031087	0.00	0.00	0.00
80	M1-0215-0002	VENTA	\N	1	41000.00	0.00	0.00	0.00	44000.00	EFECTIVO	PAGADO	50000.00	6000.00	COMPLETADA	\N	\N	\N	\N	2026-02-15 21:41:17.81436	2026-02-15 22:45:45.502455	0.00	0.00	3000.00
89	M4-0216-0001	VENTA	\N	1	52000.00	0.00	15600.00	30.00	43040.00	EFECTIVO	PAGADO	58640.00	15600.00	ANULADA	\N	9	2026-02-16 17:18:28.324701	e	2026-02-16 12:17:48.928346	2026-02-16 17:18:28.340392	10.00	3640.00	3000.00
88	M1-0216-0001	VENTA	5	1	59000.00	0.00	0.00	0.00	59000.00	TRANSFERENCIA	PAGADO	59000.00	0.00	ANULADA	\N	9	2026-02-16 17:18:33.254098	e	2026-02-16 09:46:59.739013	2026-02-16 17:18:33.272716	0.00	0.00	0.00
87	M7-0216-0001	VENTA	\N	1	42000.00	0.00	0.00	0.00	42000.00	TRANSFERENCIA	PAGADO	42000.00	0.00	ANULADA	\N	9	2026-02-16 17:18:39.502673	e	2026-02-16 08:31:15.868592	2026-02-16 17:18:39.512416	0.00	0.00	0.00
86	V0216-0001	VENTA	\N	1	77000.00	0.00	0.00	0.00	80000.00	EFECTIVO	PAGADO	80000.00	0.00	ANULADA		9	2026-02-16 17:18:44.065251	e	2026-02-16 08:31:00.246071	2026-02-16 17:18:44.0825	0.00	0.00	3000.00
90	V0216-0002	VENTA	\N	9	18000.00	0.00	0.00	0.00	18000.00	EFECTIVO	PAGADO	18000.00	0.00	ANULADA		9	2026-02-16 17:18:22.563311	e	2026-02-16 13:51:49.194061	2026-02-16 17:18:22.644207	0.00	0.00	0.00
85	M5-0216-0001	VENTA	\N	1	35000.00	0.00	0.00	0.00	38000.00	EFECTIVO	PAGADO	40000.00	2000.00	ANULADA	\N	9	2026-02-16 17:18:48.54273	e	2026-02-16 08:04:32.707889	2026-02-16 17:18:48.571105	0.00	0.00	3000.00
91	M6-0216-0001	VENTA	\N	9	25000.00	0.00	0.00	0.00	25000.00	EFECTIVO	PAGADO	25000.00	0.00	ANULADA	\N	1	2026-02-16 20:59:15.805463	d	2026-02-16 18:36:25.964258	2026-02-16 20:59:15.812595	0.00	0.00	0.00
94	V0216-0004	VENTA	\N	9	77000.00	0.00	0.00	0.00	89700.00	TRANSFERENCIA	PAGADO	77000.00	-12700.00	ANULADA		9	2026-02-16 21:20:31.199417	prueba	2026-02-16 21:20:15.992863	2026-02-16 21:20:31.206772	10.00	7700.00	5000.00
95	V0216-0005	VENTA	\N	9	77000.00	0.00	0.00	0.00	77000.00	TRANSFERENCIA	PAGADO	77000.00	0.00	COMPLETADA		\N	\N	\N	2026-02-16 21:22:19.954481	2026-02-16 21:22:20.020304	0.00	0.00	0.00
97	V0216-0007	VENTA	\N	9	10000.00	0.00	0.00	0.00	10000.00	EFECTIVO	PAGADO	10000.00	0.00	COMPLETADA		\N	\N	\N	2026-02-16 21:45:08.018141	2026-02-16 21:45:08.052456	0.00	0.00	0.00
98	V0216-0008	VENTA	\N	9	25000.00	0.00	0.00	0.00	25000.00	EFECTIVO	PAGADO	25000.00	0.00	COMPLETADA		\N	\N	\N	2026-02-16 21:45:35.329944	2026-02-16 21:45:35.352538	0.00	0.00	0.00
84	M3-0215-0003	VENTA	\N	1	50000.00	0.00	0.00	0.00	50000.00	TRANSFERENCIA	PAGADO	53000.00	3000.00	ANULADA	\N	9	2026-02-16 21:48:18.247412	prueba	2026-02-15 22:58:25.409438	2026-02-16 21:48:18.253931	0.00	0.00	0.00
107	M8-0218-0004	VENTA	\N	1	0.00	0.00	0.00	0.00	0.00	\N	PENDIENTE	0.00	0.00	ANULADA	\N	\N	\N	Mesa liberada sin pedido	2026-02-18 17:58:20.010815	2026-02-18 18:35:03.005623	0.00	0.00	0.00
108	V0218-0001	VENTA	\N	9	70000.00	0.00	0.00	0.00	70000.00	TRANSFERENCIA	PAGADO	70000.00	0.00	COMPLETADA		\N	\N	\N	2026-02-18 20:19:15.61445	2026-02-18 20:19:15.8275	0.00	0.00	0.00
99	M2-0216-0001	VENTA	\N	6	0.00	0.00	0.00	0.00	0.00	\N	PENDIENTE	0.00	0.00	ANULADA	\N	\N	\N	Mesa liberada sin pedido	2026-02-16 22:53:08.554857	2026-02-16 23:50:00.78953	0.00	0.00	0.00
92	M1-0216-0002	VENTA	\N	9	0.00	0.00	0.00	0.00	0.00	\N	PENDIENTE	0.00	0.00	ANULADA	\N	\N	\N	Mesa liberada sin pedido	2026-02-16 20:59:14.055847	2026-02-16 23:50:06.891063	0.00	0.00	0.00
121	M10-0220-0001	VENTA	\N	1	0.00	0.00	0.00	0.00	0.00	\N	PENDIENTE	0.00	0.00	ANULADA	\N	\N	\N	Mesa liberada sin pedido	2026-02-20 19:53:23.555583	2026-02-20 20:05:34.358013	0.00	0.00	0.00
109	M1-0218-0001	VENTA	\N	9	0.00	0.00	0.00	0.00	0.00	\N	PENDIENTE	0.00	0.00	ANULADA	\N	\N	\N	Mesa liberada sin pedido	2026-02-18 20:38:13.361097	2026-02-18 20:44:38.44396	0.00	0.00	0.00
101	M4-0216-0002	VENTA	\N	6	0.00	0.00	0.00	0.00	0.00	\N	PENDIENTE	0.00	0.00	ANULADA	\N	\N	\N	Mesa liberada sin pedido	2026-02-16 23:30:16.05178	2026-02-18 09:37:25.526515	0.00	0.00	0.00
110	M6-0218-0001	VENTA	\N	9	7500.00	0.00	0.00	0.00	7500.00	TRANSFERENCIA	PAGADO	7500.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-02-18 20:47:03.738163	2026-02-18 20:48:19.438034	0.00	0.00	0.00
119	M6-0220-0001	VENTA	\N	1	0.00	0.00	0.00	0.00	0.00	\N	PENDIENTE	0.00	0.00	ANULADA	\N	\N	\N	Mesa liberada sin pedido	2026-02-20 19:30:59.938304	2026-02-20 19:45:47.645354	0.00	0.00	0.00
111	V0219-0001	VENTA	\N	1	5500.00	0.00	0.00	0.00	9050.00	EFECTIVO	PAGADO	9050.00	0.00	ANULADA		1	2026-02-19 16:46:00.522525	prueba de impresion\n	2026-02-19 16:45:30.581758	2026-02-19 16:46:00.55104	10.00	550.00	3000.00
100	M3-0216-0001	VENTA	\N	6	0.00	0.00	0.00	0.00	0.00	\N	PENDIENTE	0.00	0.00	ANULADA	\N	\N	\N	Mesa liberada sin pedido	2026-02-16 23:08:27.561571	2026-02-18 09:37:40.506718	0.00	0.00	0.00
102	M3-0218-0001	VENTA	\N	1	0.00	0.00	0.00	0.00	0.00	\N	PENDIENTE	0.00	0.00	ANULADA	\N	\N	\N	Mesa liberada sin pedido	2026-02-18 17:09:11.284249	2026-02-18 17:20:42.895019	0.00	0.00	0.00
103	M4-0218-0001	VENTA	\N	1	0.00	0.00	0.00	0.00	0.00	\N	PENDIENTE	0.00	0.00	ANULADA	\N	\N	\N	Mesa liberada sin pedido	2026-02-18 17:21:01.267062	2026-02-18 17:21:48.74165	0.00	0.00	0.00
104	M8-0218-0001	VENTA	\N	9	0.00	0.00	0.00	0.00	0.00	\N	PENDIENTE	0.00	0.00	ANULADA	\N	\N	\N	Mesa liberada sin pedido	2026-02-18 17:29:32.570517	2026-02-18 17:41:25.367223	0.00	0.00	0.00
105	M8-0218-0002	VENTA	\N	9	0.00	0.00	0.00	0.00	0.00	\N	PENDIENTE	0.00	0.00	ANULADA	\N	\N	\N	Mesa liberada sin pedido	2026-02-18 17:44:55.532616	2026-02-18 17:57:10.784352	0.00	0.00	0.00
106	M8-0218-0003	VENTA	\N	10	0.00	0.00	0.00	0.00	0.00	\N	PENDIENTE	0.00	0.00	ANULADA	\N	\N	\N	Mesa liberada sin pedido	2026-02-18 17:57:27.882216	2026-02-18 17:57:51.696104	0.00	0.00	0.00
113	M2-0219-0001	VENTA	\N	1	0.00	0.00	0.00	0.00	0.00	\N	PENDIENTE	0.00	0.00	ANULADA	\N	\N	\N	Mesa liberada sin pedido	2026-02-19 18:14:36.267996	2026-02-19 18:14:52.160935	0.00	0.00	0.00
112	M1-0219-0001	VENTA	\N	9	11000.00	0.00	0.00	0.00	11000.00	EFECTIVO	PAGADO	11000.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-02-19 18:11:00.498471	2026-02-19 18:19:58.579733	0.00	0.00	0.00
120	V0220-0001	VENTA	\N	9	9000.00	0.00	0.00	0.00	9000.00	EFECTIVO	PAGADO	9000.00	0.00	COMPLETADA		\N	\N	\N	2026-02-20 19:41:31.337081	2026-02-20 19:41:31.360578	0.00	0.00	0.00
114	M1-0219-0002	VENTA	\N	9	46000.00	0.00	0.00	0.00	46000.00	EFECTIVO	PAGADO	46000.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-02-19 18:20:19.987688	2026-02-19 18:24:00.08011	0.00	0.00	0.00
115	M3-0220-0001	VENTA	\N	1	33000.00	0.00	0.00	0.00	33000.00	\N	PENDIENTE	0.00	0.00	ANULADA	\N	\N	\N	Mesa liberada sin pedido	2026-02-20 00:10:27.052397	2026-02-20 12:35:17.59584	0.00	0.00	0.00
117	M1-0220-0002	VENTA	\N	1	0.00	0.00	0.00	0.00	0.00	\N	PENDIENTE	0.00	0.00	ANULADA	\N	\N	\N	Mesa liberada sin pedido	2026-02-20 19:24:20.699188	2026-02-20 19:44:36.277709	0.00	0.00	0.00
116	M1-0220-0001	VENTA	\N	1	30000.00	0.00	0.00	0.00	30000.00	\N	PENDIENTE	0.00	0.00	ANULADA	\N	\N	\N	Mesa liberada sin pedido	2026-02-20 12:28:28.757096	2026-02-20 12:36:10.728429	0.00	0.00	0.00
122	M11-0220-0001	VENTA	\N	1	16000.00	0.00	0.00	0.00	16000.00	\N	PENDIENTE	0.00	0.00	ANULADA	\N	\N	\N	Mesa liberada sin pedido	2026-02-20 19:56:15.492058	2026-02-20 20:07:13.331118	0.00	0.00	0.00
118	M3-0220-0002	VENTA	\N	1	0.00	0.00	0.00	0.00	0.00	\N	PENDIENTE	0.00	0.00	ANULADA	\N	\N	\N	Mesa liberada sin pedido	2026-02-20 19:24:21.301623	2026-02-20 19:45:34.348921	0.00	0.00	0.00
126	M7-0220-0001	VENTA	\N	9	8000.00	0.00	0.00	0.00	8000.00	EFECTIVO	PAGADO	8000.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-02-20 20:38:05.814889	2026-02-20 20:38:27.239475	0.00	0.00	0.00
125	M1-0220-0003	VENTA	\N	10	0.00	0.00	0.00	0.00	0.00	\N	PENDIENTE	0.00	0.00	ANULADA	\N	\N	\N	Mesa liberada sin pedido	2026-02-20 20:13:41.508639	2026-02-20 20:14:55.43264	0.00	0.00	0.00
124	M6-0220-0002	VENTA	\N	10	78000.00	0.00	0.00	0.00	78000.00	EFECTIVO	PAGADO	78000.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-02-20 20:07:06.44707	2026-02-20 21:12:51.619472	0.00	0.00	0.00
127	M8-0220-0001	VENTA	\N	9	5500.00	0.00	0.00	0.00	5500.00	EFECTIVO	PAGADO	5500.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-02-20 21:08:35.385746	2026-02-20 21:09:03.858981	0.00	0.00	0.00
128	M3-0220-0003	VENTA	\N	9	62500.00	0.00	0.00	0.00	62500.00	TRANSFERENCIA	PAGADO	62500.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-02-20 21:30:58.161125	2026-02-20 21:50:06.114466	0.00	0.00	0.00
123	M5-0220-0001	VENTA	\N	10	99000.00	0.00	0.00	0.00	99000.00	EFECTIVO	PAGADO	99000.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-02-20 20:04:25.198612	2026-02-20 20:37:45.41435	0.00	0.00	0.00
129	V0220-0002	VENTA	\N	9	139000.00	0.00	0.00	0.00	139000.00	TRANSFERENCIA	PAGADO	139000.00	0.00	ANULADA		9	2026-02-20 22:02:12.735778	prueba	2026-02-20 22:01:31.984974	2026-02-20 22:02:12.761168	0.00	0.00	0.00
130	M10-0220-0002	VENTA	\N	1	0.00	0.00	0.00	0.00	0.00	\N	PENDIENTE	0.00	0.00	ANULADA	\N	\N	\N	Mesa liberada sin pedido	2026-02-20 22:47:24.991159	2026-02-20 22:49:33.358748	0.00	0.00	0.00
131	V0221-0001	VENTA	\N	9	13000.00	0.00	1950.00	15.00	11050.00	EFECTIVO	PAGADO	11050.00	0.00	COMPLETADA		\N	\N	\N	2026-02-21 18:31:05.463167	2026-02-21 18:31:05.874628	0.00	0.00	0.00
132	V0221-0002	VENTA	\N	9	60000.00	0.00	9000.00	15.00	51000.00	EFECTIVO	PAGADO	60000.00	9000.00	ANULADA		9	2026-02-21 19:32:00.319042	prueba	2026-02-21 19:31:45.358768	2026-02-21 19:32:00.329116	0.00	0.00	0.00
133	V0221-0003	VENTA	\N	9	60000.00	0.00	0.00	0.00	60000.00	EFECTIVO	PAGADO	60000.00	0.00	COMPLETADA		\N	\N	\N	2026-02-21 19:32:44.494806	2026-02-21 19:32:44.656819	0.00	0.00	0.00
158	M3-0222-0005	VENTA	\N	9	70000.00	0.00	0.00	0.00	70000.00	EFECTIVO	PAGADO	70000.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-02-22 22:29:36.514063	2026-02-22 23:09:59.227212	0.00	0.00	0.00
150	M10-0222-0004	VENTA	\N	1	0.00	0.00	0.00	0.00	0.00	\N	PENDIENTE	0.00	0.00	ANULADA	\N	\N	\N	Mesa liberada sin pedido	2026-02-22 19:21:17.672617	2026-02-22 19:31:12.5921	0.00	0.00	0.00
143	V0222-0001	VENTA	\N	9	113000.00	0.00	0.00	0.00	116000.00	TRANSFERENCIA	PAGADO	116000.00	0.00	COMPLETADA		\N	\N	\N	2026-02-22 17:42:42.000471	2026-02-22 17:42:42.07209	0.00	0.00	3000.00
146	M2-0222-0002	VENTA	\N	9	15600.00	0.00	0.00	0.00	15600.00	TRANSFERENCIA	PAGADO	15600.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-02-22 18:58:56.666411	2026-02-22 19:36:45.25427	0.00	0.00	0.00
151	V0222-0002	VENTA	\N	1	26000.00	0.00	0.00	0.00	26000.00	TRANSFERENCIA	PAGADO	26000.00	0.00	COMPLETADA		\N	\N	\N	2026-02-22 19:37:31.555179	2026-02-22 19:37:31.56777	0.00	0.00	0.00
152	V0222-0003	VENTA	\N	9	17000.00	0.00	0.00	0.00	17000.00	EFECTIVO	PAGADO	17000.00	0.00	COMPLETADA		\N	\N	\N	2026-02-22 20:16:44.429996	2026-02-22 20:16:44.450093	0.00	0.00	0.00
140	M1-0222-0001	VENTA	\N	1	0.00	0.00	0.00	0.00	0.00	\N	PENDIENTE	0.00	0.00	ANULADA	\N	\N	\N	Mesa liberada sin pedido	2026-02-22 02:20:45.516523	2026-02-22 18:49:23.422876	0.00	0.00	0.00
141	M2-0222-0001	VENTA	\N	1	0.00	0.00	0.00	0.00	0.00	\N	PENDIENTE	0.00	0.00	ANULADA	\N	\N	\N	Mesa liberada sin pedido	2026-02-22 02:21:02.00398	2026-02-22 18:49:28.422998	0.00	0.00	0.00
144	M10-0222-0003	VENTA	\N	9	9000.00	0.00	1350.00	15.00	11415.00	TRANSFERENCIA	PAGADO	11550.00	135.00	ANULADA	\N	9	2026-02-22 18:54:48.310522	prueba\n	2026-02-22 18:49:48.876327	2026-02-22 18:54:48.318899	10.00	765.00	3000.00
139	M10-0222-0002	VENTA	\N	1	47000.00	0.00	0.00	0.00	54700.00	EFECTIVO	PAGADO	81700.00	27000.00	ANULADA	\N	9	2026-02-22 18:55:36.395965	prueba	2026-02-22 01:33:24.936945	2026-02-22 18:55:36.400598	10.00	4700.00	3000.00
134	M10-0221-0001	VENTA	\N	1	0.00	0.00	0.00	0.00	0.00	\N	PENDIENTE	0.00	0.00	ANULADA	\N	\N	\N	Mesa liberada sin pedido	2026-02-21 23:56:11.687545	2026-02-22 00:15:16.284485	0.00	0.00	0.00
166	V0225-0003	VENTA	\N	9	56000.00	0.00	0.00	0.00	59000.00	EFECTIVO	PAGADO	59000.00	0.00	COMPLETADA		\N	\N	\N	2026-02-25 18:46:48.043633	2026-02-25 18:46:48.08021	0.00	0.00	3000.00
136	M8-0222-0002	VENTA	\N	1	0.00	0.00	0.00	0.00	0.00	\N	PENDIENTE	0.00	0.00	ANULADA	\N	\N	\N	Mesa liberada sin pedido	2026-02-22 00:13:58.288522	2026-02-22 00:15:25.910764	0.00	0.00	0.00
135	M8-0222-0001	VENTA	\N	1	60000.00	0.00	0.00	0.00	69000.00	EFECTIVO	PAGADO	69000.00	0.00	ANULADA	\N	1	2026-02-22 00:17:10.869841	prueba	2026-02-22 00:10:50.473102	2026-02-22 00:17:10.977785	10.00	6000.00	3000.00
147	M6-0222-0001	VENTA	\N	9	26000.00	0.00	0.00	0.00	26000.00	EFECTIVO	PAGADO	26000.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-02-22 19:02:27.649071	2026-02-22 19:03:11.888296	0.00	0.00	0.00
145	M3-0222-0002	VENTA	\N	9	68000.00	0.00	0.00	0.00	68000.00	EFECTIVO	PAGADO	100000.00	32000.00	COMPLETADA	\N	\N	\N	\N	2026-02-22 18:58:26.16644	2026-02-22 19:05:35.244914	0.00	0.00	0.00
137	M10-0222-0001	VENTA	\N	1	0.00	0.00	0.00	0.00	0.00	\N	PENDIENTE	0.00	0.00	ANULADA	\N	\N	\N	Mesa liberada sin pedido	2026-02-22 00:35:18.724646	2026-02-22 01:33:15.434276	0.00	0.00	0.00
160	V0223-0001	VENTA	\N	9	109000.00	0.00	10900.00	10.00	98100.00	EFECTIVO	PAGADO	98100.00	0.00	COMPLETADA		\N	\N	\N	2026-02-23 20:37:40.22051	2026-02-23 20:37:40.279185	0.00	0.00	0.00
153	M6-0222-0002	VENTA	\N	9	49000.00	0.00	0.00	0.00	49000.00	EFECTIVO	PAGADO	49000.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-02-22 20:28:28.685945	2026-02-22 21:16:32.848853	0.00	0.00	0.00
138	M8-0222-0003	VENTA	\N	1	0.00	0.00	0.00	0.00	0.00	\N	PENDIENTE	0.00	0.00	ANULADA	\N	\N	\N	Mesa liberada sin pedido	2026-02-22 01:00:54.624109	2026-02-22 01:33:21.123404	0.00	0.00	0.00
155	M7-0222-0001	VENTA	\N	9	57000.00	0.00	0.00	0.00	57000.00	EFECTIVO	PAGADO	57000.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-02-22 21:12:58.16803	2026-02-22 21:25:52.888303	0.00	0.00	0.00
149	M4-0222-0001	VENTA	\N	10	0.00	0.00	0.00	0.00	0.00	\N	PENDIENTE	0.00	0.00	ANULADA	\N	\N	\N	Mesa liberada sin pedido	2026-02-22 19:17:50.839594	2026-02-22 19:30:47.858497	0.00	0.00	0.00
148	M3-0222-0003	VENTA	\N	10	0.00	0.00	0.00	0.00	0.00	\N	PENDIENTE	0.00	0.00	ANULADA	\N	\N	\N	Mesa liberada sin pedido	2026-02-22 19:10:57.742824	2026-02-22 19:30:54.786723	0.00	0.00	0.00
161	V0223-0002	VENTA	\N	9	47000.00	0.00	0.00	0.00	47000.00	TRANSFERENCIA	PAGADO	47000.00	0.00	COMPLETADA		\N	\N	\N	2026-02-23 22:33:12.639416	2026-02-23 22:33:12.734957	0.00	0.00	0.00
162	V0223-0003	VENTA	\N	9	19000.00	0.00	0.00	0.00	19000.00	EFECTIVO	PAGADO	19000.00	0.00	COMPLETADA		\N	\N	\N	2026-02-23 22:34:12.770708	2026-02-23 22:34:12.791355	0.00	0.00	0.00
154	M3-0222-0004	VENTA	\N	10	56000.00	0.00	0.00	0.00	56000.00	TRANSFERENCIA	PAGADO	56000.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-02-22 21:01:56.284172	2026-02-22 22:12:00.160661	0.00	0.00	0.00
156	M4-0222-0002	VENTA	\N	9	75000.00	0.00	0.00	0.00	75000.00	EFECTIVO	PAGADO	75000.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-02-22 21:44:39.51042	2026-02-22 22:12:50.275723	0.00	0.00	0.00
159	M8-0223-0001	VENTA	\N	9	111000.00	0.00	0.00	0.00	114000.00	TRANSFERENCIA	PAGADO	114000.00	0.00	ANULADA	\N	9	2026-02-23 22:40:48.756262	ERROR	2026-02-23 18:54:24.566227	2026-02-23 22:40:48.765444	0.00	0.00	3000.00
157	M7-0222-0002	VENTA	\N	10	126000.00	0.00	0.00	0.00	126000.00	TRANSFERENCIA	PAGADO	126000.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-02-22 22:01:34.327833	2026-02-22 22:36:30.809719	0.00	0.00	0.00
165	V0225-0002	VENTA	\N	9	96000.00	0.00	0.00	0.00	96000.00	TRANSFERENCIA	PAGADO	96000.00	0.00	ANULADA		9	2026-02-25 19:01:44.301947	error	2026-02-25 18:45:37.582771	2026-02-25 19:01:44.317498	0.00	0.00	0.00
163	V0223-0004	VENTA	\N	9	111000.00	0.00	0.00	0.00	114000.00	EFECTIVO	PAGADO	114000.00	0.00	COMPLETADA		\N	\N	\N	2026-02-23 22:42:09.799689	2026-02-23 22:42:09.857877	0.00	0.00	3000.00
173	M3-0225-0002	VENTA	\N	9	45000.00	0.00	0.00	0.00	45000.00	TRANSFERENCIA	PAGADO	45000.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-02-25 20:31:13.080257	2026-02-25 21:24:15.452354	0.00	0.00	0.00
164	V0225-0001	VENTA	\N	9	84000.00	0.00	0.00	0.00	84000.00	TRANSFERENCIA	PAGADO	84000.00	0.00	ANULADA		9	2026-02-25 19:02:13.642643	error	2026-02-25 18:43:36.347271	2026-02-25 19:02:13.649008	0.00	0.00	0.00
167	V0225-0004	VENTA	\N	9	96000.00	0.00	0.00	0.00	96000.00	TRANSFERENCIA	PAGADO	96000.00	0.00	COMPLETADA		\N	\N	\N	2026-02-25 19:03:33.985746	2026-02-25 19:03:34.053199	0.00	0.00	0.00
169	V0225-0005	VENTA	\N	9	62500.00	0.00	0.00	0.00	62500.00	EFECTIVO	PAGADO	62500.00	0.00	COMPLETADA		\N	\N	\N	2026-02-25 19:28:51.832451	2026-02-25 19:28:51.97921	0.00	0.00	0.00
168	M8-0225-0001	VENTA	\N	9	120500.00	0.00	0.00	0.00	120500.00	EFECTIVO	PAGADO	120500.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-02-25 19:06:46.756925	2026-02-25 19:31:12.407848	0.00	0.00	0.00
172	M3-0225-0001	VENTA	\N	9	0.00	0.00	0.00	0.00	0.00	\N	PENDIENTE	0.00	0.00	ANULADA	\N	\N	\N	Mesa liberada sin pedido	2026-02-25 20:29:55.378989	2026-02-25 20:30:01.264284	0.00	0.00	0.00
171	M6-0225-0001	VENTA	\N	9	70600.00	0.00	0.00	0.00	70600.00	TRANSFERENCIA	PAGADO	70600.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-02-25 19:58:51.954586	2026-02-25 20:32:19.603701	0.00	0.00	0.00
170	M7-0225-0001	VENTA	\N	9	68000.00	0.00	0.00	0.00	68000.00	TRANSFERENCIA	PAGADO	68000.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-02-25 19:54:51.878264	2026-02-25 20:33:15.637804	0.00	0.00	0.00
174	M8-0225-0002	VENTA	\N	9	26000.00	0.00	0.00	0.00	30000.00	TRANSFERENCIA	PAGADO	30000.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-02-25 21:34:49.771511	2026-02-25 21:45:00.313695	0.00	0.00	4000.00
175	M6-0226-0001	VENTA	\N	9	51500.00	0.00	0.00	0.00	51500.00	TRANSFERENCIA	PAGADO	51500.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-02-26 21:01:34.520783	2026-02-26 21:50:49.763321	0.00	0.00	0.00
176	V0226-0001	VENTA	\N	9	30000.00	0.00	4500.00	15.00	25500.00	TRANSFERENCIA	PAGADO	25500.00	0.00	COMPLETADA		\N	\N	\N	2026-02-26 21:01:51.112296	2026-02-26 21:01:51.133756	0.00	0.00	0.00
178	M8-0226-0001	VENTA	\N	9	33000.00	0.00	0.00	0.00	36000.00	EFECTIVO	PAGADO	36000.00	0.00	ANULADA	\N	9	2026-02-26 21:56:38.368508	error	2026-02-26 21:52:13.915715	2026-02-26 21:56:38.380292	0.00	0.00	3000.00
177	M3-0226-0001	VENTA	\N	9	71000.00	0.00	0.00	0.00	71000.00	TRANSFERENCIA	PAGADO	71000.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-02-26 21:23:35.03546	2026-02-26 22:00:52.921249	0.00	0.00	0.00
179	V0226-0002	VENTA	\N	9	33000.00	0.00	0.00	0.00	36000.00	TRANSFERENCIA	PAGADO	36000.00	0.00	COMPLETADA		\N	\N	\N	2026-02-26 22:03:59.399835	2026-02-26 22:03:59.4442	0.00	0.00	3000.00
180	M8-0226-0002	VENTA	\N	9	17000.00	0.00	0.00	0.00	17000.00	EFECTIVO	PAGADO	17000.00	0.00	ANULADA	\N	9	2026-02-26 22:25:08.32333	error	2026-02-26 22:11:32.233261	2026-02-26 22:25:08.328995	0.00	0.00	0.00
181	V0226-0003	VENTA	\N	9	17000.00	0.00	0.00	0.00	17000.00	TRANSFERENCIA	PAGADO	17000.00	0.00	COMPLETADA		\N	\N	\N	2026-02-26 22:25:15.851872	2026-02-26 22:25:15.869943	0.00	0.00	0.00
191	M8-0227-0002	VENTA	\N	9	25000.00	0.00	0.00	0.00	30000.00	TRANSFERENCIA	PAGADO	30000.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-02-27 22:50:01.011958	2026-02-27 22:54:51.175629	0.00	0.00	5000.00
182	M6-0227-0001	VENTA	\N	9	45500.00	0.00	0.00	0.00	45500.00	EFECTIVO	PAGADO	45500.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-02-27 18:38:32.463451	2026-02-27 18:47:23.960822	0.00	0.00	0.00
186	M7-0227-0002	VENTA	\N	9	56000.00	0.00	0.00	0.00	56000.00	TRANSFERENCIA	PAGADO	56000.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-02-27 20:59:24.03355	2026-02-27 23:16:52.483535	0.00	0.00	0.00
183	M7-0227-0001	VENTA	\N	9	115000.00	0.00	0.00	0.00	126500.00	EFECTIVO	PAGADO	126500.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-02-27 19:43:49.57715	2026-02-27 19:59:19.312103	10.00	11500.00	0.00
193	V0227-0001	VENTA	\N	9	65800.00	0.00	0.00	0.00	72380.00	TRANSFERENCIA	PAGADO	72380.00	0.00	COMPLETADA		\N	\N	\N	2026-02-27 23:20:46.233109	2026-02-27 23:20:46.296189	10.00	6580.00	0.00
184	M6-0227-0002	VENTA	\N	10	65800.00	0.00	0.00	0.00	72380.00	EFECTIVO	PAGADO	72380.00	0.00	ANULADA	\N	9	2026-02-27 23:20:59.303301	ERROR	2026-02-27 20:16:08.746351	2026-02-27 23:20:59.314948	10.00	6580.00	0.00
185	M8-0227-0001	VENTA	\N	9	30000.00	0.00	0.00	0.00	30000.00	EFECTIVO	PAGADO	30000.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-02-27 20:37:29.142639	2026-02-27 20:41:34.889867	0.00	0.00	0.00
192	M5-0227-0001	VENTA	\N	9	57000.00	0.00	0.00	0.00	57000.00	TRANSFERENCIA	PAGADO	57000.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-02-27 22:50:48.500649	2026-02-27 23:59:46.099384	0.00	0.00	0.00
194	V0228-0001	VENTA	\N	9	8000.00	0.00	0.00	0.00	8000.00	EFECTIVO	PAGADO	20000.00	12000.00	COMPLETADA		\N	\N	\N	2026-02-28 17:15:26.235712	2026-02-28 17:15:26.296299	0.00	0.00	0.00
202	M8-0228-0002	VENTA	\N	1	118000.00	0.00	0.00	0.00	121000.00	TRANSFERENCIA	PAGADO	121000.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-02-28 19:29:36.169552	2026-02-28 19:32:53.451216	0.00	0.00	3000.00
187	M4-0227-0001	VENTA	\N	9	0.00	0.00	0.00	0.00	0.00	\N	PENDIENTE	0.00	0.00	ANULADA	\N	\N	\N	Mesa liberada sin pedido	2026-02-27 21:57:54.022641	2026-02-27 22:00:00.12486	0.00	0.00	0.00
201	M10-0228-0001	VENTA	\N	1	38000.00	0.00	0.00	0.00	41000.00	EFECTIVO	PAGADO	68000.00	27000.00	COMPLETADA	\N	\N	\N	\N	2026-02-28 19:13:59.396677	2026-02-28 19:36:36.804604	0.00	0.00	3000.00
205	M5-0228-0003	VENTA	\N	1	104000.00	0.00	0.00	0.00	104000.00	EFECTIVO	PAGADO	150000.00	46000.00	COMPLETADA	\N	\N	\N	\N	2026-02-28 20:35:45.415635	2026-02-28 21:23:49.269506	0.00	0.00	0.00
199	M3-0228-0001	VENTA	\N	10	88000.00	0.00	0.00	0.00	88000.00	TRANSFERENCIA	PAGADO	88000.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-02-28 18:47:43.887572	2026-02-28 19:40:52.242798	0.00	0.00	0.00
190	M6-0227-0003	VENTA	\N	9	111000.00	0.00	0.00	0.00	111000.00	TRANSFERENCIA	PAGADO	111000.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-02-27 22:02:03.238702	2026-02-27 22:16:20.358281	0.00	0.00	0.00
188	M3-0227-0001	VENTA	\N	9	82000.00	0.00	0.00	0.00	82000.00	EFECTIVO	PAGADO	100000.00	18000.00	COMPLETADA	\N	\N	\N	\N	2026-02-27 21:59:40.830309	2026-02-27 22:18:24.611654	0.00	0.00	0.00
189	M4-0227-0002	VENTA	\N	9	92500.00	0.00	0.00	0.00	92500.00	EFECTIVO	PAGADO	100000.00	7500.00	COMPLETADA	\N	\N	\N	\N	2026-02-27 22:01:08.493696	2026-02-27 22:25:46.601343	0.00	0.00	0.00
214	M8-0228-0004	VENTA	\N	1	0.00	0.00	0.00	0.00	0.00	\N	PENDIENTE	0.00	0.00	ANULADA	\N	\N	\N	Mesa liberada sin pedido	2026-02-28 22:29:18.689859	2026-02-28 23:29:32.483282	0.00	0.00	0.00
195	M5-0228-0001	VENTA	\N	10	88500.00	0.00	0.00	0.00	88500.00	EFECTIVO	PAGADO	100000.00	11500.00	COMPLETADA	\N	\N	\N	\N	2026-02-28 17:29:48.136172	2026-02-28 18:30:45.695139	0.00	0.00	0.00
213	M6-0228-0003	VENTA	\N	1	71000.00	0.00	0.00	0.00	78100.00	TRANSFERENCIA	PAGADO	78100.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-02-28 21:58:06.433538	2026-02-28 22:52:45.211664	10.00	7100.00	0.00
196	M6-0228-0001	VENTA	\N	1	96500.00	0.00	0.00	0.00	96500.00	TRANSFERENCIA	PAGADO	96500.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-02-28 18:11:19.969266	2026-02-28 19:57:48.75505	0.00	0.00	0.00
197	M7-0228-0001	VENTA	\N	1	105000.00	0.00	0.00	0.00	105000.00	EFECTIVO	PAGADO	120000.00	15000.00	COMPLETADA	\N	\N	\N	\N	2026-02-28 18:17:03.245629	2026-02-28 19:05:30.047659	0.00	0.00	0.00
206	M6-0228-0002	VENTA	\N	1	88000.00	0.00	0.00	0.00	88000.00	TRANSFERENCIA	PAGADO	88000.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-02-28 21:04:33.819384	2026-02-28 21:47:37.238576	0.00	0.00	0.00
198	M8-0228-0001	VENTA	\N	9	25000.00	0.00	0.00	0.00	25000.00	TRANSFERENCIA	PAGADO	28000.00	3000.00	COMPLETADA	\N	\N	\N	\N	2026-02-28 18:40:33.952153	2026-02-28 19:17:20.512372	0.00	0.00	0.00
200	M5-0228-0002	VENTA	\N	10	49600.00	0.00	0.00	0.00	49600.00	TRANSFERENCIA	PAGADO	49600.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-02-28 18:49:39.417391	2026-02-28 19:24:42.755153	0.00	0.00	0.00
203	M8-0228-0003	VENTA	\N	1	59000.00	0.00	0.00	0.00	59000.00	EFECTIVO	PAGADO	59000.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-02-28 19:51:32.892601	2026-02-28 20:17:13.885668	0.00	0.00	0.00
210	M4-0228-0001	VENTA	\N	1	274000.00	0.00	0.00	0.00	274000.00	EFECTIVO	PAGADO	300000.00	26000.00	COMPLETADA	\N	\N	\N	\N	2026-02-28 21:50:36.892167	2026-02-28 22:50:27.003	0.00	0.00	0.00
204	M7-0228-0002	VENTA	\N	10	88000.00	0.00	0.00	0.00	88000.00	EFECTIVO	PAGADO	100000.00	12000.00	COMPLETADA	\N	\N	\N	\N	2026-02-28 20:10:17.534727	2026-02-28 20:47:55.640141	0.00	0.00	0.00
215	M1-0228-0002	VENTA	\N	1	93000.00	0.00	0.00	0.00	102300.00	TRANSFERENCIA	PAGADO	102300.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-02-28 22:46:15.745423	2026-02-28 23:20:02.03984	10.00	9300.00	0.00
207	M7-0228-0003	VENTA	\N	1	112000.00	0.00	0.00	0.00	123200.00	EFECTIVO	PAGADO	124000.00	800.00	COMPLETADA	\N	\N	\N	\N	2026-02-28 21:31:52.683032	2026-02-28 22:06:29.827522	10.00	11200.00	0.00
209	M3-0228-0002	VENTA	\N	1	70000.00	0.00	0.00	0.00	70000.00	EFECTIVO	PAGADO	100000.00	30000.00	COMPLETADA	\N	\N	\N	\N	2026-02-28 21:49:38.296702	2026-02-28 22:36:00.34126	0.00	0.00	0.00
212	M1-0228-0001	VENTA	\N	1	52000.00	0.00	0.00	0.00	52000.00	TRANSFERENCIA	PAGADO	52000.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-02-28 21:54:13.51146	2026-02-28 22:44:26.729956	0.00	0.00	0.00
208	M2-0228-0001	VENTA	\N	1	86000.00	0.00	0.00	0.00	86000.00	EFECTIVO	PAGADO	100000.00	14000.00	COMPLETADA	\N	\N	\N	\N	2026-02-28 21:39:59.889866	2026-02-28 22:45:25.278403	0.00	0.00	0.00
211	M5-0228-0004	VENTA	\N	1	108000.00	0.00	0.00	0.00	118800.00	TRANSFERENCIA	PAGADO	118800.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-02-28 21:52:53.631351	2026-02-28 22:51:55.504351	10.00	10800.00	0.00
217	M9-0228-0001	VENTA	\N	1	30000.00	0.00	0.00	0.00	30000.00	EFECTIVO	PAGADO	30000.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-02-28 23:02:59.189242	2026-02-28 23:11:14.796577	0.00	0.00	0.00
216	M3-0228-0003	VENTA	\N	1	84000.00	0.00	0.00	0.00	92400.00	TRANSFERENCIA	PAGADO	92400.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-02-28 22:53:05.723897	2026-02-28 23:19:01.299196	10.00	8400.00	0.00
218	M6-0228-0004	VENTA	\N	1	67000.00	0.00	0.00	0.00	73700.00	TRANSFERENCIA	PAGADO	73700.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-02-28 23:20:21.00351	2026-02-28 23:56:53.762072	10.00	6700.00	0.00
219	M8-0228-0005	VENTA	\N	1	10000.00	0.00	0.00	0.00	10000.00	TRANSFERENCIA	PAGADO	10000.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-02-28 23:29:48.967217	2026-02-28 23:30:20.283012	0.00	0.00	0.00
220	M6-0301-0001	VENTA	\N	10	66300.00	0.00	0.00	0.00	66300.00	EFECTIVO	PAGADO	70000.00	3700.00	COMPLETADA	\N	\N	\N	\N	2026-03-01 18:41:05.85533	2026-03-01 19:33:05.29784	0.00	0.00	0.00
221	M5-0301-0001	VENTA	\N	1	30000.00	0.00	0.00	0.00	30000.00	EFECTIVO	PAGADO	30000.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-03-01 19:20:55.689589	2026-03-01 19:30:56.266036	0.00	0.00	0.00
222	M3-0301-0001	VENTA	\N	10	76000.00	0.00	0.00	0.00	83600.00	EFECTIVO	PAGADO	100000.00	16400.00	COMPLETADA	\N	\N	\N	\N	2026-03-01 19:23:22.161441	2026-03-01 20:15:51.298584	10.00	7600.00	0.00
251	M6-0304-0001	VENTA	\N	1	59000.00	0.00	0.00	0.00	59000.00	EFECTIVO	PAGADO	70000.00	11000.00	COMPLETADA	\N	\N	\N	\N	2026-03-04 19:46:31.962826	2026-03-04 20:34:21.716009	0.00	0.00	0.00
252	M7-0304-0001	VENTA	\N	10	85000.00	0.00	0.00	0.00	85000.00	EFECTIVO	PAGADO	85000.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-03-04 20:04:28.959983	2026-03-04 21:19:21.987017	0.00	0.00	0.00
254	V0304-0002	VENTA	\N	1	23000.00	0.00	0.00	0.00	23000.00	EFECTIVO	PAGADO	23000.00	0.00	COMPLETADA		\N	\N	\N	2026-03-04 22:21:58.976827	2026-03-04 22:21:59.011985	0.00	0.00	0.00
280	M3-0307-0002	VENTA	\N	1	33000.00	0.00	0.00	0.00	33000.00	EFECTIVO	PAGADO	33000.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-03-07 22:34:37.106152	2026-03-07 22:35:00.771956	0.00	0.00	0.00
256	M5-0305-0001	VENTA	\N	1	87000.00	0.00	0.00	0.00	87000.00	TRANSFERENCIA	PAGADO	87000.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-03-05 19:52:29.057409	2026-03-05 20:48:35.309278	0.00	0.00	0.00
231	M5-0301-0002	VENTA	\N	1	59000.00	0.00	0.00	0.00	59000.00	EFECTIVO	PAGADO	59000.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-03-01 20:50:41.724557	2026-03-01 21:55:55.002058	0.00	0.00	0.00
232	M5-0301-0003	VENTA	\N	1	15000.00	0.00	0.00	0.00	15000.00	TRANSFERENCIA	PAGADO	15000.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-03-01 21:55:59.970471	2026-03-01 22:31:33.497124	0.00	0.00	0.00
258	V0306-0002	VENTA	\N	1	7800.00	0.00	0.00	0.00	7800.00	TRANSFERENCIA	PAGADO	7800.00	0.00	COMPLETADA		\N	\N	\N	2026-03-06 20:28:00.802877	2026-03-06 20:28:00.829861	0.00	0.00	0.00
223	M4-0301-0001	VENTA	\N	1	489500.00	0.00	0.00	0.00	489500.00	TRANSFERENCIA	PAGADO	489500.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-03-01 19:23:27.105457	2026-03-01 23:06:45.317144	0.00	0.00	0.00
234	M5-0301-0004	VENTA	\N	1	45500.00	0.00	0.00	0.00	50050.00	EFECTIVO	PAGADO	50050.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-03-01 23:01:30.754144	2026-03-01 23:44:36.059005	10.00	4550.00	0.00
260	V0306-0004	VENTA	\N	1	26000.00	0.00	3900.00	15.00	22100.00	TRANSFERENCIA	PAGADO	22100.00	0.00	COMPLETADA		\N	\N	\N	2026-03-06 23:03:59.939469	2026-03-06 23:03:59.957979	0.00	0.00	0.00
236	V0302-0001	VENTA	\N	1	14000.00	0.00	2100.00	15.00	11900.00	EFECTIVO	PAGADO	11900.00	0.00	ANULADA		1	2026-03-02 18:06:18.59882	error	2026-03-02 18:05:18.33356	2026-03-02 18:06:18.607661	0.00	0.00	0.00
273	M8-0307-0002	VENTA	\N	1	64000.00	0.00	0.00	0.00	64000.00	EFECTIVO	PAGADO	67000.00	3000.00	COMPLETADA	\N	\N	\N	\N	2026-03-07 21:08:58.36435	2026-03-07 21:09:46.816426	0.00	0.00	0.00
262	M9-0307-0001	VENTA	\N	1	64000.00	0.00	0.00	0.00	69000.00	TRANSFERENCIA	PAGADO	69000.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-03-07 18:58:49.461503	2026-03-07 19:07:59.839302	0.00	0.00	5000.00
279	M7-0307-0002	VENTA	\N	1	118000.00	0.00	0.00	0.00	118000.00	EFECTIVO	PAGADO	118000.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-03-07 22:32:39.9268	2026-03-07 22:36:20.636993	0.00	0.00	0.00
238	M4-0302-0001	VENTA	\N	1	114000.00	0.00	0.00	0.00	114000.00	EFECTIVO	PAGADO	114000.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-03-02 18:56:46.840736	2026-03-02 21:12:04.386714	0.00	0.00	0.00
267	M4-0307-0001	VENTA	\N	1	100000.00	0.00	0.00	0.00	100000.00	TRANSFERENCIA	PAGADO	100000.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-03-07 19:39:46.390604	2026-03-07 21:28:33.226395	0.00	0.00	0.00
247	V0302-0005	VENTA	\N	1	100000.00	0.00	0.00	0.00	110000.00	EFECTIVO	PAGADO	110000.00	0.00	COMPLETADA		\N	\N	\N	2026-03-02 21:46:10.727326	2026-03-02 21:46:10.805232	10.00	10000.00	0.00
241	M5-0302-0001	VENTA	\N	10	83000.00	0.00	0.00	0.00	83000.00	TRANSFERENCIA	PAGADO	83000.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-03-02 20:49:58.833379	2026-03-02 21:47:46.475442	0.00	0.00	0.00
243	M3-0302-0001	VENTA	\N	1	48000.00	0.00	0.00	0.00	48000.00	EFECTIVO	PAGADO	48000.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-03-02 21:25:02.650531	2026-03-02 21:56:07.467128	0.00	0.00	0.00
275	M2-0307-0001	VENTA	\N	1	92000.00	0.00	0.00	0.00	92000.00	EFECTIVO	PAGADO	102000.00	10000.00	COMPLETADA	\N	\N	\N	\N	2026-03-07 22:04:49.708848	2026-03-07 23:11:03.439515	0.00	0.00	0.00
249	M1-0304-0001	VENTA	\N	1	53500.00	0.00	0.00	0.00	53500.00	EFECTIVO	PAGADO	53500.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-03-04 18:09:01.227013	2026-03-04 18:59:38.780417	0.00	0.00	0.00
281	M3-0307-0003	VENTA	\N	1	33000.00	0.00	0.00	0.00	33000.00	EFECTIVO	PAGADO	50000.00	17000.00	COMPLETADA	\N	\N	\N	\N	2026-03-07 22:38:59.049254	2026-03-07 22:39:32.746008	0.00	0.00	0.00
292	M3-0307-0010	VENTA	\N	1	104000.00	0.00	0.00	0.00	104000.00	EFECTIVO	PAGADO	104000.00	0.00	ANULADA	\N	1	2026-03-07 23:26:44.588417	error	2026-03-07 23:23:54.004488	2026-03-07 23:26:44.594462	0.00	0.00	0.00
277	M4-0307-0002	VENTA	\N	1	141000.00	0.00	0.00	0.00	155100.00	TRANSFERENCIA	PAGADO	155100.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-03-07 22:23:55.918528	2026-03-07 22:26:02.975427	10.00	14100.00	0.00
284	M3-0307-0006	VENTA	\N	1	56000.00	0.00	0.00	0.00	56000.00	TRANSFERENCIA	PAGADO	56000.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-03-07 22:44:36.508998	2026-03-07 22:45:45.349178	0.00	0.00	0.00
266	M7-0307-0001	VENTA	\N	1	203000.00	0.00	0.00	0.00	203000.00	TRANSFERENCIA	PAGADO	203000.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-03-07 19:27:05.638402	2026-03-07 19:43:12.255391	0.00	0.00	0.00
278	M8-0307-0003	VENTA	\N	1	30000.00	0.00	0.00	0.00	30000.00	EFECTIVO	PAGADO	30000.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-03-07 22:27:16.733354	2026-03-07 22:30:40.268531	0.00	0.00	0.00
265	M8-0307-0001	VENTA	\N	1	0.00	0.00	0.00	0.00	0.00	\N	PENDIENTE	0.00	0.00	ANULADA	\N	\N	\N	Mesa liberada sin pedido	2026-03-07 19:25:29.293502	2026-03-07 20:48:57.627814	0.00	0.00	0.00
269	M9-0307-0002	VENTA	\N	1	135000.00	0.00	0.00	0.00	140000.00	TRANSFERENCIA	PAGADO	140000.00	0.00	ANULADA	\N	1	2026-03-07 20:53:42.95033	error	2026-03-07 19:52:36.066719	2026-03-07 20:53:42.956559	0.00	0.00	5000.00
271	M9-0307-0004	VENTA	\N	1	207000.00	0.00	0.00	0.00	207000.00	TRANSFERENCIA	PAGADO	207000.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-03-07 20:29:13.117712	2026-03-07 20:54:00.442472	0.00	0.00	0.00
291	M4-0307-0005	VENTA	\N	1	0.00	0.00	0.00	0.00	0.00	\N	PENDIENTE	0.00	0.00	ANULADA	\N	\N	\N	Mesa liberada sin pedido	2026-03-07 23:20:09.195798	2026-03-07 23:26:58.081975	0.00	0.00	0.00
289	M3-0307-0009	VENTA	\N	1	0.00	0.00	0.00	0.00	0.00	\N	PENDIENTE	0.00	0.00	ANULADA	\N	\N	\N	Mesa liberada sin pedido	2026-03-07 23:08:51.446074	2026-03-07 23:16:36.811373	0.00	0.00	0.00
288	M4-0307-0003	VENTA	\N	1	67000.00	0.00	0.00	0.00	67000.00	TRANSFERENCIA	PAGADO	67000.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-03-07 22:56:04.137254	2026-03-07 22:57:52.62597	0.00	0.00	0.00
283	M3-0307-0005	VENTA	\N	1	106000.00	0.00	0.00	0.00	106000.00	TRANSFERENCIA	PAGADO	106000.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-03-07 22:42:53.092867	2026-03-07 22:44:04.16212	0.00	0.00	0.00
286	M7-0307-0003	VENTA	\N	1	55000.00	0.00	0.00	0.00	55000.00	TRANSFERENCIA	PAGADO	55000.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-03-07 22:50:40.74576	2026-03-07 22:58:32.521573	0.00	0.00	0.00
287	M3-0307-0008	VENTA	\N	1	53000.00	0.00	0.00	0.00	53000.00	TRANSFERENCIA	PAGADO	53000.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-03-07 22:52:57.986433	2026-03-07 23:03:16.058162	0.00	0.00	0.00
294	M7-0307-0004	VENTA	\N	1	0.00	0.00	0.00	0.00	0.00	\N	PENDIENTE	0.00	0.00	ANULADA	\N	\N	\N	Mesa liberada sin pedido	2026-03-07 23:29:16.320818	2026-03-07 23:30:37.180404	0.00	0.00	0.00
298	V0308-0001	VENTA	\N	1	34000.00	0.00	0.00	0.00	34000.00	TRANSFERENCIA	PAGADO	34000.00	0.00	COMPLETADA		\N	\N	\N	2026-03-08 18:59:05.930437	2026-03-08 18:59:06.017155	0.00	0.00	0.00
296	M7-0307-0005	VENTA	\N	1	96500.00	0.00	0.00	0.00	96500.00	EFECTIVO	PAGADO	100000.00	3500.00	COMPLETADA	\N	\N	\N	\N	2026-03-07 23:32:10.75914	2026-03-07 23:41:20.802934	0.00	0.00	0.00
299	M3-0308-0001	VENTA	\N	1	82000.00	0.00	0.00	0.00	82000.00	TRANSFERENCIA	PAGADO	82000.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-03-08 18:59:30.799691	2026-03-08 19:03:47.126984	0.00	0.00	0.00
301	M8-0308-0001	VENTA	\N	1	38000.00	0.00	0.00	0.00	38000.00	EFECTIVO	PAGADO	38000.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-03-08 19:16:51.443507	2026-03-08 19:24:27.885311	0.00	0.00	0.00
303	M3-0308-0002	VENTA	\N	1	103500.00	0.00	0.00	0.00	103500.00	EFECTIVO	PAGADO	120000.00	16500.00	COMPLETADA	\N	\N	\N	\N	2026-03-08 19:26:10.185376	2026-03-08 19:43:37.907222	0.00	0.00	0.00
305	M2-0308-0001	VENTA	\N	1	96000.00	0.00	0.00	0.00	96000.00	EFECTIVO	PAGADO	102000.00	6000.00	COMPLETADA	\N	\N	\N	\N	2026-03-08 19:39:38.585663	2026-03-08 20:29:55.834172	0.00	0.00	0.00
226	M2-0301-0001	VENTA	\N	1	67000.00	0.00	0.00	0.00	73700.00	EFECTIVO	PAGADO	80000.00	6300.00	COMPLETADA	\N	\N	\N	\N	2026-03-01 19:55:41.702191	2026-03-01 20:53:47.403106	10.00	6700.00	0.00
228	M1-0301-0001	VENTA	\N	10	88000.00	0.00	0.00	0.00	88000.00	EFECTIVO	PAGADO	100000.00	12000.00	COMPLETADA	\N	\N	\N	\N	2026-03-01 20:18:10.771453	2026-03-01 21:01:22.776836	0.00	0.00	0.00
229	M6-0301-0003	VENTA	\N	1	89000.00	0.00	0.00	0.00	97900.00	TRANSFERENCIA	PAGADO	97900.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-03-01 20:30:55.052887	2026-03-01 21:06:29.191397	10.00	8900.00	0.00
293	M3-0307-0011	VENTA	\N	1	66000.00	0.00	0.00	0.00	66000.00	EFECTIVO	PAGADO	70000.00	4000.00	COMPLETADA	\N	\N	\N	\N	2026-03-07 23:27:02.210645	2026-03-07 23:28:29.503191	0.00	0.00	0.00
270	M9-0307-0003	VENTA	\N	1	32000.00	0.00	0.00	0.00	35000.00	TRANSFERENCIA	PAGADO	35000.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-03-07 20:03:04.226666	2026-03-07 20:04:03.948526	0.00	0.00	3000.00
224	M6-0301-0002	VENTA	\N	10	0.00	0.00	0.00	0.00	0.00	\N	PENDIENTE	0.00	0.00	ANULADA	\N	\N	\N	Mesa liberada sin pedido	2026-03-01 19:45:35.524744	2026-03-01 19:55:32.80095	0.00	0.00	0.00
230	M8-0301-0001	VENTA	\N	1	31000.00	0.00	4650.00	15.00	26350.00	EFECTIVO	PAGADO	31000.00	4650.00	COMPLETADA	\N	\N	\N	\N	2026-03-01 20:39:20.587661	2026-03-01 22:20:28.398573	0.00	0.00	0.00
233	M6-0301-0004	VENTA	\N	10	84000.00	0.00	0.00	0.00	84000.00	EFECTIVO	PAGADO	100000.00	16000.00	COMPLETADA	\N	\N	\N	\N	2026-03-01 22:02:49.531289	2026-03-01 22:40:46.41706	0.00	0.00	0.00
268	M6-0307-0001	VENTA	\N	1	0.00	0.00	0.00	0.00	0.00	\N	PENDIENTE	0.00	0.00	ANULADA	\N	\N	\N	Mesa liberada sin pedido	2026-03-07 19:46:06.351514	2026-03-07 22:18:05.979509	0.00	0.00	0.00
235	V0301-0001	VENTA	\N	1	20500.00	0.00	0.00	0.00	20500.00	EFECTIVO	PAGADO	20500.00	0.00	COMPLETADA		\N	\N	\N	2026-03-01 23:38:39.791794	2026-03-01 23:38:39.858979	0.00	0.00	0.00
225	M7-0301-0001	VENTA	\N	1	133800.00	0.00	0.00	0.00	147180.00	TRANSFERENCIA	PAGADO	147180.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-03-01 19:52:27.607993	2026-03-01 20:26:03.546279	10.00	13380.00	0.00
276	M3-0307-0001	VENTA	\N	1	68800.00	0.00	0.00	0.00	75680.00	EFECTIVO	PAGADO	75680.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-03-07 22:08:36.620633	2026-03-07 22:09:52.438042	10.00	6880.00	0.00
227	M9-0301-0001	VENTA	\N	1	22000.00	0.00	0.00	0.00	22000.00	TRANSFERENCIA	PAGADO	22000.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-03-01 20:05:58.433811	2026-03-01 20:37:22.739048	0.00	0.00	0.00
237	V0302-0002	VENTA	\N	1	14000.00	0.00	2100.00	15.00	11900.00	TRANSFERENCIA	PAGADO	14000.00	2100.00	COMPLETADA		\N	\N	\N	2026-03-02 18:05:52.060273	2026-03-02 18:05:52.088641	0.00	0.00	0.00
239	V0302-0003	VENTA	\N	1	10000.00	0.00	0.00	0.00	10000.00	EFECTIVO	PAGADO	10000.00	0.00	COMPLETADA		\N	\N	\N	2026-03-02 19:46:57.225296	2026-03-02 19:46:57.258191	0.00	0.00	0.00
240	V0302-0004	VENTA	\N	1	15000.00	0.00	2250.00	15.00	12750.00	TRANSFERENCIA	PAGADO	12750.00	0.00	COMPLETADA		\N	\N	\N	2026-03-02 19:49:28.173642	2026-03-02 19:49:28.186161	0.00	0.00	0.00
242	M4-0302-0002	VENTA	\N	1	15000.00	0.00	0.00	0.00	15000.00	TRANSFERENCIA	PAGADO	15000.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-03-02 21:13:12.9037	2026-03-02 21:14:03.518353	0.00	0.00	0.00
248	M9-0304-0001	VENTA	\N	1	0.00	0.00	0.00	0.00	0.00	\N	PENDIENTE	0.00	0.00	ANULADA	\N	\N	\N	Mesa liberada sin pedido	2026-03-04 13:48:02.07918	2026-03-04 13:49:05.029771	0.00	0.00	0.00
250	V0304-0001	VENTA	\N	1	26000.00	0.00	0.00	0.00	29000.00	EFECTIVO	PAGADO	29000.00	0.00	COMPLETADA		\N	\N	\N	2026-03-04 19:28:44.488439	2026-03-04 19:28:44.52563	0.00	0.00	3000.00
295	M4-0307-0006	VENTA	\N	1	31000.00	0.00	0.00	0.00	31000.00	EFECTIVO	PAGADO	100000.00	69000.00	COMPLETADA	\N	\N	\N	\N	2026-03-07 23:30:49.085338	2026-03-07 23:31:07.536936	0.00	0.00	0.00
253	M4-0304-0001	VENTA	\N	10	105000.00	0.00	0.00	0.00	115500.00	EFECTIVO	PAGADO	115500.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-03-04 20:43:24.878279	2026-03-04 22:08:11.558284	10.00	10500.00	0.00
255	V0305-0001	VENTA	\N	1	26000.00	0.00	0.00	0.00	29000.00	EFECTIVO	PAGADO	29000.00	0.00	COMPLETADA		\N	\N	\N	2026-03-05 19:02:12.895667	2026-03-05 19:02:12.946501	0.00	0.00	3000.00
246	M8-0302-0001	VENTA	\N	1	0.00	0.00	0.00	0.00	0.00	\N	PENDIENTE	0.00	0.00	ANULADA	\N	\N	\N	Mesa liberada sin pedido	2026-03-02 21:34:00.256293	2026-03-02 21:34:51.9696	0.00	0.00	0.00
245	M7-0302-0001	VENTA	\N	1	96000.00	0.00	0.00	0.00	105600.00	EFECTIVO	PAGADO	105600.00	0.00	ANULADA	\N	1	2026-03-02 21:58:29.239209	Error	2026-03-02 21:31:56.616818	2026-03-02 21:58:29.255288	10.00	9600.00	0.00
244	M6-0302-0001	VENTA	\N	1	89500.00	0.00	0.00	0.00	98450.00	EFECTIVO	PAGADO	100499.00	2049.00	COMPLETADA	\N	\N	\N	\N	2026-03-02 21:26:57.82963	2026-03-02 22:09:12.024378	10.00	8950.00	0.00
257	V0306-0001	VENTA	\N	1	36000.00	0.00	0.00	0.00	36000.00	EFECTIVO	PAGADO	100000.00	64000.00	COMPLETADA		\N	\N	\N	2026-03-06 20:06:04.256128	2026-03-06 20:06:04.346164	0.00	0.00	0.00
259	V0306-0003	VENTA	\N	1	37500.00	0.00	0.00	0.00	37500.00	TRANSFERENCIA	PAGADO	37500.00	0.00	COMPLETADA		\N	\N	\N	2026-03-06 23:03:13.380859	2026-03-06 23:03:13.436156	0.00	0.00	0.00
261	V0307-0001	VENTA	\N	1	90000.00	0.00	0.00	0.00	93000.00	TRANSFERENCIA	PAGADO	93000.00	0.00	COMPLETADA		\N	\N	\N	2026-03-07 18:15:00.738182	2026-03-07 18:15:00.837056	0.00	0.00	3000.00
285	M3-0307-0007	VENTA	\N	1	45000.00	0.00	0.00	0.00	45000.00	EFECTIVO	PAGADO	100000.00	55000.00	COMPLETADA	\N	\N	\N	\N	2026-03-07 22:46:12.989586	2026-03-07 22:47:15.889835	0.00	0.00	0.00
264	V0307-0002	VENTA	\N	1	65000.00	0.00	0.00	0.00	65000.00	EFECTIVO	PAGADO	65000.00	0.00	COMPLETADA		\N	\N	\N	2026-03-07 19:05:20.446231	2026-03-07 19:05:20.468896	0.00	0.00	0.00
272	M1-0307-0001	VENTA	\N	1	143000.00	0.00	0.00	0.00	143000.00	TRANSFERENCIA	PAGADO	143000.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-03-07 20:46:17.671959	2026-03-07 20:48:24.810144	0.00	0.00	0.00
274	M1-0307-0002	VENTA	\N	1	81000.00	0.00	0.00	0.00	81000.00	TRANSFERENCIA	PAGADO	81000.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-03-07 21:48:09.896511	2026-03-07 22:32:00.032034	0.00	0.00	0.00
290	M4-0307-0004	VENTA	\N	1	144000.00	0.00	0.00	0.00	144000.00	TRANSFERENCIA	PAGADO	144000.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-03-07 23:16:45.253201	2026-03-07 23:19:09.456267	0.00	0.00	0.00
297	M4-0308-0001	VENTA	\N	1	71000.00	0.00	0.00	0.00	71000.00	TRANSFERENCIA	PAGADO	71000.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-03-08 00:08:47.427638	2026-03-08 00:19:05.640932	0.00	0.00	0.00
282	M3-0307-0004	VENTA	\N	1	49000.00	0.00	0.00	0.00	49000.00	TRANSFERENCIA	PAGADO	49000.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-03-07 22:41:06.656561	2026-03-07 22:41:52.349442	0.00	0.00	0.00
263	M5-0307-0001	VENTA	\N	1	0.00	0.00	0.00	0.00	0.00	\N	PENDIENTE	0.00	0.00	ANULADA	\N	\N	\N	Mesa liberada sin pedido	2026-03-07 19:00:57.381948	2026-03-07 22:50:02.729487	0.00	0.00	0.00
306	M8-0308-0002	VENTA	\N	1	59000.00	0.00	0.00	0.00	62000.00	EFECTIVO	PAGADO	62000.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-03-08 20:10:34.526737	2026-03-08 22:31:04.96028	0.00	0.00	3000.00
308	V0308-0002	VENTA	\N	1	11500.00	0.00	0.00	0.00	11500.00	EFECTIVO	PAGADO	20000.00	8500.00	COMPLETADA		\N	\N	\N	2026-03-08 20:30:53.685455	2026-03-08 20:30:53.708687	0.00	0.00	0.00
300	M1-0308-0001	VENTA	\N	1	88000.00	0.00	0.00	0.00	88000.00	EFECTIVO	PAGADO	89997.00	1997.00	COMPLETADA	\N	\N	\N	\N	2026-03-08 19:00:53.947475	2026-03-08 19:44:40.785556	0.00	0.00	0.00
304	M7-0308-0001	VENTA	\N	1	154000.00	0.00	0.00	0.00	169400.00	EFECTIVO	PAGADO	200000.00	30600.00	COMPLETADA	\N	\N	\N	\N	2026-03-08 19:38:58.006326	2026-03-08 20:09:58.058827	10.00	15400.00	0.00
307	M7-0308-0002	VENTA	\N	1	228000.00	0.00	0.00	0.00	238000.00	TRANSFERENCIA	PAGADO	238000.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-03-08 20:15:30.541687	2026-03-08 20:45:52.583358	0.00	0.00	10000.00
309	M1-0308-0002	VENTA	\N	1	87000.00	0.00	0.00	0.00	87000.00	EFECTIVO	PAGADO	100000.00	13000.00	COMPLETADA	\N	\N	\N	\N	2026-03-08 20:34:35.632657	2026-03-08 21:02:09.979658	0.00	0.00	0.00
311	M4-0308-0002	VENTA	\N	1	228000.00	0.00	0.00	0.00	228000.00	EFECTIVO	PAGADO	228000.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-03-08 21:36:38.73133	2026-03-08 21:41:04.365232	0.00	0.00	0.00
310	V0308-0003	VENTA	\N	1	59000.00	0.00	0.00	0.00	62000.00	EFECTIVO	PAGADO	62000.00	0.00	ANULADA		1	2026-03-08 23:33:08.412561	error	2026-03-08 20:50:21.279544	2026-03-08 23:33:08.420125	0.00	0.00	3000.00
312	M2-0308-0002	VENTA	\N	1	52000.00	0.00	0.00	0.00	52000.00	EFECTIVO	PAGADO	52000.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-03-08 21:43:10.420104	2026-03-08 21:44:13.287391	0.00	0.00	0.00
326	M8-0309-0002	VENTA	\N	1	0.00	0.00	0.00	0.00	0.00	\N	PENDIENTE	0.00	0.00	ANULADA	\N	\N	\N	Mesa liberada sin pedido	2026-03-09 21:14:58.690543	2026-03-09 21:41:07.493384	0.00	0.00	0.00
328	V0309-0002	VENTA	\N	1	68000.00	0.00	0.00	0.00	71000.00	EFECTIVO	PAGADO	71000.00	0.00	COMPLETADA		\N	\N	\N	2026-03-09 21:44:22.98295	2026-03-09 21:44:23.010459	0.00	0.00	3000.00
315	M3-0308-0003	VENTA	\N	1	143000.00	0.00	0.00	0.00	157300.00	EFECTIVO	PAGADO	157300.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-03-08 21:54:54.956327	2026-03-08 21:56:18.701715	10.00	14300.00	0.00
314	M6-0308-0001	VENTA	\N	1	153000.00	0.00	0.00	0.00	153000.00	EFECTIVO	PAGADO	153000.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-03-08 21:52:59.210546	2026-03-08 22:06:26.569573	0.00	0.00	0.00
329	M3-0309-0002	VENTA	\N	1	0.00	0.00	0.00	0.00	0.00	\N	PENDIENTE	0.00	0.00	ANULADA	\N	\N	\N	Mesa liberada sin pedido	2026-03-09 22:42:19.824246	2026-03-09 22:55:24.144896	0.00	0.00	0.00
317	M7-0308-0003	VENTA	\N	1	0.00	0.00	0.00	0.00	0.00	\N	PENDIENTE	0.00	0.00	ANULADA	\N	\N	\N	Mesa liberada sin pedido	2026-03-08 22:08:51.18277	2026-03-08 22:11:54.343159	0.00	0.00	0.00
302	M9-0308-0001	VENTA	\N	1	25000.00	0.00	3750.00	15.00	21250.00	TRANSFERENCIA	PAGADO	21250.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-03-08 19:18:20.949904	2026-03-08 22:15:16.328349	0.00	0.00	0.00
316	M5-0308-0001	VENTA	\N	1	75000.00	0.00	0.00	0.00	75000.00	EFECTIVO	PAGADO	100000.00	25000.00	COMPLETADA	\N	\N	\N	\N	2026-03-08 22:07:04.172699	2026-03-08 22:23:14.642308	0.00	0.00	0.00
318	M7-0308-0004	VENTA	\N	1	118500.00	0.00	0.00	0.00	130350.00	EFECTIVO	PAGADO	130350.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-03-08 22:12:58.335429	2026-03-08 22:25:01.0666	10.00	11850.00	0.00
330	V0309-0003	VENTA	\N	1	7000.00	0.00	0.00	0.00	7000.00	EFECTIVO	PAGADO	7000.00	0.00	COMPLETADA		\N	\N	\N	2026-03-09 23:20:02.151603	2026-03-09 23:20:02.180799	0.00	0.00	0.00
319	M6-0308-0002	VENTA	\N	1	96000.00	0.00	0.00	0.00	96000.00	EFECTIVO	PAGADO	96000.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-03-08 22:32:54.640167	2026-03-08 22:34:05.747002	0.00	0.00	0.00
313	M1-0308-0003	VENTA	\N	1	80000.00	0.00	0.00	0.00	80000.00	EFECTIVO	PAGADO	80000.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-03-08 21:46:05.521949	2026-03-08 22:34:29.767624	0.00	0.00	0.00
331	V0309-0004	VENTA	\N	1	7000.00	0.00	0.00	0.00	7000.00	EFECTIVO	PAGADO	7000.00	0.00	COMPLETADA		\N	\N	\N	2026-03-09 23:36:30.004855	2026-03-09 23:36:30.034885	0.00	0.00	0.00
320	M3-0308-0004	VENTA	\N	1	98000.00	0.00	0.00	0.00	98000.00	TRANSFERENCIA	PAGADO	98000.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-03-08 22:41:07.862215	2026-03-08 22:41:54.410543	0.00	0.00	0.00
321	M5-0308-0002	VENTA	\N	1	45500.00	0.00	0.00	0.00	45500.00	TRANSFERENCIA	PAGADO	45500.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-03-08 23:00:45.452088	2026-03-08 23:22:12.946893	0.00	0.00	0.00
323	M6-0309-0001	VENTA	\N	1	102000.00	0.00	0.00	0.00	102000.00	TRANSFERENCIA	PAGADO	102000.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-03-09 20:33:27.685638	2026-03-09 20:46:27.897059	0.00	0.00	0.00
324	M5-0309-0001	VENTA	\N	1	94000.00	0.00	0.00	0.00	94000.00	EFECTIVO	PAGADO	94000.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-03-09 20:34:37.360779	2026-03-09 21:01:50.933483	0.00	0.00	0.00
325	M3-0309-0001	VENTA	\N	1	0.00	0.00	0.00	0.00	0.00	\N	PENDIENTE	0.00	0.00	ANULADA	\N	\N	\N	Mesa liberada sin pedido	2026-03-09 21:02:03.825075	2026-03-09 21:04:21.026212	0.00	0.00	0.00
322	M8-0309-0001	VENTA	\N	1	118000.00	0.00	0.00	0.00	123000.00	TRANSFERENCIA	PAGADO	123000.00	0.00	COMPLETADA	\N	\N	\N	\N	2026-03-09 20:32:51.585766	2026-03-09 21:14:51.414182	0.00	0.00	5000.00
327	V0309-0001	VENTA	\N	1	26500.00	0.00	0.00	0.00	26500.00	EFECTIVO	PAGADO	26500.00	0.00	COMPLETADA		\N	\N	\N	2026-03-09 21:38:48.88175	2026-03-09 21:38:48.918971	0.00	0.00	0.00
\.


--
-- Data for Name: kitchen_orders; Type: TABLE DATA; Schema: public; Owner: morales_user
--

COPY public.kitchen_orders (id, table_id, invoice_detail_id, order_time, sequence_number, status, is_urgent, urgency_reason, notes, created_at, updated_at) FROM stdin;
165	6	454	2026-02-27 18:38:32.823384	11	ENTREGADO	f	\N	\N	2026-02-27 18:38:32.849492	2026-02-27 18:47:23.979036
166	6	455	2026-02-27 18:38:32.823384	11	ENTREGADO	f	\N	\N	2026-02-27 18:38:32.93741	2026-02-27 18:47:24.018082
44	5	297	2026-02-20 20:04:26.407662	2	ENTREGADO	f	\N	\N	2026-02-20 20:04:26.407662	2026-02-20 20:21:38.988348
46	5	299	2026-02-20 20:04:26.444143	4	ENTREGADO	f	\N	\N	2026-02-20 20:04:26.444143	2026-02-20 20:21:44.476306
45	5	298	2026-02-20 20:04:26.425918	3	ENTREGADO	f	\N	\N	2026-02-20 20:04:26.425918	2026-02-20 20:21:44.506478
243	5	537	2026-02-28 20:50:45.660977	15	ENTREGADO	f	\N	\N	2026-02-28 20:50:45.673635	2026-02-28 21:23:49.271515
352	4	646	2026-03-01 22:32:24.12331	11	ENTREGADO	f	\N	\N	2026-03-01 22:32:24.139012	2026-03-01 23:06:45.318695
47	5	300	2026-02-20 20:04:26.462888	5	ENTREGADO	f	\N	\N	2026-02-20 20:04:26.462888	2026-02-20 20:21:49.426459
247	8	541	2026-02-28 21:32:53.349423	12	ENTREGADO	f	\N	\N	2026-02-28 21:32:53.367648	2026-02-28 22:06:29.828046
121	6	376	2026-02-22 20:28:28.902912	7	ENTREGADO	f	\N	\N	2026-02-22 20:28:28.910177	2026-02-22 20:36:56.34907
123	6	378	2026-02-22 20:28:28.902912	7	ENTREGADO	f	\N	\N	2026-02-22 20:28:28.942878	2026-02-22 20:36:59.814283
48	6	301	2026-02-20 20:07:08.697087	1	ENTREGADO	f	\N	\N	2026-02-20 20:07:08.697087	2026-02-20 20:22:13.939319
50	6	303	2026-02-20 20:07:08.753191	3	ENTREGADO	f	\N	\N	2026-02-20 20:07:08.753191	2026-02-20 20:22:15.277372
51	6	304	2026-02-20 20:07:08.772123	4	ENTREGADO	f	\N	\N	2026-02-20 20:07:08.773127	2026-02-20 20:22:17.081343
49	6	302	2026-02-20 20:07:08.731227	2	ENTREGADO	f	\N	\N	2026-02-20 20:07:08.731227	2026-02-20 20:22:18.059144
122	6	377	2026-02-22 20:28:28.902912	7	ENTREGADO	f	\N	\N	2026-02-22 20:28:28.928132	2026-02-22 20:37:01.492026
127	8	382	2026-02-22 21:12:58.288384	2	ENTREGADO	f	\N	\N	2026-02-22 21:12:58.297265	2026-02-22 21:25:52.889316
128	8	383	2026-02-22 21:12:58.288384	2	ENTREGADO	f	\N	\N	2026-02-22 21:12:58.31637	2026-02-22 21:25:52.889316
56	8	309	2026-02-20 20:38:21.906313	1	ENTREGADO	f	\N	\N	2026-02-20 20:38:21.930313	2026-02-20 21:44:20.645472
129	8	384	2026-02-22 21:12:58.288384	2	ENTREGADO	f	\N	\N	2026-02-22 21:12:58.328267	2026-02-22 21:25:52.889316
93	9	344	2026-02-22 01:38:20.28872	1	ENTREGADO	f	\N	\N	2026-02-22 01:38:20.344493	2026-02-22 02:20:37.401014
57	7	310	2026-02-20 21:08:55.255612	1	ENTREGADO	f	\N	\N	2026-02-20 21:08:55.276608	2026-02-20 21:44:29.967945
97	9	346	2026-02-22 02:17:58.808493	2	ENTREGADO	f	\N	\N	2026-02-22 02:15:48.666536	2026-02-22 02:20:37.401014
94	9	345	2026-02-22 02:17:58.808493	1	ENTREGADO	f	\N	\N	2026-02-22 01:38:20.402504	2026-02-22 02:20:37.401014
58	6	311	2026-02-20 21:11:06.230226	5	ENTREGADO	f	\N	\N	2026-02-20 21:11:06.244083	2026-02-20 21:44:47.842415
59	1	312	2026-02-20 21:30:58.629054	1	ENTREGADO	f	\N	\N	2026-02-20 21:30:58.64494	2026-02-21 17:09:58.712298
124	1	379	2026-02-22 21:01:56.45662	4	ENTREGADO	f	\N	Bbq 	2026-02-22 21:01:56.466674	2026-02-22 22:12:00.160661
125	1	380	2026-02-22 21:01:56.45662	4	ENTREGADO	f	\N	\N	2026-02-22 21:01:56.49205	2026-02-22 22:12:00.160661
60	1	313	2026-02-20 21:30:58.629054	1	ENTREGADO	f	\N	\N	2026-02-20 21:30:58.678528	2026-02-21 17:10:07.364128
61	1	314	2026-02-20 21:30:58.629054	1	ENTREGADO	f	\N	\N	2026-02-20 21:30:58.696438	2026-02-21 17:10:15.64191
105	9	358	2026-02-22 18:50:00.548786	3	ENTREGADO	f	\N	\N	2026-02-22 18:50:00.55968	2026-02-22 18:50:29.934336
126	1	381	2026-02-22 21:01:56.45662	4	ENTREGADO	f	\N	\N	2026-02-22 21:01:56.50616	2026-02-22 22:12:00.160661
62	1	315	2026-02-20 21:49:58.93253	2	ENTREGADO	f	\N	\N	2026-02-20 21:49:58.943524	2026-02-21 17:10:19.707478
130	4	385	2026-02-22 21:44:39.63295	1	ENTREGADO	f	\N	\N	2026-02-22 21:44:39.642934	2026-02-22 22:12:50.276274
131	4	386	2026-02-22 21:44:39.63295	1	ENTREGADO	f	\N	\N	2026-02-22 21:44:39.666495	2026-02-22 22:12:50.276274
111	6	364	2026-02-22 19:02:57.230377	6	ENTREGADO	f	\N	\N	2026-02-22 19:02:57.23725	2026-02-22 19:03:11.888296
106	1	359	2026-02-22 18:58:26.252335	3	ENTREGADO	f	\N	\N	2026-02-22 18:58:26.259081	2026-02-22 19:05:35.245987
107	1	360	2026-02-22 18:58:26.252335	3	ENTREGADO	f	\N	\N	2026-02-22 18:58:26.280289	2026-02-22 19:05:35.245987
108	1	361	2026-02-22 18:58:26.252335	3	ENTREGADO	f	\N	\N	2026-02-22 18:58:26.296382	2026-02-22 19:05:35.245987
109	1	362	2026-02-22 18:58:26.252335	3	ENTREGADO	f	\N	\N	2026-02-22 18:58:26.309396	2026-02-22 19:05:35.245987
43	5	296	2026-02-20 20:04:26.322106	1	ENTREGADO	f	\N	\N	2026-02-20 20:04:26.322106	2026-02-20 20:18:05.436727
69	7	329	2026-02-22 00:11:02.93738	2	ENTREGADO	f	\N	con limon	2026-02-22 00:11:02.949546	2026-02-22 00:12:51.05117
133	8	388	2026-02-22 22:07:55.554082	3	ENTREGADO	f	\N	\N	2026-02-22 22:01:34.551688	2026-02-22 22:30:11.404119
70	7	330	2026-02-22 00:11:02.93738	2	ENTREGADO	f	\N	\N	2026-02-22 00:11:03.007413	2026-02-22 00:12:51.05117
110	3	363	2026-02-22 19:01:35.439667	1	ENTREGADO	f	\N	\N	2026-02-22 19:01:35.446251	2026-02-22 19:19:24.335331
134	8	389	2026-02-22 22:07:55.554082	3	ENTREGADO	f	\N	\N	2026-02-22 22:01:34.562806	2026-02-22 22:30:12.284516
132	8	387	2026-02-22 22:24:49.79508	3	ENTREGADO	f	\N	\N	2026-02-22 22:01:34.533248	2026-02-22 22:30:18.465526
135	1	390	2026-02-22 22:29:36.615339	5	ENTREGADO	f	\N	Sin maizicitos	2026-02-22 22:29:36.621315	2026-02-22 23:09:59.227735
136	1	391	2026-02-22 22:29:36.615339	5	ENTREGADO	f	\N	Papas en casco	2026-02-22 22:29:36.641072	2026-02-22 23:09:59.227735
137	1	392	2026-02-22 22:29:36.615339	5	ENTREGADO	f	\N	\N	2026-02-22 22:29:36.654095	2026-02-22 23:09:59.227735
138	1	393	2026-02-22 23:03:27.074819	6	ENTREGADO	f	\N	\N	2026-02-22 23:03:27.086016	2026-02-22 23:09:59.227735
139	7	394	2026-02-23 18:54:24.891209	3	ENTREGADO	f	\N	\N	2026-02-23 18:54:24.916759	2026-02-23 19:14:01.9084
140	7	395	2026-02-23 18:54:24.891209	3	ENTREGADO	f	\N	\N	2026-02-23 18:54:25.051124	2026-02-23 19:14:01.912932
141	7	396	2026-02-23 18:54:24.891209	3	ENTREGADO	f	\N	\N	2026-02-23 18:54:25.079464	2026-02-23 19:14:01.912932
142	7	423	2026-02-25 19:06:47.189512	4	ENTREGADO	f	\N	\N	2026-02-25 19:06:47.232356	2026-02-25 19:31:12.408859
143	7	424	2026-02-25 19:06:47.189512	4	ENTREGADO	f	\N	\N	2026-02-25 19:06:48.479464	2026-02-25 19:31:12.408859
144	7	425	2026-02-25 19:06:47.189512	4	ENTREGADO	f	\N	\N	2026-02-25 19:06:48.516208	2026-02-25 19:31:12.408859
145	7	426	2026-02-25 19:06:47.189512	4	ENTREGADO	f	\N	\N	2026-02-25 19:06:48.613072	2026-02-25 19:31:12.408859
146	7	427	2026-02-25 19:06:47.189512	4	ENTREGADO	f	\N	\N	2026-02-25 19:06:48.64745	2026-02-25 19:31:12.409728
149	6	434	2026-02-25 19:58:52.473073	8	ENTREGADO	f	\N	\N	2026-02-25 19:58:52.505303	2026-02-25 20:32:19.604562
150	6	435	2026-02-25 19:58:52.473073	8	ENTREGADO	f	\N	\N	2026-02-25 19:58:52.583461	2026-02-25 20:32:19.604562
151	6	436	2026-02-25 19:58:52.473073	8	ENTREGADO	f	\N	\N	2026-02-25 19:58:52.624272	2026-02-25 20:32:19.604562
147	8	432	2026-02-25 19:54:52.33605	4	ENTREGADO	f	\N	\N	2026-02-25 19:54:52.378373	2026-02-25 20:33:15.637804
148	8	433	2026-02-25 19:54:52.33605	4	ENTREGADO	f	\N	\N	2026-02-25 19:54:52.463754	2026-02-25 20:33:15.637804
152	1	437	2026-02-25 20:31:13.560961	7	ENTREGADO	f	\N	\N	2026-02-25 20:31:13.599156	2026-02-25 21:24:15.453369
153	1	438	2026-02-25 20:31:13.560961	7	ENTREGADO	f	\N	\N	2026-02-25 20:31:13.751529	2026-02-25 21:24:15.453369
154	7	439	2026-02-25 21:34:49.935818	5	ENTREGADO	f	\N	\N	2026-02-25 21:34:49.95127	2026-02-25 21:45:00.313695
155	6	440	2026-02-26 21:01:34.719302	9	ENTREGADO	f	\N	\N	2026-02-26 21:01:34.737148	2026-02-26 21:50:49.763321
156	6	441	2026-02-26 21:01:34.719302	9	ENTREGADO	f	\N	\N	2026-02-26 21:01:34.770975	2026-02-26 21:50:49.763321
161	6	447	2026-02-26 21:50:43.452923	10	ENTREGADO	f	\N	\N	2026-02-26 21:50:43.463468	2026-02-26 21:50:49.763321
162	7	448	2026-02-26 21:52:14.05966	6	ENTREGADO	f	\N	\N	2026-02-26 21:52:14.069369	2026-02-26 21:55:29.112071
163	7	449	2026-02-26 21:54:47.349283	7	ENTREGADO	f	\N	\N	2026-02-26 21:54:47.357975	2026-02-26 21:55:29.112071
157	1	443	2026-02-26 21:23:35.250909	8	ENTREGADO	f	\N	\N	2026-02-26 21:23:35.262489	2026-02-26 22:00:52.921249
158	1	444	2026-02-26 21:23:35.250909	8	ENTREGADO	f	\N	\N	2026-02-26 21:23:35.292978	2026-02-26 22:00:52.921249
159	1	445	2026-02-26 21:23:35.250909	8	ENTREGADO	f	\N	\N	2026-02-26 21:23:35.320764	2026-02-26 22:00:52.921249
160	1	446	2026-02-26 21:50:28.833062	9	ENTREGADO	f	\N	\N	2026-02-26 21:50:28.847805	2026-02-26 22:00:52.921249
164	7	452	2026-02-26 22:11:32.389316	8	ENTREGADO	f	\N	\N	2026-02-26 22:11:32.402888	2026-02-26 22:15:08.475021
167	6	456	2026-02-27 18:38:32.823384	11	ENTREGADO	f	\N	\N	2026-02-27 18:38:33.027968	2026-02-27 18:47:24.024205
168	6	457	2026-02-27 18:38:32.823384	11	ENTREGADO	f	\N	\N	2026-02-27 18:38:33.111408	2026-02-27 18:47:24.024205
458	4	777	2026-03-07 21:27:42.28718	21	ENTREGADO	f	\N	\N	2026-03-07 21:27:42.296469	2026-03-07 21:28:33.226395
238	5	532	2026-02-28 20:36:19.558202	12	ENTREGADO	f	\N	\N	2026-02-28 20:36:19.569529	2026-02-28 21:23:49.271515
239	5	533	2026-02-28 20:36:19.558202	12	ENTREGADO	f	\N	\N	2026-02-28 20:36:19.596351	2026-02-28 21:23:49.271515
241	5	535	2026-02-28 20:36:34.321664	13	ENTREGADO	f	\N	\N	2026-02-28 20:36:34.329242	2026-02-28 21:23:49.273215
242	5	536	2026-02-28 20:37:19.261436	14	ENTREGADO	f	\N	\N	2026-02-28 20:37:19.269866	2026-02-28 21:23:49.273215
169	8	458	2026-02-27 19:43:49.788933	5	ENTREGADO	f	\N	\N	2026-02-27 19:43:49.80708	2026-02-27 19:59:19.312103
170	8	459	2026-02-27 19:43:49.788933	5	ENTREGADO	f	\N	\N	2026-02-27 19:43:49.865294	2026-02-27 19:59:19.312103
171	8	460	2026-02-27 19:43:49.788933	5	ENTREGADO	f	\N	\N	2026-02-27 19:43:49.899901	2026-02-27 19:59:19.312103
172	8	461	2026-02-27 19:43:49.788933	5	ENTREGADO	f	\N	\N	2026-02-27 19:43:49.926644	2026-02-27 19:59:19.313126
173	8	462	2026-02-27 19:43:49.788933	5	ENTREGADO	f	\N	\N	2026-02-27 19:43:49.954649	2026-02-27 19:59:19.313126
174	8	463	2026-02-27 19:43:49.788933	5	ENTREGADO	f	\N	\N	2026-02-27 19:43:49.983508	2026-02-27 19:59:19.313126
175	8	464	2026-02-27 19:58:41.293008	6	ENTREGADO	f	\N	\N	2026-02-27 19:58:41.312649	2026-02-27 19:59:19.313126
353	5	647	2026-03-01 23:02:39.633031	20	ENTREGADO	f	\N	\N	2026-03-01 23:02:39.646582	2026-03-01 23:44:36.059005
244	6	538	2026-02-28 21:05:28.329738	16	ENTREGADO	f	\N	\N	2026-02-28 21:05:28.343507	2026-02-28 21:47:37.238576
249	8	543	2026-02-28 21:32:53.349423	12	ENTREGADO	f	\N	\N	2026-02-28 21:32:53.422538	2026-02-28 22:06:29.828046
250	8	544	2026-02-28 21:32:53.349423	12	ENTREGADO	f	\N	\N	2026-02-28 21:32:53.466022	2026-02-28 22:06:29.828046
180	7	469	2026-02-27 20:41:28.553058	9	ENTREGADO	f	\N	\N	2026-02-27 20:41:01.536474	2026-02-27 20:41:34.889867
251	8	545	2026-02-28 21:32:53.349423	12	ENTREGADO	f	\N	\N	2026-02-28 21:32:53.499448	2026-02-28 22:06:29.828046
176	6	465	2026-02-27 20:16:08.949403	12	ENTREGADO	f	\N	\N	2026-02-27 20:16:08.965421	2026-02-27 21:44:02.74897
177	6	466	2026-02-27 20:16:08.949403	12	ENTREGADO	f	\N	\N	2026-02-27 20:16:08.997075	2026-02-27 21:44:02.74897
178	6	467	2026-02-27 20:16:08.949403	12	ENTREGADO	f	\N	\N	2026-02-27 20:16:09.029668	2026-02-27 21:44:02.74897
179	6	468	2026-02-27 20:16:08.949403	12	ENTREGADO	f	\N	\N	2026-02-27 20:16:09.050501	2026-02-27 21:44:02.74897
192	6	481	2026-02-27 22:02:03.331259	13	ENTREGADO	f	\N	\N	2026-02-27 22:02:03.345459	2026-02-27 22:16:20.358281
193	6	482	2026-02-27 22:02:03.331259	13	ENTREGADO	f	\N	\N	2026-02-27 22:02:03.367879	2026-02-27 22:16:20.360307
194	6	483	2026-02-27 22:02:03.331259	13	ENTREGADO	f	\N	\N	2026-02-27 22:02:03.383167	2026-02-27 22:16:20.360307
195	6	484	2026-02-27 22:02:03.331259	13	ENTREGADO	f	\N	\N	2026-02-27 22:02:03.397924	2026-02-27 22:16:20.360307
196	6	485	2026-02-27 22:02:03.331259	13	ENTREGADO	f	\N	\N	2026-02-27 22:02:03.413869	2026-02-27 22:16:20.360307
197	6	486	2026-02-27 22:02:03.331259	13	ENTREGADO	f	\N	\N	2026-02-27 22:02:03.429848	2026-02-27 22:16:20.360307
184	1	473	2026-02-27 21:59:40.950921	10	ENTREGADO	f	\N	\N	2026-02-27 21:59:40.959178	2026-02-27 22:18:24.611654
185	1	474	2026-02-27 21:59:40.950921	10	ENTREGADO	f	\N	\N	2026-02-27 21:59:40.976304	2026-02-27 22:18:24.611654
186	1	475	2026-02-27 21:59:40.950921	10	ENTREGADO	f	\N	\N	2026-02-27 21:59:40.993995	2026-02-27 22:18:24.611654
187	4	476	2026-02-27 22:01:08.591133	2	ENTREGADO	f	\N	\N	2026-02-27 22:01:08.605046	2026-02-27 22:25:46.602865
188	4	477	2026-02-27 22:01:08.591133	2	ENTREGADO	f	\N	\N	2026-02-27 22:01:08.632998	2026-02-27 22:25:46.602865
189	4	478	2026-02-27 22:01:08.591133	2	ENTREGADO	f	\N	\N	2026-02-27 22:01:08.651291	2026-02-27 22:25:46.602865
190	4	479	2026-02-27 22:01:08.591133	2	ENTREGADO	f	\N	\N	2026-02-27 22:01:08.668798	2026-02-27 22:25:46.602865
191	4	480	2026-02-27 22:01:08.591133	2	ENTREGADO	f	\N	\N	2026-02-27 22:01:08.687246	2026-02-27 22:25:46.602865
201	7	490	2026-02-27 22:50:01.194164	10	ENTREGADO	f	\N	\N	2026-02-27 22:50:01.210996	2026-02-27 22:54:51.177158
181	8	470	2026-02-27 21:00:25.62698	7	ENTREGADO	f	\N	\N	2026-02-27 21:00:25.648314	2026-02-27 23:16:52.485269
198	8	487	2026-02-27 22:02:32.399939	8	ENTREGADO	f	\N	\N	2026-02-27 22:02:32.408971	2026-02-27 23:16:52.485269
204	8	493	2026-02-27 22:57:11.918844	9	ENTREGADO	f	\N	\N	2026-02-27 22:57:11.928805	2026-02-27 23:16:52.485269
202	5	491	2026-02-27 22:50:48.608047	6	ENTREGADO	f	\N	\N	2026-02-27 22:50:48.645771	2026-02-27 23:59:46.100899
203	5	492	2026-02-27 22:50:48.608047	6	ENTREGADO	f	\N	\N	2026-02-27 22:50:48.672452	2026-02-27 23:59:46.100899
205	5	499	2026-02-28 17:29:48.33435	7	ENTREGADO	f	\N	\N	2026-02-28 17:29:48.347673	2026-02-28 18:30:45.695139
206	5	500	2026-02-28 17:29:48.33435	7	ENTREGADO	f	\N	\N	2026-02-28 17:29:48.3911	2026-02-28 18:30:45.695139
207	5	501	2026-02-28 17:29:48.33435	7	ENTREGADO	f	\N	\N	2026-02-28 17:29:48.423422	2026-02-28 18:30:45.695139
215	5	509	2026-02-28 18:22:25.966088	8	ENTREGADO	f	\N	\N	2026-02-28 18:22:25.982843	2026-02-28 18:30:45.695139
216	5	510	2026-02-28 18:28:31.344873	9	ENTREGADO	f	\N	\N	2026-02-28 18:28:31.358045	2026-02-28 18:30:45.696277
217	5	511	2026-02-28 18:28:50.08878	10	ENTREGADO	f	\N	\N	2026-02-28 18:28:50.099406	2026-02-28 18:30:45.696277
212	8	506	2026-02-28 18:17:03.486996	10	ENTREGADO	f	\N	\N	2026-02-28 18:17:03.509526	2026-02-28 19:05:30.047659
213	8	507	2026-02-28 18:17:03.486996	10	ENTREGADO	f	\N	\N	2026-02-28 18:17:03.549723	2026-02-28 19:05:30.047659
214	8	508	2026-02-28 18:17:03.486996	10	ENTREGADO	f	\N	\N	2026-02-28 18:17:03.577826	2026-02-28 19:05:30.047659
218	7	512	2026-02-28 18:40:42.659226	11	ENTREGADO	f	\N	\N	2026-02-28 18:40:42.677507	2026-02-28 19:17:20.512372
222	5	516	2026-02-28 18:49:39.583762	11	ENTREGADO	f	\N	\N	2026-02-28 18:49:39.595155	2026-02-28 19:24:42.757039
223	5	517	2026-02-28 18:49:39.583762	11	ENTREGADO	f	\N	\N	2026-02-28 18:49:39.634451	2026-02-28 19:24:42.757039
224	5	518	2026-02-28 18:49:39.583762	11	ENTREGADO	f	\N	Ajo, maiz	2026-02-28 18:49:39.65562	2026-02-28 19:24:42.759048
226	7	520	2026-02-28 19:30:26.286814	12	ENTREGADO	f	\N	\N	2026-02-28 19:30:26.304782	2026-02-28 19:32:53.451216
227	7	521	2026-02-28 19:30:26.286814	12	ENTREGADO	f	\N	\N	2026-02-28 19:30:26.348472	2026-02-28 19:32:53.451216
228	7	522	2026-02-28 19:30:26.286814	12	ENTREGADO	f	\N	\N	2026-02-28 19:30:26.371304	2026-02-28 19:32:53.451216
229	7	523	2026-02-28 19:30:26.286814	12	ENTREGADO	f	\N	\N	2026-02-28 19:30:26.399546	2026-02-28 19:32:53.451216
225	9	519	2026-02-28 19:14:21.126853	4	ENTREGADO	f	\N	\N	2026-02-28 19:14:21.159685	2026-02-28 19:36:36.804604
219	1	513	2026-02-28 18:47:44.099193	11	ENTREGADO	f	\N	Maiz,ajo	2026-02-28 18:47:44.115578	2026-02-28 19:40:52.242798
220	1	514	2026-02-28 18:47:44.099193	11	ENTREGADO	f	\N	Maiz, ajo,bbq	2026-02-28 18:47:44.152152	2026-02-28 19:40:52.242798
221	1	515	2026-02-28 18:47:44.099193	11	ENTREGADO	f	\N	\N	2026-02-28 18:47:44.175218	2026-02-28 19:40:52.242798
208	6	502	2026-02-28 18:11:20.239979	14	ENTREGADO	f	\N	\N	2026-02-28 18:11:20.257843	2026-02-28 19:57:48.75505
209	6	503	2026-02-28 18:11:20.239979	14	ENTREGADO	f	\N	\N	2026-02-28 18:11:20.302752	2026-02-28 19:57:48.75505
210	6	504	2026-02-28 18:11:20.239979	14	ENTREGADO	f	\N	\N	2026-02-28 18:11:20.328309	2026-02-28 19:57:48.75505
230	6	524	2026-02-28 19:36:54.654904	15	ENTREGADO	f	\N	\N	2026-02-28 19:36:54.667306	2026-02-28 19:57:48.75505
211	6	505	2026-02-28 19:41:43.969861	14	ENTREGADO	f	\N	\N	2026-02-28 18:11:20.35836	2026-02-28 19:57:48.75505
231	7	525	2026-02-28 19:52:02.001538	13	ENTREGADO	f	\N	\N	2026-02-28 19:52:02.017625	2026-02-28 20:17:13.886319
232	7	526	2026-02-28 19:52:02.001538	13	ENTREGADO	f	\N	\N	2026-02-28 19:52:02.044832	2026-02-28 20:17:13.886319
233	7	527	2026-02-28 19:53:08.001508	14	ENTREGADO	f	\N	\N	2026-02-28 19:53:08.011293	2026-02-28 20:17:13.886319
234	8	528	2026-02-28 20:10:17.733393	11	ENTREGADO	f	\N	Casco, ajo rosada	2026-02-28 20:10:17.747756	2026-02-28 20:47:55.641902
235	8	529	2026-02-28 20:10:17.733393	11	ENTREGADO	f	\N	Francesa ajo,rosada	2026-02-28 20:10:17.77623	2026-02-28 20:47:55.641902
236	8	530	2026-02-28 20:10:17.733393	11	ENTREGADO	f	\N	\N	2026-02-28 20:10:17.795535	2026-02-28 20:47:55.641902
237	8	531	2026-02-28 20:10:17.733393	11	ENTREGADO	f	\N	\N	2026-02-28 20:10:17.81715	2026-02-28 20:47:55.641902
303	4	597	2026-03-01 21:03:53.475585	4	ENTREGADO	f	\N	\N	2026-03-01 19:23:27.503148	2026-03-01 23:06:45.318695
308	4	602	2026-03-01 21:03:53.475585	6	ENTREGADO	f	\N	\N	2026-03-01 19:40:25.868943	2026-03-01 23:06:45.318695
304	4	598	2026-03-01 21:16:04.408801	4	ENTREGADO	f	\N	\N	2026-03-01 19:23:27.590601	2026-03-01 23:06:45.318695
252	3	546	2026-02-28 21:40:00.103483	2	ENTREGADO	f	\N	Termino medio	2026-02-28 21:40:00.119925	2026-02-28 22:45:25.278403
253	3	547	2026-02-28 21:40:00.103483	2	ENTREGADO	f	\N	Bbq	2026-02-28 21:40:00.153738	2026-02-28 22:45:25.278403
254	3	548	2026-02-28 21:40:00.103483	2	ENTREGADO	f	\N	\N	2026-02-28 21:40:00.171941	2026-02-28 22:45:25.278403
423	4	742	2026-03-07 19:39:58.847992	17	ENTREGADO	f	\N	\N	2026-03-07 19:39:58.852706	2026-03-07 21:28:33.226395
357	4	657	2026-03-02 18:57:56.39773	13	ENTREGADO	f	\N	\N	2026-03-02 18:57:56.408777	2026-03-02 21:12:04.387714
424	4	743	2026-03-07 19:40:08.435616	18	ENTREGADO	f	\N	\N	2026-03-07 19:40:08.441533	2026-03-07 21:28:33.226395
363	4	665	2026-03-02 21:13:59.633859	15	ENTREGADO	f	\N	\N	2026-03-02 21:13:59.642733	2026-03-02 21:14:03.518892
425	4	744	2026-03-07 19:40:34.980143	19	ENTREGADO	f	\N	\N	2026-03-07 19:40:34.9898	2026-03-07 21:28:33.226395
426	4	745	2026-03-07 20:01:37.851384	20	ENTREGADO	f	\N	\N	2026-03-07 19:40:47.563305	2026-03-07 21:28:33.226395
467	1	786	2026-03-07 22:09:31.204539	20	ENTREGADO	f	\N	\N	2026-03-07 22:09:31.208899	2026-03-07 22:09:52.439678
370	8	672	2026-03-02 21:33:33.877127	15	ENTREGADO	f	\N	\N	2026-03-02 21:33:33.888395	2026-03-02 21:37:58.707609
371	8	673	2026-03-02 21:33:33.877127	15	ENTREGADO	f	\N	\N	2026-03-02 21:33:33.912571	2026-03-02 21:37:58.707609
372	8	674	2026-03-02 21:33:33.877127	15	ENTREGADO	f	\N	\N	2026-03-02 21:33:33.930757	2026-03-02 21:37:58.707609
366	6	668	2026-03-02 21:28:49.567101	23	ENTREGADO	f	\N	\N	2026-03-02 21:28:49.579487	2026-03-02 22:09:12.025447
578	4	902	2026-03-08 21:37:06.337656	38	ENTREGADO	f	\N	\N	2026-03-08 21:37:06.346028	2026-03-08 21:41:04.366492
579	4	903	2026-03-08 21:37:06.337656	38	ENTREGADO	f	\N	\N	2026-03-08 21:37:06.364862	2026-03-08 21:41:04.366492
388	2	694	2026-03-04 18:50:38.651016	7	ENTREGADO	f	\N	\N	2026-03-04 18:50:38.662956	2026-03-04 18:59:38.781517
469	4	788	2026-03-07 22:24:07.359365	22	ENTREGADO	f	\N	\N	2026-03-07 22:24:07.366227	2026-03-07 22:26:02.976956
470	4	789	2026-03-07 22:24:17.27975	23	ENTREGADO	f	\N	\N	2026-03-07 22:24:17.284628	2026-03-07 22:26:02.976956
471	4	790	2026-03-07 22:24:40.314988	24	ENTREGADO	f	\N	\N	2026-03-07 22:24:40.320733	2026-03-07 22:26:02.976956
472	4	791	2026-03-07 22:24:50.007676	25	ENTREGADO	f	\N	\N	2026-03-07 22:24:50.012532	2026-03-07 22:26:02.977584
473	4	792	2026-03-07 22:24:57.764426	26	ENTREGADO	f	\N	\N	2026-03-07 22:24:57.769021	2026-03-07 22:26:02.977584
474	7	793	2026-03-07 22:27:28.872733	21	ENTREGADO	f	\N	\N	2026-03-07 22:27:28.87795	2026-03-07 22:30:40.268531
389	6	696	2026-03-04 19:46:32.139306	27	ENTREGADO	f	\N	\N	2026-03-04 19:46:32.155175	2026-03-04 20:34:21.716009
390	8	697	2026-03-04 20:04:29.169183	16	ENTREGADO	f	\N	\N	2026-03-04 20:04:29.184836	2026-03-04 21:19:21.988539
391	8	698	2026-03-04 20:04:29.169183	16	ENTREGADO	f	\N	\N	2026-03-04 20:04:29.232795	2026-03-04 21:19:21.988539
392	8	699	2026-03-04 20:04:29.169183	16	ENTREGADO	f	\N	\N	2026-03-04 20:04:29.267385	2026-03-04 21:19:21.988539
393	8	700	2026-03-04 20:04:29.169183	16	ENTREGADO	f	\N	\N	2026-03-04 20:04:29.288698	2026-03-04 21:19:21.988539
394	8	701	2026-03-04 20:04:29.169183	16	ENTREGADO	f	\N	\N	2026-03-04 20:04:29.313536	2026-03-04 21:19:21.988539
395	8	702	2026-03-04 20:04:29.169183	16	ENTREGADO	f	\N	\N	2026-03-04 20:04:29.336079	2026-03-04 21:19:21.988539
459	2	778	2026-03-07 21:48:20.378164	13	ENTREGADO	f	\N	\N	2026-03-07 21:48:20.388421	2026-03-07 22:32:00.032034
460	2	779	2026-03-07 21:48:20.378164	13	ENTREGADO	f	\N	\N	2026-03-07 21:48:20.404698	2026-03-07 22:32:00.032034
461	2	780	2026-03-07 21:48:33.64942	14	ENTREGADO	f	\N	\N	2026-03-07 21:48:33.652967	2026-03-07 22:32:00.032034
475	2	794	2026-03-07 22:31:31.014815	15	ENTREGADO	f	\N	\N	2026-03-07 22:31:31.018919	2026-03-07 22:32:00.032034
401	5	710	2026-03-05 19:52:29.285516	22	ENTREGADO	f	\N	\N	2026-03-05 19:52:29.307245	2026-03-05 20:48:35.310591
402	5	711	2026-03-05 19:52:29.285516	22	ENTREGADO	f	\N	\N	2026-03-05 19:52:29.365702	2026-03-05 20:48:35.310591
403	5	712	2026-03-05 19:52:29.285516	22	ENTREGADO	f	\N	\N	2026-03-05 19:52:29.394736	2026-03-05 20:48:35.310591
404	5	713	2026-03-05 19:52:29.285516	22	ENTREGADO	f	\N	\N	2026-03-05 19:52:29.422451	2026-03-05 20:48:35.310591
405	5	714	2026-03-05 19:52:29.285516	22	ENTREGADO	f	\N	\N	2026-03-05 19:52:29.447229	2026-03-05 20:48:35.310591
477	1	796	2026-03-07 22:34:46.488063	21	ENTREGADO	f	\N	\N	2026-03-07 22:34:46.49222	2026-03-07 22:35:00.771956
478	1	797	2026-03-07 22:34:52.752874	22	ENTREGADO	f	\N	\N	2026-03-07 22:34:52.75711	2026-03-07 22:35:00.771956
476	8	795	2026-03-07 22:32:54.005372	26	ENTREGADO	f	\N	\N	2026-03-07 22:32:54.010054	2026-03-07 22:36:20.63731
414	8	733	2026-03-07 19:32:01.841029	17	ENTREGADO	f	\N	\N	2026-03-07 19:32:01.857607	2026-03-07 19:43:12.257451
416	8	735	2026-03-07 19:33:24.164258	19	ENTREGADO	f	\N	\N	2026-03-07 19:33:24.172676	2026-03-07 19:43:12.257451
417	8	736	2026-03-07 19:36:12.314844	20	ENTREGADO	f	\N	\N	2026-03-07 19:36:12.326569	2026-03-07 19:43:12.257451
419	8	738	2026-03-07 19:38:46.666467	22	ENTREGADO	f	\N	\N	2026-03-07 19:38:46.671258	2026-03-07 19:43:12.257451
421	8	740	2026-03-07 19:39:10.814667	24	ENTREGADO	f	\N	\N	2026-03-07 19:39:10.821382	2026-03-07 19:43:12.257451
479	1	798	2026-03-07 22:39:07.871436	23	ENTREGADO	f	\N	\N	2026-03-07 22:39:07.876775	2026-03-07 22:39:32.746008
438	9	757	2026-03-07 19:52:47.167864	8	ENTREGADO	f	\N	\N	2026-03-07 19:52:47.188597	2026-03-07 19:56:46.112349
480	1	799	2026-03-07 22:39:15.920107	24	ENTREGADO	f	\N	\N	2026-03-07 22:39:15.925151	2026-03-07 22:39:32.746008
443	9	762	2026-03-07 20:03:57.77863	13	ENTREGADO	f	\N	\N	2026-03-07 20:03:57.784246	2026-03-07 20:04:03.94887
445	9	764	2026-03-07 20:29:46.148711	15	ENTREGADO	f	\N	\N	2026-03-07 20:29:46.156301	2026-03-07 20:54:00.444244
446	9	765	2026-03-07 20:29:58.241605	16	ENTREGADO	f	\N	\N	2026-03-07 20:29:58.246237	2026-03-07 20:54:00.444244
447	9	766	2026-03-07 20:30:10.323951	17	ENTREGADO	f	\N	\N	2026-03-07 20:30:10.330521	2026-03-07 20:54:00.444244
448	9	767	2026-03-07 20:30:30.117129	18	ENTREGADO	f	\N	\N	2026-03-07 20:30:30.122536	2026-03-07 20:54:00.444244
484	1	803	2026-03-07 22:43:03.766888	28	ENTREGADO	f	\N	\N	2026-03-07 22:43:03.772725	2026-03-07 22:44:04.16212
485	1	804	2026-03-07 22:43:18.388104	29	ENTREGADO	f	\N	\N	2026-03-07 22:43:11.052971	2026-03-07 22:44:04.16212
456	7	775	2026-03-07 21:09:06.342061	19	ENTREGADO	f	\N	\N	2026-03-07 21:09:06.348404	2026-03-07 21:09:46.816426
457	7	776	2026-03-07 21:09:15.833329	20	ENTREGADO	f	\N	\N	2026-03-07 21:09:15.839455	2026-03-07 21:09:46.816426
486	1	805	2026-03-07 22:43:25.000637	30	ENTREGADO	f	\N	\N	2026-03-07 22:43:25.004658	2026-03-07 22:44:04.16212
487	1	806	2026-03-07 22:43:37.543702	31	ENTREGADO	f	\N	\N	2026-03-07 22:43:37.549447	2026-03-07 22:44:04.16212
488	1	807	2026-03-07 22:43:47.56996	32	ENTREGADO	f	\N	\N	2026-03-07 22:43:47.573956	2026-03-07 22:44:04.16212
489	1	808	2026-03-07 22:44:44.85844	33	ENTREGADO	f	\N	\N	2026-03-07 22:44:44.863182	2026-03-07 22:45:45.349178
490	1	809	2026-03-07 22:45:30.930171	34	ENTREGADO	f	\N	\N	2026-03-07 22:45:30.937001	2026-03-07 22:45:45.349178
491	1	810	2026-03-07 22:45:40.709927	35	ENTREGADO	f	\N	\N	2026-03-07 22:45:40.714051	2026-03-07 22:45:45.349178
494	1	813	2026-03-07 22:46:55.769713	38	ENTREGADO	f	\N	\N	2026-03-07 22:46:55.77697	2026-03-07 22:47:15.889835
503	4	822	2026-03-07 22:56:28.338148	28	ENTREGADO	f	\N	\N	2026-03-07 22:56:28.342303	2026-03-07 22:57:52.62597
501	1	820	2026-03-07 22:53:54.159282	42	ENTREGADO	f	\N	\N	2026-03-07 22:53:54.163418	2026-03-07 23:03:16.058162
508	3	827	2026-03-07 23:10:03.636303	4	ENTREGADO	f	\N	\N	2026-03-07 23:10:03.642647	2026-03-07 23:11:03.439515
509	3	828	2026-03-07 23:10:08.998168	5	ENTREGADO	f	\N	\N	2026-03-07 23:10:09.002943	2026-03-07 23:11:03.439515
510	3	829	2026-03-07 23:10:15.979397	6	ENTREGADO	f	\N	\N	2026-03-07 23:10:15.98395	2026-03-07 23:11:03.439515
245	6	539	2026-02-28 21:05:28.329738	16	ENTREGADO	f	\N	\N	2026-02-28 21:05:28.37204	2026-02-28 21:47:37.238576
246	6	540	2026-02-28 21:05:28.329738	16	ENTREGADO	f	\N	\N	2026-02-28 21:05:28.403923	2026-02-28 21:47:37.238576
302	4	596	2026-03-01 19:23:27.325858	4	ENTREGADO	f	\N	\N	2026-03-01 19:23:27.336956	2026-03-01 23:06:45.318695
305	4	599	2026-03-01 19:23:27.325858	4	ENTREGADO	f	\N	\N	2026-03-01 19:23:27.651047	2026-03-01 23:06:45.318695
306	4	600	2026-03-01 19:23:48.239397	5	ENTREGADO	f	\N	\N	2026-03-01 19:23:48.25146	2026-03-01 23:06:45.318695
307	4	601	2026-03-01 19:40:25.786611	6	ENTREGADO	f	\N	\N	2026-03-01 19:40:25.812358	2026-03-01 23:06:45.318695
334	4	628	2026-03-01 20:36:56.94957	7	ENTREGADO	f	\N	\N	2026-03-01 20:36:56.967966	2026-03-01 23:06:45.318695
580	4	904	2026-03-08 21:38:04.566913	39	ENTREGADO	f	\N	\N	2026-03-08 21:38:04.573212	2026-03-08 21:41:04.366492
355	5	649	2026-03-01 23:39:02.446878	20	ENTREGADO	f	\N	\N	2026-03-01 23:02:39.69809	2026-03-01 23:44:36.059005
581	4	905	2026-03-08 21:38:04.566913	39	ENTREGADO	f	\N	\N	2026-03-08 21:38:04.58618	2026-03-08 21:41:04.366492
358	4	658	2026-03-02 18:58:16.068705	14	ENTREGADO	f	\N	\N	2026-03-02 18:58:16.076499	2026-03-02 21:12:04.387714
364	1	666	2026-03-02 21:26:25.179805	15	ENTREGADO	f	\N	\N	2026-03-02 21:26:25.193229	2026-03-02 21:56:07.467128
367	6	669	2026-03-02 21:29:27.935928	24	ENTREGADO	t	\N	\N	2026-03-02 21:29:27.942507	2026-03-02 22:09:12.025447
377	6	683	2026-03-02 21:47:58.80213	26	ENTREGADO	f	\N	\N	2026-03-02 21:47:58.812412	2026-03-02 22:09:12.025447
385	2	691	2026-03-04 18:14:24.186965	4	ENTREGADO	f	\N	\N	2026-03-04 18:14:24.304076	2026-03-04 18:59:38.781517
248	8	542	2026-02-28 21:32:53.349423	12	ENTREGADO	f	\N	\N	2026-02-28 21:32:53.399463	2026-02-28 22:06:29.828046
255	1	549	2026-02-28 21:50:14.106778	12	ENTREGADO	f	\N	\N	2026-02-28 21:50:14.129173	2026-02-28 22:36:00.34126
256	1	550	2026-02-28 21:50:14.106778	12	ENTREGADO	f	\N	\N	2026-02-28 21:50:14.184837	2026-02-28 22:36:00.34126
257	1	551	2026-02-28 21:50:14.106778	12	ENTREGADO	f	\N	\N	2026-02-28 21:50:14.207766	2026-02-28 22:36:00.34126
272	2	566	2026-02-28 21:54:47.789797	1	ENTREGADO	f	\N	\N	2026-02-28 21:54:47.798239	2026-02-28 22:44:26.729956
273	2	567	2026-02-28 21:54:47.789797	1	ENTREGADO	f	\N	\N	2026-02-28 21:54:47.815054	2026-02-28 22:44:26.729956
274	2	568	2026-02-28 21:54:47.789797	1	ENTREGADO	f	\N	\N	2026-02-28 21:54:47.831648	2026-02-28 22:44:26.729956
258	4	552	2026-02-28 21:52:39.273447	3	ENTREGADO	f	\N	\N	2026-02-28 21:52:39.283259	2026-02-28 22:50:27.003
259	4	553	2026-02-28 21:52:39.273447	3	ENTREGADO	f	\N	\N	2026-02-28 21:52:39.304722	2026-02-28 22:50:27.003
260	4	554	2026-02-28 21:52:39.273447	3	ENTREGADO	f	\N	\N	2026-02-28 21:52:39.330049	2026-02-28 22:50:27.003
261	4	555	2026-02-28 21:52:39.273447	3	ENTREGADO	f	\N	\N	2026-02-28 21:52:39.353855	2026-02-28 22:50:27.003
262	4	556	2026-02-28 21:52:39.273447	3	ENTREGADO	f	\N	\N	2026-02-28 21:52:39.378045	2026-02-28 22:50:27.003
263	4	557	2026-02-28 21:52:39.273447	3	ENTREGADO	f	\N	\N	2026-02-28 21:52:39.400985	2026-02-28 22:50:27.003
264	4	558	2026-02-28 21:52:39.273447	3	ENTREGADO	f	\N	\N	2026-02-28 21:52:39.417709	2026-02-28 22:50:27.003
265	4	559	2026-02-28 21:52:39.273447	3	ENTREGADO	f	\N	\N	2026-02-28 21:52:39.436161	2026-02-28 22:50:27.003
266	4	560	2026-02-28 21:52:39.273447	3	ENTREGADO	f	\N	\N	2026-02-28 21:52:39.454481	2026-02-28 22:50:27.003
267	4	561	2026-02-28 22:49:13.643468	3	ENTREGADO	f	\N	\N	2026-02-28 21:52:39.47155	2026-02-28 22:50:27.003
268	5	562	2026-02-28 21:53:57.053006	16	ENTREGADO	f	\N	\N	2026-02-28 21:53:57.061351	2026-02-28 22:51:55.506877
269	5	563	2026-02-28 21:53:57.053006	16	ENTREGADO	f	\N	\N	2026-02-28 21:53:57.078671	2026-02-28 22:51:55.506877
270	5	564	2026-02-28 21:53:57.053006	16	ENTREGADO	f	\N	\N	2026-02-28 21:53:57.108537	2026-02-28 22:51:55.506877
275	6	569	2026-02-28 21:58:06.612148	17	ENTREGADO	f	\N	\N	2026-02-28 21:58:06.625254	2026-02-28 22:52:45.213207
276	6	570	2026-02-28 21:58:06.612148	17	ENTREGADO	f	\N	\N	2026-02-28 21:58:06.650281	2026-02-28 22:52:45.213207
277	6	571	2026-02-28 21:58:06.612148	17	ENTREGADO	f	\N	\N	2026-02-28 21:58:06.664751	2026-02-28 22:52:45.213207
278	6	572	2026-02-28 21:58:06.612148	17	ENTREGADO	f	\N	\N	2026-02-28 21:58:06.680219	2026-02-28 22:52:45.213207
287	9	581	2026-02-28 23:02:59.346703	5	ENTREGADO	f	\N	\N	2026-02-28 23:02:59.362996	2026-02-28 23:11:14.796577
283	1	577	2026-02-28 22:54:00.807521	13	ENTREGADO	f	\N	\N	2026-02-28 22:54:00.815169	2026-02-28 23:19:01.299196
284	1	578	2026-02-28 22:54:00.807521	13	ENTREGADO	f	\N	\N	2026-02-28 22:54:00.831392	2026-02-28 23:19:01.299196
285	1	579	2026-02-28 22:54:00.807521	13	ENTREGADO	f	\N	\N	2026-02-28 22:54:00.852804	2026-02-28 23:19:01.299196
286	1	580	2026-02-28 22:54:00.807521	13	ENTREGADO	f	\N	\N	2026-02-28 22:54:00.874521	2026-02-28 23:19:01.299196
280	2	574	2026-02-28 22:46:46.919179	2	ENTREGADO	f	\N	\N	2026-02-28 22:46:46.928219	2026-02-28 23:20:02.03984
281	2	575	2026-02-28 22:46:46.919179	2	ENTREGADO	f	\N	\N	2026-02-28 22:46:46.95161	2026-02-28 23:20:02.03984
282	2	576	2026-02-28 22:46:46.919179	2	ENTREGADO	f	\N	\N	2026-02-28 22:46:46.965765	2026-02-28 23:20:02.03984
292	7	586	2026-02-28 23:29:59.102578	15	ENTREGADO	f	\N	\N	2026-02-28 23:29:59.126681	2026-02-28 23:30:20.283012
289	6	583	2026-02-28 23:20:47.332025	18	ENTREGADO	f	\N	\N	2026-02-28 23:20:47.343214	2026-02-28 23:56:53.762072
290	6	584	2026-02-28 23:20:47.332025	18	ENTREGADO	f	\N	\N	2026-02-28 23:20:47.401072	2026-02-28 23:56:53.762072
291	6	585	2026-02-28 23:20:47.332025	18	ENTREGADO	f	\N	\N	2026-02-28 23:20:47.423282	2026-02-28 23:56:53.762072
297	5	591	2026-03-01 19:20:56.443672	17	ENTREGADO	f	\N	\N	2026-03-01 19:20:56.477219	2026-03-01 19:30:56.267054
293	6	587	2026-03-01 18:41:06.897368	19	ENTREGADO	f	\N	\N	2026-03-01 18:41:06.948026	2026-03-01 19:33:05.298866
294	6	588	2026-03-01 18:41:06.897368	19	ENTREGADO	f	\N	\N	2026-03-01 18:41:07.100128	2026-03-01 19:33:05.298866
295	6	589	2026-03-01 18:41:06.897368	19	ENTREGADO	f	\N	Termino tres cuartos, francesa., rosada 	2026-03-01 18:41:07.217824	2026-03-01 19:33:05.298866
296	6	590	2026-03-01 18:41:06.897368	19	ENTREGADO	f	\N	\N	2026-03-01 18:41:07.381499	2026-03-01 19:33:05.298866
298	1	592	2026-03-01 19:23:22.41725	14	ENTREGADO	f	\N	Rosada y maiz	2026-03-01 19:23:22.480797	2026-03-01 20:15:51.299665
299	1	593	2026-03-01 19:23:22.41725	14	ENTREGADO	f	\N	\N	2026-03-01 19:23:22.572888	2026-03-01 20:15:51.299665
300	1	594	2026-03-01 19:23:22.41725	14	ENTREGADO	f	\N	\N	2026-03-01 19:23:22.695511	2026-03-01 20:15:51.299665
301	1	595	2026-03-01 19:23:22.41725	14	ENTREGADO	f	\N	\N	2026-03-01 19:23:22.770412	2026-03-01 20:15:51.299665
315	8	609	2026-03-01 19:53:14.966069	13	ENTREGADO	f	\N	\N	2026-03-01 19:53:15.025482	2026-03-01 20:26:03.547009
316	8	610	2026-03-01 19:53:14.966069	13	ENTREGADO	f	\N	\N	2026-03-01 19:53:15.044459	2026-03-01 20:26:03.547009
317	8	611	2026-03-01 19:53:14.966069	13	ENTREGADO	f	\N	\N	2026-03-01 19:53:15.072964	2026-03-01 20:26:03.547009
318	8	612	2026-03-01 19:53:14.966069	13	ENTREGADO	f	\N	\N	2026-03-01 19:53:15.096125	2026-03-01 20:26:03.547009
314	8	608	2026-03-01 20:23:02.279616	13	ENTREGADO	f	\N	\N	2026-03-01 19:53:14.990972	2026-03-01 20:26:03.547009
328	8	622	2026-03-01 20:25:22.78717	14	ENTREGADO	f	\N	\N	2026-03-01 20:25:22.79616	2026-03-01 20:26:03.547009
322	9	616	2026-03-01 20:11:57.051169	6	ENTREGADO	f	\N	\N	2026-03-01 20:11:57.06379	2026-03-01 20:37:22.741625
323	2	617	2026-03-01 20:18:11.020332	3	ENTREGADO	f	\N	Casco, rosada ajo, chimichurri 	2026-03-01 20:18:11.034363	2026-03-01 21:01:22.777865
324	2	618	2026-03-01 20:18:11.020332	3	ENTREGADO	f	\N	Mango	2026-03-01 20:18:11.072776	2026-03-01 21:01:22.777865
326	2	620	2026-03-01 20:18:11.020332	3	ENTREGADO	f	\N	Michelada	2026-03-01 20:18:11.133373	2026-03-01 21:01:22.777865
329	6	623	2026-03-01 20:32:53.882142	20	ENTREGADO	f	\N	\N	2026-03-01 20:32:53.906792	2026-03-01 21:06:29.19191
330	6	624	2026-03-01 20:32:53.882142	20	ENTREGADO	f	\N	\N	2026-03-01 20:32:53.960592	2026-03-01 21:06:29.19191
331	6	625	2026-03-01 20:32:53.882142	20	ENTREGADO	f	\N	\N	2026-03-01 20:32:53.98384	2026-03-01 21:06:29.19191
332	6	626	2026-03-01 20:32:53.882142	20	ENTREGADO	f	\N	\N	2026-03-01 20:32:54.00622	2026-03-01 21:06:29.19191
333	6	627	2026-03-01 20:32:53.882142	20	ENTREGADO	f	\N	\N	2026-03-01 20:32:54.028135	2026-03-01 21:06:29.19191
336	5	630	2026-03-01 20:52:22.170913	18	ENTREGADO	f	\N	\N	2026-03-01 20:52:22.18928	2026-03-01 21:55:55.002058
335	7	629	2026-03-01 20:40:55.013404	16	ENTREGADO	f	\N	\N	2026-03-01 20:40:55.027774	2026-03-01 22:20:28.398573
319	3	613	2026-03-01 19:56:32.802826	3	ENTREGADO	f	\N	\N	2026-03-01 19:56:32.816669	2026-03-01 20:53:47.404126
320	3	614	2026-03-01 19:56:32.802826	3	ENTREGADO	f	\N	\N	2026-03-01 19:56:32.851815	2026-03-01 20:53:47.404126
321	3	615	2026-03-01 19:56:32.802826	3	ENTREGADO	f	\N	\N	2026-03-01 19:56:32.876977	2026-03-01 20:53:47.404126
346	5	640	2026-03-01 21:56:10.006299	19	ENTREGADO	f	\N	\N	2026-03-01 21:56:10.017812	2026-03-01 22:31:33.497124
325	2	619	2026-03-01 20:18:11.020332	3	ENTREGADO	f	\N	Francesa ajo, rosada,chimichurri 	2026-03-01 20:18:11.104023	2026-03-01 21:01:22.777865
327	2	621	2026-03-01 20:18:11.020332	3	ENTREGADO	f	\N	\N	2026-03-01 20:18:11.1532	2026-03-01 21:01:22.777865
347	6	641	2026-03-01 22:02:49.798826	21	ENTREGADO	f	\N	Rosada bbq	2026-03-01 22:02:49.814375	2026-03-01 22:40:46.41706
348	6	642	2026-03-01 22:02:49.798826	21	ENTREGADO	f	\N	Guanabana, maracuyá	2026-03-01 22:02:49.852535	2026-03-01 22:40:46.41706
582	4	906	2026-03-08 21:38:04.566913	39	ENTREGADO	f	\N	\N	2026-03-08 21:38:04.59711	2026-03-08 21:41:04.366492
583	4	907	2026-03-08 21:38:56.027491	40	ENTREGADO	f	\N	\N	2026-03-08 21:38:56.033001	2026-03-08 21:41:04.366492
465	1	784	2026-03-07 22:08:59.263005	18	ENTREGADO	f	\N	\N	2026-03-07 22:08:59.269168	2026-03-07 22:09:52.438042
464	1	783	2026-03-07 22:08:50.993747	17	ENTREGADO	f	\N	\N	2026-03-07 22:08:51.00104	2026-03-07 22:09:52.439678
466	1	785	2026-03-07 22:09:08.943846	19	ENTREGADO	f	\N	\N	2026-03-07 22:09:08.9484	2026-03-07 22:09:52.439678
584	4	908	2026-03-08 21:40:37.762215	41	ENTREGADO	f	\N	\N	2026-03-08 21:40:37.768423	2026-03-08 21:41:04.366492
481	1	800	2026-03-07 22:41:16.930004	25	ENTREGADO	f	\N	\N	2026-03-07 22:41:16.934663	2026-03-07 22:41:52.349442
482	1	801	2026-03-07 22:41:24.247732	26	ENTREGADO	f	\N	\N	2026-03-07 22:41:24.253904	2026-03-07 22:41:52.349442
483	1	802	2026-03-07 22:41:36.60174	27	ENTREGADO	f	\N	\N	2026-03-07 22:41:36.607186	2026-03-07 22:41:52.349442
349	6	643	2026-03-01 22:02:49.798826	21	ENTREGADO	f	\N	Francesas	2026-03-01 22:02:49.880752	2026-03-01 22:40:46.41706
337	7	631	2026-03-01 20:54:37.838154	17	ENTREGADO	f	\N	\N	2026-03-01 20:54:37.848829	2026-03-01 22:20:28.398573
351	7	645	2026-03-01 22:16:40.062006	18	ENTREGADO	f	\N	\N	2026-03-01 22:16:40.08847	2026-03-01 22:20:28.398573
350	6	644	2026-03-01 22:05:16.63854	22	ENTREGADO	f	\N	\N	2026-03-01 22:05:16.651713	2026-03-01 22:40:46.41706
340	4	634	2026-03-01 21:03:53.475585	8	ENTREGADO	f	\N	\N	2026-03-01 21:03:53.600547	2026-03-01 23:06:45.318695
341	4	635	2026-03-01 21:03:53.475585	8	ENTREGADO	f	\N	\N	2026-03-01 21:03:53.668663	2026-03-01 23:06:45.319664
342	4	636	2026-03-01 21:03:53.475585	8	ENTREGADO	f	\N	\N	2026-03-01 21:03:53.693244	2026-03-01 23:06:45.319664
343	4	637	2026-03-01 21:03:53.475585	8	ENTREGADO	f	\N	\N	2026-03-01 21:03:53.746112	2026-03-01 23:06:45.319664
344	4	638	2026-03-01 21:04:52.411768	9	ENTREGADO	f	\N	\N	2026-03-01 21:04:52.427967	2026-03-01 23:06:45.319664
339	4	633	2026-03-01 21:09:09.32331	8	ENTREGADO	f	\N	\N	2026-03-01 21:03:53.564825	2026-03-01 23:06:45.319664
338	4	632	2026-03-01 21:09:33.833384	8	ENTREGADO	f	\N	\N	2026-03-01 21:03:53.485682	2026-03-01 23:06:45.319664
345	4	639	2026-03-01 21:49:44.794355	10	ENTREGADO	f	\N	\N	2026-03-01 21:49:44.817102	2026-03-01 23:06:45.319664
354	5	648	2026-03-01 23:02:39.633031	20	ENTREGADO	f	\N	\N	2026-03-01 23:02:39.677481	2026-03-01 23:44:36.059005
492	1	811	2026-03-07 22:46:19.464971	36	ENTREGADO	f	\N	\N	2026-03-07 22:46:19.472671	2026-03-07 22:47:15.889835
493	1	812	2026-03-07 22:46:37.172057	37	ENTREGADO	f	\N	\N	2026-03-07 22:46:37.177232	2026-03-07 22:47:15.889835
359	5	661	2026-03-02 20:49:59.074286	21	ENTREGADO	f	\N	Casco	2026-03-02 20:49:59.088981	2026-03-02 21:47:46.476132
360	5	662	2026-03-02 20:49:59.074286	21	ENTREGADO	f	\N	\N	2026-03-02 20:49:59.124626	2026-03-02 21:47:46.476132
361	5	663	2026-03-02 20:49:59.074286	21	ENTREGADO	f	\N	\N	2026-03-02 20:49:59.145282	2026-03-02 21:47:46.476132
362	5	664	2026-03-02 20:49:59.074286	21	ENTREGADO	f	\N	\N	2026-03-02 20:49:59.161196	2026-03-02 21:47:46.476132
365	1	667	2026-03-02 21:26:44.841173	16	ENTREGADO	f	\N	\N	2026-03-02 21:26:44.850401	2026-03-02 21:56:07.467128
368	6	670	2026-03-02 21:30:46.531734	25	ENTREGADO	f	\N	\N	2026-03-02 21:30:46.540264	2026-03-02 22:09:12.025447
369	6	671	2026-03-02 21:30:46.531734	25	ENTREGADO	f	\N	\N	2026-03-02 21:30:46.561073	2026-03-02 22:09:12.025447
386	2	692	2026-03-04 18:14:49.595405	5	ENTREGADO	f	\N	\N	2026-03-04 18:14:49.612973	2026-03-04 18:59:38.781517
387	2	693	2026-03-04 18:50:22.028046	6	ENTREGADO	f	\N	\N	2026-03-04 18:50:22.041864	2026-03-04 18:59:38.781517
502	4	821	2026-03-07 22:56:12.054311	27	ENTREGADO	f	\N	\N	2026-03-07 22:56:12.059866	2026-03-07 22:57:52.62597
504	4	823	2026-03-07 22:56:39.595629	29	ENTREGADO	f	\N	\N	2026-03-07 22:56:39.599266	2026-03-07 22:57:52.62597
505	4	824	2026-03-07 22:56:53.078688	30	ENTREGADO	f	\N	\N	2026-03-07 22:56:53.081867	2026-03-07 22:57:52.62597
495	8	814	2026-03-07 22:51:56.639563	27	ENTREGADO	f	\N	\N	2026-03-07 22:51:56.645851	2026-03-07 22:58:32.521573
396	4	703	2026-03-04 20:43:25.06559	16	ENTREGADO	f	\N	\N	2026-03-04 20:43:25.077857	2026-03-04 22:08:11.558804
397	4	704	2026-03-04 20:43:25.06559	16	ENTREGADO	f	\N	\N	2026-03-04 20:43:25.109295	2026-03-04 22:08:11.559826
398	4	705	2026-03-04 20:43:25.06559	16	ENTREGADO	f	\N	\N	2026-03-04 20:43:25.132726	2026-03-04 22:08:11.559826
399	4	706	2026-03-04 20:43:25.06559	16	ENTREGADO	f	\N	\N	2026-03-04 20:43:25.154073	2026-03-04 22:08:11.559826
400	4	707	2026-03-04 20:43:25.06559	16	ENTREGADO	f	\N	\N	2026-03-04 20:43:25.172665	2026-03-04 22:08:11.559826
496	8	815	2026-03-07 22:51:56.639563	27	ENTREGADO	f	\N	\N	2026-03-07 22:51:56.658398	2026-03-07 22:58:32.521573
497	8	816	2026-03-07 22:52:04.001435	28	ENTREGADO	f	\N	\N	2026-03-07 22:52:04.006355	2026-03-07 22:58:32.521573
406	9	724	2026-03-07 18:58:49.63948	7	ENTREGADO	f	\N	\N	2026-03-07 18:58:49.654902	2026-03-07 19:07:59.839302
407	9	725	2026-03-07 18:58:49.63948	7	ENTREGADO	f	\N	\N	2026-03-07 18:58:49.684519	2026-03-07 19:07:59.839302
498	1	817	2026-03-07 22:53:08.123639	39	ENTREGADO	f	\N	\N	2026-03-07 22:53:08.128259	2026-03-07 23:03:16.058162
499	1	818	2026-03-07 22:53:25.672787	40	ENTREGADO	f	\N	\N	2026-03-07 22:53:25.676969	2026-03-07 23:03:16.058162
500	1	819	2026-03-07 22:53:41.821936	41	ENTREGADO	f	\N	\N	2026-03-07 22:53:41.827027	2026-03-07 23:03:16.058162
511	3	830	2026-03-07 23:10:25.308929	7	ENTREGADO	f	\N	\N	2026-03-07 23:10:25.314197	2026-03-07 23:11:03.439515
512	3	831	2026-03-07 23:10:36.461544	8	ENTREGADO	f	\N	\N	2026-03-07 23:10:36.466606	2026-03-07 23:11:03.439515
415	8	734	2026-03-07 19:32:35.973975	18	ENTREGADO	f	\N	\N	2026-03-07 19:32:35.986108	2026-03-07 19:43:12.257451
418	8	737	2026-03-07 19:38:29.66841	21	ENTREGADO	f	\N	\N	2026-03-07 19:38:29.68819	2026-03-07 19:43:12.257451
420	8	739	2026-03-07 19:38:56.875248	23	ENTREGADO	f	\N	\N	2026-03-07 19:38:56.88414	2026-03-07 19:43:12.257451
422	8	741	2026-03-07 19:39:23.07221	25	ENTREGADO	f	\N	\N	2026-03-07 19:39:23.077773	2026-03-07 19:43:12.257451
513	4	832	2026-03-07 23:16:53.917442	31	ENTREGADO	f	\N	\N	2026-03-07 23:16:53.923637	2026-03-07 23:19:09.456751
514	4	833	2026-03-07 23:17:03.452591	32	ENTREGADO	f	\N	\N	2026-03-07 23:17:03.457302	2026-03-07 23:19:09.456751
516	4	835	2026-03-07 23:17:37.48195	34	ENTREGADO	f	\N	\N	2026-03-07 23:17:37.485826	2026-03-07 23:19:09.456751
439	9	758	2026-03-07 19:52:55.285393	9	ENTREGADO	f	\N	\N	2026-03-07 19:52:55.29222	2026-03-07 19:56:46.112349
440	9	759	2026-03-07 19:53:06.073385	10	ENTREGADO	f	\N	\N	2026-03-07 19:53:06.077918	2026-03-07 19:56:46.112349
441	9	760	2026-03-07 19:53:19.999682	11	ENTREGADO	f	\N	\N	2026-03-07 19:53:20.00477	2026-03-07 19:56:46.112349
442	9	761	2026-03-07 19:53:35.691467	12	ENTREGADO	f	\N	\N	2026-03-07 19:53:35.697692	2026-03-07 19:56:46.112349
452	2	771	2026-03-07 20:46:37.483144	9	ENTREGADO	f	\N	\N	2026-03-07 20:46:37.48735	2026-03-07 20:48:24.810654
453	2	772	2026-03-07 20:46:45.111995	10	ENTREGADO	f	\N	\N	2026-03-07 20:46:45.116612	2026-03-07 20:48:24.810654
454	2	773	2026-03-07 20:47:01.3711	11	ENTREGADO	f	\N	\N	2026-03-07 20:47:01.375801	2026-03-07 20:48:24.810654
455	2	774	2026-03-07 20:47:19.13427	12	ENTREGADO	f	\N	\N	2026-03-07 20:47:19.139138	2026-03-07 20:48:24.810654
451	2	770	2026-03-07 20:47:25.530783	8	ENTREGADO	f	\N	\N	2026-03-07 20:46:28.032048	2026-03-07 20:48:24.810654
444	9	763	2026-03-07 20:29:32.26956	14	ENTREGADO	f	\N	\N	2026-03-07 20:29:32.285151	2026-03-07 20:54:00.444244
450	9	769	2026-03-07 20:43:42.692717	19	ENTREGADO	f	\N	\N	2026-03-07 20:43:42.699764	2026-03-07 20:54:00.444244
517	4	836	2026-03-07 23:17:58.804621	35	ENTREGADO	f	\N	\N	2026-03-07 23:17:58.810452	2026-03-07 23:19:09.456751
515	4	834	2026-03-07 23:18:17.448215	33	ENTREGADO	f	\N	\N	2026-03-07 23:17:22.674411	2026-03-07 23:19:09.456751
585	3	909	2026-03-08 21:44:04.12559	10	ENTREGADO	f	\N	\N	2026-03-08 21:44:04.126113	2026-03-08 21:44:13.287391
586	3	910	2026-03-08 21:44:04.12559	10	ENTREGADO	f	\N	\N	2026-03-08 21:44:04.147051	2026-03-08 21:44:13.287391
518	1	837	2026-03-07 23:24:04.458568	43	ENTREGADO	f	\N	\N	2026-03-07 23:24:04.464213	2026-03-07 23:25:24.814641
520	1	839	2026-03-07 23:24:45.547206	45	ENTREGADO	f	\N	\N	2026-03-07 23:24:45.551455	2026-03-07 23:25:24.814641
521	1	840	2026-03-07 23:25:01.031033	46	ENTREGADO	f	\N	\N	2026-03-07 23:25:01.036759	2026-03-07 23:25:24.816168
587	3	911	2026-03-08 21:44:04.12559	10	ENTREGADO	f	\N	\N	2026-03-08 21:44:04.15731	2026-03-08 21:44:13.287391
605	5	929	2026-03-08 22:08:32.167633	23	ENTREGADO	f	\N	\N	2026-03-08 22:08:32.178048	2026-03-08 22:23:14.642308
606	5	930	2026-03-08 22:08:32.167633	23	ENTREGADO	f	\N	\N	2026-03-08 22:08:32.197562	2026-03-08 22:23:14.642308
607	5	931	2026-03-08 22:08:32.167633	23	ENTREGADO	f	\N	\N	2026-03-08 22:08:32.210303	2026-03-08 22:23:14.642308
608	5	932	2026-03-08 22:08:32.167633	23	ENTREGADO	f	\N	\N	2026-03-08 22:08:32.222166	2026-03-08 22:23:14.642308
617	6	941	2026-03-08 22:32:54.722834	29	ENTREGADO	f	\N	\N	2026-03-08 22:32:54.745575	2026-03-08 22:34:05.747002
618	6	942	2026-03-08 22:32:54.722834	29	ENTREGADO	f	\N	\N	2026-03-08 22:32:54.763882	2026-03-08 22:34:05.747002
619	6	943	2026-03-08 22:32:54.722834	29	ENTREGADO	f	\N	\N	2026-03-08 22:32:54.776566	2026-03-08 22:34:05.747002
620	6	944	2026-03-08 22:32:54.722834	29	ENTREGADO	f	\N	\N	2026-03-08 22:32:54.787415	2026-03-08 22:34:05.747002
621	6	945	2026-03-08 22:32:54.722834	29	ENTREGADO	f	\N	\N	2026-03-08 22:32:54.798554	2026-03-08 22:34:05.747002
588	2	912	2026-03-08 21:49:04.078642	18	ENTREGADO	f	\N	\N	2026-03-08 21:49:04.08363	2026-03-08 22:34:29.76928
589	2	913	2026-03-08 21:49:04.078642	18	ENTREGADO	f	\N	\N	2026-03-08 21:49:04.100552	2026-03-08 22:34:29.76928
590	2	914	2026-03-08 21:49:04.078642	18	ENTREGADO	f	\N	\N	2026-03-08 21:49:04.110622	2026-03-08 22:34:29.76928
591	2	915	2026-03-08 21:49:04.078642	18	ENTREGADO	f	\N	\N	2026-03-08 21:49:04.120165	2026-03-08 22:34:29.76928
592	2	916	2026-03-08 21:49:04.078642	18	ENTREGADO	f	\N	\N	2026-03-08 21:49:04.136759	2026-03-08 22:34:29.76928
623	1	947	2026-03-08 22:41:07.954307	55	ENTREGADO	f	\N	\N	2026-03-08 22:41:07.990511	2026-03-08 22:41:54.410543
624	1	948	2026-03-08 22:41:07.954307	55	ENTREGADO	f	\N	\N	2026-03-08 22:41:08.00618	2026-03-08 22:41:54.410543
625	1	949	2026-03-08 22:41:07.954307	55	ENTREGADO	f	\N	\N	2026-03-08 22:41:08.020338	2026-03-08 22:41:54.410543
626	1	950	2026-03-08 22:41:35.426159	56	ENTREGADO	f	\N	\N	2026-03-08 22:41:35.426159	2026-03-08 22:41:54.410543
627	5	951	2026-03-08 23:00:45.560437	24	ENTREGADO	f	\N	\N	2026-03-08 23:00:45.574418	2026-03-08 23:22:12.946893
628	5	952	2026-03-08 23:18:46.249027	24	ENTREGADO	f	\N	\N	2026-03-08 23:00:45.594722	2026-03-08 23:22:12.946893
630	6	954	2026-03-09 20:33:27.877007	30	ENTREGADO	f	\N	\N	2026-03-09 20:33:27.889599	2026-03-09 20:46:27.898582
631	6	955	2026-03-09 20:33:27.877007	30	ENTREGADO	f	\N	\N	2026-03-09 20:33:27.906915	2026-03-09 20:46:27.898582
632	6	956	2026-03-09 20:33:27.877007	30	ENTREGADO	f	\N	\N	2026-03-09 20:33:27.925127	2026-03-09 20:46:27.898582
633	5	957	2026-03-09 20:34:37.533064	25	ENTREGADO	f	\N	\N	2026-03-09 20:34:37.539774	2026-03-09 21:01:50.933483
634	5	958	2026-03-09 20:34:37.533064	25	ENTREGADO	f	\N	\N	2026-03-09 20:34:37.557489	2026-03-09 21:01:50.933483
635	5	959	2026-03-09 20:34:37.533064	25	ENTREGADO	f	\N	\N	2026-03-09 20:34:37.582281	2026-03-09 21:01:50.933483
636	5	960	2026-03-09 20:34:37.533064	25	ENTREGADO	f	\N	\N	2026-03-09 20:34:37.603255	2026-03-09 21:01:50.933483
629	7	953	2026-03-09 20:32:51.908671	24	ENTREGADO	f	\N	\N	2026-03-09 20:32:51.928486	2026-03-09 21:14:51.414182
519	1	838	2026-03-07 23:24:29.493812	44	ENTREGADO	f	\N	\N	2026-03-07 23:24:29.498354	2026-03-07 23:25:24.816168
522	1	841	2026-03-07 23:25:10.80495	47	ENTREGADO	f	\N	\N	2026-03-07 23:25:10.811668	2026-03-07 23:25:24.816168
523	1	842	2026-03-07 23:25:19.822986	48	ENTREGADO	f	\N	\N	2026-03-07 23:25:19.830714	2026-03-07 23:25:24.816168
524	1	843	2026-03-07 23:27:13.358805	49	ENTREGADO	f	\N	\N	2026-03-07 23:27:13.363694	2026-03-07 23:28:29.503835
525	1	844	2026-03-07 23:27:13.358805	49	ENTREGADO	f	\N	\N	2026-03-07 23:27:13.373318	2026-03-07 23:28:29.503835
526	1	845	2026-03-07 23:27:38.810102	50	ENTREGADO	f	\N	\N	2026-03-07 23:27:38.814477	2026-03-07 23:28:29.503835
527	1	846	2026-03-07 23:27:38.810102	50	ENTREGADO	f	\N	\N	2026-03-07 23:27:38.823808	2026-03-07 23:28:29.503835
528	1	847	2026-03-07 23:27:38.810102	50	ENTREGADO	f	\N	\N	2026-03-07 23:27:38.836864	2026-03-07 23:28:29.503835
529	4	848	2026-03-07 23:30:59.848206	36	ENTREGADO	f	\N	\N	2026-03-07 23:30:59.854554	2026-03-07 23:31:07.536936
530	4	849	2026-03-07 23:30:59.848206	36	ENTREGADO	f	\N	\N	2026-03-07 23:30:59.864796	2026-03-07 23:31:07.536936
598	1	922	2026-03-08 21:56:03.046057	54	ENTREGADO	f	\N	\N	2026-03-08 21:56:03.051529	2026-03-08 21:56:18.703226
599	1	923	2026-03-08 21:56:03.046057	54	ENTREGADO	f	\N	\N	2026-03-08 21:56:03.062344	2026-03-08 21:56:18.703226
600	1	924	2026-03-08 21:56:03.046057	54	ENTREGADO	f	\N	\N	2026-03-08 21:56:03.072116	2026-03-08 21:56:18.703226
531	8	850	2026-03-07 23:32:36.592757	29	ENTREGADO	f	\N	\N	2026-03-07 23:32:36.601464	2026-03-07 23:41:20.802934
532	8	851	2026-03-07 23:32:36.592757	29	ENTREGADO	f	\N	\N	2026-03-07 23:32:36.627158	2026-03-07 23:41:20.802934
533	8	852	2026-03-07 23:32:36.592757	29	ENTREGADO	f	\N	\N	2026-03-07 23:32:36.643986	2026-03-07 23:41:20.802934
534	8	853	2026-03-07 23:32:36.592757	29	ENTREGADO	f	\N	\N	2026-03-07 23:32:36.657066	2026-03-07 23:41:20.802934
535	8	854	2026-03-07 23:39:51.357279	30	ENTREGADO	f	\N	\N	2026-03-07 23:39:51.364332	2026-03-07 23:41:20.802934
601	1	925	2026-03-08 21:56:03.046057	54	ENTREGADO	f	\N	\N	2026-03-08 21:56:03.084402	2026-03-08 21:56:18.703226
602	1	926	2026-03-08 21:56:03.046057	54	ENTREGADO	f	\N	\N	2026-03-08 21:56:03.096937	2026-03-08 21:56:18.703226
603	1	927	2026-03-08 21:56:03.046057	54	ENTREGADO	f	\N	\N	2026-03-08 21:56:03.106969	2026-03-08 21:56:18.703226
536	4	855	2026-03-08 00:09:19.247177	37	ENTREGADO	f	\N	\N	2026-03-08 00:09:19.262677	2026-03-08 00:19:05.641931
537	4	856	2026-03-08 00:09:19.247177	37	ENTREGADO	f	\N	\N	2026-03-08 00:09:19.299749	2026-03-08 00:19:05.641931
538	4	857	2026-03-08 00:09:19.247177	37	ENTREGADO	f	\N	\N	2026-03-08 00:09:19.313754	2026-03-08 00:19:05.641931
604	1	928	2026-03-08 21:56:03.046057	54	ENTREGADO	f	\N	\N	2026-03-08 21:56:03.119585	2026-03-08 21:56:18.703226
593	6	917	2026-03-08 21:54:33.552022	28	ENTREGADO	f	\N	\N	2026-03-08 21:54:33.56258	2026-03-08 22:06:26.570082
594	6	918	2026-03-08 21:54:33.552022	28	ENTREGADO	f	\N	\N	2026-03-08 21:54:33.578655	2026-03-08 22:06:26.570082
596	6	920	2026-03-08 21:54:33.552022	28	ENTREGADO	f	\N	\N	2026-03-08 21:54:33.603541	2026-03-08 22:06:26.570082
597	6	921	2026-03-08 21:54:33.552022	28	ENTREGADO	f	\N	\N	2026-03-08 21:54:33.615976	2026-03-08 22:06:26.570082
539	1	861	2026-03-08 18:59:30.935494	51	ENTREGADO	f	\N	\N	2026-03-08 18:59:30.943796	2026-03-08 19:03:47.129545
540	1	862	2026-03-08 18:59:30.935494	51	ENTREGADO	f	\N	\N	2026-03-08 18:59:30.970022	2026-03-08 19:03:47.129545
541	1	863	2026-03-08 18:59:30.935494	51	ENTREGADO	f	\N	\N	2026-03-08 18:59:30.987858	2026-03-08 19:03:47.129545
546	7	868	2026-03-08 19:16:51.592714	22	ENTREGADO	f	\N	\N	2026-03-08 19:16:51.606256	2026-03-08 19:24:27.88884
547	9	869	2026-03-08 19:18:21.035264	20	ENTREGADO	f	\N	\N	2026-03-08 19:18:21.044381	2026-03-08 22:15:16.328349
609	8	933	2026-03-08 22:12:58.450439	34	ENTREGADO	f	\N	\N	2026-03-08 22:12:58.460465	2026-03-08 22:25:01.0666
610	8	934	2026-03-08 22:12:58.450439	34	ENTREGADO	f	\N	\N	2026-03-08 22:12:58.476507	2026-03-08 22:25:01.0666
611	8	935	2026-03-08 22:12:58.450439	34	ENTREGADO	f	\N	\N	2026-03-08 22:12:58.487611	2026-03-08 22:25:01.0666
612	8	936	2026-03-08 22:12:58.450439	34	ENTREGADO	f	\N	\N	2026-03-08 22:12:58.497277	2026-03-08 22:25:01.0666
613	8	937	2026-03-08 22:12:58.450439	34	ENTREGADO	f	\N	\N	2026-03-08 22:12:58.516502	2026-03-08 22:25:01.0666
614	8	938	2026-03-08 22:12:58.450439	34	ENTREGADO	f	\N	\N	2026-03-08 22:12:58.526485	2026-03-08 22:25:01.0666
615	8	939	2026-03-08 22:12:58.450439	34	ENTREGADO	f	\N	\N	2026-03-08 22:12:58.538268	2026-03-08 22:25:01.0666
563	7	885	2026-03-08 20:10:34.639451	23	ENTREGADO	f	\N	\N	2026-03-08 20:10:34.648604	2026-03-08 22:31:04.96028
548	1	870	2026-03-08 19:26:10.300888	52	ENTREGADO	f	\N	\N	2026-03-08 19:26:10.313793	2026-03-08 19:43:37.908235
549	1	871	2026-03-08 19:26:10.300888	52	ENTREGADO	f	\N	\N	2026-03-08 19:26:10.333109	2026-03-08 19:43:37.908235
550	1	872	2026-03-08 19:26:10.300888	52	ENTREGADO	f	\N	\N	2026-03-08 19:26:10.349574	2026-03-08 19:43:37.908235
562	1	884	2026-03-08 19:40:53.665546	53	ENTREGADO	f	\N	\N	2026-03-08 19:40:53.669256	2026-03-08 19:43:37.908744
542	2	864	2026-03-08 19:00:54.033059	16	ENTREGADO	f	\N	\N	2026-03-08 19:00:54.042466	2026-03-08 19:44:40.787267
543	2	865	2026-03-08 19:00:54.033059	16	ENTREGADO	f	\N	\N	2026-03-08 19:00:54.064592	2026-03-08 19:44:40.787267
544	2	866	2026-03-08 19:00:54.033059	16	ENTREGADO	f	\N	\N	2026-03-08 19:00:54.082989	2026-03-08 19:44:40.787267
545	2	867	2026-03-08 19:00:54.033059	16	ENTREGADO	f	\N	\N	2026-03-08 19:00:54.101618	2026-03-08 19:44:40.787267
551	8	873	2026-03-08 19:38:58.137196	31	ENTREGADO	f	\N	\N	2026-03-08 19:38:58.143572	2026-03-08 20:09:58.058827
552	8	874	2026-03-08 19:38:58.137196	31	ENTREGADO	f	\N	\N	2026-03-08 19:38:58.161626	2026-03-08 20:09:58.058827
553	8	875	2026-03-08 19:38:58.137196	31	ENTREGADO	f	\N	\N	2026-03-08 19:38:58.175893	2026-03-08 20:09:58.058827
554	8	876	2026-03-08 19:38:58.137196	31	ENTREGADO	f	\N	\N	2026-03-08 19:38:58.193139	2026-03-08 20:09:58.058827
555	8	877	2026-03-08 19:38:58.137196	31	ENTREGADO	f	\N	\N	2026-03-08 19:38:58.209831	2026-03-08 20:09:58.058827
556	8	878	2026-03-08 19:38:58.137196	31	ENTREGADO	f	\N	\N	2026-03-08 19:38:58.226746	2026-03-08 20:09:58.058827
557	8	879	2026-03-08 19:38:58.137196	31	ENTREGADO	f	\N	\N	2026-03-08 19:38:58.242886	2026-03-08 20:09:58.060842
616	6	940	2026-03-08 22:32:54.722834	29	ENTREGADO	f	\N	\N	2026-03-08 22:32:54.728513	2026-03-08 22:34:05.747002
558	3	880	2026-03-08 19:39:38.685493	9	ENTREGADO	f	\N	\N	2026-03-08 19:39:38.697453	2026-03-08 20:29:55.834172
559	3	881	2026-03-08 19:39:38.685493	9	ENTREGADO	f	\N	\N	2026-03-08 19:39:38.713001	2026-03-08 20:29:55.834172
560	3	882	2026-03-08 19:39:38.685493	9	ENTREGADO	f	\N	\N	2026-03-08 19:39:38.725968	2026-03-08 20:29:55.834172
561	3	883	2026-03-08 19:39:38.685493	9	ENTREGADO	f	\N	\N	2026-03-08 19:39:38.739445	2026-03-08 20:29:55.834172
622	1	946	2026-03-08 22:41:07.954307	55	ENTREGADO	f	\N	\N	2026-03-08 22:41:07.965659	2026-03-08 22:41:54.410543
565	8	887	2026-03-08 20:15:30.651552	32	ENTREGADO	f	\N	\N	2026-03-08 20:15:30.677791	2026-03-08 20:45:52.583358
566	8	888	2026-03-08 20:15:30.651552	32	ENTREGADO	f	\N	\N	2026-03-08 20:15:30.689084	2026-03-08 20:45:52.583358
567	8	889	2026-03-08 20:15:30.651552	32	ENTREGADO	f	\N	\N	2026-03-08 20:15:30.701608	2026-03-08 20:45:52.583358
568	8	890	2026-03-08 20:15:30.651552	32	ENTREGADO	f	\N	\N	2026-03-08 20:15:30.71536	2026-03-08 20:45:52.583358
569	8	891	2026-03-08 20:15:30.651552	32	ENTREGADO	f	\N	\N	2026-03-08 20:15:30.729963	2026-03-08 20:45:52.583358
570	8	892	2026-03-08 20:15:30.651552	32	ENTREGADO	f	\N	\N	2026-03-08 20:15:30.743501	2026-03-08 20:45:52.583358
577	8	900	2026-03-08 20:40:13.01888	33	ENTREGADO	f	\N	\N	2026-03-08 20:40:13.026089	2026-03-08 20:45:52.583358
571	2	894	2026-03-08 20:34:35.818783	17	ENTREGADO	f	\N	\N	2026-03-08 20:34:35.829273	2026-03-08 21:02:09.979658
572	2	895	2026-03-08 20:34:35.818783	17	ENTREGADO	f	\N	\N	2026-03-08 20:34:35.852803	2026-03-08 21:02:09.979658
573	2	896	2026-03-08 20:34:35.818783	17	ENTREGADO	f	\N	\N	2026-03-08 20:34:35.868929	2026-03-08 21:02:09.979658
574	2	897	2026-03-08 20:34:35.818783	17	ENTREGADO	f	\N	\N	2026-03-08 20:34:35.885161	2026-03-08 21:02:09.979658
575	2	898	2026-03-08 20:34:35.818783	17	ENTREGADO	f	\N	\N	2026-03-08 20:34:35.899348	2026-03-08 21:02:09.979658
\.


--
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner: morales_user
--

COPY public.notifications (id, type, title, message, severity, target_roles, reference_type, reference_id, is_read, read_by, read_at, created_at, updated_at) FROM stdin;
1	TABLE_IDLE	Mesa #1 sin actividad	La mesa #1 no ha tenido movimientos en los últimos 15 minutos	INFO	["ADMIN", "SUPERVISOR"]	TABLE	2	t	1	2026-02-09 21:51:41.19233	2026-02-09 21:31:09.875718	2026-02-09 21:51:41.193341
120	TABLE_IDLE	Mesa #1 sin actividad	La mesa #1 no ha tenido movimientos en los últimos 15 minutos	INFO	["ADMIN", "SUPERVISOR"]	TABLE	2	t	\N	2026-03-01 19:33:21.042808	2026-02-28 23:07:49.88526	2026-02-28 23:07:49.88526
3	TABLE_IDLE	Mesa #1 sin actividad	La mesa #1 no ha tenido movimientos en los últimos 15 minutos	INFO	["ADMIN", "SUPERVISOR"]	TABLE	2	t	1	2026-02-09 21:57:15.524045	2026-02-09 21:56:09.96164	2026-02-09 21:57:15.524045
2	TABLE_LONG_OPEN	Mesa #1 abierta mucho tiempo	La mesa #1 lleva abierta desde 21:13:01.589042 (43 minutos)	WARNING	["ADMIN", "SUPERVISOR", "MESERO"]	TABLE	2	t	1	2026-02-09 21:58:17.695146	2026-02-09 21:56:09.873987	2026-02-09 21:58:17.696151
4	TABLE_IDLE	Mesa #1 sin actividad	La mesa #1 no ha tenido movimientos en los últimos 15 minutos	INFO	["ADMIN", "SUPERVISOR"]	TABLE	2	t	1	2026-02-09 22:43:03.404933	2026-02-09 22:15:39.003247	2026-02-09 22:43:03.425191
6	TABLE_IDLE	Mesa #4 sin actividad	La mesa #4 no ha tenido movimientos en los últimos 15 minutos	INFO	["ADMIN", "SUPERVISOR"]	TABLE	4	t	1	2026-02-09 23:24:11.914567	2026-02-09 22:50:56.072997	2026-02-09 23:24:11.920102
5	TABLE_IDLE	Mesa #3 sin actividad	La mesa #3 no ha tenido movimientos en los últimos 15 minutos	INFO	["ADMIN", "SUPERVISOR"]	TABLE	1	t	1	2026-02-09 23:24:16.386642	2026-02-09 22:45:56.060951	2026-02-09 23:24:16.387155
130	LOW_STOCK	Stock bajo: Hamburguesa Sencilla	El producto Hamburguesa Sencilla tiene 5 unidades (mínimo: 5)	WARNING	["ADMIN", "INVENTARIO"]	PRODUCT	10	t	\N	2026-03-05 21:51:13.696249	2026-03-01 20:11:57.088881	2026-03-01 20:11:57.088881
131	TABLE_IDLE	Mesa #7 sin actividad	La mesa #7 no ha tenido movimientos en los últimos 15 minutos	INFO	["ADMIN", "SUPERVISOR"]	TABLE	8	t	\N	2026-03-05 21:51:13.696249	2026-03-01 20:12:49.891366	2026-03-01 20:12:49.891366
132	TABLE_IDLE	Mesa #2 sin actividad	La mesa #2 no ha tenido movimientos en los últimos 15 minutos	INFO	["ADMIN", "SUPERVISOR"]	TABLE	3	t	\N	2026-03-05 21:51:13.696249	2026-03-01 20:12:49.897191	2026-03-01 20:12:49.897191
141	TABLE_LONG_OPEN	Mesa #8 abierta mucho tiempo	La mesa #8 lleva abierta desde 20:39:20.591335 (43 minutos)	WARNING	["ADMIN", "SUPERVISOR", "MESERO"]	TABLE	7	t	\N	2026-03-05 21:51:13.696249	2026-03-01 21:22:49.895692	2026-03-01 21:22:49.895692
142	TABLE_LONG_OPEN	Mesa #5 abierta mucho tiempo	La mesa #5 lleva abierta desde 20:50:41.738287 (42 minutos)	WARNING	["ADMIN", "SUPERVISOR", "MESERO"]	TABLE	5	t	\N	2026-03-05 21:51:13.696249	2026-03-01 21:32:49.876681	2026-03-01 21:32:49.876681
148	LOW_STOCK	Stock bajo: Costilla	El producto Costilla tiene 5 unidades (mínimo: 5)	WARNING	["ADMIN", "INVENTARIO"]	PRODUCT	2	t	\N	2026-03-05 21:51:13.696249	2026-03-04 20:04:29.209313	2026-03-04 20:04:29.209313
154	LOW_STOCK	Stock bajo: Costilla	El producto Costilla tiene 4 unidades (mínimo: 5)	WARNING	["ADMIN", "INVENTARIO"]	PRODUCT	2	f	\N	\N	2026-03-07 19:51:42.483025	2026-03-07 19:51:42.483025
163	TABLE_IDLE	Mesa #2 sin actividad	La mesa #2 no ha tenido movimientos en los últimos 15 minutos	INFO	["ADMIN", "SUPERVISOR"]	TABLE	3	f	\N	\N	2026-03-07 22:22:24.385317	2026-03-07 22:22:24.385317
168	TABLE_LONG_OPEN	Mesa #1 abierta mucho tiempo	La mesa #1 lleva abierta desde 19:00:53.949516 (41 minutos)	WARNING	["ADMIN", "SUPERVISOR", "MESERO"]	TABLE	2	f	\N	\N	2026-03-08 19:42:24.377419	2026-03-08 19:42:24.377419
174	VOID_ATTEMPT	Anulación de factura	El usuario Administrador anuló la factura V0308-0003	CRITICAL	["ADMIN", "SUPERVISOR"]	INVOICE	\N	f	\N	\N	2026-03-08 23:33:08.414866	2026-03-08 23:33:08.414866
20	LOW_STOCK	Stock bajo: Uva	El producto Uva tiene 49 unidades (mínimo: 100)	WARNING	["ADMIN", "INVENTARIO"]	PRODUCT	42	t	1	2026-02-16 08:32:26.01803	2026-02-16 08:31:00.562971	2026-02-16 08:32:26.019026
7	TABLE_IDLE	Mesa #2 sin actividad	La mesa #2 no ha tenido movimientos en los últimos 15 minutos	INFO	["ADMIN", "SUPERVISOR"]	TABLE	3	t	\N	2026-02-16 08:32:32.049902	2026-02-10 09:09:23.279385	2026-02-10 09:09:23.279385
8	TABLE_IDLE	Mesa #4 sin actividad	La mesa #4 no ha tenido movimientos en los últimos 15 minutos	INFO	["ADMIN", "SUPERVISOR"]	TABLE	4	t	\N	2026-02-16 08:32:32.049902	2026-02-10 09:14:23.283995	2026-02-10 09:14:23.283995
9	TABLE_IDLE	Mesa #7 sin actividad	La mesa #7 no ha tenido movimientos en los últimos 15 minutos	INFO	["ADMIN", "SUPERVISOR"]	TABLE	8	t	\N	2026-02-16 08:32:32.049902	2026-02-10 09:14:23.293991	2026-02-10 09:14:23.293991
10	TABLE_LONG_OPEN	Mesa #2 abierta mucho tiempo	La mesa #2 lleva abierta desde 08:52:12.488293 (42 minutos)	WARNING	["ADMIN", "SUPERVISOR", "MESERO"]	TABLE	3	t	\N	2026-02-16 08:32:32.049902	2026-02-10 09:34:23.276689	2026-02-10 09:34:23.276689
11	TABLE_LONG_OPEN	Mesa #4 abierta mucho tiempo	La mesa #4 lleva abierta desde 20:10:20.508346 (43 minutos)	WARNING	["ADMIN", "SUPERVISOR", "MESERO"]	TABLE	4	t	\N	2026-02-16 08:32:32.049902	2026-02-10 20:54:14.71908	2026-02-10 20:54:14.71908
12	TABLE_IDLE	Mesa #1 sin actividad	La mesa #1 no ha tenido movimientos en los últimos 15 minutos	INFO	["ADMIN", "SUPERVISOR"]	TABLE	2	t	\N	2026-02-16 08:32:32.049902	2026-02-11 13:47:44.157587	2026-02-11 13:47:44.157587
13	TABLE_LONG_OPEN	Mesa #1 abierta mucho tiempo	La mesa #1 lleva abierta desde 13:31:47.916504 (40 minutos)	WARNING	["ADMIN", "SUPERVISOR", "MESERO"]	TABLE	2	t	\N	2026-02-16 08:32:32.049902	2026-02-11 14:12:44.157919	2026-02-11 14:12:44.157919
14	TABLE_LONG_OPEN	Mesa #7 abierta mucho tiempo	La mesa #7 lleva abierta desde 13:40:52.304354 (41 minutos)	WARNING	["ADMIN", "SUPERVISOR", "MESERO"]	TABLE	8	t	\N	2026-02-16 08:32:32.049902	2026-02-11 14:22:44.195758	2026-02-11 14:22:44.195758
15	TABLE_IDLE	Mesa #3 sin actividad	La mesa #3 no ha tenido movimientos en los últimos 15 minutos	INFO	["ADMIN", "SUPERVISOR"]	TABLE	1	t	\N	2026-02-16 08:32:32.049902	2026-02-11 17:27:44.168987	2026-02-11 17:27:44.168987
21	TABLE_IDLE	Mesa #5 sin actividad	La mesa #5 no ha tenido movimientos en los últimos 15 minutos	INFO	["ADMIN", "SUPERVISOR"]	TABLE	5	t	\N	2026-02-16 11:24:19.477134	2026-02-16 08:36:32.218397	2026-02-16 08:36:32.218397
16	TABLE_LONG_OPEN	Mesa #3 abierta mucho tiempo	La mesa #3 lleva abierta desde 17:12:40.316996 (40 minutos)	WARNING	["ADMIN", "SUPERVISOR", "MESERO"]	TABLE	1	t	\N	2026-02-16 08:32:32.049902	2026-02-11 17:52:44.176062	2026-02-11 17:52:44.176062
17	TABLE_IDLE	Mesa #8 sin actividad	La mesa #8 no ha tenido movimientos en los últimos 15 minutos	INFO	["ADMIN", "SUPERVISOR"]	TABLE	7	t	\N	2026-02-16 08:32:32.049902	2026-02-13 17:47:33.278953	2026-02-13 17:47:33.278953
18	TABLE_LONG_OPEN	Mesa #8 abierta mucho tiempo	La mesa #8 lleva abierta desde 17:27:43.949919 (44 minutos)	WARNING	["ADMIN", "SUPERVISOR", "MESERO"]	TABLE	7	t	\N	2026-02-16 08:32:32.049902	2026-02-13 18:12:33.233703	2026-02-13 18:12:33.233703
19	TABLE_IDLE	Mesa #5 sin actividad	La mesa #5 no ha tenido movimientos en los últimos 15 minutos	INFO	["ADMIN", "SUPERVISOR"]	TABLE	5	t	\N	2026-02-16 08:32:32.049902	2026-02-16 08:21:31.987024	2026-02-16 08:21:31.987024
121	TABLE_LONG_OPEN	Mesa #8 abierta mucho tiempo	La mesa #8 lleva abierta desde 22:29:18.699439 (43 minutos)	WARNING	["ADMIN", "SUPERVISOR", "MESERO"]	TABLE	7	t	\N	2026-03-01 19:33:21.042808	2026-02-28 23:12:49.869973	2026-02-28 23:12:49.869973
122	TABLE_IDLE	Mesa #3 sin actividad	La mesa #3 no ha tenido movimientos en los últimos 15 minutos	INFO	["ADMIN", "SUPERVISOR"]	TABLE	1	t	\N	2026-03-01 19:33:21.042808	2026-02-28 23:12:49.889216	2026-02-28 23:12:49.889216
123	TABLE_IDLE	Mesa #8 sin actividad	La mesa #8 no ha tenido movimientos en los últimos 15 minutos	INFO	["ADMIN", "SUPERVISOR"]	TABLE	7	t	\N	2026-03-01 19:33:21.042808	2026-02-28 23:22:49.885635	2026-02-28 23:22:49.885635
22	TABLE_LONG_OPEN	Mesa #5 abierta mucho tiempo	La mesa #5 lleva abierta desde 08:04:33.108929 (41 minutos)	WARNING	["ADMIN", "SUPERVISOR", "MESERO"]	TABLE	5	t	\N	2026-02-16 11:24:19.477134	2026-02-16 08:46:32.104805	2026-02-16 08:46:32.104805
23	TABLE_IDLE	Mesa #7 sin actividad	La mesa #7 no ha tenido movimientos en los últimos 15 minutos	INFO	["ADMIN", "SUPERVISOR"]	TABLE	8	t	\N	2026-02-16 11:24:19.477134	2026-02-16 08:46:32.152945	2026-02-16 08:46:32.152945
24	TABLE_LONG_OPEN	Mesa #7 abierta mucho tiempo	La mesa #7 lleva abierta desde 08:31:15.877021 (40 minutos)	WARNING	["ADMIN", "SUPERVISOR", "MESERO"]	TABLE	8	t	\N	2026-02-16 11:24:19.477134	2026-02-16 09:11:32.445734	2026-02-16 09:11:32.445734
25	LOW_STOCK	Stock bajo: Entradas	El producto Entradas tiene 1 unidades (mínimo: 3)	WARNING	["ADMIN", "INVENTARIO"]	PRODUCT	4	t	\N	2026-02-16 11:24:19.477134	2026-02-16 09:11:46.616059	2026-02-16 09:11:46.616059
26	TABLE_IDLE	Mesa #1 sin actividad	La mesa #1 no ha tenido movimientos en los últimos 15 minutos	INFO	["ADMIN", "SUPERVISOR"]	TABLE	2	t	\N	2026-02-16 11:24:19.477134	2026-02-16 10:08:50.384517	2026-02-16 10:08:50.384517
27	TABLE_LONG_OPEN	Mesa #1 abierta mucho tiempo	La mesa #1 lleva abierta desde 09:46:59.795366 (41 minutos)	WARNING	["ADMIN", "SUPERVISOR", "MESERO"]	TABLE	2	t	\N	2026-02-16 11:24:19.477134	2026-02-16 10:28:50.358064	2026-02-16 10:28:50.358064
133	TABLE_IDLE	Mesa #9 sin actividad	La mesa #9 no ha tenido movimientos en los últimos 15 minutos	INFO	["ADMIN", "SUPERVISOR"]	TABLE	9	t	\N	2026-03-05 21:51:13.696249	2026-03-01 20:27:49.893919	2026-03-01 20:27:49.893919
135	TABLE_LONG_OPEN	Mesa #2 abierta mucho tiempo	La mesa #2 lleva abierta desde 19:55:41.705323 (42 minutos)	WARNING	["ADMIN", "SUPERVISOR", "MESERO"]	TABLE	3	t	\N	2026-03-05 21:51:13.696249	2026-03-01 20:37:49.875199	2026-03-01 20:37:49.875199
155	TABLE_IDLE	Mesa #4 sin actividad	La mesa #4 no ha tenido movimientos en los últimos 15 minutos	INFO	["ADMIN", "SUPERVISOR"]	TABLE	4	f	\N	\N	2026-03-07 19:57:24.40065	2026-03-07 19:57:24.40065
156	TABLE_LONG_OPEN	Mesa #8 abierta mucho tiempo	La mesa #8 lleva abierta desde 19:25:29.307246 (41 minutos)	WARNING	["ADMIN", "SUPERVISOR", "MESERO"]	TABLE	7	f	\N	\N	2026-03-07 20:07:24.390593	2026-03-07 20:07:24.390593
157	TABLE_IDLE	Mesa #6 sin actividad	La mesa #6 no ha tenido movimientos en los últimos 15 minutos	INFO	["ADMIN", "SUPERVISOR"]	TABLE	6	f	\N	\N	2026-03-07 20:07:24.407797	2026-03-07 20:07:24.407797
28	TABLE_IDLE	Mesa #4 sin actividad	La mesa #4 no ha tenido movimientos en los últimos 15 minutos	INFO	["ADMIN", "SUPERVISOR"]	TABLE	4	t	\N	2026-02-16 18:35:29.647489	2026-02-16 12:33:40.468758	2026-02-16 12:33:40.468758
29	TABLE_LONG_OPEN	Mesa #4 abierta mucho tiempo	La mesa #4 lleva abierta desde 12:17:48.996197 (40 minutos)	WARNING	["ADMIN", "SUPERVISOR", "MESERO"]	TABLE	4	t	\N	2026-02-16 18:35:29.647489	2026-02-16 12:58:40.444929	2026-02-16 12:58:40.444929
30	VOID_ATTEMPT	Anulación de factura	El usuario Tatiana agudelo anuló la factura V0216-0002	CRITICAL	["ADMIN", "SUPERVISOR"]	INVOICE	\N	t	\N	2026-02-16 18:35:29.647489	2026-02-16 17:18:22.572216	2026-02-16 17:18:22.572216
31	VOID_ATTEMPT	Anulación de factura	El usuario Tatiana agudelo anuló la factura M4-0216-0001	CRITICAL	["ADMIN", "SUPERVISOR"]	INVOICE	\N	t	\N	2026-02-16 18:35:29.647489	2026-02-16 17:18:28.326785	2026-02-16 17:18:28.326785
32	VOID_ATTEMPT	Anulación de factura	El usuario Tatiana agudelo anuló la factura M1-0216-0001	CRITICAL	["ADMIN", "SUPERVISOR"]	INVOICE	\N	t	\N	2026-02-16 18:35:29.647489	2026-02-16 17:18:33.25962	2026-02-16 17:18:33.25962
34	VOID_ATTEMPT	Anulación de factura	El usuario Tatiana agudelo anuló la factura M7-0216-0001	CRITICAL	["ADMIN", "SUPERVISOR"]	INVOICE	\N	t	\N	2026-02-16 18:35:29.647489	2026-02-16 17:18:39.504733	2026-02-16 17:18:39.504733
35	VOID_ATTEMPT	Anulación de factura	El usuario Tatiana agudelo anuló la factura V0216-0001	CRITICAL	["ADMIN", "SUPERVISOR"]	INVOICE	\N	t	\N	2026-02-16 18:35:29.647489	2026-02-16 17:18:44.0698	2026-02-16 17:18:44.0698
37	VOID_ATTEMPT	Anulación de factura	El usuario Tatiana agudelo anuló la factura M5-0216-0001	CRITICAL	["ADMIN", "SUPERVISOR"]	INVOICE	\N	t	\N	2026-02-16 18:35:29.647489	2026-02-16 17:18:48.544749	2026-02-16 17:18:48.544749
169	TABLE_IDLE	Mesa #7 sin actividad	La mesa #7 no ha tenido movimientos en los últimos 15 minutos	INFO	["ADMIN", "SUPERVISOR"]	TABLE	8	f	\N	\N	2026-03-08 19:57:24.39042	2026-03-08 19:57:24.39042
39	TABLE_LONG_OPEN	Mesa #6 abierta mucho tiempo	La mesa #6 lleva abierta desde 18:36:25.978769 (42 minutos)	WARNING	["ADMIN", "SUPERVISOR", "MESERO"]	TABLE	6	t	9	2026-02-16 20:58:28.585532	2026-02-16 19:18:40.477686	2026-02-16 20:58:28.58758
38	TABLE_IDLE	Mesa #6 sin actividad	La mesa #6 no ha tenido movimientos en los últimos 15 minutos	INFO	["ADMIN", "SUPERVISOR"]	TABLE	6	t	9	2026-02-16 20:58:32.56157	2026-02-16 18:53:40.47186	2026-02-16 20:58:32.562587
43	VOID_ATTEMPT	Anulación de factura	El usuario Tatiana agudelo anuló la factura V0216-0003	CRITICAL	["ADMIN", "SUPERVISOR"]	INVOICE	\N	t	9	2026-02-16 21:12:50.474015	2026-02-16 21:09:43.359797	2026-02-16 21:12:50.475027
41	TABLE_LONG_OPEN	Mesa #6 abierta mucho tiempo	La mesa #6 lleva abierta desde 18:36:25.978769 (142 minutos)	WARNING	["ADMIN", "SUPERVISOR", "MESERO"]	TABLE	6	t	9	2026-02-16 21:12:53.048391	2026-02-16 20:58:40.443483	2026-02-16 21:12:53.048391
42	VOID_ATTEMPT	Anulación de factura	El usuario Administrador anuló la factura M6-0216-0001	CRITICAL	["ADMIN", "SUPERVISOR"]	INVOICE	\N	t	9	2026-02-16 21:13:45.758012	2026-02-16 20:59:15.805463	2026-02-16 21:13:45.759018
40	TABLE_IDLE	Mesa #6 sin actividad	La mesa #6 no ha tenido movimientos en los últimos 15 minutos	INFO	["ADMIN", "SUPERVISOR"]	TABLE	6	t	9	2026-02-16 21:13:47.321864	2026-02-16 20:58:40.425963	2026-02-16 21:13:47.321864
45	VOID_ATTEMPT	Anulación de factura	El usuario Tatiana agudelo anuló la factura V0216-0004	CRITICAL	["ADMIN", "SUPERVISOR"]	INVOICE	\N	t	9	2026-02-16 21:33:58.654145	2026-02-16 21:20:31.200423	2026-02-16 21:33:58.655674
44	TABLE_IDLE	Mesa #1 sin actividad	La mesa #1 no ha tenido movimientos en los últimos 15 minutos	INFO	["ADMIN", "SUPERVISOR"]	TABLE	2	t	9	2026-02-16 21:34:00.844031	2026-02-16 21:18:40.415266	2026-02-16 21:34:00.845029
33	LOW_STOCK	Stock bajo: Uva	El producto Uva tiene 49 unidades (mínimo: 100)	WARNING	["ADMIN", "INVENTARIO"]	PRODUCT	42	t	\N	2026-02-18 09:37:48.004304	2026-02-16 17:18:39.426504	2026-02-16 17:18:39.426504
36	LOW_STOCK	Stock bajo: Entradas	El producto Entradas tiene 2 unidades (mínimo: 3)	WARNING	["ADMIN", "INVENTARIO"]	PRODUCT	4	t	\N	2026-02-18 09:37:48.004304	2026-02-16 17:18:48.508956	2026-02-16 17:18:48.508956
46	TABLE_IDLE	Mesa #1 sin actividad	La mesa #1 no ha tenido movimientos en los últimos 15 minutos	INFO	["ADMIN", "SUPERVISOR"]	TABLE	2	t	\N	2026-02-18 09:37:48.004304	2026-02-16 21:38:40.422512	2026-02-16 21:38:40.422512
47	TABLE_LONG_OPEN	Mesa #1 abierta mucho tiempo	La mesa #1 lleva abierta desde 20:59:14.060417 (44 minutos)	WARNING	["ADMIN", "SUPERVISOR", "MESERO"]	TABLE	2	t	\N	2026-02-18 09:37:48.004304	2026-02-16 21:43:40.43892	2026-02-16 21:43:40.43892
48	VOID_ATTEMPT	Anulación de factura	El usuario Tatiana agudelo anuló la factura M3-0215-0003	CRITICAL	["ADMIN", "SUPERVISOR"]	INVOICE	\N	t	\N	2026-02-18 09:37:48.004304	2026-02-16 21:48:18.24841	2026-02-16 21:48:18.24841
49	TABLE_IDLE	Mesa #2 sin actividad	La mesa #2 no ha tenido movimientos en los últimos 15 minutos	INFO	["ADMIN", "SUPERVISOR"]	TABLE	3	t	\N	2026-02-18 09:37:48.004304	2026-02-16 23:12:40.425491	2026-02-16 23:12:40.425491
50	TABLE_IDLE	Mesa #3 sin actividad	La mesa #3 no ha tenido movimientos en los últimos 15 minutos	INFO	["ADMIN", "SUPERVISOR"]	TABLE	1	t	\N	2026-02-18 09:37:48.004304	2026-02-16 23:27:40.509085	2026-02-16 23:27:40.509085
51	TABLE_LONG_OPEN	Mesa #2 abierta mucho tiempo	La mesa #2 lleva abierta desde 22:53:08.707602 (44 minutos)	WARNING	["ADMIN", "SUPERVISOR", "MESERO"]	TABLE	3	t	\N	2026-02-18 09:37:48.004304	2026-02-16 23:37:40.447034	2026-02-16 23:37:40.447034
52	TABLE_IDLE	Mesa #4 sin actividad	La mesa #4 no ha tenido movimientos en los últimos 15 minutos	INFO	["ADMIN", "SUPERVISOR"]	TABLE	4	t	\N	2026-02-18 09:37:48.004304	2026-02-16 23:52:14.250148	2026-02-16 23:52:14.250148
53	TABLE_LONG_OPEN	Mesa #3 abierta mucho tiempo	La mesa #3 lleva abierta desde 23:08:27.575636 (43 minutos)	WARNING	["ADMIN", "SUPERVISOR", "MESERO"]	TABLE	1	t	\N	2026-02-18 09:37:48.004304	2026-02-16 23:52:14.280107	2026-02-16 23:52:14.280107
54	TABLE_LONG_OPEN	Mesa #4 abierta mucho tiempo	La mesa #4 lleva abierta desde 23:30:16.061810 (41 minutos)	WARNING	["ADMIN", "SUPERVISOR", "MESERO"]	TABLE	4	t	\N	2026-02-18 09:37:48.004304	2026-02-17 00:12:14.253709	2026-02-17 00:12:14.253709
124	TABLE_IDLE	Mesa #6 sin actividad	La mesa #6 no ha tenido movimientos en los últimos 15 minutos	INFO	["ADMIN", "SUPERVISOR"]	TABLE	6	t	\N	2026-03-01 19:33:21.042808	2026-02-28 23:37:49.877032	2026-02-28 23:37:49.877032
55	TABLE_IDLE	Mesa #8 sin actividad	La mesa #8 no ha tenido movimientos en los últimos 15 minutos	INFO	["ADMIN", "SUPERVISOR"]	TABLE	7	t	\N	2026-02-18 18:37:29.15044	2026-02-18 18:17:15.295206	2026-02-18 18:17:15.295206
56	VOID_ATTEMPT	Anulación de factura	El usuario Administrador anuló la factura V0219-0001	CRITICAL	["ADMIN", "SUPERVISOR"]	INVOICE	\N	t	\N	2026-02-19 18:16:52.397288	2026-02-19 16:46:00.529236	2026-02-19 16:46:00.529236
136	TABLE_IDLE	Mesa #1 sin actividad	La mesa #1 no ha tenido movimientos en los últimos 15 minutos	INFO	["ADMIN", "SUPERVISOR"]	TABLE	2	t	\N	2026-03-05 21:51:13.696249	2026-03-01 20:37:49.894124	2026-03-01 20:37:49.894124
57	TABLE_IDLE	Mesa #3 sin actividad	La mesa #3 no ha tenido movimientos en los últimos 15 minutos	INFO	["ADMIN", "SUPERVISOR"]	TABLE	1	t	\N	2026-02-20 17:52:37.86803	2026-02-20 00:28:25.370205	2026-02-20 00:28:25.370205
58	TABLE_LONG_OPEN	Mesa #3 abierta mucho tiempo	La mesa #3 lleva abierta desde 00:10:27.103976 (43 minutos)	WARNING	["ADMIN", "SUPERVISOR", "MESERO"]	TABLE	1	t	\N	2026-02-20 17:52:37.86803	2026-02-20 00:54:01.971599	2026-02-20 00:54:01.971599
143	VOID_ATTEMPT	Anulación de factura	El usuario Administrador anuló la factura V0302-0001	CRITICAL	["ADMIN", "SUPERVISOR"]	INVOICE	\N	t	\N	2026-03-05 21:51:13.696249	2026-03-02 18:06:18.599349	2026-03-02 18:06:18.599349
149	TABLE_LONG_OPEN	Mesa #7 abierta mucho tiempo	La mesa #7 lleva abierta desde 20:04:28.970458 (43 minutos)	WARNING	["ADMIN", "SUPERVISOR", "MESERO"]	TABLE	8	t	\N	2026-03-05 21:51:13.696249	2026-03-04 20:47:49.873313	2026-03-04 20:47:49.873313
134	LOW_STOCK	Stock bajo: Chicharron	El producto Chicharron tiene 2 unidades (mínimo: 2)	WARNING	["ADMIN", "INVENTARIO"]	PRODUCT	3	t	\N	2026-03-05 21:51:13.696249	2026-03-01 20:32:53.936988	2026-03-01 20:32:53.936988
144	LOW_STOCK	Stock bajo: Especial	El producto Especial tiene 5 unidades (mínimo: 5)	WARNING	["ADMIN", "INVENTARIO"]	PRODUCT	11	t	\N	2026-03-05 21:51:13.696249	2026-03-02 21:29:27.953057	2026-03-02 21:29:27.953057
158	TABLE_LONG_OPEN	Mesa #4 abierta mucho tiempo	La mesa #4 lleva abierta desde 19:39:46.393125 (42 minutos)	WARNING	["ADMIN", "SUPERVISOR", "MESERO"]	TABLE	4	f	\N	\N	2026-03-07 20:22:24.390405	2026-03-07 20:22:24.390405
164	TABLE_LONG_OPEN	Mesa #2 abierta mucho tiempo	La mesa #2 lleva abierta desde 22:04:49.712696 (42 minutos)	WARNING	["ADMIN", "SUPERVISOR", "MESERO"]	TABLE	3	t	1	2026-03-07 23:13:59.895633	2026-03-07 22:47:24.384056	2026-03-07 23:13:59.89735
170	TABLE_LONG_OPEN	Mesa #9 abierta mucho tiempo	La mesa #9 lleva abierta desde 19:18:20.952957 (44 minutos)	WARNING	["ADMIN", "SUPERVISOR", "MESERO"]	TABLE	9	f	\N	\N	2026-03-08 20:02:24.375971	2026-03-08 20:02:24.375971
65	VOID_ATTEMPT	Anulación de factura	El usuario Tatiana agudelo anuló la factura V0221-0002	CRITICAL	["ADMIN", "SUPERVISOR"]	INVOICE	\N	t	1	2026-02-21 23:38:26.86522	2026-02-21 19:32:00.320044	2026-02-21 23:38:26.972643
59	TABLE_IDLE	Mesa #1 sin actividad	La mesa #1 no ha tenido movimientos en los últimos 15 minutos	INFO	["ADMIN", "SUPERVISOR"]	TABLE	2	t	\N	2026-02-21 23:38:35.824204	2026-02-20 19:41:08.249282	2026-02-20 19:41:08.249282
60	TABLE_IDLE	Mesa #3 sin actividad	La mesa #3 no ha tenido movimientos en los últimos 15 minutos	INFO	["ADMIN", "SUPERVISOR"]	TABLE	1	t	\N	2026-02-21 23:38:35.824204	2026-02-20 19:41:08.476419	2026-02-20 19:41:08.476419
61	TABLE_IDLE	Mesa #5 sin actividad	La mesa #5 no ha tenido movimientos en los últimos 15 minutos	INFO	["ADMIN", "SUPERVISOR"]	TABLE	5	t	\N	2026-02-21 23:38:35.824204	2026-02-20 20:20:50.669282	2026-02-20 20:20:50.669282
62	TABLE_IDLE	Mesa #6 sin actividad	La mesa #6 no ha tenido movimientos en los últimos 15 minutos	INFO	["ADMIN", "SUPERVISOR"]	TABLE	6	t	\N	2026-02-21 23:38:35.824204	2026-02-20 20:25:49.829223	2026-02-20 20:25:49.829223
63	TABLE_LONG_OPEN	Mesa #6 abierta mucho tiempo	La mesa #6 lleva abierta desde 20:07:06.451069 (43 minutos)	WARNING	["ADMIN", "SUPERVISOR", "MESERO"]	TABLE	6	t	\N	2026-02-21 23:38:35.824204	2026-02-20 20:50:14.172817	2026-02-20 20:50:14.172817
64	VOID_ATTEMPT	Anulación de factura	El usuario Tatiana agudelo anuló la factura V0220-0002	CRITICAL	["ADMIN", "SUPERVISOR"]	INVOICE	\N	t	\N	2026-02-21 23:38:35.824204	2026-02-20 22:02:12.743571	2026-02-20 22:02:12.743571
66	VOID_ATTEMPT	Anulación de factura	El usuario Administrador anuló la factura M8-0222-0001	CRITICAL	["ADMIN", "SUPERVISOR"]	INVOICE	\N	t	\N	2026-02-22 00:53:35.161816	2026-02-22 00:17:10.882214	2026-02-22 00:17:10.882214
67	TABLE_IDLE	Mesa #10 sin actividad	La mesa #10 no ha tenido movimientos en los últimos 15 minutos	INFO	["ADMIN", "SUPERVISOR"]	TABLE	9	t	\N	2026-02-22 00:53:35.161816	2026-02-22 00:51:09.953875	2026-02-22 00:51:09.953875
68	TABLE_IDLE	Mesa #10 sin actividad	La mesa #10 no ha tenido movimientos en los últimos 15 minutos	INFO	["ADMIN", "SUPERVISOR"]	TABLE	9	t	\N	2026-02-22 18:55:01.003189	2026-02-22 01:10:52.020139	2026-02-22 01:10:52.020139
69	TABLE_IDLE	Mesa #8 sin actividad	La mesa #8 no ha tenido movimientos en los últimos 15 minutos	INFO	["ADMIN", "SUPERVISOR"]	TABLE	7	t	\N	2026-02-22 18:55:01.003189	2026-02-22 01:18:40.722841	2026-02-22 01:18:40.722841
70	TABLE_LONG_OPEN	Mesa #10 abierta mucho tiempo	La mesa #10 lleva abierta desde 00:35:19.274655 (43 minutos)	WARNING	["ADMIN", "SUPERVISOR", "MESERO"]	TABLE	9	t	\N	2026-02-22 18:55:01.003189	2026-02-22 01:18:40.812367	2026-02-22 01:18:40.812367
71	TABLE_IDLE	Mesa #2 sin actividad	La mesa #2 no ha tenido movimientos en los últimos 15 minutos	INFO	["ADMIN", "SUPERVISOR"]	TABLE	3	t	\N	2026-02-22 18:55:01.003189	2026-02-22 02:40:09.138048	2026-02-22 02:40:09.138048
72	TABLE_IDLE	Mesa #1 sin actividad	La mesa #1 no ha tenido movimientos en los últimos 15 minutos	INFO	["ADMIN", "SUPERVISOR"]	TABLE	2	t	\N	2026-02-22 18:55:01.003189	2026-02-22 02:40:09.161273	2026-02-22 02:40:09.161273
73	TABLE_IDLE	Mesa #3 sin actividad	La mesa #3 no ha tenido movimientos en los últimos 15 minutos	INFO	["ADMIN", "SUPERVISOR"]	TABLE	1	t	\N	2026-02-22 18:55:01.003189	2026-02-22 02:45:09.128704	2026-02-22 02:45:09.128704
74	TABLE_LONG_OPEN	Mesa #1 abierta mucho tiempo	La mesa #1 lleva abierta desde 02:20:45.520138 (44 minutos)	WARNING	["ADMIN", "SUPERVISOR", "MESERO"]	TABLE	2	t	\N	2026-02-22 18:55:01.003189	2026-02-22 03:05:09.115178	2026-02-22 03:05:09.115178
75	TABLE_LONG_OPEN	Mesa #2 abierta mucho tiempo	La mesa #2 lleva abierta desde 02:21:02.009019 (44 minutos)	WARNING	["ADMIN", "SUPERVISOR", "MESERO"]	TABLE	3	t	\N	2026-02-22 18:55:01.003189	2026-02-22 03:05:09.120038	2026-02-22 03:05:09.120038
76	TABLE_LONG_OPEN	Mesa #3 abierta mucho tiempo	La mesa #3 lleva abierta desde 02:29:04.610685 (41 minutos)	WARNING	["ADMIN", "SUPERVISOR", "MESERO"]	TABLE	1	t	\N	2026-02-22 18:55:01.003189	2026-02-22 03:10:09.13146	2026-02-22 03:10:09.13146
77	VOID_ATTEMPT	Anulación de factura	El usuario Tatiana agudelo anuló la factura M10-0222-0003	CRITICAL	["ADMIN", "SUPERVISOR"]	INVOICE	\N	t	\N	2026-02-22 18:55:01.003189	2026-02-22 18:54:48.313092	2026-02-22 18:54:48.313092
78	VOID_ATTEMPT	Anulación de factura	El usuario Tatiana agudelo anuló la factura M10-0222-0002	CRITICAL	["ADMIN", "SUPERVISOR"]	INVOICE	\N	t	\N	2026-02-22 19:06:46.078213	2026-02-22 18:55:36.395965	2026-02-22 18:55:36.395965
125	TABLE_LONG_OPEN	Mesa #6 abierta mucho tiempo	La mesa #6 lleva abierta desde 18:41:05.962223 (41 minutos)	WARNING	["ADMIN", "SUPERVISOR", "MESERO"]	TABLE	6	t	\N	2026-03-01 19:33:21.042808	2026-03-01 19:22:49.896053	2026-03-01 19:22:49.896053
137	TABLE_IDLE	Mesa #6 sin actividad	La mesa #6 no ha tenido movimientos en los últimos 15 minutos	INFO	["ADMIN", "SUPERVISOR"]	TABLE	6	t	\N	2026-03-05 21:51:13.696249	2026-03-01 20:52:49.890477	2026-03-01 20:52:49.890477
145	VOID_ATTEMPT	Anulación de factura	El usuario Administrador anuló la factura M7-0302-0001	CRITICAL	["ADMIN", "SUPERVISOR"]	INVOICE	\N	t	\N	2026-03-05 21:51:13.696249	2026-03-02 21:58:29.241844	2026-03-02 21:58:29.241844
150	LOW_STOCK	Stock bajo: Especial	El producto Especial tiene 4 unidades (mínimo: 5)	WARNING	["ADMIN", "INVENTARIO"]	PRODUCT	11	f	\N	\N	2026-03-07 18:15:00.802915	2026-03-07 18:15:00.802915
159	TABLE_LONG_OPEN	Mesa #6 abierta mucho tiempo	La mesa #6 lleva abierta desde 19:46:06.359880 (41 minutos)	WARNING	["ADMIN", "SUPERVISOR", "MESERO"]	TABLE	6	f	\N	\N	2026-03-07 20:27:24.385627	2026-03-07 20:27:24.385627
79	TABLE_IDLE	Mesa #2 sin actividad	La mesa #2 no ha tenido movimientos en los últimos 15 minutos	INFO	["ADMIN", "SUPERVISOR"]	TABLE	3	t	\N	2026-02-23 10:10:51.704356	2026-02-22 19:20:10.639642	2026-02-22 19:20:10.639642
80	TABLE_IDLE	Mesa #3 sin actividad	La mesa #3 no ha tenido movimientos en los últimos 15 minutos	INFO	["ADMIN", "SUPERVISOR"]	TABLE	1	t	\N	2026-02-23 10:10:51.704356	2026-02-22 19:30:10.653181	2026-02-22 19:30:10.653181
81	TABLE_IDLE	Mesa #6 sin actividad	La mesa #6 no ha tenido movimientos en los últimos 15 minutos	INFO	["ADMIN", "SUPERVISOR"]	TABLE	6	t	\N	2026-02-23 10:10:51.704356	2026-02-22 20:45:10.651917	2026-02-22 20:45:10.651917
82	TABLE_LONG_OPEN	Mesa #6 abierta mucho tiempo	La mesa #6 lleva abierta desde 20:28:28.688653 (41 minutos)	WARNING	["ADMIN", "SUPERVISOR", "MESERO"]	TABLE	6	t	\N	2026-02-23 10:10:51.704356	2026-02-22 21:10:10.639586	2026-02-22 21:10:10.639586
83	LOW_STOCK	Stock bajo: Picada Grande	El producto Picada Grande tiene 99 unidades (mínimo: 250)	WARNING	["ADMIN", "INVENTARIO"]	PRODUCT	80	t	\N	2026-02-23 10:10:51.704356	2026-02-22 21:44:39.656889	2026-02-22 21:44:39.656889
84	TABLE_LONG_OPEN	Mesa #3 abierta mucho tiempo	La mesa #3 lleva abierta desde 21:01:56.290995 (43 minutos)	WARNING	["ADMIN", "SUPERVISOR", "MESERO"]	TABLE	1	t	\N	2026-02-23 10:10:51.704356	2026-02-22 21:45:10.647857	2026-02-22 21:45:10.647857
85	TABLE_IDLE	Mesa #4 sin actividad	La mesa #4 no ha tenido movimientos en los últimos 15 minutos	INFO	["ADMIN", "SUPERVISOR"]	TABLE	4	t	\N	2026-02-23 10:10:51.704356	2026-02-22 22:00:10.65804	2026-02-22 22:00:10.65804
160	OUT_OF_STOCK	Sin stock: Especial	El producto Especial se ha agotado	ERROR	["ADMIN", "INVENTARIO", "CAJERO"]	PRODUCT	11	f	\N	\N	2026-03-07 20:30:10.338315	2026-03-07 20:30:10.338315
165	VOID_ATTEMPT	Anulación de factura	El usuario Administrador anuló la factura M3-0307-0010	CRITICAL	["ADMIN", "SUPERVISOR"]	INVOICE	\N	f	\N	\N	2026-03-07 23:26:44.589938	2026-03-07 23:26:44.589938
171	TABLE_LONG_OPEN	Mesa #2 abierta mucho tiempo	La mesa #2 lleva abierta desde 19:39:38.586784 (42 minutos)	WARNING	["ADMIN", "SUPERVISOR", "MESERO"]	TABLE	3	f	\N	\N	2026-03-08 20:22:24.38066	2026-03-08 20:22:24.38066
95	VOID_ATTEMPT	Anulación de factura	El usuario Tatiana agudelo anuló la factura M8-0226-0001	CRITICAL	["ADMIN", "SUPERVISOR"]	INVOICE	\N	t	1	2026-02-26 22:22:03.102136	2026-02-26 21:56:38.37163	2026-02-26 22:22:03.104152
86	TABLE_IDLE	Mesa #8 sin actividad	La mesa #8 no ha tenido movimientos en los últimos 15 minutos	INFO	["ADMIN", "SUPERVISOR"]	TABLE	7	t	\N	2026-02-28 20:04:02.180181	2026-02-23 19:12:48.329614	2026-02-23 19:12:48.329614
87	VOID_ATTEMPT	Anulación de factura	El usuario Tatiana agudelo anuló la factura M8-0223-0001	CRITICAL	["ADMIN", "SUPERVISOR"]	INVOICE	\N	t	\N	2026-02-28 20:04:02.180181	2026-02-23 22:40:48.759272	2026-02-23 22:40:48.759272
88	VOID_ATTEMPT	Anulación de factura	El usuario Tatiana agudelo anuló la factura V0225-0002	CRITICAL	["ADMIN", "SUPERVISOR"]	INVOICE	\N	t	\N	2026-02-28 20:04:02.180181	2026-02-25 19:01:44.305117	2026-02-25 19:01:44.305117
89	VOID_ATTEMPT	Anulación de factura	El usuario Tatiana agudelo anuló la factura V0225-0001	CRITICAL	["ADMIN", "SUPERVISOR"]	INVOICE	\N	t	\N	2026-02-28 20:04:02.180181	2026-02-25 19:02:13.64367	2026-02-25 19:02:13.64367
90	TABLE_IDLE	Mesa #7 sin actividad	La mesa #7 no ha tenido movimientos en los últimos 15 minutos	INFO	["ADMIN", "SUPERVISOR"]	TABLE	8	t	\N	2026-02-28 20:04:02.180181	2026-02-25 20:12:49.893867	2026-02-25 20:12:49.893867
91	TABLE_IDLE	Mesa #6 sin actividad	La mesa #6 no ha tenido movimientos en los últimos 15 minutos	INFO	["ADMIN", "SUPERVISOR"]	TABLE	6	t	\N	2026-02-28 20:04:02.180181	2026-02-25 20:17:49.894228	2026-02-25 20:17:49.894228
92	TABLE_IDLE	Mesa #3 sin actividad	La mesa #3 no ha tenido movimientos en los últimos 15 minutos	INFO	["ADMIN", "SUPERVISOR"]	TABLE	1	t	\N	2026-02-28 20:04:02.180181	2026-02-25 20:47:49.891716	2026-02-25 20:47:49.891716
93	TABLE_LONG_OPEN	Mesa #3 abierta mucho tiempo	La mesa #3 lleva abierta desde 20:31:13.083273 (41 minutos)	WARNING	["ADMIN", "SUPERVISOR", "MESERO"]	TABLE	1	t	\N	2026-02-28 20:04:02.180181	2026-02-25 21:12:49.883691	2026-02-25 21:12:49.883691
94	TABLE_LONG_OPEN	Mesa #6 abierta mucho tiempo	La mesa #6 lleva abierta desde 21:01:34.534822 (41 minutos)	WARNING	["ADMIN", "SUPERVISOR", "MESERO"]	TABLE	6	t	\N	2026-02-28 20:04:02.180181	2026-02-26 21:42:49.876799	2026-02-26 21:42:49.876799
96	VOID_ATTEMPT	Anulación de factura	El usuario Tatiana agudelo anuló la factura M8-0226-0002	CRITICAL	["ADMIN", "SUPERVISOR"]	INVOICE	\N	t	\N	2026-02-28 20:04:02.180181	2026-02-26 22:25:08.324342	2026-02-26 22:25:08.324342
97	LOW_STOCK	Stock bajo: Patacones	El producto Patacones tiene 4 unidades (mínimo: 4)	WARNING	["ADMIN", "INVENTARIO"]	PRODUCT	6	t	\N	2026-02-28 20:04:02.180181	2026-02-27 18:38:32.899052	2026-02-27 18:38:32.899052
98	TABLE_LONG_OPEN	Mesa #7 abierta mucho tiempo	La mesa #7 lleva abierta desde 20:59:24.039998 (43 minutos)	WARNING	["ADMIN", "SUPERVISOR", "MESERO"]	TABLE	8	t	\N	2026-02-28 20:04:02.180181	2026-02-27 21:42:49.88043	2026-02-27 21:42:49.88043
99	TABLE_IDLE	Mesa #4 sin actividad	La mesa #4 no ha tenido movimientos en los últimos 15 minutos	INFO	["ADMIN", "SUPERVISOR"]	TABLE	4	t	\N	2026-02-28 20:04:02.180181	2026-02-27 22:17:49.881845	2026-02-27 22:17:49.881845
100	TABLE_IDLE	Mesa #5 sin actividad	La mesa #5 no ha tenido movimientos en los últimos 15 minutos	INFO	["ADMIN", "SUPERVISOR"]	TABLE	5	t	\N	2026-02-28 20:04:02.180181	2026-02-27 23:07:49.881239	2026-02-27 23:07:49.881239
101	VOID_ATTEMPT	Anulación de factura	El usuario Tatiana Agudelo anuló la factura M6-0227-0002	CRITICAL	["ADMIN", "SUPERVISOR"]	INVOICE	\N	t	\N	2026-02-28 20:04:02.180181	2026-02-27 23:20:59.306005	2026-02-27 23:20:59.306005
102	TABLE_LONG_OPEN	Mesa #5 abierta mucho tiempo	La mesa #5 lleva abierta desde 22:50:48.504796 (42 minutos)	WARNING	["ADMIN", "SUPERVISOR", "MESERO"]	TABLE	5	t	\N	2026-02-28 20:04:02.180181	2026-02-27 23:32:49.876235	2026-02-27 23:32:49.876235
103	OUT_OF_STOCK	Sin stock: Patacones	El producto Patacones se ha agotado	ERROR	["ADMIN", "INVENTARIO", "CAJERO"]	PRODUCT	6	t	\N	2026-02-28 20:04:02.180181	2026-02-28 18:49:39.611756	2026-02-28 18:49:39.611756
104	TABLE_IDLE	Mesa #10 sin actividad	La mesa #10 no ha tenido movimientos en los últimos 15 minutos	INFO	["ADMIN", "SUPERVISOR"]	TABLE	9	t	\N	2026-02-28 20:04:02.180181	2026-02-28 19:32:49.896123	2026-02-28 19:32:49.896123
126	TABLE_IDLE	Mesa #3 sin actividad	La mesa #3 no ha tenido movimientos en los últimos 15 minutos	INFO	["ADMIN", "SUPERVISOR"]	TABLE	1	t	\N	2026-03-05 21:51:13.696249	2026-03-01 19:42:49.878369	2026-03-01 19:42:49.878369
138	LOW_STOCK	Stock bajo: Mix de costilla, chicharrón y bondiola	El producto Mix de costilla, chicharrón y bondiola tiene 2 unidades (mínimo: 5)	WARNING	["ADMIN", "INVENTARIO"]	PRODUCT	8	t	\N	2026-03-05 21:51:13.696249	2026-03-01 21:03:53.639197	2026-03-01 21:03:53.639197
139	TABLE_IDLE	Mesa #5 sin actividad	La mesa #5 no ha tenido movimientos en los últimos 15 minutos	INFO	["ADMIN", "SUPERVISOR"]	TABLE	5	t	\N	2026-03-05 21:51:13.696249	2026-03-01 21:07:49.881412	2026-03-01 21:07:49.881412
146	TABLE_LONG_OPEN	Mesa #6 abierta mucho tiempo	La mesa #6 lleva abierta desde 21:26:57.831833 (40 minutos)	WARNING	["ADMIN", "SUPERVISOR", "MESERO"]	TABLE	6	t	\N	2026-03-05 21:51:13.696249	2026-03-02 22:07:49.879483	2026-03-02 22:07:49.879483
151	TABLE_IDLE	Mesa #5 sin actividad	La mesa #5 no ha tenido movimientos en los últimos 15 minutos	INFO	["ADMIN", "SUPERVISOR"]	TABLE	5	f	\N	\N	2026-03-07 19:17:24.379754	2026-03-07 19:17:24.379754
161	VOID_ATTEMPT	Anulación de factura	El usuario Administrador anuló la factura M9-0307-0002	CRITICAL	["ADMIN", "SUPERVISOR"]	INVOICE	\N	f	\N	\N	2026-03-07 20:53:42.952343	2026-03-07 20:53:42.952343
166	LOW_STOCK	Stock bajo: Papas al carbón mix	El producto Papas al carbón mix tiene 5 unidades (mínimo: 5)	WARNING	["ADMIN", "INVENTARIO"]	PRODUCT	20	f	\N	\N	2026-03-08 00:09:19.282266	2026-03-08 00:09:19.282266
172	OUT_OF_STOCK	Sin stock: Costilla	El producto Costilla se ha agotado	ERROR	["ADMIN", "INVENTARIO", "CAJERO"]	PRODUCT	2	f	\N	\N	2026-03-08 22:12:58.507482	2026-03-08 22:12:58.507482
105	TABLE_IDLE	Mesa #8 sin actividad	La mesa #8 no ha tenido movimientos en los últimos 15 minutos	INFO	["ADMIN", "SUPERVISOR"]	TABLE	7	t	\N	2026-02-28 23:05:41.617587	2026-02-28 20:12:49.893574	2026-02-28 20:12:49.893574
106	TABLE_IDLE	Mesa #7 sin actividad	La mesa #7 no ha tenido movimientos en los últimos 15 minutos	INFO	["ADMIN", "SUPERVISOR"]	TABLE	8	t	\N	2026-02-28 23:05:41.617587	2026-02-28 20:27:49.886025	2026-02-28 20:27:49.886025
107	TABLE_IDLE	Mesa #5 sin actividad	La mesa #5 no ha tenido movimientos en los últimos 15 minutos	INFO	["ADMIN", "SUPERVISOR"]	TABLE	5	t	\N	2026-02-28 23:05:41.617587	2026-02-28 21:07:49.885978	2026-02-28 21:07:49.885978
108	TABLE_LONG_OPEN	Mesa #5 abierta mucho tiempo	La mesa #5 lleva abierta desde 20:35:45.423613 (42 minutos)	WARNING	["ADMIN", "SUPERVISOR", "MESERO"]	TABLE	5	t	\N	2026-02-28 23:05:41.617587	2026-02-28 21:17:49.877408	2026-02-28 21:17:49.877408
109	TABLE_IDLE	Mesa #6 sin actividad	La mesa #6 no ha tenido movimientos en los últimos 15 minutos	INFO	["ADMIN", "SUPERVISOR"]	TABLE	6	t	\N	2026-02-28 23:05:41.617587	2026-02-28 21:22:49.887452	2026-02-28 21:22:49.887452
110	LOW_STOCK	Stock bajo: Mix de costilla, chicharrón y bondiola	El producto Mix de costilla, chicharrón y bondiola tiene 5 unidades (mínimo: 5)	WARNING	["ADMIN", "INVENTARIO"]	PRODUCT	8	t	\N	2026-02-28 23:05:41.617587	2026-02-28 21:32:53.447391	2026-02-28 21:32:53.447391
111	TABLE_IDLE	Mesa #2 sin actividad	La mesa #2 no ha tenido movimientos en los últimos 15 minutos	INFO	["ADMIN", "SUPERVISOR"]	TABLE	3	t	\N	2026-02-28 23:05:41.617587	2026-02-28 21:57:49.878244	2026-02-28 21:57:49.878244
112	TABLE_IDLE	Mesa #3 sin actividad	La mesa #3 no ha tenido movimientos en los últimos 15 minutos	INFO	["ADMIN", "SUPERVISOR"]	TABLE	1	t	\N	2026-02-28 23:05:41.617587	2026-02-28 22:07:49.889962	2026-02-28 22:07:49.889962
113	TABLE_IDLE	Mesa #4 sin actividad	La mesa #4 no ha tenido movimientos en los últimos 15 minutos	INFO	["ADMIN", "SUPERVISOR"]	TABLE	4	t	\N	2026-02-28 23:05:41.617587	2026-02-28 22:07:49.900647	2026-02-28 22:07:49.900647
114	TABLE_IDLE	Mesa #1 sin actividad	La mesa #1 no ha tenido movimientos en los últimos 15 minutos	INFO	["ADMIN", "SUPERVISOR"]	TABLE	2	t	\N	2026-02-28 23:05:41.617587	2026-02-28 22:12:49.886415	2026-02-28 22:12:49.886415
115	TABLE_LONG_OPEN	Mesa #2 abierta mucho tiempo	La mesa #2 lleva abierta desde 21:39:59.899219 (42 minutos)	WARNING	["ADMIN", "SUPERVISOR", "MESERO"]	TABLE	3	t	\N	2026-02-28 23:05:41.617587	2026-02-28 22:22:49.876202	2026-02-28 22:22:49.876202
116	TABLE_LONG_OPEN	Mesa #3 abierta mucho tiempo	La mesa #3 lleva abierta desde 21:49:38.301353 (43 minutos)	WARNING	["ADMIN", "SUPERVISOR", "MESERO"]	TABLE	1	t	\N	2026-02-28 23:05:41.617587	2026-02-28 22:32:49.876003	2026-02-28 22:32:49.876003
117	TABLE_LONG_OPEN	Mesa #4 abierta mucho tiempo	La mesa #4 lleva abierta desde 21:50:36.895235 (42 minutos)	WARNING	["ADMIN", "SUPERVISOR", "MESERO"]	TABLE	4	t	\N	2026-02-28 23:05:41.617587	2026-02-28 22:32:49.886196	2026-02-28 22:32:49.886196
118	TABLE_LONG_OPEN	Mesa #1 abierta mucho tiempo	La mesa #1 lleva abierta desde 21:54:13.517959 (43 minutos)	WARNING	["ADMIN", "SUPERVISOR", "MESERO"]	TABLE	2	t	\N	2026-02-28 23:05:41.617587	2026-02-28 22:37:49.886083	2026-02-28 22:37:49.886083
119	TABLE_LONG_OPEN	Mesa #6 abierta mucho tiempo	La mesa #6 lleva abierta desde 21:58:06.442806 (44 minutos)	WARNING	["ADMIN", "SUPERVISOR", "MESERO"]	TABLE	6	t	\N	2026-02-28 23:05:41.617587	2026-02-28 22:42:49.889106	2026-02-28 22:42:49.889106
127	TABLE_IDLE	Mesa #4 sin actividad	La mesa #4 no ha tenido movimientos en los últimos 15 minutos	INFO	["ADMIN", "SUPERVISOR"]	TABLE	4	t	\N	2026-03-05 21:51:13.696249	2026-03-01 19:57:49.893111	2026-03-01 19:57:49.893111
128	TABLE_LONG_OPEN	Mesa #3 abierta mucho tiempo	La mesa #3 lleva abierta desde 19:23:22.165526 (44 minutos)	WARNING	["ADMIN", "SUPERVISOR", "MESERO"]	TABLE	1	t	\N	2026-03-05 21:51:13.696249	2026-03-01 20:07:49.875315	2026-03-01 20:07:49.875315
129	TABLE_LONG_OPEN	Mesa #4 abierta mucho tiempo	La mesa #4 lleva abierta desde 19:23:27.110037 (44 minutos)	WARNING	["ADMIN", "SUPERVISOR", "MESERO"]	TABLE	4	t	\N	2026-03-05 21:51:13.696249	2026-03-01 20:07:49.88943	2026-03-01 20:07:49.88943
140	TABLE_IDLE	Mesa #8 sin actividad	La mesa #8 no ha tenido movimientos en los últimos 15 minutos	INFO	["ADMIN", "SUPERVISOR"]	TABLE	7	t	\N	2026-03-05 21:51:13.696249	2026-03-01 21:12:49.888652	2026-03-01 21:12:49.888652
147	TABLE_LONG_OPEN	Mesa #1 abierta mucho tiempo	La mesa #1 lleva abierta desde 18:09:01.268541 (43 minutos)	WARNING	["ADMIN", "SUPERVISOR", "MESERO"]	TABLE	2	t	\N	2026-03-05 21:51:13.696249	2026-03-04 18:52:49.877223	2026-03-04 18:52:49.877223
152	TABLE_LONG_OPEN	Mesa #5 abierta mucho tiempo	La mesa #5 lleva abierta desde 19:00:57.383981 (41 minutos)	WARNING	["ADMIN", "SUPERVISOR", "MESERO"]	TABLE	5	f	\N	\N	2026-03-07 19:42:24.396575	2026-03-07 19:42:24.396575
153	TABLE_IDLE	Mesa #8 sin actividad	La mesa #8 no ha tenido movimientos en los últimos 15 minutos	INFO	["ADMIN", "SUPERVISOR"]	TABLE	7	f	\N	\N	2026-03-07 19:42:24.43438	2026-03-07 19:42:24.43438
162	TABLE_IDLE	Mesa #1 sin actividad	La mesa #1 no ha tenido movimientos en los últimos 15 minutos	INFO	["ADMIN", "SUPERVISOR"]	TABLE	2	f	\N	\N	2026-03-07 22:07:24.383892	2026-03-07 22:07:24.383892
167	TABLE_IDLE	Mesa #9 sin actividad	La mesa #9 no ha tenido movimientos en los últimos 15 minutos	INFO	["ADMIN", "SUPERVISOR"]	TABLE	9	f	\N	\N	2026-03-08 19:37:24.379518	2026-03-08 19:37:24.379518
173	OUT_OF_STOCK	Sin stock: Papas al carbón mix	El producto Papas al carbón mix se ha agotado	ERROR	["ADMIN", "INVENTARIO", "CAJERO"]	PRODUCT	20	f	\N	\N	2026-03-08 22:32:54.755054	2026-03-08 22:32:54.755054
\.


--
-- Data for Name: payments; Type: TABLE DATA; Schema: public; Owner: morales_user
--

COPY public.payments (id, invoice_id, payment_method, amount, reference, notes, created_at) FROM stdin;
\.


--
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: morales_user
--

COPY public.products (id, code, barcode, name, description, category_id, image_url, cost_price, sale_price, unit, tax_rate, is_active, created_by, created_at, updated_at) FROM stdin;
4	04	\N	Entradas	\N	5	\N	4000.00	10000.00	UND	0.00	t	\N	2026-01-30 10:08:23.546616	2026-01-30 10:08:23.546616
5	06	\N	Picadita De La Casa	\N	5	\N	15000.00	25000.00	UND	0.00	t	\N	2026-01-30 10:09:10.975385	2026-02-10 07:15:34.340558
12	13	\N	Sangria	\N	24	\N	5000.00	13000.00	UND	0.00	t	\N	2026-02-10 19:57:24.953586	2026-02-10 19:57:24.953586
6	07	\N	Patacones	\N	5	\N	4500.00	12000.00	UND	0.00	t	\N	2026-02-10 07:15:08.16032	2026-02-11 19:36:44.316996
7	08	\N	Ceviche de chicharron	\N	5	\N	17000.00	25000.00	UND	0.00	t	\N	2026-02-10 07:16:32.687442	2026-02-11 19:37:02.611007
13	PRD-0001	\N	Mini Picada	\N	5	\N	15000.00	25000.00	UND	0.00	t	\N	2026-02-11 19:37:53.002289	2026-02-11 19:37:53.002289
1	01		Salchipapas		8	data:image/jpeg;base64,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	13000.00	25000.00	UND	0.00	f	\N	2026-01-27 21:49:50.288091	2026-02-18 18:42:22.304599
2	02		Costilla		7	data:image/jpeg;base64,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	15000.00	30000.00	UND	0.00	t	\N	2026-01-27 23:06:58.14838	2026-02-20 20:56:38.862418
8	09	\N	Mix de costilla, chicharrón y bondiola	\N	7	data:image/jpeg;base64,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	19000.00	38000.00	UND	0.00	t	\N	2026-02-10 07:17:54.07232	2026-02-20 20:57:31.774108
11	12	\N	Especial	\N	9	\N	14000.00	32000.00	UND	0.00	t	\N	2026-02-10 07:20:16.982711	2026-02-11 19:42:11.288661
14	PRD-0002	\N	Argentina	\N	9	\N	15000.00	30000.00	UND	0.00	t	\N	2026-02-11 19:43:03.295922	2026-02-11 19:43:03.295922
15	PRD-0003	\N	Sandwich	\N	9	\N	16000.00	25000.00	UND	0.00	t	\N	2026-02-11 19:43:41.604141	2026-02-11 19:43:41.604141
16	PRD-0004	\N	Sandwich chicharron	\N	9	\N	16000.00	27000.00	UND	0.00	t	\N	2026-02-11 19:44:18.972241	2026-02-11 19:44:18.972241
17	PRD-0005	\N	Nuggets	\N	10	\N	8000.00	17000.00	UND	0.00	t	\N	2026-02-11 19:45:00.926343	2026-02-11 19:45:00.926343
18	PRD-0006	\N	Salchipapas	\N	10	\N	9000.00	17000.00	UND	0.00	t	\N	2026-02-11 19:45:30.565741	2026-02-11 19:45:30.565741
20	PRD-0008	\N	Papas al carbón mix	\N	8	\N	13000.00	26000.00	UND	0.00	t	\N	2026-02-11 19:46:31.619028	2026-02-11 19:46:31.619028
24	PRD-0012	\N	Arepa y queso Mozarella	\N	12	\N	2000.00	4000.00	UND	0.00	t	\N	2026-02-11 19:50:17.445292	2026-02-11 19:50:17.445292
29	PRD-0017	\N	Cereza	\N	16	\N	5000.00	10000.00	UND	0.00	t	\N	2026-02-11 19:52:51.493004	2026-02-11 19:52:51.493004
30	PRD-0018	\N	Lychee	\N	16	\N	5000.00	10000.00	UND	0.00	t	\N	2026-02-11 19:53:14.580772	2026-02-11 19:53:14.580772
31	PRD-0019	\N	Jugos en agua	\N	17	\N	4000.00	8000.00	UND	0.00	t	\N	2026-02-11 19:54:42.875687	2026-02-11 19:54:42.875687
32	PRD-0020	\N	Jugos en leche	\N	17	\N	5000.00	10000.00	UND	0.00	t	\N	2026-02-11 19:55:11.748177	2026-02-11 19:55:11.748177
33	PRD-0021	\N	Jugos en leche	\N	17	\N	5000.00	10000.00	UND	0.00	f	\N	2026-02-11 19:55:52.134171	2026-02-11 19:56:57.130922
34	PRD-0022	\N	Natural	\N	18	\N	4500.00	9000.00	UND	0.00	t	\N	2026-02-11 19:58:28.908337	2026-02-11 19:58:28.908337
36	PRD-0024	\N	Hierbabuena	\N	18	\N	5000.00	10000.00	UND	0.00	t	\N	2026-02-11 19:59:27.314252	2026-02-11 19:59:27.314252
37	PRD-0025	\N	Cereza	\N	18	\N	5000.00	10000.00	UND	0.00	t	\N	2026-02-11 19:59:46.490716	2026-02-11 19:59:46.490716
38	PRD-0026	\N	Limonada de vino	\N	18	\N	6000.00	12000.00	UND	0.00	t	\N	2026-02-11 20:00:11.700695	2026-02-11 20:00:11.700695
39	PRD-0027	\N	Manzana	\N	15	\N	4000.00	6000.00	UND	0.00	t	\N	2026-02-11 20:01:57.778038	2026-02-11 20:01:57.778038
40	PRD-0028	\N	Colombiana	\N	15	\N	4000.00	6000.00	UND	0.00	t	\N	2026-02-11 20:02:18.166772	2026-02-11 20:02:18.166772
41	PRD-0029	\N	Naranjada	\N	15	\N	4000.00	6000.00	UND	0.00	t	\N	2026-02-11 20:02:39.192831	2026-02-11 20:02:39.192831
42	PRD-0030	\N	Uva	\N	15	\N	4000.00	6000.00	UND	0.00	t	\N	2026-02-11 20:02:55.755711	2026-02-11 20:02:55.755711
44	PRD-0032	\N	Quatro	\N	15	\N	3500.00	7000.00	UND	0.00	t	\N	2026-02-11 20:05:09.915485	2026-02-11 20:05:09.915485
45	PRD-0033	\N	Premio	\N	15	\N	3500.00	7000.00	UND	0.00	t	\N	2026-02-11 20:07:16.950832	2026-02-11 20:07:16.950832
47	PRD-0035	\N	Aguila	\N	19	\N	4000.00	7000.00	UND	0.00	t	\N	2026-02-11 20:08:34.461858	2026-02-11 20:08:34.461858
48	PRD-0036	\N	Pilsen	\N	19	\N	4000.00	7000.00	UND	0.00	t	\N	2026-02-11 20:10:05.324843	2026-02-11 20:10:05.324843
49	PRD-0037	\N	Heineken	\N	19	\N	6000.00	8000.00	UND	0.00	t	\N	2026-02-11 20:10:29.760132	2026-02-11 20:10:29.760132
50	PRD-0038	\N	Club Colombia	\N	19	\N	6000.00	8000.00	UND	0.00	t	\N	2026-02-11 20:11:03.217715	2026-02-11 20:11:03.217715
51	PRD-0039	\N	3 Cordilleras	\N	19	\N	7000.00	9000.00	UND	0.00	t	\N	2026-02-11 20:11:32.677149	2026-02-11 20:11:32.677149
53	PRD-0041	\N	Shot de aguardiente	\N	24	\N	6000.00	8000.00	UND	0.00	t	\N	2026-02-11 20:14:33.91846	2026-02-11 20:14:33.91846
54	PRD-0042	\N	Shot de ron	\N	24	\N	6000.00	8000.00	UND	0.00	t	\N	2026-02-11 20:16:03.450509	2026-02-11 20:16:03.450509
55	PRD-0043	\N	Shot de baileys	\N	24	\N	12000.00	19000.00	UND	0.00	t	\N	2026-02-11 20:17:16.660169	2026-02-11 20:17:16.660169
57	PRD-0045	\N	Copa de Sangria	\N	13	\N	12000.00	16000.00	UND	0.00	t	\N	2026-02-11 20:19:12.963526	2026-02-11 20:19:12.963526
58	PRD-0046	\N	Mojito	\N	13	\N	12000.00	18000.00	UND	0.00	t	\N	2026-02-11 20:19:46.578396	2026-02-11 20:19:46.578396
59	PRD-0047	\N	Margarita	\N	13	\N	12000.00	18000.00	UND	0.00	t	\N	2026-02-11 20:19:59.988928	2026-02-11 20:19:59.988928
60	PRD-0048	\N	Espresso Martini	\N	13	\N	12000.00	18000.00	UND	0.00	t	\N	2026-02-11 20:20:24.356286	2026-02-11 20:20:24.356286
61	PRD-0049	\N	Copa Dubonet	\N	13	\N	15000.00	28000.00	UND	0.00	t	\N	2026-02-11 20:20:48.043321	2026-02-11 20:20:48.043321
64	PRD-0052	\N	Espresso	\N	21	\N	3000.00	5800.00	UND	0.00	t	\N	2026-02-11 20:23:00.096067	2026-02-11 20:23:00.096067
65	PRD-0053	\N	Aromática frutos secos	\N	21	\N	4500.00	7000.00	UND	0.00	t	\N	2026-02-11 20:24:28.596728	2026-02-11 20:24:28.596728
66	PRD-0054	\N	capuchino	\N	21	\N	4500.00	7500.00	UND	0.00	t	\N	2026-02-11 20:24:50.464454	2026-02-11 20:24:50.464454
67	PRD-0055	\N	Carajillo	\N	21	\N	5000.00	8500.00	UND	0.00	t	\N	2026-02-11 20:25:14.212119	2026-02-11 20:25:14.212119
68	PRD-0056	\N	Mocca	\N	21	\N	4500.00	8500.00	UND	0.00	t	\N	2026-02-11 20:25:49.359181	2026-02-11 20:25:49.359181
69	PRD-0057	\N	Espresso frio	\N	22	\N	3000.00	5500.00	UND	0.00	t	\N	2026-02-11 20:26:26.231167	2026-02-11 20:26:26.231167
21	PRD-0009	\N	Filete de Pechuga	\N	11	data:image/jpeg;base64,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	13000.00	26000.00	UND	0.00	t	\N	2026-02-11 19:47:24.45887	2026-02-20 20:58:25.430565
19	PRD-0007	\N	Papas al carbón supreme	\N	8	data:image/jpeg;base64,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	16000.00	25000.00	UND	0.00	t	\N	2026-02-11 19:46:08.04436	2026-02-20 21:00:31.496154
25	PRD-0013	\N	Papas Francesas	\N	12	data:image/jpeg;base64,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	4000.00	8000.00	UND	0.00	t	\N	2026-02-11 19:50:46.603046	2026-02-20 21:02:11.180249
63	PRD-0051	\N	Americano	\N	21	data:image/jpeg;base64,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	3000.00	5500.00	UND	0.00	t	\N	2026-02-11 20:22:40.293726	2026-02-20 21:03:19.203968
22	PRD-0010	\N	Churrasco	\N	11	data:image/jpeg;base64,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	19000.00	36000.00	UND	0.00	t	\N	2026-02-11 19:48:17.157395	2026-02-20 21:03:54.284234
43	PRD-0031	\N	Coca-cola	\N	15	data:image/jpeg;base64,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	3500.00	7000.00	UND	0.00	t	\N	2026-02-11 20:04:48.96368	2026-02-20 21:06:33.293181
23	PRD-0011	\N	Punta de Anca	\N	11	data:image/jpeg;base64,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	19000.00	38000.00	UND	0.00	t	\N	2026-02-11 19:49:24.661968	2026-02-20 21:07:02.35939
26	PRD-0014	\N	Papas en casco	\N	12	data:image/jpeg;base64,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	4000.00	8000.00	UND	0.00	t	\N	2026-02-11 19:51:23.063667	2026-02-20 21:08:27.516855
62	PRD-0050	\N	Jarra de Sangria	\N	13	data:image/jpeg;base64,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	30000.00	60000.00	UND	0.00	t	\N	2026-02-11 20:22:02.561238	2026-02-20 21:21:14.58004
35	PRD-0023	\N	Limonada de Coco	\N	18	\N	5000.00	10000.00	UND	0.00	t	\N	2026-02-11 19:58:59.500043	2026-02-22 22:26:02.840865
27	PRD-0015	\N	Soda Michelada	\N	16	data:image/jpeg;base64,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	4000.00	8000.00	UND	0.00	t	\N	2026-02-11 19:52:03.505028	2026-02-20 21:25:13.345537
56	PRD-0044	\N	Copa vino	\N	13	data:image/jpeg;base64,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	9000.00	12000.00	UND	0.00	t	\N	2026-02-11 20:18:48.029467	2026-02-20 21:26:09.283491
28	PRD-0016	\N	Soda Maracuya	\N	16	\N	5000.00	10000.00	UND	0.00	t	\N	2026-02-11 19:52:28.236929	2026-02-22 21:22:18.798826
10	11	\N	Hamburguesa Sencilla	\N	9	data:image/jpeg;base64,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	11000.00	22000.00	UND	0.00	t	\N	2026-02-10 07:19:44.329125	2026-02-22 22:25:43.202756
70	PRD-0058	\N	Café Frappe	\N	22	\N	4000.00	7800.00	UND	0.00	t	\N	2026-02-11 20:26:48.769043	2026-02-11 20:26:48.769043
71	PRD-0059	\N	Carajillo Frio	\N	22	\N	5000.00	8500.00	UND	0.00	t	\N	2026-02-11 20:27:26.068081	2026-02-11 20:27:26.068081
72	PRD-0060	\N	Mocca Frio	\N	22	\N	5000.00	8500.00	UND	0.00	t	\N	2026-02-11 20:27:53.35532	2026-02-11 20:27:53.35532
75	PRD-0063	\N	Chocolate	\N	23	\N	7000.00	11500.00	UND	0.00	t	\N	2026-02-11 20:29:17.832403	2026-02-11 20:29:17.832403
77	PRD-0065	\N	Red Velvet	\N	23	\N	7000.00	11500.00	UND	0.00	t	\N	2026-02-11 20:29:56.121058	2026-02-11 20:29:56.121058
9	10	\N	Bondiola	\N	7	https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSEC-a00xYuKnuLKMR-LfglFMATk581JfFZDQ&s	13000.00	29000.00	UND	0.00	t	\N	2026-02-10 07:18:54.767351	2026-02-16 08:40:23.786919
78	PRD-0066	\N	Hamburguesa de chicharrón	\N	9	\N	30000.00	32000.00	UND	0.00	t	\N	2026-02-11 20:33:03.438602	2026-02-20 19:57:17.141528
3	03	\N	Chicharron	\N	7	data:image/jpeg;base64,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	15000.00	30000.00	UND	0.00	t	\N	2026-01-30 09:13:49.682895	2026-02-20 20:56:02.93341
52	PRD-0040	\N	Corona	\N	19	data:image/jpeg;base64,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	7000.00	9000.00	UND	0.00	t	\N	2026-02-11 20:11:50.718288	2026-02-20 21:09:57.543531
76	PRD-0064	\N	Zanahoria	\N	23	data:image/jpeg;base64,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	7000.00	11500.00	UND	0.00	t	\N	2026-02-11 20:29:33.08393	2026-02-20 21:27:13.504666
73	PRD-0061	\N	Frappe Amaretto	\N	22	\N	6000.00	13000.00	UND	0.00	t	\N	2026-02-11 20:28:26.664954	2026-02-20 21:29:57.263516
79	PRD-0067	\N	1 Entradas Patacones-1 hamb sencilla-1 papas mix- 2 gaseosas	\N	25	\N	40000.00	59000.00	UND	0.00	t	\N	2026-02-22 02:26:20.779594	2026-02-22 02:28:46.257341
80	PRD-0068	\N	Picada Grande	\N	7	\N	35000.00	65000.00	UND	0.00	t	\N	2026-02-22 21:42:47.006146	2026-02-22 21:43:18.92653
81	PRD-0069	\N	SODA	\N	2	\N	2500.00	5000.00	UND	0.00	t	\N	2026-02-25 19:25:11.443689	2026-02-25 19:25:11.443689
82	PRD-0070	\N	SODA CEREZA	\N	16	\N	5000.00	10000.00	UND	0.00	t	\N	2026-02-26 21:23:23.771773	2026-02-26 21:23:23.771773
74	PRD-0062	\N	Frappe Baileys	\N	22	\N	6000.00	15000.00	UND	0.00	t	\N	2026-02-11 20:28:49.731069	2026-02-27 20:40:25.029757
83	PRD-0071	\N	Michelada	\N	2	\N	1500.00	3000.00	UND	0.00	t	\N	2026-02-28 20:34:49.112414	2026-02-28 20:34:49.112414
84	PRD-0072	\N	Picada especial	\N	7	\N	45000.00	85000.00	UND	0.00	t	\N	2026-03-01 20:25:04.830135	2026-03-01 20:25:04.830135
85	PRD-0073	\N	AGUA	\N	2	\N	2000.00	4000.00	UND	0.00	t	\N	2026-03-02 21:39:30.25063	2026-03-02 21:39:30.25063
86	PRD-0074	\N	LATTE	\N	21	\N	5000.00	10000.00	UND	0.00	t	\N	2026-03-04 18:49:58.242267	2026-03-04 18:49:58.242267
46	PRD-0034	\N	Aguila Light	\N	19	\N	4000.00	7.00	UND	0.00	t	\N	2026-02-11 20:08:01.485821	2026-03-07 18:59:51.31893
87	PRD-0075	\N	GASESEOSA 1.5	\N	2	\N	7000.00	12000.00	UND	0.00	t	\N	2026-03-08 20:38:45.96212	2026-03-08 20:38:45.96212
\.


--
-- Data for Name: promotions; Type: TABLE DATA; Schema: public; Owner: morales_user
--

COPY public.promotions (id, name, description, discount_percent, schedule_type, days_of_week, start_date, end_date, is_active, apply_to_all_products, priority, created_at, updated_at) FROM stdin;
1	Martes de Descuento	Descuento especial todos los martes	20.00	WEEKLY	[2]	\N	\N	f	t	1	2026-02-16 09:36:46.765124	2026-02-22 02:24:06.822685
\.


--
-- Data for Name: restaurant_tables; Type: TABLE DATA; Schema: public; Owner: morales_user
--

COPY public.restaurant_tables (id, table_number, name, capacity, status, zone, display_order, is_active, created_at, updated_at) FROM stdin;
2	1	Mesa 1	2	DISPONIBLE	INTERIOR	4	t	2026-02-09 21:12:35.352562	2026-03-08 22:34:29.76928
6	6	Mesa 6	4	DISPONIBLE	INTERIOR	6	t	2026-02-09 21:45:09.486277	2026-03-09 20:46:27.897569
5	5	Mesa 5	4	DISPONIBLE	INTERIOR	5	t	2026-02-09 21:44:54.736515	2026-03-09 21:01:50.933483
7	8	Mesa 8	4	DISPONIBLE	INTERIOR	7	t	2026-02-09 21:45:18.779167	2026-03-09 21:41:07.494908
1	3	Mesa 3	4	DISPONIBLE	INTERIOR	1	t	2026-02-09 21:03:10.598067	2026-03-09 22:55:24.145426
4	4	Mesa 4	12	DISPONIBLE	INTERIOR	4	t	2026-02-09 21:44:26.928299	2026-03-08 21:41:04.365848
3	2	Mesa 2	2	DISPONIBLE	INTERIOR	4	t	2026-02-09 21:44:15.370384	2026-03-08 21:44:13.287391
9	9	Mesa 9	4	DISPONIBLE	VIP	9	t	2026-02-20 19:52:48.078583	2026-03-08 22:15:16.328349
10	11	test 2	4	DISPONIBLE	TEST	11	f	2026-02-20 19:53:04.166414	2026-02-20 21:46:21.988266
8	7	Mesa 7	6	DISPONIBLE	INTERIOR	9	t	2026-02-09 21:45:32.194278	2026-03-08 22:25:01.0666
\.


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: morales_user
--

COPY public.roles (id, name, description, permissions, is_system, created_at, updated_at) FROM stdin;
7	COCINERO	Cocinero - ve pedidos pendientes con exigencias, actualiza estado	["kitchen.view", "kitchen.update_status"]	t	2026-02-11 12:43:51.099709	2026-02-11 12:43:51.099709
1	ADMIN	Administrador del sistema con acceso total	["*", "pos.sell", "pos.discount", "pos.void", "products.view", "products.create", "products.edit", "products.delete", "categories.view", "categories.create", "categories.edit", "categories.delete", "customers.view", "customers.create", "customers.edit", "invoices.view", "invoices.void", "inventory.view", "inventory.adjust", "tables.view", "tables.open", "tables.add_items", "tables.pay", "tables.add_notes", "kitchen.view", "kitchen.update_status", "reports.view", "reports.export", "settings.view", "settings.edit", "users.view", "users.manage"]	t	2026-01-27 11:29:59.946047	2026-02-16 08:05:37.504925
2	CAJERO	Operador de caja - ventas y clientes	["pos:*", "invoices:read", "invoices:create", "products:read", "customers:*", "reports:sales:own", "pos.sell", "pos.discount", "pos.void", "products.view", "products.create", "products.edit", "products.delete", "categories.view", "categories.create", "categories.edit", "categories.delete", "inventory.view", "inventory.adjust", "invoices.view", "invoices.void", "customers.view", "customers.create", "customers.edit", "tables.view", "tables.open", "tables.add_items", "tables.pay", "tables.add_notes", "reports.view", "reports.export"]	t	2026-01-27 11:29:59.946047	2026-02-16 08:06:11.189742
3	INVENTARIO	Gestor de inventario y productos	["products:*", "categories:*", "inventory:*", "suppliers:*", "reports:inventory", "inventory.view", "inventory.adjust", "products.view", "products.create", "products.edit", "products.delete", "categories.view", "categories.create", "categories.edit", "categories.delete"]	t	2026-01-27 11:29:59.946047	2026-02-16 08:06:28.254555
6	MESERO	Mesero - puede abrir mesas, agregar productos y notas	["tables.view", "tables.open", "tables.add_items", "tables.add_notes", "products.view", "categories.view", "customers.view", "pos.sell", "pos.discount", "pos.void"]	t	2026-02-11 12:43:51.099709	2026-02-16 22:53:33.865138
5	REPORTES	Solo visualización de reportes	["reports:*", "products:read", "invoices:read", "customers:read", "invoices.view", "invoices.void", "reports.view", "reports.export"]	t	2026-01-27 11:29:59.946047	2026-02-18 18:40:47.487196
4	SUPERVISOR	Supervisor con acceso a reportes y anulaciones	["pos:*", "invoices:*", "products:read", "customers:*", "reports:*", "users:read", "products.view", "products.create", "products.edit", "products.delete", "pos.sell", "pos.discount", "pos.void", "categories.view", "categories.create", "categories.edit", "categories.delete", "inventory.view", "inventory.adjust", "invoices.view", "invoices.void", "customers.view", "customers.create", "customers.edit", "tables.view", "tables.open", "tables.add_items", "tables.pay", "tables.add_notes", "kitchen.view", "kitchen.update_status", "reports.view", "reports.export", "users.view", "users.manage", "promotions.view", "promotions.create", "promotions.edit", "promotions.delete"]	t	2026-01-27 11:29:59.946047	2026-02-22 00:09:01.293099
\.


--
-- Data for Name: suppliers; Type: TABLE DATA; Schema: public; Owner: morales_user
--

COPY public.suppliers (id, name, contact_name, email, phone, address, tax_id, notes, is_active, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: table_sessions; Type: TABLE DATA; Schema: public; Owner: morales_user
--

COPY public.table_sessions (id, table_id, invoice_id, opened_by, closed_by, opened_at, closed_at, guest_count, notes, status, created_at, updated_at) FROM stdin;
1	1	32	1	1	2026-02-09 21:06:03.508855	2026-02-09 21:07:30.413969	6	\N	CERRADA	2026-02-09 21:06:03.511857	2026-02-09 21:07:30.434167
3	3	34	1	1	2026-02-09 21:47:01.548775	2026-02-09 21:49:32.452399	8	cumpleaños	CERRADA	2026-02-09 21:47:01.550786	2026-02-09 21:49:32.465473
4	5	35	1	1	2026-02-09 21:50:45.963583	2026-02-09 21:51:33.336224	5	\N	CERRADA	2026-02-09 21:50:45.964594	2026-02-09 21:51:33.349003
2	2	33	1	1	2026-02-09 21:13:01.589042	2026-02-09 21:57:47.417433	5	\N	CERRADA	2026-02-09 21:13:01.592503	2026-02-09 21:57:47.434497
6	8	38	1	1	2026-02-09 22:27:14.321215	2026-02-09 22:27:15.825179	1	\N	CERRADA	2026-02-09 22:27:14.323219	2026-02-09 22:27:15.832523
5	2	36	1	1	2026-02-09 21:58:41.469754	2026-02-09 22:40:09.176135	1	\N	CERRADA	2026-02-09 21:58:41.469754	2026-02-09 22:40:09.20769
11	8	43	1	1	2026-02-09 22:53:37.718025	2026-02-09 22:53:38.471895	1	\N	CERRADA	2026-02-09 22:53:37.718025	2026-02-09 22:53:38.682369
10	2	42	1	1	2026-02-09 22:52:47.645656	2026-02-09 22:54:11.46091	1	\N	CERRADA	2026-02-09 22:52:47.646651	2026-02-09 22:54:11.481684
7	1	39	1	1	2026-02-09 22:28:15.304351	2026-02-09 22:54:35.305183	1	\N	CERRADA	2026-02-09 22:28:15.304351	2026-02-09 22:54:35.326243
8	4	40	1	1	2026-02-09 22:31:22.961511	2026-02-09 22:54:45.231084	6	\N	CERRADA	2026-02-09 22:31:22.961511	2026-02-09 22:54:45.618576
9	5	41	1	1	2026-02-09 22:38:57.238061	2026-02-09 22:55:03.361255	7	\N	CERRADA	2026-02-09 22:38:57.239572	2026-02-09 22:55:03.399499
14	4	46	1	1	2026-02-09 23:13:03.151723	2026-02-09 23:20:57.288486	10	\N	CERRADA	2026-02-09 23:13:03.153728	2026-02-09 23:20:57.406604
15	5	47	2	1	2026-02-09 23:15:24.975926	2026-02-09 23:21:04.94009	1	\N	CERRADA	2026-02-09 23:15:24.975926	2026-02-09 23:21:04.993099
12	6	44	2	1	2026-02-09 23:06:24.134088	2026-02-09 23:21:14.741452	1	\N	CERRADA	2026-02-09 23:06:24.136091	2026-02-09 23:21:14.842907
13	7	45	1	1	2026-02-09 23:10:38.400724	2026-02-09 23:21:24.460628	10	\N	CERRADA	2026-02-09 23:10:38.401715	2026-02-09 23:21:24.568812
17	1	49	1	1	2026-02-10 08:53:07.342338	2026-02-10 08:53:56.42478	5	\N	CERRADA	2026-02-10 08:53:07.342338	2026-02-10 08:53:56.437933
20	5	52	1	1	2026-02-10 09:08:21.723667	2026-02-10 09:24:20.040907	1	\N	CERRADA	2026-02-10 09:08:21.725727	2026-02-10 09:24:20.051649
22	2	54	1	1	2026-02-10 09:22:35.821759	2026-02-10 09:35:58.57459	1	\N	CERRADA	2026-02-10 09:22:35.821759	2026-02-10 09:35:58.580115
16	3	48	1	1	2026-02-10 08:52:12.488293	2026-02-10 09:36:04.437661	1	\N	CERRADA	2026-02-10 08:52:12.491439	2026-02-10 09:36:04.445646
24	1	56	1	1	2026-02-10 09:33:40.695633	2026-02-10 09:36:10.724984	5	\N	CERRADA	2026-02-10 09:33:40.695633	2026-02-10 09:36:10.738235
18	4	50	1	1	2026-02-10 08:55:47.701942	2026-02-10 09:36:16.621581	1	\N	CERRADA	2026-02-10 08:55:47.701942	2026-02-10 09:36:16.629983
21	6	53	1	1	2026-02-10 09:20:48.81214	2026-02-10 09:36:21.890992	1	\N	CERRADA	2026-02-10 09:20:48.814168	2026-02-10 09:36:21.895639
23	7	55	1	1	2026-02-10 09:25:43.679255	2026-02-10 09:36:26.801705	5	\N	CERRADA	2026-02-10 09:25:43.679255	2026-02-10 09:36:26.813547
19	8	51	1	1	2026-02-10 08:58:38.213707	2026-02-10 09:36:44.201552	1	\N	CERRADA	2026-02-10 08:58:38.213707	2026-02-10 09:36:44.234003
25	6	57	1	1	2026-02-10 19:27:16.96466	2026-02-10 19:30:26.17136	1	\N	CERRADA	2026-02-10 19:27:16.965692	2026-02-10 19:30:26.199385
26	1	58	1	1	2026-02-10 19:28:34.479936	2026-02-10 19:35:30.536825	1	\N	CERRADA	2026-02-10 19:28:34.479936	2026-02-10 19:35:30.552807
28	4	60	2	1	2026-02-10 20:10:20.508346	2026-02-11 12:20:24.22282	1	\N	CERRADA	2026-02-10 20:10:20.508859	2026-02-11 12:20:24.286572
27	3	59	2	1	2026-02-10 20:09:46.111015	2026-02-11 12:21:12.182253	1	\N	CERRADA	2026-02-10 20:09:46.113531	2026-02-11 12:21:12.220721
29	2	62	1	1	2026-02-11 12:22:19.170897	2026-02-11 12:22:19.438791	1	\N	CERRADA	2026-02-11 12:22:19.170897	2026-02-11 12:22:19.445551
30	1	63	1	1	2026-02-11 12:27:55.135463	2026-02-11 12:27:55.55568	1	\N	CERRADA	2026-02-11 12:27:55.136135	2026-02-11 12:27:55.565432
31	4	65	1	1	2026-02-11 12:31:11.439694	2026-02-11 12:31:31.732365	5	\N	CERRADA	2026-02-11 12:31:11.440709	2026-02-11 12:31:31.74463
33	8	67	1	1	2026-02-11 13:40:52.304354	2026-02-11 15:47:26.715436	1	\N	CERRADA	2026-02-11 13:40:52.305377	2026-02-11 15:47:26.813037
32	2	66	1	1	2026-02-11 13:31:47.916504	2026-02-11 15:47:32.414623	1	\N	CERRADA	2026-02-11 13:31:47.919034	2026-02-11 15:47:32.426745
34	1	68	2	1	2026-02-11 17:12:40.316996	2026-02-11 19:34:31.123949	1	\N	CERRADA	2026-02-11 17:12:40.319503	2026-02-11 19:34:31.154765
35	4	69	2	1	2026-02-11 17:14:31.901941	2026-02-11 19:34:37.002299	5	\N	CERRADA	2026-02-11 17:14:31.901941	2026-02-11 19:34:37.017342
37	4	76	1	1	2026-02-14 20:13:59.085634	2026-02-14 20:20:43.619552	1	\N	CERRADA	2026-02-14 20:13:59.087186	2026-02-14 20:20:43.642049
36	7	75	1	1	2026-02-13 17:27:43.949919	2026-02-14 20:23:13.959026	1	\N	CERRADA	2026-02-13 17:27:43.95145	2026-02-14 20:23:13.984108
38	4	78	1	1	2026-02-15 19:28:16.246146	2026-02-15 19:29:01.342189	6	\N	CERRADA	2026-02-15 19:28:16.249146	2026-02-15 19:29:01.373081
39	2	79	1	1	2026-02-15 21:36:47.052973	2026-02-15 21:37:22.051719	1	\N	CERRADA	2026-02-15 21:36:47.056259	2026-02-15 21:37:22.069701
41	1	81	1	1	2026-02-15 21:42:57.206275	2026-02-15 22:30:32.998643	1	\N	CERRADA	2026-02-15 21:42:57.206275	2026-02-15 22:30:33.033101
40	2	80	1	1	2026-02-15 21:41:17.827998	2026-02-15 22:45:45.471472	1	\N	CERRADA	2026-02-15 21:41:17.829013	2026-02-15 22:45:45.517118
42	1	83	1	1	2026-02-15 22:48:56.222864	2026-02-15 22:57:30.914673	1	\N	CERRADA	2026-02-15 22:48:56.222864	2026-02-15 22:57:30.94912
43	1	84	1	1	2026-02-15 22:58:25.421576	2026-02-15 22:58:26.189187	1	\N	CERRADA	2026-02-15 22:58:25.421576	2026-02-15 22:58:26.222389
44	5	85	1	1	2026-02-16 08:04:33.108929	2026-02-16 09:12:09.625241	1	\N	CERRADA	2026-02-16 08:04:33.114463	2026-02-16 09:12:09.730899
45	8	87	1	1	2026-02-16 08:31:15.877021	2026-02-16 09:12:18.247526	1	\N	CERRADA	2026-02-16 08:31:15.878542	2026-02-16 09:12:18.344695
46	2	88	1	1	2026-02-16 09:46:59.795366	2026-02-16 11:16:08.765023	1	\N	CERRADA	2026-02-16 09:46:59.797379	2026-02-16 11:16:08.817581
47	4	89	1	9	2026-02-16 12:17:48.996197	2026-02-16 13:52:15.542428	1	\N	CERRADA	2026-02-16 12:17:48.99987	2026-02-16 13:52:15.55702
48	6	91	9	1	2026-02-16 18:36:25.978769	2026-02-16 20:58:53.128984	1	\N	CERRADA	2026-02-16 18:36:25.979731	2026-02-16 20:58:53.137128
50	3	99	6	9	2026-02-16 22:53:08.707602	2026-02-16 23:50:00.769468	1	\N	CERRADA	2026-02-16 22:53:08.711133	2026-02-16 23:50:00.819661
49	2	92	9	9	2026-02-16 20:59:14.060417	2026-02-16 23:50:06.875559	1	\N	CERRADA	2026-02-16 20:59:14.061433	2026-02-16 23:50:06.892066
52	4	101	6	1	2026-02-16 23:30:16.06181	2026-02-18 09:37:25.524607	1	\N	CERRADA	2026-02-16 23:30:16.063469	2026-02-18 09:37:25.536592
51	1	100	6	1	2026-02-16 23:08:27.575636	2026-02-18 09:37:40.5022	1	\N	CERRADA	2026-02-16 23:08:27.576649	2026-02-18 09:37:40.507724
53	1	102	1	1	2026-02-18 17:09:11.319106	2026-02-18 17:20:42.841517	1	\N	CERRADA	2026-02-18 17:09:11.324843	2026-02-18 17:20:42.928376
54	4	103	1	1	2026-02-18 17:21:01.275401	2026-02-18 17:21:48.74034	1	\N	CERRADA	2026-02-18 17:21:01.275401	2026-02-18 17:21:48.751662
55	7	104	9	9	2026-02-18 17:29:32.57805	2026-02-18 17:41:25.349148	1	\N	CERRADA	2026-02-18 17:29:32.580237	2026-02-18 17:41:25.36922
56	7	105	9	10	2026-02-18 17:44:55.561698	2026-02-18 17:57:10.782579	1	\N	CERRADA	2026-02-18 17:44:55.564467	2026-02-18 17:57:10.786355
57	7	106	10	10	2026-02-18 17:57:27.908592	2026-02-18 17:57:51.69559	5	\N	CERRADA	2026-02-18 17:57:27.909589	2026-02-18 17:57:51.697118
58	7	107	1	9	2026-02-18 17:58:20.014481	2026-02-18 18:35:03.001489	1	\N	CERRADA	2026-02-18 17:58:20.014481	2026-02-18 18:35:03.006836
59	2	109	9	9	2026-02-18 20:38:13.368856	2026-02-18 20:44:38.44396	1	\N	CERRADA	2026-02-18 20:38:13.374122	2026-02-18 20:44:38.445994
60	6	110	9	9	2026-02-18 20:47:03.743675	2026-02-18 20:48:19.427703	1	\N	CERRADA	2026-02-18 20:47:03.743675	2026-02-18 20:48:19.438693
62	3	113	1	1	2026-02-19 18:14:36.276486	2026-02-19 18:14:52.160413	5	\N	CERRADA	2026-02-19 18:14:36.276486	2026-02-19 18:14:52.160935
61	2	112	9	9	2026-02-19 18:11:00.510172	2026-02-19 18:19:58.573688	1	\N	CERRADA	2026-02-19 18:11:00.516231	2026-02-19 18:19:58.58231
63	2	114	9	9	2026-02-19 18:20:19.999392	2026-02-19 18:24:00.058259	1	\N	CERRADA	2026-02-19 18:20:20.000407	2026-02-19 18:24:00.080635
90	6	147	9	9	2026-02-22 19:02:27.650682	2026-02-22 19:03:11.880022	1	\N	CERRADA	2026-02-22 19:02:27.650682	2026-02-22 19:03:11.888296
64	1	115	1	1	2026-02-20 00:10:27.103976	2026-02-20 12:35:17.593841	1	smoke-test	CERRADA	2026-02-20 00:10:27.106988	2026-02-20 12:35:17.597377
65	2	116	1	1	2026-02-20 12:28:28.761627	2026-02-20 12:36:10.588964	1	\N	CERRADA	2026-02-20 12:28:28.768645	2026-02-20 12:36:10.729959
88	1	145	9	9	2026-02-22 18:58:26.169317	2026-02-22 19:05:35.23673	1	\N	CERRADA	2026-02-22 18:58:26.169317	2026-02-22 19:05:35.245987
66	2	117	1	1	2026-02-20 19:24:20.72278	2026-02-20 19:44:36.276695	1	cron-test	CERRADA	2026-02-20 19:24:20.724798	2026-02-20 19:44:36.27971
67	1	118	1	1	2026-02-20 19:24:21.305627	2026-02-20 19:45:34.347923	1	cron-test	CERRADA	2026-02-20 19:24:21.306625	2026-02-20 19:45:34.350437
68	6	119	1	1	2026-02-20 19:30:59.942309	2026-02-20 19:45:47.64332	1	\N	CERRADA	2026-02-20 19:30:59.943303	2026-02-20 19:45:47.645354
92	4	149	10	1	2026-02-22 19:17:50.842859	2026-02-22 19:30:47.857935	1	\N	CERRADA	2026-02-22 19:17:50.842859	2026-02-22 19:30:47.859615
91	1	148	10	1	2026-02-22 19:10:57.744967	2026-02-22 19:30:54.786078	3	\N	CERRADA	2026-02-22 19:10:57.744967	2026-02-22 19:30:54.786723
69	9	121	1	1	2026-02-20 19:53:23.566039	2026-02-20 20:05:34.357009	3	\N	CERRADA	2026-02-20 19:53:23.567564	2026-02-20 20:05:34.358013
93	9	150	1	1	2026-02-22 19:21:17.674741	2026-02-22 19:31:12.5921	1	\N	CERRADA	2026-02-22 19:21:17.674741	2026-02-22 19:31:12.5921
70	10	122	1	1	2026-02-20 19:56:15.496079	2026-02-20 20:07:13.330114	1	\N	CERRADA	2026-02-20 19:56:15.496079	2026-02-20 20:07:13.332114
89	3	146	9	1	2026-02-22 18:58:56.669776	2026-02-22 19:36:45.231557	2	\N	CERRADA	2026-02-22 18:58:56.669776	2026-02-22 19:36:45.254997
73	2	125	10	9	2026-02-20 20:13:42.124449	2026-02-20 20:14:55.43264	1	\N	CERRADA	2026-02-20 20:13:42.341808	2026-02-20 20:14:55.433661
71	5	123	10	9	2026-02-20 20:04:25.246702	2026-02-20 20:37:45.376571	1	\N	CERRADA	2026-02-20 20:04:25.248809	2026-02-20 20:37:45.430188
74	8	126	9	9	2026-02-20 20:38:05.818941	2026-02-20 20:38:27.235789	1	\N	CERRADA	2026-02-20 20:38:05.818941	2026-02-20 20:38:27.241478
75	7	127	9	9	2026-02-20 21:08:35.973474	2026-02-20 21:09:03.853524	1	\N	CERRADA	2026-02-20 21:08:35.977249	2026-02-20 21:09:03.859522
72	6	124	10	9	2026-02-20 20:07:06.451069	2026-02-20 21:12:51.611469	1	\N	CERRADA	2026-02-20 20:07:06.452163	2026-02-20 21:12:51.619472
76	1	128	9	9	2026-02-20 21:30:58.171194	2026-02-20 21:50:06.101385	1	\N	CERRADA	2026-02-20 21:30:58.173203	2026-02-20 21:50:06.116486
94	6	153	9	9	2026-02-22 20:28:28.688653	2026-02-22 21:16:32.839764	1	\N	CERRADA	2026-02-22 20:28:28.689668	2026-02-22 21:16:32.848853
77	9	130	1	1	2026-02-20 22:47:25.023334	2026-02-20 22:49:33.35775	1	\N	CERRADA	2026-02-20 22:47:25.025334	2026-02-20 22:49:33.359748
96	8	155	9	9	2026-02-22 21:12:58.172684	2026-02-22 21:25:52.881749	1	\N	CERRADA	2026-02-22 21:12:58.173242	2026-02-22 21:25:52.889316
79	7	135	1	1	2026-02-22 00:10:50.528782	2026-02-22 00:12:51.023016	5	\N	CERRADA	2026-02-22 00:10:50.533127	2026-02-22 00:12:51.050158
78	9	134	1	1	2026-02-21 23:56:11.711635	2026-02-22 00:15:16.280454	1	\N	CERRADA	2026-02-21 23:56:11.712303	2026-02-22 00:15:16.285001
80	7	136	1	1	2026-02-22 00:13:58.299964	2026-02-22 00:15:25.908865	1	\N	CERRADA	2026-02-22 00:13:58.299964	2026-02-22 00:15:25.922708
95	1	154	10	9	2026-02-22 21:01:56.290995	2026-02-22 22:12:00.155445	1	\N	CERRADA	2026-02-22 21:01:56.291567	2026-02-22 22:12:00.160661
97	4	156	9	9	2026-02-22 21:44:39.515236	2026-02-22 22:12:50.268945	1	\N	CERRADA	2026-02-22 21:44:39.516303	2026-02-22 22:12:50.276274
81	9	137	1	1	2026-02-22 00:35:19.274655	2026-02-22 01:33:15.431273	1	\N	CERRADA	2026-02-22 00:35:19.295081	2026-02-22 01:33:15.450105
82	7	138	1	1	2026-02-22 01:00:54.666399	2026-02-22 01:33:21.12088	1	\N	CERRADA	2026-02-22 01:00:54.669747	2026-02-22 01:33:21.125403
83	9	139	1	1	2026-02-22 01:33:24.944416	2026-02-22 02:20:37.365354	1	\N	CERRADA	2026-02-22 01:33:24.944416	2026-02-22 02:20:37.401014
98	8	157	10	9	2026-02-22 22:01:34.33364	2026-02-22 22:36:30.791786	1	\N	CERRADA	2026-02-22 22:01:34.334257	2026-02-22 22:36:30.810747
99	1	158	9	9	2026-02-22 22:29:36.51665	2026-02-22 23:09:59.215121	1	\N	CERRADA	2026-02-22 22:29:36.517732	2026-02-22 23:09:59.227735
84	2	140	1	9	2026-02-22 02:20:45.520138	2026-02-22 18:49:23.421711	1	\N	CERRADA	2026-02-22 02:20:45.520138	2026-02-22 18:49:23.424441
85	3	141	1	9	2026-02-22 02:21:02.009019	2026-02-22 18:49:28.421847	1	\N	CERRADA	2026-02-22 02:21:02.009019	2026-02-22 18:49:28.422998
86	1	142	1	9	2026-02-22 02:29:04.610685	2026-02-22 18:49:44.467606	1	\N	CERRADA	2026-02-22 02:29:04.612711	2026-02-22 18:49:44.469151
100	7	159	9	9	2026-02-23 18:54:24.631165	2026-02-23 19:14:01.845501	1	\N	CERRADA	2026-02-23 18:54:24.63336	2026-02-23 19:14:01.907402
87	9	144	9	9	2026-02-22 18:49:48.878535	2026-02-22 18:50:29.92802	1	\N	CERRADA	2026-02-22 18:49:48.878535	2026-02-22 18:50:29.934336
101	7	168	9	9	2026-02-25 19:06:46.761999	2026-02-25 19:31:12.383808	1	\N	CERRADA	2026-02-25 19:06:46.766012	2026-02-25 19:31:12.408859
104	1	172	9	9	2026-02-25 20:29:55.409597	2026-02-25 20:30:01.23919	1	\N	CERRADA	2026-02-25 20:29:55.410593	2026-02-25 20:30:01.277827
103	6	171	9	9	2026-02-25 19:58:52.002862	2026-02-25 20:32:19.576379	1	\N	CERRADA	2026-02-25 19:58:52.004378	2026-02-25 20:32:19.604045
102	8	170	9	9	2026-02-25 19:54:51.901763	2026-02-25 20:33:15.620871	1	\N	CERRADA	2026-02-25 19:54:51.902775	2026-02-25 20:33:15.637804
105	1	173	9	9	2026-02-25 20:31:13.083273	2026-02-25 21:24:15.431806	1	\N	CERRADA	2026-02-25 20:31:13.083273	2026-02-25 21:24:15.452354
106	7	174	9	9	2026-02-25 21:34:49.781494	2026-02-25 21:45:00.295368	1	\N	CERRADA	2026-02-25 21:34:49.782291	2026-02-25 21:45:00.313695
107	6	175	9	9	2026-02-26 21:01:34.534822	2026-02-26 21:50:49.741066	1	\N	CERRADA	2026-02-26 21:01:34.536833	2026-02-26 21:50:49.763321
109	7	178	9	9	2026-02-26 21:52:13.919222	2026-02-26 21:55:29.103501	1	\N	CERRADA	2026-02-26 21:52:13.919222	2026-02-26 21:55:29.112071
108	1	177	9	9	2026-02-26 21:23:35.043888	2026-02-26 22:00:52.9016	1	\N	CERRADA	2026-02-26 21:23:35.0454	2026-02-26 22:00:52.921249
110	7	180	9	9	2026-02-26 22:11:32.242457	2026-02-26 22:15:08.465786	1	\N	CERRADA	2026-02-26 22:11:32.242984	2026-02-26 22:15:08.475021
111	6	182	9	9	2026-02-27 18:38:32.523223	2026-02-27 18:47:23.882263	1	\N	CERRADA	2026-02-27 18:38:32.526503	2026-02-27 18:47:23.979036
112	8	183	9	9	2026-02-27 19:43:49.590889	2026-02-27 19:59:19.272477	1	\N	CERRADA	2026-02-27 19:43:49.593407	2026-02-27 19:59:19.312103
114	7	185	9	9	2026-02-27 20:37:29.155086	2026-02-27 20:41:34.881406	2	\N	CERRADA	2026-02-27 20:37:29.157119	2026-02-27 20:41:34.889867
113	6	184	10	9	2026-02-27 20:16:08.756991	2026-02-27 21:44:02.731939	1	\N	CERRADA	2026-02-27 20:16:08.758155	2026-02-27 21:44:02.74897
116	4	187	9	9	2026-02-27 21:57:54.042546	2026-02-27 22:00:00.123852	1	\N	CERRADA	2026-02-27 21:57:54.04355	2026-02-27 22:00:00.125875
119	6	190	9	9	2026-02-27 22:02:03.242903	2026-02-27 22:16:20.339991	1	\N	CERRADA	2026-02-27 22:02:03.242903	2026-02-27 22:16:20.358281
117	1	188	9	9	2026-02-27 21:59:40.833001	2026-02-27 22:18:24.599141	1	\N	CERRADA	2026-02-27 21:59:40.833001	2026-02-27 22:18:24.611654
118	4	189	9	9	2026-02-27 22:01:08.497069	2026-02-27 22:25:46.583558	1	\N	CERRADA	2026-02-27 22:01:08.497069	2026-02-27 22:25:46.602865
120	7	191	9	9	2026-02-27 22:50:01.023002	2026-02-27 22:54:51.150986	1	\N	CERRADA	2026-02-27 22:50:01.023521	2026-02-27 22:54:51.177158
115	8	186	9	9	2026-02-27 20:59:24.039998	2026-02-27 23:16:52.469986	1	\N	CERRADA	2026-02-27 20:59:24.041049	2026-02-27 23:16:52.485269
121	5	192	9	9	2026-02-27 22:50:48.504796	2026-02-27 23:59:46.08304	1	\N	CERRADA	2026-02-27 22:50:48.504796	2026-02-27 23:59:46.099384
122	5	195	10	9	2026-02-28 17:29:48.149723	2026-02-28 18:30:45.670479	1	\N	CERRADA	2026-02-28 17:29:48.151376	2026-02-28 18:30:45.695139
124	8	197	1	1	2026-02-28 18:17:03.28094	2026-02-28 19:05:30.03561	1	\N	CERRADA	2026-02-28 18:17:03.286966	2026-02-28 19:05:30.047659
127	5	200	10	1	2026-02-28 18:49:39.420658	2026-02-28 19:24:42.736115	1	\N	CERRADA	2026-02-28 18:49:39.420658	2026-02-28 19:24:42.756702
128	9	201	1	1	2026-02-28 19:13:59.408782	2026-02-28 19:36:36.792775	1	\N	CERRADA	2026-02-28 19:13:59.408782	2026-02-28 19:36:36.804604
123	6	196	1	1	2026-02-28 18:11:19.980571	2026-02-28 19:57:48.733216	1	\N	CERRADA	2026-02-28 18:11:19.98283	2026-02-28 19:57:48.75505
125	7	198	9	1	2026-02-28 18:40:33.964043	2026-02-28 19:17:20.499072	1	\N	CERRADA	2026-02-28 18:40:33.965573	2026-02-28 19:17:20.512372
129	7	202	1	1	2026-02-28 19:29:36.185115	2026-02-28 19:32:53.422787	1	\N	CERRADA	2026-02-28 19:29:36.185115	2026-02-28 19:32:53.451216
126	1	199	10	1	2026-02-28 18:47:43.91115	2026-02-28 19:40:52.226204	1	\N	CERRADA	2026-02-28 18:47:43.91115	2026-02-28 19:40:52.242798
171	6	251	1	1	2026-03-04 19:46:31.971773	2026-03-04 20:34:21.701524	1	\N	CERRADA	2026-03-04 19:46:31.971773	2026-03-04 20:34:21.716009
130	7	203	1	1	2026-02-28 19:51:32.904498	2026-02-28 20:17:13.865198	1	\N	CERRADA	2026-02-28 19:51:32.904498	2026-02-28 20:17:13.886319
172	8	252	10	1	2026-03-04 20:04:28.970458	2026-03-04 21:19:21.960834	1	\N	CERRADA	2026-03-04 20:04:28.971473	2026-03-04 21:19:21.987017
131	8	204	10	1	2026-02-28 20:10:17.561446	2026-02-28 20:47:55.620699	1	\N	CERRADA	2026-02-28 20:10:17.5644	2026-02-28 20:47:55.640141
173	4	253	10	1	2026-03-04 20:43:24.88843	2026-03-04 22:08:11.536461	1	\N	CERRADA	2026-03-04 20:43:24.889455	2026-03-04 22:08:11.558804
132	5	205	1	1	2026-02-28 20:35:45.423613	2026-02-28 21:23:49.225209	1	\N	CERRADA	2026-02-28 20:35:45.425244	2026-02-28 21:23:49.271515
174	5	256	1	1	2026-03-05 19:52:29.066815	2026-03-05 20:48:35.279398	1	\N	CERRADA	2026-03-05 19:52:29.067345	2026-03-05 20:48:35.310058
133	6	206	1	1	2026-02-28 21:04:33.830469	2026-02-28 21:47:37.220796	2	\N	CERRADA	2026-02-28 21:04:33.831499	2026-02-28 21:47:37.238576
175	9	262	1	1	2026-03-07 18:58:49.468713	2026-03-07 19:07:59.817552	1	\N	CERRADA	2026-03-07 18:58:49.47174	2026-03-07 19:07:59.839302
134	8	207	1	1	2026-02-28 21:31:52.692398	2026-02-28 22:06:29.810329	3	\N	CERRADA	2026-02-28 21:31:52.692398	2026-02-28 22:06:29.827522
136	1	209	1	1	2026-02-28 21:49:38.301353	2026-02-28 22:36:00.319297	2	\N	CERRADA	2026-02-28 21:49:38.301353	2026-02-28 22:36:00.34126
139	2	212	1	1	2026-02-28 21:54:13.517959	2026-02-28 22:44:26.708884	2	\N	CERRADA	2026-02-28 21:54:13.517959	2026-02-28 22:44:26.729956
135	3	208	1	1	2026-02-28 21:39:59.899219	2026-02-28 22:45:25.269278	1	\N	CERRADA	2026-02-28 21:39:59.901333	2026-02-28 22:45:25.278403
178	8	266	1	1	2026-03-07 19:27:05.642115	2026-03-07 19:43:12.22801	1	\N	CERRADA	2026-03-07 19:27:05.642115	2026-03-07 19:43:12.25644
137	4	210	1	1	2026-02-28 21:50:36.895235	2026-02-28 22:50:26.978248	7	\N	CERRADA	2026-02-28 21:50:36.895235	2026-02-28 22:50:27.003
138	5	211	1	1	2026-02-28 21:52:53.633536	2026-02-28 22:51:55.49735	1	\N	CERRADA	2026-02-28 21:52:53.633536	2026-02-28 22:51:55.504351
140	6	213	1	1	2026-02-28 21:58:06.442806	2026-02-28 22:52:45.201336	1	\N	CERRADA	2026-02-28 21:58:06.442806	2026-02-28 22:52:45.213207
144	9	217	1	1	2026-02-28 23:02:59.198909	2026-02-28 23:11:14.783246	1	\N	CERRADA	2026-02-28 23:02:59.198909	2026-02-28 23:11:14.796577
143	1	216	1	1	2026-02-28 22:53:05.726033	2026-02-28 23:19:01.28109	2	\N	CERRADA	2026-02-28 22:53:05.726033	2026-02-28 23:19:01.299196
142	2	215	1	1	2026-02-28 22:46:15.751557	2026-02-28 23:20:02.02766	1	\N	CERRADA	2026-02-28 22:46:15.751557	2026-02-28 23:20:02.03984
181	9	269	1	1	2026-03-07 19:52:36.069212	2026-03-07 19:56:46.086221	1	\N	CERRADA	2026-03-07 19:52:36.070228	2026-03-07 19:56:46.112349
141	7	214	1	1	2026-02-28 22:29:18.699439	2026-02-28 23:29:32.480968	1	\N	CERRADA	2026-02-28 22:29:18.699439	2026-02-28 23:29:32.485895
146	7	219	1	1	2026-02-28 23:29:48.971447	2026-02-28 23:30:20.276222	1	\N	CERRADA	2026-02-28 23:29:48.971447	2026-02-28 23:30:20.283012
145	6	218	1	1	2026-02-28 23:20:21.005641	2026-02-28 23:56:53.745494	2	\N	CERRADA	2026-02-28 23:20:21.005641	2026-02-28 23:56:53.762072
182	9	270	1	1	2026-03-07 20:03:04.228701	2026-03-07 20:04:03.942304	1	\N	CERRADA	2026-03-07 20:03:04.229685	2026-03-07 20:04:03.94887
184	2	272	1	1	2026-03-07 20:46:17.673966	2026-03-07 20:48:24.801425	1	\N	CERRADA	2026-03-07 20:46:17.673966	2026-03-07 20:48:24.810144
148	5	221	1	1	2026-03-01 19:20:55.760752	2026-03-01 19:30:56.167051	1	\N	CERRADA	2026-03-01 19:20:55.762772	2026-03-01 19:30:56.267054
147	6	220	10	1	2026-03-01 18:41:05.962223	2026-03-01 19:33:05.256515	1	\N	CERRADA	2026-03-01 18:41:05.963751	2026-03-01 19:33:05.298355
177	7	265	1	1	2026-03-07 19:25:29.307246	2026-03-07 20:48:57.627814	1	\N	CERRADA	2026-03-07 19:25:29.308335	2026-03-07 20:48:57.627814
183	9	271	1	1	2026-03-07 20:29:13.123941	2026-03-07 20:54:00.427495	1	\N	CERRADA	2026-03-07 20:29:13.123941	2026-03-07 20:54:00.443494
151	6	224	10	1	2026-03-01 19:45:35.539407	2026-03-01 19:55:32.799883	1	\N	CERRADA	2026-03-01 19:45:35.541492	2026-03-01 19:55:32.801484
185	7	273	1	1	2026-03-07 21:08:58.369508	2026-03-07 21:09:46.809084	1	\N	CERRADA	2026-03-07 21:08:58.369508	2026-03-07 21:09:46.816426
149	1	222	10	1	2026-03-01 19:23:22.165526	2026-03-01 20:15:51.278914	1	\N	CERRADA	2026-03-01 19:23:22.165526	2026-03-01 20:15:51.299125
179	4	267	1	1	2026-03-07 19:39:46.393125	2026-03-07 21:28:33.215921	1	\N	CERRADA	2026-03-07 19:39:46.395158	2026-03-07 21:28:33.226395
152	8	225	1	1	2026-03-01 19:52:27.618222	2026-03-01 20:26:03.518785	8	\N	CERRADA	2026-03-01 19:52:27.619279	2026-03-01 20:26:03.547009
154	9	227	1	1	2026-03-01 20:05:58.449933	2026-03-01 20:37:22.715889	1	\N	CERRADA	2026-03-01 20:05:58.449933	2026-03-01 20:37:22.741625
153	3	226	1	1	2026-03-01 19:55:41.705323	2026-03-01 20:53:47.37827	2	\N	CERRADA	2026-03-01 19:55:41.705323	2026-03-01 20:53:47.403106
155	2	228	10	1	2026-03-01 20:18:10.775154	2026-03-01 21:01:22.747535	1	\N	CERRADA	2026-03-01 20:18:10.775154	2026-03-01 21:01:22.777865
156	6	229	1	1	2026-03-01 20:30:55.065872	2026-03-01 21:06:29.158686	2	\N	CERRADA	2026-03-01 20:30:55.065872	2026-03-01 21:06:29.191397
158	5	231	1	1	2026-03-01 20:50:41.738287	2026-03-01 21:55:54.989822	1	\N	CERRADA	2026-03-01 20:50:41.739809	2026-03-01 21:55:55.002058
188	1	276	1	1	2026-03-07 22:08:36.625139	2026-03-07 22:09:52.429833	1	\N	CERRADA	2026-03-07 22:08:36.626363	2026-03-07 22:09:52.438042
180	6	268	1	1	2026-03-07 19:46:06.35988	2026-03-07 22:18:05.979509	1	\N	CERRADA	2026-03-07 19:46:06.360387	2026-03-07 22:18:05.980521
157	7	230	1	1	2026-03-01 20:39:20.591335	2026-03-01 22:20:28.38427	1	\N	CERRADA	2026-03-01 20:39:20.592348	2026-03-01 22:20:28.398573
159	5	232	1	1	2026-03-01 21:55:59.974042	2026-03-01 22:31:33.487374	1	\N	CERRADA	2026-03-01 21:55:59.974042	2026-03-01 22:31:33.497124
160	6	233	10	1	2026-03-01 22:02:49.549019	2026-03-01 22:40:46.402958	1	\N	CERRADA	2026-03-01 22:02:49.549915	2026-03-01 22:40:46.41706
150	4	223	1	1	2026-03-01 19:23:27.110037	2026-03-01 23:06:45.266631	1	\N	CERRADA	2026-03-01 19:23:27.110037	2026-03-01 23:06:45.318695
161	5	234	1	1	2026-03-01 23:01:30.765256	2026-03-01 23:44:36.032446	1	\N	CERRADA	2026-03-01 23:01:30.765801	2026-03-01 23:44:36.059005
189	4	277	1	1	2026-03-07 22:23:55.922583	2026-03-07 22:26:02.967667	1	\N	CERRADA	2026-03-07 22:23:55.922583	2026-03-07 22:26:02.976956
162	4	238	1	1	2026-03-02 18:56:46.857228	2026-03-02 21:12:04.305434	1	\N	CERRADA	2026-03-02 18:56:46.85828	2026-03-02 21:12:04.387714
190	7	278	1	1	2026-03-07 22:27:16.734351	2026-03-07 22:30:40.263605	1	\N	CERRADA	2026-03-07 22:27:16.734351	2026-03-07 22:30:40.268531
164	4	242	1	1	2026-03-02 21:13:12.905807	2026-03-02 21:14:03.512509	1	\N	CERRADA	2026-03-02 21:13:12.905807	2026-03-02 21:14:03.518892
186	2	274	1	1	2026-03-07 21:48:09.900875	2026-03-07 22:32:00.023404	1	\N	CERRADA	2026-03-07 21:48:09.901875	2026-03-07 22:32:00.032034
176	5	263	1	1	2026-03-07 19:00:57.383981	2026-03-07 22:50:02.729487	1	\N	CERRADA	2026-03-07 19:00:57.385589	2026-03-07 22:50:02.729998
187	3	275	1	1	2026-03-07 22:04:49.712696	2026-03-07 23:11:03.429863	1	\N	CERRADA	2026-03-07 22:04:49.714224	2026-03-07 23:11:03.439515
168	7	246	1	1	2026-03-02 21:34:00.258319	2026-03-02 21:34:51.9696	1	\N	CERRADA	2026-03-02 21:34:00.258319	2026-03-02 21:34:51.971408
167	8	245	1	1	2026-03-02 21:31:56.619891	2026-03-02 21:37:58.695538	1	\N	CERRADA	2026-03-02 21:31:56.62198	2026-03-02 21:37:58.707609
163	5	241	10	1	2026-03-02 20:49:58.844692	2026-03-02 21:47:46.458024	1	\N	CERRADA	2026-03-02 20:49:58.845213	2026-03-02 21:47:46.475442
165	1	243	1	1	2026-03-02 21:25:02.659824	2026-03-02 21:56:07.459755	1	\N	CERRADA	2026-03-02 21:25:02.661352	2026-03-02 21:56:07.467128
166	6	244	1	1	2026-03-02 21:26:57.831833	2026-03-02 22:09:12.006311	1	\N	CERRADA	2026-03-02 21:26:57.831833	2026-03-02 22:09:12.025447
169	9	248	1	1	2026-03-04 13:48:02.126229	2026-03-04 13:49:05.027745	1	\N	CERRADA	2026-03-04 13:48:02.128291	2026-03-04 13:49:05.032319
170	2	249	1	1	2026-03-04 18:09:01.268541	2026-03-04 18:59:38.758008	1	\N	CERRADA	2026-03-04 18:09:01.271103	2026-03-04 18:59:38.781517
192	1	280	1	1	2026-03-07 22:34:37.108613	2026-03-07 22:35:00.766365	1	\N	CERRADA	2026-03-07 22:34:37.108613	2026-03-07 22:35:00.771956
191	8	279	1	1	2026-03-07 22:32:39.927799	2026-03-07 22:36:20.633271	1	\N	CERRADA	2026-03-07 22:32:39.927799	2026-03-07 22:36:20.63731
193	1	281	1	1	2026-03-07 22:38:59.05294	2026-03-07 22:39:32.737738	1	\N	CERRADA	2026-03-07 22:38:59.05294	2026-03-07 22:39:32.746008
194	1	282	1	1	2026-03-07 22:41:06.658453	2026-03-07 22:41:52.342894	1	\N	CERRADA	2026-03-07 22:41:06.658453	2026-03-07 22:41:52.349442
195	1	283	1	1	2026-03-07 22:42:53.095669	2026-03-07 22:44:04.151294	1	\N	CERRADA	2026-03-07 22:42:53.095669	2026-03-07 22:44:04.16212
196	1	284	1	1	2026-03-07 22:44:36.510052	2026-03-07 22:45:45.342336	1	\N	CERRADA	2026-03-07 22:44:36.510052	2026-03-07 22:45:45.349178
197	1	285	1	1	2026-03-07 22:46:12.991637	2026-03-07 22:47:15.876759	1	\N	CERRADA	2026-03-07 22:46:12.991637	2026-03-07 22:47:15.889835
200	4	288	1	1	2026-03-07 22:56:04.13824	2026-03-07 22:57:52.61977	1	\N	CERRADA	2026-03-07 22:56:04.139259	2026-03-07 22:57:52.62597
198	8	286	1	1	2026-03-07 22:50:40.747319	2026-03-07 22:58:32.515509	1	\N	CERRADA	2026-03-07 22:50:40.747319	2026-03-07 22:58:32.521573
199	1	287	1	1	2026-03-07 22:52:57.987952	2026-03-07 23:03:16.050611	1	\N	CERRADA	2026-03-07 22:52:57.987952	2026-03-07 23:03:16.058162
201	1	289	1	1	2026-03-07 23:08:51.448458	2026-03-07 23:16:36.811373	1	\N	CERRADA	2026-03-07 23:08:51.448458	2026-03-07 23:16:36.812385
202	4	290	1	1	2026-03-07 23:16:45.254742	2026-03-07 23:19:09.443967	1	\N	CERRADA	2026-03-07 23:16:45.254742	2026-03-07 23:19:09.456751
204	1	292	1	1	2026-03-07 23:23:54.006058	2026-03-07 23:25:24.804453	1	\N	CERRADA	2026-03-07 23:23:54.006058	2026-03-07 23:25:24.814641
203	4	291	1	1	2026-03-07 23:20:09.199473	2026-03-07 23:26:58.080448	1	\N	CERRADA	2026-03-07 23:20:09.199473	2026-03-07 23:26:58.081975
205	1	293	1	1	2026-03-07 23:27:02.21244	2026-03-07 23:28:29.49399	1	\N	CERRADA	2026-03-07 23:27:02.21244	2026-03-07 23:28:29.503835
206	8	294	1	1	2026-03-07 23:29:16.321818	2026-03-07 23:30:37.180404	1	\N	CERRADA	2026-03-07 23:29:16.321818	2026-03-07 23:30:37.181915
207	4	295	1	1	2026-03-07 23:30:49.087586	2026-03-07 23:31:07.532072	1	\N	CERRADA	2026-03-07 23:30:49.087586	2026-03-07 23:31:07.536936
208	8	296	1	1	2026-03-07 23:32:10.761336	2026-03-07 23:41:20.794489	1	\N	CERRADA	2026-03-07 23:32:10.761336	2026-03-07 23:41:20.802934
209	4	297	1	1	2026-03-08 00:08:47.433301	2026-03-08 00:19:05.627769	1	\N	CERRADA	2026-03-08 00:08:47.434592	2026-03-08 00:19:05.641931
210	1	299	1	1	2026-03-08 18:59:30.80292	2026-03-08 19:03:47.107153	1	\N	CERRADA	2026-03-08 18:59:30.80292	2026-03-08 19:03:47.129545
212	7	301	1	1	2026-03-08 19:16:51.451362	2026-03-08 19:24:27.871598	1	\N	CERRADA	2026-03-08 19:16:51.452876	2026-03-08 19:24:27.88884
214	1	303	1	1	2026-03-08 19:26:10.18841	2026-03-08 19:43:37.892121	1	\N	CERRADA	2026-03-08 19:26:10.1896	2026-03-08 19:43:37.908235
211	2	300	1	1	2026-03-08 19:00:53.949516	2026-03-08 19:44:40.777598	1	\N	CERRADA	2026-03-08 19:00:53.950563	2026-03-08 19:44:40.787267
215	8	304	1	1	2026-03-08 19:38:58.011842	2026-03-08 20:09:58.03195	1	\N	CERRADA	2026-03-08 19:38:58.01254	2026-03-08 20:09:58.058827
216	3	305	1	1	2026-03-08 19:39:38.586784	2026-03-08 20:29:55.821892	1	\N	CERRADA	2026-03-08 19:39:38.586784	2026-03-08 20:29:55.834172
218	8	307	1	1	2026-03-08 20:15:30.547184	2026-03-08 20:45:52.568655	1	\N	CERRADA	2026-03-08 20:15:30.548378	2026-03-08 20:45:52.583358
219	2	309	1	1	2026-03-08 20:34:35.644075	2026-03-08 21:02:09.953486	1	\N	CERRADA	2026-03-08 20:34:35.644583	2026-03-08 21:02:09.979658
220	4	311	1	1	2026-03-08 21:36:38.739626	2026-03-08 21:41:04.35342	1	\N	CERRADA	2026-03-08 21:36:38.740647	2026-03-08 21:41:04.366492
221	3	312	1	1	2026-03-08 21:43:10.421754	2026-03-08 21:44:13.276632	1	\N	CERRADA	2026-03-08 21:43:10.421754	2026-03-08 21:44:13.287391
224	1	315	1	1	2026-03-08 21:54:54.957565	2026-03-08 21:56:18.689845	1	\N	CERRADA	2026-03-08 21:54:54.957565	2026-03-08 21:56:18.703226
223	6	314	1	1	2026-03-08 21:52:59.2192	2026-03-08 22:06:26.559551	1	\N	CERRADA	2026-03-08 21:52:59.219777	2026-03-08 22:06:26.569573
226	8	317	1	1	2026-03-08 22:08:51.18329	2026-03-08 22:11:54.342002	1	\N	CERRADA	2026-03-08 22:08:51.184309	2026-03-08 22:11:54.343159
213	9	302	1	1	2026-03-08 19:18:20.952957	2026-03-08 22:15:16.319246	1	\N	CERRADA	2026-03-08 19:18:20.952957	2026-03-08 22:15:16.328349
225	5	316	1	1	2026-03-08 22:07:04.175529	2026-03-08 22:23:14.632953	1	\N	CERRADA	2026-03-08 22:07:04.175529	2026-03-08 22:23:14.642308
227	8	318	1	1	2026-03-08 22:12:58.33743	2026-03-08 22:25:01.054945	1	\N	CERRADA	2026-03-08 22:12:58.33743	2026-03-08 22:25:01.0666
217	7	306	1	1	2026-03-08 20:10:34.526737	2026-03-08 22:31:04.955065	1	\N	CERRADA	2026-03-08 20:10:34.529379	2026-03-08 22:31:04.96028
228	6	319	1	1	2026-03-08 22:32:54.642316	2026-03-08 22:34:05.733432	1	\N	CERRADA	2026-03-08 22:32:54.642316	2026-03-08 22:34:05.747002
222	2	313	1	1	2026-03-08 21:46:05.523105	2026-03-08 22:34:29.757104	1	\N	CERRADA	2026-03-08 21:46:05.523105	2026-03-08 22:34:29.76928
229	1	320	1	1	2026-03-08 22:41:07.867848	2026-03-08 22:41:54.401913	1	\N	CERRADA	2026-03-08 22:41:07.867848	2026-03-08 22:41:54.410543
230	5	321	1	1	2026-03-08 23:00:45.457926	2026-03-08 23:22:12.935715	1	\N	CERRADA	2026-03-08 23:00:45.457926	2026-03-08 23:22:12.946893
232	6	323	1	1	2026-03-09 20:33:27.688388	2026-03-09 20:46:27.879027	1	\N	CERRADA	2026-03-09 20:33:27.688388	2026-03-09 20:46:27.897569
233	5	324	1	1	2026-03-09 20:34:37.36403	2026-03-09 21:01:50.915276	1	\N	CERRADA	2026-03-09 20:34:37.36403	2026-03-09 21:01:50.933483
234	1	325	1	1	2026-03-09 21:02:03.827723	2026-03-09 21:04:21.026212	1	\N	CERRADA	2026-03-09 21:02:03.827723	2026-03-09 21:04:21.026212
231	7	322	1	1	2026-03-09 20:32:51.619267	2026-03-09 21:14:51.407099	1	\N	CERRADA	2026-03-09 20:32:51.620795	2026-03-09 21:14:51.414182
235	7	326	1	1	2026-03-09 21:14:58.693578	2026-03-09 21:41:07.493384	1	\N	CERRADA	2026-03-09 21:14:58.693578	2026-03-09 21:41:07.495415
236	1	329	1	1	2026-03-09 22:42:19.843714	2026-03-09 22:55:24.141683	1	\N	CERRADA	2026-03-09 22:42:19.844723	2026-03-09 22:55:24.147301
\.


--
-- Data for Name: user_sessions; Type: TABLE DATA; Schema: public; Owner: morales_user
--

COPY public.user_sessions (id, user_id, refresh_token_hash, ip_address, user_agent, expires_at, is_valid, created_at) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: morales_user
--

COPY public.users (id, username, email, password_hash, full_name, role_id, avatar_url, is_active, must_change_password, last_login, failed_login_attempts, locked_until, created_at, updated_at) FROM stdin;
6	prueba01	p@as.com	$2a$12$SB04JpBYpd5n2RuvUn1mQOBkljPcp6fEYwA0utWwnq6/us9E7JMse	Mesero 1	6	\N	t	f	2026-02-16 22:54:36.607444	0	\N	2026-02-15 21:39:19.883546	2026-02-16 22:54:36.608446
1	admin	admin@sistema.com	$2a$12$5VuErHRPVPoKO5ubPUGmfeIBmRnZvkAvuDYlu3q8ViJz4pqwyzbH2	Administrador	1	\N	t	f	2026-03-11 18:04:35.362643	0	\N	2026-01-27 11:29:59.946047	2026-03-11 18:04:35.364749
11	COCINA	COCINA@COCINA.COM	$2a$12$g2k1l7KjO64tOk2zNPJ6QeUaPWJOrLEMm7c9FKsjhEsIFDOdZAh9a	COCINA	7	\N	t	f	\N	0	\N	2026-03-11 18:23:39.339455	2026-03-11 18:23:39.339455
4	emy01	e@hot.com	$2a$12$uGoxPvvYjLWN7VNTd8VemOTvBxPYDQrHctbBFpV5w7aJhcSe1ayzu	emily morales	4	\N	t	f	2026-01-28 19:04:18.904092	0	\N	2026-01-28 18:54:42.100673	2026-01-28 19:04:18.90511
2	luis01	arleymorales96@gmail.com	$2a$12$hVFMh5qjDzEYWkwlAO5I5e6QvJPBJGd4zrofcJq05YWmqPz1U/g16	luis morales	2	\N	t	f	2026-02-16 12:57:17.964168	0	\N	2026-01-28 18:53:14.301254	2026-02-16 12:57:17.965181
10	mesero01	mes@carbonycafe.com	$2a$12$RXhCPeZ2fgbuVjcCuqiE4eG9znqA.APnbAOXWRgcU9n5XqiNLoBR.	Mesero 2	6	\N	t	f	2026-03-04 20:02:58.926086	0	\N	2026-02-18 17:23:18.705601	2026-03-04 20:02:58.932106
9	Administradora	tati.y.a@hotmail.com	$2a$12$oR6RT2smd1aFCFOsEBESDO.CTLMqS5WXnhvUKmhb7JvrrW8FOZcAW	Tatiana Agudelo	4	\N	t	f	2026-02-28 17:14:58.598838	0	\N	2026-02-16 12:58:35.832489	2026-02-28 17:14:58.615022
\.


--
-- Name: audit_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: morales_user
--

SELECT pg_catalog.setval('public.audit_logs_id_seq', 1, false);


--
-- Name: categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: morales_user
--

SELECT pg_catalog.setval('public.categories_id_seq', 25, true);


--
-- Name: company_config_id_seq; Type: SEQUENCE SET; Schema: public; Owner: morales_user
--

SELECT pg_catalog.setval('public.company_config_id_seq', 1, true);


--
-- Name: customers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: morales_user
--

SELECT pg_catalog.setval('public.customers_id_seq', 8, true);


--
-- Name: inventory_id_seq; Type: SEQUENCE SET; Schema: public; Owner: morales_user
--

SELECT pg_catalog.setval('public.inventory_id_seq', 87, true);


--
-- Name: inventory_movements_id_seq; Type: SEQUENCE SET; Schema: public; Owner: morales_user
--

SELECT pg_catalog.setval('public.inventory_movements_id_seq', 1257, true);


--
-- Name: invoice_details_id_seq; Type: SEQUENCE SET; Schema: public; Owner: morales_user
--

SELECT pg_catalog.setval('public.invoice_details_id_seq', 968, true);


--
-- Name: invoices_id_seq; Type: SEQUENCE SET; Schema: public; Owner: morales_user
--

SELECT pg_catalog.setval('public.invoices_id_seq', 331, true);


--
-- Name: kitchen_orders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: morales_user
--

SELECT pg_catalog.setval('public.kitchen_orders_id_seq', 638, true);


--
-- Name: notifications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: morales_user
--

SELECT pg_catalog.setval('public.notifications_id_seq', 174, true);


--
-- Name: payments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: morales_user
--

SELECT pg_catalog.setval('public.payments_id_seq', 1, false);


--
-- Name: products_id_seq; Type: SEQUENCE SET; Schema: public; Owner: morales_user
--

SELECT pg_catalog.setval('public.products_id_seq', 87, true);


--
-- Name: promotions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: morales_user
--

SELECT pg_catalog.setval('public.promotions_id_seq', 1, true);


--
-- Name: restaurant_tables_id_seq; Type: SEQUENCE SET; Schema: public; Owner: morales_user
--

SELECT pg_catalog.setval('public.restaurant_tables_id_seq', 10, true);


--
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: morales_user
--

SELECT pg_catalog.setval('public.roles_id_seq', 7, true);


--
-- Name: suppliers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: morales_user
--

SELECT pg_catalog.setval('public.suppliers_id_seq', 1, false);


--
-- Name: table_sessions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: morales_user
--

SELECT pg_catalog.setval('public.table_sessions_id_seq', 236, true);


--
-- Name: user_sessions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: morales_user
--

SELECT pg_catalog.setval('public.user_sessions_id_seq', 1, false);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: morales_user
--

SELECT pg_catalog.setval('public.users_id_seq', 11, true);


--
-- Name: audit_logs audit_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: morales_user
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT audit_logs_pkey PRIMARY KEY (id);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: morales_user
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: company_config company_config_pkey; Type: CONSTRAINT; Schema: public; Owner: morales_user
--

ALTER TABLE ONLY public.company_config
    ADD CONSTRAINT company_config_pkey PRIMARY KEY (id);


--
-- Name: customers customers_document_type_document_number_key; Type: CONSTRAINT; Schema: public; Owner: morales_user
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_document_type_document_number_key UNIQUE (document_type, document_number);


--
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: public; Owner: morales_user
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (id);


--
-- Name: flyway_schema_history flyway_schema_history_pk; Type: CONSTRAINT; Schema: public; Owner: morales_user
--

ALTER TABLE ONLY public.flyway_schema_history
    ADD CONSTRAINT flyway_schema_history_pk PRIMARY KEY (installed_rank);


--
-- Name: inventory_movements inventory_movements_pkey; Type: CONSTRAINT; Schema: public; Owner: morales_user
--

ALTER TABLE ONLY public.inventory_movements
    ADD CONSTRAINT inventory_movements_pkey PRIMARY KEY (id);


--
-- Name: inventory inventory_pkey; Type: CONSTRAINT; Schema: public; Owner: morales_user
--

ALTER TABLE ONLY public.inventory
    ADD CONSTRAINT inventory_pkey PRIMARY KEY (id);


--
-- Name: inventory inventory_product_id_key; Type: CONSTRAINT; Schema: public; Owner: morales_user
--

ALTER TABLE ONLY public.inventory
    ADD CONSTRAINT inventory_product_id_key UNIQUE (product_id);


--
-- Name: invoice_details invoice_details_pkey; Type: CONSTRAINT; Schema: public; Owner: morales_user
--

ALTER TABLE ONLY public.invoice_details
    ADD CONSTRAINT invoice_details_pkey PRIMARY KEY (id);


--
-- Name: invoices invoices_invoice_number_key; Type: CONSTRAINT; Schema: public; Owner: morales_user
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_invoice_number_key UNIQUE (invoice_number);


--
-- Name: invoices invoices_pkey; Type: CONSTRAINT; Schema: public; Owner: morales_user
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_pkey PRIMARY KEY (id);


--
-- Name: kitchen_orders kitchen_orders_invoice_detail_id_key; Type: CONSTRAINT; Schema: public; Owner: morales_user
--

ALTER TABLE ONLY public.kitchen_orders
    ADD CONSTRAINT kitchen_orders_invoice_detail_id_key UNIQUE (invoice_detail_id);


--
-- Name: kitchen_orders kitchen_orders_pkey; Type: CONSTRAINT; Schema: public; Owner: morales_user
--

ALTER TABLE ONLY public.kitchen_orders
    ADD CONSTRAINT kitchen_orders_pkey PRIMARY KEY (id);


--
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: morales_user
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- Name: payments payments_pkey; Type: CONSTRAINT; Schema: public; Owner: morales_user
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (id);


--
-- Name: products products_code_key; Type: CONSTRAINT; Schema: public; Owner: morales_user
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_code_key UNIQUE (code);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: morales_user
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- Name: promotions promotions_pkey; Type: CONSTRAINT; Schema: public; Owner: morales_user
--

ALTER TABLE ONLY public.promotions
    ADD CONSTRAINT promotions_pkey PRIMARY KEY (id);


--
-- Name: restaurant_tables restaurant_tables_pkey; Type: CONSTRAINT; Schema: public; Owner: morales_user
--

ALTER TABLE ONLY public.restaurant_tables
    ADD CONSTRAINT restaurant_tables_pkey PRIMARY KEY (id);


--
-- Name: restaurant_tables restaurant_tables_table_number_key; Type: CONSTRAINT; Schema: public; Owner: morales_user
--

ALTER TABLE ONLY public.restaurant_tables
    ADD CONSTRAINT restaurant_tables_table_number_key UNIQUE (table_number);


--
-- Name: roles roles_name_key; Type: CONSTRAINT; Schema: public; Owner: morales_user
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_name_key UNIQUE (name);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: morales_user
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: suppliers suppliers_pkey; Type: CONSTRAINT; Schema: public; Owner: morales_user
--

ALTER TABLE ONLY public.suppliers
    ADD CONSTRAINT suppliers_pkey PRIMARY KEY (id);


--
-- Name: table_sessions table_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: morales_user
--

ALTER TABLE ONLY public.table_sessions
    ADD CONSTRAINT table_sessions_pkey PRIMARY KEY (id);


--
-- Name: user_sessions user_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: morales_user
--

ALTER TABLE ONLY public.user_sessions
    ADD CONSTRAINT user_sessions_pkey PRIMARY KEY (id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: morales_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: morales_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: morales_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: flyway_schema_history_s_idx; Type: INDEX; Schema: public; Owner: morales_user
--

CREATE INDEX flyway_schema_history_s_idx ON public.flyway_schema_history USING btree (success);


--
-- Name: idx_audit_date; Type: INDEX; Schema: public; Owner: morales_user
--

CREATE INDEX idx_audit_date ON public.audit_logs USING btree (created_at);


--
-- Name: idx_audit_entity; Type: INDEX; Schema: public; Owner: morales_user
--

CREATE INDEX idx_audit_entity ON public.audit_logs USING btree (entity_type, entity_id);


--
-- Name: idx_audit_user; Type: INDEX; Schema: public; Owner: morales_user
--

CREATE INDEX idx_audit_user ON public.audit_logs USING btree (user_id);


--
-- Name: idx_categories_active; Type: INDEX; Schema: public; Owner: morales_user
--

CREATE INDEX idx_categories_active ON public.categories USING btree (is_active);


--
-- Name: idx_categories_parent; Type: INDEX; Schema: public; Owner: morales_user
--

CREATE INDEX idx_categories_parent ON public.categories USING btree (parent_id);


--
-- Name: idx_categories_parent_active; Type: INDEX; Schema: public; Owner: morales_user
--

CREATE INDEX idx_categories_parent_active ON public.categories USING btree (parent_id, is_active) WHERE (parent_id IS NOT NULL);


--
-- Name: idx_customers_document; Type: INDEX; Schema: public; Owner: morales_user
--

CREATE INDEX idx_customers_document ON public.customers USING btree (document_type, document_number);


--
-- Name: idx_customers_name; Type: INDEX; Schema: public; Owner: morales_user
--

CREATE INDEX idx_customers_name ON public.customers USING btree (full_name);


--
-- Name: idx_inventory_low_stock; Type: INDEX; Schema: public; Owner: morales_user
--

CREATE INDEX idx_inventory_low_stock ON public.inventory USING btree (quantity, min_stock);


--
-- Name: idx_inventory_product; Type: INDEX; Schema: public; Owner: morales_user
--

CREATE INDEX idx_inventory_product ON public.inventory USING btree (product_id);


--
-- Name: idx_inventory_quantity_minstock; Type: INDEX; Schema: public; Owner: morales_user
--

CREATE INDEX idx_inventory_quantity_minstock ON public.inventory USING btree (quantity, min_stock);


--
-- Name: idx_invoice_details_invoice; Type: INDEX; Schema: public; Owner: morales_user
--

CREATE INDEX idx_invoice_details_invoice ON public.invoice_details USING btree (invoice_id);


--
-- Name: idx_invoice_details_invoice_id; Type: INDEX; Schema: public; Owner: morales_user
--

CREATE INDEX idx_invoice_details_invoice_id ON public.invoice_details USING btree (invoice_id);


--
-- Name: idx_invoice_details_kitchen_status; Type: INDEX; Schema: public; Owner: morales_user
--

CREATE INDEX idx_invoice_details_kitchen_status ON public.invoice_details USING btree (kitchen_status);


--
-- Name: idx_invoice_details_product; Type: INDEX; Schema: public; Owner: morales_user
--

CREATE INDEX idx_invoice_details_product ON public.invoice_details USING btree (product_id);


--
-- Name: idx_invoice_details_product_id; Type: INDEX; Schema: public; Owner: morales_user
--

CREATE INDEX idx_invoice_details_product_id ON public.invoice_details USING btree (product_id);


--
-- Name: idx_invoices_created_status; Type: INDEX; Schema: public; Owner: morales_user
--

CREATE INDEX idx_invoices_created_status ON public.invoices USING btree (created_at, status);


--
-- Name: idx_invoices_customer; Type: INDEX; Schema: public; Owner: morales_user
--

CREATE INDEX idx_invoices_customer ON public.invoices USING btree (customer_id);


--
-- Name: idx_invoices_customer_created; Type: INDEX; Schema: public; Owner: morales_user
--

CREATE INDEX idx_invoices_customer_created ON public.invoices USING btree (customer_id, created_at DESC) WHERE (customer_id IS NOT NULL);


--
-- Name: idx_invoices_customer_id; Type: INDEX; Schema: public; Owner: morales_user
--

CREATE INDEX idx_invoices_customer_id ON public.invoices USING btree (customer_id);


--
-- Name: idx_invoices_date; Type: INDEX; Schema: public; Owner: morales_user
--

CREATE INDEX idx_invoices_date ON public.invoices USING btree (created_at);


--
-- Name: idx_invoices_number; Type: INDEX; Schema: public; Owner: morales_user
--

CREATE INDEX idx_invoices_number ON public.invoices USING btree (invoice_number);


--
-- Name: idx_invoices_status; Type: INDEX; Schema: public; Owner: morales_user
--

CREATE INDEX idx_invoices_status ON public.invoices USING btree (status);


--
-- Name: idx_invoices_status_created; Type: INDEX; Schema: public; Owner: morales_user
--

CREATE INDEX idx_invoices_status_created ON public.invoices USING btree (status, created_at DESC);


--
-- Name: idx_invoices_user; Type: INDEX; Schema: public; Owner: morales_user
--

CREATE INDEX idx_invoices_user ON public.invoices USING btree (user_id);


--
-- Name: idx_invoices_user_created; Type: INDEX; Schema: public; Owner: morales_user
--

CREATE INDEX idx_invoices_user_created ON public.invoices USING btree (user_id, created_at DESC);


--
-- Name: idx_is_active; Type: INDEX; Schema: public; Owner: morales_user
--

CREATE INDEX idx_is_active ON public.promotions USING btree (is_active);


--
-- Name: idx_kitchen_orders_status_ordertime; Type: INDEX; Schema: public; Owner: morales_user
--

CREATE INDEX idx_kitchen_orders_status_ordertime ON public.kitchen_orders USING btree (status, order_time);


--
-- Name: idx_kitchen_orders_status_time; Type: INDEX; Schema: public; Owner: morales_user
--

CREATE INDEX idx_kitchen_orders_status_time ON public.kitchen_orders USING btree (status, order_time);


--
-- Name: idx_kitchen_orders_table_seq; Type: INDEX; Schema: public; Owner: morales_user
--

CREATE INDEX idx_kitchen_orders_table_seq ON public.kitchen_orders USING btree (table_id, sequence_number);


--
-- Name: idx_kitchen_orders_table_sequence; Type: INDEX; Schema: public; Owner: morales_user
--

CREATE INDEX idx_kitchen_orders_table_sequence ON public.kitchen_orders USING btree (table_id, sequence_number);


--
-- Name: idx_kitchen_orders_table_status; Type: INDEX; Schema: public; Owner: morales_user
--

CREATE INDEX idx_kitchen_orders_table_status ON public.kitchen_orders USING btree (table_id, status);


--
-- Name: idx_kitchen_orders_urgent; Type: INDEX; Schema: public; Owner: morales_user
--

CREATE INDEX idx_kitchen_orders_urgent ON public.kitchen_orders USING btree (is_urgent, order_time);


--
-- Name: idx_notifications_created_at; Type: INDEX; Schema: public; Owner: morales_user
--

CREATE INDEX idx_notifications_created_at ON public.notifications USING btree (created_at);


--
-- Name: idx_notifications_is_read; Type: INDEX; Schema: public; Owner: morales_user
--

CREATE INDEX idx_notifications_is_read ON public.notifications USING btree (is_read);


--
-- Name: idx_notifications_read_created; Type: INDEX; Schema: public; Owner: morales_user
--

CREATE INDEX idx_notifications_read_created ON public.notifications USING btree (is_read, created_at DESC);


--
-- Name: idx_notifications_reference; Type: INDEX; Schema: public; Owner: morales_user
--

CREATE INDEX idx_notifications_reference ON public.notifications USING btree (reference_type, reference_id);


--
-- Name: idx_notifications_type; Type: INDEX; Schema: public; Owner: morales_user
--

CREATE INDEX idx_notifications_type ON public.notifications USING btree (type);


--
-- Name: idx_priority; Type: INDEX; Schema: public; Owner: morales_user
--

CREATE INDEX idx_priority ON public.promotions USING btree (priority);


--
-- Name: idx_products_active; Type: INDEX; Schema: public; Owner: morales_user
--

CREATE INDEX idx_products_active ON public.products USING btree (is_active);


--
-- Name: idx_products_barcode; Type: INDEX; Schema: public; Owner: morales_user
--

CREATE INDEX idx_products_barcode ON public.products USING btree (barcode);


--
-- Name: idx_products_category; Type: INDEX; Schema: public; Owner: morales_user
--

CREATE INDEX idx_products_category ON public.products USING btree (category_id);


--
-- Name: idx_products_category_active; Type: INDEX; Schema: public; Owner: morales_user
--

CREATE INDEX idx_products_category_active ON public.products USING btree (category_id, is_active);


--
-- Name: idx_products_code; Type: INDEX; Schema: public; Owner: morales_user
--

CREATE INDEX idx_products_code ON public.products USING btree (code);


--
-- Name: idx_products_name; Type: INDEX; Schema: public; Owner: morales_user
--

CREATE INDEX idx_products_name ON public.products USING btree (name);


--
-- Name: idx_restaurant_tables_active; Type: INDEX; Schema: public; Owner: morales_user
--

CREATE INDEX idx_restaurant_tables_active ON public.restaurant_tables USING btree (is_active);


--
-- Name: idx_restaurant_tables_status; Type: INDEX; Schema: public; Owner: morales_user
--

CREATE INDEX idx_restaurant_tables_status ON public.restaurant_tables USING btree (status);


--
-- Name: idx_restaurant_tables_zone; Type: INDEX; Schema: public; Owner: morales_user
--

CREATE INDEX idx_restaurant_tables_zone ON public.restaurant_tables USING btree (zone);


--
-- Name: idx_schedule_type; Type: INDEX; Schema: public; Owner: morales_user
--

CREATE INDEX idx_schedule_type ON public.promotions USING btree (schedule_type);


--
-- Name: idx_table_sessions_invoice; Type: INDEX; Schema: public; Owner: morales_user
--

CREATE INDEX idx_table_sessions_invoice ON public.table_sessions USING btree (invoice_id);


--
-- Name: idx_table_sessions_opened_at; Type: INDEX; Schema: public; Owner: morales_user
--

CREATE INDEX idx_table_sessions_opened_at ON public.table_sessions USING btree (opened_at);


--
-- Name: idx_table_sessions_status; Type: INDEX; Schema: public; Owner: morales_user
--

CREATE INDEX idx_table_sessions_status ON public.table_sessions USING btree (status);


--
-- Name: idx_table_sessions_table; Type: INDEX; Schema: public; Owner: morales_user
--

CREATE INDEX idx_table_sessions_table ON public.table_sessions USING btree (table_id);


--
-- Name: idx_table_sessions_table_status; Type: INDEX; Schema: public; Owner: morales_user
--

CREATE INDEX idx_table_sessions_table_status ON public.table_sessions USING btree (table_id, status);


--
-- Name: idx_users_active; Type: INDEX; Schema: public; Owner: morales_user
--

CREATE INDEX idx_users_active ON public.users USING btree (is_active);


--
-- Name: idx_users_email; Type: INDEX; Schema: public; Owner: morales_user
--

CREATE INDEX idx_users_email ON public.users USING btree (email);


--
-- Name: idx_users_username; Type: INDEX; Schema: public; Owner: morales_user
--

CREATE INDEX idx_users_username ON public.users USING btree (username);


--
-- Name: audit_logs audit_logs_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: morales_user
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT audit_logs_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: categories categories_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: morales_user
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.categories(id);


--
-- Name: kitchen_orders fk_kitchen_orders_detail; Type: FK CONSTRAINT; Schema: public; Owner: morales_user
--

ALTER TABLE ONLY public.kitchen_orders
    ADD CONSTRAINT fk_kitchen_orders_detail FOREIGN KEY (invoice_detail_id) REFERENCES public.invoice_details(id) ON DELETE CASCADE;


--
-- Name: kitchen_orders fk_kitchen_orders_table; Type: FK CONSTRAINT; Schema: public; Owner: morales_user
--

ALTER TABLE ONLY public.kitchen_orders
    ADD CONSTRAINT fk_kitchen_orders_table FOREIGN KEY (table_id) REFERENCES public.restaurant_tables(id);


--
-- Name: inventory_movements inventory_movements_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: morales_user
--

ALTER TABLE ONLY public.inventory_movements
    ADD CONSTRAINT inventory_movements_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: inventory_movements inventory_movements_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: morales_user
--

ALTER TABLE ONLY public.inventory_movements
    ADD CONSTRAINT inventory_movements_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: inventory inventory_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: morales_user
--

ALTER TABLE ONLY public.inventory
    ADD CONSTRAINT inventory_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE;


--
-- Name: invoice_details invoice_details_invoice_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: morales_user
--

ALTER TABLE ONLY public.invoice_details
    ADD CONSTRAINT invoice_details_invoice_id_fkey FOREIGN KEY (invoice_id) REFERENCES public.invoices(id) ON DELETE CASCADE;


--
-- Name: invoice_details invoice_details_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: morales_user
--

ALTER TABLE ONLY public.invoice_details
    ADD CONSTRAINT invoice_details_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: invoices invoices_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: morales_user
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(id);


--
-- Name: invoices invoices_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: morales_user
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: invoices invoices_voided_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: morales_user
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_voided_by_fkey FOREIGN KEY (voided_by) REFERENCES public.users(id);


--
-- Name: notifications notifications_read_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: morales_user
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_read_by_fkey FOREIGN KEY (read_by) REFERENCES public.users(id);


--
-- Name: payments payments_invoice_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: morales_user
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_invoice_id_fkey FOREIGN KEY (invoice_id) REFERENCES public.invoices(id) ON DELETE CASCADE;


--
-- Name: products products_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: morales_user
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.categories(id);


--
-- Name: products products_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: morales_user
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: table_sessions table_sessions_closed_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: morales_user
--

ALTER TABLE ONLY public.table_sessions
    ADD CONSTRAINT table_sessions_closed_by_fkey FOREIGN KEY (closed_by) REFERENCES public.users(id);


--
-- Name: table_sessions table_sessions_invoice_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: morales_user
--

ALTER TABLE ONLY public.table_sessions
    ADD CONSTRAINT table_sessions_invoice_id_fkey FOREIGN KEY (invoice_id) REFERENCES public.invoices(id);


--
-- Name: table_sessions table_sessions_opened_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: morales_user
--

ALTER TABLE ONLY public.table_sessions
    ADD CONSTRAINT table_sessions_opened_by_fkey FOREIGN KEY (opened_by) REFERENCES public.users(id);


--
-- Name: table_sessions table_sessions_table_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: morales_user
--

ALTER TABLE ONLY public.table_sessions
    ADD CONSTRAINT table_sessions_table_id_fkey FOREIGN KEY (table_id) REFERENCES public.restaurant_tables(id);


--
-- Name: user_sessions user_sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: morales_user
--

ALTER TABLE ONLY public.user_sessions
    ADD CONSTRAINT user_sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: users users_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: morales_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO morales_user;


--
-- PostgreSQL database dump complete
--

\unrestrict D0gvNniZ9HC3Cya8GMDUojJCbuKkdIefidliE8eDif4YvWZLMKTBpiGGQwDK124

