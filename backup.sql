--
-- PostgreSQL database dump
--

-- Dumped from database version 14.12 (Homebrew)
-- Dumped by pg_dump version 14.12 (Homebrew)

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
-- Name: generate_serial_number(); Type: FUNCTION; Schema: public; Owner: abinet
--

CREATE FUNCTION public.generate_serial_number() RETURNS trigger
    LANGUAGE plpgsql
    AS $_$
DECLARE
    last_serial_number INT;
    next_number INT;
BEGIN
    -- Find the last serial number for the given participant_type_id
    SELECT MAX(CAST(SUBSTRING(serial_number FROM 9) AS INT))
    INTO last_serial_number
    FROM participants
    WHERE participant_type_id = NEW.participant_type_id
      AND SUBSTRING(serial_number FROM 9) ~ '^[0-9]+$';

    -- Determine the next number
    next_number := COALESCE(last_serial_number, 0) + 1;

    -- Generate the new serial number
    NEW.serial_number := 'ARM26' || NEW.participant_type_id || LPAD(next_number::TEXT, 4, '0');

    RETURN NEW;
END;
$_$;


ALTER FUNCTION public.generate_serial_number() OWNER TO abinet;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: account_invitations; Type: TABLE; Schema: public; Owner: abinet
--

CREATE TABLE public.account_invitations (
    id bigint NOT NULL,
    account_id bigint NOT NULL,
    invited_by_id bigint,
    token character varying NOT NULL,
    name character varying NOT NULL,
    email character varying NOT NULL,
    roles jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.account_invitations OWNER TO abinet;

--
-- Name: account_invitations_id_seq; Type: SEQUENCE; Schema: public; Owner: abinet
--

CREATE SEQUENCE public.account_invitations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.account_invitations_id_seq OWNER TO abinet;

--
-- Name: account_invitations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: abinet
--

ALTER SEQUENCE public.account_invitations_id_seq OWNED BY public.account_invitations.id;


--
-- Name: account_users; Type: TABLE; Schema: public; Owner: abinet
--

CREATE TABLE public.account_users (
    id bigint NOT NULL,
    account_id bigint,
    user_id bigint,
    roles jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.account_users OWNER TO abinet;

--
-- Name: account_users_id_seq; Type: SEQUENCE; Schema: public; Owner: abinet
--

CREATE SEQUENCE public.account_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.account_users_id_seq OWNER TO abinet;

--
-- Name: account_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: abinet
--

ALTER SEQUENCE public.account_users_id_seq OWNED BY public.account_users.id;


--
-- Name: accounts; Type: TABLE; Schema: public; Owner: abinet
--

CREATE TABLE public.accounts (
    id bigint NOT NULL,
    name character varying NOT NULL,
    owner_id bigint,
    personal boolean DEFAULT false,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    extra_billing_info text,
    domain character varying,
    subdomain character varying,
    billing_email character varying,
    account_users_count integer DEFAULT 0
);


ALTER TABLE public.accounts OWNER TO abinet;

--
-- Name: accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: abinet
--

CREATE SEQUENCE public.accounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.accounts_id_seq OWNER TO abinet;

--
-- Name: accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: abinet
--

ALTER SEQUENCE public.accounts_id_seq OWNED BY public.accounts.id;


--
-- Name: action_text_embeds; Type: TABLE; Schema: public; Owner: abinet
--

CREATE TABLE public.action_text_embeds (
    id bigint NOT NULL,
    url character varying,
    fields jsonb,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.action_text_embeds OWNER TO abinet;

--
-- Name: action_text_embeds_id_seq; Type: SEQUENCE; Schema: public; Owner: abinet
--

CREATE SEQUENCE public.action_text_embeds_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.action_text_embeds_id_seq OWNER TO abinet;

--
-- Name: action_text_embeds_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: abinet
--

ALTER SEQUENCE public.action_text_embeds_id_seq OWNED BY public.action_text_embeds.id;


--
-- Name: action_text_rich_texts; Type: TABLE; Schema: public; Owner: abinet
--

CREATE TABLE public.action_text_rich_texts (
    id bigint NOT NULL,
    name character varying NOT NULL,
    body text,
    record_type character varying NOT NULL,
    record_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.action_text_rich_texts OWNER TO abinet;

--
-- Name: action_text_rich_texts_id_seq; Type: SEQUENCE; Schema: public; Owner: abinet
--

CREATE SEQUENCE public.action_text_rich_texts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.action_text_rich_texts_id_seq OWNER TO abinet;

--
-- Name: action_text_rich_texts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: abinet
--

ALTER SEQUENCE public.action_text_rich_texts_id_seq OWNED BY public.action_text_rich_texts.id;


--
-- Name: active_storage_attachments; Type: TABLE; Schema: public; Owner: abinet
--

CREATE TABLE public.active_storage_attachments (
    id bigint NOT NULL,
    name character varying NOT NULL,
    record_type character varying NOT NULL,
    record_id bigint NOT NULL,
    blob_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL
);


ALTER TABLE public.active_storage_attachments OWNER TO abinet;

--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE; Schema: public; Owner: abinet
--

CREATE SEQUENCE public.active_storage_attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.active_storage_attachments_id_seq OWNER TO abinet;

--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: abinet
--

ALTER SEQUENCE public.active_storage_attachments_id_seq OWNED BY public.active_storage_attachments.id;


--
-- Name: active_storage_blobs; Type: TABLE; Schema: public; Owner: abinet
--

CREATE TABLE public.active_storage_blobs (
    id bigint NOT NULL,
    key character varying NOT NULL,
    filename character varying NOT NULL,
    content_type character varying,
    metadata text,
    byte_size bigint NOT NULL,
    checksum character varying,
    created_at timestamp without time zone NOT NULL,
    service_name character varying NOT NULL
);


ALTER TABLE public.active_storage_blobs OWNER TO abinet;

--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE; Schema: public; Owner: abinet
--

CREATE SEQUENCE public.active_storage_blobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.active_storage_blobs_id_seq OWNER TO abinet;

--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: abinet
--

ALTER SEQUENCE public.active_storage_blobs_id_seq OWNED BY public.active_storage_blobs.id;


--
-- Name: active_storage_variant_records; Type: TABLE; Schema: public; Owner: abinet
--

CREATE TABLE public.active_storage_variant_records (
    id bigint NOT NULL,
    blob_id bigint NOT NULL,
    variation_digest character varying NOT NULL
);


ALTER TABLE public.active_storage_variant_records OWNER TO abinet;

--
-- Name: active_storage_variant_records_id_seq; Type: SEQUENCE; Schema: public; Owner: abinet
--

CREATE SEQUENCE public.active_storage_variant_records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.active_storage_variant_records_id_seq OWNER TO abinet;

--
-- Name: active_storage_variant_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: abinet
--

ALTER SEQUENCE public.active_storage_variant_records_id_seq OWNED BY public.active_storage_variant_records.id;


--
-- Name: addresses; Type: TABLE; Schema: public; Owner: abinet
--

CREATE TABLE public.addresses (
    id bigint NOT NULL,
    addressable_type character varying NOT NULL,
    addressable_id bigint NOT NULL,
    address_type integer,
    line1 character varying,
    line2 character varying,
    city character varying,
    state character varying,
    country character varying,
    postal_code character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.addresses OWNER TO abinet;

--
-- Name: addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: abinet
--

CREATE SEQUENCE public.addresses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.addresses_id_seq OWNER TO abinet;

--
-- Name: addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: abinet
--

ALTER SEQUENCE public.addresses_id_seq OWNED BY public.addresses.id;


--
-- Name: announcements; Type: TABLE; Schema: public; Owner: abinet
--

CREATE TABLE public.announcements (
    id bigint NOT NULL,
    kind character varying,
    title character varying,
    published_at timestamp without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.announcements OWNER TO abinet;

--
-- Name: announcements_id_seq; Type: SEQUENCE; Schema: public; Owner: abinet
--

CREATE SEQUENCE public.announcements_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.announcements_id_seq OWNER TO abinet;

--
-- Name: announcements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: abinet
--

ALTER SEQUENCE public.announcements_id_seq OWNED BY public.announcements.id;


--
-- Name: api_tokens; Type: TABLE; Schema: public; Owner: abinet
--

CREATE TABLE public.api_tokens (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    token character varying,
    name character varying,
    metadata jsonb,
    transient boolean DEFAULT false,
    last_used_at timestamp without time zone,
    expires_at timestamp without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.api_tokens OWNER TO abinet;

--
-- Name: api_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: abinet
--

CREATE SEQUENCE public.api_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.api_tokens_id_seq OWNER TO abinet;

--
-- Name: api_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: abinet
--

ALTER SEQUENCE public.api_tokens_id_seq OWNED BY public.api_tokens.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: abinet
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.ar_internal_metadata OWNER TO abinet;

--
-- Name: attendees; Type: TABLE; Schema: public; Owner: abinet
--

CREATE TABLE public.attendees (
    id bigint NOT NULL,
    full_name character varying,
    address character varying,
    org character varying,
    days_to_attend character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.attendees OWNER TO abinet;

--
-- Name: attendees_id_seq; Type: SEQUENCE; Schema: public; Owner: abinet
--

CREATE SEQUENCE public.attendees_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.attendees_id_seq OWNER TO abinet;

--
-- Name: attendees_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: abinet
--

ALTER SEQUENCE public.attendees_id_seq OWNED BY public.attendees.id;


--
-- Name: connected_accounts; Type: TABLE; Schema: public; Owner: abinet
--

CREATE TABLE public.connected_accounts (
    id bigint NOT NULL,
    owner_id bigint,
    provider character varying,
    uid character varying,
    refresh_token character varying,
    expires_at timestamp without time zone,
    auth text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    access_token character varying,
    access_token_secret character varying,
    owner_type character varying
);


ALTER TABLE public.connected_accounts OWNER TO abinet;

--
-- Name: connected_accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: abinet
--

CREATE SEQUENCE public.connected_accounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.connected_accounts_id_seq OWNER TO abinet;

--
-- Name: connected_accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: abinet
--

ALTER SEQUENCE public.connected_accounts_id_seq OWNED BY public.connected_accounts.id;


--
-- Name: email_logs; Type: TABLE; Schema: public; Owner: abinet
--

CREATE TABLE public.email_logs (
    id bigint NOT NULL,
    participant_id integer,
    status character varying,
    sent_at timestamp(6) without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.email_logs OWNER TO abinet;

--
-- Name: email_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: abinet
--

CREATE SEQUENCE public.email_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.email_logs_id_seq OWNER TO abinet;

--
-- Name: email_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: abinet
--

ALTER SEQUENCE public.email_logs_id_seq OWNED BY public.email_logs.id;


--
-- Name: field_visit_activities; Type: TABLE; Schema: public; Owner: abinet
--

CREATE TABLE public.field_visit_activities (
    id bigint NOT NULL,
    name character varying,
    description text,
    field_visit_area_id bigint NOT NULL,
    scheduled_date date,
    duration double precision,
    max_participants integer,
    notes text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.field_visit_activities OWNER TO abinet;

--
-- Name: field_visit_activities_id_seq; Type: SEQUENCE; Schema: public; Owner: abinet
--

CREATE SEQUENCE public.field_visit_activities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.field_visit_activities_id_seq OWNER TO abinet;

--
-- Name: field_visit_activities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: abinet
--

ALTER SEQUENCE public.field_visit_activities_id_seq OWNED BY public.field_visit_activities.id;


--
-- Name: field_visit_areas; Type: TABLE; Schema: public; Owner: abinet
--

CREATE TABLE public.field_visit_areas (
    id bigint NOT NULL,
    name character varying,
    distance_from_arm_venue double precision,
    note character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.field_visit_areas OWNER TO abinet;

--
-- Name: field_visit_areas_id_seq; Type: SEQUENCE; Schema: public; Owner: abinet
--

CREATE SEQUENCE public.field_visit_areas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.field_visit_areas_id_seq OWNER TO abinet;

--
-- Name: field_visit_areas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: abinet
--

ALTER SEQUENCE public.field_visit_areas_id_seq OWNED BY public.field_visit_areas.id;


--
-- Name: groups; Type: TABLE; Schema: public; Owner: abinet
--

CREATE TABLE public.groups (
    id bigint NOT NULL,
    name character varying,
    description character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.groups OWNER TO abinet;

--
-- Name: groups_id_seq; Type: SEQUENCE; Schema: public; Owner: abinet
--

CREATE SEQUENCE public.groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.groups_id_seq OWNER TO abinet;

--
-- Name: groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: abinet
--

ALTER SEQUENCE public.groups_id_seq OWNED BY public.groups.id;


--
-- Name: hotels; Type: TABLE; Schema: public; Owner: abinet
--

CREATE TABLE public.hotels (
    id bigint NOT NULL,
    name character varying,
    location character varying,
    room_numbers integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.hotels OWNER TO abinet;

--
-- Name: hotels_id_seq; Type: SEQUENCE; Schema: public; Owner: abinet
--

CREATE SEQUENCE public.hotels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.hotels_id_seq OWNER TO abinet;

--
-- Name: hotels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: abinet
--

ALTER SEQUENCE public.hotels_id_seq OWNED BY public.hotels.id;


--
-- Name: inbound_webhooks; Type: TABLE; Schema: public; Owner: abinet
--

CREATE TABLE public.inbound_webhooks (
    id bigint NOT NULL,
    status integer DEFAULT 0 NOT NULL,
    body text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.inbound_webhooks OWNER TO abinet;

--
-- Name: inbound_webhooks_id_seq; Type: SEQUENCE; Schema: public; Owner: abinet
--

CREATE SEQUENCE public.inbound_webhooks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.inbound_webhooks_id_seq OWNER TO abinet;

--
-- Name: inbound_webhooks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: abinet
--

ALTER SEQUENCE public.inbound_webhooks_id_seq OWNED BY public.inbound_webhooks.id;


--
-- Name: noticed_events; Type: TABLE; Schema: public; Owner: abinet
--

CREATE TABLE public.noticed_events (
    id bigint NOT NULL,
    account_id bigint,
    type character varying,
    record_type character varying,
    record_id bigint,
    params jsonb,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    notifications_count integer
);


ALTER TABLE public.noticed_events OWNER TO abinet;

--
-- Name: noticed_events_id_seq; Type: SEQUENCE; Schema: public; Owner: abinet
--

CREATE SEQUENCE public.noticed_events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.noticed_events_id_seq OWNER TO abinet;

--
-- Name: noticed_events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: abinet
--

ALTER SEQUENCE public.noticed_events_id_seq OWNED BY public.noticed_events.id;


--
-- Name: noticed_notifications; Type: TABLE; Schema: public; Owner: abinet
--

CREATE TABLE public.noticed_notifications (
    id bigint NOT NULL,
    account_id bigint,
    type character varying,
    event_id bigint NOT NULL,
    recipient_type character varying NOT NULL,
    recipient_id bigint NOT NULL,
    read_at timestamp without time zone,
    seen_at timestamp without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.noticed_notifications OWNER TO abinet;

--
-- Name: noticed_notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: abinet
--

CREATE SEQUENCE public.noticed_notifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.noticed_notifications_id_seq OWNER TO abinet;

--
-- Name: noticed_notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: abinet
--

ALTER SEQUENCE public.noticed_notifications_id_seq OWNED BY public.noticed_notifications.id;


--
-- Name: notification_tokens; Type: TABLE; Schema: public; Owner: abinet
--

CREATE TABLE public.notification_tokens (
    id bigint NOT NULL,
    user_id bigint,
    token character varying NOT NULL,
    platform character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.notification_tokens OWNER TO abinet;

--
-- Name: notification_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: abinet
--

CREATE SEQUENCE public.notification_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.notification_tokens_id_seq OWNER TO abinet;

--
-- Name: notification_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: abinet
--

ALTER SEQUENCE public.notification_tokens_id_seq OWNED BY public.notification_tokens.id;


--
-- Name: notifications; Type: TABLE; Schema: public; Owner: abinet
--

CREATE TABLE public.notifications (
    id bigint NOT NULL,
    account_id bigint NOT NULL,
    recipient_type character varying NOT NULL,
    recipient_id bigint NOT NULL,
    type character varying,
    params jsonb,
    read_at timestamp without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    interacted_at timestamp without time zone
);


ALTER TABLE public.notifications OWNER TO abinet;

--
-- Name: notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: abinet
--

CREATE SEQUENCE public.notifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.notifications_id_seq OWNER TO abinet;

--
-- Name: notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: abinet
--

ALTER SEQUENCE public.notifications_id_seq OWNED BY public.notifications.id;


--
-- Name: organizations; Type: TABLE; Schema: public; Owner: abinet
--

CREATE TABLE public.organizations (
    id bigint NOT NULL,
    name character varying,
    location character varying,
    allowed_participant_number integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.organizations OWNER TO abinet;

--
-- Name: organizations_id_seq; Type: SEQUENCE; Schema: public; Owner: abinet
--

CREATE SEQUENCE public.organizations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.organizations_id_seq OWNER TO abinet;

--
-- Name: organizations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: abinet
--

ALTER SEQUENCE public.organizations_id_seq OWNED BY public.organizations.id;


--
-- Name: participant_types; Type: TABLE; Schema: public; Owner: abinet
--

CREATE TABLE public.participant_types (
    id bigint NOT NULL,
    type_name character varying,
    description character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.participant_types OWNER TO abinet;

--
-- Name: participant_types_id_seq; Type: SEQUENCE; Schema: public; Owner: abinet
--

CREATE SEQUENCE public.participant_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.participant_types_id_seq OWNER TO abinet;

--
-- Name: participant_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: abinet
--

ALTER SEQUENCE public.participant_types_id_seq OWNED BY public.participant_types.id;


--
-- Name: participants; Type: TABLE; Schema: public; Owner: abinet
--

CREATE TABLE public.participants (
    id bigint NOT NULL,
    name character varying,
    organization_id bigint,
    registration_date date,
    location character varying,
    "position" character varying,
    email character varying,
    telephone_number character varying,
    participant_type_id bigint NOT NULL,
    group_id bigint NOT NULL,
    emergency_contact_name character varying,
    emergency_contact_number character varying,
    side_event_id bigint NOT NULL,
    meal_options character varying,
    "resourceMaterial_take" boolean,
    accommodation_required boolean,
    notes text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    approved boolean,
    serial_number character varying,
    attended_day_0 boolean,
    attended_day_1 boolean,
    attended_day_2 boolean,
    attended_day_3 boolean,
    field_visit_activity_id integer,
    user_id integer,
    region character varying,
    orgname character varying,
    rollno character varying
);


ALTER TABLE public.participants OWNER TO abinet;

--
-- Name: participants_id_seq; Type: SEQUENCE; Schema: public; Owner: abinet
--

CREATE SEQUENCE public.participants_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.participants_id_seq OWNER TO abinet;

--
-- Name: participants_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: abinet
--

ALTER SEQUENCE public.participants_id_seq OWNED BY public.participants.id;


--
-- Name: pay_charges; Type: TABLE; Schema: public; Owner: abinet
--

CREATE TABLE public.pay_charges (
    id bigint NOT NULL,
    processor_id character varying NOT NULL,
    amount integer NOT NULL,
    amount_refunded integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    data jsonb,
    application_fee_amount integer,
    currency character varying,
    metadata jsonb,
    subscription_id integer,
    customer_id bigint,
    stripe_account character varying
);


ALTER TABLE public.pay_charges OWNER TO abinet;

--
-- Name: pay_charges_id_seq; Type: SEQUENCE; Schema: public; Owner: abinet
--

CREATE SEQUENCE public.pay_charges_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pay_charges_id_seq OWNER TO abinet;

--
-- Name: pay_charges_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: abinet
--

ALTER SEQUENCE public.pay_charges_id_seq OWNED BY public.pay_charges.id;


--
-- Name: pay_customers; Type: TABLE; Schema: public; Owner: abinet
--

CREATE TABLE public.pay_customers (
    id bigint NOT NULL,
    owner_type character varying,
    owner_id bigint,
    processor character varying,
    processor_id character varying,
    "default" boolean,
    data jsonb,
    deleted_at timestamp without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    stripe_account character varying
);


ALTER TABLE public.pay_customers OWNER TO abinet;

--
-- Name: pay_customers_id_seq; Type: SEQUENCE; Schema: public; Owner: abinet
--

CREATE SEQUENCE public.pay_customers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pay_customers_id_seq OWNER TO abinet;

--
-- Name: pay_customers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: abinet
--

ALTER SEQUENCE public.pay_customers_id_seq OWNED BY public.pay_customers.id;


--
-- Name: pay_merchants; Type: TABLE; Schema: public; Owner: abinet
--

CREATE TABLE public.pay_merchants (
    id bigint NOT NULL,
    owner_type character varying,
    owner_id bigint,
    processor character varying,
    processor_id character varying,
    "default" boolean,
    data jsonb,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.pay_merchants OWNER TO abinet;

--
-- Name: pay_merchants_id_seq; Type: SEQUENCE; Schema: public; Owner: abinet
--

CREATE SEQUENCE public.pay_merchants_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pay_merchants_id_seq OWNER TO abinet;

--
-- Name: pay_merchants_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: abinet
--

ALTER SEQUENCE public.pay_merchants_id_seq OWNED BY public.pay_merchants.id;


--
-- Name: pay_payment_methods; Type: TABLE; Schema: public; Owner: abinet
--

CREATE TABLE public.pay_payment_methods (
    id bigint NOT NULL,
    customer_id bigint,
    processor_id character varying,
    "default" boolean,
    type character varying,
    data jsonb,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    stripe_account character varying
);


ALTER TABLE public.pay_payment_methods OWNER TO abinet;

--
-- Name: pay_payment_methods_id_seq; Type: SEQUENCE; Schema: public; Owner: abinet
--

CREATE SEQUENCE public.pay_payment_methods_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pay_payment_methods_id_seq OWNER TO abinet;

--
-- Name: pay_payment_methods_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: abinet
--

ALTER SEQUENCE public.pay_payment_methods_id_seq OWNED BY public.pay_payment_methods.id;


--
-- Name: pay_subscriptions; Type: TABLE; Schema: public; Owner: abinet
--

CREATE TABLE public.pay_subscriptions (
    id integer NOT NULL,
    name character varying NOT NULL,
    processor_id character varying NOT NULL,
    processor_plan character varying NOT NULL,
    quantity integer DEFAULT 1 NOT NULL,
    trial_ends_at timestamp without time zone,
    ends_at timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    status character varying,
    data jsonb,
    application_fee_percent numeric(8,2),
    metadata jsonb,
    customer_id bigint,
    current_period_start timestamp(6) without time zone,
    current_period_end timestamp(6) without time zone,
    metered boolean,
    pause_behavior character varying,
    pause_starts_at timestamp(6) without time zone,
    pause_resumes_at timestamp(6) without time zone,
    payment_method_id character varying,
    stripe_account character varying
);


ALTER TABLE public.pay_subscriptions OWNER TO abinet;

--
-- Name: pay_subscriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: abinet
--

CREATE SEQUENCE public.pay_subscriptions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pay_subscriptions_id_seq OWNER TO abinet;

--
-- Name: pay_subscriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: abinet
--

ALTER SEQUENCE public.pay_subscriptions_id_seq OWNED BY public.pay_subscriptions.id;


--
-- Name: pay_webhooks; Type: TABLE; Schema: public; Owner: abinet
--

CREATE TABLE public.pay_webhooks (
    id bigint NOT NULL,
    processor character varying,
    event_type character varying,
    event jsonb,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.pay_webhooks OWNER TO abinet;

--
-- Name: pay_webhooks_id_seq; Type: SEQUENCE; Schema: public; Owner: abinet
--

CREATE SEQUENCE public.pay_webhooks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pay_webhooks_id_seq OWNER TO abinet;

--
-- Name: pay_webhooks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: abinet
--

ALTER SEQUENCE public.pay_webhooks_id_seq OWNED BY public.pay_webhooks.id;


--
-- Name: plans; Type: TABLE; Schema: public; Owner: abinet
--

CREATE TABLE public.plans (
    id bigint NOT NULL,
    name character varying NOT NULL,
    amount integer DEFAULT 0 NOT NULL,
    "interval" character varying NOT NULL,
    details jsonb,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    trial_period_days integer DEFAULT 0,
    hidden boolean,
    currency character varying,
    interval_count integer DEFAULT 1,
    description character varying,
    unit_label character varying,
    charge_per_unit boolean,
    stripe_id character varying,
    braintree_id character varying,
    paddle_billing_id character varying,
    paddle_classic_id character varying,
    lemon_squeezy_id character varying,
    fake_processor_id character varying,
    contact_url character varying
);


ALTER TABLE public.plans OWNER TO abinet;

--
-- Name: plans_id_seq; Type: SEQUENCE; Schema: public; Owner: abinet
--

CREATE SEQUENCE public.plans_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.plans_id_seq OWNER TO abinet;

--
-- Name: plans_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: abinet
--

ALTER SEQUENCE public.plans_id_seq OWNED BY public.plans.id;


--
-- Name: refer_referral_codes; Type: TABLE; Schema: public; Owner: abinet
--

CREATE TABLE public.refer_referral_codes (
    id bigint NOT NULL,
    referrer_type character varying NOT NULL,
    referrer_id bigint NOT NULL,
    code character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    referrals_count integer DEFAULT 0,
    visits_count integer DEFAULT 0
);


ALTER TABLE public.refer_referral_codes OWNER TO abinet;

--
-- Name: refer_referral_codes_id_seq; Type: SEQUENCE; Schema: public; Owner: abinet
--

CREATE SEQUENCE public.refer_referral_codes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.refer_referral_codes_id_seq OWNER TO abinet;

--
-- Name: refer_referral_codes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: abinet
--

ALTER SEQUENCE public.refer_referral_codes_id_seq OWNED BY public.refer_referral_codes.id;


--
-- Name: refer_referrals; Type: TABLE; Schema: public; Owner: abinet
--

CREATE TABLE public.refer_referrals (
    id bigint NOT NULL,
    referrer_type character varying NOT NULL,
    referrer_id bigint NOT NULL,
    referee_type character varying NOT NULL,
    referee_id bigint NOT NULL,
    referral_code_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    completed_at timestamp(6) without time zone
);


ALTER TABLE public.refer_referrals OWNER TO abinet;

--
-- Name: refer_referrals_id_seq; Type: SEQUENCE; Schema: public; Owner: abinet
--

CREATE SEQUENCE public.refer_referrals_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.refer_referrals_id_seq OWNER TO abinet;

--
-- Name: refer_referrals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: abinet
--

ALTER SEQUENCE public.refer_referrals_id_seq OWNED BY public.refer_referrals.id;


--
-- Name: refer_visits; Type: TABLE; Schema: public; Owner: abinet
--

CREATE TABLE public.refer_visits (
    id bigint NOT NULL,
    referral_code_id bigint NOT NULL,
    ip character varying,
    user_agent text,
    referrer text,
    referring_domain character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.refer_visits OWNER TO abinet;

--
-- Name: refer_visits_id_seq; Type: SEQUENCE; Schema: public; Owner: abinet
--

CREATE SEQUENCE public.refer_visits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.refer_visits_id_seq OWNER TO abinet;

--
-- Name: refer_visits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: abinet
--

ALTER SEQUENCE public.refer_visits_id_seq OWNED BY public.refer_visits.id;


--
-- Name: room_assignments; Type: TABLE; Schema: public; Owner: abinet
--

CREATE TABLE public.room_assignments (
    id bigint NOT NULL,
    participant_id bigint NOT NULL,
    room_id bigint NOT NULL,
    arrived_date date,
    checkin_date date,
    checkout_date date,
    notes text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    status integer
);


ALTER TABLE public.room_assignments OWNER TO abinet;

--
-- Name: room_assignments_id_seq; Type: SEQUENCE; Schema: public; Owner: abinet
--

CREATE SEQUENCE public.room_assignments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.room_assignments_id_seq OWNER TO abinet;

--
-- Name: room_assignments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: abinet
--

ALTER SEQUENCE public.room_assignments_id_seq OWNED BY public.room_assignments.id;


--
-- Name: rooms; Type: TABLE; Schema: public; Owner: abinet
--

CREATE TABLE public.rooms (
    id bigint NOT NULL,
    room_number character varying,
    room_type character varying,
    floor integer,
    hotel_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.rooms OWNER TO abinet;

--
-- Name: rooms_id_seq; Type: SEQUENCE; Schema: public; Owner: abinet
--

CREATE SEQUENCE public.rooms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rooms_id_seq OWNER TO abinet;

--
-- Name: rooms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: abinet
--

ALTER SEQUENCE public.rooms_id_seq OWNED BY public.rooms.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: abinet
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


ALTER TABLE public.schema_migrations OWNER TO abinet;

--
-- Name: side_events; Type: TABLE; Schema: public; Owner: abinet
--

CREATE TABLE public.side_events (
    id bigint NOT NULL,
    event_name character varying,
    description character varying,
    startdate date,
    enddate date,
    venue character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.side_events OWNER TO abinet;

--
-- Name: side_events_id_seq; Type: SEQUENCE; Schema: public; Owner: abinet
--

CREATE SEQUENCE public.side_events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.side_events_id_seq OWNER TO abinet;

--
-- Name: side_events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: abinet
--

ALTER SEQUENCE public.side_events_id_seq OWNED BY public.side_events.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: abinet
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    confirmation_token character varying,
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    unconfirmed_email character varying,
    first_name character varying,
    last_name character varying,
    time_zone character varying,
    accepted_terms_at timestamp without time zone,
    accepted_privacy_at timestamp without time zone,
    announcements_read_at timestamp without time zone,
    admin boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    invitation_token character varying,
    invitation_created_at timestamp without time zone,
    invitation_sent_at timestamp without time zone,
    invitation_accepted_at timestamp without time zone,
    invitation_limit integer,
    invited_by_type character varying,
    invited_by_id bigint,
    invitations_count integer DEFAULT 0,
    preferred_language character varying,
    otp_required_for_login boolean,
    otp_secret character varying,
    last_otp_timestep integer,
    otp_backup_codes text,
    preferences jsonb,
    name character varying GENERATED ALWAYS AS ((((first_name)::text || ' '::text) || (COALESCE(last_name, ''::character varying))::text)) STORED
);


ALTER TABLE public.users OWNER TO abinet;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: abinet
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO abinet;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: abinet
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: account_invitations id; Type: DEFAULT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.account_invitations ALTER COLUMN id SET DEFAULT nextval('public.account_invitations_id_seq'::regclass);


--
-- Name: account_users id; Type: DEFAULT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.account_users ALTER COLUMN id SET DEFAULT nextval('public.account_users_id_seq'::regclass);


--
-- Name: accounts id; Type: DEFAULT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.accounts ALTER COLUMN id SET DEFAULT nextval('public.accounts_id_seq'::regclass);


--
-- Name: action_text_embeds id; Type: DEFAULT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.action_text_embeds ALTER COLUMN id SET DEFAULT nextval('public.action_text_embeds_id_seq'::regclass);


--
-- Name: action_text_rich_texts id; Type: DEFAULT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.action_text_rich_texts ALTER COLUMN id SET DEFAULT nextval('public.action_text_rich_texts_id_seq'::regclass);


--
-- Name: active_storage_attachments id; Type: DEFAULT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.active_storage_attachments ALTER COLUMN id SET DEFAULT nextval('public.active_storage_attachments_id_seq'::regclass);


--
-- Name: active_storage_blobs id; Type: DEFAULT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.active_storage_blobs ALTER COLUMN id SET DEFAULT nextval('public.active_storage_blobs_id_seq'::regclass);


--
-- Name: active_storage_variant_records id; Type: DEFAULT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.active_storage_variant_records ALTER COLUMN id SET DEFAULT nextval('public.active_storage_variant_records_id_seq'::regclass);


--
-- Name: addresses id; Type: DEFAULT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.addresses ALTER COLUMN id SET DEFAULT nextval('public.addresses_id_seq'::regclass);


--
-- Name: announcements id; Type: DEFAULT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.announcements ALTER COLUMN id SET DEFAULT nextval('public.announcements_id_seq'::regclass);


--
-- Name: api_tokens id; Type: DEFAULT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.api_tokens ALTER COLUMN id SET DEFAULT nextval('public.api_tokens_id_seq'::regclass);


--
-- Name: attendees id; Type: DEFAULT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.attendees ALTER COLUMN id SET DEFAULT nextval('public.attendees_id_seq'::regclass);


--
-- Name: connected_accounts id; Type: DEFAULT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.connected_accounts ALTER COLUMN id SET DEFAULT nextval('public.connected_accounts_id_seq'::regclass);


--
-- Name: email_logs id; Type: DEFAULT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.email_logs ALTER COLUMN id SET DEFAULT nextval('public.email_logs_id_seq'::regclass);


--
-- Name: field_visit_activities id; Type: DEFAULT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.field_visit_activities ALTER COLUMN id SET DEFAULT nextval('public.field_visit_activities_id_seq'::regclass);


--
-- Name: field_visit_areas id; Type: DEFAULT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.field_visit_areas ALTER COLUMN id SET DEFAULT nextval('public.field_visit_areas_id_seq'::regclass);


--
-- Name: groups id; Type: DEFAULT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.groups ALTER COLUMN id SET DEFAULT nextval('public.groups_id_seq'::regclass);


--
-- Name: hotels id; Type: DEFAULT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.hotels ALTER COLUMN id SET DEFAULT nextval('public.hotels_id_seq'::regclass);


--
-- Name: inbound_webhooks id; Type: DEFAULT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.inbound_webhooks ALTER COLUMN id SET DEFAULT nextval('public.inbound_webhooks_id_seq'::regclass);


--
-- Name: noticed_events id; Type: DEFAULT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.noticed_events ALTER COLUMN id SET DEFAULT nextval('public.noticed_events_id_seq'::regclass);


--
-- Name: noticed_notifications id; Type: DEFAULT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.noticed_notifications ALTER COLUMN id SET DEFAULT nextval('public.noticed_notifications_id_seq'::regclass);


--
-- Name: notification_tokens id; Type: DEFAULT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.notification_tokens ALTER COLUMN id SET DEFAULT nextval('public.notification_tokens_id_seq'::regclass);


--
-- Name: notifications id; Type: DEFAULT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.notifications ALTER COLUMN id SET DEFAULT nextval('public.notifications_id_seq'::regclass);


--
-- Name: organizations id; Type: DEFAULT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.organizations ALTER COLUMN id SET DEFAULT nextval('public.organizations_id_seq'::regclass);


--
-- Name: participant_types id; Type: DEFAULT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.participant_types ALTER COLUMN id SET DEFAULT nextval('public.participant_types_id_seq'::regclass);


--
-- Name: participants id; Type: DEFAULT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.participants ALTER COLUMN id SET DEFAULT nextval('public.participants_id_seq'::regclass);


--
-- Name: pay_charges id; Type: DEFAULT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.pay_charges ALTER COLUMN id SET DEFAULT nextval('public.pay_charges_id_seq'::regclass);


--
-- Name: pay_customers id; Type: DEFAULT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.pay_customers ALTER COLUMN id SET DEFAULT nextval('public.pay_customers_id_seq'::regclass);


--
-- Name: pay_merchants id; Type: DEFAULT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.pay_merchants ALTER COLUMN id SET DEFAULT nextval('public.pay_merchants_id_seq'::regclass);


--
-- Name: pay_payment_methods id; Type: DEFAULT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.pay_payment_methods ALTER COLUMN id SET DEFAULT nextval('public.pay_payment_methods_id_seq'::regclass);


--
-- Name: pay_subscriptions id; Type: DEFAULT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.pay_subscriptions ALTER COLUMN id SET DEFAULT nextval('public.pay_subscriptions_id_seq'::regclass);


--
-- Name: pay_webhooks id; Type: DEFAULT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.pay_webhooks ALTER COLUMN id SET DEFAULT nextval('public.pay_webhooks_id_seq'::regclass);


--
-- Name: plans id; Type: DEFAULT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.plans ALTER COLUMN id SET DEFAULT nextval('public.plans_id_seq'::regclass);


--
-- Name: refer_referral_codes id; Type: DEFAULT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.refer_referral_codes ALTER COLUMN id SET DEFAULT nextval('public.refer_referral_codes_id_seq'::regclass);


--
-- Name: refer_referrals id; Type: DEFAULT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.refer_referrals ALTER COLUMN id SET DEFAULT nextval('public.refer_referrals_id_seq'::regclass);


--
-- Name: refer_visits id; Type: DEFAULT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.refer_visits ALTER COLUMN id SET DEFAULT nextval('public.refer_visits_id_seq'::regclass);


--
-- Name: room_assignments id; Type: DEFAULT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.room_assignments ALTER COLUMN id SET DEFAULT nextval('public.room_assignments_id_seq'::regclass);


--
-- Name: rooms id; Type: DEFAULT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.rooms ALTER COLUMN id SET DEFAULT nextval('public.rooms_id_seq'::regclass);


--
-- Name: side_events id; Type: DEFAULT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.side_events ALTER COLUMN id SET DEFAULT nextval('public.side_events_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: account_invitations; Type: TABLE DATA; Schema: public; Owner: abinet
--

COPY public.account_invitations (id, account_id, invited_by_id, token, name, email, roles, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: account_users; Type: TABLE DATA; Schema: public; Owner: abinet
--

COPY public.account_users (id, account_id, user_id, roles, created_at, updated_at) FROM stdin;
9	9	1	{"admin": true}	2024-10-24 19:24:07.283284	2024-10-24 19:24:07.283284
\.


--
-- Data for Name: accounts; Type: TABLE DATA; Schema: public; Owner: abinet
--

COPY public.accounts (id, name, owner_id, personal, created_at, updated_at, extra_billing_info, domain, subdomain, billing_email, account_users_count) FROM stdin;
9	Abinet Seife Zergaw	1	t	2024-10-24 19:24:07.258211	2024-10-24 19:24:07.258211	\N	\N	\N	\N	1
\.


--
-- Data for Name: action_text_embeds; Type: TABLE DATA; Schema: public; Owner: abinet
--

COPY public.action_text_embeds (id, url, fields, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: action_text_rich_texts; Type: TABLE DATA; Schema: public; Owner: abinet
--

COPY public.action_text_rich_texts (id, name, body, record_type, record_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: active_storage_attachments; Type: TABLE DATA; Schema: public; Owner: abinet
--

COPY public.active_storage_attachments (id, name, record_type, record_id, blob_id, created_at) FROM stdin;
1	invitation_letter	Participant	1	1	2024-10-11 19:54:21.021406
2	invitation_letter	Participant	2	2	2024-10-11 19:56:24.174335
3	invitation_letter	Participant	3	3	2024-10-11 19:57:35.916643
4	invitation_letter	Participant	4	4	2024-10-20 10:55:48.46289
5	invitation_letter	Participant	5	5	2024-10-20 17:21:46.762025
6	invitation_letter	Participant	6	6	2024-10-20 17:53:18.36723
7	invitation_letter	Participant	7	7	2024-10-20 17:56:15.968955
8	invitation_letter	Participant	9	8	2024-10-20 19:05:47.536774
9	invitation_letter	Participant	11	9	2024-10-21 16:01:39.28481
10	invitation_letter	Participant	12	10	2024-10-21 16:23:19.362404
11	invitation_letter	Participant	13	11	2024-10-21 16:30:36.10797
12	invitation_letter	Participant	14	12	2024-10-21 16:50:40.577659
13	invitation_letter	Participant	15	13	2024-10-21 17:55:52.818025
14	invitation_letter	Participant	16	14	2024-10-21 18:00:13.595064
15	invitation_letter	Participant	17	15	2024-10-21 18:25:33.128936
\.


--
-- Data for Name: active_storage_blobs; Type: TABLE DATA; Schema: public; Owner: abinet
--

COPY public.active_storage_blobs (id, key, filename, content_type, metadata, byte_size, checksum, created_at, service_name) FROM stdin;
1	fihy6v3ci5pi6nybp2rwubnb1niw	samalo pigs.jpeg	image/jpeg	{"identified":true,"width":1024,"height":1024,"analyzed":true}	133246	+jfGzYwpkYsac+FUaS1pfw==	2024-10-11 19:54:21.018932	local
2	r1fu4akv2cblt9ocyfrkcg2hnrrt	intro to git (1).pdf	application/pdf	{"identified":true,"analyzed":true}	274171	RIh6nAHH3Rc20Ll9HvJA2A==	2024-10-11 19:56:24.172718	local
3	10bfwe1y4bikej69afnfagrdxx21	EE App Installation & Navigation 4HIT v0.3.pdf	application/pdf	{"identified":true,"analyzed":true}	5981157	qE7zQoHkovzcYAzxfI+qcA==	2024-10-11 19:57:35.915425	local
4	bz6yn6undhplw9yzqpe4d4memitt	Screenshot 2024-10-11 at 12.08.10 PM.png	image/png	{"identified":true,"width":2880,"height":1800,"analyzed":true}	372335	U3tXcDy+lEaXLtIWEm0/dw==	2024-10-20 10:55:48.458056	local
5	wzz7ky6iuje8mdu7a29n6o5haqur	Screenshot 2024-10-11 at 10.36.29 AM.png	image/png	{"identified":true,"width":2880,"height":1800,"analyzed":true}	371359	M0GNocxMlRqremD675r6VA==	2024-10-20 17:21:46.758988	local
6	x1pk4e7u96mh4buikse7gv1gwv5f	Screenshot 2024-10-11 at 3.46.12 AM.png	image/png	{"identified":true,"width":2880,"height":1800,"analyzed":true}	460920	NguIUcdvG8piIXVdGgUlZQ==	2024-10-20 17:53:18.364859	local
7	278k9aqvdz4o5vn764gqaow0vr60	Screenshot 2024-10-11 at 4.28.52 AM.png	image/png	{"identified":true,"width":2880,"height":1800,"analyzed":true}	448623	9uVJeehT3QwIDHLj2ElfIA==	2024-10-20 17:56:15.966091	local
8	tafvn02m42y50ied9vcrsesumkga	Screenshot 2024-10-11 at 4.33.37 AM.png	image/png	{"identified":true,"width":2880,"height":1800,"analyzed":true}	328550	kQr81RpIRPw7WpPhGuqhjw==	2024-10-20 19:05:47.529486	local
9	7yy0ihtjngpn0cqvgtvypfbxgg02	BI_Lecture4.pdf	application/pdf	{"identified":true,"analyzed":true}	580861	3tRR9ypBnjHSiF/B7sbwBg==	2024-10-21 16:01:39.280491	local
10	uk2fvi6l9xw3ik821uhu2ybatpg8	Screenshot 2024-10-11 at 10.53.14 AM.png	image/png	{"identified":true,"width":2880,"height":1800,"analyzed":true}	555573	7tZBcCYCKKRQL7v98P4AfA==	2024-10-21 16:23:19.359734	local
11	zqlbwvottpoab2hyilxi96ojueli	Screenshot 2024-10-11 at 4.33.37 AM.png	image/png	{"identified":true,"width":2880,"height":1800,"analyzed":true}	328550	kQr81RpIRPw7WpPhGuqhjw==	2024-10-21 16:30:36.106099	local
12	9bwza3tochcsz6e3z1tt7okt1az9	Screenshot 2024-10-11 at 3.49.57 AM.png	image/png	{"identified":true,"width":2880,"height":1800,"analyzed":true}	465104	kYm4bChKKwnPJ1hYqx3F0w==	2024-10-21 16:50:40.575652	local
13	zpyjt0fpk29ef3w757tw81wkog3m	Screenshot 2024-10-11 at 3.46.12 AM.png	image/png	{"identified":true,"width":2880,"height":1800,"analyzed":true}	460920	NguIUcdvG8piIXVdGgUlZQ==	2024-10-21 17:55:52.815419	local
14	sx163s4ul29cdo8s7edsbp9pl1qy	Screenshot 2024-10-11 at 3.46.12 AM.png	image/png	{"identified":true,"width":2880,"height":1800,"analyzed":true}	460920	NguIUcdvG8piIXVdGgUlZQ==	2024-10-21 18:00:13.592347	local
15	s2xvqcdsq3k480rpcdjdpot6c2ic	Screenshot 2024-10-11 at 4.35.49 AM.png	image/png	{"identified":true,"width":2880,"height":1800,"analyzed":true}	744085	8m+rr/rd4N36xvNLaDLl6A==	2024-10-21 18:25:33.126702	local
\.


--
-- Data for Name: active_storage_variant_records; Type: TABLE DATA; Schema: public; Owner: abinet
--

COPY public.active_storage_variant_records (id, blob_id, variation_digest) FROM stdin;
\.


--
-- Data for Name: addresses; Type: TABLE DATA; Schema: public; Owner: abinet
--

COPY public.addresses (id, addressable_type, addressable_id, address_type, line1, line2, city, state, country, postal_code, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: announcements; Type: TABLE DATA; Schema: public; Owner: abinet
--

COPY public.announcements (id, kind, title, published_at, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: api_tokens; Type: TABLE DATA; Schema: public; Owner: abinet
--

COPY public.api_tokens (id, user_id, token, name, metadata, transient, last_used_at, expires_at, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: ar_internal_metadata; Type: TABLE DATA; Schema: public; Owner: abinet
--

COPY public.ar_internal_metadata (key, value, created_at, updated_at) FROM stdin;
environment	development	2024-10-11 19:34:02.500997	2024-10-11 19:34:02.500999
\.


--
-- Data for Name: attendees; Type: TABLE DATA; Schema: public; Owner: abinet
--

COPY public.attendees (id, full_name, address, org, days_to_attend, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: connected_accounts; Type: TABLE DATA; Schema: public; Owner: abinet
--

COPY public.connected_accounts (id, owner_id, provider, uid, refresh_token, expires_at, auth, created_at, updated_at, access_token, access_token_secret, owner_type) FROM stdin;
\.


--
-- Data for Name: email_logs; Type: TABLE DATA; Schema: public; Owner: abinet
--

COPY public.email_logs (id, participant_id, status, sent_at, created_at, updated_at) FROM stdin;
1	1	sent	2024-10-11 20:14:04.85204	2024-10-11 20:14:04.85824	2024-10-11 20:14:04.85824
2	1	sent	2024-10-11 20:14:04.862593	2024-10-11 20:14:04.862651	2024-10-11 20:14:04.862651
3	1	sent	2024-10-11 20:14:08.895791	2024-10-11 20:14:08.896419	2024-10-11 20:14:08.896419
4	1	failed	2024-10-22 22:41:19.450429	2024-10-22 22:41:19.488001	2024-10-22 22:41:19.488001
5	1	sent	2024-10-22 22:44:24.674435	2024-10-22 22:44:24.684413	2024-10-22 22:44:24.684413
6	1	sent	2024-10-22 22:44:24.730862	2024-10-22 22:44:24.731145	2024-10-22 22:44:24.731145
7	1	sent	2024-10-22 22:44:28.916641	2024-10-22 22:44:28.920675	2024-10-22 22:44:28.920675
8	1	sent	2024-10-22 22:46:15.988972	2024-10-22 22:46:16.009113	2024-10-22 22:46:16.009113
9	1	sent	2024-10-22 22:46:16.015021	2024-10-22 22:46:16.015123	2024-10-22 22:46:16.015123
10	1	sent	2024-10-22 22:46:21.749259	2024-10-22 22:46:21.754643	2024-10-22 22:46:21.754643
11	1	sent	2024-10-22 22:50:26.179156	2024-10-22 22:50:26.17993	2024-10-22 22:50:26.17993
12	1	sent	2024-10-22 22:50:26.211408	2024-10-22 22:50:26.211595	2024-10-22 22:50:26.211595
13	1	sent	2024-10-22 22:50:29.919925	2024-10-22 22:50:29.924654	2024-10-22 22:50:29.924654
14	1	sent	2024-10-22 22:51:34.057197	2024-10-22 22:51:34.071063	2024-10-22 22:51:34.071063
15	1	sent	2024-10-22 22:51:34.076124	2024-10-22 22:51:34.076283	2024-10-22 22:51:34.076283
16	1	sent	2024-10-22 22:51:42.414376	2024-10-22 22:51:42.415968	2024-10-22 22:51:42.415968
17	1	sent	2024-10-22 22:57:37.643641	2024-10-22 22:57:37.655852	2024-10-22 22:57:37.655852
18	1	sent	2024-10-22 22:57:37.679656	2024-10-22 22:57:37.679878	2024-10-22 22:57:37.679878
19	1	sent	2024-10-22 22:57:43.001175	2024-10-22 22:57:43.00497	2024-10-22 22:57:43.00497
20	1	sent	2024-10-22 23:06:27.602205	2024-10-22 23:06:27.614799	2024-10-22 23:06:27.614799
21	1	sent	2024-10-22 23:06:27.835142	2024-10-22 23:06:27.842689	2024-10-22 23:06:27.842689
22	1	sent	2024-10-22 23:06:34.032632	2024-10-22 23:06:34.034534	2024-10-22 23:06:34.034534
23	1	sent	2024-10-22 23:16:18.837418	2024-10-22 23:16:18.977198	2024-10-22 23:16:18.977198
24	1	sent	2024-10-22 23:16:18.98183	2024-10-22 23:16:18.981931	2024-10-22 23:16:18.981931
25	1	sent	2024-10-22 23:16:23.310112	2024-10-22 23:16:23.314372	2024-10-22 23:16:23.314372
26	1	sent	2024-10-22 23:20:32.899703	2024-10-22 23:20:32.91372	2024-10-22 23:20:32.91372
27	1	sent	2024-10-22 23:20:32.922636	2024-10-22 23:20:32.922782	2024-10-22 23:20:32.922782
28	1	sent	2024-10-22 23:20:37.033337	2024-10-22 23:20:37.039135	2024-10-22 23:20:37.039135
29	1	sent	2024-10-22 23:24:01.542397	2024-10-22 23:24:01.556012	2024-10-22 23:24:01.556012
30	1	sent	2024-10-22 23:24:01.582678	2024-10-22 23:24:01.582855	2024-10-22 23:24:01.582855
31	1	sent	2024-10-22 23:24:07.305767	2024-10-22 23:24:07.309844	2024-10-22 23:24:07.309844
32	1	sent	2024-10-22 23:27:26.954811	2024-10-22 23:27:26.982374	2024-10-22 23:27:26.982374
33	1	sent	2024-10-22 23:27:27.002703	2024-10-22 23:27:27.002838	2024-10-22 23:27:27.002838
34	1	sent	2024-10-22 23:27:37.26346	2024-10-22 23:27:37.269217	2024-10-22 23:27:37.269217
35	1	sent	2024-10-22 23:30:20.527075	2024-10-22 23:30:20.549586	2024-10-22 23:30:20.549586
36	1	sent	2024-10-22 23:30:20.556345	2024-10-22 23:30:20.556512	2024-10-22 23:30:20.556512
37	1	sent	2024-10-22 23:30:25.587939	2024-10-22 23:30:25.5918	2024-10-22 23:30:25.5918
38	1	sent	2024-10-22 23:30:28.70693	2024-10-22 23:30:28.707458	2024-10-22 23:30:28.707458
39	1	sent	2024-10-22 23:30:28.726999	2024-10-22 23:30:28.727192	2024-10-22 23:30:28.727192
40	1	sent	2024-10-22 23:30:36.915094	2024-10-22 23:30:36.920337	2024-10-22 23:30:36.920337
41	1	sent	2024-10-22 23:30:44.560572	2024-10-22 23:30:44.561268	2024-10-22 23:30:44.561268
42	1	sent	2024-10-22 23:30:44.580782	2024-10-22 23:30:44.580956	2024-10-22 23:30:44.580956
43	1	sent	2024-10-22 23:30:49.915859	2024-10-22 23:30:49.919002	2024-10-22 23:30:49.919002
44	1	sent	2024-10-22 23:36:08.609277	2024-10-22 23:36:08.622729	2024-10-22 23:36:08.622729
45	1	sent	2024-10-22 23:36:08.693373	2024-10-22 23:36:08.693555	2024-10-22 23:36:08.693555
46	1	sent	2024-10-22 23:36:13.122989	2024-10-22 23:36:13.126822	2024-10-22 23:36:13.126822
\.


--
-- Data for Name: field_visit_activities; Type: TABLE DATA; Schema: public; Owner: abinet
--

COPY public.field_visit_activities (id, name, description, field_visit_area_id, scheduled_date, duration, max_participants, notes, created_at, updated_at) FROM stdin;
2	Arba Minch Zuria Woreda	Arba Minch Zuria Woreda	1	2024-10-18	2	43	10 KM	2024-10-11 19:45:05.941932	2024-10-11 19:45:05.941932
3	Welaita Sodo City and Bayira Koyisha Woreda	Welaita Sodo City and Bayira Koyisha Woreda	1	2024-10-24	2	2	100 KM	2024-10-21 17:51:26.364418	2024-10-21 17:51:26.364418
4	West Abaya Woreda	West Abaya Woreda	1	\N	2	32	40 KM	2024-10-22 15:40:39.139095	2024-10-22 15:40:39.139095
1	Arba Minch City	Arba Minch City	2	2024-10-18	\N	3	5KM\n	2024-10-11 19:44:24.659778	2024-10-11 19:44:24.659778
\.


--
-- Data for Name: field_visit_areas; Type: TABLE DATA; Schema: public; Owner: abinet
--

COPY public.field_visit_areas (id, name, distance_from_arm_venue, note, created_at, updated_at) FROM stdin;
2	Arba Minch Zuria Woreda	10	Arba Minch Zuria Woreda	2024-10-11 19:43:59.65459	2024-10-24 19:26:32.397627
3	Welaita Sodo City and Bayira Koyisha Woreda	100	Welaita Sodo City and Bayira Koyisha Woreda	2024-10-22 15:39:53.840235	2024-10-24 19:26:47.687908
4	West Abaya Woreda	40	West Abaya Woreda	2024-10-24 19:27:13.823918	2024-10-24 19:27:13.823918
1	Arba Minch City	5	Arbaminch City	2024-10-11 19:43:47.840918	2024-10-24 19:26:08.587901
\.


--
-- Data for Name: groups; Type: TABLE DATA; Schema: public; Owner: abinet
--

COPY public.groups (id, name, description, created_at, updated_at) FROM stdin;
1	G1	Group 1 - Addis	2024-10-11 19:43:14.923787	2024-10-11 19:43:14.923787
2	G2	Group 2 - MoH	2024-10-11 19:43:22.55087	2024-10-11 19:43:22.55087
3	G3	Group 3 - MoH	2024-10-11 19:43:32.826796	2024-10-11 19:43:32.826796
4	G4	Group332 - MoH	2024-10-15 16:26:01.496731	2024-10-15 16:26:01.496731
5	G5	hh	2024-10-21 08:34:10.415509	2024-10-21 08:34:10.415509
7	 	 	2024-10-26 12:40:30.559924	2024-10-26 12:40:30.559924
6	 	 	2024-10-21 17:53:34.257705	2024-10-26 12:40:51.29968
\.


--
-- Data for Name: hotels; Type: TABLE DATA; Schema: public; Owner: abinet
--

COPY public.hotels (id, name, location, room_numbers, created_at, updated_at) FROM stdin;
1	Haile Resort	Abayata mount	42	2024-10-11 19:37:33.023433	2024-10-11 19:37:33.023433
2	Bekele Mola	5k sdaskd	43	2024-10-11 19:37:50.536873	2024-10-11 19:37:50.536873
3	Radison Int	Central	23	2024-10-11 19:38:15.100208	2024-10-11 19:38:15.100208
4	Glory Int Hotel	central location	4	2024-10-15 12:31:49.706934	2024-10-15 12:31:49.706934
5	Glory Int Hotel	central location	4	2024-10-15 12:31:50.488096	2024-10-15 12:31:50.488096
6	Glory Int Hotel	central location	4	2024-10-15 12:31:50.652909	2024-10-15 12:31:50.652909
7	Glory Int Hotel	central location	4	2024-10-15 12:31:50.845464	2024-10-15 12:31:50.845464
8	Glory Int Hotel	central location	4	2024-10-15 12:31:50.970739	2024-10-15 12:31:50.970739
9	Chamo Hotel	south gate area	42	2024-10-15 14:31:56.143622	2024-10-15 14:31:56.143622
\.


--
-- Data for Name: inbound_webhooks; Type: TABLE DATA; Schema: public; Owner: abinet
--

COPY public.inbound_webhooks (id, status, body, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: noticed_events; Type: TABLE DATA; Schema: public; Owner: abinet
--

COPY public.noticed_events (id, account_id, type, record_type, record_id, params, created_at, updated_at, notifications_count) FROM stdin;
\.


--
-- Data for Name: noticed_notifications; Type: TABLE DATA; Schema: public; Owner: abinet
--

COPY public.noticed_notifications (id, account_id, type, event_id, recipient_type, recipient_id, read_at, seen_at, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: notification_tokens; Type: TABLE DATA; Schema: public; Owner: abinet
--

COPY public.notification_tokens (id, user_id, token, platform, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner: abinet
--

COPY public.notifications (id, account_id, recipient_type, recipient_id, type, params, read_at, created_at, updated_at, interacted_at) FROM stdin;
\.


--
-- Data for Name: organizations; Type: TABLE DATA; Schema: public; Owner: abinet
--

COPY public.organizations (id, name, location, allowed_participant_number, created_at, updated_at) FROM stdin;
1	MoH	Addis Ababa	2	2024-10-11 19:40:29.458303	2024-10-11 19:40:29.458303
2	JSI	Addis	2	2024-10-11 19:40:42.508779	2024-10-11 19:40:42.508779
3	HABTech	Addis Ababa	3	2024-10-11 19:40:54.762626	2024-10-11 19:40:54.762626
4	AACRHB	Addis Ababa	2	2024-10-11 19:41:05.242795	2024-10-11 19:41:05.242795
5	ORHB	Oromia	3	2024-10-11 19:41:25.844712	2024-10-11 19:41:25.844712
6	other	other	\N	2024-10-21 17:39:48.920689	2024-10-21 17:43:28.136395
7	DGDGGD	\N	\N	2024-10-21 18:00:13.547925	2024-10-21 18:00:13.547925
8	UNFPA	\N	\N	2024-10-22 13:31:35.51066	2024-10-22 13:31:35.51066
\.


--
-- Data for Name: participant_types; Type: TABLE DATA; Schema: public; Owner: abinet
--

COPY public.participant_types (id, type_name, description, created_at, updated_at) FROM stdin;
6	Guest	Guest participant	2024-10-21 07:15:21.70076	2024-10-21 07:15:21.70076
4	VIP	VIP	2024-10-11 19:42:19.775349	2024-10-11 19:42:19.775349
5	MEDIA	MEDIA	2024-10-11 19:42:59.112443	2024-10-11 19:42:59.112443
8	Media	Media	2024-10-25 13:00:24.765998	2024-10-25 13:00:24.765998
11	Reviewer	Reviewer	2024-10-25 13:03:42.700771	2024-10-25 13:03:42.700771
3	PARTICIPANT -MoH	PARTICIPANTS -MoH	2024-10-11 19:42:00.122278	2024-10-11 19:42:00.122278
2	PARTICIPANT	PARTICIPANTS	2024-10-11 19:41:48.021866	2024-10-11 19:41:48.021866
7	Exhibitor	Exhibitors	2024-10-25 13:00:13.331447	2024-10-25 13:00:13.331447
10	Coordinator	Coordinators	2024-10-25 13:00:48.935191	2024-10-25 13:00:48.935191
9	Awardee	Awards	2024-10-25 13:00:36.84089	2024-10-25 13:00:36.84089
1	PARTNER	PARTNERS	2024-10-11 19:41:37.346123	2024-10-11 19:41:37.346123
\.


--
-- Data for Name: participants; Type: TABLE DATA; Schema: public; Owner: abinet
--

COPY public.participants (id, name, organization_id, registration_date, location, "position", email, telephone_number, participant_type_id, group_id, emergency_contact_name, emergency_contact_number, side_event_id, meal_options, "resourceMaterial_take", accommodation_required, notes, created_at, updated_at, approved, serial_number, attended_day_0, attended_day_1, attended_day_2, attended_day_3, field_visit_activity_id, user_id, region, orgname, rollno) FROM stdin;
312	Dr. Mesay Hailu 	\N	\N	EPHI	General Director 	mesdang216@gmail.com	\N	4	2	\N	\N	2	\N	\N	\N	\N	2024-12-23 19:29:12	2024-12-23 19:29:12	t	ARM2640043	t	\N	\N	\N	1	300	\N	Addis Ababa	300
449	Awol Mamo 	\N	\N	EPOS 	Exhibitors 	N/A	993037118	7	4	\N	\N	4	\N	\N	\N	\N	2025-05-09 19:29:12	2025-05-09 19:29:12	t	ARM2670011	t	\N	\N	\N	3	437	\N	ADDIS ABABA	437
450	Bezawit Tamiru 	\N	\N	MOH-NE	Exhibitors 	N/A	911995082	7	3	\N	\N	3	\N	\N	\N	\N	2025-05-10 19:29:12	2025-05-10 19:29:12	t	ARM2670012	t	\N	\N	\N	4	438	\N	ADDIS ABABA	438
451	Meron Tesfaye 	\N	\N	MOH-DPCE	Exhibitors 	N/A	947599467	7	4	\N	\N	4	\N	\N	\N	\N	2025-05-11 19:29:12	2025-05-11 19:29:12	t	ARM2670013	t	\N	\N	\N	2	439	\N	ADDIS ABABA	439
452	Alemayehu Birhanu	\N	\N	MOH-MSE	Exhibitors 	N/A	912333918	7	5	\N	\N	5	\N	\N	\N	\N	2025-05-12 19:29:12	2025-05-12 19:29:12	t	ARM2670014	t	\N	\N	\N	2	440	\N	ADDIS ABABA	440
453	Takelech Moges	\N	\N	MOH-DPCE	Exhibitors 	N/A	911659795	7	1	\N	\N	1	\N	\N	\N	\N	2025-05-13 19:29:12	2025-05-13 19:29:12	t	ARM2670015	t	\N	\N	\N	3	441	\N	ADDIS ABABA	441
454	Wondwosen Mengesha	\N	\N	ORHB	Exhibitors 	N/A	926643934	7	5	\N	\N	5	\N	\N	\N	\N	2025-05-14 19:29:12	2025-05-14 19:29:12	t	ARM2670016	t	\N	\N	\N	1	442	\N	ADDIS ABABA	442
455	Redwan Mohammed 	\N	\N	HRHB	Exhibitors 	N/A	910146159	7	4	\N	\N	4	\N	\N	\N	\N	2025-05-15 19:29:12	2025-05-15 19:29:12	t	ARM2670017	t	\N	\N	\N	3	443	\N	ADDIS ABABA	443
456	Tizita Demisse 	\N	\N	PR/MOH	Exhibitors 	N/A	\N	7	4	\N	\N	4	\N	\N	\N	\N	2025-05-16 19:29:12	2025-05-16 19:29:12	t	ARM2670018	t	\N	\N	\N	1	444	\N	ADDIS ABABA	444
457	Efrem Biruk 	\N	\N	SAEO/MOH	Exhibitors 	N/A	911674093	7	5	\N	\N	5	\N	\N	\N	\N	2025-05-17 19:29:12	2025-05-17 19:29:12	t	ARM2670019	t	\N	\N	\N	2	445	\N	ADDIS ABABA	445
458	Fikade Aychiluhim 	\N	\N	OBN 	Media 	N/A	912333918	5	5	\N	\N	5	\N	\N	\N	\N	2025-05-18 19:29:12	2025-05-18 19:29:12	t	ARM2650001	t	\N	\N	\N	1	446	\N	ADDIS ABABA	446
459	Arif Ahmed	\N	\N	OBN 	Media 	N/A	911659795	5	4	\N	\N	4	\N	\N	\N	\N	2025-05-19 19:29:12	2025-05-19 19:29:12	t	ARM2650002	t	\N	\N	\N	2	447	\N	ADDIS ABABA	447
460	Betel Mekonnen	\N	\N	AMECO	Media 	N/A	926643934	5	3	\N	\N	3	\N	\N	\N	\N	2025-05-20 19:29:12	2025-05-20 19:29:12	t	ARM2650003	t	\N	\N	\N	4	448	\N	ADDIS ABABA	448
461	Natnael Hailemeskel	\N	\N	AMECO	Media 	N/A	910146159	5	3	\N	\N	3	\N	\N	\N	\N	2025-05-21 19:29:12	2025-05-21 19:29:12	t	ARM2650004	t	\N	\N	\N	3	449	\N	ADDIS ABABA	449
462	Abeselom Areaya	\N	\N	NBC	Media 	N/A	912333918	5	4	\N	\N	4	\N	\N	\N	\N	2025-05-22 19:29:12	2025-05-22 19:29:12	t	ARM2650005	t	\N	\N	\N	1	450	\N	ADDIS ABABA	450
463	Yabsira Million 	\N	\N	NBC	Media 	N/A	911659795	5	2	\N	\N	2	\N	\N	\N	\N	2025-05-23 19:29:12	2025-05-23 19:29:12	t	ARM2650006	t	\N	\N	\N	4	451	\N	ADDIS ABABA	451
464	Samuel Werkayehu	\N	\N	FANA BC	Media 	N/A	926643934	5	4	\N	\N	4	\N	\N	\N	\N	2025-05-24 19:29:12	2025-05-24 19:29:12	t	ARM2650007	t	\N	\N	\N	2	452	\N	ADDIS ABABA	452
465	Elias Seid 	\N	\N	FANA BC	Media 	N/A	910146159	5	5	\N	\N	5	\N	\N	\N	\N	2025-05-25 19:29:12	2025-05-25 19:29:12	t	ARM2650008	t	\N	\N	\N	3	453	\N	ADDIS ABABA	453
466	Melkamu Ababu	\N	\N	WALTA	Media 	N/A	911674093	5	4	\N	\N	4	\N	\N	\N	\N	2025-05-26 19:29:12	2025-05-26 19:29:12	t	ARM2650009	t	\N	\N	\N	1	454	\N	ADDIS ABABA	454
467	Henok Lemi 	\N	\N	WALTA	Media 	N/A	912333918	5	5	\N	\N	5	\N	\N	\N	\N	2025-05-27 19:29:12	2025-05-27 19:29:12	t	ARM2650010	t	\N	\N	\N	2	455	\N	ADDIS ABABA	455
468	Hana Demissie 	\N	\N	GERMEN/DW	Media 	N/A	911659795	5	1	\N	\N	1	\N	\N	\N	\N	2025-05-28 19:29:12	2025-05-28 19:29:12	t	ARM2650011	t	\N	\N	\N	4	456	\N	ADDIS ABABA	456
469	Dagmawit Dereje 	\N	\N	EBS	Media 	N/A	926643934	5	1	\N	\N	1	\N	\N	\N	\N	2025-05-29 19:29:12	2025-05-29 19:29:12	t	ARM2650012	t	\N	\N	\N	3	457	\N	ADDIS ABABA	457
470	Eyob  Asefa Agzie 	\N	\N	EBS	Media 	N/A	910146159	5	4	\N	\N	4	\N	\N	\N	\N	2025-05-30 19:29:12	2025-05-30 19:29:12	t	ARM2650013	t	\N	\N	\N	4	458	\N	ADDIS ABABA	458
471	Tesfaye Lemessa	\N	\N	EBC	Media 	N/A	912333918	5	4	\N	\N	4	\N	\N	\N	\N	2025-05-31 19:29:12	2025-05-31 19:29:12	t	ARM2650014	t	\N	\N	\N	1	459	\N	ADDIS ABABA	459
472	Alemayehu Fikre 	\N	\N	EBC	Media 	N/A	911659795	5	4	\N	\N	4	\N	\N	\N	\N	2025-06-01 19:29:12	2025-06-01 19:29:12	t	ARM2650015	t	\N	\N	\N	2	460	\N	ADDIS ABABA	460
473	Yonatan Zebedyos 	\N	\N	VOA	Media 	N/A	926643934	5	3	\N	\N	3	\N	\N	\N	\N	2025-06-02 19:29:12	2025-06-02 19:29:12	t	ARM2650016	t	\N	\N	\N	3	461	\N	ADDIS ABABA	461
474	Temegnuh  Geresu 	\N	\N	SOUTH MEDIA	Media 	N/A	910146159	5	1	\N	\N	1	\N	\N	\N	\N	2025-06-03 19:29:12	2025-06-03 19:29:12	t	ARM2650017	t	\N	\N	\N	3	462	\N	ADDIS ABABA	462
475	Munta Mudda	\N	\N	SOUTH MEDIA	Media 	N/A	911674093	5	4	\N	\N	4	\N	\N	\N	\N	2025-06-04 19:29:12	2025-06-04 19:29:12	t	ARM2650018	t	\N	\N	\N	1	463	\N	ADDIS ABABA	463
476	AMINAT HUSSIEN 	\N	\N	ARHB	HEW	N/A	912333918	9	1	\N	\N	1	\N	\N	\N	\N	2025-06-05 19:29:12	2025-06-05 19:29:12	t	ARM2690001	t	\N	\N	\N	3	464	\N	ADDIS ABABA	464
477	AJEB KEMAL 	\N	\N	CENTRAL ET. RHB 	HEW	N/A	911659795	9	5	\N	\N	5	\N	\N	\N	\N	2025-06-06 19:29:12	2025-06-06 19:29:12	t	ARM2690002	t	\N	\N	\N	2	465	\N	ADDIS ABABA	465
478	MEKIYA NURI 	\N	\N	SOUTH ET. RHB 	HEW	N/A	926643934	9	1	\N	\N	1	\N	\N	\N	\N	2025-06-07 19:29:12	2025-06-07 19:29:12	t	ARM2690003	t	\N	\N	\N	4	466	\N	ADDIS ABABA	466
479	ASSMA LENCHI 	\N	\N	SOUTH  WEST  RHB 	HEW	N/A	910146159	9	1	\N	\N	1	\N	\N	\N	\N	2025-06-08 19:29:12	2025-06-08 19:29:12	t	ARM2690004	t	\N	\N	\N	3	467	\N	ADDIS ABABA	467
480	Sr. SIMEGN ASSEFA 	\N	\N	HARAR RHB 	HEW	N/A	912333918	9	4	\N	\N	4	\N	\N	\N	\N	2025-06-09 19:29:12	2025-06-09 19:29:12	t	ARM2690005	t	\N	\N	\N	4	468	\N	ADDIS ABABA	468
481	SEGNI URGESSA 	\N	\N	OROMIA RHB	HEW	N/A	911659795	9	4	\N	\N	4	\N	\N	\N	\N	2025-06-10 19:29:12	2025-06-10 19:29:12	t	ARM2690006	t	\N	\N	\N	1	469	\N	ADDIS ABABA	469
482	TIGIST TSEGAYE	\N	\N	SIDAMA RHB 	HEW	N/A	926643934	9	4	\N	\N	4	\N	\N	\N	\N	2025-06-11 19:29:12	2025-06-11 19:29:12	t	ARM2690007	t	\N	\N	\N	2	470	\N	ADDIS ABABA	470
483	DIRSHAYE ESSA 	\N	\N	BENESHANGUL G. RHB	HEW	N/A	910146159	9	3	\N	\N	3	\N	\N	\N	\N	2025-06-12 19:29:12	2025-06-12 19:29:12	t	ARM2690008	t	\N	\N	\N	3	471	\N	ADDIS ABABA	471
484	DESSALECH AYIMALU 	\N	\N	GAMBELLA RHB 	HEW	N/A	911674093	9	1	\N	\N	1	\N	\N	\N	\N	2025-06-13 19:29:12	2025-06-13 19:29:12	t	ARM2690009	t	\N	\N	\N	3	472	\N	ADDIS ABABA	472
1	Abinet Seife	\N	\N	ADDIS ABABA	DevOps	abinet.seife.et@gmail.com	\N	1	1	\N	\N	1	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	f	ARM2610001	t	\N	\N	\N	1	1	\N	MoH -DH	001
485	AFRHA KEDIR 	\N	\N	AFAR RHB	HEW	N/A	912333918	9	4	\N	\N	4	\N	\N	\N	\N	2025-06-14 19:29:12	2025-06-14 19:29:12	t	ARM2690010	t	\N	\N	\N	1	473	\N	ADDIS ABABA	473
486	FERIHIYA MOHAMMED 	\N	\N	SOMALE RHB	HEW	N/A	911659795	9	4	\N	\N	4	\N	\N	\N	\N	2025-06-15 19:29:12	2025-06-15 19:29:12	t	ARM2690011	t	\N	\N	\N	4	474	\N	ADDIS ABABA	474
487	ADER  USMAEL 	\N	\N	DIREDAWA CAD HB 	HEW	N/A	926643934	9	4	\N	\N	4	\N	\N	\N	\N	2025-06-16 19:29:12	2025-06-16 19:29:12	t	ARM2690012	t	\N	\N	\N	1	475	\N	ADDIS ABABA	475
488	Sr. EDEN WORKU 	\N	\N	AWARDEE	HEW	N/A	910146159	9	4	\N	\N	4	\N	\N	\N	\N	2025-06-17 19:29:12	2025-06-17 19:29:12	t	ARM2690013	t	\N	\N	\N	2	476	\N	ADDIS ABABA	476
489	HEW-AWARDEE	\N	\N	AWARDEE	AWARDEE	N/A	912333918	9	3	\N	\N	3	\N	\N	\N	\N	2025-06-18 19:29:12	2025-06-18 19:29:12	t	ARM2690014	t	\N	\N	\N	3	477	\N	ADDIS ABABA	477
490	BIRARA HUNYALEW 	\N	\N	MOH	COORDINATOR 	N/A	911942339	10	4	\N	\N	4	\N	\N	\N	\N	2025-06-19 19:29:12	2025-06-19 19:29:12	t	ARM26100076	t	\N	\N	\N	3	478	\N	ADDIS ABABA	478
491	AGENCY DRIVER	\N	\N	ADDIS ABABA	DRIVER	N/A	N/A	10	6	\N	\N	6	\N	\N	\N	\N	2025-06-20 19:29:12	2025-06-20 19:29:12	t	ARM26100077	t	\N	\N	\N	5	479	\N	ADDIS ABABA	479
576	Mr. belay endashaw	\N	\N	MoH	AWARDEE	abinetsei@gmial.com1	9121212	9	5	\N	\N	5	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2690015	\N	\N	\N	\N	1	576	\N	Addis Ababa	564
577	Prof. Nega Assefa	\N	\N	MoH	AWARDEE	abinetsei@gmial.com2	9121212	9	5	\N	\N	5	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2690016	\N	\N	\N	\N	1	577	\N	Addis Ababa	565
579	Mr. Dereje Abdena Bayisa	\N	\N	MoH	AWARDEE	abinetsei@gmial.com4	9121212	9	5	\N	\N	5	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2690018	\N	\N	\N	\N	1	579	\N	Addis Ababa	567
580	Emebet Demme	\N	\N	MoH	Coordinator	Emebetdeme221@gmail.com	910164007	10	5	\N	\N	5	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM26100149	\N	\N	\N	\N	1	580	\N	Addis Ababa	568
581	Tesfyae Yiheyis	\N	\N	MoH	PMED- Desk	tesfayeyihes@gmail.com	911942340	2	5	\N	\N	5	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2620076	\N	\N	\N	\N	1	581	\N	Addis Ababa	569
582	Mlulatu Sisay	\N	\N	EHCF	CEO	ceo@ethiohealthfed.org	911692347	2	5	\N	\N	5	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2620077	\N	\N	\N	\N	1	582	\N	Addis Ababa	570
583	Dr Jemal Aliyi	\N	\N	MOH	Exhibitor	abinetsei@gmial.com5	9121212	2	5	\N	\N	5	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2620078	\N	\N	\N	\N	1	583	\N	Addis Ababa	571
584	Dr Zebideru Zewdie Abebe	\N	\N	MOH	Exhibitor	abinetsei@gmial.com6	9121212	2	5	\N	\N	5	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2620079	\N	\N	\N	\N	1	584	\N	Addis Ababa	572
585	Tarkegn Negesse Soroto	\N	\N	MOH	Exhibitor	abinetsei@gmial.com7	9121212	2	5	\N	\N	5	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2620080	\N	\N	\N	\N	1	585	\N	Addis Ababa	573
586	Meron Abdurahman	\N	\N	MOH	Exhibitor	abinetsei@gmial.com8	9121212	2	5	\N	\N	5	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2620081	\N	\N	\N	\N	1	586	\N	Addis Ababa	574
587	Dr Biruk Melesse	\N	\N	MOH	Exhibitor	abinetsei@gmial.com9	9121212	2	5	\N	\N	5	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2620082	\N	\N	\N	\N	1	587	\N	Addis Ababa	575
588	Mohammed Aliyu	\N	\N	MOH	Exhibitor	abinetsei@gmial.com10	9121212	2	5	\N	\N	5	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2620083	\N	\N	\N	\N	1	588	\N	Addis Ababa	576
589	Dr. Tiruwork Fikade	\N	\N	MoH	AWARDEE	abinetsei@gmial.com11	9121212	9	4	\N	\N	4	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2690019	\N	\N	\N	\N	3	589	\N	Addis Ababa	577
590	Prof. Damte Shimels	\N	\N	MoH	AWARDEE	abinetsei@gmial.com12	9121212	9	4	\N	\N	4	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2690020	\N	\N	\N	\N	3	590	\N	Addis Ababa	578
591	Mr. Binyam Teshale	\N	\N	MoH	AWARDEE	abinetsei@gmial.com13	9121212	9	4	\N	\N	4	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2690021	\N	\N	\N	\N	3	591	\N	Addis Ababa	579
592	Senayit Eshete	\N	\N	MoH	Coordinator	senayiteshete@gmail.com	910164006	10	4	\N	\N	4	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM26100150	\N	\N	\N	\N	3	592	\N	Addis Ababa	580
593	Mengistu Demissie	\N	\N	EHCF	President SE Ethiopia	gujaraguzhe@gmail.com	912133529	2	4	\N	\N	4	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2620084	\N	\N	\N	\N	3	593	\N	Addis Ababa	581
594	Kassahun Sime	\N	\N	MOH	Exhibitor	abinetsei@gmial.com14	9121212	2	4	\N	\N	4	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2620085	\N	\N	\N	\N	3	594	\N	Addis Ababa	582
595	Gashanew Asrat	\N	\N	MOH	Exhibitor	abinetsei@gmial.com15	9121212	2	4	\N	\N	4	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2620086	\N	\N	\N	\N	3	595	\N	Addis Ababa	583
596	Alem Abera Tefera	\N	\N	MOH	Exhibitor	abinetsei@gmial.com16	9121212	2	4	\N	\N	4	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2620087	\N	\N	\N	\N	3	596	\N	Addis Ababa	584
597	Dr. Zeleke Gobena	\N	\N	MoH	AWARDEE	abinetsei@gmial.com17	9121212	9	2	\N	\N	2	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2690022	\N	\N	\N	\N	4	597	\N	Addis Ababa	585
598	Dr. Fikrte Abera	\N	\N	MoH	AWARDEE	abinetsei@gmial.com18	9121212	9	2	\N	\N	2	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2690023	\N	\N	\N	\N	4	598	\N	Addis Ababa	586
599	Dr. Sisay Yifru	\N	\N	MoH	AWARDEE	abinetsei@gmial.com19	9121212	9	2	\N	\N	2	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2690024	\N	\N	\N	\N	4	599	\N	Addis Ababa	587
600	Dr. Masresha Tesema	\N	\N	MoH	AWARDEE	abinetsei@gmial.com20	9121212	9	2	\N	\N	2	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2690025	\N	\N	\N	\N	4	600	\N	Addis Ababa	588
601	Dr. Kibrom G/Silassie	\N	\N	MoH	AWARDEE	abinetsei@gmial.com21	9121212	9	2	\N	\N	2	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2690026	\N	\N	\N	\N	4	601	\N	Addis Ababa	589
602	Fasika Gemeda	\N	\N	MoH	Coordinator	fasikagemeda91@gmail.com	912118474	10	2	\N	\N	2	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM26100151	\N	\N	\N	\N	4	602	\N	Addis Ababa	590
603	Dr. Girma Ababi	\N	\N	EHCF	Vice President	girmaababi20 I 8@gmail.com	091 1406346	2	2	\N	\N	2	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2620088	\N	\N	\N	\N	4	603	\N	Addis Ababa	591
604	Ermias Mulatu	\N	\N	MOH	Exhibitor	abinetsei@gmial.com22	9121212	2	2	\N	\N	2	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2620089	\N	\N	\N	\N	4	604	\N	Addis Ababa	592
605	Melkamu Ayale Kokobe	\N	\N	MOH	Exhibitor	abinetsei@gmial.com23	9121212	2	2	\N	\N	2	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2620090	\N	\N	\N	\N	4	605	\N	Addis Ababa	593
606	Dr Abebaw	\N	\N	MOH	Exhibitor	abinetsei@gmial.com24	9121212	2	2	\N	\N	2	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2620091	\N	\N	\N	\N	4	606	\N	Addis Ababa	594
607	Dr Yibeltal Tebeka	\N	\N	MOH	Exhibitor	abinetsei@gmial.com25	9121212	2	2	\N	\N	2	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2620092	\N	\N	\N	\N	4	607	\N	Addis Ababa	595
608	Dr Girma Tadesse Birru	\N	\N	MOH	Exhibitor	abinetsei@gmial.com26	9121212	2	2	\N	\N	2	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2620093	\N	\N	\N	\N	4	608	\N	Addis Ababa	596
609	Mulugeta Debele	\N	\N	MOH	Exhibitor	abinetsei@gmial.com27	9121212	2	2	\N	\N	2	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2620094	\N	\N	\N	\N	4	609	\N	Addis Ababa	597
562	Gemu Tiru	\N	\N	MOH	MoH-HSIQ	Gemu.Tiru@moh.gov.et	919118871	7	5	\N	\N	5	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2670020	t	\N	\N	\N	4	561	\N	ADDIS ABABA	550
563	Dr. Abdi Amin	\N	\N	Haremaya University	Chief Cllinical director	abdi5116@gmail.com	915046933	2	1	\N	\N	1	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2620072	t	\N	\N	\N	2	562	\N	ADDIS ABABA	551
564	Dr. Hiwot Solomon	\N	\N	MOH	DPC-LEO	Hiwot.Solom@moh.gov.et	910164007	2	2	\N	\N	2	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2620073	t	\N	\N	\N	2	563	\N	ADDIS ABABA	552
565	Eshete Yima	\N	\N	Consultant	Consultant	eshetyilma@gmail.com	944734288	1	1	\N	\N	1	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610100	t	\N	\N	\N	2	564	\N	ADDIS ABABA	553
566	Dr. Desalegn melese	\N	\N	WCAH/University of Manitoba	Consultant	Delsalegn.Melese@Umanitoba.ca	912690345	1	1	\N	\N	1	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610100	t	\N	\N	\N	2	565	\N	ADDIS ABABA	554
567	Tigist Mekonnen	\N	\N	EMA	, Executive Director	tigist@ethiopianmedicalass.org	911051222	1	1	\N	\N	1	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610100	t	\N	\N	\N	2	566	\N	ADDIS ABABA	555
568	Aboubacar Kampo	\N	\N	UNICEF	Country Director	Akmpo@unicef.org	911913456	1	3	\N	\N	3	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610100	t	\N	\N	\N	1	567	\N	ADDIS ABABA	556
569	Dr. Abiy Kiflie	\N	\N	IHI	Country Director	akiflie@ihi.org	912690336	1	4	\N	\N	4	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610100	t	\N	\N	\N	3	568	\N	ADDIS ABABA	557
263	Mr. Zelalem Mengistu 	\N	\N	Mathowos Wondu CA 	 Program Director	zelalemM@mathiwos.org	0911342908	1	2	\N	\N	2	\N	\N	\N	\N	2024-11-04 19:29:12	2024-11-04 19:29:12	t	ARM2610100	t	\N	\N	\N	4	251	\N	AA	251
610	Zeine Abosse	\N	\N	MOH	Exhibitor	abinetsei@gmial.com28	9121212	2	2	\N	\N	2	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2620095	\N	\N	\N	\N	4	610	\N	Addis Ababa	598
252	Henock Gezahegn	\N	\N	FHI360	Country Representative	hgezahegn@fhi360.org	0984876364	1	2	\N	\N	2	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610100	t	\N	\N	\N	4	240	\N	AA	240
611	Lopez Fajardo Juliana	\N	\N	Embassy of Canada	Deputy Dir./Counsellor	Juliana.LopezFajardo@international.gc.ca	911942339	1	2	\N	\N	2	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610100	\N	\N	\N	\N	4	611	\N	Addis Ababa	599
578	Prof. HaileMekael Desalegn	\N	\N	MoH	AWARDEE	abinetsei@gmial.com3	9121212	9	5	\N	\N	5	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2690017	\N	\N	\N	\N	1	578	\N	Addis Ababa	566
561	F. MINISTER  DRIVER 	\N	\N	FEDERAL MINISTER  	DRIVER	N/A	N/A	10	6	\N	\N	6	\N	\N	\N	\N	2025-08-29 19:29:12	2025-08-29 19:29:12	t	ARM26100147	t	\N	\N	\N	5	549	\N	FEDERAL MINISTER  	549
2000	Zelalem Worku	\N	2024-10-28	Addis Ababa	DH -Supply Chain Focal	zolawk@gmail.com	0912070871	10	3			3		f	f		2024-10-28 13:15:35.552432	2024-10-28 13:17:06.157709	t	ARM26100148	f	f	f	f	4	1	Addis Ababa	MoH	\N
3	Mr. Taiwo Oluyomi	\N	\N	ADDIS ABABA	Deputy Representative	oluyomi@unfpa.org	0944 026745	1	4	\N	\N	4	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610002	t	\N	\N	\N	3	3	\N	UNFPA	002
4	Nasir Ali	\N	\N	ADDIS ABABA	Country Director	naali@path.org	911735158	1	1	\N	\N	1	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610003	t	\N	\N	\N	1	4	\N	PATH Ethiopia	003
5	Mr. Basaznew Terefe	\N	\N	ADDIS ABABA	1hips Specialist	basazinewt@unops.org	910580564	1	5	\N	\N	5	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610004	t	\N	\N	\N	2	6	\N	UNOPS	005
6	Berhanu Assefa	\N	\N	ADDIS ABABA	1hips Specialis	BerhanuT@unops.org	911903051	1	2	\N	\N	2	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610005	t	\N	\N	\N	3	7	\N	UNOPS	006
200	Dr Amanuel Haile	\N	\N	Tigray Region	TRHB- Head	amanchs133@gmail.com	911432481	1	1	\N	\N	1	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610090	t	\N	\N	\N	2	99	\N	TRHB	098
253	Semra Asefa 	\N	\N	Embassy of Canada GF	Cosnsultant 	semra.asefa@gmail.com	0929137707	1	4	\N	\N	4	\N	\N	\N	\N	2024-10-25 19:29:12	2024-10-25 19:29:12	t	ARM2610100	t	\N	\N	\N	3	241	\N	ADDIS ABABA	241
254	Dr Mekonnen Admassu	\N	\N	WHO	Program Officer	kaluwao@who.in	0911157593	1	5	\N	\N	5	\N	\N	\N	\N	2024-10-26 19:29:12	2024-10-26 19:29:12	t	ARM2610100	t	\N	\N	\N	1	242	\N	ADDIS ABABA	242
255	Eshete Yima	\N	\N	Consultant 	Advisor 	eshetyilma@gmail.com 	0929137709	1	3	\N	\N	3	\N	\N	\N	\N	2024-10-27 19:29:12	2024-10-27 19:29:12	t	ARM2610100	t	\N	\N	\N	1	243	\N	ADDIS ABABA	243
266	Tsedeke Mathewos	\N	\N	GFF	advisor	tmasebo@worldbank.org	0911268689	1	3	\N	\N	3	\N	\N	\N	\N	2024-11-07 19:29:12	2024-11-07 19:29:12	t	ARM2610100	t	\N	\N	\N	1	254	\N	ADDIS ABABA	254
272	Dr.Fasil Nigussie	\N	\N	FCDO	advisor 	Fasil.Nigussie@fcdo.gov.uk	0912-163174	1	4	\N	\N	4	\N	\N	\N	\N	2024-11-13 19:29:12	2024-11-13 19:29:12	t	ARM2610100	t	\N	\N	\N	1	260	\N	ADDIS ABABA	260
273	Hannah Binci	\N	\N	FCDO	Team Leader HCD	Hannah.Binci@fcdo.gov.uk	0955722085	1	2	\N	\N	2	\N	\N	\N	\N	2024-11-14 19:29:12	2024-11-14 19:29:12	t	ARM2610100	t	\N	\N	\N	2	261	\N	ADDIS ABABA	261
274	Dr. Lydia Tesfaye	\N	\N	FCDO	Health Advisor	Lydia.Tesfaye@fcdo.gov.uk	0955722085	1	3	\N	\N	3	\N	\N	\N	\N	2024-11-15 19:29:12	2024-11-15 19:29:12	t	ARM2610100	t	\N	\N	\N	4	262	\N	ADDIS ABABA	262
275	Robin Gorna	\N	\N	FCDO	Advisor	Robin.Gorna@fcdo.gov.uk	0955722085	1	4	\N	\N	4	\N	\N	\N	\N	2024-11-16 19:29:12	2024-11-16 19:29:12	t	ARM2610100	t	\N	\N	\N	3	263	\N	ADDIS ABABA	263
280	Beatrice NERI	\N	\N	EU Delegation	Head of Sector	Beatrice.NERI@eeas.europa.eu	+251 116 612511	1	3	\N	\N	3	\N	\N	\N	\N	2024-11-21 19:29:12	2024-11-21 19:29:12	t	ARM2610100	t	\N	\N	\N	3	268	\N	ADDIS ABABA	268
285	Ms. Jennifer Mika	\N	\N	CDC Ethiopia	Country Directo	 ziz5@cdc.gov	+251.904.032.336	1	5	\N	\N	5	\N	\N	\N	\N	2024-11-26 19:29:12	2024-11-26 19:29:12	t	ARM2610100	t	\N	\N	\N	1	273	\N	ADDIS ABABA	273
2001	Ms. Alem Abera	\N	2024-10-28	Addis Ababa	Inrer. Op Spec.	alem.abera@moh.gov.et	0921493233	2	2			2		f	f		2024-10-28 13:22:09.466725	2024-10-28 13:24:42.334726	t	ARM2620074	t	f	f	f	3	1	Addis Ababa	MoH	\N
2002	Habib Bushira	\N	2024-10-28	Addis Ababa	Sr. DH Arch. Spec.	habib.bushra@gmail.com	0904299209	2	2			2		f	f		2024-10-28 13:23:52.967996	2024-10-28 13:24:49.808224	t	ARM2620075	t	f	f	f	2	1	Addis Ababa	MoH	\N
264	Kidest Hailu	\N	\N	AIHA	Country Director 	khailu@aiha-et.com	0911342900	1	4	\N	\N	4	\N	\N	\N	\N	2024-11-05 19:29:12	2024-11-05 19:29:12	t	ARM2610100	t	\N	\N	\N	3	252	\N	AA	252
265	Dinksera Debebe	\N	\N	GFF	 Liaison officer	dmekuria@worldbank.org	0911268688	1	1	\N	\N	1	\N	\N	\N	\N	2024-11-06 19:29:12	2024-11-06 19:29:12	t	ARM2610100	t	\N	\N	\N	1	253	\N	AA	253
267	Dr. Awoke Tasew	\N	\N	UNFPA	As. Representative/PA	tasewtebeje@unfpa.org	0944 122326 	1	5	\N	\N	5	\N	\N	\N	\N	2024-11-08 19:29:12	2024-11-08 19:29:12	t	ARM2610100	t	\N	\N	\N	1	255	\N	AA	255
268	Worknesh Mekonnen	\N	\N	UNOPS	Country Director	workneshg@unops.org	0911512306 	1	3	\N	\N	3	\N	\N	\N	\N	2024-11-09 19:29:12	2024-11-09 19:29:12	t	ARM2610100	t	\N	\N	\N	1	256	\N	AA	256
269	Ms. KWAK Hyemin	\N	\N	KOFIH ET 	Deputy Country Director 	hemina3675@kofih.org	977160968	1	2	\N	\N	2	\N	\N	\N	\N	2024-11-10 19:29:12	2024-11-10 19:29:12	t	ARM2610100	t	\N	\N	\N	2	257	\N	AA	257
270	Dr. Zenebe Melaku	\N	\N	ICAP	Country Director	zy2115@cumc.columbia.edu	0911-225347 	1	3	\N	\N	3	\N	\N	\N	\N	2024-11-11 19:29:12	2024-11-11 19:29:12	t	ARM2610100	t	\N	\N	\N	1	258	\N	AA	258
271	Professor Sileshi	\N	\N	ICAP	Management team 	sl2883@cumc.columbia.edu	251-911-228496	1	5	\N	\N	5	\N	\N	\N	\N	2024-11-12 19:29:12	2024-11-12 19:29:12	t	ARM2610100	t	\N	\N	\N	3	259	\N	AA	259
276	Dr. Girum Hailu	\N	\N	IGAD	Regional Coordinator	girum.hailu@igad.int	0911214588	1	2	\N	\N	2	\N	\N	\N	\N	2024-11-17 19:29:12	2024-11-17 19:29:12	t	ARM2610100	t	\N	\N	\N	1	264	\N	AA	264
277	Kidist Hailu 	\N	\N	AIHA	Country   Director 	khailu@aiha-et.com	 0911-142730	1	5	\N	\N	5	\N	\N	\N	\N	2024-11-18 19:29:12	2024-11-18 19:29:12	t	ARM2610100	t	\N	\N	\N	4	265	\N	AA	265
278	Mr. Eshett Degefa	\N	\N	UNAIDS	Country Director 	TokonE@unaids.org	0911508725	1	1	\N	\N	1	\N	\N	\N	\N	2024-11-19 19:29:12	2024-11-19 19:29:12	t	ARM2610100	t	\N	\N	\N	1	266	\N	AA	266
279	Abebe Kebede	\N	\N	CORHA	Executive director	abe_keb@yahoo.com	0911228516	1	5	\N	\N	5	\N	\N	\N	\N	2024-11-20 19:29:12	2024-11-20 19:29:12	t	ARM2610100	t	\N	\N	\N	2	267	\N	AA	267
281	Roman Tesfaye	\N	\N	World Bank	Senior Operations Officer	rtesfaye@worldbank.org	0931573222	1	2	\N	\N	2	\N	\N	\N	\N	2024-11-22 19:29:12	2024-11-22 19:29:12	t	ARM2610100	t	\N	\N	\N	4	269	\N	AA	269
282	Kidist Kebebe	\N	\N	World Bank	Senior Health Specialist	kdemissie@worldbank.org	0912633760	1	4	\N	\N	4	\N	\N	\N	\N	2024-11-23 19:29:12	2024-11-23 19:29:12	t	ARM2610100	t	\N	\N	\N	2	270	\N	AA	270
283	Wubedel Dereje	\N	\N	World Bank	Senior Health Specialist	walemu@worldbank.org	0921666617	1	5	\N	\N	5	\N	\N	\N	\N	2024-11-24 19:29:12	2024-11-24 19:29:12	t	ARM2610100	t	\N	\N	\N	3	271	\N	AA	271
570	Girma Assefa	\N	\N	Resolve to Save Live	Interim Country Director	gdessie@resolvetosavelives.org	911754191	1	4	\N	\N	4	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610100	t	\N	\N	\N	3	569	\N	ADDIS ABABA	558
571	Sintayehu Abebe	\N	\N	AMREF	RMMCAYH Promgram	SintayehuAbebe@gmail.com	966904343	1	4	\N	\N	4	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610100	t	\N	\N	\N	3	570	\N	ADDIS ABABA	559
572	Samuel Yalew	\N	\N	Master Card Foundation	Senior Director	syalewadela@mastercard.fdn.org	\N	1	5	\N	\N	5	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610100	t	\N	\N	\N	4	571	\N	ADDIS ABABA	560
573	Yibelta Kifle	\N	\N	MERQ	Consultant	yibeltal.k@merqconsultancy.org	912690345	1	5	\N	\N	5	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610100	t	\N	\N	\N	4	572	\N	ADDIS ABABA	561
574	Luca Carpintieri	\N	\N	Ambasciata d’Italia a Addis Abeba	Deputy Head of Mission	luca.carpintieri@esteri.it	0 11 1235682	1	1	\N	\N	1	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610100	t	\N	\N	\N	2	573	\N	ADDIS ABABA	562
575	Dinkneh Bikilla	\N	\N	CHAI	Program manage r	dinknehbikilla@gmail.com	910164007	1	2	\N	\N	2	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610100	t	\N	\N	\N	2	574	\N	ADDIS ABABA	563
256	Dr. Abiy Kiflie 	\N	\N	IHI	Country Director 	akiflie@ihi.org 	0912690336	1	4	\N	\N	4	\N	\N	\N	\N	2024-10-28 19:29:12	2024-10-28 19:29:12	t	ARM2610100	t	\N	\N	\N	3	244	\N	AA	244
257	Dr Haimanot Ambelu	\N	\N	WHO	Program Officer/MCH	malumos@who.int	0911157593	1	4	\N	\N	4	\N	\N	\N	\N	2024-10-29 19:29:12	2024-10-29 19:29:12	t	ARM2610100	t	\N	\N	\N	3	245	\N	AA	245
258	Dr Kassu Ketema	\N	\N	WHO	Program Officer/HS	nambiarb@who.int	0911157593	1	3	\N	\N	3	\N	\N	\N	\N	2024-10-30 19:29:12	2024-10-30 19:29:12	t	ARM2610100	t	\N	\N	\N	1	246	\N	AA	246
259	Mr. Mengistab Teferi	\N	\N	WHO	Program Officer/EDM	nambiarb@who.int	0911157593	1	3	\N	\N	3	\N	\N	\N	\N	2024-10-31 19:29:12	2024-10-31 19:29:12	t	ARM2610100	t	\N	\N	\N	1	247	\N	AA	247
260	Dr Asmamaw Bezabih	\N	\N	WHO	Program Officer/NCD	solomonshiferaw@gmail.com	0911157593	1	1	\N	\N	1	\N	\N	\N	\N	2024-11-01 19:29:12	2024-11-01 19:29:12	t	ARM2610100	t	\N	\N	\N	1	248	\N	AA	248
261	Samuel  Yalew 	\N	\N	Master Card Foun.	Senior Director 	syalewadela@mastercard.fdn.org 	0911157593	1	4	\N	\N	4	\N	\N	\N	\N	2024-11-02 19:29:12	2024-11-02 19:29:12	t	ARM2610100	t	\N	\N	\N	3	249	\N	AA	249
262	Girma Assefa	\N	\N	Resolve to Save Live	Interim Country Director	gdessie@resolvetosavelives.org	0911754191	1	4	\N	\N	4	\N	\N	\N	\N	2024-11-03 19:29:12	2024-11-03 19:29:12	t	ARM2610100	t	\N	\N	\N	3	250	\N	AA	250
526	MOH  DRIVER 	\N	\N	ADDIS ABABA	DRIVER	N/A	N/A	10	6	\N	\N	6	\N	\N	\N	\N	2025-07-25 19:29:12	2025-07-25 19:29:12	t	ARM26100112	t	\N	\N	\N	5	514	\N	ADDIS ABABA	514
527	MOH  DRIVER 	\N	\N	ADDIS ABABA	DRIVER	N/A	N/A	10	6	\N	\N	6	\N	\N	\N	\N	2025-07-26 19:29:12	2025-07-26 19:29:12	t	ARM26100113	t	\N	\N	\N	5	515	\N	ADDIS ABABA	515
528	MOH  DRIVER 	\N	\N	ADDIS ABABA	DRIVER	N/A	N/A	10	6	\N	\N	6	\N	\N	\N	\N	2025-07-27 19:29:12	2025-07-27 19:29:12	t	ARM26100114	t	\N	\N	\N	5	516	\N	ADDIS ABABA	516
529	MOH  DRIVER 	\N	\N	ADDIS ABABA	DRIVER	N/A	N/A	10	6	\N	\N	6	\N	\N	\N	\N	2025-07-28 19:29:12	2025-07-28 19:29:12	t	ARM26100115	t	\N	\N	\N	5	517	\N	ADDIS ABABA	517
530	MOH  DRIVER 	\N	\N	ADDIS ABABA	DRIVER	N/A	N/A	10	6	\N	\N	6	\N	\N	\N	\N	2025-07-29 19:29:12	2025-07-29 19:29:12	t	ARM26100116	t	\N	\N	\N	5	518	\N	ADDIS ABABA	518
531	MOH  DRIVER 	\N	\N	ADDIS ABABA	DRIVER	N/A	N/A	10	6	\N	\N	6	\N	\N	\N	\N	2025-07-30 19:29:12	2025-07-30 19:29:12	t	ARM26100117	t	\N	\N	\N	5	519	\N	ADDIS ABABA	519
532	MOH  DRIVER 	\N	\N	ADDIS ABABA	DRIVER	N/A	N/A	10	6	\N	\N	6	\N	\N	\N	\N	2025-07-31 19:29:12	2025-07-31 19:29:12	t	ARM26100118	t	\N	\N	\N	5	520	\N	ADDIS ABABA	520
533	MOH  DRIVER 	\N	\N	ADDIS ABABA	DRIVER	N/A	N/A	10	6	\N	\N	6	\N	\N	\N	\N	2025-08-01 19:29:12	2025-08-01 19:29:12	t	ARM26100119	t	\N	\N	\N	5	521	\N	ADDIS ABABA	521
534	MOH  DRIVER 	\N	\N	ADDIS ABABA	DRIVER	N/A	N/A	10	6	\N	\N	6	\N	\N	\N	\N	2025-08-02 19:29:12	2025-08-02 19:29:12	t	ARM26100120	t	\N	\N	\N	5	522	\N	ADDIS ABABA	522
535	MOH  DRIVER 	\N	\N	ADDIS ABABA	DRIVER	N/A	N/A	10	6	\N	\N	6	\N	\N	\N	\N	2025-08-03 19:29:12	2025-08-03 19:29:12	t	ARM26100121	t	\N	\N	\N	5	523	\N	ADDIS ABABA	523
536	MOH  DRIVER 	\N	\N	ADDIS ABABA	DRIVER	N/A	N/A	10	6	\N	\N	6	\N	\N	\N	\N	2025-08-04 19:29:12	2025-08-04 19:29:12	t	ARM26100122	t	\N	\N	\N	5	524	\N	ADDIS ABABA	524
537	MOH  DRIVER 	\N	\N	ADDIS ABABA	DRIVER	N/A	N/A	10	6	\N	\N	6	\N	\N	\N	\N	2025-08-05 19:29:12	2025-08-05 19:29:12	t	ARM26100123	t	\N	\N	\N	5	525	\N	ADDIS ABABA	525
538	MOH  DRIVER 	\N	\N	ADDIS ABABA	DRIVER	N/A	N/A	10	6	\N	\N	6	\N	\N	\N	\N	2025-08-06 19:29:12	2025-08-06 19:29:12	t	ARM26100124	t	\N	\N	\N	5	526	\N	ADDIS ABABA	526
539	MOH  DRIVER 	\N	\N	ADDIS ABABA	DRIVER	N/A	N/A	10	6	\N	\N	6	\N	\N	\N	\N	2025-08-07 19:29:12	2025-08-07 19:29:12	t	ARM26100125	t	\N	\N	\N	5	527	\N	ADDIS ABABA	527
540	MOH  DRIVER 	\N	\N	ADDIS ABABA	DRIVER	N/A	N/A	10	6	\N	\N	6	\N	\N	\N	\N	2025-08-08 19:29:12	2025-08-08 19:29:12	t	ARM26100126	t	\N	\N	\N	5	528	\N	ADDIS ABABA	528
541	MOH  DRIVER 	\N	\N	ADDIS ABABA	DRIVER	N/A	N/A	10	6	\N	\N	6	\N	\N	\N	\N	2025-08-09 19:29:12	2025-08-09 19:29:12	t	ARM26100127	t	\N	\N	\N	5	529	\N	ADDIS ABABA	529
542	MOH  DRIVER 	\N	\N	ADDIS ABABA	DRIVER	N/A	N/A	10	6	\N	\N	6	\N	\N	\N	\N	2025-08-10 19:29:12	2025-08-10 19:29:12	t	ARM26100128	t	\N	\N	\N	5	530	\N	ADDIS ABABA	530
543	MOH  DRIVER 	\N	\N	ADDIS ABABA	DRIVER	N/A	N/A	10	6	\N	\N	6	\N	\N	\N	\N	2025-08-11 19:29:12	2025-08-11 19:29:12	t	ARM26100129	t	\N	\N	\N	5	531	\N	ADDIS ABABA	531
544	MOH  DRIVER 	\N	\N	ADDIS ABABA	DRIVER	N/A	N/A	10	6	\N	\N	6	\N	\N	\N	\N	2025-08-12 19:29:12	2025-08-12 19:29:12	t	ARM26100130	t	\N	\N	\N	5	532	\N	ADDIS ABABA	532
545	MOH  DRIVER 	\N	\N	ADDIS ABABA	DRIVER	N/A	N/A	10	6	\N	\N	6	\N	\N	\N	\N	2025-08-13 19:29:12	2025-08-13 19:29:12	t	ARM26100131	t	\N	\N	\N	5	533	\N	ADDIS ABABA	533
546	SOUTH  R. DRIVER 	\N	\N	SOUTH  REGION 	DRIVER	N/A	N/A	10	6	\N	\N	6	\N	\N	\N	\N	2025-08-14 19:29:12	2025-08-14 19:29:12	t	ARM26100132	t	\N	\N	\N	5	534	\N	SOUTH  REGION 	534
547	SOUTH  R. DRIVER 	\N	\N	SOUTH  REGION 	DRIVER	N/A	N/A	10	6	\N	\N	6	\N	\N	\N	\N	2025-08-15 19:29:12	2025-08-15 19:29:12	t	ARM26100133	t	\N	\N	\N	5	535	\N	SOUTH  REGION 	535
548	SOUTH  R. DRIVER 	\N	\N	SOUTH  REGION 	DRIVER	N/A	N/A	10	6	\N	\N	6	\N	\N	\N	\N	2025-08-16 19:29:12	2025-08-16 19:29:12	t	ARM26100134	t	\N	\N	\N	5	536	\N	SOUTH  REGION 	536
549	SOUTH  R. DRIVER 	\N	\N	SOUTH  REGION 	DRIVER	N/A	N/A	10	6	\N	\N	6	\N	\N	\N	\N	2025-08-17 19:29:12	2025-08-17 19:29:12	t	ARM26100135	t	\N	\N	\N	5	537	\N	SOUTH  REGION 	537
550	SOUTH  R. DRIVER 	\N	\N	SOUTH  REGION 	DRIVER	N/A	N/A	10	6	\N	\N	6	\N	\N	\N	\N	2025-08-18 19:29:12	2025-08-18 19:29:12	t	ARM26100136	t	\N	\N	\N	5	538	\N	SOUTH  REGION 	538
551	SOUTH  R. DRIVER 	\N	\N	SOUTH  REGION 	DRIVER	N/A	N/A	10	6	\N	\N	6	\N	\N	\N	\N	2025-08-19 19:29:12	2025-08-19 19:29:12	t	ARM26100137	t	\N	\N	\N	5	539	\N	SOUTH  REGION 	539
552	SOUTH  R. DRIVER 	\N	\N	SOUTH  REGION 	DRIVER	N/A	N/A	10	6	\N	\N	6	\N	\N	\N	\N	2025-08-20 19:29:12	2025-08-20 19:29:12	t	ARM26100138	t	\N	\N	\N	5	540	\N	SOUTH  REGION 	540
553	SOUTH  R. DRIVER 	\N	\N	SOUTH  REGION 	DRIVER	N/A	N/A	10	6	\N	\N	6	\N	\N	\N	\N	2025-08-21 19:29:12	2025-08-21 19:29:12	t	ARM26100139	t	\N	\N	\N	5	541	\N	SOUTH  REGION 	541
554	SOUTH  R. DRIVER 	\N	\N	SOUTH  REGION 	DRIVER	N/A	N/A	10	6	\N	\N	6	\N	\N	\N	\N	2025-08-22 19:29:12	2025-08-22 19:29:12	t	ARM26100140	t	\N	\N	\N	5	542	\N	SOUTH  REGION 	542
555	SOUTH  R. DRIVER 	\N	\N	SOUTH  REGION 	DRIVER	N/A	N/A	10	6	\N	\N	6	\N	\N	\N	\N	2025-08-23 19:29:12	2025-08-23 19:29:12	t	ARM26100141	t	\N	\N	\N	5	543	\N	SOUTH  REGION 	543
556	SOUTH  R. DRIVER 	\N	\N	SOUTH  REGION 	DRIVER	N/A	N/A	10	6	\N	\N	6	\N	\N	\N	\N	2025-08-24 19:29:12	2025-08-24 19:29:12	t	ARM26100142	t	\N	\N	\N	5	544	\N	SOUTH  REGION 	544
557	F. MINISTER  DRIVER 	\N	\N	FEDERAL MINISTER  	DRIVER	N/A	N/A	10	6	\N	\N	6	\N	\N	\N	\N	2025-08-25 19:29:12	2025-08-25 19:29:12	t	ARM26100143	t	\N	\N	\N	5	545	\N	FEDERAL MINISTER  	545
558	F. MINISTER  DRIVER 	\N	\N	FEDERAL MINISTER  	DRIVER	N/A	N/A	10	6	\N	\N	6	\N	\N	\N	\N	2025-08-26 19:29:12	2025-08-26 19:29:12	t	ARM26100144	t	\N	\N	\N	5	546	\N	FEDERAL MINISTER  	546
559	F. MINISTER  DRIVER 	\N	\N	FEDERAL MINISTER  	DRIVER	N/A	N/A	10	6	\N	\N	6	\N	\N	\N	\N	2025-08-27 19:29:12	2025-08-27 19:29:12	t	ARM26100145	t	\N	\N	\N	5	547	\N	FEDERAL MINISTER  	547
560	F. MINISTER  DRIVER 	\N	\N	FEDERAL MINISTER  	DRIVER	N/A	N/A	10	6	\N	\N	6	\N	\N	\N	\N	2025-08-28 19:29:12	2025-08-28 19:29:12	t	ARM26100146	t	\N	\N	\N	5	548	\N	FEDERAL MINISTER  	548
284	Ms.Thais González	\N	\N	Spanish AECID	Country Representative	thais.gonzalez@aecid.es	09700433629	1	2	\N	\N	2	\N	\N	\N	\N	2024-11-25 19:29:12	2024-11-25 19:29:12	t	ARM2610100	t	\N	\N	\N	2	272	\N	AA	272
321	Mrs. Ashereka Digga 	\N	\N	PMO	Wing Desk Coordinator	umumasoud1434@gmail.com	0913390246	2	4	\N	\N	4	\N	\N	\N	\N	2025-01-01 19:29:12	2025-01-01 19:29:12	t	ARM2620049	t	\N	\N	\N	2	309	\N	AA	309
322	Mr. Teshome Debero 	\N	\N	PMO	Wing Desk T. Advisor 	tdebero@yahoo.com	0913662056	2	5	\N	\N	5	\N	\N	\N	\N	2025-01-02 19:29:12	2025-01-02 19:29:12	t	ARM2620050	t	\N	\N	\N	3	310	\N	AA	310
323	Sr. Hirut Imbiale	\N	\N	HPR	Higher Gender Expert	hirunalin@gmail.Com	0938039150	4	4	\N	\N	4	\N	\N	\N	\N	2025-01-03 19:29:12	2025-01-03 19:29:12	t	ARM2640046	t	\N	\N	\N	1	311	\N	AA	311
326	Alebel Dessie 	\N	\N	Policy Institute 	Deputy Director 	bantam2011luck@gmail.com	ዐ9299ዐ778ዐ	2	1	\N	\N	1	\N	\N	\N	\N	2025-01-06 19:29:12	2025-01-06 19:29:12	t	ARM2620053	t	\N	\N	\N	3	314	\N	AA	314
344	Maleda Tefera (PhD)	\N	\N	ENA	Board President 	maledaifa21@gmail.com	0911947792	2	1	\N	\N	1	\N	\N	\N	\N	2025-01-24 19:29:12	2025-01-24 19:29:12	t	ARM2620067	t	\N	\N	\N	3	332	\N	AA	332
347	Tesfaye Seyifu 	\N	\N	CHAI	Senior Program Manager 	maledaifa21@gmail.com	0911947792	2	3	\N	\N	3	\N	\N	\N	\N	2025-01-27 19:29:12	2025-01-27 19:29:12	t	ARM2620070	t	\N	\N	\N	2	335	\N	AA	335
349	Worknesh Mekonnen	\N	\N	UNOPS	Country Director	workneshg@unops.org	0911512306 	1	3	\N	\N	3	\N	\N	\N	\N	2025-01-29 19:29:12	2025-01-29 19:29:12	t	ARM2610100	t	\N	\N	\N	1	337	\N	AA	337
39	Dawit Abraham (Dr)	\N	\N	ADDIS ABABA	Country Representative	dtsegaye@projecthope.org	0911 24 0131	1	5	\N	\N	5	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610038	t	\N	\N	\N	3	56	\N	Project HOPE	055
42	Ato Edmealem Ejigu	\N	\N	ADDIS ABABA	Country Director	eejigu@ghsc-psm.org	966269995	1	2	\N	\N	2	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610041	t	\N	\N	\N	1	59	\N	GHSC-PSM	058
79	Mr. Mena Mekuria	\N	\N	South Ethiopia	SERHB- Vice Haed	menam1958@yahoo.com	911836784	2	4	\N	\N	4	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2620013	t	\N	\N	\N	3	112	\N	SERHB	111
80	Mr. Tegegn Chote	\N	\N	South Ethiopia	SWRHB- PMED	tegegn.chote@yahoo.com	913496040	2	3	\N	\N	3	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2620014	t	\N	\N	\N	2	113	\N	SERHB	112
122	Dr, Shalo Daba	\N	\N	Addis Ababa	Minister office	,ShaloDaba@gmail.com	9111211	3	3	\N	\N	3	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2630014	t	\N	\N	\N	4	165	\N	MoH	166
7	Dr. Zelalem Tadesse	\N	\N	ADDIS ABABA	CoP, USAID Amh KP A.	Zelalemtadesse@beza-posterity.org	917823722	1	1	\N	\N	1	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610006	t	\N	\N	\N	1	8	\N	Beza PDO	007
8	Mary Healy	\N	\N	ADDIS ABABA	PM Health & Nutrition	Mary.Healy@dfa.ie	911512589	1	3	\N	\N	3	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610007	t	\N	\N	\N	4	9	\N	Embassy of Ireland	008
9	Getachew Teshome (PhD)	\N	\N	ADDIS ABABA	Country Director	gteshome@popcouncil.org	967835905	1	4	\N	\N	4	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610008	t	\N	\N	\N	4	10	\N	The Population Council Inc.	009
11	Mr. Tamiru Kassa	\N	\N	ADDIS ABABA	Deputy country Director	ktamiru@yahoo.com	923254210	1	1	\N	\N	1	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610010	t	\N	\N	\N	2	13	\N	Emory University	012
12	Prof. Gurmessa Tura	\N	\N	ADDIS ABABA	Research & Doc. Co.	tkassa@emory.edu	923254211	1	1	\N	\N	1	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610011	t	\N	\N	\N	4	14	\N	Emory University	013
13	Mr. Daniel Chekol	\N	\N	ADDIS ABABA	Country Director	dchekol@vitalstrategies.org	91682044	1	2	\N	\N	2	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610012	t	\N	\N	\N	4	21	\N	Vital Strategies	020
14	Bereket Useman	\N	\N	ADDIS ABABA	Program Officer	BereketUseman.ET@jica.go.jp	913583247	1	3	\N	\N	3	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610013	t	\N	\N	\N	2	23	\N	JICA	022
15	Frank van de Looij	\N	\N	Addis Ababa	Exp. Health & SRHR	Frank-vande.looij@minbuza.nl	911504148	1	5	\N	\N	5	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610014	t	\N	\N	\N	3	25	\N	Netherlands Embassy	024
16	Arsema W/michael	\N	\N	Addis Ababa	Exp. SRHR & Gender	arsema.wmichael@minbuza.nl	944288717	1	2	\N	\N	2	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610015	t	\N	\N	\N	2	26	\N	Netherlands Embassy	025
17	Mrs. Shoa Girma	\N	\N	ADDIS ABABA	Country Director	shoa.girma@jhpiego.org	911605967	1	2	\N	\N	2	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610016	t	\N	\N	\N	3	28	\N	Jhpiego Ethiopia	027
18	Dr Damtew Woldemariam	\N	\N	ADDIS ABABA	RISE Project Director	Damtew.Woldemariam@jhpiego.org	911807682	1	3	\N	\N	3	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610017	t	\N	\N	\N	4	29	\N	Jhpiego Ethiopia	028
19	Dr Della Berhanu	\N	\N	ADDIS ABABA	ARC Project Director	Della.Berhanu@jhpiego.org	926783038	1	4	\N	\N	4	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610018	t	\N	\N	\N	2	30	\N	Jhpiego Ethiopia	029
20	Dr Daniel Dejene	\N	\N	ADDIS ABABA	Deputy Chief of Party	Daniel.Dejene@jhpiego.org	911308713	1	5	\N	\N	5	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610019	t	\N	\N	\N	1	31	\N	Jhpiego Ethiopia	030
21	Dr Tegbar Yigzaw	\N	\N	ADDIS ABABA	HWIP Chief of Party	tegbar.yigzaw@jhpiego.org	911408682	1	1	\N	\N	1	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610020	t	\N	\N	\N	3	32	\N	Jhpiego Ethiopia	031
22	Daniel Getachew Kabtyimer	\N	\N	ADDIS ABABA	Senior Prog. Officer	dan.kabtyimer@gatesfoundation.org	0 944 143162	1	2	\N	\N	2	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610021	t	\N	\N	\N	4	33	\N	Bill & Melinda GF	032
23	Susna De	\N	\N	ADDIS ABABA	Deputy Dir.Health & Nutr.	Susna.De@gatesfoundation.org	0 911251349	1	2	\N	\N	2	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610022	t	\N	\N	\N	2	34	\N	Bill & Melinda GF	033
24	Dessalew Emaway	\N	\N	ADDIS ABABA	Country Repr.	dessalew_emaway@et.jsi.com	0911 36 4281	1	1	\N	\N	1	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610023	t	\N	\N	\N	4	35	\N	JSI L1OK	034
25	Melaku Muleta	\N	\N	ADDIS ABABA	Program manager	melaku.muleta@thinkplace.co.ke	911885881	1	2	\N	\N	2	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610024	t	\N	\N	\N	4	36	\N	Think place	035
26	Wubshet Denboba	\N	\N	ADDIS ABABA	PD-JSI - DUP	wubshet_denboba@et.jsi.com	911124908	1	2	\N	\N	2	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610025	t	\N	\N	\N	4	37	\N	JSI/DUP	036
27	Adane Letta (PhD)	\N	\N	ADDIS ABABA	Country Director	adane@habtechsolution.com	975164638	1	2	\N	\N	2	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610026	t	\N	\N	\N	2	38	\N	Habtech Soloution	037
28	Dr Abebe Shibru	\N	\N	ADDIS ABABA	Country Director	abebe.shibru@mariestopes.org.et	905051501	1	1	\N	\N	1	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610027	t	\N	\N	\N	1	39	\N	MSI Ethiopia	038
29	Tseday Alemseged	\N	\N	ADDIS ABABA	Strategic Info. Advisor	AlemsegedT@state.gov	935401465	1	3	\N	\N	3	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610028	t	\N	\N	\N	4	40	\N	PEPFAR ET Coord. Office	039
348	Dinkneh Bikila 	\N	\N	CHAI	Senior Program Manager 	maledaifa21@gmail.com	0946855955 	2	2	\N	\N	2	\N	\N	\N	\N	2025-01-28 19:29:12	2025-01-28 19:29:12	t	ARM2620071	t	\N	\N	\N	3	336	\N	AA	336
30	Abdurahman Ali	\N	\N	ADDIS ABABA	STEP GIZ Ethiopia	abdurahman.ali@giz.de	911633777	1	4	\N	\N	4	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610029	t	\N	\N	\N	3	41	\N	GIZ -Ethiopia	040
31	Dagim Damtew	\N	\N	ADDIS ABABA	County Repr.	martadagim@gmail.com	913385822	1	4	\N	\N	4	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610030	t	\N	\N	\N	4	43	\N	Global Fund CCM	042
32	Dr Abraham Endeshaw	\N	\N	ADDIS ABABA	Deputy Country Director	aendeshaw@clintonhealthaccess.org	901927228	1	5	\N	\N	5	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610031	t	\N	\N	\N	2	44	\N	CHAI	043
33	Dr Zelalem Demeke	\N	\N	ADDIS ABABA	Senior Program Manager	ZDemeke@clintonhealthaccess.org	901927229	1	5	\N	\N	5	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610032	t	\N	\N	\N	3	45	\N	CHAI	044
34	Dr Hailemariam Segni	\N	\N	ADDIS ABABA	President	Abiami1064@gmail.com	911408061	1	3	\N	\N	3	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610033	t	\N	\N	\N	1	46	\N	ESOG	045
35	Dr.Binyam Desta	\N	\N	ADDIS ABABA	CoP -USAID QHA	binyam_desta@et.jsi.com	912605658	1	2	\N	\N	2	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610034	t	\N	\N	\N	4	47	\N	JSI - Ethiopia	046
36	Habtamu Adane	\N	\N	ADDIS ABABA	Health Programme Manage	Habtamu.ADANE@eeas.europa.eu	#ERROR!	1	3	\N	\N	3	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610035	t	\N	\N	\N	1	48	\N	EU Delegation	047
37	Dr Abnet Zeleke	\N	\N	ADDIS ABABA	Director of Programs	abnet.zeleke@iphce.org	910121308	1	1	\N	\N	1	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610036	t	\N	\N	\N	2	50	\N	IfPHC-E	049
38	Misrak Makonnen	\N	\N	ADDIS ABABA	Country Director	misrak.makonnen@amref.org	911642458	1	1	\N	\N	1	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610037	t	\N	\N	\N	4	55	\N	Amref Health Africa	054
10	Nasir Ali	\N	\N	ADDIS ABABA	Country Repr.	nasir.hasen@thepalladiumgroup.com	911735158	1	2	\N	\N	2	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610009	t	\N	\N	\N	3	11	\N	Palladium	010
40	Frehiwot Nigatu (Dr)	\N	\N	ADDIS ABABA	CoP USAID ECA	FNigatu@projecthope.org	0940 716840	1	4	\N	\N	4	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610039	t	\N	\N	\N	2	57	\N	Project HOPE	056
41	Senait Zewdie	\N	\N	ADDIS ABABA	Nutrition Teal Lead	Senait.Zewdie@fao.org	911176395	1	3	\N	\N	3	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610040	t	\N	\N	\N	1	58	\N	FAO Ethiopia	057
43	Ato Habtamu Tesfaye	\N	\N	ADDIS ABABA	Deputy Country Dir.	HTesfaye@ghsc-psm.org	929939799	1	3	\N	\N	3	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610042	t	\N	\N	\N	4	60	\N	GHSC-PSM	059
44	Dr. Mengistu Asnake	\N	\N	ADDIS ABABA	Senior Country Dir.	Masnake@pathfinder.org	911227430	1	4	\N	\N	4	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610043	t	\N	\N	\N	2	61	\N	Pathfinder	060
45	Mr. Dereje Olana Dengela	\N	\N	ADDIS ABABA	Project CoP	dereje_dengela@abtassoc.com	911892758	1	1	\N	\N	1	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610044	t	\N	\N	\N	3	62	\N	PMI Evolve project.	061
46	Ms. Briana Lozano	\N	\N	ADDIS ABABA	Program Deputy Dir.	ihj0@cdc.gov	9040323370	1	4	\N	\N	4	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610045	t	\N	\N	\N	4	64	\N	CDC Ethiopia	063
50	Naod Wendrad	\N	\N	ADDIS ABABA	Chief of party	naod_wendrad@et.jsi.com	9944220900	1	2	\N	\N	2	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610049	t	\N	\N	\N	4	71	\N	JSI/DHA	070
51	Silas Muriungi Mukangu	\N	\N	ADDIS ABABA	Health Coordinator	simukangu@icrc.org	0944 33 51 14	1	3	\N	\N	3	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610050	t	\N	\N	\N	1	73	\N	ICRC	072
52	Jemal Kassaw	\N	\N	ADDIS ABABA	Country Repr.	JKassaw@engenderhealth.org	911697129	1	1	\N	\N	1	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610051	t	\N	\N	\N	2	74	\N	ENGENDER HEALTH	073
53	Dr. Abdulaziz Ali	\N	\N	ADDIS ABABA	CoP, USAID LHA	EWoldeamanuel@engenderhealth.org	911405380	1	1	\N	\N	1	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610052	t	\N	\N	\N	3	75	\N	ENGENDER HEALTH	074
54	Daniel Gemechu	\N	\N	ADDIS ABABA	Country Repr.	dgemechu@msh.org	911967091	1	3	\N	\N	3	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610053	t	\N	\N	\N	3	76	\N	MSH	075
55	Andualem Oumer	\N	\N	ADDIS ABABA	Tech. Advisor & Lead	aoumer@msh.org	911662948	1	1	\N	\N	1	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610054	t	\N	\N	\N	2	77	\N	MSH	076
56	Ms Laura Miglierina	\N	\N	ADDIS ABABA	Health Prog. Coord.	laura.miglierina@aics.gov.it	91220515	1	4	\N	\N	4	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610055	t	\N	\N	\N	4	78	\N	IADC	077
57	Mr Tibebe Akalu	\N	\N	ADDIS ABABA	Health Expert	tibebe.akalu@aics.gov.it	911670062	1	2	\N	\N	2	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610056	t	\N	\N	\N	2	79	\N	IADC	078
58	Dr. Yunis Mussema	\N	\N	ADDIS ABABA	FH Team Leader	ymussema@usaid.gov	944749389	1	1	\N	\N	1	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610057	t	\N	\N	\N	4	82	\N	USAID	081
59	Dr. Daniel G/Michael	\N	\N	ADDIS ABABA	HSS Team Leader	dgebremichael@usaid.gov	944143035	1	1	\N	\N	1	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610058	t	\N	\N	\N	2	83	\N	USAID	082
60	Tesfaye Ashagari	\N	\N	ADDIS ABABA	Sr. HCF Advisor	tashagari@usaid.gov	944136732	1	4	\N	\N	4	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610059	t	\N	\N	\N	2	84	\N	USAID	083
61	Dr. Guda Alemayehu	\N	\N	ADDIS ABABA	SBCC Specialist	galemayehu@usaid.gov	910353511	1	5	\N	\N	5	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610060	t	\N	\N	\N	3	85	\N	USAID	084
62	Dr. Peter Mumba	\N	\N	ADDIS ABABA	Malaria Team Leader	pmumba@usaid.gov	944136731	1	3	\N	\N	3	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610061	t	\N	\N	\N	4	86	\N	USAID	085
63	Dr. Yewulsew Kassie	\N	\N	ADDIS ABABA	Inf. Dis. Sr Advisor	ykassie@usaid.gov	930481587	1	4	\N	\N	4	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610062	t	\N	\N	\N	2	87	\N	USAID	086
64	Dr Sarai Malumo,	\N	\N	ADDIS ABABA	Cluster Lead, IMCH	malumos@who.int	9111211	1	4	\N	\N	4	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610063	t	\N	\N	\N	3	92	\N	WHO	091
65	Dr Bejoy Nambiar	\N	\N	ADDIS ABABA	Co Strategic Health PP	nambiarb@who.int	9111211	1	1	\N	\N	1	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610064	t	\N	\N	\N	1	93	\N	WHO	092
66	Dr Solomon Shiferaw	\N	\N	ADDIS ABABA	EPMA-Principal Inv.	solomonshiferaw@gmail.com	0911 406845	1	1	\N	\N	1	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610065	t	\N	\N	\N	1	95	\N	WHO	094
67	Yetayesh Maru	\N	\N	ADDIS ABABA	Nutrition Specialist	ymaru@unicef.org	911157593	2	2	\N	\N	2	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2620001	t	\N	\N	\N	3	89	\N	UNICEF	088
68	Dr Andarge Abie	\N	\N	ADDIS ABABA	Health Specialist	anayele@unicef.org	967131921	2	2	\N	\N	2	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2620002	t	\N	\N	\N	4	90	\N	UNICEF	089
69	Mr. Yusuf Sead	\N	\N	Dredawa City administration	DRHB- Vice Haed	yusufsaed7@gmail.com	915007842	2	5	\N	\N	5	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2620003	t	\N	\N	\N	3	97	\N	DRHB	096
70	Mr. Alemayehu Girma	\N	\N	Dredawa City administration	DRHB- PMED	alexgirma11@yahoo.com	915761197	2	2	\N	\N	2	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2620004	t	\N	\N	\N	4	98	\N	DRHB	097
71	Dr Rieye Esayas Belay	\N	\N	Tigray Region	TRHB- Vice Haed	esayas1978.sm@gmail.com	932501042	2	4	\N	\N	4	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2620005	t	\N	\N	\N	4	100	\N	TRHB	099
341	Mr. Denekew Ayele 	\N	\N	MoH	team lead 	\N	\N	2	3	\N	\N	3	\N	\N	\N	\N	2025-01-21 19:29:12	2025-01-21 19:29:12	t	ARM2620064	t	\N	\N	\N	2	329	\N	Addis Ababa	329
342	Jemal Mohammed 	\N	\N	MoH	team lead	\N	\N	2	2	\N	\N	2	\N	\N	\N	\N	2025-01-22 19:29:12	2025-01-22 19:29:12	t	ARM2620065	t	\N	\N	\N	3	330	\N	Addis Ababa	330
290	Dr. Helina Worku	\N	\N	USAID	Deputy Office Director	hworku@usaid.gov	0929929729	1	2	\N	\N	2	\N	\N	\N	\N	2024-12-01 19:29:12	2024-12-01 19:29:12	t	ARM2610100	t	\N	\N	\N	1	278	\N	AA	278
291	Dr. Daniel Ngemera	\N	\N	UNICEF	Chief of Health	dngemera@unicef.org	0911505178	1	5	\N	\N	5	\N	\N	\N	\N	2024-12-02 19:29:12	2024-12-02 19:29:12	t	ARM2610100	t	\N	\N	\N	1	279	\N	ADDIS ABABA	279
293	Dr. Patrick Abok	\N	\N	WHO	Cluster Lead	nambiarb@who.int	0911157593	1	3	\N	\N	3	\N	\N	\N	\N	2024-12-04 19:29:12	2024-12-04 19:29:12	t	ARM2610100	t	\N	\N	\N	1	281	\N	ADDIS ABABA	281
302	Dr. Yohannes Challa	\N	\N	ACAHB	ACAHB	kebemd@gmail.com	0930076636	4	2	\N	\N	2	\N	\N	\N	\N	2024-12-13 19:29:12	2024-12-13 19:29:12	t	ARM2640033	t	\N	\N	\N	3	290	\N	Addis Ababa	290
295	Dr. Amanuel Haile	\N	\N	TRHB	TRHB- Head 	amanchs133@gmail.com	0911432481	4	1	\N	\N	1	\N	\N	\N	\N	2024-12-06 19:29:12	2024-12-06 19:29:12	t	ARM2640026	t	\N	\N	\N	2	283	\N	Tigray Region	283
287	Dr. Tokunbo Oshin	\N	\N	GAVI	Director	oshin@gavi.org	0041 22 909 29 75	1	5	\N	\N	5	\N	\N	\N	\N	2024-11-28 19:29:12	2024-11-28 19:29:12	t	ARM2610100	t	\N	\N	\N	3	275	\N	ADDIS ABABA	275
108	Dr. W/Senbet Waganew	\N	\N	ADDIS ABABA	Represenative	woldegessam@gmail.com	932456995	2	3	\N	\N	3	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2620042	t	\N	\N	\N	3	230	\N	ESECCP	239
109	Edossa Adugna	\N	\N	Addis Ababa	Program Wing SMO Advisor	edossa.adugna@moh.gov.et	9111211	3	1	\N	\N	1	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2630001	t	\N	\N	\N	2	152	\N	MoH	151
110	Lelisa Amanuel	\N	\N	Addis Ababa	Senior Advisor	Lelisa.amanuel@moh.gov.et	9111211	3	5	\N	\N	5	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2630002	t	\N	\N	\N	2	153	\N	MoH	152
111	Dr. Abera Bekele	\N	\N	Addis Ababa	advisor for Swift TB	abera.bekele@moh.gov.et	9111211	3	3	\N	\N	3	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2630003	t	\N	\N	\N	3	154	\N	MoH	153
113	Teshome Dires Adane	\N	\N	Addis Ababa	Project Adviser	teshomea@unops.orgorteshome.dires@moh.gov.et	0913 96 29 69	3	4	\N	\N	4	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2630005	t	\N	\N	\N	1	156	\N	MoH	155
114	Bekele Ashagire	\N	\N	Addis Ababa	Project Adviser	bekeleashagire16@gmail.com,Bekele.ashagire@moh.gov.etorbekeley@unops.org	0913 13 82 02	3	1	\N	\N	1	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2630006	t	\N	\N	\N	1	157	\N	MoH	156
115	Mr. Kibebew Workneh	\N	\N	Addis Ababa	HSP Wing SMO Advisor	Kibebew.Workneh@moh.gov.et	9111211	3	5	\N	\N	5	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2630007	t	\N	\N	\N	3	158	\N	MoH	157
116	Dr. Bethelhem Workneh	\N	\N	Addis Ababa	Minister office	BethelhemWorkneh@gmail.com	9111211	3	1	\N	\N	1	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2630008	t	\N	\N	\N	1	159	\N	MoH	160
117	Mrs. Ulian Fikr	\N	\N	Addis Ababa	Minister office	MrsUlianFikr@gmail.com	9111211	3	2	\N	\N	2	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2630009	t	\N	\N	\N	2	160	\N	MoH	161
118	Mrs. Sara Kassahun	\N	\N	Addis Ababa	Minister office	MrsSaraKassahun@gmail.com	9111211	3	3	\N	\N	3	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2630010	t	\N	\N	\N	4	161	\N	MoH	162
87	Mohamed Ayanle	\N	\N	Somale Region	SRHB- Vice Haed	ayanle5710@gmail.com	910484566	2	4	\N	\N	4	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2620021	t	\N	\N	\N	3	124	\N	SRHB	123
92	Mr. Aklilu Yohannes	\N	\N	Sidama Region	SIRHB- PMED	akliluy@yahoo.com	989929223	2	1	\N	\N	1	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2620026	t	\N	\N	\N	4	131	\N	SRHB	130
119	Mr. Abera Girma	\N	\N	Addis Ababa	Minister office	MrAberaGirma@gmail.com	9111211	3	4	\N	\N	4	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2630011	t	\N	\N	\N	3	162	\N	MoH	163
120	Mrs Tigist Assefa	\N	\N	Addis Ababa	Minister office	MrsTigistAssefa@gmail.com	9111211	3	5	\N	\N	5	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2630012	t	\N	\N	\N	1	163	\N	MoH	164
121	Mrs Rehima Shikur	\N	\N	Addis Ababa	Minister office	MrsRehimaShikur@gmail.com	9111211	3	4	\N	\N	4	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2630013	t	\N	\N	\N	2	164	\N	MoH	165
123	Dr. Girmay Deye	\N	\N	Addis Ababa	Minister office	GirmayDeye@gmail.com	9111211	3	5	\N	\N	5	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2630015	t	\N	\N	\N	3	166	\N	MoH	167
124	Dr. Abinet Zeleke	\N	\N	Addis Ababa	Minister office	AbinetZeleke@gmail.com	9111211	3	1	\N	\N	1	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2630016	t	\N	\N	\N	1	167	\N	MoH	168
125	Dr. Aschalew Worku	\N	\N	Addis Ababa	Minister office	AschalewWorku@gmail.com	9111211	3	2	\N	\N	2	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2630017	t	\N	\N	\N	2	168	\N	MoH	169
126	Dr. Mebratu Masebo	\N	\N	Addis Ababa	Minister office	MebratuMasebo@gmail.com	9111211	3	1	\N	\N	1	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2630018	t	\N	\N	\N	4	169	\N	MoH	170
127	Dr. Muluken Yohannes	\N	\N	Addis Ababa	Minister office	MulukenYohannes@gmail.com	9111211	3	2	\N	\N	2	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2630019	t	\N	\N	\N	3	170	\N	MoH	171
128	Mr. Mehari Tekeste	\N	\N	Addis Ababa	Minister office	MrMehariTekeste@gmail.com	9111211	3	3	\N	\N	3	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2630020	t	\N	\N	\N	1	171	\N	MoH	172
129	Dr. Solomon Worku	\N	\N	Addis Ababa	Minister office	SolomonWorku@gmail.com	9111211	3	4	\N	\N	4	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2630021	t	\N	\N	\N	2	172	\N	MoH	173
130	Mr. Birehanu Asfaw	\N	\N	Addis Ababa	Minister office	MrBirehanuAsfaw@gmail.com	9111211	3	1	\N	\N	1	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2630022	t	\N	\N	\N	4	173	\N	MoH	174
131	Asegid Samueal	\N	\N	Addis Ababa	HPHDI- LEO	assegid.samuel@moh.gov.et	9111211	3	4	\N	\N	4	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2630023	t	\N	\N	\N	2	174	\N	MoH	175
132	Solomon W/Aamanuel	\N	\N	Addis Ababa	HPHDI-TL	Solomon.Woldeamanuel@moh.gov.et	9111211	3	4	\N	\N	4	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2630024	t	\N	\N	\N	3	175	\N	MoH	176
133	Israel Ataro Otoro	\N	\N	Addis Ababa	CEPHC-LEO	Israel.Ataro@gmail.com	9111211	3	1	\N	\N	1	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2630025	t	\N	\N	\N	2	176	\N	MoH	177
134	Regassa Bayisa Obse	\N	\N	Addis Ababa	PME-LEO	Regassa.Bayisa@moh.gov.et	9111211	3	4	\N	\N	4	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2630026	t	\N	\N	\N	1	177	\N	MoH	179
135	Hiwot Darsene Dimd	\N	\N	Addis Ababa	Nut Coord LEO	Hiwot.Darsene@moh.gov.et	9111211	3	2	\N	\N	2	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2630027	t	\N	\N	\N	4	178	\N	MoH	181
136	Mezgebu Siyum	\N	\N	Addis Ababa	Nut Coord LEO	Mezgebu.Siyum@moh.gov.et	9111211	3	2	\N	\N	2	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2630028	t	\N	\N	\N	2	179	\N	MoH	182
137	Shambel Negassa	\N	\N	Addis Ababa	Ethics & Anti-Corruption EO	Shambel.Negassa@moh.gov.et	9111211	3	4	\N	\N	4	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2630029	t	\N	\N	\N	2	180	\N	MoH	183
138	Fatuma Seid	\N	\N	Addis Ababa	WSAII-EO	Fatuma.Seid@moh.gov.et	9111211	3	4	\N	\N	4	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2630030	t	\N	\N	\N	1	181	\N	MoH	185
139	Dr. Muluken Argaw	\N	\N	Addis Ababa	Strategic Affairs EO	Muluken.Argaw@moh.gov.et	9111211	3	2	\N	\N	2	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2630031	t	\N	\N	\N	1	182	\N	MoH	187
140	Mesoud Mohammed	\N	\N	Addis Ababa	Strategic Affairs TL	Mesoud.Mohammed@moh.gov.et	9111211	3	2	\N	\N	2	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2630032	t	\N	\N	\N	4	183	\N	MoH	188
141	Hiwot Solomon	\N	\N	Addis Ababa	DPC-EO	Hiwot.Solomon@moh.gov.et	9111211	3	3	\N	\N	3	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2630033	t	\N	\N	\N	2	184	\N	MoH	189
142	Gudisa Assefa	\N	\N	Addis Ababa	DPC-TL	gudissabayissa35@gmail.com	920499275	3	3	\N	\N	3	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2630034	t	\N	\N	\N	3	185	\N	MoH	190
143	Habtamu Demssie	\N	\N	Addis Ababa	CHRA-LEO	habtamu.demissie@moh.gov.et	9111211	3	4	\N	\N	4	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2630035	t	\N	\N	\N	4	186	\N	MoH	191
144	Girma Bogale	\N	\N	Addis Ababa	CHRA-TL	girma.bogale@ymail.com	9111211	3	4	\N	\N	4	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2630036	t	\N	\N	\N	2	187	\N	MoH	192
145	Maru Sisay	\N	\N	Addis Ababa	ICT-EO	Maru.Sisay@moh.gov.et	9111211	3	5	\N	\N	5	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2630037	t	\N	\N	\N	4	188	\N	MoH	193
146	Esayas Lulu	\N	\N	Addis Ababa	ICT-TL	esayaslulu@gmail.com	9111211	3	4	\N	\N	4	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2630038	t	\N	\N	\N	4	189	\N	MoH	194
147	Fikadu Yadeta	\N	\N	Addis Ababa	HIV Control & Prev. LEO	fekadu.yadeta@moh.gov.et	9111211	3	3	\N	\N	3	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2630039	t	\N	\N	\N	2	190	\N	MoH	195
148	Mrs. Abinet Assefat	\N	\N	Addis Ababa	HIV Cont. & Prev. TL	abnetfeyssa@yahoo.com	9111211	3	3	\N	\N	3	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2630040	t	\N	\N	\N	4	191	\N	MoH	196
149	Tibesso Bezabih	\N	\N	Addis Ababa	Legal Services EO	Tibesso,Bezabih@moh.gov.et	9111211	3	5	\N	\N	5	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2630041	t	\N	\N	\N	4	192	\N	MoH	197
150	Endegena Abebe	\N	\N	Addis Ababa	PSR-LEO	Endegena.Abebe@moh.gov.et	9111211	3	4	\N	\N	4	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2630042	t	\N	\N	\N	4	193	\N	MoH	199
151	Dr. Mohammed Aliye	\N	\N	Addis Ababa	PSR-TL	MohammedAliye@gmail.com	9111211	3	2	\N	\N	2	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2630043	t	\N	\N	\N	3	194	\N	MoH	200
152	Dr. Alemayehu Hunduma	\N	\N	Addis Ababa	MCAHS-EO	Alemayehu.Hunduma@moh.gov.et	9111211	3	1	\N	\N	1	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2630044	t	\N	\N	\N	1	195	\N	MoH	201
153	Motuma Bekele Nagu	\N	\N	Addis Ababa	RH, FP & AYH desk	Motuma.Bekele@moh.gov.et	9111211	3	1	\N	\N	1	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2630045	t	\N	\N	\N	2	196	\N	MoH	202
154	Tesfaw Bifered	\N	\N	Addis Ababa	Int. Audit Excutive	Tesfaw.Bifered@moh.gov.et	9111211	3	5	\N	\N	5	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2630046	t	\N	\N	\N	4	197	\N	MoH	203
155	Gemechis Melkamu	\N	\N	Addis Ababa	DH-LEO	Gemechis.Melkamu@moh.gov.et	9111211	3	2	\N	\N	2	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2630047	t	\N	\N	\N	2	198	\N	MoH	204
156	OLI KABA	\N	\N	Addis Ababa	DH-TL	OLIKABA@gmail.com	9111211	3	2	\N	\N	2	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2630048	t	\N	\N	\N	4	199	\N	MoH	205
157	Tadesse Yemane Worku	\N	\N	Addis Ababa	HI-LEO	Tadesse.Yemane@moh.gov.et	9111211	3	4	\N	\N	4	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2630049	t	\N	\N	\N	1	200	\N	MoH	206
158	Frew Ataklt Yeshitila	\N	\N	Addis Ababa	HI-TL	FrewAtakltYeshitila@gmail.com	9111211	3	5	\N	\N	5	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2630050	t	\N	\N	\N	3	201	\N	MoH	207
159	Yihenew Birehane	\N	\N	Addis Ababa	Procurement EO	Yihenew.Birehane@moh.gov.et	9111211	3	1	\N	\N	1	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2630051	t	\N	\N	\N	1	202	\N	MoH	208
160	Habtamu Kassahun	\N	\N	Addis Ababa	Procurement TL	HabtamuKassahun@gmail.com	9111211	3	3	\N	\N	3	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2630052	t	\N	\N	\N	3	203	\N	MoH	209
161	Dr. Abas Hassen Yesuf	\N	\N	Addis Ababa	HSII-LEO	Abas.Hassen@moh.gov.et	9111211	3	2	\N	\N	2	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2630053	t	\N	\N	\N	1	204	\N	MoH	210
162	Mr. Endalkachew Tsedal	\N	\N	Addis Ababa	HHRIPR-LEO	Endalkachew.Tsedal@moh.gov.et	9111211	3	2	\N	\N	2	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2630054	t	\N	\N	\N	1	205	\N	MoH	212
163	Mr. Solomon Ejigu	\N	\N	Addis Ababa	Finance EO	Solomon.Ejigu@moh.gov.et	9111211	3	3	\N	\N	3	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2630055	t	\N	\N	\N	1	206	\N	MoH	214
164	Gemechu assfaw	\N	\N	Addis Ababa	Finance TL	Gemechu.Assfaw@moh.gov.et	9111211	3	4	\N	\N	4	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2630056	t	\N	\N	\N	3	207	\N	MoH	215
165	Dr. Tegene Regassa	\N	\N	Addis Ababa	PRC-EO	Tegene.Regassa@moh.gov.et	9111211	3	3	\N	\N	3	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2630057	t	\N	\N	\N	4	208	\N	MoH	216
72	Tedros Tsehaye Abay	\N	\N	Tigray Region	TRHB- PMED	taditsehaye@gmail.com	914706801	2	5	\N	\N	5	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2620006	t	\N	\N	\N	3	101	\N	TRHB	100
73	Fariha mohammed	\N	\N	Harari region	HRHB- Vice Haed	ferunasu@gmail.com	915740744	2	3	\N	\N	3	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2620007	t	\N	\N	\N	1	103	\N	HRHB	102
74	Abdusemed Ali	\N	\N	Harari region	HRHB- PMED	abdusemedali697@yahoo.com	913385438	2	1	\N	\N	1	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2620008	t	\N	\N	\N	2	104	\N	HRHB	103
75	Mitiku Tamene Negash	\N	\N	SWEP	SWEPRHB- Vice Head	hailezewudie2010@gmail.com	912123748	2	5	\N	\N	5	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2620009	t	\N	\N	\N	2	106	\N	SWEPRHB	105
76	Mr. Wasihun Berhanu	\N	\N	SWEP	SWEPRHB- PMED	berhanuwasihun1@gmail.com	913418156	2	3	\N	\N	3	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2620010	t	\N	\N	\N	4	107	\N	SWEPRHB	106
77	Abdulmunium Albeshir	\N	\N	Benishangul Gumuz Region	BRHB- Vice Haed	Alemd756@gmail.com	913252754	2	1	\N	\N	1	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2620011	t	\N	\N	\N	4	109	\N	BGRHB	108
78	Usman Abdulahi	\N	\N	Benishangul Gumuz Region	BRHB- PMED	uabdulahi97@gmail.com	945305663	2	5	\N	\N	5	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2620012	t	\N	\N	\N	1	110	\N	BGRHB	109
47	Esayas Mesele	\N	\N	ADDIS ABABA	Country Dir.	emesele@purposeafrica.com	911781859	1	2	\N	\N	2	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610046	t	\N	\N	\N	3	66	\N	Purpose Africa - Ethi.	065
81	Mr. Abebe Temtim	\N	\N	AMHARA REGION	ARHB- Vice Haed	temtmeabebe@yahoo.com	913057212	2	2	\N	\N	2	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2620015	t	\N	\N	\N	4	115	\N	ARHB	114
82	Mr. Amare Shumet	\N	\N	AMHARA REGION	ARHB- PMED	eyoshumet@gmail.com	920271625	2	3	\N	\N	3	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2620016	t	\N	\N	\N	3	116	\N	ARHB	115
83	Ashenafi Petros	\N	\N	Central Ethiopia	SERHB- Vice Haed	ashenafipet2016@gmail.com	977089612	2	2	\N	\N	2	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2620017	t	\N	\N	\N	2	118	\N	CERHB	117
84	Ayile Lemma	\N	\N	Central Ethiopia	CERHB- PMED	ayileshew2007@gmail.com	928793646	2	2	\N	\N	2	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2620018	t	\N	\N	\N	4	119	\N	CERHB	118
86	Ato Aklilu Simanesew	\N	\N	Addis Ababa	ACAHB- PMED	aklilusimanesew@gmail.com	911803058	2	1	\N	\N	1	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2620020	t	\N	\N	\N	4	122	\N	ACAHB	121
88	Mr. Ayderus Ahmed	\N	\N	Somale Region	SRHB- PMED	Directorayderus24@gmail.com	9100923210	2	1	\N	\N	1	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2620022	t	\N	\N	\N	1	125	\N	SRHB	124
89	Wittika Nore	\N	\N	Afar Region	AHB- Vice Haed	Wittican@gmail.com	920100882	2	2	\N	\N	2	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2620023	t	\N	\N	\N	2	127	\N	ARHB	126
90	Amin Arba	\N	\N	Afar Region	ARHB- PMED	Wittican@gmail.com	911985225	2	3	\N	\N	3	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2620024	t	\N	\N	\N	3	128	\N	ARHB	127
91	Muntasha Berhanu	\N	\N	Sidama Region	SIRHB- Vice Haed	akliluy@yahoo.com	911398938	2	5	\N	\N	5	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2620025	t	\N	\N	\N	2	130	\N	SRHB	129
166	Yordanos Alebachew	\N	\N	Addis Ababa	PRC-TL	Yordanos.Alebachew@moh.gov.et	9111211	3	4	\N	\N	4	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2630058	t	\N	\N	\N	2	209	\N	MoH	217
167	Geremew Uga Merga	\N	\N	Addis Ababa	Institutional Reform Exec.	Geremew.Uga@moh.gov.et	9111211	3	5	\N	\N	5	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2630059	t	\N	\N	\N	2	210	\N	MoH	218
168	Assefa Ayide	\N	\N	Addis Ababa	Institutional Reform TL	Assefa.Ayide@moh.gov.et	9111211	3	1	\N	\N	1	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2630060	t	\N	\N	\N	3	211	\N	MoH	219
169	Dr. Elubabor Buno	\N	\N	Addis Ababa	Medical Services LEO	Elubabor.Buno@moh.gov.et	9111211	3	5	\N	\N	5	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2630061	t	\N	\N	\N	1	212	\N	MoH	220
170	Dr. Asnake Wagari	\N	\N	Addis Ababa	Management CEO	Tesfaw.Bifered@moh.gov.et	9111211	3	4	\N	\N	4	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2630062	t	\N	\N	\N	1	213	\N	MoH	222
286	Dr. Zerihun Tadesse,	\N	\N	Carter Center 	Senior Country Rep.	Tadesse@cartercenter.org	0911-401498	1	3	\N	\N	3	\N	\N	\N	\N	2024-11-27 19:29:12	2024-11-27 19:29:12	t	ARM2610100	t	\N	\N	\N	3	274	\N	AA	274
93	Mr. Ogetu Ading	\N	\N	Gambella Region	GRHB- Vice Haed	chanie704@gmail.com	912418667	2	2	\N	\N	2	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2620027	t	\N	\N	\N	4	133	\N	GRHB	132
94	Chanie Hussen	\N	\N	Gambella Region	GRHB- PMED	chanie704@gmail.com	912418668	2	5	\N	\N	5	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2620028	t	\N	\N	\N	2	134	\N	GRHB	133
95	Prof. Nestanet Workineh	\N	\N	Oromia Region	ORHB- Head	konetsanet@gmail.com	917762109	2	5	\N	\N	5	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2620029	t	\N	\N	\N	1	135	\N	ORHB	134
96	Mr.Dereje Abdena	\N	\N	Oromia Region	ORHB- Vice Haed	dkumsa2000@gmail.com	09 66 11 82 22	2	4	\N	\N	4	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2620030	t	\N	\N	\N	3	136	\N	ORHB	135
97	Mr. Lemessa Tadesse	\N	\N	Oromia Region	ORHB- PMED	lamessa2@gmail.com	09 11 36 62 90	2	1	\N	\N	1	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2620031	t	\N	\N	\N	1	137	\N	ORHB	136
98	Habtamu Taye	\N	\N	Addis Ababa	Deputy Director	hab.taye@yahoo.com	913361822	2	5	\N	\N	5	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2620032	t	\N	\N	\N	2	139	\N	EBTS	138
99	Mr. Negash Sime	\N	\N	Addis Ababa	Deputy Director	nsime@efda.gov.et	935409078	2	2	\N	\N	2	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2620033	t	\N	\N	\N	3	141	\N	EFDA	140
100	Dr.Demssew Yheyis	\N	\N	Addis Ababa	Deputy Director	demisew.yiheyis@gmail.com	909900889	2	2	\N	\N	2	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2620034	t	\N	\N	\N	2	143	\N	EPOS	142
101	Mr. Messay W/Mariam	\N	\N	Addis Ababa	Deputy Director	messay.woldemariam@ahri.gov.et	911967505	2	4	\N	\N	4	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2620035	t	\N	\N	\N	3	145	\N	AHRI	144
102	Dr Getachew Eticha	\N	\N	Addis Ababa	Deputy Director	getachewtollera@gmail.com	9111211	2	3	\N	\N	3	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2620036	t	\N	\N	\N	2	147	\N	EPHI	146
103	Mrs. Yamrot Andualem	\N	\N	Addis Ababa	Deputy Director	yamdual@gmail.com	944703774	2	1	\N	\N	1	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2620037	t	\N	\N	\N	3	149	\N	CBHI	148
104	Aknawu Kawaza	\N	\N	Addis Ababa	Deputy Director	aknawu.kawaza@epss.gov.et	944305057	2	1	\N	\N	1	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2620038	t	\N	\N	\N	3	151	\N	EPSS	150
105	Dr.Alemayehu Mekonnen	\N	\N	ADDIS ABABA	County Director	alemayehuem@yahoo.com	09 11 60 63 61	2	4	\N	\N	4	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2620039	t	\N	\N	\N	4	227	\N	AEPHA	236
106	Kidu Hailu	\N	\N	ADDIS ABABA	County Representative	kiduhailug@gmail.com	911925251	2	4	\N	\N	4	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2620040	t	\N	\N	\N	1	228	\N	EPA	237
288	Emmanuella Baguma	\N	\N	GAVI	Senior Country Manager 	ebaguma@gavi.org	0041 79 912 21 74	1	1	\N	\N	1	\N	\N	\N	\N	2024-11-29 19:29:12	2024-11-29 19:29:12	t	ARM2610100	t	\N	\N	\N	1	276	\N	AA	276
292	Dr. Owen L. Kaluwa	\N	\N	WHO	WHO Representative	kaluwao@who.in	0911157593	1	5	\N	\N	5	\N	\N	\N	\N	2024-12-03 19:29:12	2024-12-03 19:29:12	t	ARM2610100	t	\N	\N	\N	1	280	\N	AA	280
303	Dr. Musse Ahmed  	\N	\N	SRHB	SRHB- Head 	 Headwaliadawe91@gmail.com	09134606452	4	1	\N	\N	1	\N	\N	\N	\N	2024-12-14 19:29:12	2024-12-14 19:29:12	t	ARM2640034	t	\N	\N	\N	2	291	\N	Somale Region 	291
304	Yassin Habib	\N	\N	ARHB	ARHB- Head 	yashabhel@gmail.com	0911936340	4	1	\N	\N	1	\N	\N	\N	\N	2024-12-15 19:29:12	2024-12-15 19:29:12	t	ARM2640035	t	\N	\N	\N	4	292	\N	Afar Region 	292
305	Dr.Selamawit Mengesha	\N	\N	SRHB	SRHB- Head 	akliluy@yahoo.com	0924319998	4	4	\N	\N	4	\N	\N	\N	\N	2024-12-16 19:29:12	2024-12-16 19:29:12	t	ARM2640036	t	\N	\N	\N	1	293	\N	Sidama Region 	293
307	Prof. Nestanet Workineh	\N	\N	ORHB	ORHB- Head 	konetsanet@gmail.com	 0917762109	4	5	\N	\N	5	\N	\N	\N	\N	2024-12-18 19:29:12	2024-12-18 19:29:12	t	ARM2640038	t	\N	\N	\N	1	295	\N	Oromia Region 	295
171	Mulualem Bulcha	\N	\N	Addis Ababa	CEO Advisor	Tesfaw.Bifered@moh.gov.et	9111211	3	5	\N	\N	5	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2630063	t	\N	\N	\N	2	214	\N	MoH	223
172	Dr. Awoke Tasew Tebeje	\N	\N	ADDIS ABABA	Ass. Repr./PA	tasewtebeje@unfpa.org	0944 122326	1	5	\N	\N	5	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610066	t	\N	\N	\N	1	2	\N	UNFPA	001
173	Worknesh Mekonnen	\N	\N	ADDIS ABABA	Country Director	workneshg@unops.org	911512306	1	3	\N	\N	3	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610067	t	\N	\N	\N	1	5	\N	UNOPS	004
174	Ms. KWAK Hyemin	\N	\N	ADDIS ABABA	Deputy Country Dir.	hemina3675@kofih.org	977160968	1	2	\N	\N	2	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610068	t	\N	\N	\N	2	12	\N	KOFIH Ethiopia Office	011
175	Dr. Zenebe Melaku	\N	\N	ADDIS ABABA	ICAP’s Country Dir.	zy2115@cumc.columbia.edu	911225347	1	3	\N	\N	3	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610069	t	\N	\N	\N	1	15	\N	ICAP	014
176	Prof. Sileshi Lulseged	\N	\N	ADDIS ABABA	Management team	sl2883@cumc.columbia.edu	2.52E+11	1	5	\N	\N	5	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610070	t	\N	\N	\N	3	16	\N	ICAP	015
177	Dr.Fasil Nigussie	\N	\N	ADDIS ABABA	Social dev. adv. & PRO	Fasil.Nigussie@fcdo.gov.uk	912163174	1	4	\N	\N	4	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610071	t	\N	\N	\N	1	17	\N	FCDO - AA, Eth.	016
178	Hannah Binci	\N	\N	ADDIS ABABA	Team Leader HCD	Hannah.Binci@fcdo.gov.uk	955722085	1	2	\N	\N	2	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610072	t	\N	\N	\N	2	18	\N	FCDO - AA, Eth.	017
179	Dr. Lydia Tesfaye	\N	\N	ADDIS ABABA	Health Advisor	Lydia.Tesfaye@fcdo.gov.uk	955722085	1	3	\N	\N	3	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610073	t	\N	\N	\N	4	19	\N	FCDO - AA, Eth.	018
180	Robin Gorna	\N	\N	ADDIS ABABA	GF Accl'r HAdv.	Robin.Gorna@fcdo.gov.uk	955722085	1	4	\N	\N	4	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610074	t	\N	\N	\N	3	20	\N	FCDO - AA, Eth.	019
181	Dr. Girum Hailu	\N	\N	ADDIS ABABA	Regional Coord.	girum.hailu@igad.int	911214588	1	2	\N	\N	2	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610075	t	\N	\N	\N	1	22	\N	IGAD	021
182	Kidist Hailu	\N	\N	ADDIS ABABA	Country Director	khailu@aiha-et.com	911142730	1	5	\N	\N	5	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610076	t	\N	\N	\N	4	24	\N	AIHA	023
183	Mr. Eshett Degefa	\N	\N	ADDIS ABABA	Country Director	TokonE@unaids.org	911508725	1	1	\N	\N	1	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610077	t	\N	\N	\N	1	27	\N	UNAIDS	026
184	Abebe Kebede	\N	\N	ADDIS ABABA	Executive director	abe_keb@yahoo.com	911228516	1	5	\N	\N	5	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610078	t	\N	\N	\N	2	42	\N	CORHA	041
185	Beatrice NERI	\N	\N	ADDIS ABABA	Head of Sector	Beatrice.NERI@eeas.europa.eu	#ERROR!	1	3	\N	\N	3	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610079	t	\N	\N	\N	3	49	\N	EU Delegation	048
186	Roman Tesfaye	\N	\N	ADDIS ABABA	Senior Op. Officer	rtesfaye@worldbank.org	931573222	1	2	\N	\N	2	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610080	t	\N	\N	\N	4	51	\N	World Bank	050
187	Kidist Kebebe	\N	\N	ADDIS ABABA	Senior Health Specialist	kdemissie@worldbank.org	912633760	1	4	\N	\N	4	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610081	t	\N	\N	\N	2	52	\N	World Bank	051
188	Wubedel Dereje	\N	\N	ADDIS ABABA	Senior Health Specialist	walemu@worldbank.org	921666617	4	5	\N	\N	5	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2640001	t	\N	\N	\N	3	53	\N	World Bank	052
189	Ms.Thais González Capella	\N	\N	ADDIS ABABA	Country Representative	thais.gonzalez@aecid.es	9700433629	1	2	\N	\N	2	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610082	t	\N	\N	\N	2	54	\N	AECID	053
190	Ms. Jennifer Mika	\N	\N	ADDIS ABABA	Country Director	ziz5@cdc.gov	904032336	1	5	\N	\N	5	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610083	t	\N	\N	\N	1	63	\N	CDC Ethiopia	062
191	Dr. Zerihun Tadesse	\N	\N	ADDIS ABABA	Sr. Country Repr.	Tadesse@cartercenter.org	911401498	1	3	\N	\N	3	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610084	t	\N	\N	\N	3	65	\N	Carter Center	064
192	Dr. Tokunbo Oshin	\N	\N	ADDIS ABABA	Director, GAVI	oshin@gavi.org	0041 22 909 29 75	1	5	\N	\N	5	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610085	t	\N	\N	\N	3	68	\N	GAVI	067
193	Emmanuella Baguma	\N	\N	ADDIS ABABA	Senior Country Manager	ebaguma@gavi.org	0041 79 912 21 74	1	1	\N	\N	1	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610086	t	\N	\N	\N	1	69	\N	GAVI	068
194	Jonathan Ross	\N	\N	ADDIS ABABA	Office Director	jross@usaid.gov	911201048	4	5	\N	\N	5	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2640002	t	\N	\N	\N	3	80	\N	USAID	079
195	Dr. Helina Worku	\N	\N	ADDIS ABABA	Deputy Office Director	hworku@usaid.gov	929929729	1	2	\N	\N	2	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610087	t	\N	\N	\N	1	81	\N	USAID	080
196	Dr Daniel Ngemera	\N	\N	ADDIS ABABA	Chief of Health	dngemera@unicef.org	911505178	1	5	\N	\N	5	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610088	t	\N	\N	\N	1	88	\N	UNICEF	087
197	Dr Owen L. Kaluwa	\N	\N	ADDIS ABABA	WHO Representative	kaluwao@who.in	9111211	4	5	\N	\N	5	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2640003	t	\N	\N	\N	1	91	\N	WHO	090
198	Dr Patrick Abok	\N	\N	ADDIS ABABA	Cluster Lead, EPR	nambiarb@who.int	9111211	1	3	\N	\N	3	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610089	t	\N	\N	\N	1	94	\N	WHO	093
199	Dr. Tsigereda Kifle	\N	\N	Dredawa City administration	DRHB- Head	drtsigeredakifle2@gmail.com	906920094	4	4	\N	\N	4	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2640004	t	\N	\N	\N	1	96	\N	DRHB	095
201	Yasin Abdulahi	\N	\N	Harari region	HRHB- Head	yaseenharar@gmail.com	911285245	4	4	\N	\N	4	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2640005	t	\N	\N	\N	3	102	\N	HRHB	101
202	Mr. Ibrahim Temam	\N	\N	SWEP	SWEPRHB- Head	ibri.temam@gmail.com	923431635	1	3	\N	\N	3	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610091	t	\N	\N	\N	1	105	\N	SWEPRHB	104
345	Gizachew Kedida	\N	\N	EMLA	Director	gkedida@gmail.com	0946855955 	2	4	\N	\N	4	\N	\N	\N	\N	2025-01-25 19:29:12	2025-01-25 19:29:12	t	ARM2620068	t	\N	\N	\N	1	333	\N	ADDIS ABABA	333
346	Dr Girma Taye	\N	\N	AAU	Director	girmataye2009@gmail.com	0911769926	2	1	\N	\N	1	\N	\N	\N	\N	2025-01-26 19:29:12	2025-01-26 19:29:12	t	ARM2620069	t	\N	\N	\N	3	334	\N	ADDIS ABABA	334
350	Mr. Mideksa Adunya	\N	\N	Fenot	Fenot	mideksaa@gmail.com	0911363562	11	2	\N	\N	2	\N	\N	\N	\N	2025-01-30 19:29:12	2025-01-30 19:29:12	t	ARM26110001	t	\N	\N	\N	3	338	\N	ADDIS ABABA	338
203	Waltaji Begalo	\N	\N	Benishangul Gumuz Region	BRHB- Head	begalowaltajie@gmail.com	960880064	4	3	\N	\N	3	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2640006	t	\N	\N	\N	3	108	\N	BGRHB	107
204	Mr. Endeshaw Shibru	\N	\N	South Ethiopia	SERHB- Head	endashawshibru@gmail.com	937222844	4	2	\N	\N	2	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2640007	t	\N	\N	\N	4	111	\N	SERHB	110
205	Mr. Abdulkerim Wengistu	\N	\N	AMHARA REGION	ARHB- Head	abdulkerimmengistu@gmail.com	930989478	4	1	\N	\N	1	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2640008	t	\N	\N	\N	2	114	\N	ARHB	113
206	Samuel Darge	\N	\N	Central Ethiopia	CERHB- Head	dargesamuel@yahoo.com	911395375	1	5	\N	\N	5	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610092	t	\N	\N	\N	1	117	\N	CERHB	116
207	Dr Yohannes Challa	\N	\N	Addis Ababa	ACAHB- Head	kebemd@gmail.com	930076636	4	2	\N	\N	2	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2640009	t	\N	\N	\N	3	120	\N	ACAHB	119
209	Yassin Habib	\N	\N	Afar Region	ARHB- Head	yashabhel@gmail.com	911936340	4	1	\N	\N	1	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2640011	t	\N	\N	\N	4	126	\N	ARHB	125
210	Dr.Selamawit Mengesha	\N	\N	Sidama Region	SIRHB- Head	akliluy@yahoo.com	924319998	4	4	\N	\N	4	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2640012	t	\N	\N	\N	1	129	\N	SRHB	128
211	Dr.Abel Asefa	\N	\N	Gambella Region	GRHB- Head	chanie704@gmail.com	965757106	4	3	\N	\N	3	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2640013	t	\N	\N	\N	3	132	\N	GRHB	131
212	Dr Ashenafi Tazebew	\N	\N	Addis Ababa	General Director	ashenafitazebew1@gmail.com	992102707	1	1	\N	\N	1	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610093	t	\N	\N	\N	1	138	\N	EBTS	137
213	Mrs. Heran Gerba	\N	\N	Addis Ababa	General Director	hgreba@efda.gov.et	944306682	4	4	\N	\N	4	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2640014	t	\N	\N	\N	4	140	\N	EFDA	139
214	Dr. Tariku Tadesse	\N	\N	Addis Ababa	General Director	taarikuuguutee@gmail.com	909900888	1	3	\N	\N	3	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610094	t	\N	\N	\N	1	142	\N	EPOS	141
215	Prof. Afework Kassu	\N	\N	Addis Ababa	General Director	afework.kassu@ahri.gov.et	911207865	4	1	\N	\N	1	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2640015	t	\N	\N	\N	4	144	\N	AHRI	143
216	Mesay Hailu	\N	\N	Addis Ababa	General Director	mesdan216@gmail.com	9111211	4	2	\N	\N	2	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2640016	t	\N	\N	\N	1	146	\N	EPHI	145
217	Mr. Tesfaye Worku	\N	\N	Addis Ababa	General Director	Tesfayew885@gmail.com	911867128	1	2	\N	\N	2	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610095	t	\N	\N	\N	4	148	\N	CBHI	147
218	DR. Abdulkedir Gelgelo	\N	\N	Addis Ababa	General Director	abdulkedir.gelgelo@epss.gov.et	944305056	1	2	\N	\N	2	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610096	t	\N	\N	\N	1	150	\N	EPSS	149
219	Dr Shimels Gezahegn	\N	\N	ADDIS ABABA	CEO	gshime98@gmail.com	911623754	4	5	\N	\N	5	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2640017	t	\N	\N	\N	1	215	\N	ALERT CSH	224
220	Dr. Abraham Eshetu	\N	\N	ADDIS ABABA	CEO	biniamnesru.1234@gmail.com	9111211	4	4	\N	\N	4	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2640018	t	\N	\N	\N	2	216	\N	St. Peter	225
221	Dr. Muluken	\N	\N	ADDIS ABABA	CED	Mulathea18@gmail.com	911637161	4	3	\N	\N	3	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2640019	t	\N	\N	\N	4	217	\N	Eka Kotebe Hospital	226
222	EDAO FEJO HAMDA	\N	\N	ADDIS ABABA	CED	edaofejo@yahoo.com	930077546	4	3	\N	\N	3	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2640020	t	\N	\N	\N	3	218	\N	Amanuel Mental SH	227
223	Dr. Sisay Sirgu	\N	\N	ADDIS ABABA	Provest	Sisay.sirgu@sphmmc.edu.et	911247720	1	4	\N	\N	4	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610097	t	\N	\N	\N	1	219	\N	SPHMMC	228
224	H.E Tirumar Abate	\N	\N	ADDIS ABABA	State Minister	atirumar@gmail.com	953001290	4	2	\N	\N	2	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2640021	t	\N	\N	\N	4	220	\N	MPD	229
225	Mrs. Ashereka Digga	\N	\N	ADDIS ABABA	Wing Desk Coordin.	umumasoud1434@gmail.com	913390246	1	4	\N	\N	4	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610098	t	\N	\N	\N	2	221	\N	PMO	230
226	Mr. Teshome Debero	\N	\N	ADDIS ABABA	Wing Desk T. Advisor	tdebero@yahoo.com	913662056	1	5	\N	\N	5	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610099	t	\N	\N	\N	3	222	\N	PMO	231
227	Sr. Hirut Imbiale	\N	\N	ADDIS ABABA	Higher Gender Expert	hirunalin@gmail.Com	938039150	1	4	\N	\N	4	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610100	t	\N	\N	\N	1	223	\N	House of PR	232
228	Mr.Omod Ujulu Ubup	\N	\N	ADDIS ABABA	State Minister	mesker.tariku@moj.gov.et	911748648	4	5	\N	\N	5	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2640022	t	\N	\N	\N	2	224	\N	Ministry of Justice	233
229	Kefelech Denbebo	\N	\N	ADDIS ABABA	State Minister	executivesecretary.mills@gmail.com	902483048	4	1	\N	\N	1	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2640023	t	\N	\N	\N	4	225	\N	Regation Minister	234
48	Maliha Dost	\N	\N	ADDIS ABABA	FS (Dev.)	Maliha.Dost@international.gc.ca	091 125 2751	1	1	\N	\N	1	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610047	t	\N	\N	\N	1	67	\N	Emb. of Canada to Eth.	066
49	Yosef Alemu	\N	\N	ADDIS ABABA	Country Dir.	yalemu@r4d.org	911393356	1	5	\N	\N	5	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2610048	t	\N	\N	\N	1	70	\N	Results For Dev't (R4D)	069
85	Mrs. Hangatu Muhammud	\N	\N	Addis Ababa	ACAHB- Vice Haed	hangatum@gmail.com	913332649	2	5	\N	\N	5	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2620019	t	\N	\N	\N	1	121	\N	ACAHB	120
112	Mrs. Semira Sultan	\N	\N	Addis Ababa	State Minister Adviser	semira.sultan@moh.gov.et	0948 87-42-17	3	2	\N	\N	2	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2630004	t	\N	\N	\N	1	155	\N	MoH	154
208	Dr.Musse Ahmed	\N	\N	Somale Region	DRHB- Head	Headwaliadawe91@gmail.com	9134606452	4	1	\N	\N	1	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2640010	t	\N	\N	\N	2	123	\N	SRHB	122
289	Jonathan Ross	\N	\N	USAID	Office Director	jross@usaid.gov	0911201048	1	5	\N	\N	5	\N	\N	\N	\N	2024-11-30 19:29:12	2024-11-30 19:29:12	t	ARM2610100	t	\N	\N	\N	3	277	\N	ADDIS ABABA	277
294	Dr. Tsigereda Kifle	\N	\N	DRHB 	DRHB- Head 	drtsigeredakifle2@gmail.com 	 0906920094	4	4	\N	\N	4	\N	\N	\N	\N	2024-12-05 19:29:12	2024-12-05 19:29:12	t	ARM2640025	t	\N	\N	\N	1	282	\N	Dredawa City administration 	282
296	Yasin Abdulahi	\N	\N	HRHB	HRHB- Head 	yaseenharar@gmail.com	0911285245	4	4	\N	\N	4	\N	\N	\N	\N	2024-12-07 19:29:12	2024-12-07 19:29:12	t	ARM2640027	t	\N	\N	\N	3	284	\N	Harari region	284
297	Mr. Ibrahim Temam	\N	\N	SWEPRHB	SWEPRHB- Head 	ibri.temam@gmail.com	0923431635	4	3	\N	\N	3	\N	\N	\N	\N	2024-12-08 19:29:12	2024-12-08 19:29:12	t	ARM2640028	t	\N	\N	\N	1	285	\N	SWEP	285
298	Waltaji Begalo	\N	\N	BGRHB	BRHB- Head 	 begalowaltajie@gmail.com	0960880064	4	3	\N	\N	3	\N	\N	\N	\N	2024-12-09 19:29:12	2024-12-09 19:29:12	t	ARM2640029	t	\N	\N	\N	3	286	\N	Benishangul Gumuz Region	286
299	Mr. Endeshaw Shibru	\N	\N	SERHB	SRHB- Head 	endashawshibru@gmail.com	0937222844	4	2	\N	\N	2	\N	\N	\N	\N	2024-12-10 19:29:12	2024-12-10 19:29:12	t	ARM2640030	t	\N	\N	\N	4	287	\N	South Ethiopia	287
300	Mr. Abdulkerim Wengistu	\N	\N	ARHB	ARHB- Head 	 abdulkerimmengistu@gmail.com	0930989478	4	1	\N	\N	1	\N	\N	\N	\N	2024-12-11 19:29:12	2024-12-11 19:29:12	t	ARM2640031	t	\N	\N	\N	2	288	\N	AMHARA REGION	288
301	Samuel Darge	\N	\N	CERHB	DRHB- Head 	dargesamuel@yahoo.com	0911395375	4	5	\N	\N	5	\N	\N	\N	\N	2024-12-12 19:29:12	2024-12-12 19:29:12	t	ARM2640032	t	\N	\N	\N	1	289	\N	Central Ethiopia	289
309	Mrs. Heran Gerba 	\N	\N	EFDA 	General Director 	hgreba@efda.gov.et	0944306682	4	4	\N	\N	4	\N	\N	\N	\N	2024-12-20 19:29:12	2024-12-20 19:29:12	t	ARM2640040	t	\N	\N	\N	4	297	\N	Addis Ababa	297
310	Dr. Tariku Tadesse	\N	\N	EPOS 	General Director 	taarikuuguutee@gmail.com	0909900888	4	3	\N	\N	3	\N	\N	\N	\N	2024-12-21 19:29:12	2024-12-21 19:29:12	t	ARM2640041	t	\N	\N	\N	1	298	\N	Addis Ababa	298
311	Prof. Afework Kassu 	\N	\N	AHRI	General Director 	afework.kassu@ahri.gov.et	0911207865	4	1	\N	\N	1	\N	\N	\N	\N	2024-12-22 19:29:12	2024-12-22 19:29:12	t	ARM2640042	t	\N	\N	\N	4	299	\N	Addis Ababa	299
313	Mr. Tesfaye Worku 	\N	\N	EHIS	General Director 	Tesfayew885@gmail.com	0911867128	4	2	\N	\N	2	\N	\N	\N	\N	2024-12-24 19:29:12	2024-12-24 19:29:12	t	ARM2640044	t	\N	\N	\N	4	301	\N	Addis Ababa	301
314	DR. Abdulkedir Gelgelo	\N	\N	EPSS	General Director 	abdulkedir.gelgelo@epss.gov.et	0944.30.50.56	4	2	\N	\N	2	\N	\N	\N	\N	2024-12-25 19:29:12	2024-12-25 19:29:12	t	ARM2640045	t	\N	\N	\N	1	302	\N	Addis Ababa	302
315	Dr. Shimels Gezahegn 	\N	\N	ALERT CSH	CEO	gshime98@gmail.com	0911623754	2	5	\N	\N	5	\N	\N	\N	\N	2024-12-26 19:29:12	2024-12-26 19:29:12	t	ARM2620043	t	\N	\N	\N	1	303	\N	ADDIS ABABA	303
316	Dr. Abraham Eshetu 	\N	\N	St. Peter 	CEO	biniamnesru.1234@gmail.com	\N	2	4	\N	\N	4	\N	\N	\N	\N	2024-12-27 19:29:12	2024-12-27 19:29:12	t	ARM2620044	t	\N	\N	\N	2	304	\N	ADDIS ABABA	304
317	Dr. Muluken  Tesfaye	\N	\N	Eka Kotebe Hospital	CED	 Mulathea18@gmail.com 	0911637161	2	3	\N	\N	3	\N	\N	\N	\N	2024-12-28 19:29:12	2024-12-28 19:29:12	t	ARM2620045	t	\N	\N	\N	4	305	\N	ADDIS ABABA	305
318	EDAO FEJO 	\N	\N	Amanuel MSH	CED	edaofejo@yahoo.com	0930077546	2	3	\N	\N	3	\N	\N	\N	\N	2024-12-29 19:29:12	2024-12-29 19:29:12	t	ARM2620046	t	\N	\N	\N	3	306	\N	ADDIS ABABA	306
319	Dr. Sisay Sirgu	\N	\N	 SPHMMC	Provest	Sisay.sirgu@sphmmc.edu.et 	0911247720	2	4	\N	\N	4	\N	\N	\N	\N	2024-12-30 19:29:12	2024-12-30 19:29:12	t	ARM2620047	t	\N	\N	\N	1	307	\N	ADDIS ABABA	307
320	H.E Tirumar Abate	\N	\N	MPD	State Minister	atirumar@gmail.com	0953001290 	2	2	\N	\N	2	\N	\N	\N	\N	2024-12-31 19:29:12	2024-12-31 19:29:12	t	ARM2620048	t	\N	\N	\N	4	308	\N	ADDIS ABABA	308
324	Mr. Omod Ujulu 	\N	\N	Ministry of Justice 	State Minister 	mesker.tariku@moj.gov.et	0911748648	2	5	\N	\N	5	\N	\N	\N	\N	2025-01-04 19:29:12	2025-01-04 19:29:12	t	ARM2620051	t	\N	\N	\N	2	312	\N	ADDIS ABABA	312
325	Kefelech  Denbebo	\N	\N	Regation Minister 	N/A	executivesecretary.mills@gmail.com	0902483048	2	1	\N	\N	1	\N	\N	\N	\N	2025-01-05 19:29:12	2025-01-05 19:29:12	t	ARM2620052	t	\N	\N	\N	4	313	\N	ADDIS ABABA	313
328	Dr. Abdi Samuel	\N	\N	MoH	Senior Advisor	Abdi.Samuel@moh.gov.et	0917815478	2	5	\N	\N	5	\N	\N	\N	\N	2025-01-08 19:29:12	2025-01-08 19:29:12	t	ARM2620054	t	\N	\N	\N	2	316	\N	Addis Ababa	316
329	Mrs. Frehiwot Abebe	\N	\N	MoH	MoH State Minsiter 	\N	\N	4	1	\N	\N	1	\N	\N	\N	\N	2025-01-09 19:29:12	2025-01-09 19:29:12	t	ARM2640048	t	\N	\N	\N	1	317	\N	Addis Ababa	317
330	Dr. Ayele Teshome 	\N	\N	MoH	MoH State Minsiter 	\N	\N	4	4	\N	\N	4	\N	\N	\N	\N	2025-01-10 19:29:12	2025-01-10 19:29:12	t	ARM2640049	t	\N	\N	\N	3	318	\N	Addis Ababa	318
331	Dr. Yared Agidew 	\N	\N	MoH	Advisor 	N/A	\N	2	3	\N	\N	3	\N	\N	\N	\N	2025-01-11 19:29:12	2025-01-11 19:29:12	t	ARM2620055	t	\N	\N	\N	3	319	\N	Addis Ababa	319
332	Dr. Fantu  Abebe	\N	\N	MoH	Advisor 	N/A	\N	2	2	\N	\N	2	\N	\N	\N	\N	2025-01-12 19:29:12	2025-01-12 19:29:12	t	ARM2620056	t	\N	\N	\N	3	320	\N	Addis Ababa	320
333	Dr. Mekdes Daba	\N	\N	MoH	Minister 	\N	\N	4	1	\N	\N	1	\N	\N	\N	\N	2025-01-13 19:29:12	2025-01-13 19:29:12	t	ARM2640050	t	\N	\N	\N	1	321	\N	Addis Ababa	321
334	Dr. Ruth Nigatu 	\N	\N	MoH	Chief of Staff	\N	\N	2	4	\N	\N	4	\N	\N	\N	\N	2025-01-14 19:29:12	2025-01-14 19:29:12	t	ARM2620057	t	\N	\N	\N	3	322	\N	Addis Ababa	322
335	Mrs. Ulian Fiker 	\N	\N	MoH	Minister office 	N/A	\N	2	2	\N	\N	2	\N	\N	\N	\N	2025-01-15 19:29:12	2025-01-15 19:29:12	t	ARM2620058	t	\N	\N	\N	2	323	\N	Addis Ababa	323
336	Hiwot Darsene 	\N	\N	MoH	Lead Executive Officer	Hiwot.Darsene@moh.gov.et	\N	2	2	\N	\N	2	\N	\N	\N	\N	2025-01-16 19:29:12	2025-01-16 19:29:12	t	ARM2620059	t	\N	\N	\N	4	324	\N	Addis Ababa	324
337	Meles Tadesse 	\N	\N	MoH	 team lead 	Meles.Tadesse @moh.gov.et	\N	2	4	\N	\N	4	\N	\N	\N	\N	2025-01-17 19:29:12	2025-01-17 19:29:12	t	ARM2620060	t	\N	\N	\N	4	325	\N	Addis Ababa	325
338	Gudisa Assefa	\N	\N	MoH	team lead	gudissabayissa35@gmail.com 	0920499275	2	3	\N	\N	3	\N	\N	\N	\N	2025-01-18 19:29:12	2025-01-18 19:29:12	t	ARM2620061	t	\N	\N	\N	3	326	\N	Addis Ababa	326
339	Hamelmal Bekele	\N	\N	MoH	team lead 	Hamelmal.Bekele@moh.gov.et	\N	2	3	\N	\N	3	\N	\N	\N	\N	2025-01-19 19:29:12	2025-01-19 19:29:12	t	ARM2620062	t	\N	\N	\N	2	327	\N	Addis Ababa	327
340	Legesse Dibaba	\N	\N	MoH	team lead	\N	\N	2	2	\N	\N	2	\N	\N	\N	\N	2025-01-20 19:29:12	2025-01-20 19:29:12	t	ARM2620063	t	\N	\N	\N	4	328	\N	Addis Ababa	328
343	Mr.Abiy Dawit	\N	\N	MoH	team lead 	Abiy.Dawit@moh.gov.et	\N	2	4	\N	\N	4	\N	\N	\N	\N	2025-01-23 19:29:12	2025-01-23 19:29:12	t	ARM2620066	t	\N	\N	\N	3	331	\N	Addis Ababa	331
327	Dr. Dereje Dhuguma 	\N	\N	MoH	State Minsiter 	\N	\N	4	4	\N	\N	4	\N	\N	\N	\N	2025-01-07 19:29:12	2025-01-07 19:29:12	t	ARM2640047	t	\N	\N	\N	3	315	\N	Addis Ababa	315
306	Dr. Abel Asefa	\N	\N	GRHB	GRHB- Head 	chanie704@gmail.com	0965757106	4	3	\N	\N	3	\N	\N	\N	\N	2024-12-17 19:29:12	2024-12-17 19:29:12	t	ARM2640037	t	\N	\N	\N	3	294	\N	Gambella Region 	294
308	Dr. Ashenafi Tazebew 	\N	\N	EBTS	General Director 	ashenafitazebew1@gmail.com	 +251 992102707	4	1	\N	\N	1	\N	\N	\N	\N	2024-12-19 19:29:12	2024-12-19 19:29:12	t	ARM2640039	t	\N	\N	\N	1	296	\N	Addis Ababa	296
351	Dr.Abdilhalik Workicho	\N	\N	Fenot	Fenot	abdulhalikw@gmail.com	0913000000	11	3	\N	\N	3	\N	\N	\N	\N	2025-01-31 19:29:12	2025-01-31 19:29:12	t	ARM26110002	t	\N	\N	\N	1	339	\N	ADDIS ABABA	339
352	Dr. Awoke Misganaw	\N	\N	EPHI	NDMC	asterawoke2007@gmail.com 	0989966483	11	4	\N	\N	4	\N	\N	\N	\N	2025-02-01 19:29:12	2025-02-01 19:29:12	t	ARM26110003	t	\N	\N	\N	3	340	\N	ADDIS ABABA	340
353	Dr. Fentabil Getnet	\N	\N	EPHI	NDMC	b.infen4ever@gmail.com	0913000000	11	3	\N	\N	3	\N	\N	\N	\N	2025-02-02 19:29:12	2025-02-02 19:29:12	t	ARM26110004	t	\N	\N	\N	4	341	\N	ADDIS ABABA	341
354	Dr. Lemessa Oljira	\N	\N	Haramay University	-	olemessa@yahoo.com	0911408954	11	4	\N	\N	4	\N	\N	\N	\N	2025-02-03 19:29:12	2025-02-03 19:29:12	t	ARM26110005	t	\N	\N	\N	2	342	\N	ADDIS ABABA	342
355	Prof. Sultan Suleman	\N	\N	Jimma University	-	sultan.suleman@ju.edu.et	0911742354	11	5	\N	\N	5	\N	\N	\N	\N	2025-02-04 19:29:12	2025-02-04 19:29:12	t	ARM26110006	t	\N	\N	\N	2	343	\N	ADDIS ABABA	343
356	Tariku Tesfaye 	\N	\N	Wellega University	-	tarii2007@gmail.com	0920233798	11	1	\N	\N	1	\N	\N	\N	\N	2025-02-05 19:29:12	2025-02-05 19:29:12	t	ARM26110007	t	\N	\N	\N	3	344	\N	ADDIS ABABA	344
357	Prof. Gemeda Abebe	\N	\N	Jimma Uinversity	-	moa.ayana@gmail.com	0911991285	11	5	\N	\N	5	\N	\N	\N	\N	2025-02-06 19:29:12	2025-02-06 19:29:12	t	ARM26110008	t	\N	\N	\N	1	345	\N	ADDIS ABABA	345
358	Alemnesh Mirkuzie (PhD)	\N	\N	JSI/L10K	-	alemmirkuzie@yahoo.com	0929376628	11	4	\N	\N	4	\N	\N	\N	\N	2025-02-07 19:29:12	2025-02-07 19:29:12	t	ARM26110009	t	\N	\N	\N	3	346	\N	ADDIS ABABA	346
359	Dr. Zenebu Begna	\N	\N	Fenot	-	zbayissa@hsph.harvard.edu; zeni.begna@gmail.com	0913229623	11	4	\N	\N	4	\N	\N	\N	\N	2025-02-08 19:29:12	2025-02-08 19:29:12	t	ARM26110010	t	\N	\N	\N	1	347	\N	ADDIS ABABA	347
360	Dr.Kedir Seid	\N	\N	SAEO/MOH	-	kedirask2015@gmail.com	0946853190	11	5	\N	\N	5	\N	\N	\N	\N	2025-02-09 19:29:12	2025-02-09 19:29:12	t	ARM26110011	t	\N	\N	\N	2	348	\N	ADDIS ABABA	348
361	Mr.Lemma Gutema	\N	\N	SAEO/MOH	-	lemma_gutema@et.jsi.com 	0911463560	11	5	\N	\N	5	\N	\N	\N	\N	2025-02-10 19:29:12	2025-02-10 19:29:12	t	ARM26110012	t	\N	\N	\N	1	349	\N	ADDIS ABABA	349
362	Mr.Solomon Kasahun	\N	\N	SAEO/MOH	-	solomonkassahun44@gmail.com 	0921528735	11	4	\N	\N	4	\N	\N	\N	\N	2025-02-11 19:29:12	2025-02-11 19:29:12	t	ARM26110013	t	\N	\N	\N	2	350	\N	ADDIS ABABA	350
363	Dr. Belete Getahun	\N	\N	SAEO/MOH	-	beletegetahunwoldeyes@gmail.com 	0911602272	11	3	\N	\N	3	\N	\N	\N	\N	2025-02-12 19:29:12	2025-02-12 19:29:12	t	ARM26110014	t	\N	\N	\N	4	351	\N	ADDIS ABABA	351
364	Mr. Tsedeke Mathiwos	\N	\N	SAEO/MOH	Coordinator 	tsede171@gmail.com 	91268688	10	3	\N	\N	3	\N	\N	\N	\N	2025-02-13 19:29:12	2025-02-13 19:29:12	t	ARM26100001	t	\N	\N	\N	3	352	\N	ADDIS ABABA	352
365	Mr. Shegaw Mulu	\N	\N	SAEO/MOH	Coordinator 	shegawmulu@gmail.com 	911316123	10	4	\N	\N	4	\N	\N	\N	\N	2025-02-14 19:29:12	2025-02-14 19:29:12	t	ARM26100002	t	\N	\N	\N	1	353	\N	ADDIS ABABA	353
366	Mr. Yoseph Zeru	\N	\N	SAEO/MOH	Coordinator 	yosefzeru@gmail.com 	910721591	10	2	\N	\N	2	\N	\N	\N	\N	2025-02-15 19:29:12	2025-02-15 19:29:12	t	ARM26100003	t	\N	\N	\N	4	354	\N	ADDIS ABABA	354
367	Mr. Tamrat Awel	\N	\N	SAEO/MOH	Coordinator 	tamirat.awel@moh.gov.et,\ntamratawell@gmail.com	912714644	10	4	\N	\N	4	\N	\N	\N	\N	2025-02-16 19:29:12	2025-02-16 19:29:12	t	ARM26100004	t	\N	\N	\N	2	355	\N	ADDIS ABABA	355
368	Mr. Tewabe Manaye	\N	\N	SAEO/MOH	Coordinator 	tewabemanaye@gmail.com 	912464269	10	5	\N	\N	5	\N	\N	\N	\N	2025-02-17 19:29:12	2025-02-17 19:29:12	t	ARM26100005	t	\N	\N	\N	3	356	\N	ADDIS ABABA	356
369	Mrs. Dule Tagessu	\N	\N	SAEO/MOH	Coordinator 	dulejirata@gmail.com 	913199423	10	4	\N	\N	4	\N	\N	\N	\N	2025-02-18 19:29:12	2025-02-18 19:29:12	t	ARM26100006	t	\N	\N	\N	1	357	\N	ADDIS ABABA	357
370	Mr. Gadissa Lemecha	\N	\N	SAEO/MOH	Coordinator 	ketema_muluneh@et.jsi.com 	911179076	10	5	\N	\N	5	\N	\N	\N	\N	2025-02-19 19:29:12	2025-02-19 19:29:12	t	ARM26100007	t	\N	\N	\N	2	358	\N	ADDIS ABABA	358
371	Mrs. Azeb Lemma	\N	\N	SAEO/MOH	Coordinator 	gadissal2@gmail.com 	911693380	10	1	\N	\N	1	\N	\N	\N	\N	2025-02-20 19:29:12	2025-02-20 19:29:12	t	ARM26100008	t	\N	\N	\N	4	359	\N	ADDIS ABABA	359
372	Mrs.Tamenech Teshome	\N	\N	SAEO/MOH	Coordinator 	ashubez2@gmail.com, ashenafi.beza@moh.gov.et	912065857	10	1	\N	\N	1	\N	\N	\N	\N	2025-02-21 19:29:12	2025-02-21 19:29:12	t	ARM26100009	t	\N	\N	\N	3	360	\N	ADDIS ABABA	360
373	Mr.Ketema Muluneh	\N	\N	SAEO/MOH	Coordinator 	azeblemma29@gmail.com	911346403	10	4	\N	\N	4	\N	\N	\N	\N	2025-02-22 19:29:12	2025-02-22 19:29:12	t	ARM26100010	t	\N	\N	\N	4	361	\N	ADDIS ABABA	361
374	Dr. Ashenafi Beza	\N	\N	SAEO/MOH	Coordinator 	tamenehtechteshomesong1989@gmail.com	910791091	10	4	\N	\N	4	\N	\N	\N	\N	2025-02-23 19:29:12	2025-02-23 19:29:12	t	ARM26100011	t	\N	\N	\N	1	362	\N	ADDIS ABABA	362
375	Mr.Alemayheu Bogale	\N	\N	SAEO/MOH	Coordinator 	alemayehu.bogale@moh.gov.et 	911871315	10	4	\N	\N	4	\N	\N	\N	\N	2025-02-24 19:29:12	2025-02-24 19:29:12	t	ARM26100012	t	\N	\N	\N	2	363	\N	ADDIS ABABA	363
376	Mr.Hailu Dawo	\N	\N	SAEO/MOH	Coordinator 	hailu.dawo@moh.gov.et	910113949	10	3	\N	\N	3	\N	\N	\N	\N	2025-02-25 19:29:12	2025-02-25 19:29:12	t	ARM26100013	t	\N	\N	\N	3	364	\N	ADDIS ABABA	364
377	Mr.Mesfin Kebede	\N	\N	SAEO/MOH	Coordinator 	N/A	0913000000	10	1	\N	\N	1	\N	\N	\N	\N	2025-02-26 19:29:12	2025-02-26 19:29:12	t	ARM26100014	t	\N	\N	\N	3	365	\N	ADDIS ABABA	365
378	Mr.Wendwosen Ayel	\N	\N	SAEO/MOH	Coordinator 	N/A	0911408954	10	4	\N	\N	4	\N	\N	\N	\N	2025-02-27 19:29:12	2025-02-27 19:29:12	t	ARM26100015	t	\N	\N	\N	1	366	\N	ADDIS ABABA	366
379	Mr. Wasihun Tilahun	\N	\N	SAEO/MOH	Coordinator 	N/A	0911742354	10	1	\N	\N	1	\N	\N	\N	\N	2025-02-28 19:29:12	2025-02-28 19:29:12	t	ARM26100016	t	\N	\N	\N	3	367	\N	ADDIS ABABA	367
380	Mr.Animut Ayalew	\N	\N	SAEO/MOH	Coordinator 	N/A	0920233798	10	2	\N	\N	2	\N	\N	\N	\N	2025-03-01 19:29:12	2025-03-01 19:29:12	t	ARM26100017	t	\N	\N	\N	3	368	\N	ADDIS ABABA	368
381	Dr. Selamawit Getachew	\N	\N	SAEO/MOH	Coordinator 	N/A	0911991285	10	3	\N	\N	3	\N	\N	\N	\N	2025-03-02 19:29:12	2025-03-02 19:29:12	t	ARM26100018	t	\N	\N	\N	1	369	\N	ADDIS ABABA	369
382	Mr.Leulseged Nigusse	\N	\N	SAEO/MOH	Coordinator 	N/A	0929376628	10	4	\N	\N	4	\N	\N	\N	\N	2025-03-03 19:29:12	2025-03-03 19:29:12	t	ARM26100019	t	\N	\N	\N	3	370	\N	ADDIS ABABA	370
383	Mrs.Seble Abebe	\N	\N	MoH-PR 	Coordinator 	N/A	0911463560	10	5	\N	\N	5	\N	\N	\N	\N	2025-03-04 19:29:12	2025-03-04 19:29:12	t	ARM26100020	t	\N	\N	\N	2	371	\N	ADDIS ABABA	371
384	Mr. Afework Yihiune	\N	\N	MoH-PR 	Coordinator 	N/A	0921528735	10	1	\N	\N	1	\N	\N	\N	\N	2025-03-05 19:29:12	2025-03-05 19:29:12	t	ARM26100021	t	\N	\N	\N	3	372	\N	ADDIS ABABA	372
385	Mr. Daniel Betre 	\N	\N	MoH-PR 	Coordinator 	N/A	0911602272	10	5	\N	\N	5	\N	\N	\N	\N	2025-03-06 19:29:12	2025-03-06 19:29:12	t	ARM26100022	t	\N	\N	\N	1	373	\N	ADDIS ABABA	373
386	Mrs.Wubishet Tadesse	\N	\N	MoH-PR 	Coordinator 	N/A	91268688	10	4	\N	\N	4	\N	\N	\N	\N	2025-03-07 19:29:12	2025-03-07 19:29:12	t	ARM26100023	t	\N	\N	\N	3	374	\N	ADDIS ABABA	374
387	Mr.Ahmed Mohammed	\N	\N	MoH-PR 	Coordinator 	N/A	911316123	10	4	\N	\N	4	\N	\N	\N	\N	2025-03-08 19:29:12	2025-03-08 19:29:12	t	ARM26100024	t	\N	\N	\N	1	375	\N	ADDIS ABABA	375
388	Mr.Yalew Getachew	\N	\N	MoH-PR 	Coordinator 	N/A	910721591	10	5	\N	\N	5	\N	\N	\N	\N	2025-03-09 19:29:12	2025-03-09 19:29:12	t	ARM26100025	t	\N	\N	\N	2	376	\N	ADDIS ABABA	376
389	Mr.Nigussu G/Yesus 	\N	\N	MoH-PR 	Coordinator 	N/A	912714644	10	5	\N	\N	5	\N	\N	\N	\N	2025-03-10 19:29:12	2025-03-10 19:29:12	t	ARM26100026	t	\N	\N	\N	1	377	\N	ADDIS ABABA	377
390	Mr.Yewendwosen Birhanu 	\N	\N	MoH-PR 	Coordinator 	N/A	912464269	10	4	\N	\N	4	\N	\N	\N	\N	2025-03-11 19:29:12	2025-03-11 19:29:12	t	ARM26100027	t	\N	\N	\N	2	378	\N	ADDIS ABABA	378
391	Mr. Marta Wolde 	\N	\N	MoH-PR 	Coordinator 	N/A	913199423	10	3	\N	\N	3	\N	\N	\N	\N	2025-03-12 19:29:12	2025-03-12 19:29:12	t	ARM26100028	t	\N	\N	\N	4	379	\N	ADDIS ABABA	379
392	Mr. H/mariam Addise	\N	\N	MoH-PR 	Coordinator 	N/A	911179076	10	3	\N	\N	3	\N	\N	\N	\N	2025-03-13 19:29:12	2025-03-13 19:29:12	t	ARM26100029	t	\N	\N	\N	3	380	\N	ADDIS ABABA	380
393	Mr. Liyu Tadesse 	\N	\N	MoH-PR 	Coordinator 	N/A	911693380	10	4	\N	\N	4	\N	\N	\N	\N	2025-03-14 19:29:12	2025-03-14 19:29:12	t	ARM26100030	t	\N	\N	\N	1	381	\N	ADDIS ABABA	381
394	Mr. Abel Wubayehu	\N	\N	MoH-PR 	Coordinator 	N/A	912065857	10	2	\N	\N	2	\N	\N	\N	\N	2025-03-15 19:29:12	2025-03-15 19:29:12	t	ARM26100031	t	\N	\N	\N	4	382	\N	ADDIS ABABA	382
395	Mr. Zewde Gulema	\N	\N	MoH-PR 	Coordinator 	N/A	911346403	10	4	\N	\N	4	\N	\N	\N	\N	2025-03-16 19:29:12	2025-03-16 19:29:12	t	ARM26100032	t	\N	\N	\N	2	383	\N	ADDIS ABABA	383
396	Mr.Tsega Gebreyes	\N	\N	MoH-PR 	Coordinator 	N/A	910791091	10	5	\N	\N	5	\N	\N	\N	\N	2025-03-17 19:29:12	2025-03-17 19:29:12	t	ARM26100033	t	\N	\N	\N	3	384	\N	ADDIS ABABA	384
397	Mr.Dawit Birhanu	\N	\N	MoH-PR 	Coordinator 	N/A	911871315	10	4	\N	\N	4	\N	\N	\N	\N	2025-03-18 19:29:12	2025-03-18 19:29:12	t	ARM26100034	t	\N	\N	\N	1	385	\N	ADDIS ABABA	385
398	Mr.Hiwot Yimer 	\N	\N	MoH-PR 	Coordinator 	N/A	910113949	10	5	\N	\N	5	\N	\N	\N	\N	2025-03-19 19:29:12	2025-03-19 19:29:12	t	ARM26100035	t	\N	\N	\N	2	386	\N	ADDIS ABABA	386
399	Mr.Yonatan Getahun 	\N	\N	MoH-PR 	Coordinator 	N/A	\N	10	1	\N	\N	1	\N	\N	\N	\N	2025-03-20 19:29:12	2025-03-20 19:29:12	t	ARM26100036	t	\N	\N	\N	4	387	\N	ADDIS ABABA	387
107	Fekadu mazengia	\N	\N	ADDIS ABABA	Executive director	fekadum@emwa.org.et	924542858	2	4	\N	\N	4	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2620041	t	\N	\N	\N	2	229	\N	EMA	238
400	Mr.Tesfamichael Afework 	\N	\N	MoH-PR 	Coordinator 	N/A	\N	10	1	\N	\N	1	\N	\N	\N	\N	2025-03-21 19:29:12	2025-03-21 19:29:12	t	ARM26100037	t	\N	\N	\N	3	388	\N	ADDIS ABABA	388
401	Mrs. Menbere Belay 	\N	\N	MoH-PR 	Coordinator 	N/A	\N	10	4	\N	\N	4	\N	\N	\N	\N	2025-03-22 19:29:12	2025-03-22 19:29:12	t	ARM26100038	t	\N	\N	\N	4	389	\N	ADDIS ABABA	389
402	Mr. Endeshaw Dege 	\N	\N	MoH-PR 	Coordinator 	N/A	\N	10	4	\N	\N	4	\N	\N	\N	\N	2025-03-23 19:29:12	2025-03-23 19:29:12	t	ARM26100039	t	\N	\N	\N	1	390	\N	ADDIS ABABA	390
403	Mrs. Seble Mekonen	\N	\N	MOH-BSE 	USHER	N/A	\N	10	4	\N	\N	4	\N	\N	\N	\N	2025-03-24 19:29:12	2025-03-24 19:29:12	t	ARM26100040	t	\N	\N	\N	2	391	\N	ADDIS ABABA	391
404	Mrs.Helen getachew 	\N	\N	MOH-BSE 	USHER	N/A	\N	10	3	\N	\N	3	\N	\N	\N	\N	2025-03-25 19:29:12	2025-03-25 19:29:12	t	ARM26100041	t	\N	\N	\N	3	392	\N	ADDIS ABABA	392
405	Mrs. Tigist Admasu	\N	\N	MOH-BSE 	USHER	N/A	\N	10	1	\N	\N	1	\N	\N	\N	\N	2025-03-26 19:29:12	2025-03-26 19:29:12	t	ARM26100042	t	\N	\N	\N	3	393	\N	ADDIS ABABA	393
406	Mrs. Soriti Workneh	\N	\N	MOH-BSE 	USHER	N/A	\N	10	4	\N	\N	4	\N	\N	\N	\N	2025-03-27 19:29:12	2025-03-27 19:29:12	t	ARM26100043	t	\N	\N	\N	1	394	\N	ADDIS ABABA	394
407	Mrs. Alelign Tiruneh	\N	\N	MOH-BSE 	USHER	N/A	\N	10	1	\N	\N	1	\N	\N	\N	\N	2025-03-28 19:29:12	2025-03-28 19:29:12	t	ARM26100044	t	\N	\N	\N	3	395	\N	ADDIS ABABA	395
408	Mr. Workneh Demsie 	\N	\N	MOH-BSE 	USHER	N/A	\N	10	2	\N	\N	2	\N	\N	\N	\N	2025-03-29 19:29:12	2025-03-29 19:29:12	t	ARM26100045	t	\N	\N	\N	3	396	\N	ADDIS ABABA	396
409	Mr. Alazar Awoke	\N	\N	MOH-BSE 	USHER	N/A	\N	10	3	\N	\N	3	\N	\N	\N	\N	2025-03-30 19:29:12	2025-03-30 19:29:12	t	ARM26100046	t	\N	\N	\N	1	397	\N	ADDIS ABABA	397
410	Mr.Mesafint Girma	\N	\N	MOH-BSE 	USHER	N/A	\N	10	4	\N	\N	4	\N	\N	\N	\N	2025-03-31 19:29:12	2025-03-31 19:29:12	t	ARM26100047	t	\N	\N	\N	3	398	\N	ADDIS ABABA	398
411	Mr. Meseret Melaku	\N	\N	MOH-BSE 	USHER	N/A	\N	10	3	\N	\N	3	\N	\N	\N	\N	2025-04-01 19:29:12	2025-04-01 19:29:12	t	ARM26100048	t	\N	\N	\N	4	399	\N	ADDIS ABABA	399
412	Mrs. Elsa tekle 	\N	\N	MOH-BSE 	USHER	N/A	\N	10	4	\N	\N	4	\N	\N	\N	\N	2025-04-02 19:29:12	2025-04-02 19:29:12	t	ARM26100049	t	\N	\N	\N	2	400	\N	ADDIS ABABA	400
413	Mrs. Beletshachew Abatye 	\N	\N	MOH-BSE 	USHER	N/A	\N	10	5	\N	\N	5	\N	\N	\N	\N	2025-04-03 19:29:12	2025-04-03 19:29:12	t	ARM26100050	t	\N	\N	\N	2	401	\N	ADDIS ABABA	401
414	Mrs. Wogayehu Mamo	\N	\N	MOH-BSE 	USHER	N/A	\N	10	1	\N	\N	1	\N	\N	\N	\N	2025-04-04 19:29:12	2025-04-04 19:29:12	t	ARM26100051	t	\N	\N	\N	3	402	\N	ADDIS ABABA	402
415	Mrs. Sosina Birehanu	\N	\N	MOH-BSE 	USHER	N/A	\N	10	5	\N	\N	5	\N	\N	\N	\N	2025-04-05 19:29:12	2025-04-05 19:29:12	t	ARM26100052	t	\N	\N	\N	1	403	\N	ADDIS ABABA	403
416	Mrs.Serkalem Alemu	\N	\N	MOH-BSE 	USHER	N/A	\N	10	4	\N	\N	4	\N	\N	\N	\N	2025-04-06 19:29:12	2025-04-06 19:29:12	t	ARM26100053	t	\N	\N	\N	3	404	\N	ADDIS ABABA	404
417	Mrs.Netsanet Aragaw	\N	\N	MOH-BSE 	USHER	N/A	\N	10	4	\N	\N	4	\N	\N	\N	\N	2025-04-07 19:29:12	2025-04-07 19:29:12	t	ARM26100054	t	\N	\N	\N	1	405	\N	ADDIS ABABA	405
418	Mrs. Hanna Getachew 	\N	\N	MOH-BSE 	USHER	N/A	\N	10	5	\N	\N	5	\N	\N	\N	\N	2025-04-08 19:29:12	2025-04-08 19:29:12	t	ARM26100055	t	\N	\N	\N	2	406	\N	ADDIS ABABA	406
419	Mrs. Biruktawit Teshome 	\N	\N	MOH-BSE 	USHER	N/A	\N	10	5	\N	\N	5	\N	\N	\N	\N	2025-04-09 19:29:12	2025-04-09 19:29:12	t	ARM26100056	t	\N	\N	\N	1	407	\N	ADDIS ABABA	407
420	Mrs. Fikrte Tomas	\N	\N	MOH-BSE 	USHER	N/A	\N	10	4	\N	\N	4	\N	\N	\N	\N	2025-04-10 19:29:12	2025-04-10 19:29:12	t	ARM26100057	t	\N	\N	\N	2	408	\N	ADDIS ABABA	408
421	Mr. Zerihun Tariku	\N	\N	MOH-BSE 	USHER	N/A	\N	10	3	\N	\N	3	\N	\N	\N	\N	2025-04-11 19:29:12	2025-04-11 19:29:12	t	ARM26100058	t	\N	\N	\N	4	409	\N	ADDIS ABABA	409
422	Mrs. Tsigereda Birehanu 	\N	\N	MOH-BSE 	USHER	N/A	\N	10	3	\N	\N	3	\N	\N	\N	\N	2025-04-12 19:29:12	2025-04-12 19:29:12	t	ARM26100059	t	\N	\N	\N	3	410	\N	ADDIS ABABA	410
423	Mrs.Sara Kasahun	\N	\N	MOH-BSE 	USHER	N/A	\N	10	4	\N	\N	4	\N	\N	\N	\N	2025-04-13 19:29:12	2025-04-13 19:29:12	t	ARM26100060	t	\N	\N	\N	1	411	\N	ADDIS ABABA	411
424	Mrs. Meaza Mulugeta 	\N	\N	MOH-BSE 	USHER	N/A	\N	10	2	\N	\N	2	\N	\N	\N	\N	2025-04-14 19:29:12	2025-04-14 19:29:12	t	ARM26100061	t	\N	\N	\N	4	412	\N	ADDIS ABABA	412
425	Mr. Abebe Feyisa	\N	\N	MOH-BSE 	USHER	N/A	\N	10	3	\N	\N	3	\N	\N	\N	\N	2025-04-15 19:29:12	2025-04-15 19:29:12	t	ARM26100062	t	\N	\N	\N	4	413	\N	ADDIS ABABA	413
426	Mr.Assfaw Kelbessa 	\N	\N	MOH-DHLEO	Coordinator 	N/A	\N	10	4	\N	\N	4	\N	\N	\N	\N	2025-04-16 19:29:12	2025-04-16 19:29:12	t	ARM26100063	t	\N	\N	\N	2	414	\N	ADDIS ABABA	414
427	Mr.Abinet Seyife 	\N	\N	MOH-DHLEO	Coordinator 	N/A	\N	10	3	\N	\N	3	\N	\N	\N	\N	2025-04-17 19:29:12	2025-04-17 19:29:12	t	ARM26100064	t	\N	\N	\N	3	415	\N	ADDIS ABABA	415
428	Mr. Antensay Amare 	\N	\N	MOH-DHLEO	Coordinator 	N/A	\N	10	1	\N	\N	1	\N	\N	\N	\N	2025-04-18 19:29:12	2025-04-18 19:29:12	t	ARM26100065	t	\N	\N	\N	3	416	\N	ADDIS ABABA	416
429	Mr. Alem Abera 	\N	\N	MOH-DHLEO	Coordinator 	N/A	\N	10	4	\N	\N	4	\N	\N	\N	\N	2025-04-19 19:29:12	2025-04-19 19:29:12	t	ARM26100066	t	\N	\N	\N	1	417	\N	ADDIS ABABA	417
430	Mr. Gezahegn Feyissa	\N	\N	MOH-DHLEO	Coordinator 	N/A	\N	10	1	\N	\N	1	\N	\N	\N	\N	2025-04-20 19:29:12	2025-04-20 19:29:12	t	ARM26100067	t	\N	\N	\N	3	418	\N	ADDIS ABABA	418
431	Mr. Gashaw Ayalew 	\N	\N	MOH-FE  	Coordinator 	N/A	\N	10	2	\N	\N	2	\N	\N	\N	\N	2025-04-21 19:29:12	2025-04-21 19:29:12	t	ARM26100068	t	\N	\N	\N	3	419	\N	ADDIS ABABA	419
432	Mr. Adu Aderajew	\N	\N	MOH-FE  	Coordinator 	N/A	\N	10	3	\N	\N	3	\N	\N	\N	\N	2025-04-22 19:29:12	2025-04-22 19:29:12	t	ARM26100069	t	\N	\N	\N	1	420	\N	ADDIS ABABA	420
433	Mrs. Birtukan Abate	\N	\N	MOH-FE  	Coordinator 	N/A	\N	10	4	\N	\N	4	\N	\N	\N	\N	2025-04-23 19:29:12	2025-04-23 19:29:12	t	ARM26100070	t	\N	\N	\N	3	421	\N	ADDIS ABABA	421
434	Mrs. Kidist Abiza	\N	\N	MOH-FE  	Coordinator 	N/A	\N	10	3	\N	\N	3	\N	\N	\N	\N	2025-04-24 19:29:12	2025-04-24 19:29:12	t	ARM26100071	t	\N	\N	\N	4	422	\N	ADDIS ABABA	422
435	Mrs. Mebrat G/Medihn	\N	\N	MOH-FE  	Coordinator 	N/A	\N	10	4	\N	\N	4	\N	\N	\N	\N	2025-04-25 19:29:12	2025-04-25 19:29:12	t	ARM26100072	t	\N	\N	\N	2	423	\N	ADDIS ABABA	423
436	Mr. Gashaw Tebabel	\N	\N	MOH-FE  	Coordinator 	N/A	\N	10	5	\N	\N	5	\N	\N	\N	\N	2025-04-26 19:29:12	2025-04-26 19:29:12	t	ARM26100073	t	\N	\N	\N	2	424	\N	ADDIS ABABA	424
437	Mr. Feyera Olana	\N	\N	MOH-FE  	Coordinator 	N/A	\N	10	1	\N	\N	1	\N	\N	\N	\N	2025-04-27 19:29:12	2025-04-27 19:29:12	t	ARM26100074	t	\N	\N	\N	3	425	\N	ADDIS ABABA	425
438	Mrs. Yenealem Endale	\N	\N	MOH-FE  	Coordinator 	N/A	\N	10	5	\N	\N	5	\N	\N	\N	\N	2025-04-28 19:29:12	2025-04-28 19:29:12	t	ARM26100075	t	\N	\N	\N	1	426	\N	ADDIS ABABA	426
439	Mr. Dejyitenu Mulaw 	\N	\N	AHRI	Exhibitors 	N/A	0911 74 79 38	7	1	\N	\N	1	\N	\N	\N	\N	2025-04-29 19:29:12	2025-04-29 19:29:12	t	ARM2670001	t	\N	\N	\N	3	427	\N	ADDIS ABABA	427
440	Firew Atikelt 	\N	\N	MOH-HI	Exhibitors 	N/A	911787374	7	4	\N	\N	4	\N	\N	\N	\N	2025-04-30 19:29:12	2025-04-30 19:29:12	t	ARM2670002	t	\N	\N	\N	4	428	\N	ADDIS ABABA	428
441	Mulualem Mekete 	\N	\N	Eka Kotebe Hospital	Exhibitors 	N/A	920531570	7	4	\N	\N	4	\N	\N	\N	\N	2025-05-01 19:29:12	2025-05-01 19:29:12	t	ARM2670003	t	\N	\N	\N	1	429	\N	ADDIS ABABA	429
442	Alemseged chane	\N	\N	ALERT CSH	Exhibitors 	N/A	911090965	7	4	\N	\N	4	\N	\N	\N	\N	2025-05-02 19:29:12	2025-05-02 19:29:12	t	ARM2670004	t	\N	\N	\N	2	430	\N	ADDIS ABABA	430
443	Neway Tsegaye	\N	\N	St. Peter	Exhibitors 	N/A	911502551	7	3	\N	\N	3	\N	\N	\N	\N	2025-05-03 19:29:12	2025-05-03 19:29:12	t	ARM2670005	t	\N	\N	\N	3	431	\N	ADDIS ABABA	431
444	Alemayehu Tarekegn 	\N	\N	Blood and Tissue Bank	Exhibitors 	N/A	911094638	7	1	\N	\N	1	\N	\N	\N	\N	2025-05-04 19:29:12	2025-05-04 19:29:12	t	ARM2670006	t	\N	\N	\N	3	432	\N	ADDIS ABABA	432
230	Alebel Dessie	\N	\N	ADDIS ABABA	Deputy Director	bantam2011luck@gmail.com	ዐ9299ዐ778ዐ	4	1	\N	\N	1	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	t	ARM2640024	t	\N	\N	\N	3	226	\N	Policy Institute	235
445	Awol Hassen 	\N	\N	EPSS	Exhibitors 	N/A	943516005	7	4	\N	\N	4	\N	\N	\N	\N	2025-05-05 19:29:12	2025-05-05 19:29:12	t	ARM2670007	t	\N	\N	\N	1	433	\N	ADDIS ABABA	433
446	Abera Deneke 	\N	\N	EFDA 	Exhibitors 	N/A	936641290	7	1	\N	\N	1	\N	\N	\N	\N	2025-05-06 19:29:12	2025-05-06 19:29:12	t	ARM2670008	t	\N	\N	\N	3	434	\N	ADDIS ABABA	434
447	Nahom Firdawok 	\N	\N	St. Peter	Exhibitors 	N/A	919600427	7	2	\N	\N	2	\N	\N	\N	\N	2025-05-07 19:29:12	2025-05-07 19:29:12	t	ARM2670009	t	\N	\N	\N	3	435	\N	ADDIS ABABA	435
448	Shimeles Arega Reta	\N	\N	CBHI	Exhibitors 	N/A	913075779	7	3	\N	\N	3	\N	\N	\N	\N	2025-05-08 19:29:12	2025-05-08 19:29:12	t	ARM2670010	t	\N	\N	\N	1	436	\N	ADDIS ABABA	436
492	AGENCY DRIVER	\N	\N	ADDIS ABABA	DRIVER	N/A	N/A	10	6	\N	\N	6	\N	\N	\N	\N	2025-06-21 19:29:12	2025-06-21 19:29:12	t	ARM26100078	t	\N	\N	\N	5	480	\N	ADDIS ABABA	480
493	AGENCY DRIVER	\N	\N	ADDIS ABABA	DRIVER	N/A	N/A	10	6	\N	\N	6	\N	\N	\N	\N	2025-06-22 19:29:12	2025-06-22 19:29:12	t	ARM26100079	t	\N	\N	\N	5	481	\N	ADDIS ABABA	481
494	AGENCY DRIVER	\N	\N	ADDIS ABABA	DRIVER	N/A	N/A	10	6	\N	\N	6	\N	\N	\N	\N	2025-06-23 19:29:12	2025-06-23 19:29:12	t	ARM26100080	t	\N	\N	\N	5	482	\N	ADDIS ABABA	482
495	AGENCY DRIVER	\N	\N	ADDIS ABABA	DRIVER	N/A	N/A	10	6	\N	\N	6	\N	\N	\N	\N	2025-06-24 19:29:12	2025-06-24 19:29:12	t	ARM26100081	t	\N	\N	\N	5	483	\N	ADDIS ABABA	483
496	AGENCY DRIVER	\N	\N	ADDIS ABABA	DRIVER	N/A	N/A	10	6	\N	\N	6	\N	\N	\N	\N	2025-06-25 19:29:12	2025-06-25 19:29:12	t	ARM26100082	t	\N	\N	\N	5	484	\N	ADDIS ABABA	484
497	AGENCY DRIVER	\N	\N	ADDIS ABABA	DRIVER	N/A	N/A	10	6	\N	\N	6	\N	\N	\N	\N	2025-06-26 19:29:12	2025-06-26 19:29:12	t	ARM26100083	t	\N	\N	\N	5	485	\N	ADDIS ABABA	485
498	RHB DRIVER 	\N	\N	REGION 	DRIVER	N/A	N/A	10	6	\N	\N	6	\N	\N	\N	\N	2025-06-27 19:29:12	2025-06-27 19:29:12	t	ARM26100084	t	\N	\N	\N	5	486	\N	REGION 	486
499	RHB DRIVER 	\N	\N	REGION 	DRIVER	N/A	N/A	10	6	\N	\N	6	\N	\N	\N	\N	2025-06-28 19:29:12	2025-06-28 19:29:12	t	ARM26100085	t	\N	\N	\N	5	487	\N	REGION 	487
500	RHB DRIVER 	\N	\N	REGION 	DRIVER	N/A	N/A	10	6	\N	\N	6	\N	\N	\N	\N	2025-06-29 19:29:12	2025-06-29 19:29:12	t	ARM26100086	t	\N	\N	\N	5	488	\N	REGION 	488
501	RHB DRIVER 	\N	\N	REGION 	DRIVER	N/A	N/A	10	6	\N	\N	6	\N	\N	\N	\N	2025-06-30 19:29:12	2025-06-30 19:29:12	t	ARM26100087	t	\N	\N	\N	5	489	\N	REGION 	489
502	RHB DRIVER 	\N	\N	REGION 	DRIVER	N/A	N/A	10	6	\N	\N	6	\N	\N	\N	\N	2025-07-01 19:29:12	2025-07-01 19:29:12	t	ARM26100088	t	\N	\N	\N	5	490	\N	REGION 	490
503	RHB DRIVER 	\N	\N	REGION 	DRIVER	N/A	N/A	10	6	\N	\N	6	\N	\N	\N	\N	2025-07-02 19:29:12	2025-07-02 19:29:12	t	ARM26100089	t	\N	\N	\N	5	491	\N	REGION 	491
504	RHB DRIVER 	\N	\N	REGION 	DRIVER	N/A	N/A	10	6	\N	\N	6	\N	\N	\N	\N	2025-07-03 19:29:12	2025-07-03 19:29:12	t	ARM26100090	t	\N	\N	\N	5	492	\N	REGION 	492
505	RHB DRIVER 	\N	\N	REGION 	DRIVER	N/A	N/A	10	6	\N	\N	6	\N	\N	\N	\N	2025-07-04 19:29:12	2025-07-04 19:29:12	t	ARM26100091	t	\N	\N	\N	5	493	\N	REGION 	493
506	RHB DRIVER 	\N	\N	REGION 	DRIVER	N/A	N/A	10	6	\N	\N	6	\N	\N	\N	\N	2025-07-05 19:29:12	2025-07-05 19:29:12	t	ARM26100092	t	\N	\N	\N	5	494	\N	REGION 	494
507	RHB DRIVER 	\N	\N	REGION 	DRIVER	N/A	N/A	10	6	\N	\N	6	\N	\N	\N	\N	2025-07-06 19:29:12	2025-07-06 19:29:12	t	ARM26100093	t	\N	\N	\N	5	495	\N	REGION 	495
508	RHB DRIVER 	\N	\N	REGION 	DRIVER	N/A	N/A	10	6	\N	\N	6	\N	\N	\N	\N	2025-07-07 19:29:12	2025-07-07 19:29:12	t	ARM26100094	t	\N	\N	\N	5	496	\N	REGION 	496
509	RHB DRIVER 	\N	\N	REGION 	DRIVER	N/A	N/A	10	6	\N	\N	6	\N	\N	\N	\N	2025-07-08 19:29:12	2025-07-08 19:29:12	t	ARM26100095	t	\N	\N	\N	5	497	\N	REGION 	497
510	RHB DRIVER 	\N	\N	REGION 	DRIVER	N/A	N/A	10	6	\N	\N	6	\N	\N	\N	\N	2025-07-09 19:29:12	2025-07-09 19:29:12	t	ARM26100096	t	\N	\N	\N	5	498	\N	REGION 	498
511	RHB DRIVER 	\N	\N	REGION 	DRIVER	N/A	N/A	10	6	\N	\N	6	\N	\N	\N	\N	2025-07-10 19:29:12	2025-07-10 19:29:12	t	ARM26100097	t	\N	\N	\N	5	499	\N	REGION 	499
512	RHB DRIVER 	\N	\N	REGION 	DRIVER	N/A	N/A	10	6	\N	\N	6	\N	\N	\N	\N	2025-07-11 19:29:12	2025-07-11 19:29:12	t	ARM26100098	t	\N	\N	\N	5	500	\N	REGION 	500
513	RHB DRIVER 	\N	\N	REGION 	DRIVER	N/A	N/A	10	6	\N	\N	6	\N	\N	\N	\N	2025-07-12 19:29:12	2025-07-12 19:29:12	t	ARM26100099	t	\N	\N	\N	5	501	\N	REGION 	501
514	RHB DRIVER 	\N	\N	REGION 	DRIVER	N/A	N/A	10	6	\N	\N	6	\N	\N	\N	\N	2025-07-13 19:29:12	2025-07-13 19:29:12	t	ARM26100100	t	\N	\N	\N	5	502	\N	REGION 	502
515	RHB DRIVER 	\N	\N	REGION 	DRIVER	N/A	N/A	10	6	\N	\N	6	\N	\N	\N	\N	2025-07-14 19:29:12	2025-07-14 19:29:12	t	ARM26100101	t	\N	\N	\N	5	503	\N	REGION 	503
516	RHB DRIVER 	\N	\N	REGION 	DRIVER	N/A	N/A	10	6	\N	\N	6	\N	\N	\N	\N	2025-07-15 19:29:12	2025-07-15 19:29:12	t	ARM26100102	t	\N	\N	\N	5	504	\N	REGION 	504
517	RHB DRIVER 	\N	\N	REGION 	DRIVER	N/A	N/A	10	6	\N	\N	6	\N	\N	\N	\N	2025-07-16 19:29:12	2025-07-16 19:29:12	t	ARM26100103	t	\N	\N	\N	5	505	\N	REGION 	505
518	RHB DRIVER 	\N	\N	REGION 	DRIVER	N/A	N/A	10	6	\N	\N	6	\N	\N	\N	\N	2025-07-17 19:29:12	2025-07-17 19:29:12	t	ARM26100104	t	\N	\N	\N	5	506	\N	REGION 	506
519	RHB DRIVER 	\N	\N	REGION 	DRIVER	N/A	N/A	10	6	\N	\N	6	\N	\N	\N	\N	2025-07-18 19:29:12	2025-07-18 19:29:12	t	ARM26100105	t	\N	\N	\N	5	507	\N	REGION 	507
520	RHB DRIVER 	\N	\N	REGION 	DRIVER	N/A	N/A	10	6	\N	\N	6	\N	\N	\N	\N	2025-07-19 19:29:12	2025-07-19 19:29:12	t	ARM26100106	t	\N	\N	\N	5	508	\N	REGION 	508
521	RHB DRIVER 	\N	\N	REGION 	DRIVER	N/A	N/A	10	6	\N	\N	6	\N	\N	\N	\N	2025-07-20 19:29:12	2025-07-20 19:29:12	t	ARM26100107	t	\N	\N	\N	5	509	\N	REGION 	509
522	RHB DRIVER 	\N	\N	REGION 	DRIVER	N/A	N/A	10	6	\N	\N	6	\N	\N	\N	\N	2025-07-21 19:29:12	2025-07-21 19:29:12	t	ARM26100108	t	\N	\N	\N	5	510	\N	REGION 	510
523	RHB DRIVER 	\N	\N	REGION 	DRIVER	N/A	N/A	10	6	\N	\N	6	\N	\N	\N	\N	2025-07-22 19:29:12	2025-07-22 19:29:12	t	ARM26100109	t	\N	\N	\N	5	511	\N	REGION 	511
524	RHB DRIVER 	\N	\N	REGION 	DRIVER	N/A	N/A	10	6	\N	\N	6	\N	\N	\N	\N	2025-07-23 19:29:12	2025-07-23 19:29:12	t	ARM26100110	t	\N	\N	\N	5	512	\N	REGION 	512
525	RHB DRIVER 	\N	\N	REGION 	DRIVER	N/A	N/A	10	6	\N	\N	6	\N	\N	\N	\N	2025-07-24 19:29:12	2025-07-24 19:29:12	t	ARM26100111	t	\N	\N	\N	5	513	\N	REGION 	513
\.


--
-- Data for Name: pay_charges; Type: TABLE DATA; Schema: public; Owner: abinet
--

COPY public.pay_charges (id, processor_id, amount, amount_refunded, created_at, updated_at, data, application_fee_amount, currency, metadata, subscription_id, customer_id, stripe_account) FROM stdin;
\.


--
-- Data for Name: pay_customers; Type: TABLE DATA; Schema: public; Owner: abinet
--

COPY public.pay_customers (id, owner_type, owner_id, processor, processor_id, "default", data, deleted_at, created_at, updated_at, stripe_account) FROM stdin;
\.


--
-- Data for Name: pay_merchants; Type: TABLE DATA; Schema: public; Owner: abinet
--

COPY public.pay_merchants (id, owner_type, owner_id, processor, processor_id, "default", data, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: pay_payment_methods; Type: TABLE DATA; Schema: public; Owner: abinet
--

COPY public.pay_payment_methods (id, customer_id, processor_id, "default", type, data, created_at, updated_at, stripe_account) FROM stdin;
\.


--
-- Data for Name: pay_subscriptions; Type: TABLE DATA; Schema: public; Owner: abinet
--

COPY public.pay_subscriptions (id, name, processor_id, processor_plan, quantity, trial_ends_at, ends_at, created_at, updated_at, status, data, application_fee_percent, metadata, customer_id, current_period_start, current_period_end, metered, pause_behavior, pause_starts_at, pause_resumes_at, payment_method_id, stripe_account) FROM stdin;
\.


--
-- Data for Name: pay_webhooks; Type: TABLE DATA; Schema: public; Owner: abinet
--

COPY public.pay_webhooks (id, processor, event_type, event, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: plans; Type: TABLE DATA; Schema: public; Owner: abinet
--

COPY public.plans (id, name, amount, "interval", details, created_at, updated_at, trial_period_days, hidden, currency, interval_count, description, unit_label, charge_per_unit, stripe_id, braintree_id, paddle_billing_id, paddle_classic_id, lemon_squeezy_id, fake_processor_id, contact_url) FROM stdin;
\.


--
-- Data for Name: refer_referral_codes; Type: TABLE DATA; Schema: public; Owner: abinet
--

COPY public.refer_referral_codes (id, referrer_type, referrer_id, code, created_at, updated_at, referrals_count, visits_count) FROM stdin;
1	User	1	aIrlOuyb	2024-10-21 09:17:29.669419	2024-10-21 09:17:29.669419	0	0
\.


--
-- Data for Name: refer_referrals; Type: TABLE DATA; Schema: public; Owner: abinet
--

COPY public.refer_referrals (id, referrer_type, referrer_id, referee_type, referee_id, referral_code_id, created_at, updated_at, completed_at) FROM stdin;
\.


--
-- Data for Name: refer_visits; Type: TABLE DATA; Schema: public; Owner: abinet
--

COPY public.refer_visits (id, referral_code_id, ip, user_agent, referrer, referring_domain, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: room_assignments; Type: TABLE DATA; Schema: public; Owner: abinet
--

COPY public.room_assignments (id, participant_id, room_id, arrived_date, checkin_date, checkout_date, notes, created_at, updated_at, status) FROM stdin;
\.


--
-- Data for Name: rooms; Type: TABLE DATA; Schema: public; Owner: abinet
--

COPY public.rooms (id, room_number, room_type, floor, hotel_id, created_at, updated_at) FROM stdin;
1	32b	normal	2	1	2024-10-11 19:38:34.037634	2024-10-11 19:38:34.037634
2	23	Single	2	1	2024-10-11 19:38:45.016801	2024-10-11 19:38:45.016801
3	123B	Single	1	2	2024-10-11 19:39:06.101856	2024-10-11 19:39:06.101856
4	122B	Sweet	3	3	2024-10-11 19:39:26.756777	2024-10-11 19:39:26.756777
5	b238	Normal	3	2	2024-10-15 12:28:07.090874	2024-10-15 12:28:07.090874
25	201B	Single	3	4	2024-10-15 12:34:25.806531	2024-10-15 12:34:25.806531
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: abinet
--

COPY public.schema_migrations (version) FROM stdin;
20180801000000
20180801000001
20180817230558
20180820210659
20180821214212
20180821214213
20190114062649
20190114062651
20190207041139
20190211185457
20190211185458
20190211194309
20190409222127
20190801160834
20190820024249
20191025224530
20191219010439
20200102195022
20200110222159
20200208030344
20200209004223
20200326020204
20200715173316
20200726201932
20200806001403
20201206085920
20201209233133
20201209233134
20210312034326
20210419210614
20210422222152
20210804000959
20210805001857
20211002195137
20220329195242
20220331201915
20221121232410
20221216130900
20230114132615
20230204162609
20230503180159
20230717174558
20230810152614
20231010151212
20231024150632
20231128155334
20240102192139
20240129200820
20240222013808
20240222020825
20240224021434
20241001224313
20241003082724
20241003082725
20241003082726
20241003095805
20241003100616
20241005120350
20241005122049
20241005122156
20241005125604
20241005130009
20241005131821
20241005132550
20241005160443
20241005194931
20241005224606
20241006003750
20241006202322
20241011143327
20241011205812
20241021160717
20241021181718
20241024120357
20241024140133
20241024140325
20241024142040
20241024142936
20241024221005
\.


--
-- Data for Name: side_events; Type: TABLE DATA; Schema: public; Owner: abinet
--

COPY public.side_events (id, event_name, description, startdate, enddate, venue, created_at, updated_at) FROM stdin;
1	Digital Payment Event	Digital Payment EventDigital Payment Event	2024-10-18	2024-10-25	Abaya Hall, Haile	2024-10-11 19:45:36.010692	2024-10-11 19:45:36.010692
2	Health system and Digitalizarion Event	Health system and Digitalizarion Event	2024-10-19	2024-10-20	Renov Hal, Haile	2024-10-11 19:46:40.769106	2024-10-11 19:46:40.769106
3	Digital Payment Event	askdmandaks	\N	\N		2024-10-24 06:36:47.044364	2024-10-24 06:36:47.044364
4	Gp4	Gp4	\N	\N		2024-10-24 22:35:49.969544	2024-10-24 22:35:49.969544
5	G5	G5	\N	\N		2024-10-24 22:36:03.123685	2024-10-24 22:36:03.123685
6	G6		\N	\N		2024-10-24 22:36:10.241532	2024-10-24 22:36:10.241532
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: abinet
--

COPY public.users (id, email, encrypted_password, reset_password_token, reset_password_sent_at, remember_created_at, confirmation_token, confirmed_at, confirmation_sent_at, unconfirmed_email, first_name, last_name, time_zone, accepted_terms_at, accepted_privacy_at, announcements_read_at, admin, created_at, updated_at, invitation_token, invitation_created_at, invitation_sent_at, invitation_accepted_at, invitation_limit, invited_by_type, invited_by_id, invitations_count, preferred_language, otp_required_for_login, otp_secret, last_otp_timestep, otp_backup_codes, preferences) FROM stdin;
288	1231232@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mr	Abdulkerim Wengistu	Nairobi	\N	\N	\N	\N	2024-12-11 19:29:12	2024-12-11 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
2	tasewtebeje@unfpa.org	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	 Awoke	Tasew Tebeje	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
3	oluyomi@unfpa.org	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	 Taiwo	Oluyomi 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
4	naali@path.org	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Nasir Ali	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
5	workneshg@unops.org	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Worknesh Mekonnen	GONET 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
6	basazinewt@unops.org	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	 Basaznew	Terefe 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
7	BerhanuT@unops.org	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Berhanu Assefa	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
8	Zelalemtadesse@beza-posterity.org	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	 Zelalem	Tadesse 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
9	Mary.Healy@dfa.ie	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mary Healy	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
10	gteshome@popcouncil.org	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Getachew Teshome	Eregata (PhD)	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
11	nasir.hasen@thepalladiumgroup.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Nasir Ali	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
12	hemina3675@kofih.org	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Ms. KWAK	Hyemin 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
13	ktamiru@yahoo.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	 Tamiru	Kassa 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
14	tkassa@emory.edu	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Professor Gurmessa	Tura 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
15	zy2115@cumc.columbia.edu	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	 Zenebe	Melaku 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
16	sl2883@cumc.columbia.edu	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Professor Sileshi	Lulseged 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
17	Fasil.Nigussie@fcdo.gov.uk	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Fasil Nigussie	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
18	Hannah.Binci@fcdo.gov.uk	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Hannah Binci	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
19	Lydia.Tesfaye@fcdo.gov.uk	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	 Lydia	Tesfaye 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
20	Robin.Gorna@fcdo.gov.uk	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Robin Gorna	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
21	dchekol@vitalstrategies.org	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	 Daniel	Chekol 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
22	girum.hailu@igad.int	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	 Girum	Hailu Maheteme	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
23	BereketUseman.ET@jica.go.jp	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Bereket Useman	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
24	khailu@aiha-et.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Kidist Hailu	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
25	Frank-vande.looij@minbuza.nl	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Frank van	de Looij	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
26	arsema.wmichael@minbuza.nl	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Arsema W/michael	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
27	TokonE@unaids.org	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	 Eshett	Degefa 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
28	shoa.girma@jhpiego.org	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	 Shoa	Girma 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
29	 Damtew.Woldemariam@jhpiego.org	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Damtew Woldemariam	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
30	 Della.Berhanu@jhpiego.org	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Della Berhanu	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
31	 Daniel.Dejene@jhpiego.org	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Daniel Dejene	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
32	tegbar.yigzaw@jhpiego.org	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Tegbar Yigzaw	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
33	dan.kabtyimer@gatesfoundation.org	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Daniel Getachew	Kabtyimer 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
34	Susna.De@gatesfoundation.org	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Susna De 	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
35	dessalew_emaway@et.jsi.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Dessalew Emaway	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
36	melaku.muleta@thinkplace.co.ke	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Melaku Muleta	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
37	wubshet_denboba@et.jsi.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Wubshet Denboba	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
38	adane@habtechsolution.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Adane Letta	(PhD) 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
39	abebe.shibru@mariestopes.org.et	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Abebe Shibru	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
40	AlemsegedT@state.gov	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Tseday Alemseged	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
41	abdurahman.ali@giz.de	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Abdurahman Ali	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
42	abe_keb@yahoo.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Abebe Kebede	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
43	martadagim@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Dagim Damtew	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
44	aendeshaw@clintonhealthaccess.org	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Abraham Endeshaw	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
45	ZDemeke@clintonhealthaccess.org	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Zelalem Demeke	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
46	Abiami1064@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Hailemariam Segni	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
47	binyam_desta@et.jsi.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Binyam Desta	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
48	Habtamu.ADANE@eeas.europa.eu	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Habtamu Adane	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
49	Beatrice.NERI@eeas.europa.eu	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Beatrice NERI	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
50	abnet.zeleke@iphce.org 	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Abnet Zeleke	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
51	rtesfaye@worldbank.org	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Roman Tesfaye	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
52	kdemissie@worldbank.org	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Kidist Kebebe	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
53	walemu@worldbank.org	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Wubedel Dereje	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
54	thais.gonzalez@aecid.es	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Ms.Thais González	Capella 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
55	misrak.makonnen@amref.org	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Misrak Makonnen	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
56	dtsegaye@projecthope.org	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Dawit Abraham	(Dr) 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
57	FNigatu@projecthope.org	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Frehiwot Nigatu	(Dr) 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
58	Senait.Zewdie@fao.org	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Senait Zewdie	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
59	eejigu@ghsc-psm.org	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Ato Edmealem	Ejigu 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
60	HTesfaye@ghsc-psm.org	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Ato Habtamu	Tesfaye 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
61	Masnake@pathfinder.org	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	 Mengistu	Asnake 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
62	dereje_dengela@abtassoc.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	 Dereje	Olana Dengela	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
63	 ziz5@cdc.gov	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Ms. Jennifer	Mika 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
64	ihj0@cdc.gov	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Ms. Briana	Lozano 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
65	Tadesse@cartercenter.org	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	 Zerihun	Tadesse, 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
66	emesele@purposeafrica.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Esayas Mesele	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
67	Maliha.Dost@international.gc.ca	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Maliha Dost 	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
68	oshin@gavi.org	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	 Tokunbo	Oshin 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
69	ebaguma@gavi.org	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Emmanuella Baguma	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
70	yalemu@r4d.org	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Yosef Alemu	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
71	naod_wendrad@et.jsi.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Naod Wendrad	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
73	simukangu@icrc.org	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Silas Muriungi	Mukangu 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
74	JKassaw@engenderhealth.org	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Jemal Kassaw	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
75	EWoldeamanuel@engenderhealth.org	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	 Abdulaziz	Ali 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
76	dgemechu@msh.org	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Daniel Gemechu	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
77	aoumer@msh.org	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Andualem Oumer	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
78	laura.miglierina@aics.gov.it	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Ms Laura	Miglierina 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
79	tibebe.akalu@aics.gov.it	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mr Tibebe	Akalu 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
80	jross@usaid.gov	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Jonathan Ross	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
81	hworku@usaid.gov	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	 Helina	Worku 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
82	ymussema@usaid.gov	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	 Yunis	Mussema 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
83	dgebremichael@usaid.gov	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	 Daniel	G/Michael 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
84	tashagari@usaid.gov	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Tesfaye Ashagari	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
85	galemayehu@usaid.gov	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	 Guda	Alemayehu 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
86	pmumba@usaid.gov	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	 Peter	Mumba 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
87	ykassie@usaid.gov	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	 Yewulsew	Kassie 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
88	dngemera@unicef.org	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Daniel Ngemera	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
89	ymaru@unicef.org	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Yetayesh Maru	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
90	anayele@unicef.org	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Andarge Abie	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
91	kaluwao@who.in	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Owen L.	Kaluwa 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
92	malumos@who.int	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Sarai Malumo,	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
93	nambiarb@who.int	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Bejoy Nambiar	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
94	nambiarb2@who.int	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Patrick Abok	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
95	solomonshiferaw@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Solomon Shiferaw	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
96	drtsigeredakifle2@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	 Tsigereda	Kifle 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
97	yusufsaed7@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	 Yusuf	Sead 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
98	alexgirma11@yahoo.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	 Alemayehu	Girma 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
99	amanchs133@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Amanuel Haile	Aberha 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
100	esayas1978.sm@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Rieye Esayas	Belay 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
101	taditsehaye@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Tedros Tsehaye	Abay 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
102	yaseenharar@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Yasin Abdulahi	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
103	ferunasu@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Fariha mohammed	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
104	abdusemedali697@yahoo.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Abdusemed Ali	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
105	ibri.temam@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	 Ibrahim	Temam 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
106	hailezewudie2010@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mitiku Tamene	Negash 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
107	berhanuwasihun1@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	 Wasihun	Berhanu 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
108	begalowaltajie@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Waltaji Begalo	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
109	Alemd756@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Abdulmunium Albeshir	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
110	uabdulahi97@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Usman Abdulahi	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
111	endashawshibru@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	 Endeshaw	Shibru 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
112	menam1958@yahoo.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	 Mena	Mekuria 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
113	tegegn.chote@yahoo.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	 Tegegn	Chote 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
114	abdulkerimmengistu@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	 Abdulkerim	Wengistu 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
115	temtmeabebe@yahoo.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	 Abebe	Temtim 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
116	eyoshumet@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	 Amare	Shumet 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
117	dargesamuel@yahoo.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Samuel Darge	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
118	ashenafipet2016@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Ashenafi Petros	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
119	ayileshew2007@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Ayile Lemma	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
120	kebemd@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Yohannes Challa	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
121	hangatum@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	W/ro Hangatu	Muhammud 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
122	aklilusimanesew@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Ato Aklilu	Simanesew 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
123	Headwaliadawe91@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Musse Ahmed	IbrahimBureau 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
124	ayanle5710@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mohamed ayanle	hassen 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
125	Directorayderus24@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Ayderus Ahmed	Mohamud 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
126	yashabhel@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Yassin Habib	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
127	Wittican@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Wittika Nore	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
128	Wittican2@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Amin Arba	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
129	akliluy1@yahoo.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Selamawit Mengesha	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
130	akliluy2@yahoo.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Muntasha Berhanu	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
131	akliluy@yahoo.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	 Aklilu	Yohannes Oge	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
132	chanie7045@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Abel Asefa	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
133	chanie7046@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	 Ogetu	Ading 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
134	chanie704@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Chanie Hussen	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
135	konetsanet@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Professor Nestanet	Workineh 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
136	dkumsa2000@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Dereje Abdena	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
137	lamessa2@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	 Lemessa	Tadesse 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
138	ashenafitazebew1@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Ashenafi Tazebew	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
139	hab.taye@yahoo.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Habtamu Taye	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
140	hgreba@efda.gov.et	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	 Heran	Gerba 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
141	nsime@efda.gov.et	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	 Negash	Sime 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
142	taarikuuguutee@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	 Tariku	Tadesse 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
143	demisew.yiheyis@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Demssew Yheyis	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
144	afework.kassu@ahri.gov.et	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Prof. Afework	Kassu Gizaw	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
145	messay.woldemariam@ahri.gov.et	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	 Messay	Woldemariam 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
146	mesdan216@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mesay Hailu	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
147	getachewtollera@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Getachew Eticha	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
148	Tesfayew885@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	 Tesfaye	Worku 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
149	yamdual@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	 Yamrot	Andualem 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
150	abdulkedir.gelgelo@epss.gov.et	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	 Abdulkedir	Gelgelo 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
151	aknawu.kawaza@epss.gov.et	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Aknawu Kawaza	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
152	edossa.adugna@moh.gov.et	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Edossa Adugna	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
153	Lelisa.amanuel@moh.gov.et	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Lelisa Amanuel	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
154	abera.bekele@moh.gov.et	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	 Abera	Bekele 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
155	semira.sultan@moh.gov.et	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	W/ro Semira	Sultan Temam	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
156	teshomea@unops.orgorteshome.dires@moh.gov.et	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Teshome Dires	Adane 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
157	bekeleashagire16@gmail.com,Bekele.ashagire@moh.gov.etorbekeley@unops.org	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Bekele Ashagire	Yeshanew 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
158	Kibebew.Workneh@moh.gov.et	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	 Kibebew	Workneh 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
159	BethelhemWorkneh@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	 Bethelhem	Workneh 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
160	MrsUlianFikr@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	 Ulian	Fikr 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
161	MrsSaraKassahun@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	 Sara	Kassahun 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
162	MrAberaGirma@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	 Abera	Girma 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
163	MrsTigistAssefa@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mrs Tigist	Assefa 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
164	MrsRehimaShikur@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mrs Rehima	Shikur 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
165	ShaloDaba@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Dr, Shalo	Daba 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
166	GirmayDeye@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	 Girmay	Deye 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
167	AbinetZeleke@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	 Abinet	Zeleke 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
168	AschalewWorku@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	 Aschalew	Worku 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
169	MebratuMasebo@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	 Mebratu	Masebo 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
170	MulukenYohannes@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	 Muluken	Yohannes 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
171	MrMehariTekeste@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	 Mehari	Tekeste 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
172	SolomonWorku@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	 Solomon	Worku 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
173	MrBirehanuAsfaw@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	 Birehanu	Asfaw 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
174	assegid.samuel@moh.gov.et	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Asegid Samueal	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
175	Solomon.Woldeamanuel@moh.gov.et	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Solomon Woldeamanuel	Birru 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
176	Israel.Ataro@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Israel Ataro	Otoro 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
177	Regassa.Bayisa@moh.gov.et	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Regassa Bayisa	Obse 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
178	Hiwot.Darsene@moh.gov.et	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Hiwot Darsene	Dimd 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
179	Mezgebu.Siyum@moh.gov.et	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mezgebu Siyum	Gubena 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
180	Shambel.Negassa@moh.gov.et	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Shambel Negassa	Deressa 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
181	Fatuma.Seid@moh.gov.et	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Fatuma Seid	Mohammed 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
182	Muluken.Argaw@moh.gov.et	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	 Muluken	Argaw 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
183	Mesoud.Mohammed@moh.gov.et	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mesoud Mohammed	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
184	Hiwot.Solomon@moh.gov.et	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Hiwot Solomon	Tafesse 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
185	gudissabayissa35@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Ggudisa Assefa	Bayissa 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
186	habtamu.demissie@moh.gov.et	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Habtamu Demssie	Debela 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
187	girma.bogale@ymail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Girma Bogale	Workneh 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
188	Maru.Sisay@moh.gov.et	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Maru Sisay	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
189	esayaslulu@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Esayas Lulu	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
190	fekadu.yadeta@moh.gov.et	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Fikadu Yadeta	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
191	abnetfeyssa@yahoo.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Abinet Assefat	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
192	Tibesso.Bezabih@moh.gov.et	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Tibesso Bezabih	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
193	Endegena.Abebe@moh.gov.et	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Endegena Abebe	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
194	MohammedAliye@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	 Mohammed	Aliye 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
195	Alemayehu.Hunduma@moh.gov.et	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	 Alemayehu	Hunduma 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
196	Motuma.Bekele@moh.gov.et	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Motuma Bekele	Nagu 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
197	Tesfaw.Bifered@moh.gov.et	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Tesfaw Bifered	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
198	Gemechis.Melkamu@moh.gov.et	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Gemechis Melkamu	Gobana 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
199	OLIKABA@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	OLI KABA	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
200	Tadesse.Yemane@moh.gov.et	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Tadesse Yemane	Worku 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
201	FrewAtakltYeshitila@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Frew Ataklt	Yeshitila 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
202	Yihenew.Birehane@moh.gov.et	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Yihenew Birehane	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
203	HabtamuKassahun@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Habtamu Kassahun	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
204	Abas.Hassen@moh.gov.et	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	 Abas	Hassen Yesuf	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
205	Endalkachew.Tsedal@moh.gov.et	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	 Endalkachew	Tsedal 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
206	Solomon.Ejigu@moh.gov.et	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	 Solomon	Ejigu 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
207	Gemechu.Assfaw@moh.gov.et	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Gemechu assfaw	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
208	Tegene.Regassa@moh.gov.et	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	 Tegene	Regassa 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
209	Yordanos.Alebachew@moh.gov.et	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Yordanos Alebachew	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
210	Geremew.Uga@moh.gov.et	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Geremew Uga	Merga 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
211	Assefa.Ayide@moh.gov.et	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Assefa Ayide	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
212	Elubabor.Buno@moh.gov.et	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	 Elubabor	Buno 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
213	Tesfaw.Bifered2@moh.gov.et	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	 Asnake	Wagari 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
214	Tesfaw.Bifered3@moh.gov.et	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mulualem Bulcha	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
215	gshime98@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Shimels Gezahegn	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
216	biniamnesru.1234@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	 Abraham	Eshetu Mamo	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
217	 Mulathea18@gmail.com 	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	 Muluken	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
218	edaofejo@yahoo.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	EDAO FEJO	HAMDA 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
219	Sisay.sirgu@sphmmc.edu.et	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	 Sisay	Sirgu 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
220	atirumar@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	H.E Tirumar	Abate 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
221	umumasoud1434@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	 Ashereka	Digga 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
222	tdebero@yahoo.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	 Teshome	Debero 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
223	hirunalin@gmail.Com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Sr. Hirut	Imbiale 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
224	mesker.tariku@moj.gov.et	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Omod Ujulu	Ubup 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
225	executivesecretary.mills@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Kefelech Denbebo	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
226	bantam2011luck@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Alebel Dessie	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
227	alemayehuem@yahoo.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Alemayehu Mekonnen	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
228	kiduhailug@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Kidu Hailu	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
229	fekadum@emwa.org.et 	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Fekadu mazengia 	 	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
230	woldegessam@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	 Woldesenbet	Waganew Dode	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
286	1231233@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Waltaji Begalo	Musse Ahmed	Nairobi	\N	\N	\N	\N	2024-12-09 19:29:12	2024-12-09 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
291	1231234@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Dr	Musse Ahmed	Nairobi	\N	\N	\N	\N	2024-12-14 19:29:12	2024-12-14 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
305	1231235@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Dr	Muluken  Tesfaye	Nairobi	\N	\N	\N	\N	2024-12-28 19:29:12	2024-12-28 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
273	1231236@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Ms	Jennifer Mika	Nairobi	\N	\N	\N	\N	2024-11-26 19:29:12	2024-11-26 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
365	1231237@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mr	Mesfin Kebede	Nairobi	\N	\N	\N	\N	2025-02-26 19:29:12	2025-02-26 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
366	1231238@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mr	Wendwosen Ayel	Nairobi	\N	\N	\N	\N	2025-02-27 19:29:12	2025-02-27 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
367	1231239@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mr	Wasihun Tilahun	Nairobi	\N	\N	\N	\N	2025-02-28 19:29:12	2025-02-28 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
368	1231240@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mr	Animut Ayalew	Nairobi	\N	\N	\N	\N	2025-03-01 19:29:12	2025-03-01 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
369	1231241@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Dr	Selamawit Getachew	Nairobi	\N	\N	\N	\N	2025-03-02 19:29:12	2025-03-02 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
370	1231242@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mr	Leulseged Nigusse	Nairobi	\N	\N	\N	\N	2025-03-03 19:29:12	2025-03-03 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
371	1231243@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mrs	Seble Abebe	Nairobi	\N	\N	\N	\N	2025-03-04 19:29:12	2025-03-04 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
372	1231244@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mr	Afework Yihiune	Nairobi	\N	\N	\N	\N	2025-03-05 19:29:12	2025-03-05 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
373	1231245@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mr	Daniel Betre	Nairobi	\N	\N	\N	\N	2025-03-06 19:29:12	2025-03-06 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
374	1231246@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mrs	Wubishet Tadesse	Nairobi	\N	\N	\N	\N	2025-03-07 19:29:12	2025-03-07 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
375	1231247@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mr	Ahmed Mohammed	Nairobi	\N	\N	\N	\N	2025-03-08 19:29:12	2025-03-08 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
376	1231248@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mr	Yalew Getachew	Nairobi	\N	\N	\N	\N	2025-03-09 19:29:12	2025-03-09 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
377	1231249@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mr	Nigussu G/Yesus	Nairobi	\N	\N	\N	\N	2025-03-10 19:29:12	2025-03-10 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
378	1231250@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mr	Yewendwosen Birhanu	Nairobi	\N	\N	\N	\N	2025-03-11 19:29:12	2025-03-11 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
379	1231251@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mr	Marta Wolde	Nairobi	\N	\N	\N	\N	2025-03-12 19:29:12	2025-03-12 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
380	1231252@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mr	H/mariam Addise	Nairobi	\N	\N	\N	\N	2025-03-13 19:29:12	2025-03-13 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
381	1231253@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mr	Liyu Tadesse	Nairobi	\N	\N	\N	\N	2025-03-14 19:29:12	2025-03-14 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
382	1231254@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mr	Abel Wubayehu	Nairobi	\N	\N	\N	\N	2025-03-15 19:29:12	2025-03-15 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
383	1231255@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mr	Zewde Gulema	Nairobi	\N	\N	\N	\N	2025-03-16 19:29:12	2025-03-16 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
384	1231256@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mr	Tsega Gebreyes	Nairobi	\N	\N	\N	\N	2025-03-17 19:29:12	2025-03-17 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
385	1231257@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mr	Dawit Birhanu	Nairobi	\N	\N	\N	\N	2025-03-18 19:29:12	2025-03-18 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
386	1231258@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mr	Hiwot Yimer	Nairobi	\N	\N	\N	\N	2025-03-19 19:29:12	2025-03-19 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
387	1231259@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mr	Yonatan Getahun	Nairobi	\N	\N	\N	\N	2025-03-20 19:29:12	2025-03-20 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
388	1231260@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mr	Tesfamichael Afework	Nairobi	\N	\N	\N	\N	2025-03-21 19:29:12	2025-03-21 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
389	1231261@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mrs	Menbere Belay	Nairobi	\N	\N	\N	\N	2025-03-22 19:29:12	2025-03-22 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
390	1231262@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mr	Endeshaw Dege	Nairobi	\N	\N	\N	\N	2025-03-23 19:29:12	2025-03-23 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
395	1231263@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mrs	Alelign Tiruneh	Nairobi	\N	\N	\N	\N	2025-03-28 19:29:12	2025-03-28 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
400	1231264@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mrs	Elsa tekle	Nairobi	\N	\N	\N	\N	2025-04-02 19:29:12	2025-04-02 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
405	1231265@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mrs	Netsanet Aragaw	Nairobi	\N	\N	\N	\N	2025-04-07 19:29:12	2025-04-07 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
410	1231266@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mrs	Tsigereda Birehanu	Nairobi	\N	\N	\N	\N	2025-04-12 19:29:12	2025-04-12 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
415	1231267@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mr	Abinet Seyife	Nairobi	\N	\N	\N	\N	2025-04-17 19:29:12	2025-04-17 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
420	1231268@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mr	Adu Aderajew	Nairobi	\N	\N	\N	\N	2025-04-22 19:29:12	2025-04-22 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
425	1231269@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mr	Feyera Olana	Nairobi	\N	\N	\N	\N	2025-04-27 19:29:12	2025-04-27 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
430	1231270@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Alemseged chane	Tsigereda Birehanu	Nairobi	\N	\N	\N	\N	2025-05-02 19:29:12	2025-05-02 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
435	1231271@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Nahom Firdawok	Abinet Seyife	Nairobi	\N	\N	\N	\N	2025-05-07 19:29:12	2025-05-07 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
440	1231272@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Alemayehu Birhanu	Adu Aderajew	Nairobi	\N	\N	\N	\N	2025-05-12 19:29:12	2025-05-12 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
445	1231273@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Efrem Biruk	Feyera Olana	Nairobi	\N	\N	\N	\N	2025-05-17 19:29:12	2025-05-17 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
450	1231274@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Abeselom Areaya	Tsigereda Birehanu	Nairobi	\N	\N	\N	\N	2025-05-22 19:29:12	2025-05-22 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
455	1231275@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Henok Lemi	Abinet Seyife	Nairobi	\N	\N	\N	\N	2025-05-27 19:29:12	2025-05-27 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
460	1231276@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Alemayehu Fikre	Adu Aderajew	Nairobi	\N	\N	\N	\N	2025-06-01 19:29:12	2025-06-01 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
465	1231277@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	AJEB KEMAL	Feyera Olana	Nairobi	\N	\N	\N	\N	2025-06-06 19:29:12	2025-06-06 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
470	1231278@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	TIGIST TSEGAYE	Tsigereda Birehanu	Nairobi	\N	\N	\N	\N	2025-06-11 19:29:12	2025-06-11 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
475	1231279@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	ADER  USMAEL	Abinet Seyife	Nairobi	\N	\N	\N	\N	2025-06-16 19:29:12	2025-06-16 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
480	1231280@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	AGENCY DRIVER	Adu Aderajew	Nairobi	\N	\N	\N	\N	2025-06-21 19:29:12	2025-06-21 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
485	1231281@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	AGENCY DRIVER	Feyera Olana	Nairobi	\N	\N	\N	\N	2025-06-26 19:29:12	2025-06-26 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
490	1231282@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	RHB DRIVER	Tsigereda Birehanu	Nairobi	\N	\N	\N	\N	2025-07-01 19:29:12	2025-07-01 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
495	1231283@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	RHB DRIVER	Abinet Seyife	Nairobi	\N	\N	\N	\N	2025-07-06 19:29:12	2025-07-06 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
500	1231284@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	RHB DRIVER	Adu Aderajew	Nairobi	\N	\N	\N	\N	2025-07-11 19:29:12	2025-07-11 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
505	1231285@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	RHB DRIVER	Feyera Olana	Nairobi	\N	\N	\N	\N	2025-07-16 19:29:12	2025-07-16 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
510	1231286@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	RHB DRIVER	Tsigereda Birehanu	Nairobi	\N	\N	\N	\N	2025-07-21 19:29:12	2025-07-21 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
515	1231287@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	MOH DRIVER	Abinet Seyife	Nairobi	\N	\N	\N	\N	2025-07-26 19:29:12	2025-07-26 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
520	1231288@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	MOH DRIVER	Adu Aderajew	Nairobi	\N	\N	\N	\N	2025-07-31 19:29:12	2025-07-31 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
525	1231289@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	MOH DRIVER	Feyera Olana	Nairobi	\N	\N	\N	\N	2025-08-05 19:29:12	2025-08-05 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
530	1231290@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	MOH DRIVER	Tsigereda Birehanu	Nairobi	\N	\N	\N	\N	2025-08-10 19:29:12	2025-08-10 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
535	1231291@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	SOUTH  R	Abinet Seyife	Nairobi	\N	\N	\N	\N	2025-08-15 19:29:12	2025-08-15 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
540	1231292@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	SOUTH  R	Adu Aderajew	Nairobi	\N	\N	\N	\N	2025-08-20 19:29:12	2025-08-20 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
545	1231293@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	F	Feyera Olana	Nairobi	\N	\N	\N	\N	2025-08-25 19:29:12	2025-08-25 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
391	1231294@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mrs	Tsigereda Birehanu	Nairobi	\N	\N	\N	\N	2025-03-24 19:29:12	2025-03-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
396	1231295@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mr	Abinet Seyife	Nairobi	\N	\N	\N	\N	2025-03-29 19:29:12	2025-03-29 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
401	1231296@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mrs	Adu Aderajew	Nairobi	\N	\N	\N	\N	2025-04-03 19:29:12	2025-04-03 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
406	1231297@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mrs	Feyera Olana	Nairobi	\N	\N	\N	\N	2025-04-08 19:29:12	2025-04-08 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
411	1231298@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mrs	Tsigereda Birehanu	Nairobi	\N	\N	\N	\N	2025-04-13 19:29:12	2025-04-13 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
416	1231299@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mr	Abinet Seyife	Nairobi	\N	\N	\N	\N	2025-04-18 19:29:12	2025-04-18 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
421	1231300@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mrs	Adu Aderajew	Nairobi	\N	\N	\N	\N	2025-04-23 19:29:12	2025-04-23 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
426	1231301@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mrs	Feyera Olana	Nairobi	\N	\N	\N	\N	2025-04-28 19:29:12	2025-04-28 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
431	1231302@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Neway Tsegaye	Tsigereda Birehanu	Nairobi	\N	\N	\N	\N	2025-05-03 19:29:12	2025-05-03 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
436	1231303@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Shimeles Arega Reta	Abinet Seyife	Nairobi	\N	\N	\N	\N	2025-05-08 19:29:12	2025-05-08 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
441	1231304@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Takelech Moges	Adu Aderajew	Nairobi	\N	\N	\N	\N	2025-05-13 19:29:12	2025-05-13 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
446	1231305@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Fikade Aychiluhim	Feyera Olana	Nairobi	\N	\N	\N	\N	2025-05-18 19:29:12	2025-05-18 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
451	1231306@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Yabsira Million	Tsigereda Birehanu	Nairobi	\N	\N	\N	\N	2025-05-23 19:29:12	2025-05-23 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
456	1231307@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Hana Demissie	Abinet Seyife	Nairobi	\N	\N	\N	\N	2025-05-28 19:29:12	2025-05-28 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
461	1231308@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Yonatan Zebedyos	Adu Aderajew	Nairobi	\N	\N	\N	\N	2025-06-02 19:29:12	2025-06-02 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
466	1231309@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	MEKIYA NURI	Feyera Olana	Nairobi	\N	\N	\N	\N	2025-06-07 19:29:12	2025-06-07 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
471	1231310@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	DIRSHAYE ESSA	Tsigereda Birehanu	Nairobi	\N	\N	\N	\N	2025-06-12 19:29:12	2025-06-12 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
476	1231311@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Sr	Abinet Seyife	Nairobi	\N	\N	\N	\N	2025-06-17 19:29:12	2025-06-17 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
481	1231312@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	AGENCY DRIVER	Adu Aderajew	Nairobi	\N	\N	\N	\N	2025-06-22 19:29:12	2025-06-22 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
486	1231313@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	RHB DRIVER	Feyera Olana	Nairobi	\N	\N	\N	\N	2025-06-27 19:29:12	2025-06-27 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
491	1231314@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	RHB DRIVER	Tsigereda Birehanu	Nairobi	\N	\N	\N	\N	2025-07-02 19:29:12	2025-07-02 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
496	1231315@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	RHB DRIVER	Abinet Seyife	Nairobi	\N	\N	\N	\N	2025-07-07 19:29:12	2025-07-07 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
501	1231316@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	RHB DRIVER	Adu Aderajew	Nairobi	\N	\N	\N	\N	2025-07-12 19:29:12	2025-07-12 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
506	1231317@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	RHB DRIVER	Feyera Olana	Nairobi	\N	\N	\N	\N	2025-07-17 19:29:12	2025-07-17 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
511	1231318@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	RHB DRIVER	Tsigereda Birehanu	Nairobi	\N	\N	\N	\N	2025-07-22 19:29:12	2025-07-22 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
516	1231319@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	MOH DRIVER	Abinet Seyife	Nairobi	\N	\N	\N	\N	2025-07-27 19:29:12	2025-07-27 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
521	1231320@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	MOH DRIVER	Adu Aderajew	Nairobi	\N	\N	\N	\N	2025-08-01 19:29:12	2025-08-01 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
526	1231321@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	MOH DRIVER	Feyera Olana	Nairobi	\N	\N	\N	\N	2025-08-06 19:29:12	2025-08-06 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
531	1231322@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	MOH DRIVER	Tsigereda Birehanu	Nairobi	\N	\N	\N	\N	2025-08-11 19:29:12	2025-08-11 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
536	1231323@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	SOUTH  R	Abinet Seyife	Nairobi	\N	\N	\N	\N	2025-08-16 19:29:12	2025-08-16 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
541	1231324@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	SOUTH  R	Adu Aderajew	Nairobi	\N	\N	\N	\N	2025-08-21 19:29:12	2025-08-21 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
546	1231325@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	F	Feyera Olana	Nairobi	\N	\N	\N	\N	2025-08-26 19:29:12	2025-08-26 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
392	1231326@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mrs	Tsigereda Birehanu	Nairobi	\N	\N	\N	\N	2025-03-25 19:29:12	2025-03-25 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
397	1231327@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mr	Abinet Seyife	Nairobi	\N	\N	\N	\N	2025-03-30 19:29:12	2025-03-30 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
402	1231328@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mrs	Adu Aderajew	Nairobi	\N	\N	\N	\N	2025-04-04 19:29:12	2025-04-04 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
407	1231329@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mrs	Feyera Olana	Nairobi	\N	\N	\N	\N	2025-04-09 19:29:12	2025-04-09 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
412	1231330@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mrs	Tsigereda Birehanu	Nairobi	\N	\N	\N	\N	2025-04-14 19:29:12	2025-04-14 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
417	1231331@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mr	Abinet Seyife	Nairobi	\N	\N	\N	\N	2025-04-19 19:29:12	2025-04-19 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
422	1231332@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mrs	Adu Aderajew	Nairobi	\N	\N	\N	\N	2025-04-24 19:29:12	2025-04-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
427	1231333@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mr	Feyera Olana	Nairobi	\N	\N	\N	\N	2025-04-29 19:29:12	2025-04-29 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
432	1231334@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Alemayehu Tarekegn	Tsigereda Birehanu	Nairobi	\N	\N	\N	\N	2025-05-04 19:29:12	2025-05-04 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
437	1231335@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Awol Mamo	Abinet Seyife	Nairobi	\N	\N	\N	\N	2025-05-09 19:29:12	2025-05-09 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
442	1231336@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Wondwosen Mengesha	Adu Aderajew	Nairobi	\N	\N	\N	\N	2025-05-14 19:29:12	2025-05-14 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
447	1231337@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Arif Ahmed	Feyera Olana	Nairobi	\N	\N	\N	\N	2025-05-19 19:29:12	2025-05-19 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
452	1231338@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Samuel Werkayehu	Tsigereda Birehanu	Nairobi	\N	\N	\N	\N	2025-05-24 19:29:12	2025-05-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
457	1231339@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Dagmawit Dereje	Abinet Seyife	Nairobi	\N	\N	\N	\N	2025-05-29 19:29:12	2025-05-29 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
462	1231340@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Temegnuh  Geresu	Adu Aderajew	Nairobi	\N	\N	\N	\N	2025-06-03 19:29:12	2025-06-03 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
467	1231341@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	ASSMA LENCHI	Feyera Olana	Nairobi	\N	\N	\N	\N	2025-06-08 19:29:12	2025-06-08 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
472	1231342@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	DESSALECH AYIMALU	Tsigereda Birehanu	Nairobi	\N	\N	\N	\N	2025-06-13 19:29:12	2025-06-13 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
477	1231343@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	HEW-AWARDEE	Abinet Seyife	Nairobi	\N	\N	\N	\N	2025-06-18 19:29:12	2025-06-18 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
482	1231344@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	AGENCY DRIVER	Adu Aderajew	Nairobi	\N	\N	\N	\N	2025-06-23 19:29:12	2025-06-23 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
487	1231345@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	RHB DRIVER	Feyera Olana	Nairobi	\N	\N	\N	\N	2025-06-28 19:29:12	2025-06-28 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
492	1231346@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	RHB DRIVER	Tsigereda Birehanu	Nairobi	\N	\N	\N	\N	2025-07-03 19:29:12	2025-07-03 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
497	1231347@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	RHB DRIVER	Abinet Seyife	Nairobi	\N	\N	\N	\N	2025-07-08 19:29:12	2025-07-08 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
502	1231348@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	RHB DRIVER	Adu Aderajew	Nairobi	\N	\N	\N	\N	2025-07-13 19:29:12	2025-07-13 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
507	1231349@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	RHB DRIVER	Feyera Olana	Nairobi	\N	\N	\N	\N	2025-07-18 19:29:12	2025-07-18 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
512	1231350@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	RHB DRIVER	Tsigereda Birehanu	Nairobi	\N	\N	\N	\N	2025-07-23 19:29:12	2025-07-23 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
517	1231351@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	MOH DRIVER	Abinet Seyife	Nairobi	\N	\N	\N	\N	2025-07-28 19:29:12	2025-07-28 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
522	1231352@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	MOH DRIVER	Adu Aderajew	Nairobi	\N	\N	\N	\N	2025-08-02 19:29:12	2025-08-02 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
527	1231353@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	MOH DRIVER	Feyera Olana	Nairobi	\N	\N	\N	\N	2025-08-07 19:29:12	2025-08-07 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
532	1231354@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	MOH DRIVER	Tsigereda Birehanu	Nairobi	\N	\N	\N	\N	2025-08-12 19:29:12	2025-08-12 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
537	1231355@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	SOUTH  R	Abinet Seyife	Nairobi	\N	\N	\N	\N	2025-08-17 19:29:12	2025-08-17 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
542	1231356@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	SOUTH  R	Adu Aderajew	Nairobi	\N	\N	\N	\N	2025-08-22 19:29:12	2025-08-22 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
547	1231357@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	F	Feyera Olana	Nairobi	\N	\N	\N	\N	2025-08-27 19:29:12	2025-08-27 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
393	1231358@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mrs	Tsigereda Birehanu	Nairobi	\N	\N	\N	\N	2025-03-26 19:29:12	2025-03-26 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
398	1231359@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mr	Abinet Seyife	Nairobi	\N	\N	\N	\N	2025-03-31 19:29:12	2025-03-31 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
403	1231360@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mrs	Adu Aderajew	Nairobi	\N	\N	\N	\N	2025-04-05 19:29:12	2025-04-05 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
408	1231361@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mrs	Feyera Olana	Nairobi	\N	\N	\N	\N	2025-04-10 19:29:12	2025-04-10 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
413	1231362@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mr	Tsigereda Birehanu	Nairobi	\N	\N	\N	\N	2025-04-15 19:29:12	2025-04-15 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
418	1231363@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mr	Abinet Seyife	Nairobi	\N	\N	\N	\N	2025-04-20 19:29:12	2025-04-20 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
423	1231364@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mrs	Adu Aderajew	Nairobi	\N	\N	\N	\N	2025-04-25 19:29:12	2025-04-25 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
428	1231365@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Firew Atikelt	Feyera Olana	Nairobi	\N	\N	\N	\N	2025-04-30 19:29:12	2025-04-30 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
433	1231366@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Awol Hassen	Tsigereda Birehanu	Nairobi	\N	\N	\N	\N	2025-05-05 19:29:12	2025-05-05 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
438	1231367@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Bezawit Tamiru	Abinet Seyife	Nairobi	\N	\N	\N	\N	2025-05-10 19:29:12	2025-05-10 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
443	1231368@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Redwan Mohammed	Adu Aderajew	Nairobi	\N	\N	\N	\N	2025-05-15 19:29:12	2025-05-15 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
448	1231369@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Betel Mekonnen	Feyera Olana	Nairobi	\N	\N	\N	\N	2025-05-20 19:29:12	2025-05-20 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
453	1231370@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Elias Seid	Tsigereda Birehanu	Nairobi	\N	\N	\N	\N	2025-05-25 19:29:12	2025-05-25 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
458	1231371@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Eyob  Asefa Agzie	Abinet Seyife	Nairobi	\N	\N	\N	\N	2025-05-30 19:29:12	2025-05-30 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
463	1231372@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Munta Mudda	Adu Aderajew	Nairobi	\N	\N	\N	\N	2025-06-04 19:29:12	2025-06-04 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
468	1231373@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Sr	Feyera Olana	Nairobi	\N	\N	\N	\N	2025-06-09 19:29:12	2025-06-09 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
473	1231374@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	AFRHA KEDIR	Tsigereda Birehanu	Nairobi	\N	\N	\N	\N	2025-06-14 19:29:12	2025-06-14 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
478	1231375@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	BIRARA HUNYALEW	Abinet Seyife	Nairobi	\N	\N	\N	\N	2025-06-19 19:29:12	2025-06-19 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
483	1231376@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	AGENCY DRIVER	Adu Aderajew	Nairobi	\N	\N	\N	\N	2025-06-24 19:29:12	2025-06-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
488	1231377@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	RHB DRIVER	Feyera Olana	Nairobi	\N	\N	\N	\N	2025-06-29 19:29:12	2025-06-29 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
493	1231378@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	RHB DRIVER	Tsigereda Birehanu	Nairobi	\N	\N	\N	\N	2025-07-04 19:29:12	2025-07-04 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
498	1231379@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	RHB DRIVER	Abinet Seyife	Nairobi	\N	\N	\N	\N	2025-07-09 19:29:12	2025-07-09 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
503	1231380@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	RHB DRIVER	Adu Aderajew	Nairobi	\N	\N	\N	\N	2025-07-14 19:29:12	2025-07-14 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
508	1231381@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	RHB DRIVER	Feyera Olana	Nairobi	\N	\N	\N	\N	2025-07-19 19:29:12	2025-07-19 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
513	1231382@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	RHB DRIVER	Tsigereda Birehanu	Nairobi	\N	\N	\N	\N	2025-07-24 19:29:12	2025-07-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
518	1231383@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	MOH DRIVER	Abinet Seyife	Nairobi	\N	\N	\N	\N	2025-07-29 19:29:12	2025-07-29 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
523	1231384@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	MOH DRIVER	Adu Aderajew	Nairobi	\N	\N	\N	\N	2025-08-03 19:29:12	2025-08-03 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
528	1231385@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	MOH DRIVER	Feyera Olana	Nairobi	\N	\N	\N	\N	2025-08-08 19:29:12	2025-08-08 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
533	1231386@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	MOH DRIVER	Tsigereda Birehanu	Nairobi	\N	\N	\N	\N	2025-08-13 19:29:12	2025-08-13 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
538	1231387@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	SOUTH  R	Abinet Seyife	Nairobi	\N	\N	\N	\N	2025-08-18 19:29:12	2025-08-18 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
543	1231388@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	SOUTH  R	Adu Aderajew	Nairobi	\N	\N	\N	\N	2025-08-23 19:29:12	2025-08-23 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
548	1231389@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	F	Feyera Olana	Nairobi	\N	\N	\N	\N	2025-08-28 19:29:12	2025-08-28 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
394	1231390@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mrs	Tsigereda Birehanu	Nairobi	\N	\N	\N	\N	2025-03-27 19:29:12	2025-03-27 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
399	1231391@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mr	Abinet Seyife	Nairobi	\N	\N	\N	\N	2025-04-01 19:29:12	2025-04-01 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
404	1231392@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mrs	Adu Aderajew	Nairobi	\N	\N	\N	\N	2025-04-06 19:29:12	2025-04-06 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
409	1231393@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mr	Feyera Olana	Nairobi	\N	\N	\N	\N	2025-04-11 19:29:12	2025-04-11 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
414	1231394@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mr	Tsigereda Birehanu	Nairobi	\N	\N	\N	\N	2025-04-16 19:29:12	2025-04-16 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
419	1231395@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mr	Abinet Seyife	Nairobi	\N	\N	\N	\N	2025-04-21 19:29:12	2025-04-21 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
424	1231396@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mr	Adu Aderajew	Nairobi	\N	\N	\N	\N	2025-04-26 19:29:12	2025-04-26 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
429	1231397@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mulualem Mekete	Feyera Olana	Nairobi	\N	\N	\N	\N	2025-05-01 19:29:12	2025-05-01 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
434	1231398@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Abera Deneke	Tsigereda Birehanu	Nairobi	\N	\N	\N	\N	2025-05-06 19:29:12	2025-05-06 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
439	1231399@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Meron Tesfaye	Abinet Seyife	Nairobi	\N	\N	\N	\N	2025-05-11 19:29:12	2025-05-11 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
444	1231400@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Tizita Demisse	Adu Aderajew	Nairobi	\N	\N	\N	\N	2025-05-16 19:29:12	2025-05-16 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
449	1231401@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Natnael Hailemeskel	Feyera Olana	Nairobi	\N	\N	\N	\N	2025-05-21 19:29:12	2025-05-21 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
454	1231402@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Melkamu Ababu	Tsigereda Birehanu	Nairobi	\N	\N	\N	\N	2025-05-26 19:29:12	2025-05-26 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
459	1231403@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Tesfaye Lemessa	Abinet Seyife	Nairobi	\N	\N	\N	\N	2025-05-31 19:29:12	2025-05-31 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
464	1231404@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	AMINAT HUSSIEN	Adu Aderajew	Nairobi	\N	\N	\N	\N	2025-06-05 19:29:12	2025-06-05 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
469	1231405@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	SEGNI URGESSA	Feyera Olana	Nairobi	\N	\N	\N	\N	2025-06-10 19:29:12	2025-06-10 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
474	1231406@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	FERIHIYA MOHAMMED	Tsigereda Birehanu	Nairobi	\N	\N	\N	\N	2025-06-15 19:29:12	2025-06-15 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
479	1231407@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	AGENCY DRIVER	Abinet Seyife	Nairobi	\N	\N	\N	\N	2025-06-20 19:29:12	2025-06-20 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
484	1231408@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	AGENCY DRIVER	Adu Aderajew	Nairobi	\N	\N	\N	\N	2025-06-25 19:29:12	2025-06-25 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
489	1231409@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	RHB DRIVER	Feyera Olana	Nairobi	\N	\N	\N	\N	2025-06-30 19:29:12	2025-06-30 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
494	1231410@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	RHB DRIVER	Tsigereda Birehanu	Nairobi	\N	\N	\N	\N	2025-07-05 19:29:12	2025-07-05 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
499	1231411@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	RHB DRIVER	Abinet Seyife	Nairobi	\N	\N	\N	\N	2025-07-10 19:29:12	2025-07-10 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
504	1231412@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	RHB DRIVER	Adu Aderajew	Nairobi	\N	\N	\N	\N	2025-07-15 19:29:12	2025-07-15 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
509	1231413@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	RHB DRIVER	Feyera Olana	Nairobi	\N	\N	\N	\N	2025-07-20 19:29:12	2025-07-20 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
514	1231414@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	MOH DRIVER	Tsigereda Birehanu	Nairobi	\N	\N	\N	\N	2025-07-25 19:29:12	2025-07-25 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
519	1231415@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	MOH DRIVER	Abinet Seyife	Nairobi	\N	\N	\N	\N	2025-07-30 19:29:12	2025-07-30 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
524	1231416@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	MOH DRIVER	Adu Aderajew	Nairobi	\N	\N	\N	\N	2025-08-04 19:29:12	2025-08-04 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
529	1231417@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	MOH DRIVER	Feyera Olana	Nairobi	\N	\N	\N	\N	2025-08-09 19:29:12	2025-08-09 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
534	1231418@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	SOUTH  R	Tsigereda Birehanu	Nairobi	\N	\N	\N	\N	2025-08-14 19:29:12	2025-08-14 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
539	1231419@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	SOUTH  R	Abinet Seyife	Nairobi	\N	\N	\N	\N	2025-08-19 19:29:12	2025-08-19 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
544	1231420@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	SOUTH  R	Adu Aderajew	Nairobi	\N	\N	\N	\N	2025-08-24 19:29:12	2025-08-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
549	1231421@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	F	Feyera Olana	Nairobi	\N	\N	\N	\N	2025-08-29 19:29:12	2025-08-29 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
315	1231422@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Dr, Dereje Dhuguma	Tsigereda Birehanu	Nairobi	\N	\N	\N	\N	2025-01-07 19:29:12	2025-01-07 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
317	1231423@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mrs	Abinet Seyife	Nairobi	\N	\N	\N	\N	2025-01-09 19:29:12	2025-01-09 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
319	1231424@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Dr	Adu Aderajew	Nairobi	\N	\N	\N	\N	2025-01-11 19:29:12	2025-01-11 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
321	1231425@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Dr	Feyera Olana	Nairobi	\N	\N	\N	\N	2025-01-13 19:29:12	2025-01-13 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
323	1231426@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mrs	Tsigereda Birehanu	Nairobi	\N	\N	\N	\N	2025-01-15 19:29:12	2025-01-15 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
318	1231427@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Dr	Abinet Seyife	Nairobi	\N	\N	\N	\N	2025-01-10 19:29:12	2025-01-10 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
320	1231428@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Dr	Adu Aderajew	Nairobi	\N	\N	\N	\N	2025-01-12 19:29:12	2025-01-12 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
322	1231429@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Dr	Feyera Olana	Nairobi	\N	\N	\N	\N	2025-01-14 19:29:12	2025-01-14 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
316	1231430@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Dr	Tsigereda Birehanu	Nairobi	\N	\N	\N	\N	2025-01-08 19:29:12	2025-01-08 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
339	1231431@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Dr	Abinet Seyife	Nairobi	\N	\N	\N	\N	2025-01-31 19:29:12	2025-01-31 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
302	1231432@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	DR	Adu Aderajew	Nairobi	\N	\N	\N	\N	2024-12-25 19:29:12	2024-12-25 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
267	1231433@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Abebe Kebede	Feyera Olana	Nairobi	\N	\N	\N	\N	2024-11-20 19:29:12	2024-11-20 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
331	1231434@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mr	Tsigereda Birehanu	Nairobi	\N	\N	\N	\N	2025-01-23 19:29:12	2025-01-23 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
299	1231435@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Prof	Abinet Seyife	Nairobi	\N	\N	\N	\N	2024-12-22 19:29:12	2024-12-22 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
244	1231436@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Dr	Adu Aderajew	Nairobi	\N	\N	\N	\N	2024-10-28 19:29:12	2024-10-28 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
293	1231437@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Dr	Feyera Olana	Nairobi	\N	\N	\N	\N	2024-12-16 19:29:12	2024-12-16 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
363	1231438@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mr	Tsigereda Birehanu	Nairobi	\N	\N	\N	\N	2025-02-24 19:29:12	2025-02-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
346	1231439@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Alemnesh Mirkuzie (PhD)	Abinet Seyife	Nairobi	\N	\N	\N	\N	2025-02-07 19:29:12	2025-02-07 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
283	1231440@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Dr Amanuel Haile	Adu Aderajew	Nairobi	\N	\N	\N	\N	2024-12-06 19:29:12	2024-12-06 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
296	1231441@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Dr Ashenafi Tazebew	Feyera Olana	Nairobi	\N	\N	\N	\N	2024-12-19 19:29:12	2024-12-19 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
360	1231442@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mrs	Tsigereda Birehanu	Nairobi	\N	\N	\N	\N	2025-02-21 19:29:12	2025-02-21 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
340	1231443@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Dr	Abinet Seyife	Nairobi	\N	\N	\N	\N	2025-02-01 19:29:12	2025-02-01 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
308	1231444@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	H	Adu Aderajew	Nairobi	\N	\N	\N	\N	2024-12-31 19:29:12	2024-12-31 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
361	1231445@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mr	Feyera Olana	Nairobi	\N	\N	\N	\N	2025-02-22 19:29:12	2025-02-22 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
341	1231446@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Dr	Tsigereda Birehanu	Nairobi	\N	\N	\N	\N	2025-02-02 19:29:12	2025-02-02 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
314	1231447@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Alebel Dessie	Abinet Seyife	Nairobi	\N	\N	\N	\N	2025-01-06 19:29:12	2025-01-06 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
268	1231448@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Beatrice NERI	Adu Aderajew	Nairobi	\N	\N	\N	\N	2024-11-21 19:29:12	2024-11-21 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
351	1231449@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Dr	Feyera Olana	Nairobi	\N	\N	\N	\N	2025-02-12 19:29:12	2025-02-12 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
304	1231450@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Dr	Tsigereda Birehanu	Nairobi	\N	\N	\N	\N	2024-12-27 19:29:12	2024-12-27 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
294	1231451@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Dr	Abinet Seyife	Nairobi	\N	\N	\N	\N	2024-12-17 19:29:12	2024-12-17 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
289	1231452@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Samuel Darge	Adu Aderajew	Nairobi	\N	\N	\N	\N	2024-12-12 19:29:12	2024-12-12 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
253	1231453@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Dinksera Debebe	Feyera Olana	Nairobi	\N	\N	\N	\N	2024-11-06 19:29:12	2024-11-06 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
279	1231454@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Dr Daniel Ngemera	Tsigereda Birehanu	Nairobi	\N	\N	\N	\N	2024-12-02 19:29:12	2024-12-02 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
282	1231455@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Dr	Abinet Seyife	Nairobi	\N	\N	\N	\N	2024-12-05 19:29:12	2024-12-05 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
357	1231456@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mrs	Adu Aderajew	Nairobi	\N	\N	\N	\N	2025-02-18 19:29:12	2025-02-18 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
276	1231457@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Emmanuella Baguma	Feyera Olana	Nairobi	\N	\N	\N	\N	2024-11-29 19:29:12	2024-11-29 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
306	1231458@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	EDAO FEJO	Tsigereda Birehanu	Nairobi	\N	\N	\N	\N	2024-12-29 19:29:12	2024-12-29 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
287	1231459@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mr	Abinet Seyife	Nairobi	\N	\N	\N	\N	2024-12-10 19:29:12	2024-12-10 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
243	1231460@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Eshete Yima	Adu Aderajew	Nairobi	\N	\N	\N	\N	2024-10-27 19:29:12	2024-10-27 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
313	1231461@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Kefelech  Denbebo	Feyera Olana	Nairobi	\N	\N	\N	\N	2025-01-05 19:29:12	2025-01-05 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
260	1231462@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Dr	Tsigereda Birehanu	Nairobi	\N	\N	\N	\N	2024-11-13 19:29:12	2024-11-13 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
359	1231463@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mrs	Abinet Seyife	Nairobi	\N	\N	\N	\N	2025-02-20 19:29:12	2025-02-20 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
250	1231464@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Girma Assefa	Adu Aderajew	Nairobi	\N	\N	\N	\N	2024-11-03 19:29:12	2024-11-03 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
334	1231465@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Dr Girma Taye	Feyera Olana	Nairobi	\N	\N	\N	\N	2025-01-26 19:29:12	2025-01-26 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
264	1231466@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Dr	Tsigereda Birehanu	Nairobi	\N	\N	\N	\N	2024-11-17 19:29:12	2024-11-17 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
333	1231467@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Gizachew Kedida	Abinet Seyife	Nairobi	\N	\N	\N	\N	2025-01-25 19:29:12	2025-01-25 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
303	1231468@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Dr	Adu Aderajew	Nairobi	\N	\N	\N	\N	2024-12-26 19:29:12	2024-12-26 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
326	1231469@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Gudisa Assefa	Feyera Olana	Nairobi	\N	\N	\N	\N	2025-01-18 19:29:12	2025-01-18 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
364	1231470@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mr	Tsigereda Birehanu	Nairobi	\N	\N	\N	\N	2025-02-25 19:29:12	2025-02-25 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
327	1231471@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Hamelmal Bekele	Abinet Seyife	Nairobi	\N	\N	\N	\N	2025-01-19 19:29:12	2025-01-19 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
261	1231472@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Hannah Binci	Adu Aderajew	Nairobi	\N	\N	\N	\N	2024-11-14 19:29:12	2024-11-14 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
257	1231473@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Ms	Feyera Olana	Nairobi	\N	\N	\N	\N	2024-11-10 19:29:12	2024-11-10 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
240	1231474@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Henock Gezahegn	Tsigereda Birehanu	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
297	1231475@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mrs	Abinet Seyife	Nairobi	\N	\N	\N	\N	2024-12-20 19:29:12	2024-12-20 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
311	1231476@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Sr	Adu Aderajew	Nairobi	\N	\N	\N	\N	2025-01-03 19:29:12	2025-01-03 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
324	1231477@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Hiwot Darsene	Feyera Olana	Nairobi	\N	\N	\N	\N	2025-01-16 19:29:12	2025-01-16 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
278	1231478@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Dr	Tsigereda Birehanu	Nairobi	\N	\N	\N	\N	2024-12-01 19:29:12	2024-12-01 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
285	1231479@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mr	Abinet Seyife	Nairobi	\N	\N	\N	\N	2024-12-08 19:29:12	2024-12-08 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
277	1231480@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Jonathan Ross	Adu Aderajew	Nairobi	\N	\N	\N	\N	2024-11-30 19:29:12	2024-11-30 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
242	1231481@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Dr Mekonnen Admassu	Feyera Olana	Nairobi	\N	\N	\N	\N	2024-10-26 19:29:12	2024-10-26 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
280	1231482@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Dr Owen L	Tsigereda Birehanu	Nairobi	\N	\N	\N	\N	2024-12-03 19:29:12	2024-12-03 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
270	1231483@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Kidist Kebebe	Abinet Seyife	Nairobi	\N	\N	\N	\N	2024-11-23 19:29:12	2024-11-23 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
290	1231484@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Dr Yohannes Challa	Adu Aderajew	Nairobi	\N	\N	\N	\N	2024-12-13 19:29:12	2024-12-13 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
348	1231485@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Dr	Feyera Olana	Nairobi	\N	\N	\N	\N	2025-02-09 19:29:12	2025-02-09 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
358	1231486@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mr	Tsigereda Birehanu	Nairobi	\N	\N	\N	\N	2025-02-19 19:29:12	2025-02-19 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
252	1231487@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Kidest Hailu	Abinet Seyife	Nairobi	\N	\N	\N	\N	2024-11-05 19:29:12	2024-11-05 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
265	1231488@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Kidist Hailu	Adu Aderajew	Nairobi	\N	\N	\N	\N	2024-11-18 19:29:12	2024-11-18 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
295	1231489@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Prof	Feyera Olana	Nairobi	\N	\N	\N	\N	2024-12-18 19:29:12	2024-12-18 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
349	1231490@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mr	Tsigereda Birehanu	Nairobi	\N	\N	\N	\N	2025-02-10 19:29:12	2025-02-10 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
262	1231491@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Dr	Abinet Seyife	Nairobi	\N	\N	\N	\N	2024-11-15 19:29:12	2024-11-15 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
332	1231492@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Maleda Tefera (PhD)	Adu Aderajew	Nairobi	\N	\N	\N	\N	2025-01-24 19:29:12	2025-01-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
335	1231493@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Tesfaye Seyifu	Feyera Olana	Nairobi	\N	\N	\N	\N	2025-01-27 19:29:12	2025-01-27 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
336	1231494@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Dinknesh Bikila	Tsigereda Birehanu	Nairobi	\N	\N	\N	\N	2025-01-28 19:29:12	2025-01-28 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
245	1231495@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Dr Haimanot Ambelu	Abinet Seyife	Nairobi	\N	\N	\N	\N	2024-10-29 19:29:12	2024-10-29 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
325	1231496@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Meles Tadesse	Adu Aderajew	Nairobi	\N	\N	\N	\N	2025-01-17 19:29:12	2025-01-17 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
300	1231497@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mesay Hailu	Feyera Olana	Nairobi	\N	\N	\N	\N	2024-12-23 19:29:12	2024-12-23 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
312	1231498@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mr	Tsigereda Birehanu	Nairobi	\N	\N	\N	\N	2025-01-04 19:29:12	2025-01-04 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
338	1231499@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mr	Abinet Seyife	Nairobi	\N	\N	\N	\N	2025-01-30 19:29:12	2025-01-30 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
345	1231500@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Prof	Adu Aderajew	Nairobi	\N	\N	\N	\N	2025-02-06 19:29:12	2025-02-06 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
247	1231501@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mr	Feyera Olana	Nairobi	\N	\N	\N	\N	2024-10-31 19:29:12	2024-10-31 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
246	1231502@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Dr Kassu Ketema	Tsigereda Birehanu	Nairobi	\N	\N	\N	\N	2024-10-30 19:29:12	2024-10-30 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
281	1231503@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Dr Patrick Abok	Abinet Seyife	Nairobi	\N	\N	\N	\N	2024-12-04 19:29:12	2024-12-04 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
342	1231504@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Dr	Adu Aderajew	Nairobi	\N	\N	\N	\N	2025-02-03 19:29:12	2025-02-03 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
275	1231505@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Dr	Feyera Olana	Nairobi	\N	\N	\N	\N	2024-11-28 19:29:12	2024-11-28 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
263	1231506@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Robin Gorna	Tsigereda Birehanu	Nairobi	\N	\N	\N	\N	2024-11-16 19:29:12	2024-11-16 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
269	1231507@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Roman Tesfaye	Abinet Seyife	Nairobi	\N	\N	\N	\N	2024-11-22 19:29:12	2024-11-22 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
241	1231508@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Semra Asefa	Adu Aderajew	Nairobi	\N	\N	\N	\N	2024-10-25 19:29:12	2024-10-25 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
353	1231509@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mr	Feyera Olana	Nairobi	\N	\N	\N	\N	2025-02-14 19:29:12	2025-02-14 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
307	1231510@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Dr	Tsigereda Birehanu	Nairobi	\N	\N	\N	\N	2024-12-30 19:29:12	2024-12-30 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
259	1231511@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Professor Sileshi	Abinet Seyife	Nairobi	\N	\N	\N	\N	2024-11-12 19:29:12	2024-11-12 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
350	1231512@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mr	Adu Aderajew	Nairobi	\N	\N	\N	\N	2025-02-11 19:29:12	2025-02-11 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
248	1231513@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Dr Asmamaw Bezabih	Feyera Olana	Nairobi	\N	\N	\N	\N	2024-11-01 19:29:12	2024-11-01 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
343	1231514@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Prof	Tsigereda Birehanu	Nairobi	\N	\N	\N	\N	2025-02-04 19:29:12	2025-02-04 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
249	1231515@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Samuel  Yalew	Abinet Seyife	Nairobi	\N	\N	\N	\N	2024-11-02 19:29:12	2024-11-02 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
298	1231516@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Dr	Adu Aderajew	Nairobi	\N	\N	\N	\N	2024-12-21 19:29:12	2024-12-21 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
274	1231517@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Dr	Feyera Olana	Nairobi	\N	\N	\N	\N	2024-11-27 19:29:12	2024-11-27 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
362	1231518@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Dr	Tsigereda Birehanu	Nairobi	\N	\N	\N	\N	2025-02-23 19:29:12	2025-02-23 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
355	1231519@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mr	Abinet Seyife	Nairobi	\N	\N	\N	\N	2025-02-16 19:29:12	2025-02-16 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
344	1231520@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Tariku Tesfaye	Adu Aderajew	Nairobi	\N	\N	\N	\N	2025-02-05 19:29:12	2025-02-05 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
255	1231521@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Dr	Feyera Olana	Nairobi	\N	\N	\N	\N	2024-11-08 19:29:12	2024-11-08 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
310	1231522@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mr	Tsigereda Birehanu	Nairobi	\N	\N	\N	\N	2025-01-02 19:29:12	2025-01-02 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
301	1231523@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mr	Abinet Seyife	Nairobi	\N	\N	\N	\N	2024-12-24 19:29:12	2024-12-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
356	1231524@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mr	Adu Aderajew	Nairobi	\N	\N	\N	\N	2025-02-17 19:29:12	2025-02-17 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
272	1231525@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Ms	Feyera Olana	Nairobi	\N	\N	\N	\N	2024-11-25 19:29:12	2024-11-25 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
254	1231526@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Tsedeke Mathewos	Tsigereda Birehanu	Nairobi	\N	\N	\N	\N	2024-11-07 19:29:12	2024-11-07 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
266	1231527@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mr	Abinet Seyife	Nairobi	\N	\N	\N	\N	2024-11-19 19:29:12	2024-11-19 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
352	1231528@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mr	Adu Aderajew	Nairobi	\N	\N	\N	\N	2025-02-13 19:29:12	2025-02-13 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
309	1231529@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mrs	Feyera Olana	Nairobi	\N	\N	\N	\N	2025-01-01 19:29:12	2025-01-01 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
271	1231530@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Wubedel Dereje	Tsigereda Birehanu	Nairobi	\N	\N	\N	\N	2024-11-24 19:29:12	2024-11-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
256	1231531@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Worknesh Mekonnen	Abinet Seyife	Nairobi	\N	\N	\N	\N	2024-11-09 19:29:12	2024-11-09 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
337	1231532@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Worknesh Mekonnen	Adu Aderajew	Nairobi	\N	\N	\N	\N	2025-01-29 19:29:12	2025-01-29 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
284	1231533@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Yasin Abdulahi	Feyera Olana	Nairobi	\N	\N	\N	\N	2024-12-07 19:29:12	2024-12-07 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
292	1231534@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Yassin Habib	Tsigereda Birehanu	Nairobi	\N	\N	\N	\N	2024-12-15 19:29:12	2024-12-15 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
354	1231535@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mr	Abinet Seyife	Nairobi	\N	\N	\N	\N	2025-02-15 19:29:12	2025-02-15 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
347	1231536@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Dr	Adu Aderajew	Nairobi	\N	\N	\N	\N	2025-02-08 19:29:12	2025-02-08 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
251	1231537@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mr	Feyera Olana	Nairobi	\N	\N	\N	\N	2024-11-04 19:29:12	2024-11-04 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
258	1231538@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Dr	Tsigereda Birehanu	Nairobi	\N	\N	\N	\N	2024-11-11 19:29:12	2024-11-11 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
328	1231539@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Legesse Dibaba	Abinet Seyife	Nairobi	\N	\N	\N	\N	2025-01-20 19:29:12	2025-01-20 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
329	1231540@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mr	Adu Aderajew	Nairobi	\N	\N	\N	\N	2025-01-21 19:29:12	2025-01-21 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
330	1231541@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Jemal Mohammed	Feyera Olana	Nairobi	\N	\N	\N	\N	2025-01-22 19:29:12	2025-01-22 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
561	eshetyilma@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Eshete	Yima	Nairobi	\N	\N	\N	\N	2025-08-29 19:29:12	2025-08-29 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
562	akiflie@ihi.org	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Abiy	Kiflie	Nairobi	\N	\N	\N	\N	2025-08-29 19:29:12	2025-08-29 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
563	syalewadela@mastercard.fdn.org	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Samuel	Yalew	Nairobi	\N	\N	\N	\N	2025-08-29 19:29:12	2025-08-29 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
564	gdessie@resolvetosavelives.org	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Girma	Assefa	Nairobi	\N	\N	\N	\N	2025-08-29 19:29:12	2025-08-29 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
565	Delsalegn.Melese@Umanitoba.ca	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Desalegn	Melese	Nairobi	\N	\N	\N	\N	2025-08-29 19:29:12	2025-08-29 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
566	Akmpo@unicef.org	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Aboubacar	Kampo	Nairobi	\N	\N	\N	\N	2025-08-29 19:29:12	2025-08-29 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
567	yibeltal.k@merqconsultancy.org	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Yibelta	Kasahun	Nairobi	\N	\N	\N	\N	2025-08-29 19:29:12	2025-08-29 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
568	tigist@ethiopianmedicalass.org	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Tigist	Mekonnen	Nairobi	\N	\N	\N	\N	2025-08-29 19:29:12	2025-08-29 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
569	SintayehuAbebe@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Sintayehu	Abebe	Nairobi	\N	\N	\N	\N	2025-08-29 19:29:12	2025-08-29 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
570	Gemu.Tiru@moh.gov.et	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Gemu	Tiru	Nairobi	\N	\N	\N	\N	2025-08-29 19:29:12	2025-08-29 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
571	abdi5116@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Abdi	Amin	Nairobi	\N	\N	\N	\N	2025-08-29 19:29:12	2025-08-29 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
572	Hiwot.Solom@moh.gov.et	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Hiwot	Solomon	Nairobi	\N	\N	\N	\N	2025-08-29 19:29:12	2025-08-29 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
573	luca.carpintieri@esteri.it	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Luca Carpintieri	Carpintieri	Nairobi	\N	\N	\N	\N	2025-08-29 19:29:12	2025-08-29 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
574	dinknehbikilla@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Dinkneh	Bikilla	Nairobi	\N	\N	\N	\N	2025-08-29 19:29:12	2025-08-29 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
576	abinetsei@gmial.com1	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	belay	belay	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
577	abinetsei@gmial.com2	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Nega	Nega	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
578	abinetsei@gmial.com3	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Haile	Haile	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
579	abinetsei@gmial.com4	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Dereje	Dereje	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
580	Emebetdeme221@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Demme	Demme	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
581	tesfayeyihes@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Yiheyis	Yiheyis	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
582	ceo@ethiohealthfed.org	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Sisay	Sisay	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
583	abinetsei@gmial.com5	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Jemal	Jemal	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
584	abinetsei@gmial.com6	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Zebideru	Zebideru	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
585	abinetsei@gmial.com7	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Negesse	Negesse	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
586	abinetsei@gmial.com8	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Abdurahman	Abdurahman	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
587	abinetsei@gmial.com9	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Biruk	Biruk	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
588	abinetsei@gmial.com10	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Aliyu	Aliyu	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
589	abinetsei@gmial.com11	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Tiruwork	Tiruwork	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
590	abinetsei@gmial.com12	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Damte	Damte	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
591	abinetsei@gmial.com13	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Binyam	Binyam	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
592	senayiteshete@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Eshete	Eshete	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
593	gujaraguzhe@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Demissie	Demissie	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
594	abinetsei@gmial.com14	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Sime	Sime	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
595	abinetsei@gmial.com15	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Asrat	Asrat	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
596	abinetsei@gmial.com16	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Abera	Abera	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
597	abinetsei@gmial.com17	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Zeleke	Zeleke	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
598	abinetsei@gmial.com18	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Fikrte	Fikrte	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
599	abinetsei@gmial.com19	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Sisay	Sisay	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
600	abinetsei@gmial.com20	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Masresha	Masresha	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
601	abinetsei@gmial.com21	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Kibrom	Kibrom	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
602	fasikagemeda91@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Gemeda	Gemeda	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
603	girmaababi20 I 8@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Girma	Girma	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
604	abinetsei@gmial.com22	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Mulatu	Mulatu	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
605	abinetsei@gmial.com23	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Ayale	Ayale	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
606	abinetsei@gmial.com24	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Abebaw	Abebaw	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
607	abinetsei@gmial.com25	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Yibeltal	Yibeltal	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
608	abinetsei@gmial.com26	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Girma	Girma	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
609	abinetsei@gmial.com27	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Debele	Debele	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
610	abinetsei@gmial.com28	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Abosse	Abosse	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
611	Juliana.LopezFajardo@international.gc.ca	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	\N	\N	\N	\N	Fajardo	Fajardo	Nairobi	\N	\N	\N	\N	2024-10-24 19:29:12	2024-10-24 19:29:12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
1	abnios@gmail.com	$2a$12$FB2rt97vlkcpWYEHB/zh/e1lCup4YPxXraljAZiIJ7q2WyyriODjy	\N	\N	\N	ynUgnhRwKnxVEzXW8-4j	\N	2024-10-24 19:24:07.183058	\N	Abinet	Seife Zergaw	Nairobi	2024-10-24 19:24:07.182091	2024-10-24 19:24:07.18237	2024-10-28 20:36:07.160716	t	2024-10-24 19:24:07.182491	2024-10-28 20:36:07.164536	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
\.


--
-- Name: account_invitations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: abinet
--

SELECT pg_catalog.setval('public.account_invitations_id_seq', 1, false);


--
-- Name: account_users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: abinet
--

SELECT pg_catalog.setval('public.account_users_id_seq', 9, true);


--
-- Name: accounts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: abinet
--

SELECT pg_catalog.setval('public.accounts_id_seq', 9, true);


--
-- Name: action_text_embeds_id_seq; Type: SEQUENCE SET; Schema: public; Owner: abinet
--

SELECT pg_catalog.setval('public.action_text_embeds_id_seq', 1, false);


--
-- Name: action_text_rich_texts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: abinet
--

SELECT pg_catalog.setval('public.action_text_rich_texts_id_seq', 1, false);


--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: abinet
--

SELECT pg_catalog.setval('public.active_storage_attachments_id_seq', 15, true);


--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: abinet
--

SELECT pg_catalog.setval('public.active_storage_blobs_id_seq', 15, true);


--
-- Name: active_storage_variant_records_id_seq; Type: SEQUENCE SET; Schema: public; Owner: abinet
--

SELECT pg_catalog.setval('public.active_storage_variant_records_id_seq', 1, false);


--
-- Name: addresses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: abinet
--

SELECT pg_catalog.setval('public.addresses_id_seq', 1, false);


--
-- Name: announcements_id_seq; Type: SEQUENCE SET; Schema: public; Owner: abinet
--

SELECT pg_catalog.setval('public.announcements_id_seq', 1, false);


--
-- Name: api_tokens_id_seq; Type: SEQUENCE SET; Schema: public; Owner: abinet
--

SELECT pg_catalog.setval('public.api_tokens_id_seq', 1, false);


--
-- Name: attendees_id_seq; Type: SEQUENCE SET; Schema: public; Owner: abinet
--

SELECT pg_catalog.setval('public.attendees_id_seq', 1, false);


--
-- Name: connected_accounts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: abinet
--

SELECT pg_catalog.setval('public.connected_accounts_id_seq', 1, false);


--
-- Name: email_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: abinet
--

SELECT pg_catalog.setval('public.email_logs_id_seq', 46, true);


--
-- Name: field_visit_activities_id_seq; Type: SEQUENCE SET; Schema: public; Owner: abinet
--

SELECT pg_catalog.setval('public.field_visit_activities_id_seq', 4, true);


--
-- Name: field_visit_areas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: abinet
--

SELECT pg_catalog.setval('public.field_visit_areas_id_seq', 4, true);


--
-- Name: groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: abinet
--

SELECT pg_catalog.setval('public.groups_id_seq', 7, true);


--
-- Name: hotels_id_seq; Type: SEQUENCE SET; Schema: public; Owner: abinet
--

SELECT pg_catalog.setval('public.hotels_id_seq', 9, true);


--
-- Name: inbound_webhooks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: abinet
--

SELECT pg_catalog.setval('public.inbound_webhooks_id_seq', 1, false);


--
-- Name: noticed_events_id_seq; Type: SEQUENCE SET; Schema: public; Owner: abinet
--

SELECT pg_catalog.setval('public.noticed_events_id_seq', 1, false);


--
-- Name: noticed_notifications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: abinet
--

SELECT pg_catalog.setval('public.noticed_notifications_id_seq', 1, false);


--
-- Name: notification_tokens_id_seq; Type: SEQUENCE SET; Schema: public; Owner: abinet
--

SELECT pg_catalog.setval('public.notification_tokens_id_seq', 1, false);


--
-- Name: notifications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: abinet
--

SELECT pg_catalog.setval('public.notifications_id_seq', 1, false);


--
-- Name: organizations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: abinet
--

SELECT pg_catalog.setval('public.organizations_id_seq', 8, true);


--
-- Name: participant_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: abinet
--

SELECT pg_catalog.setval('public.participant_types_id_seq', 11, true);


--
-- Name: participants_id_seq; Type: SEQUENCE SET; Schema: public; Owner: abinet
--

SELECT pg_catalog.setval('public.participants_id_seq', 2002, true);


--
-- Name: pay_charges_id_seq; Type: SEQUENCE SET; Schema: public; Owner: abinet
--

SELECT pg_catalog.setval('public.pay_charges_id_seq', 1, false);


--
-- Name: pay_customers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: abinet
--

SELECT pg_catalog.setval('public.pay_customers_id_seq', 1, false);


--
-- Name: pay_merchants_id_seq; Type: SEQUENCE SET; Schema: public; Owner: abinet
--

SELECT pg_catalog.setval('public.pay_merchants_id_seq', 1, false);


--
-- Name: pay_payment_methods_id_seq; Type: SEQUENCE SET; Schema: public; Owner: abinet
--

SELECT pg_catalog.setval('public.pay_payment_methods_id_seq', 1, false);


--
-- Name: pay_subscriptions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: abinet
--

SELECT pg_catalog.setval('public.pay_subscriptions_id_seq', 1, false);


--
-- Name: pay_webhooks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: abinet
--

SELECT pg_catalog.setval('public.pay_webhooks_id_seq', 1, false);


--
-- Name: plans_id_seq; Type: SEQUENCE SET; Schema: public; Owner: abinet
--

SELECT pg_catalog.setval('public.plans_id_seq', 1, false);


--
-- Name: refer_referral_codes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: abinet
--

SELECT pg_catalog.setval('public.refer_referral_codes_id_seq', 1, true);


--
-- Name: refer_referrals_id_seq; Type: SEQUENCE SET; Schema: public; Owner: abinet
--

SELECT pg_catalog.setval('public.refer_referrals_id_seq', 1, false);


--
-- Name: refer_visits_id_seq; Type: SEQUENCE SET; Schema: public; Owner: abinet
--

SELECT pg_catalog.setval('public.refer_visits_id_seq', 1, false);


--
-- Name: room_assignments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: abinet
--

SELECT pg_catalog.setval('public.room_assignments_id_seq', 19, true);


--
-- Name: rooms_id_seq; Type: SEQUENCE SET; Schema: public; Owner: abinet
--

SELECT pg_catalog.setval('public.rooms_id_seq', 25, true);


--
-- Name: side_events_id_seq; Type: SEQUENCE SET; Schema: public; Owner: abinet
--

SELECT pg_catalog.setval('public.side_events_id_seq', 6, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: abinet
--

SELECT pg_catalog.setval('public.users_id_seq', 240, false);


--
-- Name: account_invitations account_invitations_pkey; Type: CONSTRAINT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.account_invitations
    ADD CONSTRAINT account_invitations_pkey PRIMARY KEY (id);


--
-- Name: account_users account_users_pkey; Type: CONSTRAINT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.account_users
    ADD CONSTRAINT account_users_pkey PRIMARY KEY (id);


--
-- Name: accounts accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (id);


--
-- Name: action_text_embeds action_text_embeds_pkey; Type: CONSTRAINT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.action_text_embeds
    ADD CONSTRAINT action_text_embeds_pkey PRIMARY KEY (id);


--
-- Name: action_text_rich_texts action_text_rich_texts_pkey; Type: CONSTRAINT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.action_text_rich_texts
    ADD CONSTRAINT action_text_rich_texts_pkey PRIMARY KEY (id);


--
-- Name: active_storage_attachments active_storage_attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT active_storage_attachments_pkey PRIMARY KEY (id);


--
-- Name: active_storage_blobs active_storage_blobs_pkey; Type: CONSTRAINT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.active_storage_blobs
    ADD CONSTRAINT active_storage_blobs_pkey PRIMARY KEY (id);


--
-- Name: active_storage_variant_records active_storage_variant_records_pkey; Type: CONSTRAINT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.active_storage_variant_records
    ADD CONSTRAINT active_storage_variant_records_pkey PRIMARY KEY (id);


--
-- Name: addresses addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT addresses_pkey PRIMARY KEY (id);


--
-- Name: announcements announcements_pkey; Type: CONSTRAINT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.announcements
    ADD CONSTRAINT announcements_pkey PRIMARY KEY (id);


--
-- Name: api_tokens api_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.api_tokens
    ADD CONSTRAINT api_tokens_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: attendees attendees_pkey; Type: CONSTRAINT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.attendees
    ADD CONSTRAINT attendees_pkey PRIMARY KEY (id);


--
-- Name: connected_accounts connected_accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.connected_accounts
    ADD CONSTRAINT connected_accounts_pkey PRIMARY KEY (id);


--
-- Name: email_logs email_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.email_logs
    ADD CONSTRAINT email_logs_pkey PRIMARY KEY (id);


--
-- Name: field_visit_activities field_visit_activities_pkey; Type: CONSTRAINT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.field_visit_activities
    ADD CONSTRAINT field_visit_activities_pkey PRIMARY KEY (id);


--
-- Name: field_visit_areas field_visit_areas_pkey; Type: CONSTRAINT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.field_visit_areas
    ADD CONSTRAINT field_visit_areas_pkey PRIMARY KEY (id);


--
-- Name: groups groups_pkey; Type: CONSTRAINT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.groups
    ADD CONSTRAINT groups_pkey PRIMARY KEY (id);


--
-- Name: hotels hotels_pkey; Type: CONSTRAINT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.hotels
    ADD CONSTRAINT hotels_pkey PRIMARY KEY (id);


--
-- Name: inbound_webhooks inbound_webhooks_pkey; Type: CONSTRAINT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.inbound_webhooks
    ADD CONSTRAINT inbound_webhooks_pkey PRIMARY KEY (id);


--
-- Name: noticed_events noticed_events_pkey; Type: CONSTRAINT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.noticed_events
    ADD CONSTRAINT noticed_events_pkey PRIMARY KEY (id);


--
-- Name: noticed_notifications noticed_notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.noticed_notifications
    ADD CONSTRAINT noticed_notifications_pkey PRIMARY KEY (id);


--
-- Name: notification_tokens notification_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.notification_tokens
    ADD CONSTRAINT notification_tokens_pkey PRIMARY KEY (id);


--
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- Name: organizations organizations_pkey; Type: CONSTRAINT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.organizations
    ADD CONSTRAINT organizations_pkey PRIMARY KEY (id);


--
-- Name: participant_types participant_types_pkey; Type: CONSTRAINT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.participant_types
    ADD CONSTRAINT participant_types_pkey PRIMARY KEY (id);


--
-- Name: participants participants_pkey; Type: CONSTRAINT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.participants
    ADD CONSTRAINT participants_pkey PRIMARY KEY (id);


--
-- Name: pay_charges pay_charges_pkey; Type: CONSTRAINT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.pay_charges
    ADD CONSTRAINT pay_charges_pkey PRIMARY KEY (id);


--
-- Name: pay_customers pay_customers_pkey; Type: CONSTRAINT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.pay_customers
    ADD CONSTRAINT pay_customers_pkey PRIMARY KEY (id);


--
-- Name: pay_merchants pay_merchants_pkey; Type: CONSTRAINT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.pay_merchants
    ADD CONSTRAINT pay_merchants_pkey PRIMARY KEY (id);


--
-- Name: pay_payment_methods pay_payment_methods_pkey; Type: CONSTRAINT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.pay_payment_methods
    ADD CONSTRAINT pay_payment_methods_pkey PRIMARY KEY (id);


--
-- Name: pay_subscriptions pay_subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.pay_subscriptions
    ADD CONSTRAINT pay_subscriptions_pkey PRIMARY KEY (id);


--
-- Name: pay_webhooks pay_webhooks_pkey; Type: CONSTRAINT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.pay_webhooks
    ADD CONSTRAINT pay_webhooks_pkey PRIMARY KEY (id);


--
-- Name: plans plans_pkey; Type: CONSTRAINT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.plans
    ADD CONSTRAINT plans_pkey PRIMARY KEY (id);


--
-- Name: refer_referral_codes refer_referral_codes_pkey; Type: CONSTRAINT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.refer_referral_codes
    ADD CONSTRAINT refer_referral_codes_pkey PRIMARY KEY (id);


--
-- Name: refer_referrals refer_referrals_pkey; Type: CONSTRAINT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.refer_referrals
    ADD CONSTRAINT refer_referrals_pkey PRIMARY KEY (id);


--
-- Name: refer_visits refer_visits_pkey; Type: CONSTRAINT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.refer_visits
    ADD CONSTRAINT refer_visits_pkey PRIMARY KEY (id);


--
-- Name: room_assignments room_assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.room_assignments
    ADD CONSTRAINT room_assignments_pkey PRIMARY KEY (id);


--
-- Name: rooms rooms_pkey; Type: CONSTRAINT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.rooms
    ADD CONSTRAINT rooms_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: side_events side_events_pkey; Type: CONSTRAINT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.side_events
    ADD CONSTRAINT side_events_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: customer_owner_processor_index; Type: INDEX; Schema: public; Owner: abinet
--

CREATE INDEX customer_owner_processor_index ON public.pay_customers USING btree (owner_type, owner_id, deleted_at);


--
-- Name: index_account_invitations_on_account_id_and_email; Type: INDEX; Schema: public; Owner: abinet
--

CREATE UNIQUE INDEX index_account_invitations_on_account_id_and_email ON public.account_invitations USING btree (account_id, email);


--
-- Name: index_account_invitations_on_invited_by_id; Type: INDEX; Schema: public; Owner: abinet
--

CREATE INDEX index_account_invitations_on_invited_by_id ON public.account_invitations USING btree (invited_by_id);


--
-- Name: index_account_invitations_on_token; Type: INDEX; Schema: public; Owner: abinet
--

CREATE UNIQUE INDEX index_account_invitations_on_token ON public.account_invitations USING btree (token);


--
-- Name: index_account_users_on_account_id_and_user_id; Type: INDEX; Schema: public; Owner: abinet
--

CREATE UNIQUE INDEX index_account_users_on_account_id_and_user_id ON public.account_users USING btree (account_id, user_id);


--
-- Name: index_accounts_on_owner_id; Type: INDEX; Schema: public; Owner: abinet
--

CREATE INDEX index_accounts_on_owner_id ON public.accounts USING btree (owner_id);


--
-- Name: index_action_text_rich_texts_uniqueness; Type: INDEX; Schema: public; Owner: abinet
--

CREATE UNIQUE INDEX index_action_text_rich_texts_uniqueness ON public.action_text_rich_texts USING btree (record_type, record_id, name);


--
-- Name: index_active_storage_attachments_on_blob_id; Type: INDEX; Schema: public; Owner: abinet
--

CREATE INDEX index_active_storage_attachments_on_blob_id ON public.active_storage_attachments USING btree (blob_id);


--
-- Name: index_active_storage_attachments_uniqueness; Type: INDEX; Schema: public; Owner: abinet
--

CREATE UNIQUE INDEX index_active_storage_attachments_uniqueness ON public.active_storage_attachments USING btree (record_type, record_id, name, blob_id);


--
-- Name: index_active_storage_blobs_on_key; Type: INDEX; Schema: public; Owner: abinet
--

CREATE UNIQUE INDEX index_active_storage_blobs_on_key ON public.active_storage_blobs USING btree (key);


--
-- Name: index_active_storage_variant_records_uniqueness; Type: INDEX; Schema: public; Owner: abinet
--

CREATE UNIQUE INDEX index_active_storage_variant_records_uniqueness ON public.active_storage_variant_records USING btree (blob_id, variation_digest);


--
-- Name: index_addresses_on_addressable; Type: INDEX; Schema: public; Owner: abinet
--

CREATE INDEX index_addresses_on_addressable ON public.addresses USING btree (addressable_type, addressable_id);


--
-- Name: index_api_tokens_on_token; Type: INDEX; Schema: public; Owner: abinet
--

CREATE UNIQUE INDEX index_api_tokens_on_token ON public.api_tokens USING btree (token);


--
-- Name: index_api_tokens_on_user_id; Type: INDEX; Schema: public; Owner: abinet
--

CREATE INDEX index_api_tokens_on_user_id ON public.api_tokens USING btree (user_id);


--
-- Name: index_connected_accounts_on_owner_id_and_owner_type; Type: INDEX; Schema: public; Owner: abinet
--

CREATE INDEX index_connected_accounts_on_owner_id_and_owner_type ON public.connected_accounts USING btree (owner_id, owner_type);


--
-- Name: index_field_visit_activities_on_field_visit_area_id; Type: INDEX; Schema: public; Owner: abinet
--

CREATE INDEX index_field_visit_activities_on_field_visit_area_id ON public.field_visit_activities USING btree (field_visit_area_id);


--
-- Name: index_noticed_events_on_account_id; Type: INDEX; Schema: public; Owner: abinet
--

CREATE INDEX index_noticed_events_on_account_id ON public.noticed_events USING btree (account_id);


--
-- Name: index_noticed_events_on_record; Type: INDEX; Schema: public; Owner: abinet
--

CREATE INDEX index_noticed_events_on_record ON public.noticed_events USING btree (record_type, record_id);


--
-- Name: index_noticed_notifications_on_account_id; Type: INDEX; Schema: public; Owner: abinet
--

CREATE INDEX index_noticed_notifications_on_account_id ON public.noticed_notifications USING btree (account_id);


--
-- Name: index_noticed_notifications_on_event_id; Type: INDEX; Schema: public; Owner: abinet
--

CREATE INDEX index_noticed_notifications_on_event_id ON public.noticed_notifications USING btree (event_id);


--
-- Name: index_noticed_notifications_on_recipient; Type: INDEX; Schema: public; Owner: abinet
--

CREATE INDEX index_noticed_notifications_on_recipient ON public.noticed_notifications USING btree (recipient_type, recipient_id);


--
-- Name: index_notification_tokens_on_user_id; Type: INDEX; Schema: public; Owner: abinet
--

CREATE INDEX index_notification_tokens_on_user_id ON public.notification_tokens USING btree (user_id);


--
-- Name: index_notifications_on_account_id; Type: INDEX; Schema: public; Owner: abinet
--

CREATE INDEX index_notifications_on_account_id ON public.notifications USING btree (account_id);


--
-- Name: index_notifications_on_recipient_type_and_recipient_id; Type: INDEX; Schema: public; Owner: abinet
--

CREATE INDEX index_notifications_on_recipient_type_and_recipient_id ON public.notifications USING btree (recipient_type, recipient_id);


--
-- Name: index_participants_on_group_id; Type: INDEX; Schema: public; Owner: abinet
--

CREATE INDEX index_participants_on_group_id ON public.participants USING btree (group_id);


--
-- Name: index_participants_on_organization_id; Type: INDEX; Schema: public; Owner: abinet
--

CREATE INDEX index_participants_on_organization_id ON public.participants USING btree (organization_id);


--
-- Name: index_participants_on_participant_type_id; Type: INDEX; Schema: public; Owner: abinet
--

CREATE INDEX index_participants_on_participant_type_id ON public.participants USING btree (participant_type_id);


--
-- Name: index_participants_on_side_event_id; Type: INDEX; Schema: public; Owner: abinet
--

CREATE INDEX index_participants_on_side_event_id ON public.participants USING btree (side_event_id);


--
-- Name: index_pay_charges_on_customer_id_and_processor_id; Type: INDEX; Schema: public; Owner: abinet
--

CREATE UNIQUE INDEX index_pay_charges_on_customer_id_and_processor_id ON public.pay_charges USING btree (customer_id, processor_id);


--
-- Name: index_pay_customers_on_processor_and_processor_id; Type: INDEX; Schema: public; Owner: abinet
--

CREATE INDEX index_pay_customers_on_processor_and_processor_id ON public.pay_customers USING btree (processor, processor_id);


--
-- Name: index_pay_merchants_on_owner_type_and_owner_id_and_processor; Type: INDEX; Schema: public; Owner: abinet
--

CREATE INDEX index_pay_merchants_on_owner_type_and_owner_id_and_processor ON public.pay_merchants USING btree (owner_type, owner_id, processor);


--
-- Name: index_pay_payment_methods_on_customer_id_and_processor_id; Type: INDEX; Schema: public; Owner: abinet
--

CREATE UNIQUE INDEX index_pay_payment_methods_on_customer_id_and_processor_id ON public.pay_payment_methods USING btree (customer_id, processor_id);


--
-- Name: index_pay_subscriptions_on_customer_id_and_processor_id; Type: INDEX; Schema: public; Owner: abinet
--

CREATE UNIQUE INDEX index_pay_subscriptions_on_customer_id_and_processor_id ON public.pay_subscriptions USING btree (customer_id, processor_id);


--
-- Name: index_pay_subscriptions_on_metered; Type: INDEX; Schema: public; Owner: abinet
--

CREATE INDEX index_pay_subscriptions_on_metered ON public.pay_subscriptions USING btree (metered);


--
-- Name: index_pay_subscriptions_on_pause_starts_at; Type: INDEX; Schema: public; Owner: abinet
--

CREATE INDEX index_pay_subscriptions_on_pause_starts_at ON public.pay_subscriptions USING btree (pause_starts_at);


--
-- Name: index_refer_referral_codes_on_code; Type: INDEX; Schema: public; Owner: abinet
--

CREATE UNIQUE INDEX index_refer_referral_codes_on_code ON public.refer_referral_codes USING btree (code);


--
-- Name: index_refer_referral_codes_on_referrer; Type: INDEX; Schema: public; Owner: abinet
--

CREATE INDEX index_refer_referral_codes_on_referrer ON public.refer_referral_codes USING btree (referrer_type, referrer_id);


--
-- Name: index_refer_referrals_on_referee; Type: INDEX; Schema: public; Owner: abinet
--

CREATE INDEX index_refer_referrals_on_referee ON public.refer_referrals USING btree (referee_type, referee_id);


--
-- Name: index_refer_referrals_on_referral_code_id; Type: INDEX; Schema: public; Owner: abinet
--

CREATE INDEX index_refer_referrals_on_referral_code_id ON public.refer_referrals USING btree (referral_code_id);


--
-- Name: index_refer_referrals_on_referrer; Type: INDEX; Schema: public; Owner: abinet
--

CREATE INDEX index_refer_referrals_on_referrer ON public.refer_referrals USING btree (referrer_type, referrer_id);


--
-- Name: index_refer_visits_on_referral_code_id; Type: INDEX; Schema: public; Owner: abinet
--

CREATE INDEX index_refer_visits_on_referral_code_id ON public.refer_visits USING btree (referral_code_id);


--
-- Name: index_room_assignments_on_participant_id; Type: INDEX; Schema: public; Owner: abinet
--

CREATE INDEX index_room_assignments_on_participant_id ON public.room_assignments USING btree (participant_id);


--
-- Name: index_room_assignments_on_room_id; Type: INDEX; Schema: public; Owner: abinet
--

CREATE INDEX index_room_assignments_on_room_id ON public.room_assignments USING btree (room_id);


--
-- Name: index_rooms_on_hotel_id; Type: INDEX; Schema: public; Owner: abinet
--

CREATE INDEX index_rooms_on_hotel_id ON public.rooms USING btree (hotel_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: abinet
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: index_users_on_invitation_token; Type: INDEX; Schema: public; Owner: abinet
--

CREATE UNIQUE INDEX index_users_on_invitation_token ON public.users USING btree (invitation_token);


--
-- Name: index_users_on_invitations_count; Type: INDEX; Schema: public; Owner: abinet
--

CREATE INDEX index_users_on_invitations_count ON public.users USING btree (invitations_count);


--
-- Name: index_users_on_invited_by_id; Type: INDEX; Schema: public; Owner: abinet
--

CREATE INDEX index_users_on_invited_by_id ON public.users USING btree (invited_by_id);


--
-- Name: index_users_on_invited_by_type_and_invited_by_id; Type: INDEX; Schema: public; Owner: abinet
--

CREATE INDEX index_users_on_invited_by_type_and_invited_by_id ON public.users USING btree (invited_by_type, invited_by_id);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: abinet
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON public.users USING btree (reset_password_token);


--
-- Name: participants set_serial_number; Type: TRIGGER; Schema: public; Owner: abinet
--

CREATE TRIGGER set_serial_number BEFORE INSERT ON public.participants FOR EACH ROW EXECUTE FUNCTION public.generate_serial_number();


--
-- Name: account_invitations fk_rails_04a176d6ed; Type: FK CONSTRAINT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.account_invitations
    ADD CONSTRAINT fk_rails_04a176d6ed FOREIGN KEY (invited_by_id) REFERENCES public.users(id);


--
-- Name: field_visit_activities fk_rails_335f68034d; Type: FK CONSTRAINT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.field_visit_activities
    ADD CONSTRAINT fk_rails_335f68034d FOREIGN KEY (field_visit_area_id) REFERENCES public.field_visit_areas(id);


--
-- Name: participants fk_rails_374e5e814f; Type: FK CONSTRAINT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.participants
    ADD CONSTRAINT fk_rails_374e5e814f FOREIGN KEY (group_id) REFERENCES public.groups(id);


--
-- Name: accounts fk_rails_37ced7af95; Type: FK CONSTRAINT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT fk_rails_37ced7af95 FOREIGN KEY (owner_id) REFERENCES public.users(id);


--
-- Name: refer_visits fk_rails_3a8f8143d1; Type: FK CONSTRAINT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.refer_visits
    ADD CONSTRAINT fk_rails_3a8f8143d1 FOREIGN KEY (referral_code_id) REFERENCES public.refer_referral_codes(id);


--
-- Name: participants fk_rails_443b1c608f; Type: FK CONSTRAINT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.participants
    ADD CONSTRAINT fk_rails_443b1c608f FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- Name: account_users fk_rails_685e030c15; Type: FK CONSTRAINT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.account_users
    ADD CONSTRAINT fk_rails_685e030c15 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: account_invitations fk_rails_7a9e106543; Type: FK CONSTRAINT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.account_invitations
    ADD CONSTRAINT fk_rails_7a9e106543 FOREIGN KEY (account_id) REFERENCES public.accounts(id);


--
-- Name: active_storage_variant_records fk_rails_993965df05; Type: FK CONSTRAINT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.active_storage_variant_records
    ADD CONSTRAINT fk_rails_993965df05 FOREIGN KEY (blob_id) REFERENCES public.active_storage_blobs(id);


--
-- Name: room_assignments fk_rails_a9f0575948; Type: FK CONSTRAINT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.room_assignments
    ADD CONSTRAINT fk_rails_a9f0575948 FOREIGN KEY (participant_id) REFERENCES public.participants(id);


--
-- Name: pay_charges fk_rails_b19d32f835; Type: FK CONSTRAINT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.pay_charges
    ADD CONSTRAINT fk_rails_b19d32f835 FOREIGN KEY (customer_id) REFERENCES public.pay_customers(id);


--
-- Name: pay_subscriptions fk_rails_b7cd64d378; Type: FK CONSTRAINT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.pay_subscriptions
    ADD CONSTRAINT fk_rails_b7cd64d378 FOREIGN KEY (customer_id) REFERENCES public.pay_customers(id);


--
-- Name: room_assignments fk_rails_b844a8550e; Type: FK CONSTRAINT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.room_assignments
    ADD CONSTRAINT fk_rails_b844a8550e FOREIGN KEY (room_id) REFERENCES public.rooms(id);


--
-- Name: participants fk_rails_be666622ae; Type: FK CONSTRAINT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.participants
    ADD CONSTRAINT fk_rails_be666622ae FOREIGN KEY (participant_type_id) REFERENCES public.participant_types(id);


--
-- Name: pay_payment_methods fk_rails_c78c6cb84d; Type: FK CONSTRAINT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.pay_payment_methods
    ADD CONSTRAINT fk_rails_c78c6cb84d FOREIGN KEY (customer_id) REFERENCES public.pay_customers(id);


--
-- Name: account_users fk_rails_c96445f213; Type: FK CONSTRAINT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.account_users
    ADD CONSTRAINT fk_rails_c96445f213 FOREIGN KEY (account_id) REFERENCES public.accounts(id);


--
-- Name: rooms fk_rails_cae2c0f55d; Type: FK CONSTRAINT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.rooms
    ADD CONSTRAINT fk_rails_cae2c0f55d FOREIGN KEY (hotel_id) REFERENCES public.hotels(id);


--
-- Name: api_tokens fk_rails_f16b5e0447; Type: FK CONSTRAINT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.api_tokens
    ADD CONSTRAINT fk_rails_f16b5e0447 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: participants fk_rails_f541196018; Type: FK CONSTRAINT; Schema: public; Owner: abinet
--

ALTER TABLE ONLY public.participants
    ADD CONSTRAINT fk_rails_f541196018 FOREIGN KEY (side_event_id) REFERENCES public.side_events(id);


--
-- PostgreSQL database dump complete
--

