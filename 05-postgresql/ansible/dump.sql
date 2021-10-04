--
-- PostgreSQL database dump
--

-- Dumped from database version 14.0
-- Dumped by pg_dump version 14.0

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
-- Name: soundex(text); Type: FUNCTION; Schema: public; Owner: joomla_user
--

CREATE FUNCTION public.soundex(input text) RETURNS text
    LANGUAGE plpgsql IMMUTABLE STRICT COST 500
    AS $$
DECLARE
  soundex text = '';
  char text;
  symbol text;
  last_symbol text = '';
  pos int = 1;
BEGIN
  WHILE length(soundex) < 4 LOOP
    char = upper(substr(input, pos, 1));
    pos = pos + 1;
    CASE char
    WHEN '' THEN
      -- End of input string
      IF soundex = '' THEN
        RETURN '';
      ELSE
        RETURN rpad(soundex, 4, '0');
      END IF;
    WHEN 'B', 'F', 'P', 'V' THEN
      symbol = '1';
    WHEN 'C', 'G', 'J', 'K', 'Q', 'S', 'X', 'Z' THEN
      symbol = '2';
    WHEN 'D', 'T' THEN
      symbol = '3';
    WHEN 'L' THEN
      symbol = '4';
    WHEN 'M', 'N' THEN
      symbol = '5';
    WHEN 'R' THEN
      symbol = '6';
    ELSE
      -- Not a consonant; no output, but next similar consonant will be re-recorded
      symbol = '';
    END CASE;

    IF soundex = '' THEN
      -- First character; only accept strictly English ASCII characters
      IF char ~>=~ 'A' AND char ~<=~ 'Z' THEN
        soundex = char;
        last_symbol = symbol;
      END IF;
    ELSIF last_symbol != symbol THEN
      soundex = soundex || symbol;
      last_symbol = symbol;
    END IF;
  END LOOP;

  RETURN soundex;
END;
$$;


ALTER FUNCTION public.soundex(input text) OWNER TO joomla_user;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: joomla_action_log_config; Type: TABLE; Schema: public; Owner: joomla_user
--

CREATE TABLE public.joomla_action_log_config (
    id integer NOT NULL,
    type_title character varying(255) DEFAULT ''::character varying NOT NULL,
    type_alias character varying(255) DEFAULT ''::character varying NOT NULL,
    id_holder character varying(255),
    title_holder character varying(255),
    table_name character varying(255),
    text_prefix character varying(255)
);


ALTER TABLE public.joomla_action_log_config OWNER TO joomla_user;

--
-- Name: joomla_action_log_config_id_seq; Type: SEQUENCE; Schema: public; Owner: joomla_user
--

CREATE SEQUENCE public.joomla_action_log_config_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.joomla_action_log_config_id_seq OWNER TO joomla_user;

--
-- Name: joomla_action_log_config_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: joomla_user
--

ALTER SEQUENCE public.joomla_action_log_config_id_seq OWNED BY public.joomla_action_log_config.id;


--
-- Name: joomla_action_logs; Type: TABLE; Schema: public; Owner: joomla_user
--

CREATE TABLE public.joomla_action_logs (
    id integer NOT NULL,
    message_language_key character varying(255) DEFAULT ''::character varying NOT NULL,
    message text NOT NULL,
    log_date timestamp without time zone NOT NULL,
    extension character varying(50) DEFAULT ''::character varying NOT NULL,
    user_id integer DEFAULT 0 NOT NULL,
    item_id integer DEFAULT 0 NOT NULL,
    ip_address character varying(40) DEFAULT '0.0.0.0'::character varying NOT NULL
);


ALTER TABLE public.joomla_action_logs OWNER TO joomla_user;

--
-- Name: joomla_action_logs_extensions; Type: TABLE; Schema: public; Owner: joomla_user
--

CREATE TABLE public.joomla_action_logs_extensions (
    id integer NOT NULL,
    extension character varying(50) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.joomla_action_logs_extensions OWNER TO joomla_user;

--
-- Name: joomla_action_logs_extensions_id_seq; Type: SEQUENCE; Schema: public; Owner: joomla_user
--

CREATE SEQUENCE public.joomla_action_logs_extensions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.joomla_action_logs_extensions_id_seq OWNER TO joomla_user;

--
-- Name: joomla_action_logs_extensions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: joomla_user
--

ALTER SEQUENCE public.joomla_action_logs_extensions_id_seq OWNED BY public.joomla_action_logs_extensions.id;


--
-- Name: joomla_action_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: joomla_user
--

CREATE SEQUENCE public.joomla_action_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.joomla_action_logs_id_seq OWNER TO joomla_user;

--
-- Name: joomla_action_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: joomla_user
--

ALTER SEQUENCE public.joomla_action_logs_id_seq OWNED BY public.joomla_action_logs.id;


--
-- Name: joomla_action_logs_users; Type: TABLE; Schema: public; Owner: joomla_user
--

CREATE TABLE public.joomla_action_logs_users (
    user_id integer NOT NULL,
    notify integer NOT NULL,
    extensions text NOT NULL
);


ALTER TABLE public.joomla_action_logs_users OWNER TO joomla_user;

--
-- Name: joomla_assets; Type: TABLE; Schema: public; Owner: joomla_user
--

CREATE TABLE public.joomla_assets (
    id integer NOT NULL,
    parent_id bigint DEFAULT 0 NOT NULL,
    lft bigint DEFAULT 0 NOT NULL,
    rgt bigint DEFAULT 0 NOT NULL,
    level integer NOT NULL,
    name character varying(50) NOT NULL,
    title character varying(100) NOT NULL,
    rules character varying(5120) NOT NULL
);


ALTER TABLE public.joomla_assets OWNER TO joomla_user;

--
-- Name: COLUMN joomla_assets.id; Type: COMMENT; Schema: public; Owner: joomla_user
--

COMMENT ON COLUMN public.joomla_assets.id IS 'Primary Key';


--
-- Name: COLUMN joomla_assets.parent_id; Type: COMMENT; Schema: public; Owner: joomla_user
--

COMMENT ON COLUMN public.joomla_assets.parent_id IS 'Nested set parent.';


--
-- Name: COLUMN joomla_assets.lft; Type: COMMENT; Schema: public; Owner: joomla_user
--

COMMENT ON COLUMN public.joomla_assets.lft IS 'Nested set lft.';


--
-- Name: COLUMN joomla_assets.rgt; Type: COMMENT; Schema: public; Owner: joomla_user
--

COMMENT ON COLUMN public.joomla_assets.rgt IS 'Nested set rgt.';


--
-- Name: COLUMN joomla_assets.level; Type: COMMENT; Schema: public; Owner: joomla_user
--

COMMENT ON COLUMN public.joomla_assets.level IS 'The cached level in the nested tree.';


--
-- Name: COLUMN joomla_assets.name; Type: COMMENT; Schema: public; Owner: joomla_user
--

COMMENT ON COLUMN public.joomla_assets.name IS 'The unique name for the asset.';


--
-- Name: COLUMN joomla_assets.title; Type: COMMENT; Schema: public; Owner: joomla_user
--

COMMENT ON COLUMN public.joomla_assets.title IS 'The descriptive title for the asset.';


--
-- Name: COLUMN joomla_assets.rules; Type: COMMENT; Schema: public; Owner: joomla_user
--

COMMENT ON COLUMN public.joomla_assets.rules IS 'JSON encoded access control.';


--
-- Name: joomla_assets_id_seq; Type: SEQUENCE; Schema: public; Owner: joomla_user
--

CREATE SEQUENCE public.joomla_assets_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.joomla_assets_id_seq OWNER TO joomla_user;

--
-- Name: joomla_assets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: joomla_user
--

ALTER SEQUENCE public.joomla_assets_id_seq OWNED BY public.joomla_assets.id;


--
-- Name: joomla_associations; Type: TABLE; Schema: public; Owner: joomla_user
--

CREATE TABLE public.joomla_associations (
    id integer NOT NULL,
    context character varying(50) NOT NULL,
    key character(32) NOT NULL
);


ALTER TABLE public.joomla_associations OWNER TO joomla_user;

--
-- Name: COLUMN joomla_associations.id; Type: COMMENT; Schema: public; Owner: joomla_user
--

COMMENT ON COLUMN public.joomla_associations.id IS 'A reference to the associated item.';


--
-- Name: COLUMN joomla_associations.context; Type: COMMENT; Schema: public; Owner: joomla_user
--

COMMENT ON COLUMN public.joomla_associations.context IS 'The context of the associated item.';


--
-- Name: COLUMN joomla_associations.key; Type: COMMENT; Schema: public; Owner: joomla_user
--

COMMENT ON COLUMN public.joomla_associations.key IS 'The key for the association computed from an md5 on associated ids.';


--
-- Name: joomla_banner_clients; Type: TABLE; Schema: public; Owner: joomla_user
--

CREATE TABLE public.joomla_banner_clients (
    id integer NOT NULL,
    name character varying(255) DEFAULT ''::character varying NOT NULL,
    contact character varying(255) DEFAULT ''::character varying NOT NULL,
    email character varying(255) DEFAULT ''::character varying NOT NULL,
    extrainfo text NOT NULL,
    state smallint DEFAULT 0 NOT NULL,
    checked_out integer,
    checked_out_time timestamp without time zone,
    metakey text,
    own_prefix smallint DEFAULT 0 NOT NULL,
    metakey_prefix character varying(255) DEFAULT ''::character varying NOT NULL,
    purchase_type smallint DEFAULT '-1'::integer NOT NULL,
    track_clicks smallint DEFAULT '-1'::integer NOT NULL,
    track_impressions smallint DEFAULT '-1'::integer NOT NULL
);


ALTER TABLE public.joomla_banner_clients OWNER TO joomla_user;

--
-- Name: joomla_banner_clients_id_seq; Type: SEQUENCE; Schema: public; Owner: joomla_user
--

CREATE SEQUENCE public.joomla_banner_clients_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.joomla_banner_clients_id_seq OWNER TO joomla_user;

--
-- Name: joomla_banner_clients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: joomla_user
--

ALTER SEQUENCE public.joomla_banner_clients_id_seq OWNED BY public.joomla_banner_clients.id;


--
-- Name: joomla_banner_tracks; Type: TABLE; Schema: public; Owner: joomla_user
--

CREATE TABLE public.joomla_banner_tracks (
    track_date timestamp without time zone NOT NULL,
    track_type bigint NOT NULL,
    banner_id bigint NOT NULL,
    count bigint DEFAULT 0 NOT NULL
);


ALTER TABLE public.joomla_banner_tracks OWNER TO joomla_user;

--
-- Name: joomla_banners; Type: TABLE; Schema: public; Owner: joomla_user
--

CREATE TABLE public.joomla_banners (
    id integer NOT NULL,
    cid bigint DEFAULT 0 NOT NULL,
    type bigint DEFAULT 0 NOT NULL,
    name character varying(255) DEFAULT ''::character varying NOT NULL,
    alias character varying(255) DEFAULT ''::character varying NOT NULL,
    imptotal bigint DEFAULT 0 NOT NULL,
    impmade bigint DEFAULT 0 NOT NULL,
    clicks bigint DEFAULT 0 NOT NULL,
    clickurl character varying(200) DEFAULT ''::character varying NOT NULL,
    state smallint DEFAULT 0 NOT NULL,
    catid bigint DEFAULT 0 NOT NULL,
    description text NOT NULL,
    custombannercode character varying(2048) NOT NULL,
    sticky smallint DEFAULT 0 NOT NULL,
    ordering bigint DEFAULT 0 NOT NULL,
    metakey text,
    params text NOT NULL,
    own_prefix smallint DEFAULT 0 NOT NULL,
    metakey_prefix character varying(255) DEFAULT ''::character varying NOT NULL,
    purchase_type smallint DEFAULT '-1'::integer NOT NULL,
    track_clicks smallint DEFAULT '-1'::integer NOT NULL,
    track_impressions smallint DEFAULT '-1'::integer NOT NULL,
    checked_out integer,
    checked_out_time timestamp without time zone,
    publish_up timestamp without time zone,
    publish_down timestamp without time zone,
    reset timestamp without time zone,
    created timestamp without time zone NOT NULL,
    language character varying(7) DEFAULT ''::character varying NOT NULL,
    created_by bigint DEFAULT 0 NOT NULL,
    created_by_alias character varying(255) DEFAULT ''::character varying NOT NULL,
    modified timestamp without time zone NOT NULL,
    modified_by bigint DEFAULT 0 NOT NULL,
    version bigint DEFAULT 1 NOT NULL
);


ALTER TABLE public.joomla_banners OWNER TO joomla_user;

--
-- Name: joomla_banners_id_seq; Type: SEQUENCE; Schema: public; Owner: joomla_user
--

CREATE SEQUENCE public.joomla_banners_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.joomla_banners_id_seq OWNER TO joomla_user;

--
-- Name: joomla_banners_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: joomla_user
--

ALTER SEQUENCE public.joomla_banners_id_seq OWNED BY public.joomla_banners.id;


--
-- Name: joomla_categories; Type: TABLE; Schema: public; Owner: joomla_user
--

CREATE TABLE public.joomla_categories (
    id integer NOT NULL,
    asset_id bigint DEFAULT 0 NOT NULL,
    parent_id integer DEFAULT 0 NOT NULL,
    lft bigint DEFAULT 0 NOT NULL,
    rgt bigint DEFAULT 0 NOT NULL,
    level integer DEFAULT 0 NOT NULL,
    path character varying(255) DEFAULT ''::character varying NOT NULL,
    extension character varying(50) DEFAULT ''::character varying NOT NULL,
    title character varying(255) DEFAULT ''::character varying NOT NULL,
    alias character varying(255) DEFAULT ''::character varying NOT NULL,
    note character varying(255) DEFAULT ''::character varying NOT NULL,
    description text,
    published smallint DEFAULT 0 NOT NULL,
    checked_out integer,
    checked_out_time timestamp without time zone,
    access bigint DEFAULT 0 NOT NULL,
    params text,
    metadesc character varying(1024) DEFAULT ''::character varying NOT NULL,
    metakey character varying(1024) DEFAULT ''::character varying NOT NULL,
    metadata character varying(2048) DEFAULT ''::character varying NOT NULL,
    created_user_id integer DEFAULT 0 NOT NULL,
    created_time timestamp without time zone NOT NULL,
    modified_user_id integer DEFAULT 0 NOT NULL,
    modified_time timestamp without time zone NOT NULL,
    hits integer DEFAULT 0 NOT NULL,
    language character varying(7) DEFAULT ''::character varying NOT NULL,
    version bigint DEFAULT 1 NOT NULL
);


ALTER TABLE public.joomla_categories OWNER TO joomla_user;

--
-- Name: COLUMN joomla_categories.asset_id; Type: COMMENT; Schema: public; Owner: joomla_user
--

COMMENT ON COLUMN public.joomla_categories.asset_id IS 'FK to the #__assets table.';


--
-- Name: COLUMN joomla_categories.metadesc; Type: COMMENT; Schema: public; Owner: joomla_user
--

COMMENT ON COLUMN public.joomla_categories.metadesc IS 'The meta description for the page.';


--
-- Name: COLUMN joomla_categories.metakey; Type: COMMENT; Schema: public; Owner: joomla_user
--

COMMENT ON COLUMN public.joomla_categories.metakey IS 'The keywords for the page.';


--
-- Name: COLUMN joomla_categories.metadata; Type: COMMENT; Schema: public; Owner: joomla_user
--

COMMENT ON COLUMN public.joomla_categories.metadata IS 'JSON encoded metadata properties.';


--
-- Name: joomla_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: joomla_user
--

CREATE SEQUENCE public.joomla_categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.joomla_categories_id_seq OWNER TO joomla_user;

--
-- Name: joomla_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: joomla_user
--

ALTER SEQUENCE public.joomla_categories_id_seq OWNED BY public.joomla_categories.id;


--
-- Name: joomla_contact_details; Type: TABLE; Schema: public; Owner: joomla_user
--

CREATE TABLE public.joomla_contact_details (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    alias character varying(255) NOT NULL,
    con_position character varying(255),
    address text,
    suburb character varying(100),
    state character varying(100),
    country character varying(100),
    postcode character varying(100),
    telephone character varying(255),
    fax character varying(255),
    misc text,
    image character varying(255),
    email_to character varying(255),
    default_con smallint DEFAULT 0 NOT NULL,
    published smallint DEFAULT 0 NOT NULL,
    checked_out integer,
    checked_out_time timestamp without time zone,
    ordering bigint DEFAULT 0 NOT NULL,
    params text NOT NULL,
    user_id bigint DEFAULT 0 NOT NULL,
    catid bigint DEFAULT 0 NOT NULL,
    access bigint DEFAULT 0 NOT NULL,
    mobile character varying(255) DEFAULT ''::character varying NOT NULL,
    webpage character varying(255) DEFAULT ''::character varying NOT NULL,
    sortname1 character varying(255) DEFAULT ''::character varying NOT NULL,
    sortname2 character varying(255) DEFAULT ''::character varying NOT NULL,
    sortname3 character varying(255) DEFAULT ''::character varying NOT NULL,
    language character varying(7) NOT NULL,
    created timestamp without time zone NOT NULL,
    created_by integer DEFAULT 0 NOT NULL,
    created_by_alias character varying(255) DEFAULT ''::character varying NOT NULL,
    modified timestamp without time zone NOT NULL,
    modified_by integer DEFAULT 0 NOT NULL,
    metakey text,
    metadesc text NOT NULL,
    metadata text NOT NULL,
    featured smallint DEFAULT 0 NOT NULL,
    publish_up timestamp without time zone,
    publish_down timestamp without time zone,
    version bigint DEFAULT 1 NOT NULL,
    hits bigint DEFAULT 0 NOT NULL
);


ALTER TABLE public.joomla_contact_details OWNER TO joomla_user;

--
-- Name: COLUMN joomla_contact_details.featured; Type: COMMENT; Schema: public; Owner: joomla_user
--

COMMENT ON COLUMN public.joomla_contact_details.featured IS 'Set if contact is featured.';


--
-- Name: joomla_contact_details_id_seq; Type: SEQUENCE; Schema: public; Owner: joomla_user
--

CREATE SEQUENCE public.joomla_contact_details_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.joomla_contact_details_id_seq OWNER TO joomla_user;

--
-- Name: joomla_contact_details_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: joomla_user
--

ALTER SEQUENCE public.joomla_contact_details_id_seq OWNED BY public.joomla_contact_details.id;


--
-- Name: joomla_content; Type: TABLE; Schema: public; Owner: joomla_user
--

CREATE TABLE public.joomla_content (
    id integer NOT NULL,
    asset_id bigint DEFAULT 0 NOT NULL,
    title character varying(255) DEFAULT ''::character varying NOT NULL,
    alias character varying(255) DEFAULT ''::character varying NOT NULL,
    introtext text NOT NULL,
    fulltext text NOT NULL,
    state smallint DEFAULT 0 NOT NULL,
    catid bigint DEFAULT 0 NOT NULL,
    created timestamp without time zone NOT NULL,
    created_by bigint DEFAULT 0 NOT NULL,
    created_by_alias character varying(255) DEFAULT ''::character varying NOT NULL,
    modified timestamp without time zone NOT NULL,
    modified_by bigint DEFAULT 0 NOT NULL,
    checked_out integer,
    checked_out_time timestamp without time zone,
    publish_up timestamp without time zone,
    publish_down timestamp without time zone,
    images text NOT NULL,
    urls text NOT NULL,
    attribs character varying(5120) NOT NULL,
    version bigint DEFAULT 1 NOT NULL,
    ordering bigint DEFAULT 0 NOT NULL,
    metakey text,
    metadesc text NOT NULL,
    access bigint DEFAULT 0 NOT NULL,
    hits bigint DEFAULT 0 NOT NULL,
    metadata text NOT NULL,
    featured smallint DEFAULT 0 NOT NULL,
    language character varying(7) DEFAULT ''::character varying NOT NULL,
    note character varying(255) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.joomla_content OWNER TO joomla_user;

--
-- Name: COLUMN joomla_content.asset_id; Type: COMMENT; Schema: public; Owner: joomla_user
--

COMMENT ON COLUMN public.joomla_content.asset_id IS 'FK to the #__assets table.';


--
-- Name: COLUMN joomla_content.featured; Type: COMMENT; Schema: public; Owner: joomla_user
--

COMMENT ON COLUMN public.joomla_content.featured IS 'Set if article is featured.';


--
-- Name: COLUMN joomla_content.language; Type: COMMENT; Schema: public; Owner: joomla_user
--

COMMENT ON COLUMN public.joomla_content.language IS 'The language code for the article.';


--
-- Name: joomla_content_frontpage; Type: TABLE; Schema: public; Owner: joomla_user
--

CREATE TABLE public.joomla_content_frontpage (
    content_id bigint DEFAULT 0 NOT NULL,
    ordering bigint DEFAULT 0 NOT NULL,
    featured_up timestamp without time zone,
    featured_down timestamp without time zone
);


ALTER TABLE public.joomla_content_frontpage OWNER TO joomla_user;

--
-- Name: joomla_content_id_seq; Type: SEQUENCE; Schema: public; Owner: joomla_user
--

CREATE SEQUENCE public.joomla_content_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.joomla_content_id_seq OWNER TO joomla_user;

--
-- Name: joomla_content_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: joomla_user
--

ALTER SEQUENCE public.joomla_content_id_seq OWNED BY public.joomla_content.id;


--
-- Name: joomla_content_rating; Type: TABLE; Schema: public; Owner: joomla_user
--

CREATE TABLE public.joomla_content_rating (
    content_id bigint DEFAULT 0 NOT NULL,
    rating_sum bigint DEFAULT 0 NOT NULL,
    rating_count bigint DEFAULT 0 NOT NULL,
    lastip character varying(50) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.joomla_content_rating OWNER TO joomla_user;

--
-- Name: joomla_content_types; Type: TABLE; Schema: public; Owner: joomla_user
--

CREATE TABLE public.joomla_content_types (
    type_id integer NOT NULL,
    type_title character varying(255) DEFAULT ''::character varying NOT NULL,
    type_alias character varying(255) DEFAULT ''::character varying NOT NULL,
    "table" character varying(2048) DEFAULT ''::character varying NOT NULL,
    rules text NOT NULL,
    field_mappings text NOT NULL,
    router character varying(255) DEFAULT ''::character varying NOT NULL,
    content_history_options character varying(5120) DEFAULT NULL::character varying
);


ALTER TABLE public.joomla_content_types OWNER TO joomla_user;

--
-- Name: COLUMN joomla_content_types.content_history_options; Type: COMMENT; Schema: public; Owner: joomla_user
--

COMMENT ON COLUMN public.joomla_content_types.content_history_options IS 'JSON string for com_contenthistory options';


--
-- Name: joomla_content_types_type_id_seq; Type: SEQUENCE; Schema: public; Owner: joomla_user
--

CREATE SEQUENCE public.joomla_content_types_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.joomla_content_types_type_id_seq OWNER TO joomla_user;

--
-- Name: joomla_content_types_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: joomla_user
--

ALTER SEQUENCE public.joomla_content_types_type_id_seq OWNED BY public.joomla_content_types.type_id;


--
-- Name: joomla_contentitem_tag_map; Type: TABLE; Schema: public; Owner: joomla_user
--

CREATE TABLE public.joomla_contentitem_tag_map (
    type_alias character varying(255) DEFAULT ''::character varying NOT NULL,
    core_content_id integer NOT NULL,
    content_item_id integer NOT NULL,
    tag_id integer NOT NULL,
    tag_date timestamp without time zone DEFAULT '1970-01-01 00:00:00'::timestamp without time zone NOT NULL,
    type_id integer NOT NULL
);


ALTER TABLE public.joomla_contentitem_tag_map OWNER TO joomla_user;

--
-- Name: COLUMN joomla_contentitem_tag_map.core_content_id; Type: COMMENT; Schema: public; Owner: joomla_user
--

COMMENT ON COLUMN public.joomla_contentitem_tag_map.core_content_id IS 'PK from the core content table';


--
-- Name: COLUMN joomla_contentitem_tag_map.content_item_id; Type: COMMENT; Schema: public; Owner: joomla_user
--

COMMENT ON COLUMN public.joomla_contentitem_tag_map.content_item_id IS 'PK from the content type table';


--
-- Name: COLUMN joomla_contentitem_tag_map.tag_id; Type: COMMENT; Schema: public; Owner: joomla_user
--

COMMENT ON COLUMN public.joomla_contentitem_tag_map.tag_id IS 'PK from the tag table';


--
-- Name: COLUMN joomla_contentitem_tag_map.tag_date; Type: COMMENT; Schema: public; Owner: joomla_user
--

COMMENT ON COLUMN public.joomla_contentitem_tag_map.tag_date IS 'Date of most recent save for this tag-item';


--
-- Name: COLUMN joomla_contentitem_tag_map.type_id; Type: COMMENT; Schema: public; Owner: joomla_user
--

COMMENT ON COLUMN public.joomla_contentitem_tag_map.type_id IS 'PK from the content_type table';


--
-- Name: joomla_extensions; Type: TABLE; Schema: public; Owner: joomla_user
--

CREATE TABLE public.joomla_extensions (
    extension_id integer NOT NULL,
    package_id bigint DEFAULT 0 NOT NULL,
    name character varying(100) NOT NULL,
    type character varying(20) NOT NULL,
    element character varying(100) NOT NULL,
    changelogurl text,
    folder character varying(100) NOT NULL,
    client_id smallint NOT NULL,
    enabled smallint DEFAULT 0 NOT NULL,
    access bigint DEFAULT 1 NOT NULL,
    protected smallint DEFAULT 0 NOT NULL,
    locked smallint DEFAULT 0 NOT NULL,
    manifest_cache text NOT NULL,
    params text NOT NULL,
    custom_data text NOT NULL,
    checked_out integer,
    checked_out_time timestamp without time zone,
    ordering bigint DEFAULT 0,
    state bigint DEFAULT 0,
    note character varying(255)
);


ALTER TABLE public.joomla_extensions OWNER TO joomla_user;

--
-- Name: COLUMN joomla_extensions.package_id; Type: COMMENT; Schema: public; Owner: joomla_user
--

COMMENT ON COLUMN public.joomla_extensions.package_id IS 'Parent package ID for extensions installed as a package.';


--
-- Name: COLUMN joomla_extensions.protected; Type: COMMENT; Schema: public; Owner: joomla_user
--

COMMENT ON COLUMN public.joomla_extensions.protected IS 'Flag to indicate if the extension is protected. Protected extensions cannot be disabled.';


--
-- Name: COLUMN joomla_extensions.locked; Type: COMMENT; Schema: public; Owner: joomla_user
--

COMMENT ON COLUMN public.joomla_extensions.locked IS 'Flag to indicate if the extension is locked. Locked extensions cannot be uninstalled.';


--
-- Name: joomla_extensions_extension_id_seq; Type: SEQUENCE; Schema: public; Owner: joomla_user
--

CREATE SEQUENCE public.joomla_extensions_extension_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.joomla_extensions_extension_id_seq OWNER TO joomla_user;

--
-- Name: joomla_extensions_extension_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: joomla_user
--

ALTER SEQUENCE public.joomla_extensions_extension_id_seq OWNED BY public.joomla_extensions.extension_id;


--
-- Name: joomla_fields; Type: TABLE; Schema: public; Owner: joomla_user
--

CREATE TABLE public.joomla_fields (
    id integer NOT NULL,
    asset_id bigint DEFAULT 0 NOT NULL,
    context character varying(255) DEFAULT ''::character varying NOT NULL,
    group_id bigint DEFAULT 0 NOT NULL,
    title character varying(255) DEFAULT ''::character varying NOT NULL,
    name character varying(255) DEFAULT ''::character varying NOT NULL,
    label character varying(255) DEFAULT ''::character varying NOT NULL,
    default_value text,
    type character varying(255) DEFAULT 'text'::character varying NOT NULL,
    note character varying(255) DEFAULT ''::character varying NOT NULL,
    description text NOT NULL,
    state smallint DEFAULT 0 NOT NULL,
    required smallint DEFAULT 0 NOT NULL,
    only_use_in_subform smallint DEFAULT 0 NOT NULL,
    checked_out integer,
    checked_out_time timestamp without time zone,
    ordering bigint DEFAULT 0 NOT NULL,
    params text NOT NULL,
    fieldparams text NOT NULL,
    language character varying(7) DEFAULT ''::character varying NOT NULL,
    created_time timestamp without time zone NOT NULL,
    created_user_id bigint DEFAULT 0 NOT NULL,
    modified_time timestamp without time zone NOT NULL,
    modified_by bigint DEFAULT 0 NOT NULL,
    access bigint DEFAULT 0 NOT NULL
);


ALTER TABLE public.joomla_fields OWNER TO joomla_user;

--
-- Name: joomla_fields_categories; Type: TABLE; Schema: public; Owner: joomla_user
--

CREATE TABLE public.joomla_fields_categories (
    field_id bigint DEFAULT 0 NOT NULL,
    category_id bigint DEFAULT 0 NOT NULL
);


ALTER TABLE public.joomla_fields_categories OWNER TO joomla_user;

--
-- Name: joomla_fields_groups; Type: TABLE; Schema: public; Owner: joomla_user
--

CREATE TABLE public.joomla_fields_groups (
    id integer NOT NULL,
    asset_id bigint DEFAULT 0 NOT NULL,
    context character varying(255) DEFAULT ''::character varying NOT NULL,
    title character varying(255) DEFAULT ''::character varying NOT NULL,
    note character varying(255) DEFAULT ''::character varying NOT NULL,
    description text NOT NULL,
    state smallint DEFAULT 0 NOT NULL,
    checked_out integer,
    checked_out_time timestamp without time zone,
    ordering integer DEFAULT 0 NOT NULL,
    params text NOT NULL,
    language character varying(7) DEFAULT ''::character varying NOT NULL,
    created timestamp without time zone NOT NULL,
    created_by bigint DEFAULT 0 NOT NULL,
    modified timestamp without time zone NOT NULL,
    modified_by bigint DEFAULT 0 NOT NULL,
    access bigint DEFAULT 1 NOT NULL
);


ALTER TABLE public.joomla_fields_groups OWNER TO joomla_user;

--
-- Name: joomla_fields_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: joomla_user
--

CREATE SEQUENCE public.joomla_fields_groups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.joomla_fields_groups_id_seq OWNER TO joomla_user;

--
-- Name: joomla_fields_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: joomla_user
--

ALTER SEQUENCE public.joomla_fields_groups_id_seq OWNED BY public.joomla_fields_groups.id;


--
-- Name: joomla_fields_id_seq; Type: SEQUENCE; Schema: public; Owner: joomla_user
--

CREATE SEQUENCE public.joomla_fields_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.joomla_fields_id_seq OWNER TO joomla_user;

--
-- Name: joomla_fields_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: joomla_user
--

ALTER SEQUENCE public.joomla_fields_id_seq OWNED BY public.joomla_fields.id;


--
-- Name: joomla_fields_values; Type: TABLE; Schema: public; Owner: joomla_user
--

CREATE TABLE public.joomla_fields_values (
    field_id bigint DEFAULT 0 NOT NULL,
    item_id character varying(255) DEFAULT ''::character varying NOT NULL,
    value text
);


ALTER TABLE public.joomla_fields_values OWNER TO joomla_user;

--
-- Name: joomla_finder_filters; Type: TABLE; Schema: public; Owner: joomla_user
--

CREATE TABLE public.joomla_finder_filters (
    filter_id integer NOT NULL,
    title character varying(255) NOT NULL,
    alias character varying(255) NOT NULL,
    state smallint DEFAULT 1 NOT NULL,
    created timestamp without time zone NOT NULL,
    created_by integer DEFAULT 0 NOT NULL,
    created_by_alias character varying(255) DEFAULT ''::character varying NOT NULL,
    modified timestamp without time zone NOT NULL,
    modified_by integer DEFAULT 0 NOT NULL,
    checked_out integer,
    checked_out_time timestamp without time zone,
    map_count integer DEFAULT 0 NOT NULL,
    data text,
    params text
);


ALTER TABLE public.joomla_finder_filters OWNER TO joomla_user;

--
-- Name: joomla_finder_filters_filter_id_seq; Type: SEQUENCE; Schema: public; Owner: joomla_user
--

CREATE SEQUENCE public.joomla_finder_filters_filter_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.joomla_finder_filters_filter_id_seq OWNER TO joomla_user;

--
-- Name: joomla_finder_filters_filter_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: joomla_user
--

ALTER SEQUENCE public.joomla_finder_filters_filter_id_seq OWNED BY public.joomla_finder_filters.filter_id;


--
-- Name: joomla_finder_links; Type: TABLE; Schema: public; Owner: joomla_user
--

CREATE TABLE public.joomla_finder_links (
    link_id integer NOT NULL,
    url character varying(255) NOT NULL,
    route character varying(400) NOT NULL,
    title character varying(400) DEFAULT NULL::character varying,
    description text,
    indexdate timestamp without time zone NOT NULL,
    md5sum character varying(32) DEFAULT NULL::character varying,
    published smallint DEFAULT 1 NOT NULL,
    state integer DEFAULT 1 NOT NULL,
    access integer DEFAULT 0 NOT NULL,
    language character varying(7) DEFAULT ''::character varying NOT NULL,
    publish_start_date timestamp without time zone,
    publish_end_date timestamp without time zone,
    start_date timestamp without time zone,
    end_date timestamp without time zone,
    list_price numeric(8,2) DEFAULT 0 NOT NULL,
    sale_price numeric(8,2) DEFAULT 0 NOT NULL,
    type_id bigint NOT NULL,
    object bytea
);


ALTER TABLE public.joomla_finder_links OWNER TO joomla_user;

--
-- Name: joomla_finder_links_link_id_seq; Type: SEQUENCE; Schema: public; Owner: joomla_user
--

CREATE SEQUENCE public.joomla_finder_links_link_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.joomla_finder_links_link_id_seq OWNER TO joomla_user;

--
-- Name: joomla_finder_links_link_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: joomla_user
--

ALTER SEQUENCE public.joomla_finder_links_link_id_seq OWNED BY public.joomla_finder_links.link_id;


--
-- Name: joomla_finder_links_terms; Type: TABLE; Schema: public; Owner: joomla_user
--

CREATE TABLE public.joomla_finder_links_terms (
    link_id integer NOT NULL,
    term_id integer NOT NULL,
    weight numeric(8,2) DEFAULT 0 NOT NULL
);


ALTER TABLE public.joomla_finder_links_terms OWNER TO joomla_user;

--
-- Name: joomla_finder_logging; Type: TABLE; Schema: public; Owner: joomla_user
--

CREATE TABLE public.joomla_finder_logging (
    searchterm character varying(255) DEFAULT ''::character varying NOT NULL,
    md5sum character varying(32) DEFAULT ''::character varying NOT NULL,
    query bytea NOT NULL,
    hits integer DEFAULT 1 NOT NULL,
    results integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.joomla_finder_logging OWNER TO joomla_user;

--
-- Name: joomla_finder_taxonomy; Type: TABLE; Schema: public; Owner: joomla_user
--

CREATE TABLE public.joomla_finder_taxonomy (
    id integer NOT NULL,
    parent_id integer DEFAULT 0 NOT NULL,
    lft integer DEFAULT 0 NOT NULL,
    rgt integer DEFAULT 0 NOT NULL,
    level integer DEFAULT 0 NOT NULL,
    path character varying(400) DEFAULT ''::character varying NOT NULL,
    title character varying(255) DEFAULT ''::character varying NOT NULL,
    alias character varying(400) DEFAULT ''::character varying NOT NULL,
    state smallint DEFAULT 1 NOT NULL,
    access smallint DEFAULT 1 NOT NULL,
    language character varying(7) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.joomla_finder_taxonomy OWNER TO joomla_user;

--
-- Name: joomla_finder_taxonomy_id_seq; Type: SEQUENCE; Schema: public; Owner: joomla_user
--

CREATE SEQUENCE public.joomla_finder_taxonomy_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.joomla_finder_taxonomy_id_seq OWNER TO joomla_user;

--
-- Name: joomla_finder_taxonomy_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: joomla_user
--

ALTER SEQUENCE public.joomla_finder_taxonomy_id_seq OWNED BY public.joomla_finder_taxonomy.id;


--
-- Name: joomla_finder_taxonomy_map; Type: TABLE; Schema: public; Owner: joomla_user
--

CREATE TABLE public.joomla_finder_taxonomy_map (
    link_id integer NOT NULL,
    node_id integer NOT NULL
);


ALTER TABLE public.joomla_finder_taxonomy_map OWNER TO joomla_user;

--
-- Name: joomla_finder_terms; Type: TABLE; Schema: public; Owner: joomla_user
--

CREATE TABLE public.joomla_finder_terms (
    term_id integer NOT NULL,
    term character varying(75) NOT NULL,
    stem character varying(75) DEFAULT ''::character varying NOT NULL,
    common smallint DEFAULT 0 NOT NULL,
    phrase smallint DEFAULT 0 NOT NULL,
    weight numeric(8,2) DEFAULT 0 NOT NULL,
    soundex character varying(75) DEFAULT ''::character varying NOT NULL,
    links integer DEFAULT 0 NOT NULL,
    language character varying(7) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.joomla_finder_terms OWNER TO joomla_user;

--
-- Name: joomla_finder_terms_common; Type: TABLE; Schema: public; Owner: joomla_user
--

CREATE TABLE public.joomla_finder_terms_common (
    term character varying(75) NOT NULL,
    language character varying(7) DEFAULT ''::character varying NOT NULL,
    custom integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.joomla_finder_terms_common OWNER TO joomla_user;

--
-- Name: joomla_finder_terms_term_id_seq; Type: SEQUENCE; Schema: public; Owner: joomla_user
--

CREATE SEQUENCE public.joomla_finder_terms_term_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.joomla_finder_terms_term_id_seq OWNER TO joomla_user;

--
-- Name: joomla_finder_terms_term_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: joomla_user
--

ALTER SEQUENCE public.joomla_finder_terms_term_id_seq OWNED BY public.joomla_finder_terms.term_id;


--
-- Name: joomla_finder_tokens; Type: TABLE; Schema: public; Owner: joomla_user
--

CREATE TABLE public.joomla_finder_tokens (
    term character varying(75) NOT NULL,
    stem character varying(75) DEFAULT ''::character varying NOT NULL,
    common smallint DEFAULT 0 NOT NULL,
    phrase smallint DEFAULT 0 NOT NULL,
    weight numeric(8,2) DEFAULT 1 NOT NULL,
    context smallint DEFAULT 2 NOT NULL,
    language character varying(7) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.joomla_finder_tokens OWNER TO joomla_user;

--
-- Name: joomla_finder_tokens_aggregate; Type: TABLE; Schema: public; Owner: joomla_user
--

CREATE TABLE public.joomla_finder_tokens_aggregate (
    term_id integer NOT NULL,
    term character varying(75) NOT NULL,
    stem character varying(75) DEFAULT ''::character varying NOT NULL,
    common smallint DEFAULT 0 NOT NULL,
    phrase smallint DEFAULT 0 NOT NULL,
    term_weight numeric(8,2) DEFAULT 0 NOT NULL,
    context smallint DEFAULT 2 NOT NULL,
    context_weight numeric(8,2) DEFAULT 0 NOT NULL,
    total_weight numeric(8,2) DEFAULT 0 NOT NULL,
    language character varying(7) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.joomla_finder_tokens_aggregate OWNER TO joomla_user;

--
-- Name: joomla_finder_types; Type: TABLE; Schema: public; Owner: joomla_user
--

CREATE TABLE public.joomla_finder_types (
    id integer NOT NULL,
    title character varying(100) NOT NULL,
    mime character varying(100) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.joomla_finder_types OWNER TO joomla_user;

--
-- Name: joomla_finder_types_id_seq; Type: SEQUENCE; Schema: public; Owner: joomla_user
--

CREATE SEQUENCE public.joomla_finder_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.joomla_finder_types_id_seq OWNER TO joomla_user;

--
-- Name: joomla_finder_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: joomla_user
--

ALTER SEQUENCE public.joomla_finder_types_id_seq OWNED BY public.joomla_finder_types.id;


--
-- Name: joomla_history; Type: TABLE; Schema: public; Owner: joomla_user
--

CREATE TABLE public.joomla_history (
    version_id integer NOT NULL,
    item_id character varying(50) NOT NULL,
    version_note character varying(255) DEFAULT ''::character varying NOT NULL,
    save_date timestamp with time zone NOT NULL,
    editor_user_id integer DEFAULT 0 NOT NULL,
    character_count integer DEFAULT 0 NOT NULL,
    sha1_hash character varying(50) DEFAULT ''::character varying NOT NULL,
    version_data text NOT NULL,
    keep_forever smallint DEFAULT 0 NOT NULL
);


ALTER TABLE public.joomla_history OWNER TO joomla_user;

--
-- Name: COLUMN joomla_history.version_note; Type: COMMENT; Schema: public; Owner: joomla_user
--

COMMENT ON COLUMN public.joomla_history.version_note IS 'Optional version name';


--
-- Name: COLUMN joomla_history.character_count; Type: COMMENT; Schema: public; Owner: joomla_user
--

COMMENT ON COLUMN public.joomla_history.character_count IS 'Number of characters in this version.';


--
-- Name: COLUMN joomla_history.sha1_hash; Type: COMMENT; Schema: public; Owner: joomla_user
--

COMMENT ON COLUMN public.joomla_history.sha1_hash IS 'SHA1 hash of the version_data column.';


--
-- Name: COLUMN joomla_history.version_data; Type: COMMENT; Schema: public; Owner: joomla_user
--

COMMENT ON COLUMN public.joomla_history.version_data IS 'json-encoded string of version data';


--
-- Name: COLUMN joomla_history.keep_forever; Type: COMMENT; Schema: public; Owner: joomla_user
--

COMMENT ON COLUMN public.joomla_history.keep_forever IS '0=auto delete; 1=keep';


--
-- Name: joomla_history_version_id_seq; Type: SEQUENCE; Schema: public; Owner: joomla_user
--

CREATE SEQUENCE public.joomla_history_version_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.joomla_history_version_id_seq OWNER TO joomla_user;

--
-- Name: joomla_history_version_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: joomla_user
--

ALTER SEQUENCE public.joomla_history_version_id_seq OWNED BY public.joomla_history.version_id;


--
-- Name: joomla_languages; Type: TABLE; Schema: public; Owner: joomla_user
--

CREATE TABLE public.joomla_languages (
    lang_id integer NOT NULL,
    asset_id bigint DEFAULT 0 NOT NULL,
    lang_code character varying(7) NOT NULL,
    title character varying(50) NOT NULL,
    title_native character varying(50) NOT NULL,
    sef character varying(50) NOT NULL,
    image character varying(50) NOT NULL,
    description character varying(512) NOT NULL,
    metakey text,
    metadesc text NOT NULL,
    sitename character varying(1024) DEFAULT ''::character varying NOT NULL,
    published bigint DEFAULT 0 NOT NULL,
    access integer DEFAULT 0 NOT NULL,
    ordering bigint DEFAULT 0 NOT NULL
);


ALTER TABLE public.joomla_languages OWNER TO joomla_user;

--
-- Name: joomla_languages_lang_id_seq; Type: SEQUENCE; Schema: public; Owner: joomla_user
--

CREATE SEQUENCE public.joomla_languages_lang_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.joomla_languages_lang_id_seq OWNER TO joomla_user;

--
-- Name: joomla_languages_lang_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: joomla_user
--

ALTER SEQUENCE public.joomla_languages_lang_id_seq OWNED BY public.joomla_languages.lang_id;


--
-- Name: joomla_mail_templates; Type: TABLE; Schema: public; Owner: joomla_user
--

CREATE TABLE public.joomla_mail_templates (
    template_id character varying(127) DEFAULT ''::character varying NOT NULL,
    extension character varying(127) DEFAULT ''::character varying NOT NULL,
    language character(7) DEFAULT ''::bpchar NOT NULL,
    subject character varying(255) DEFAULT ''::character varying NOT NULL,
    body text NOT NULL,
    htmlbody text NOT NULL,
    attachments text NOT NULL,
    params text NOT NULL
);


ALTER TABLE public.joomla_mail_templates OWNER TO joomla_user;

--
-- Name: joomla_menu; Type: TABLE; Schema: public; Owner: joomla_user
--

CREATE TABLE public.joomla_menu (
    id integer NOT NULL,
    menutype character varying(24) NOT NULL,
    title character varying(255) NOT NULL,
    alias character varying(255) NOT NULL,
    note character varying(255) DEFAULT ''::character varying NOT NULL,
    path character varying(1024) DEFAULT ''::character varying NOT NULL,
    link character varying(1024) NOT NULL,
    type character varying(16) NOT NULL,
    published smallint DEFAULT 0 NOT NULL,
    parent_id integer DEFAULT 1 NOT NULL,
    level integer DEFAULT 0 NOT NULL,
    component_id integer DEFAULT 0 NOT NULL,
    checked_out integer,
    checked_out_time timestamp without time zone,
    "browserNav" smallint DEFAULT 0 NOT NULL,
    access bigint DEFAULT 0 NOT NULL,
    img character varying(255) DEFAULT ''::character varying NOT NULL,
    template_style_id integer DEFAULT 0 NOT NULL,
    params text NOT NULL,
    lft bigint DEFAULT 0 NOT NULL,
    rgt bigint DEFAULT 0 NOT NULL,
    home smallint DEFAULT 0 NOT NULL,
    language character varying(7) DEFAULT ''::character varying NOT NULL,
    client_id smallint DEFAULT 0 NOT NULL,
    publish_up timestamp without time zone,
    publish_down timestamp without time zone
);


ALTER TABLE public.joomla_menu OWNER TO joomla_user;

--
-- Name: COLUMN joomla_menu.menutype; Type: COMMENT; Schema: public; Owner: joomla_user
--

COMMENT ON COLUMN public.joomla_menu.menutype IS 'The type of menu this item belongs to. FK to #__menu_types.menutype';


--
-- Name: COLUMN joomla_menu.title; Type: COMMENT; Schema: public; Owner: joomla_user
--

COMMENT ON COLUMN public.joomla_menu.title IS 'The display title of the menu item.';


--
-- Name: COLUMN joomla_menu.alias; Type: COMMENT; Schema: public; Owner: joomla_user
--

COMMENT ON COLUMN public.joomla_menu.alias IS 'The SEF alias of the menu item.';


--
-- Name: COLUMN joomla_menu.path; Type: COMMENT; Schema: public; Owner: joomla_user
--

COMMENT ON COLUMN public.joomla_menu.path IS 'The computed path of the menu item based on the alias field.';


--
-- Name: COLUMN joomla_menu.link; Type: COMMENT; Schema: public; Owner: joomla_user
--

COMMENT ON COLUMN public.joomla_menu.link IS 'The actually link the menu item refers to.';


--
-- Name: COLUMN joomla_menu.type; Type: COMMENT; Schema: public; Owner: joomla_user
--

COMMENT ON COLUMN public.joomla_menu.type IS 'The type of link: Component, URL, Alias, Separator';


--
-- Name: COLUMN joomla_menu.published; Type: COMMENT; Schema: public; Owner: joomla_user
--

COMMENT ON COLUMN public.joomla_menu.published IS 'The published state of the menu link.';


--
-- Name: COLUMN joomla_menu.parent_id; Type: COMMENT; Schema: public; Owner: joomla_user
--

COMMENT ON COLUMN public.joomla_menu.parent_id IS 'The parent menu item in the menu tree.';


--
-- Name: COLUMN joomla_menu.level; Type: COMMENT; Schema: public; Owner: joomla_user
--

COMMENT ON COLUMN public.joomla_menu.level IS 'The relative level in the tree.';


--
-- Name: COLUMN joomla_menu.component_id; Type: COMMENT; Schema: public; Owner: joomla_user
--

COMMENT ON COLUMN public.joomla_menu.component_id IS 'FK to #__extensions.id';


--
-- Name: COLUMN joomla_menu.checked_out; Type: COMMENT; Schema: public; Owner: joomla_user
--

COMMENT ON COLUMN public.joomla_menu.checked_out IS 'FK to #__users.id';


--
-- Name: COLUMN joomla_menu.checked_out_time; Type: COMMENT; Schema: public; Owner: joomla_user
--

COMMENT ON COLUMN public.joomla_menu.checked_out_time IS 'The time the menu item was checked out.';


--
-- Name: COLUMN joomla_menu."browserNav"; Type: COMMENT; Schema: public; Owner: joomla_user
--

COMMENT ON COLUMN public.joomla_menu."browserNav" IS 'The click behaviour of the link.';


--
-- Name: COLUMN joomla_menu.access; Type: COMMENT; Schema: public; Owner: joomla_user
--

COMMENT ON COLUMN public.joomla_menu.access IS 'The access level required to view the menu item.';


--
-- Name: COLUMN joomla_menu.img; Type: COMMENT; Schema: public; Owner: joomla_user
--

COMMENT ON COLUMN public.joomla_menu.img IS 'The image of the menu item.';


--
-- Name: COLUMN joomla_menu.params; Type: COMMENT; Schema: public; Owner: joomla_user
--

COMMENT ON COLUMN public.joomla_menu.params IS 'JSON encoded data for the menu item.';


--
-- Name: COLUMN joomla_menu.lft; Type: COMMENT; Schema: public; Owner: joomla_user
--

COMMENT ON COLUMN public.joomla_menu.lft IS 'Nested set lft.';


--
-- Name: COLUMN joomla_menu.rgt; Type: COMMENT; Schema: public; Owner: joomla_user
--

COMMENT ON COLUMN public.joomla_menu.rgt IS 'Nested set rgt.';


--
-- Name: COLUMN joomla_menu.home; Type: COMMENT; Schema: public; Owner: joomla_user
--

COMMENT ON COLUMN public.joomla_menu.home IS 'Indicates if this menu item is the home or default page.';


--
-- Name: joomla_menu_id_seq; Type: SEQUENCE; Schema: public; Owner: joomla_user
--

CREATE SEQUENCE public.joomla_menu_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.joomla_menu_id_seq OWNER TO joomla_user;

--
-- Name: joomla_menu_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: joomla_user
--

ALTER SEQUENCE public.joomla_menu_id_seq OWNED BY public.joomla_menu.id;


--
-- Name: joomla_menu_types; Type: TABLE; Schema: public; Owner: joomla_user
--

CREATE TABLE public.joomla_menu_types (
    id integer NOT NULL,
    asset_id bigint DEFAULT 0 NOT NULL,
    menutype character varying(24) NOT NULL,
    title character varying(48) NOT NULL,
    description character varying(255) DEFAULT ''::character varying NOT NULL,
    client_id integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.joomla_menu_types OWNER TO joomla_user;

--
-- Name: joomla_menu_types_id_seq; Type: SEQUENCE; Schema: public; Owner: joomla_user
--

CREATE SEQUENCE public.joomla_menu_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.joomla_menu_types_id_seq OWNER TO joomla_user;

--
-- Name: joomla_menu_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: joomla_user
--

ALTER SEQUENCE public.joomla_menu_types_id_seq OWNED BY public.joomla_menu_types.id;


--
-- Name: joomla_messages; Type: TABLE; Schema: public; Owner: joomla_user
--

CREATE TABLE public.joomla_messages (
    message_id integer NOT NULL,
    user_id_from bigint DEFAULT 0 NOT NULL,
    user_id_to bigint DEFAULT 0 NOT NULL,
    folder_id smallint DEFAULT 0 NOT NULL,
    date_time timestamp without time zone NOT NULL,
    state smallint DEFAULT 0 NOT NULL,
    priority smallint DEFAULT 0 NOT NULL,
    subject character varying(255) DEFAULT ''::character varying NOT NULL,
    message text NOT NULL
);


ALTER TABLE public.joomla_messages OWNER TO joomla_user;

--
-- Name: joomla_messages_cfg; Type: TABLE; Schema: public; Owner: joomla_user
--

CREATE TABLE public.joomla_messages_cfg (
    user_id bigint DEFAULT 0 NOT NULL,
    cfg_name character varying(100) DEFAULT ''::character varying NOT NULL,
    cfg_value character varying(255) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.joomla_messages_cfg OWNER TO joomla_user;

--
-- Name: joomla_messages_message_id_seq; Type: SEQUENCE; Schema: public; Owner: joomla_user
--

CREATE SEQUENCE public.joomla_messages_message_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.joomla_messages_message_id_seq OWNER TO joomla_user;

--
-- Name: joomla_messages_message_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: joomla_user
--

ALTER SEQUENCE public.joomla_messages_message_id_seq OWNED BY public.joomla_messages.message_id;


--
-- Name: joomla_modules; Type: TABLE; Schema: public; Owner: joomla_user
--

CREATE TABLE public.joomla_modules (
    id integer NOT NULL,
    asset_id bigint DEFAULT 0 NOT NULL,
    title character varying(100) DEFAULT ''::character varying NOT NULL,
    note character varying(255) DEFAULT ''::character varying NOT NULL,
    content text,
    ordering bigint DEFAULT 0 NOT NULL,
    "position" character varying(50) DEFAULT ''::character varying NOT NULL,
    checked_out integer,
    checked_out_time timestamp without time zone,
    publish_up timestamp without time zone,
    publish_down timestamp without time zone,
    published smallint DEFAULT 0 NOT NULL,
    module character varying(50) DEFAULT NULL::character varying,
    access bigint DEFAULT 0 NOT NULL,
    showtitle smallint DEFAULT 1 NOT NULL,
    params text NOT NULL,
    client_id smallint DEFAULT 0 NOT NULL,
    language character varying(7) NOT NULL
);


ALTER TABLE public.joomla_modules OWNER TO joomla_user;

--
-- Name: joomla_modules_id_seq; Type: SEQUENCE; Schema: public; Owner: joomla_user
--

CREATE SEQUENCE public.joomla_modules_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.joomla_modules_id_seq OWNER TO joomla_user;

--
-- Name: joomla_modules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: joomla_user
--

ALTER SEQUENCE public.joomla_modules_id_seq OWNED BY public.joomla_modules.id;


--
-- Name: joomla_modules_menu; Type: TABLE; Schema: public; Owner: joomla_user
--

CREATE TABLE public.joomla_modules_menu (
    moduleid bigint DEFAULT 0 NOT NULL,
    menuid bigint DEFAULT 0 NOT NULL
);


ALTER TABLE public.joomla_modules_menu OWNER TO joomla_user;

--
-- Name: joomla_newsfeeds; Type: TABLE; Schema: public; Owner: joomla_user
--

CREATE TABLE public.joomla_newsfeeds (
    catid bigint DEFAULT 0 NOT NULL,
    id integer NOT NULL,
    name character varying(100) DEFAULT ''::character varying NOT NULL,
    alias character varying(100) DEFAULT ''::character varying NOT NULL,
    link character varying(2048) DEFAULT ''::character varying NOT NULL,
    published smallint DEFAULT 0 NOT NULL,
    numarticles bigint DEFAULT 1 NOT NULL,
    cache_time bigint DEFAULT 3600 NOT NULL,
    checked_out integer,
    checked_out_time timestamp without time zone,
    ordering bigint DEFAULT 0 NOT NULL,
    rtl smallint DEFAULT 0 NOT NULL,
    access bigint DEFAULT 0 NOT NULL,
    language character varying(7) DEFAULT ''::character varying NOT NULL,
    params text NOT NULL,
    created timestamp without time zone NOT NULL,
    created_by integer DEFAULT 0 NOT NULL,
    created_by_alias character varying(255) DEFAULT ''::character varying NOT NULL,
    modified timestamp without time zone NOT NULL,
    modified_by integer DEFAULT 0 NOT NULL,
    metakey text,
    metadesc text NOT NULL,
    metadata text NOT NULL,
    publish_up timestamp without time zone,
    publish_down timestamp without time zone,
    description text NOT NULL,
    version bigint DEFAULT 1 NOT NULL,
    hits bigint DEFAULT 0 NOT NULL,
    images text NOT NULL
);


ALTER TABLE public.joomla_newsfeeds OWNER TO joomla_user;

--
-- Name: joomla_newsfeeds_id_seq; Type: SEQUENCE; Schema: public; Owner: joomla_user
--

CREATE SEQUENCE public.joomla_newsfeeds_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.joomla_newsfeeds_id_seq OWNER TO joomla_user;

--
-- Name: joomla_newsfeeds_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: joomla_user
--

ALTER SEQUENCE public.joomla_newsfeeds_id_seq OWNED BY public.joomla_newsfeeds.id;


--
-- Name: joomla_overrider; Type: TABLE; Schema: public; Owner: joomla_user
--

CREATE TABLE public.joomla_overrider (
    id integer NOT NULL,
    constant character varying(255) NOT NULL,
    string text NOT NULL,
    file character varying(255) NOT NULL
);


ALTER TABLE public.joomla_overrider OWNER TO joomla_user;

--
-- Name: COLUMN joomla_overrider.id; Type: COMMENT; Schema: public; Owner: joomla_user
--

COMMENT ON COLUMN public.joomla_overrider.id IS 'Primary Key';


--
-- Name: joomla_overrider_id_seq; Type: SEQUENCE; Schema: public; Owner: joomla_user
--

CREATE SEQUENCE public.joomla_overrider_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.joomla_overrider_id_seq OWNER TO joomla_user;

--
-- Name: joomla_overrider_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: joomla_user
--

ALTER SEQUENCE public.joomla_overrider_id_seq OWNED BY public.joomla_overrider.id;


--
-- Name: joomla_postinstall_messages; Type: TABLE; Schema: public; Owner: joomla_user
--

CREATE TABLE public.joomla_postinstall_messages (
    postinstall_message_id integer NOT NULL,
    extension_id bigint DEFAULT 700 NOT NULL,
    title_key character varying(255) DEFAULT ''::character varying NOT NULL,
    description_key character varying(255) DEFAULT ''::character varying NOT NULL,
    action_key character varying(255) DEFAULT ''::character varying NOT NULL,
    language_extension character varying(255) DEFAULT 'com_postinstall'::character varying NOT NULL,
    language_client_id smallint DEFAULT 1 NOT NULL,
    type character varying(10) DEFAULT 'link'::character varying NOT NULL,
    action_file character varying(255) DEFAULT ''::character varying,
    action character varying(255) DEFAULT ''::character varying,
    condition_file character varying(255) DEFAULT NULL::character varying,
    condition_method character varying(255) DEFAULT NULL::character varying,
    version_introduced character varying(255) DEFAULT '3.2.0'::character varying NOT NULL,
    enabled smallint DEFAULT 1 NOT NULL
);


ALTER TABLE public.joomla_postinstall_messages OWNER TO joomla_user;

--
-- Name: COLUMN joomla_postinstall_messages.extension_id; Type: COMMENT; Schema: public; Owner: joomla_user
--

COMMENT ON COLUMN public.joomla_postinstall_messages.extension_id IS 'FK to jos_extensions';


--
-- Name: COLUMN joomla_postinstall_messages.title_key; Type: COMMENT; Schema: public; Owner: joomla_user
--

COMMENT ON COLUMN public.joomla_postinstall_messages.title_key IS 'Lang key for the title';


--
-- Name: COLUMN joomla_postinstall_messages.description_key; Type: COMMENT; Schema: public; Owner: joomla_user
--

COMMENT ON COLUMN public.joomla_postinstall_messages.description_key IS 'Lang key for description';


--
-- Name: COLUMN joomla_postinstall_messages.language_extension; Type: COMMENT; Schema: public; Owner: joomla_user
--

COMMENT ON COLUMN public.joomla_postinstall_messages.language_extension IS 'Extension holding lang keys';


--
-- Name: COLUMN joomla_postinstall_messages.type; Type: COMMENT; Schema: public; Owner: joomla_user
--

COMMENT ON COLUMN public.joomla_postinstall_messages.type IS 'Message type - message, link, action';


--
-- Name: COLUMN joomla_postinstall_messages.action_file; Type: COMMENT; Schema: public; Owner: joomla_user
--

COMMENT ON COLUMN public.joomla_postinstall_messages.action_file IS 'RAD URI to the PHP file containing action method';


--
-- Name: COLUMN joomla_postinstall_messages.action; Type: COMMENT; Schema: public; Owner: joomla_user
--

COMMENT ON COLUMN public.joomla_postinstall_messages.action IS 'Action method name or URL';


--
-- Name: COLUMN joomla_postinstall_messages.condition_file; Type: COMMENT; Schema: public; Owner: joomla_user
--

COMMENT ON COLUMN public.joomla_postinstall_messages.condition_file IS 'RAD URI to file holding display condition method';


--
-- Name: COLUMN joomla_postinstall_messages.condition_method; Type: COMMENT; Schema: public; Owner: joomla_user
--

COMMENT ON COLUMN public.joomla_postinstall_messages.condition_method IS 'Display condition method, must return boolean';


--
-- Name: COLUMN joomla_postinstall_messages.version_introduced; Type: COMMENT; Schema: public; Owner: joomla_user
--

COMMENT ON COLUMN public.joomla_postinstall_messages.version_introduced IS 'Version when this message was introduced';


--
-- Name: joomla_postinstall_messages_postinstall_message_id_seq; Type: SEQUENCE; Schema: public; Owner: joomla_user
--

CREATE SEQUENCE public.joomla_postinstall_messages_postinstall_message_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.joomla_postinstall_messages_postinstall_message_id_seq OWNER TO joomla_user;

--
-- Name: joomla_postinstall_messages_postinstall_message_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: joomla_user
--

ALTER SEQUENCE public.joomla_postinstall_messages_postinstall_message_id_seq OWNED BY public.joomla_postinstall_messages.postinstall_message_id;


--
-- Name: joomla_privacy_consents; Type: TABLE; Schema: public; Owner: joomla_user
--

CREATE TABLE public.joomla_privacy_consents (
    id integer NOT NULL,
    user_id bigint DEFAULT 0 NOT NULL,
    state smallint DEFAULT 1 NOT NULL,
    created timestamp without time zone NOT NULL,
    subject character varying(255) DEFAULT ''::character varying NOT NULL,
    body text NOT NULL,
    remind smallint DEFAULT 0 NOT NULL,
    token character varying(100) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.joomla_privacy_consents OWNER TO joomla_user;

--
-- Name: joomla_privacy_consents_id_seq; Type: SEQUENCE; Schema: public; Owner: joomla_user
--

CREATE SEQUENCE public.joomla_privacy_consents_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.joomla_privacy_consents_id_seq OWNER TO joomla_user;

--
-- Name: joomla_privacy_consents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: joomla_user
--

ALTER SEQUENCE public.joomla_privacy_consents_id_seq OWNED BY public.joomla_privacy_consents.id;


--
-- Name: joomla_privacy_requests; Type: TABLE; Schema: public; Owner: joomla_user
--

CREATE TABLE public.joomla_privacy_requests (
    id integer NOT NULL,
    email character varying(100) DEFAULT ''::character varying NOT NULL,
    requested_at timestamp without time zone NOT NULL,
    status smallint DEFAULT 0 NOT NULL,
    request_type character varying(25) DEFAULT ''::character varying NOT NULL,
    confirm_token character varying(100) DEFAULT ''::character varying NOT NULL,
    confirm_token_created_at timestamp without time zone
);


ALTER TABLE public.joomla_privacy_requests OWNER TO joomla_user;

--
-- Name: joomla_privacy_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: joomla_user
--

CREATE SEQUENCE public.joomla_privacy_requests_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.joomla_privacy_requests_id_seq OWNER TO joomla_user;

--
-- Name: joomla_privacy_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: joomla_user
--

ALTER SEQUENCE public.joomla_privacy_requests_id_seq OWNED BY public.joomla_privacy_requests.id;


--
-- Name: joomla_redirect_links; Type: TABLE; Schema: public; Owner: joomla_user
--

CREATE TABLE public.joomla_redirect_links (
    id integer NOT NULL,
    old_url character varying(2048) NOT NULL,
    new_url character varying(2048),
    referer character varying(2048) NOT NULL,
    comment character varying(255) DEFAULT ''::character varying NOT NULL,
    hits bigint DEFAULT 0 NOT NULL,
    published smallint NOT NULL,
    created_date timestamp without time zone NOT NULL,
    modified_date timestamp without time zone NOT NULL,
    header integer DEFAULT 301 NOT NULL
);


ALTER TABLE public.joomla_redirect_links OWNER TO joomla_user;

--
-- Name: joomla_redirect_links_id_seq; Type: SEQUENCE; Schema: public; Owner: joomla_user
--

CREATE SEQUENCE public.joomla_redirect_links_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.joomla_redirect_links_id_seq OWNER TO joomla_user;

--
-- Name: joomla_redirect_links_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: joomla_user
--

ALTER SEQUENCE public.joomla_redirect_links_id_seq OWNED BY public.joomla_redirect_links.id;


--
-- Name: joomla_schemas; Type: TABLE; Schema: public; Owner: joomla_user
--

CREATE TABLE public.joomla_schemas (
    extension_id bigint NOT NULL,
    version_id character varying(20) NOT NULL
);


ALTER TABLE public.joomla_schemas OWNER TO joomla_user;

--
-- Name: joomla_session; Type: TABLE; Schema: public; Owner: joomla_user
--

CREATE TABLE public.joomla_session (
    session_id bytea NOT NULL,
    client_id smallint,
    guest smallint DEFAULT 1,
    "time" integer DEFAULT 0 NOT NULL,
    data text,
    userid bigint DEFAULT 0,
    username character varying(150) DEFAULT ''::character varying
);


ALTER TABLE public.joomla_session OWNER TO joomla_user;

--
-- Name: joomla_tags; Type: TABLE; Schema: public; Owner: joomla_user
--

CREATE TABLE public.joomla_tags (
    id integer NOT NULL,
    parent_id bigint DEFAULT 0 NOT NULL,
    lft bigint DEFAULT 0 NOT NULL,
    rgt bigint DEFAULT 0 NOT NULL,
    level integer DEFAULT 0 NOT NULL,
    path character varying(255) DEFAULT ''::character varying NOT NULL,
    title character varying(255) NOT NULL,
    alias character varying(255) DEFAULT ''::character varying NOT NULL,
    note character varying(255) DEFAULT ''::character varying NOT NULL,
    description text NOT NULL,
    published smallint DEFAULT 0 NOT NULL,
    checked_out integer,
    checked_out_time timestamp without time zone,
    access bigint DEFAULT 0 NOT NULL,
    params text NOT NULL,
    metadesc character varying(1024) NOT NULL,
    metakey character varying(1024) DEFAULT ''::character varying NOT NULL,
    metadata character varying(2048) NOT NULL,
    created_user_id integer DEFAULT 0 NOT NULL,
    created_time timestamp without time zone NOT NULL,
    created_by_alias character varying(255) DEFAULT ''::character varying NOT NULL,
    modified_user_id integer DEFAULT 0 NOT NULL,
    modified_time timestamp without time zone NOT NULL,
    images text NOT NULL,
    urls text NOT NULL,
    hits integer DEFAULT 0 NOT NULL,
    language character varying(7) DEFAULT ''::character varying NOT NULL,
    version bigint DEFAULT 1 NOT NULL,
    publish_up timestamp without time zone,
    publish_down timestamp without time zone
);


ALTER TABLE public.joomla_tags OWNER TO joomla_user;

--
-- Name: joomla_tags_id_seq; Type: SEQUENCE; Schema: public; Owner: joomla_user
--

CREATE SEQUENCE public.joomla_tags_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.joomla_tags_id_seq OWNER TO joomla_user;

--
-- Name: joomla_tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: joomla_user
--

ALTER SEQUENCE public.joomla_tags_id_seq OWNED BY public.joomla_tags.id;


--
-- Name: joomla_template_overrides; Type: TABLE; Schema: public; Owner: joomla_user
--

CREATE TABLE public.joomla_template_overrides (
    id integer NOT NULL,
    template character varying(50) DEFAULT ''::character varying NOT NULL,
    hash_id character varying(255) DEFAULT ''::character varying NOT NULL,
    extension_id bigint DEFAULT 0,
    state smallint DEFAULT 0 NOT NULL,
    action character varying(50) DEFAULT ''::character varying NOT NULL,
    client_id smallint DEFAULT 0 NOT NULL,
    created_date timestamp without time zone NOT NULL,
    modified_date timestamp without time zone
);


ALTER TABLE public.joomla_template_overrides OWNER TO joomla_user;

--
-- Name: joomla_template_overrides_id_seq; Type: SEQUENCE; Schema: public; Owner: joomla_user
--

CREATE SEQUENCE public.joomla_template_overrides_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.joomla_template_overrides_id_seq OWNER TO joomla_user;

--
-- Name: joomla_template_overrides_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: joomla_user
--

ALTER SEQUENCE public.joomla_template_overrides_id_seq OWNED BY public.joomla_template_overrides.id;


--
-- Name: joomla_template_styles; Type: TABLE; Schema: public; Owner: joomla_user
--

CREATE TABLE public.joomla_template_styles (
    id integer NOT NULL,
    template character varying(50) DEFAULT ''::character varying NOT NULL,
    client_id smallint DEFAULT 0 NOT NULL,
    home character varying(7) DEFAULT '0'::character varying NOT NULL,
    title character varying(255) DEFAULT ''::character varying NOT NULL,
    inheritable smallint DEFAULT 0 NOT NULL,
    parent character varying(50) DEFAULT ''::character varying,
    params text NOT NULL
);


ALTER TABLE public.joomla_template_styles OWNER TO joomla_user;

--
-- Name: joomla_template_styles_id_seq; Type: SEQUENCE; Schema: public; Owner: joomla_user
--

CREATE SEQUENCE public.joomla_template_styles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.joomla_template_styles_id_seq OWNER TO joomla_user;

--
-- Name: joomla_template_styles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: joomla_user
--

ALTER SEQUENCE public.joomla_template_styles_id_seq OWNED BY public.joomla_template_styles.id;


--
-- Name: joomla_ucm_base; Type: TABLE; Schema: public; Owner: joomla_user
--

CREATE TABLE public.joomla_ucm_base (
    ucm_id integer NOT NULL,
    ucm_item_id bigint NOT NULL,
    ucm_type_id bigint NOT NULL,
    ucm_language_id bigint NOT NULL
);


ALTER TABLE public.joomla_ucm_base OWNER TO joomla_user;

--
-- Name: joomla_ucm_base_ucm_id_seq; Type: SEQUENCE; Schema: public; Owner: joomla_user
--

CREATE SEQUENCE public.joomla_ucm_base_ucm_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.joomla_ucm_base_ucm_id_seq OWNER TO joomla_user;

--
-- Name: joomla_ucm_base_ucm_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: joomla_user
--

ALTER SEQUENCE public.joomla_ucm_base_ucm_id_seq OWNED BY public.joomla_ucm_base.ucm_id;


--
-- Name: joomla_ucm_content; Type: TABLE; Schema: public; Owner: joomla_user
--

CREATE TABLE public.joomla_ucm_content (
    core_content_id integer NOT NULL,
    core_type_alias character varying(255) DEFAULT ''::character varying NOT NULL,
    core_title character varying(255) DEFAULT ''::character varying NOT NULL,
    core_alias character varying(255) DEFAULT ''::character varying NOT NULL,
    core_body text,
    core_state smallint DEFAULT 0 NOT NULL,
    core_checked_out_time timestamp without time zone,
    core_checked_out_user_id integer,
    core_access bigint DEFAULT 0 NOT NULL,
    core_params text,
    core_featured smallint DEFAULT 0 NOT NULL,
    core_metadata text,
    core_created_user_id bigint DEFAULT 0 NOT NULL,
    core_created_by_alias character varying(255) DEFAULT ''::character varying NOT NULL,
    core_created_time timestamp without time zone NOT NULL,
    core_modified_user_id bigint DEFAULT 0 NOT NULL,
    core_modified_time timestamp without time zone NOT NULL,
    core_language character varying(7) DEFAULT ''::character varying NOT NULL,
    core_publish_up timestamp without time zone,
    core_publish_down timestamp without time zone,
    core_content_item_id bigint DEFAULT 0 NOT NULL,
    asset_id bigint DEFAULT 0 NOT NULL,
    core_images text,
    core_urls text,
    core_hits bigint DEFAULT 0 NOT NULL,
    core_version bigint DEFAULT 1 NOT NULL,
    core_ordering bigint DEFAULT 0 NOT NULL,
    core_metakey text,
    core_metadesc text,
    core_catid bigint DEFAULT 0 NOT NULL,
    core_type_id bigint DEFAULT 0 NOT NULL
);


ALTER TABLE public.joomla_ucm_content OWNER TO joomla_user;

--
-- Name: joomla_ucm_content_core_content_id_seq; Type: SEQUENCE; Schema: public; Owner: joomla_user
--

CREATE SEQUENCE public.joomla_ucm_content_core_content_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.joomla_ucm_content_core_content_id_seq OWNER TO joomla_user;

--
-- Name: joomla_ucm_content_core_content_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: joomla_user
--

ALTER SEQUENCE public.joomla_ucm_content_core_content_id_seq OWNED BY public.joomla_ucm_content.core_content_id;


--
-- Name: joomla_update_sites; Type: TABLE; Schema: public; Owner: joomla_user
--

CREATE TABLE public.joomla_update_sites (
    update_site_id integer NOT NULL,
    name character varying(100) DEFAULT ''::character varying,
    type character varying(20) DEFAULT ''::character varying,
    location text NOT NULL,
    enabled bigint DEFAULT 0,
    last_check_timestamp bigint DEFAULT 0,
    extra_query character varying(1000) DEFAULT ''::character varying,
    checked_out integer,
    checked_out_time timestamp without time zone
);


ALTER TABLE public.joomla_update_sites OWNER TO joomla_user;

--
-- Name: TABLE joomla_update_sites; Type: COMMENT; Schema: public; Owner: joomla_user
--

COMMENT ON TABLE public.joomla_update_sites IS 'Update Sites';


--
-- Name: joomla_update_sites_extensions; Type: TABLE; Schema: public; Owner: joomla_user
--

CREATE TABLE public.joomla_update_sites_extensions (
    update_site_id bigint DEFAULT 0 NOT NULL,
    extension_id bigint DEFAULT 0 NOT NULL
);


ALTER TABLE public.joomla_update_sites_extensions OWNER TO joomla_user;

--
-- Name: TABLE joomla_update_sites_extensions; Type: COMMENT; Schema: public; Owner: joomla_user
--

COMMENT ON TABLE public.joomla_update_sites_extensions IS 'Links extensions to update sites';


--
-- Name: joomla_update_sites_update_site_id_seq; Type: SEQUENCE; Schema: public; Owner: joomla_user
--

CREATE SEQUENCE public.joomla_update_sites_update_site_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.joomla_update_sites_update_site_id_seq OWNER TO joomla_user;

--
-- Name: joomla_update_sites_update_site_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: joomla_user
--

ALTER SEQUENCE public.joomla_update_sites_update_site_id_seq OWNED BY public.joomla_update_sites.update_site_id;


--
-- Name: joomla_updates; Type: TABLE; Schema: public; Owner: joomla_user
--

CREATE TABLE public.joomla_updates (
    update_id integer NOT NULL,
    update_site_id bigint DEFAULT 0,
    extension_id bigint DEFAULT 0,
    name character varying(100) DEFAULT ''::character varying,
    description text NOT NULL,
    element character varying(100) DEFAULT ''::character varying,
    type character varying(20) DEFAULT ''::character varying,
    folder character varying(20) DEFAULT ''::character varying,
    client_id smallint DEFAULT 0,
    version character varying(32) DEFAULT ''::character varying,
    data text NOT NULL,
    detailsurl text NOT NULL,
    infourl text NOT NULL,
    changelogurl text,
    extra_query character varying(1000) DEFAULT ''::character varying
);


ALTER TABLE public.joomla_updates OWNER TO joomla_user;

--
-- Name: TABLE joomla_updates; Type: COMMENT; Schema: public; Owner: joomla_user
--

COMMENT ON TABLE public.joomla_updates IS 'Available Updates';


--
-- Name: joomla_updates_update_id_seq; Type: SEQUENCE; Schema: public; Owner: joomla_user
--

CREATE SEQUENCE public.joomla_updates_update_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.joomla_updates_update_id_seq OWNER TO joomla_user;

--
-- Name: joomla_updates_update_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: joomla_user
--

ALTER SEQUENCE public.joomla_updates_update_id_seq OWNED BY public.joomla_updates.update_id;


--
-- Name: joomla_user_keys; Type: TABLE; Schema: public; Owner: joomla_user
--

CREATE TABLE public.joomla_user_keys (
    id integer NOT NULL,
    user_id character varying(255) NOT NULL,
    token character varying(255) NOT NULL,
    series character varying(255) NOT NULL,
    "time" character varying(200) NOT NULL,
    uastring character varying(255) NOT NULL
);


ALTER TABLE public.joomla_user_keys OWNER TO joomla_user;

--
-- Name: joomla_user_keys_id_seq; Type: SEQUENCE; Schema: public; Owner: joomla_user
--

CREATE SEQUENCE public.joomla_user_keys_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.joomla_user_keys_id_seq OWNER TO joomla_user;

--
-- Name: joomla_user_keys_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: joomla_user
--

ALTER SEQUENCE public.joomla_user_keys_id_seq OWNED BY public.joomla_user_keys.id;


--
-- Name: joomla_user_notes; Type: TABLE; Schema: public; Owner: joomla_user
--

CREATE TABLE public.joomla_user_notes (
    id integer NOT NULL,
    user_id integer DEFAULT 0 NOT NULL,
    catid integer DEFAULT 0 NOT NULL,
    subject character varying(100) DEFAULT ''::character varying NOT NULL,
    body text NOT NULL,
    state smallint DEFAULT 0 NOT NULL,
    checked_out integer,
    checked_out_time timestamp without time zone,
    created_user_id integer DEFAULT 0 NOT NULL,
    created_time timestamp without time zone NOT NULL,
    modified_user_id integer DEFAULT 0 NOT NULL,
    modified_time timestamp without time zone NOT NULL,
    review_time timestamp without time zone,
    publish_up timestamp without time zone,
    publish_down timestamp without time zone
);


ALTER TABLE public.joomla_user_notes OWNER TO joomla_user;

--
-- Name: joomla_user_notes_id_seq; Type: SEQUENCE; Schema: public; Owner: joomla_user
--

CREATE SEQUENCE public.joomla_user_notes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.joomla_user_notes_id_seq OWNER TO joomla_user;

--
-- Name: joomla_user_notes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: joomla_user
--

ALTER SEQUENCE public.joomla_user_notes_id_seq OWNED BY public.joomla_user_notes.id;


--
-- Name: joomla_user_profiles; Type: TABLE; Schema: public; Owner: joomla_user
--

CREATE TABLE public.joomla_user_profiles (
    user_id bigint NOT NULL,
    profile_key character varying(100) NOT NULL,
    profile_value text NOT NULL,
    ordering bigint DEFAULT 0 NOT NULL
);


ALTER TABLE public.joomla_user_profiles OWNER TO joomla_user;

--
-- Name: TABLE joomla_user_profiles; Type: COMMENT; Schema: public; Owner: joomla_user
--

COMMENT ON TABLE public.joomla_user_profiles IS 'Simple user profile storage table';


--
-- Name: joomla_user_usergroup_map; Type: TABLE; Schema: public; Owner: joomla_user
--

CREATE TABLE public.joomla_user_usergroup_map (
    user_id bigint DEFAULT 0 NOT NULL,
    group_id bigint DEFAULT 0 NOT NULL
);


ALTER TABLE public.joomla_user_usergroup_map OWNER TO joomla_user;

--
-- Name: COLUMN joomla_user_usergroup_map.user_id; Type: COMMENT; Schema: public; Owner: joomla_user
--

COMMENT ON COLUMN public.joomla_user_usergroup_map.user_id IS 'Foreign Key to #__users.id';


--
-- Name: COLUMN joomla_user_usergroup_map.group_id; Type: COMMENT; Schema: public; Owner: joomla_user
--

COMMENT ON COLUMN public.joomla_user_usergroup_map.group_id IS 'Foreign Key to #__usergroups.id';


--
-- Name: joomla_usergroups; Type: TABLE; Schema: public; Owner: joomla_user
--

CREATE TABLE public.joomla_usergroups (
    id integer NOT NULL,
    parent_id bigint DEFAULT 0 NOT NULL,
    lft bigint DEFAULT 0 NOT NULL,
    rgt bigint DEFAULT 0 NOT NULL,
    title character varying(100) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.joomla_usergroups OWNER TO joomla_user;

--
-- Name: COLUMN joomla_usergroups.id; Type: COMMENT; Schema: public; Owner: joomla_user
--

COMMENT ON COLUMN public.joomla_usergroups.id IS 'Primary Key';


--
-- Name: COLUMN joomla_usergroups.parent_id; Type: COMMENT; Schema: public; Owner: joomla_user
--

COMMENT ON COLUMN public.joomla_usergroups.parent_id IS 'Adjacency List Reference Id';


--
-- Name: COLUMN joomla_usergroups.lft; Type: COMMENT; Schema: public; Owner: joomla_user
--

COMMENT ON COLUMN public.joomla_usergroups.lft IS 'Nested set lft.';


--
-- Name: COLUMN joomla_usergroups.rgt; Type: COMMENT; Schema: public; Owner: joomla_user
--

COMMENT ON COLUMN public.joomla_usergroups.rgt IS 'Nested set rgt.';


--
-- Name: joomla_usergroups_id_seq; Type: SEQUENCE; Schema: public; Owner: joomla_user
--

CREATE SEQUENCE public.joomla_usergroups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.joomla_usergroups_id_seq OWNER TO joomla_user;

--
-- Name: joomla_usergroups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: joomla_user
--

ALTER SEQUENCE public.joomla_usergroups_id_seq OWNED BY public.joomla_usergroups.id;


--
-- Name: joomla_users; Type: TABLE; Schema: public; Owner: joomla_user
--

CREATE TABLE public.joomla_users (
    id integer NOT NULL,
    name character varying(255) DEFAULT ''::character varying NOT NULL,
    username character varying(150) DEFAULT ''::character varying NOT NULL,
    email character varying(100) DEFAULT ''::character varying NOT NULL,
    password character varying(100) DEFAULT ''::character varying NOT NULL,
    block smallint DEFAULT 0 NOT NULL,
    "sendEmail" smallint DEFAULT 0,
    "registerDate" timestamp without time zone NOT NULL,
    "lastvisitDate" timestamp without time zone,
    activation character varying(100) DEFAULT ''::character varying NOT NULL,
    params text NOT NULL,
    "lastResetTime" timestamp without time zone,
    "resetCount" bigint DEFAULT 0 NOT NULL,
    "otpKey" character varying(1000) DEFAULT ''::character varying NOT NULL,
    otep character varying(1000) DEFAULT ''::character varying NOT NULL,
    "requireReset" smallint DEFAULT 0
);


ALTER TABLE public.joomla_users OWNER TO joomla_user;

--
-- Name: COLUMN joomla_users."lastResetTime"; Type: COMMENT; Schema: public; Owner: joomla_user
--

COMMENT ON COLUMN public.joomla_users."lastResetTime" IS 'Date of last password reset';


--
-- Name: COLUMN joomla_users."resetCount"; Type: COMMENT; Schema: public; Owner: joomla_user
--

COMMENT ON COLUMN public.joomla_users."resetCount" IS 'Count of password resets since lastResetTime';


--
-- Name: COLUMN joomla_users."requireReset"; Type: COMMENT; Schema: public; Owner: joomla_user
--

COMMENT ON COLUMN public.joomla_users."requireReset" IS 'Require user to reset password on next login';


--
-- Name: joomla_users_id_seq; Type: SEQUENCE; Schema: public; Owner: joomla_user
--

CREATE SEQUENCE public.joomla_users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.joomla_users_id_seq OWNER TO joomla_user;

--
-- Name: joomla_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: joomla_user
--

ALTER SEQUENCE public.joomla_users_id_seq OWNED BY public.joomla_users.id;


--
-- Name: joomla_viewlevels; Type: TABLE; Schema: public; Owner: joomla_user
--

CREATE TABLE public.joomla_viewlevels (
    id integer NOT NULL,
    title character varying(100) DEFAULT ''::character varying NOT NULL,
    ordering bigint DEFAULT 0 NOT NULL,
    rules character varying(5120) NOT NULL
);


ALTER TABLE public.joomla_viewlevels OWNER TO joomla_user;

--
-- Name: COLUMN joomla_viewlevels.id; Type: COMMENT; Schema: public; Owner: joomla_user
--

COMMENT ON COLUMN public.joomla_viewlevels.id IS 'Primary Key';


--
-- Name: COLUMN joomla_viewlevels.rules; Type: COMMENT; Schema: public; Owner: joomla_user
--

COMMENT ON COLUMN public.joomla_viewlevels.rules IS 'JSON encoded access control.';


--
-- Name: joomla_viewlevels_id_seq; Type: SEQUENCE; Schema: public; Owner: joomla_user
--

CREATE SEQUENCE public.joomla_viewlevels_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.joomla_viewlevels_id_seq OWNER TO joomla_user;

--
-- Name: joomla_viewlevels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: joomla_user
--

ALTER SEQUENCE public.joomla_viewlevels_id_seq OWNED BY public.joomla_viewlevels.id;


--
-- Name: joomla_webauthn_credentials; Type: TABLE; Schema: public; Owner: joomla_user
--

CREATE TABLE public.joomla_webauthn_credentials (
    id character varying(1000) NOT NULL,
    user_id character varying(128) NOT NULL,
    label character varying(190) NOT NULL,
    credential text NOT NULL
);


ALTER TABLE public.joomla_webauthn_credentials OWNER TO joomla_user;

--
-- Name: joomla_workflow_associations; Type: TABLE; Schema: public; Owner: joomla_user
--

CREATE TABLE public.joomla_workflow_associations (
    item_id bigint DEFAULT 0 NOT NULL,
    stage_id bigint DEFAULT 0 NOT NULL,
    extension character varying(50) NOT NULL
);


ALTER TABLE public.joomla_workflow_associations OWNER TO joomla_user;

--
-- Name: COLUMN joomla_workflow_associations.item_id; Type: COMMENT; Schema: public; Owner: joomla_user
--

COMMENT ON COLUMN public.joomla_workflow_associations.item_id IS 'Extension table id value';


--
-- Name: COLUMN joomla_workflow_associations.stage_id; Type: COMMENT; Schema: public; Owner: joomla_user
--

COMMENT ON COLUMN public.joomla_workflow_associations.stage_id IS 'Foreign Key to #__workflow_stages.id';


--
-- Name: joomla_workflow_stages; Type: TABLE; Schema: public; Owner: joomla_user
--

CREATE TABLE public.joomla_workflow_stages (
    id integer NOT NULL,
    asset_id bigint DEFAULT 0 NOT NULL,
    ordering bigint DEFAULT 0 NOT NULL,
    workflow_id bigint DEFAULT 0 NOT NULL,
    published smallint DEFAULT 0 NOT NULL,
    title character varying(255) NOT NULL,
    description text NOT NULL,
    "default" smallint DEFAULT 0 NOT NULL,
    checked_out_time timestamp without time zone,
    checked_out integer
);


ALTER TABLE public.joomla_workflow_stages OWNER TO joomla_user;

--
-- Name: joomla_workflow_stages_id_seq; Type: SEQUENCE; Schema: public; Owner: joomla_user
--

CREATE SEQUENCE public.joomla_workflow_stages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.joomla_workflow_stages_id_seq OWNER TO joomla_user;

--
-- Name: joomla_workflow_stages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: joomla_user
--

ALTER SEQUENCE public.joomla_workflow_stages_id_seq OWNED BY public.joomla_workflow_stages.id;


--
-- Name: joomla_workflow_transitions; Type: TABLE; Schema: public; Owner: joomla_user
--

CREATE TABLE public.joomla_workflow_transitions (
    id integer NOT NULL,
    asset_id bigint DEFAULT 0 NOT NULL,
    ordering bigint DEFAULT 0 NOT NULL,
    workflow_id bigint DEFAULT 0 NOT NULL,
    published smallint DEFAULT 0 NOT NULL,
    title character varying(255) NOT NULL,
    description text NOT NULL,
    from_stage_id bigint DEFAULT 0 NOT NULL,
    to_stage_id bigint DEFAULT 0 NOT NULL,
    options text NOT NULL,
    checked_out_time timestamp without time zone,
    checked_out integer
);


ALTER TABLE public.joomla_workflow_transitions OWNER TO joomla_user;

--
-- Name: joomla_workflow_transitions_id_seq; Type: SEQUENCE; Schema: public; Owner: joomla_user
--

CREATE SEQUENCE public.joomla_workflow_transitions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.joomla_workflow_transitions_id_seq OWNER TO joomla_user;

--
-- Name: joomla_workflow_transitions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: joomla_user
--

ALTER SEQUENCE public.joomla_workflow_transitions_id_seq OWNED BY public.joomla_workflow_transitions.id;


--
-- Name: joomla_workflows; Type: TABLE; Schema: public; Owner: joomla_user
--

CREATE TABLE public.joomla_workflows (
    id integer NOT NULL,
    asset_id bigint DEFAULT 0 NOT NULL,
    published smallint DEFAULT 0 NOT NULL,
    title character varying(255) DEFAULT ''::character varying NOT NULL,
    description text NOT NULL,
    extension character varying(50) NOT NULL,
    "default" smallint DEFAULT 0 NOT NULL,
    ordering bigint DEFAULT 0 NOT NULL,
    created timestamp without time zone NOT NULL,
    created_by bigint DEFAULT 0 NOT NULL,
    modified timestamp without time zone NOT NULL,
    modified_by bigint DEFAULT 0 NOT NULL,
    checked_out_time timestamp without time zone,
    checked_out integer
);


ALTER TABLE public.joomla_workflows OWNER TO joomla_user;

--
-- Name: joomla_workflows_id_seq; Type: SEQUENCE; Schema: public; Owner: joomla_user
--

CREATE SEQUENCE public.joomla_workflows_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.joomla_workflows_id_seq OWNER TO joomla_user;

--
-- Name: joomla_workflows_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: joomla_user
--

ALTER SEQUENCE public.joomla_workflows_id_seq OWNED BY public.joomla_workflows.id;


--
-- Name: joomla_action_log_config id; Type: DEFAULT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_action_log_config ALTER COLUMN id SET DEFAULT nextval('public.joomla_action_log_config_id_seq'::regclass);


--
-- Name: joomla_action_logs id; Type: DEFAULT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_action_logs ALTER COLUMN id SET DEFAULT nextval('public.joomla_action_logs_id_seq'::regclass);


--
-- Name: joomla_action_logs_extensions id; Type: DEFAULT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_action_logs_extensions ALTER COLUMN id SET DEFAULT nextval('public.joomla_action_logs_extensions_id_seq'::regclass);


--
-- Name: joomla_assets id; Type: DEFAULT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_assets ALTER COLUMN id SET DEFAULT nextval('public.joomla_assets_id_seq'::regclass);


--
-- Name: joomla_banner_clients id; Type: DEFAULT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_banner_clients ALTER COLUMN id SET DEFAULT nextval('public.joomla_banner_clients_id_seq'::regclass);


--
-- Name: joomla_banners id; Type: DEFAULT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_banners ALTER COLUMN id SET DEFAULT nextval('public.joomla_banners_id_seq'::regclass);


--
-- Name: joomla_categories id; Type: DEFAULT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_categories ALTER COLUMN id SET DEFAULT nextval('public.joomla_categories_id_seq'::regclass);


--
-- Name: joomla_contact_details id; Type: DEFAULT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_contact_details ALTER COLUMN id SET DEFAULT nextval('public.joomla_contact_details_id_seq'::regclass);


--
-- Name: joomla_content id; Type: DEFAULT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_content ALTER COLUMN id SET DEFAULT nextval('public.joomla_content_id_seq'::regclass);


--
-- Name: joomla_content_types type_id; Type: DEFAULT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_content_types ALTER COLUMN type_id SET DEFAULT nextval('public.joomla_content_types_type_id_seq'::regclass);


--
-- Name: joomla_extensions extension_id; Type: DEFAULT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_extensions ALTER COLUMN extension_id SET DEFAULT nextval('public.joomla_extensions_extension_id_seq'::regclass);


--
-- Name: joomla_fields id; Type: DEFAULT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_fields ALTER COLUMN id SET DEFAULT nextval('public.joomla_fields_id_seq'::regclass);


--
-- Name: joomla_fields_groups id; Type: DEFAULT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_fields_groups ALTER COLUMN id SET DEFAULT nextval('public.joomla_fields_groups_id_seq'::regclass);


--
-- Name: joomla_finder_filters filter_id; Type: DEFAULT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_finder_filters ALTER COLUMN filter_id SET DEFAULT nextval('public.joomla_finder_filters_filter_id_seq'::regclass);


--
-- Name: joomla_finder_links link_id; Type: DEFAULT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_finder_links ALTER COLUMN link_id SET DEFAULT nextval('public.joomla_finder_links_link_id_seq'::regclass);


--
-- Name: joomla_finder_taxonomy id; Type: DEFAULT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_finder_taxonomy ALTER COLUMN id SET DEFAULT nextval('public.joomla_finder_taxonomy_id_seq'::regclass);


--
-- Name: joomla_finder_terms term_id; Type: DEFAULT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_finder_terms ALTER COLUMN term_id SET DEFAULT nextval('public.joomla_finder_terms_term_id_seq'::regclass);


--
-- Name: joomla_finder_types id; Type: DEFAULT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_finder_types ALTER COLUMN id SET DEFAULT nextval('public.joomla_finder_types_id_seq'::regclass);


--
-- Name: joomla_history version_id; Type: DEFAULT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_history ALTER COLUMN version_id SET DEFAULT nextval('public.joomla_history_version_id_seq'::regclass);


--
-- Name: joomla_languages lang_id; Type: DEFAULT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_languages ALTER COLUMN lang_id SET DEFAULT nextval('public.joomla_languages_lang_id_seq'::regclass);


--
-- Name: joomla_menu id; Type: DEFAULT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_menu ALTER COLUMN id SET DEFAULT nextval('public.joomla_menu_id_seq'::regclass);


--
-- Name: joomla_menu_types id; Type: DEFAULT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_menu_types ALTER COLUMN id SET DEFAULT nextval('public.joomla_menu_types_id_seq'::regclass);


--
-- Name: joomla_messages message_id; Type: DEFAULT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_messages ALTER COLUMN message_id SET DEFAULT nextval('public.joomla_messages_message_id_seq'::regclass);


--
-- Name: joomla_modules id; Type: DEFAULT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_modules ALTER COLUMN id SET DEFAULT nextval('public.joomla_modules_id_seq'::regclass);


--
-- Name: joomla_newsfeeds id; Type: DEFAULT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_newsfeeds ALTER COLUMN id SET DEFAULT nextval('public.joomla_newsfeeds_id_seq'::regclass);


--
-- Name: joomla_overrider id; Type: DEFAULT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_overrider ALTER COLUMN id SET DEFAULT nextval('public.joomla_overrider_id_seq'::regclass);


--
-- Name: joomla_postinstall_messages postinstall_message_id; Type: DEFAULT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_postinstall_messages ALTER COLUMN postinstall_message_id SET DEFAULT nextval('public.joomla_postinstall_messages_postinstall_message_id_seq'::regclass);


--
-- Name: joomla_privacy_consents id; Type: DEFAULT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_privacy_consents ALTER COLUMN id SET DEFAULT nextval('public.joomla_privacy_consents_id_seq'::regclass);


--
-- Name: joomla_privacy_requests id; Type: DEFAULT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_privacy_requests ALTER COLUMN id SET DEFAULT nextval('public.joomla_privacy_requests_id_seq'::regclass);


--
-- Name: joomla_redirect_links id; Type: DEFAULT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_redirect_links ALTER COLUMN id SET DEFAULT nextval('public.joomla_redirect_links_id_seq'::regclass);


--
-- Name: joomla_tags id; Type: DEFAULT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_tags ALTER COLUMN id SET DEFAULT nextval('public.joomla_tags_id_seq'::regclass);


--
-- Name: joomla_template_overrides id; Type: DEFAULT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_template_overrides ALTER COLUMN id SET DEFAULT nextval('public.joomla_template_overrides_id_seq'::regclass);


--
-- Name: joomla_template_styles id; Type: DEFAULT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_template_styles ALTER COLUMN id SET DEFAULT nextval('public.joomla_template_styles_id_seq'::regclass);


--
-- Name: joomla_ucm_base ucm_id; Type: DEFAULT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_ucm_base ALTER COLUMN ucm_id SET DEFAULT nextval('public.joomla_ucm_base_ucm_id_seq'::regclass);


--
-- Name: joomla_ucm_content core_content_id; Type: DEFAULT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_ucm_content ALTER COLUMN core_content_id SET DEFAULT nextval('public.joomla_ucm_content_core_content_id_seq'::regclass);


--
-- Name: joomla_update_sites update_site_id; Type: DEFAULT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_update_sites ALTER COLUMN update_site_id SET DEFAULT nextval('public.joomla_update_sites_update_site_id_seq'::regclass);


--
-- Name: joomla_updates update_id; Type: DEFAULT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_updates ALTER COLUMN update_id SET DEFAULT nextval('public.joomla_updates_update_id_seq'::regclass);


--
-- Name: joomla_user_keys id; Type: DEFAULT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_user_keys ALTER COLUMN id SET DEFAULT nextval('public.joomla_user_keys_id_seq'::regclass);


--
-- Name: joomla_user_notes id; Type: DEFAULT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_user_notes ALTER COLUMN id SET DEFAULT nextval('public.joomla_user_notes_id_seq'::regclass);


--
-- Name: joomla_usergroups id; Type: DEFAULT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_usergroups ALTER COLUMN id SET DEFAULT nextval('public.joomla_usergroups_id_seq'::regclass);


--
-- Name: joomla_users id; Type: DEFAULT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_users ALTER COLUMN id SET DEFAULT nextval('public.joomla_users_id_seq'::regclass);


--
-- Name: joomla_viewlevels id; Type: DEFAULT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_viewlevels ALTER COLUMN id SET DEFAULT nextval('public.joomla_viewlevels_id_seq'::regclass);


--
-- Name: joomla_workflow_stages id; Type: DEFAULT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_workflow_stages ALTER COLUMN id SET DEFAULT nextval('public.joomla_workflow_stages_id_seq'::regclass);


--
-- Name: joomla_workflow_transitions id; Type: DEFAULT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_workflow_transitions ALTER COLUMN id SET DEFAULT nextval('public.joomla_workflow_transitions_id_seq'::regclass);


--
-- Name: joomla_workflows id; Type: DEFAULT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_workflows ALTER COLUMN id SET DEFAULT nextval('public.joomla_workflows_id_seq'::regclass);


--
-- Data for Name: joomla_action_log_config; Type: TABLE DATA; Schema: public; Owner: joomla_user
--

COPY public.joomla_action_log_config (id, type_title, type_alias, id_holder, title_holder, table_name, text_prefix) FROM stdin;
1	article	com_content.article	id	title	#__content	PLG_ACTIONLOG_JOOMLA
2	article	com_content.form	id	title	#__content	PLG_ACTIONLOG_JOOMLA
3	banner	com_banners.banner	id	name	#__banners	PLG_ACTIONLOG_JOOMLA
4	user_note	com_users.note	id	subject	#__user_notes	PLG_ACTIONLOG_JOOMLA
5	media	com_media.file		name		PLG_ACTIONLOG_JOOMLA
6	category	com_categories.category	id	title	#__categories	PLG_ACTIONLOG_JOOMLA
7	menu	com_menus.menu	id	title	#__menu_types	PLG_ACTIONLOG_JOOMLA
8	menu_item	com_menus.item	id	title	#__menu	PLG_ACTIONLOG_JOOMLA
9	newsfeed	com_newsfeeds.newsfeed	id	name	#__newsfeeds	PLG_ACTIONLOG_JOOMLA
10	link	com_redirect.link	id	old_url	#__redirect_links	PLG_ACTIONLOG_JOOMLA
11	tag	com_tags.tag	id	title	#__tags	PLG_ACTIONLOG_JOOMLA
12	style	com_templates.style	id	title	#__template_styles	PLG_ACTIONLOG_JOOMLA
13	plugin	com_plugins.plugin	extension_id	name	#__extensions	PLG_ACTIONLOG_JOOMLA
14	component_config	com_config.component	extension_id	name		PLG_ACTIONLOG_JOOMLA
15	contact	com_contact.contact	id	name	#__contact_details	PLG_ACTIONLOG_JOOMLA
16	module	com_modules.module	id	title	#__modules	PLG_ACTIONLOG_JOOMLA
17	access_level	com_users.level	id	title	#__viewlevels	PLG_ACTIONLOG_JOOMLA
18	banner_client	com_banners.client	id	name	#__banner_clients	PLG_ACTIONLOG_JOOMLA
19	application_config	com_config.application		name		PLG_ACTIONLOG_JOOMLA
\.


--
-- Data for Name: joomla_action_logs; Type: TABLE DATA; Schema: public; Owner: joomla_user
--

COPY public.joomla_action_logs (id, message_language_key, message, log_date, extension, user_id, item_id, ip_address) FROM stdin;
1	PLG_ACTIONLOG_JOOMLA_USER_LOGGED_IN	{"action":"login","userid":605,"username":"otus","accountlink":"index.php?option=com_users&task=user.edit&id=605","app":"PLG_ACTIONLOG_JOOMLA_APPLICATION_ADMINISTRATOR"}	2021-10-02 16:08:44	com_users	605	0	COM_ACTIONLOGS_DISABLED
2	PLG_ACTIONLOG_JOOMLA_APPLICATION_CONFIG_UPDATED	{"action":"update","type":"PLG_ACTIONLOG_JOOMLA_TYPE_APPLICATION_CONFIG","extension_name":"com_config.application","itemlink":"index.php?option=com_config","userid":605,"username":"otus","accountlink":"index.php?option=com_users&task=user.edit&id=605"}	2021-10-02 16:11:33	com_config.application	605	0	COM_ACTIONLOGS_DISABLED
3	PLG_ACTIONLOG_JOOMLA_APPLICATION_CONFIG_UPDATED	{"action":"update","type":"PLG_ACTIONLOG_JOOMLA_TYPE_APPLICATION_CONFIG","extension_name":"com_config.application","itemlink":"index.php?option=com_config","userid":605,"username":"otus","accountlink":"index.php?option=com_users&task=user.edit&id=605"}	2021-10-02 16:13:50	com_config.application	605	0	COM_ACTIONLOGS_DISABLED
4	PLG_ACTIONLOG_JOOMLA_APPLICATION_CONFIG_UPDATED	{"action":"update","type":"PLG_ACTIONLOG_JOOMLA_TYPE_APPLICATION_CONFIG","extension_name":"com_config.application","itemlink":"index.php?option=com_config","userid":605,"username":"otus","accountlink":"index.php?option=com_users&task=user.edit&id=605"}	2021-10-02 16:14:19	com_config.application	605	0	COM_ACTIONLOGS_DISABLED
5	PLG_ACTIONLOG_JOOMLA_EXTENSION_INSTALLED	{"action":"install","type":"PLG_ACTIONLOG_JOOMLA_TYPE_LANGUAGE","id":216,"name":"Russian (ru-RU)","extension_name":"Russian (ru-RU)","userid":605,"username":"otus","accountlink":"index.php?option=com_users&task=user.edit&id=605"}	2021-10-02 16:15:26	com_installer	605	216	COM_ACTIONLOGS_DISABLED
6	PLG_ACTIONLOG_JOOMLA_EXTENSION_INSTALLED	{"action":"install","type":"PLG_ACTIONLOG_JOOMLA_TYPE_LANGUAGE","id":217,"name":"Russian (ru-RU)","extension_name":"Russian (ru-RU)","userid":605,"username":"otus","accountlink":"index.php?option=com_users&task=user.edit&id=605"}	2021-10-02 16:15:26	com_installer	605	217	COM_ACTIONLOGS_DISABLED
7	PLG_ACTIONLOG_JOOMLA_EXTENSION_INSTALLED	{"action":"install","type":"PLG_ACTIONLOG_JOOMLA_TYPE_LANGUAGE","id":218,"name":"Russian (ru-RU)","extension_name":"Russian (ru-RU)","userid":605,"username":"otus","accountlink":"index.php?option=com_users&task=user.edit&id=605"}	2021-10-02 16:15:26	com_installer	605	218	COM_ACTIONLOGS_DISABLED
8	PLG_ACTIONLOG_JOOMLA_EXTENSION_INSTALLED	{"action":"install","type":"PLG_ACTIONLOG_JOOMLA_TYPE_PACKAGE","id":"219","name":"Russian (ru-RU) Language Pack","extension_name":"Russian (ru-RU) Language Pack","userid":605,"username":"otus","accountlink":"index.php?option=com_users&task=user.edit&id=605"}	2021-10-02 16:15:26	com_installer	605	219	COM_ACTIONLOGS_DISABLED
9	PLG_ACTIONLOG_JOOMLA_USER_LOGGED_IN	{"action":"login","userid":605,"username":"otus","accountlink":"index.php?option=com_users&task=user.edit&id=605","app":"PLG_ACTIONLOG_JOOMLA_APPLICATION_SITE"}	2021-10-02 16:51:25	com_users	605	0	COM_ACTIONLOGS_DISABLED
10	PLG_ACTIONLOG_JOOMLA_USER_LOGGED_IN	{"action":"login","userid":605,"username":"otus","accountlink":"index.php?option=com_users&task=user.edit&id=605","app":"PLG_ACTIONLOG_JOOMLA_APPLICATION_ADMINISTRATOR"}	2021-10-02 16:51:38	com_users	605	0	COM_ACTIONLOGS_DISABLED
11	PLG_ACTIONLOG_JOOMLA_EXTENSION_INSTALLED	{"action":"install","type":"PLG_ACTIONLOG_JOOMLA_TYPE_LANGUAGE","id":220,"name":"Russian (ru-RU)","extension_name":"Russian (ru-RU)","userid":605,"username":"otus","accountlink":"index.php?option=com_users&task=user.edit&id=605"}	2021-10-02 16:52:27	com_installer	605	220	COM_ACTIONLOGS_DISABLED
12	PLG_ACTIONLOG_JOOMLA_EXTENSION_INSTALLED	{"action":"install","type":"PLG_ACTIONLOG_JOOMLA_TYPE_LANGUAGE","id":221,"name":"Russian (ru-RU)","extension_name":"Russian (ru-RU)","userid":605,"username":"otus","accountlink":"index.php?option=com_users&task=user.edit&id=605"}	2021-10-02 16:52:27	com_installer	605	221	COM_ACTIONLOGS_DISABLED
13	PLG_ACTIONLOG_JOOMLA_EXTENSION_INSTALLED	{"action":"install","type":"PLG_ACTIONLOG_JOOMLA_TYPE_LANGUAGE","id":222,"name":"Russian (ru-RU)","extension_name":"Russian (ru-RU)","userid":605,"username":"otus","accountlink":"index.php?option=com_users&task=user.edit&id=605"}	2021-10-02 16:52:27	com_installer	605	222	COM_ACTIONLOGS_DISABLED
14	PLG_ACTIONLOG_JOOMLA_EXTENSION_INSTALLED	{"action":"install","type":"PLG_ACTIONLOG_JOOMLA_TYPE_PACKAGE","id":"219","name":"Russian (ru-RU) Language Pack","extension_name":"Russian (ru-RU) Language Pack","userid":605,"username":"otus","accountlink":"index.php?option=com_users&task=user.edit&id=605"}	2021-10-02 16:52:27	com_installer	605	219	COM_ACTIONLOGS_DISABLED
15	PLG_ACTIONLOG_JOOMLA_USER_LOGGED_IN	{"action":"login","userid":605,"username":"otus","accountlink":"index.php?option=com_users&task=user.edit&id=605","app":"PLG_ACTIONLOG_JOOMLA_APPLICATION_ADMINISTRATOR"}	2021-10-02 17:34:57	com_users	605	0	COM_ACTIONLOGS_DISABLED
16	PLG_ACTIONLOG_JOOMLA_USER_LOGGED_IN	{"action":"login","userid":605,"username":"otus","accountlink":"index.php?option=com_users&task=user.edit&id=605","app":"PLG_ACTIONLOG_JOOMLA_APPLICATION_SITE"}	2021-10-02 17:48:26	com_users	605	0	COM_ACTIONLOGS_DISABLED
17	PLG_ACTIONLOG_JOOMLA_USER_CACHE	{"action":"cache","type":"PLG_ACTIONLOG_JOOMLA_TYPE_USER","id":605,"title":"otus","itemlink":"index.php?option=com_users&task=user.edit&id=605","userid":605,"username":"otus","accountlink":"index.php?option=com_users&task=user.edit&id=605","group":"all"}	2021-10-02 17:50:24	com_cache	605	605	COM_ACTIONLOGS_DISABLED
18	PLG_ACTIONLOG_JOOMLA_USER_CACHE	{"action":"cache","type":"PLG_ACTIONLOG_JOOMLA_TYPE_USER","id":605,"title":"otus","itemlink":"index.php?option=com_users&task=user.edit&id=605","userid":605,"username":"otus","accountlink":"index.php?option=com_users&task=user.edit&id=605","group":"plg_system_debug_administrator"}	2021-10-02 17:50:29	com_cache	605	605	COM_ACTIONLOGS_DISABLED
19	PLG_ACTIONLOG_JOOMLA_USER_CACHE	{"action":"cache","type":"PLG_ACTIONLOG_JOOMLA_TYPE_USER","id":605,"title":"otus","itemlink":"index.php?option=com_users&task=user.edit&id=605","userid":605,"username":"otus","accountlink":"index.php?option=com_users&task=user.edit&id=605","group":"plg_system_debug_site"}	2021-10-02 17:50:29	com_cache	605	605	COM_ACTIONLOGS_DISABLED
20	PLG_ACTIONLOG_JOOMLA_USER_LOGGED_IN	{"action":"login","userid":605,"username":"otus","accountlink":"index.php?option=com_users&task=user.edit&id=605","app":"PLG_ACTIONLOG_JOOMLA_APPLICATION_ADMINISTRATOR"}	2021-10-02 21:28:00	com_users	605	0	COM_ACTIONLOGS_DISABLED
21	PLG_SYSTEM_ACTIONLOGS_CONTENT_UPDATED	{"action":"update","type":"PLG_ACTIONLOG_JOOMLA_TYPE_MODULE","id":"88","title":"Latest Actions","extension_name":"Latest Actions","itemlink":"index.php?option=com_modules&task=module.edit&id=88","userid":605,"username":"otus","accountlink":"index.php?option=com_users&task=user.edit&id=605"}	2021-10-02 21:29:45	com_modules.module	605	88	COM_ACTIONLOGS_DISABLED
22	PLG_ACTIONLOG_JOOMLA_USER_CHECKIN	{"action":"checkin","type":"PLG_ACTIONLOG_JOOMLA_TYPE_USER","id":605,"title":"otus","itemlink":"index.php?option=com_users&task=user.edit&id=605","userid":605,"username":"otus","accountlink":"index.php?option=com_users&task=user.edit&id=605","table":"#__modules"}	2021-10-02 21:29:45	com_checkin	605	605	COM_ACTIONLOGS_DISABLED
23	PLG_SYSTEM_ACTIONLOGS_CONTENT_UPDATED	{"action":"update","type":"PLG_ACTIONLOG_JOOMLA_TYPE_MODULE","id":"16","title":"Login Form","extension_name":"Login Form","itemlink":"index.php?option=com_modules&task=module.edit&id=16","userid":605,"username":"otus","accountlink":"index.php?option=com_users&task=user.edit&id=605"}	2021-10-02 21:30:54	com_modules.module	605	16	COM_ACTIONLOGS_DISABLED
24	PLG_ACTIONLOG_JOOMLA_USER_CHECKIN	{"action":"checkin","type":"PLG_ACTIONLOG_JOOMLA_TYPE_USER","id":605,"title":"otus","itemlink":"index.php?option=com_users&task=user.edit&id=605","userid":605,"username":"otus","accountlink":"index.php?option=com_users&task=user.edit&id=605","table":"#__modules"}	2021-10-02 21:30:54	com_checkin	605	605	COM_ACTIONLOGS_DISABLED
25	PLG_ACTIONLOG_JOOMLA_USER_CHECKIN	{"action":"checkin","type":"PLG_ACTIONLOG_JOOMLA_TYPE_USER","id":605,"title":"otus","itemlink":"index.php?option=com_users&task=user.edit&id=605","userid":605,"username":"otus","accountlink":"index.php?option=com_users&task=user.edit&id=605","table":"#__modules"}	2021-10-02 21:31:07	com_checkin	605	605	COM_ACTIONLOGS_DISABLED
26	PLG_SYSTEM_ACTIONLOGS_CONTENT_ADDED	{"action":"add","type":"PLG_ACTIONLOG_JOOMLA_TYPE_MODULE","id":"109","title":"\\u0412\\u0445\\u043e\\u0434 \\u043d\\u0430 \\u0441\\u0430\\u0439\\u0442","extension_name":"\\u0412\\u0445\\u043e\\u0434 \\u043d\\u0430 \\u0441\\u0430\\u0439\\u0442","itemlink":"index.php?option=com_modules&task=module.edit&id=109","userid":605,"username":"otus","accountlink":"index.php?option=com_users&task=user.edit&id=605"}	2021-10-02 21:32:49	com_modules.module	605	109	COM_ACTIONLOGS_DISABLED
27	PLG_SYSTEM_ACTIONLOGS_CONTENT_UPDATED	{"action":"update","type":"PLG_ACTIONLOG_JOOMLA_TYPE_MODULE","id":"109","title":"\\u0412\\u0445\\u043e\\u0434 \\u043d\\u0430 \\u0441\\u0430\\u0439\\u0442","extension_name":"\\u0412\\u0445\\u043e\\u0434 \\u043d\\u0430 \\u0441\\u0430\\u0439\\u0442","itemlink":"index.php?option=com_modules&task=module.edit&id=109","userid":605,"username":"otus","accountlink":"index.php?option=com_users&task=user.edit&id=605"}	2021-10-02 21:32:52	com_modules.module	605	109	COM_ACTIONLOGS_DISABLED
28	PLG_ACTIONLOG_JOOMLA_USER_CHECKIN	{"action":"checkin","type":"PLG_ACTIONLOG_JOOMLA_TYPE_USER","id":605,"title":"otus","itemlink":"index.php?option=com_users&task=user.edit&id=605","userid":605,"username":"otus","accountlink":"index.php?option=com_users&task=user.edit&id=605","table":"#__modules"}	2021-10-02 21:32:52	com_checkin	605	605	COM_ACTIONLOGS_DISABLED
29	PLG_SYSTEM_ACTIONLOGS_CONTENT_UPDATED	{"action":"update","type":"PLG_ACTIONLOG_JOOMLA_TYPE_MODULE","id":"109","title":"\\u0412\\u0445\\u043e\\u0434 \\u043d\\u0430 \\u0441\\u0430\\u0439\\u0442","extension_name":"\\u0412\\u0445\\u043e\\u0434 \\u043d\\u0430 \\u0441\\u0430\\u0439\\u0442","itemlink":"index.php?option=com_modules&task=module.edit&id=109","userid":605,"username":"otus","accountlink":"index.php?option=com_users&task=user.edit&id=605"}	2021-10-02 21:33:13	com_modules.module	605	109	COM_ACTIONLOGS_DISABLED
30	PLG_ACTIONLOG_JOOMLA_USER_CHECKIN	{"action":"checkin","type":"PLG_ACTIONLOG_JOOMLA_TYPE_USER","id":605,"title":"otus","itemlink":"index.php?option=com_users&task=user.edit&id=605","userid":605,"username":"otus","accountlink":"index.php?option=com_users&task=user.edit&id=605","table":"#__modules"}	2021-10-02 21:33:13	com_checkin	605	605	COM_ACTIONLOGS_DISABLED
31	PLG_ACTIONLOG_JOOMLA_USER_CHECKIN	{"action":"checkin","type":"PLG_ACTIONLOG_JOOMLA_TYPE_USER","id":605,"title":"otus","itemlink":"index.php?option=com_users&task=user.edit&id=605","userid":605,"username":"otus","accountlink":"index.php?option=com_users&task=user.edit&id=605","table":"#__modules"}	2021-10-02 21:33:26	com_checkin	605	605	COM_ACTIONLOGS_DISABLED
32	PLG_SYSTEM_ACTIONLOGS_CONTENT_TRASHED	{"action":"trash","type":"PLG_ACTIONLOG_JOOMLA_TYPE_MODULE","id":16,"title":"Login Form","itemlink":"index.php?option=com_modules&task=module.edit&id=16","userid":605,"username":"otus","accountlink":"index.php?option=com_users&task=user.edit&id=605"}	2021-10-02 21:33:26	com_modules.module	605	16	COM_ACTIONLOGS_DISABLED
33	PLG_ACTIONLOG_JOOMLA_USER_CHECKIN	{"action":"checkin","type":"PLG_ACTIONLOG_JOOMLA_TYPE_USER","id":605,"title":"otus","itemlink":"index.php?option=com_users&task=user.edit&id=605","userid":605,"username":"otus","accountlink":"index.php?option=com_users&task=user.edit&id=605","table":"#__modules"}	2021-10-02 21:33:34	com_checkin	605	605	COM_ACTIONLOGS_DISABLED
34	PLG_SYSTEM_ACTIONLOGS_CONTENT_TRASHED	{"action":"trash","type":"PLG_ACTIONLOG_JOOMLA_TYPE_MODULE","id":1,"title":"Main Menu","itemlink":"index.php?option=com_modules&task=module.edit&id=1","userid":605,"username":"otus","accountlink":"index.php?option=com_users&task=user.edit&id=605"}	2021-10-02 21:33:34	com_modules.module	605	1	COM_ACTIONLOGS_DISABLED
35	PLG_SYSTEM_ACTIONLOGS_CONTENT_ADDED	{"action":"add","type":"PLG_ACTIONLOG_JOOMLA_TYPE_MODULE","id":"110","title":"\\u041c\\u0435\\u043d\\u044e","extension_name":"\\u041c\\u0435\\u043d\\u044e","itemlink":"index.php?option=com_modules&task=module.edit&id=110","userid":605,"username":"otus","accountlink":"index.php?option=com_users&task=user.edit&id=605"}	2021-10-02 21:34:00	com_modules.module	605	110	COM_ACTIONLOGS_DISABLED
36	PLG_ACTIONLOG_JOOMLA_USER_CHECKIN	{"action":"checkin","type":"PLG_ACTIONLOG_JOOMLA_TYPE_USER","id":605,"title":"otus","itemlink":"index.php?option=com_users&task=user.edit&id=605","userid":605,"username":"otus","accountlink":"index.php?option=com_users&task=user.edit&id=605","table":"#__extensions"}	2021-10-02 21:35:18	com_checkin	605	605	COM_ACTIONLOGS_DISABLED
37	PLG_SYSTEM_ACTIONLOGS_CONTENT_UNPUBLISHED	{"action":"unpublish","type":"PLG_ACTIONLOG_JOOMLA_TYPE_PLUGIN","id":182,"title":"plg_system_webauthn","itemlink":"index.php?option=com_plugins&task=plugin.edit&extension_id=182","userid":605,"username":"otus","accountlink":"index.php?option=com_users&task=user.edit&id=605"}	2021-10-02 21:35:18	com_plugins.plugin	605	182	COM_ACTIONLOGS_DISABLED
38	PLG_ACTIONLOG_JOOMLA_USER_LOGGED_IN	{"action":"login","userid":605,"username":"otus","accountlink":"index.php?option=com_users&task=user.edit&id=605","app":"PLG_ACTIONLOG_JOOMLA_APPLICATION_SITE"}	2021-10-02 21:35:35	com_users	605	0	COM_ACTIONLOGS_DISABLED
39	PLG_ACTIONLOG_JOOMLA_USER_LOGGED_OUT	{"action":"logout","id":605,"userid":605,"username":"otus","accountlink":"index.php?option=com_users&task=user.edit&id=605","app":"PLG_ACTIONLOG_JOOMLA_APPLICATION_SITE"}	2021-10-02 21:35:56	com_users	605	605	COM_ACTIONLOGS_DISABLED
40	PLG_ACTIONLOG_JOOMLA_USER_CHECKIN	{"action":"checkin","type":"PLG_ACTIONLOG_JOOMLA_TYPE_USER","id":605,"title":"otus","itemlink":"index.php?option=com_users&task=user.edit&id=605","userid":605,"username":"otus","accountlink":"index.php?option=com_users&task=user.edit&id=605","table":"joomla_extensions"}	2021-10-02 21:36:12	com_checkin	605	605	COM_ACTIONLOGS_DISABLED
\.


--
-- Data for Name: joomla_action_logs_extensions; Type: TABLE DATA; Schema: public; Owner: joomla_user
--

COPY public.joomla_action_logs_extensions (id, extension) FROM stdin;
1	com_banners
2	com_cache
3	com_categories
4	com_config
5	com_contact
6	com_content
7	com_installer
8	com_media
9	com_menus
10	com_messages
11	com_modules
12	com_newsfeeds
13	com_plugins
14	com_redirect
15	com_tags
16	com_templates
17	com_users
18	com_checkin
\.


--
-- Data for Name: joomla_action_logs_users; Type: TABLE DATA; Schema: public; Owner: joomla_user
--

COPY public.joomla_action_logs_users (user_id, notify, extensions) FROM stdin;
\.


--
-- Data for Name: joomla_assets; Type: TABLE DATA; Schema: public; Owner: joomla_user
--

COPY public.joomla_assets (id, parent_id, lft, rgt, level, name, title, rules) FROM stdin;
2	1	1	2	1	com_admin	com_admin	{}
3	1	3	6	1	com_banners	com_banners	{"core.admin":{"7":1},"core.manage":{"6":1}}
4	1	7	8	1	com_cache	com_cache	{"core.admin":{"7":1},"core.manage":{"7":1}}
5	1	9	10	1	com_checkin	com_checkin	{"core.admin":{"7":1},"core.manage":{"7":1}}
6	1	11	12	1	com_config	com_config	{}
7	1	13	16	1	com_contact	com_contact	{"core.admin":{"7":1},"core.manage":{"6":1}}
8	1	17	38	1	com_content	com_content	{"core.admin":{"7":1},"core.manage":{"6":1},"core.create":{"3":1},"core.edit":{"4":1},"core.edit.state":{"5":1},"core.execute.transition":{"6":1,"5":1}}
9	1	39	40	1	com_cpanel	com_cpanel	{}
10	1	41	42	1	com_installer	com_installer	{"core.manage":{"7":0},"core.delete":{"7":0},"core.edit.state":{"7":0}}
27	8	18	19	2	com_content.category.2	Uncategorised	{}
28	3	4	5	2	com_banners.category.3	Uncategorised	{}
29	7	14	15	2	com_contact.category.4	Uncategorised	{}
56	8	20	37	2	com_content.workflow.1	COM_WORKFLOW_BASIC_WORKFLOW	{}
57	56	21	22	3	com_content.stage.1	COM_WORKFLOW_BASIC_STAGE	{}
58	56	23	24	3	com_content.transition.1	Unpublish	{}
59	56	25	26	3	com_content.transition.2	Publish	{}
60	56	27	28	3	com_content.transition.3	Trash	{}
61	56	29	30	3	com_content.transition.4	Archive	{}
62	56	31	32	3	com_content.transition.5	Feature	{}
63	56	33	34	3	com_content.transition.6	Unfeature	{}
64	56	35	36	3	com_content.transition.7	Publish & Feature	{}
16	1	53	56	1	com_menus	com_menus	{"core.admin":{"7":1}}
17	1	57	58	1	com_messages	com_messages	{"core.admin":{"7":1},"core.manage":{"7":1}}
11	1	43	46	1	com_languages	com_languages	{"core.admin":{"7":1}}
12	1	47	48	1	com_login	com_login	{}
14	1	49	50	1	com_massmail	com_massmail	{}
15	1	51	52	1	com_media	com_media	{"core.admin":{"7":1},"core.manage":{"6":1},"core.create":{"3":1},"core.delete":{"5":1}}
39	18	60	61	2	com_modules.module.1	Main Menu	{}
40	18	62	63	2	com_modules.module.2	Login	{}
41	18	64	65	2	com_modules.module.3	Popular Articles	{}
42	18	66	67	2	com_modules.module.4	Recently Added Articles	{}
43	18	68	69	2	com_modules.module.8	Toolbar	{}
44	18	70	71	2	com_modules.module.9	Notifications	{}
45	18	72	73	2	com_modules.module.10	Logged-in Users	{}
46	18	74	75	2	com_modules.module.12	Admin Menu	{}
48	18	80	81	2	com_modules.module.14	User Status	{}
49	18	82	83	2	com_modules.module.15	Title	{}
51	18	86	87	2	com_modules.module.17	Breadcrumbs	{}
52	18	88	89	2	com_modules.module.79	Multilanguage status	{}
53	18	92	93	2	com_modules.module.86	Joomla Version	{}
54	16	54	55	2	com_menus.menu.1	Main Menu	{}
55	18	96	97	2	com_modules.module.87	Sample Data	{}
68	18	78	79	2	com_modules.module.89	Privacy Dashboard	{}
70	18	90	91	2	com_modules.module.103	Site	{}
71	18	94	95	2	com_modules.module.104	System	{}
72	18	98	99	2	com_modules.module.91	System Dashboard	{}
73	18	100	101	2	com_modules.module.92	Content Dashboard	{}
74	18	102	103	2	com_modules.module.93	Menus Dashboard	{}
75	18	104	105	2	com_modules.module.94	Components Dashboard	{}
76	18	106	107	2	com_modules.module.95	Users Dashboard	{}
50	18	84	85	2	com_modules.module.16	Login Form	{}
77	18	108	109	2	com_modules.module.99	Frontend Link	{}
78	18	110	111	2	com_modules.module.100	Messages	{}
79	18	112	113	2	com_modules.module.101	Post Install Messages	{}
80	18	114	115	2	com_modules.module.102	User Status	{}
82	18	116	117	2	com_modules.module.105	3rd Party	{}
83	18	118	119	2	com_modules.module.106	Help Dashboard	{}
84	18	120	121	2	com_modules.module.107	Privacy Requests	{}
85	18	122	123	2	com_modules.module.108	Privacy Status	{}
86	18	124	125	2	com_modules.module.96	Popular Articles	{}
88	18	128	129	2	com_modules.module.98	Logged-in Users	{}
87	18	126	127	2	com_modules.module.97	Recently Added Articles	{}
89	11	44	45	2	com_languages.language.2	Russian (ru-RU)	{}
67	18	76	77	2	com_modules.module.88	Latest Actions	{}
90	18	130	131	2	com_modules.module.109	Вход на сайт	{}
1	0	0	167	0	root.1	Root Asset	{"core.login.site":{"6":1,"2":1},"core.login.admin":{"6":1},"core.login.api":{"8":1},"core.login.offline":{"6":1},"core.admin":{"8":1},"core.manage":{"7":1},"core.create":{"6":1,"3":1},"core.delete":{"6":1},"core.edit":{"6":1,"4":1},"core.edit.state":{"6":1,"5":1},"core.edit.own":{"6":1,"3":1}}
18	1	59	134	1	com_modules	com_modules	{"core.admin":{"7":1}}
20	1	139	140	1	com_plugins	com_plugins	{"core.admin":{"7":1}}
19	1	135	138	1	com_newsfeeds	com_newsfeeds	{"core.admin":{"7":1},"core.manage":{"6":1}}
21	1	141	142	1	com_redirect	com_redirect	{"core.admin":{"7":1}}
23	1	143	144	1	com_templates	com_templates	{"core.admin":{"7":1}}
24	1	149	152	1	com_users	com_users	{"core.admin":{"7":1}}
26	1	153	154	1	com_wrapper	com_wrapper	{}
30	19	136	137	2	com_newsfeeds.category.5	Uncategorised	{}
32	24	150	151	2	com_users.category.7	Uncategorised	{}
33	1	155	156	1	com_finder	com_finder	{"core.admin":{"7":1},"core.manage":{"6":1}}
34	1	157	158	1	com_joomlaupdate	com_joomlaupdate	{}
35	1	159	160	1	com_tags	com_tags	{}
36	1	161	162	1	com_contenthistory	com_contenthistory	{}
37	1	163	164	1	com_ajax	com_ajax	{}
38	1	165	166	1	com_postinstall	com_postinstall	{}
65	1	145	146	1	com_privacy	com_privacy	{}
66	1	147	148	1	com_actionlogs	com_actionlogs	{}
91	18	132	133	2	com_modules.module.110	Меню	{}
\.


--
-- Data for Name: joomla_associations; Type: TABLE DATA; Schema: public; Owner: joomla_user
--

COPY public.joomla_associations (id, context, key) FROM stdin;
\.


--
-- Data for Name: joomla_banner_clients; Type: TABLE DATA; Schema: public; Owner: joomla_user
--

COPY public.joomla_banner_clients (id, name, contact, email, extrainfo, state, checked_out, checked_out_time, metakey, own_prefix, metakey_prefix, purchase_type, track_clicks, track_impressions) FROM stdin;
\.


--
-- Data for Name: joomla_banner_tracks; Type: TABLE DATA; Schema: public; Owner: joomla_user
--

COPY public.joomla_banner_tracks (track_date, track_type, banner_id, count) FROM stdin;
\.


--
-- Data for Name: joomla_banners; Type: TABLE DATA; Schema: public; Owner: joomla_user
--

COPY public.joomla_banners (id, cid, type, name, alias, imptotal, impmade, clicks, clickurl, state, catid, description, custombannercode, sticky, ordering, metakey, params, own_prefix, metakey_prefix, purchase_type, track_clicks, track_impressions, checked_out, checked_out_time, publish_up, publish_down, reset, created, language, created_by, created_by_alias, modified, modified_by, version) FROM stdin;
\.


--
-- Data for Name: joomla_categories; Type: TABLE DATA; Schema: public; Owner: joomla_user
--

COPY public.joomla_categories (id, asset_id, parent_id, lft, rgt, level, path, extension, title, alias, note, description, published, checked_out, checked_out_time, access, params, metadesc, metakey, metadata, created_user_id, created_time, modified_user_id, modified_time, hits, language, version) FROM stdin;
1	0	0	0	11	0		system	ROOT	root			1	\N	\N	1	{}			{}	605	2021-10-02 19:08:17.628777	605	2021-10-02 19:08:17.628777	0	*	1
2	27	1	1	2	1	uncategorised	com_content	Uncategorised	uncategorised			1	\N	\N	1	{"category_layout":"","image":"","workflow_id":"use_default"}			{"author":"","robots":""}	605	2021-10-02 19:08:17.628777	605	2021-10-02 19:08:17.628777	0	*	1
3	28	1	3	4	1	uncategorised	com_banners	Uncategorised	uncategorised			1	\N	\N	1	{"category_layout":"","image":""}			{"author":"","robots":""}	605	2021-10-02 19:08:17.628777	605	2021-10-02 19:08:17.628777	0	*	1
4	29	1	5	6	1	uncategorised	com_contact	Uncategorised	uncategorised			1	\N	\N	1	{"category_layout":"","image":""}			{"author":"","robots":""}	605	2021-10-02 19:08:17.628777	605	2021-10-02 19:08:17.628777	0	*	1
5	30	1	7	8	1	uncategorised	com_newsfeeds	Uncategorised	uncategorised			1	\N	\N	1	{"category_layout":"","image":""}			{"author":"","robots":""}	605	2021-10-02 19:08:17.628777	605	2021-10-02 19:08:17.628777	0	*	1
7	32	1	9	10	1	uncategorised	com_users	Uncategorised	uncategorised			1	\N	\N	1	{"category_layout":"","image":""}			{"author":"","robots":""}	605	2021-10-02 19:08:17.628777	605	2021-10-02 19:08:17.628777	0	*	1
\.


--
-- Data for Name: joomla_contact_details; Type: TABLE DATA; Schema: public; Owner: joomla_user
--

COPY public.joomla_contact_details (id, name, alias, con_position, address, suburb, state, country, postcode, telephone, fax, misc, image, email_to, default_con, published, checked_out, checked_out_time, ordering, params, user_id, catid, access, mobile, webpage, sortname1, sortname2, sortname3, language, created, created_by, created_by_alias, modified, modified_by, metakey, metadesc, metadata, featured, publish_up, publish_down, version, hits) FROM stdin;
\.


--
-- Data for Name: joomla_content; Type: TABLE DATA; Schema: public; Owner: joomla_user
--

COPY public.joomla_content (id, asset_id, title, alias, introtext, fulltext, state, catid, created, created_by, created_by_alias, modified, modified_by, checked_out, checked_out_time, publish_up, publish_down, images, urls, attribs, version, ordering, metakey, metadesc, access, hits, metadata, featured, language, note) FROM stdin;
\.


--
-- Data for Name: joomla_content_frontpage; Type: TABLE DATA; Schema: public; Owner: joomla_user
--

COPY public.joomla_content_frontpage (content_id, ordering, featured_up, featured_down) FROM stdin;
\.


--
-- Data for Name: joomla_content_rating; Type: TABLE DATA; Schema: public; Owner: joomla_user
--

COPY public.joomla_content_rating (content_id, rating_sum, rating_count, lastip) FROM stdin;
\.


--
-- Data for Name: joomla_content_types; Type: TABLE DATA; Schema: public; Owner: joomla_user
--

COPY public.joomla_content_types (type_id, type_title, type_alias, "table", rules, field_mappings, router, content_history_options) FROM stdin;
1	Article	com_content.article	{"special":{"dbtable":"#__content","key":"id","type":"ArticleTable","prefix":"Joomla\\\\Component\\\\Content\\\\Administrator\\\\Table\\\\","config":"array()"},"common":{"dbtable":"#__ucm_content","key":"ucm_id","type":"Corecontent","prefix":"Joomla\\\\CMS\\\\Table\\\\","config":"array()"}}		{"common":{"core_content_item_id":"id","core_title":"title","core_state":"state","core_alias":"alias","core_created_time":"created","core_modified_time":"modified","core_body":"introtext", "core_hits":"hits","core_publish_up":"publish_up","core_publish_down":"publish_down","core_access":"access", "core_params":"attribs", "core_featured":"featured", "core_metadata":"metadata", "core_language":"language", "core_images":"images", "core_urls":"urls", "core_version":"version", "core_ordering":"ordering", "core_metakey":"metakey", "core_metadesc":"metadesc", "core_catid":"catid", "asset_id":"asset_id", "note":"note"}, "special":{"fulltext":"fulltext"}}	ContentHelperRoute::getArticleRoute	{"formFile":"administrator\\/components\\/com_content\\/forms\\/article.xml", "hideFields":["asset_id","checked_out","checked_out_time","version"],"ignoreChanges":["modified_by", "modified", "checked_out", "checked_out_time", "version", "hits", "ordering"],"convertToInt":["publish_up", "publish_down", "featured", "ordering"],"displayLookup":[{"sourceColumn":"catid","targetTable":"#__categories","targetColumn":"id","displayColumn":"title"},{"sourceColumn":"created_by","targetTable":"#__users","targetColumn":"id","displayColumn":"name"},{"sourceColumn":"access","targetTable":"#__viewlevels","targetColumn":"id","displayColumn":"title"},{"sourceColumn":"modified_by","targetTable":"#__users","targetColumn":"id","displayColumn":"name"} ]}
2	Contact	com_contact.contact	{"special":{"dbtable":"#__contact_details","key":"id","type":"ContactTable","prefix":"Joomla\\\\Component\\\\Contact\\\\Administrator\\\\Table\\\\","config":"array()"},"common":{"dbtable":"#__ucm_content","key":"ucm_id","type":"Corecontent","prefix":"Joomla\\\\CMS\\\\Table\\\\","config":"array()"}}		{"common":{"core_content_item_id":"id","core_title":"name","core_state":"published","core_alias":"alias","core_created_time":"created","core_modified_time":"modified","core_body":"address", "core_hits":"hits","core_publish_up":"publish_up","core_publish_down":"publish_down","core_access":"access", "core_params":"params", "core_featured":"featured", "core_metadata":"metadata", "core_language":"language", "core_images":"image", "core_urls":"webpage", "core_version":"version", "core_ordering":"ordering", "core_metakey":"metakey", "core_metadesc":"metadesc", "core_catid":"catid", "asset_id":"null"}, "special":{"con_position":"con_position","suburb":"suburb","state":"state","country":"country","postcode":"postcode","telephone":"telephone","fax":"fax","misc":"misc","email_to":"email_to","default_con":"default_con","user_id":"user_id","mobile":"mobile","sortname1":"sortname1","sortname2":"sortname2","sortname3":"sortname3"}}	ContactHelperRoute::getContactRoute	{"formFile":"administrator\\/components\\/com_contact\\/forms\\/contact.xml","hideFields":["default_con","checked_out","checked_out_time","version"],"ignoreChanges":["modified_by", "modified", "checked_out", "checked_out_time", "version", "hits"],"convertToInt":["publish_up", "publish_down", "featured", "ordering"], "displayLookup":[ {"sourceColumn":"created_by","targetTable":"#__users","targetColumn":"id","displayColumn":"name"},{"sourceColumn":"catid","targetTable":"#__categories","targetColumn":"id","displayColumn":"title"},{"sourceColumn":"modified_by","targetTable":"#__users","targetColumn":"id","displayColumn":"name"},{"sourceColumn":"access","targetTable":"#__viewlevels","targetColumn":"id","displayColumn":"title"},{"sourceColumn":"user_id","targetTable":"#__users","targetColumn":"id","displayColumn":"name"} ] }
3	Newsfeed	com_newsfeeds.newsfeed	{"special":{"dbtable":"#__newsfeeds","key":"id","type":"NewsfeedTable","prefix":"Joomla\\\\Component\\\\Newsfeeds\\\\Administrator\\\\Table\\\\","config":"array()"},"common":{"dbtable":"#__ucm_content","key":"ucm_id","type":"Corecontent","prefix":"Joomla\\\\CMS\\\\Table\\\\","config":"array()"}}		{"common":{"core_content_item_id":"id","core_title":"name","core_state":"published","core_alias":"alias","core_created_time":"created","core_modified_time":"modified","core_body":"description", "core_hits":"hits","core_publish_up":"publish_up","core_publish_down":"publish_down","core_access":"access", "core_params":"params", "core_featured":"featured", "core_metadata":"metadata", "core_language":"language", "core_images":"images", "core_urls":"link", "core_version":"version", "core_ordering":"ordering", "core_metakey":"metakey", "core_metadesc":"metadesc", "core_catid":"catid", "asset_id":"null"}, "special":{"numarticles":"numarticles","cache_time":"cache_time","rtl":"rtl"}}	NewsfeedsHelperRoute::getNewsfeedRoute	{"formFile":"administrator\\/components\\/com_newsfeeds\\/forms\\/newsfeed.xml","hideFields":["asset_id","checked_out","checked_out_time","version"],"ignoreChanges":["modified_by", "modified", "checked_out", "checked_out_time", "version", "hits"],"convertToInt":["publish_up", "publish_down", "featured", "ordering"],"displayLookup":[{"sourceColumn":"catid","targetTable":"#__categories","targetColumn":"id","displayColumn":"title"},{"sourceColumn":"created_by","targetTable":"#__users","targetColumn":"id","displayColumn":"name"},{"sourceColumn":"access","targetTable":"#__viewlevels","targetColumn":"id","displayColumn":"title"},{"sourceColumn":"modified_by","targetTable":"#__users","targetColumn":"id","displayColumn":"name"} ]}
4	User	com_users.user	{"special":{"dbtable":"#__users","key":"id","type":"User","prefix":"Joomla\\\\CMS\\\\Table\\\\","config":"array()"},"common":{"dbtable":"#__ucm_content","key":"ucm_id","type":"Corecontent","prefix":"Joomla\\\\CMS\\\\Table\\\\","config":"array()"}}		{"common":{"core_content_item_id":"id","core_title":"name","core_state":"null","core_alias":"username","core_created_time":"registerDate","core_modified_time":"lastvisitDate","core_body":"null", "core_hits":"null","core_publish_up":"null","core_publish_down":"null","access":"null", "core_params":"params", "core_featured":"null", "core_metadata":"null", "core_language":"null", "core_images":"null", "core_urls":"null", "core_version":"null", "core_ordering":"null", "core_metakey":"null", "core_metadesc":"null", "core_catid":"null", "asset_id":"null"}, "special":{}}		
5	Article Category	com_content.category	{"special":{"dbtable":"#__categories","key":"id","type":"CategoryTable","prefix":"Joomla\\\\Component\\\\Categories\\\\Administrator\\\\Table\\\\","config":"array()"},"common":{"dbtable":"#__ucm_content","key":"ucm_id","type":"Corecontent","prefix":"Joomla\\\\CMS\\\\Table\\\\","config":"array()"}}		{"common":{"core_content_item_id":"id","core_title":"title","core_state":"published","core_alias":"alias","core_created_time":"created_time","core_modified_time":"modified_time","core_body":"description", "core_hits":"hits","core_publish_up":"null","core_publish_down":"null","core_access":"access", "core_params":"params", "core_featured":"null", "core_metadata":"metadata", "core_language":"language", "core_images":"null", "core_urls":"null", "core_version":"version", "core_ordering":"null", "core_metakey":"metakey", "core_metadesc":"metadesc", "core_catid":"parent_id", "asset_id":"asset_id"}, "special":{"parent_id":"parent_id","lft":"lft","rgt":"rgt","level":"level","path":"path","extension":"extension","note":"note"}}	ContentHelperRoute::getCategoryRoute	{"formFile":"administrator\\/components\\/com_categories\\/forms\\/category.xml", "hideFields":["asset_id","checked_out","checked_out_time","version","lft","rgt","level","path","extension"], "ignoreChanges":["modified_user_id", "modified_time", "checked_out", "checked_out_time", "version", "hits", "path"],"convertToInt":["publish_up", "publish_down"], "displayLookup":[{"sourceColumn":"created_user_id","targetTable":"#__users","targetColumn":"id","displayColumn":"name"},{"sourceColumn":"access","targetTable":"#__viewlevels","targetColumn":"id","displayColumn":"title"},{"sourceColumn":"modified_user_id","targetTable":"#__users","targetColumn":"id","displayColumn":"name"},{"sourceColumn":"parent_id","targetTable":"#__categories","targetColumn":"id","displayColumn":"title"}]}
6	Contact Category	com_contact.category	{"special":{"dbtable":"#__categories","key":"id","type":"CategoryTable","prefix":"Joomla\\\\Component\\\\Categories\\\\Administrator\\\\Table\\\\","config":"array()"},"common":{"dbtable":"#__ucm_content","key":"ucm_id","type":"Corecontent","prefix":"Joomla\\\\CMS\\\\Table\\\\","config":"array()"}}		{"common":{"core_content_item_id":"id","core_title":"title","core_state":"published","core_alias":"alias","core_created_time":"created_time","core_modified_time":"modified_time","core_body":"description", "core_hits":"hits","core_publish_up":"null","core_publish_down":"null","core_access":"access", "core_params":"params", "core_featured":"null", "core_metadata":"metadata", "core_language":"language", "core_images":"null", "core_urls":"null", "core_version":"version", "core_ordering":"null", "core_metakey":"metakey", "core_metadesc":"metadesc", "core_catid":"parent_id", "asset_id":"asset_id"}, "special":{"parent_id":"parent_id","lft":"lft","rgt":"rgt","level":"level","path":"path","extension":"extension","note":"note"}}	ContactHelperRoute::getCategoryRoute	{"formFile":"administrator\\/components\\/com_categories\\/forms\\/category.xml", "hideFields":["asset_id","checked_out","checked_out_time","version","lft","rgt","level","path","extension"], "ignoreChanges":["modified_user_id", "modified_time", "checked_out", "checked_out_time", "version", "hits", "path"],"convertToInt":["publish_up", "publish_down"], "displayLookup":[{"sourceColumn":"created_user_id","targetTable":"#__users","targetColumn":"id","displayColumn":"name"},{"sourceColumn":"access","targetTable":"#__viewlevels","targetColumn":"id","displayColumn":"title"},{"sourceColumn":"modified_user_id","targetTable":"#__users","targetColumn":"id","displayColumn":"name"},{"sourceColumn":"parent_id","targetTable":"#__categories","targetColumn":"id","displayColumn":"title"}]}
7	Newsfeeds Category	com_newsfeeds.category	{"special":{"dbtable":"#__categories","key":"id","type":"CategoryTable","prefix":"Joomla\\\\Component\\\\Categories\\\\Administrator\\\\Table\\\\","config":"array()"},"common":{"dbtable":"#__ucm_content","key":"ucm_id","type":"Corecontent","prefix":"Joomla\\\\CMS\\\\Table\\\\","config":"array()"}}		{"common":{"core_content_item_id":"id","core_title":"title","core_state":"published","core_alias":"alias","core_created_time":"created_time","core_modified_time":"modified_time","core_body":"description", "core_hits":"hits","core_publish_up":"null","core_publish_down":"null","core_access":"access", "core_params":"params", "core_featured":"null", "core_metadata":"metadata", "core_language":"language", "core_images":"null", "core_urls":"null", "core_version":"version", "core_ordering":"null", "core_metakey":"metakey", "core_metadesc":"metadesc", "core_catid":"parent_id", "asset_id":"asset_id"}, "special":{"parent_id":"parent_id","lft":"lft","rgt":"rgt","level":"level","path":"path","extension":"extension","note":"note"}}	NewsfeedsHelperRoute::getCategoryRoute	{"formFile":"administrator\\/components\\/com_categories\\/forms\\/category.xml", "hideFields":["asset_id","checked_out","checked_out_time","version","lft","rgt","level","path","extension"], "ignoreChanges":["modified_user_id", "modified_time", "checked_out", "checked_out_time", "version", "hits", "path"],"convertToInt":["publish_up", "publish_down"], "displayLookup":[{"sourceColumn":"created_user_id","targetTable":"#__users","targetColumn":"id","displayColumn":"name"},{"sourceColumn":"access","targetTable":"#__viewlevels","targetColumn":"id","displayColumn":"title"},{"sourceColumn":"modified_user_id","targetTable":"#__users","targetColumn":"id","displayColumn":"name"},{"sourceColumn":"parent_id","targetTable":"#__categories","targetColumn":"id","displayColumn":"title"}]}
8	Tag	com_tags.tag	{"special":{"dbtable":"#__tags","key":"tag_id","type":"TagTable","prefix":"Joomla\\\\Component\\\\Tags\\\\Administrator\\\\Table\\\\","config":"array()"},"common":{"dbtable":"#__ucm_content","key":"ucm_id","type":"Corecontent","prefix":"Joomla\\\\CMS\\\\Table\\\\","config":"array()"}}		{"common":{"core_content_item_id":"id","core_title":"title","core_state":"published","core_alias":"alias","core_created_time":"created_time","core_modified_time":"modified_time","core_body":"description", "core_hits":"hits","core_publish_up":"null","core_publish_down":"null","core_access":"access", "core_params":"params", "core_featured":"featured", "core_metadata":"metadata", "core_language":"language", "core_images":"images", "core_urls":"urls", "core_version":"version", "core_ordering":"null", "core_metakey":"metakey", "core_metadesc":"metadesc", "core_catid":"null", "asset_id":"null"}, "special":{"parent_id":"parent_id","lft":"lft","rgt":"rgt","level":"level","path":"path"}}	TagsHelperRoute::getTagRoute	{"formFile":"administrator\\/components\\/com_tags\\/forms\\/tag.xml", "hideFields":["checked_out","checked_out_time","version", "lft", "rgt", "level", "path", "urls", "publish_up", "publish_down"],"ignoreChanges":["modified_user_id", "modified_time", "checked_out", "checked_out_time", "version", "hits", "path"],"convertToInt":["publish_up", "publish_down"], "displayLookup":[{"sourceColumn":"created_user_id","targetTable":"#__users","targetColumn":"id","displayColumn":"name"}, {"sourceColumn":"access","targetTable":"#__viewlevels","targetColumn":"id","displayColumn":"title"}, {"sourceColumn":"modified_user_id","targetTable":"#__users","targetColumn":"id","displayColumn":"name"}]}
9	Banner	com_banners.banner	{"special":{"dbtable":"#__banners","key":"id","type":"BannerTable","prefix":"Joomla\\\\Component\\\\Banners\\\\Administrator\\\\Table\\\\","config":"array()"},"common":{"dbtable":"#__ucm_content","key":"ucm_id","type":"Corecontent","prefix":"Joomla\\\\CMS\\\\Table\\\\","config":"array()"}}		{"common":{"core_content_item_id":"id","core_title":"name","core_state":"published","core_alias":"alias","core_created_time":"created","core_modified_time":"modified","core_body":"description", "core_hits":"null","core_publish_up":"publish_up","core_publish_down":"publish_down","core_access":"access", "core_params":"params", "core_featured":"null", "core_metadata":"metadata", "core_language":"language", "core_images":"images", "core_urls":"link", "core_version":"version", "core_ordering":"ordering", "core_metakey":"metakey", "core_metadesc":"metadesc", "core_catid":"catid", "asset_id":"null"}, "special":{"imptotal":"imptotal", "impmade":"impmade", "clicks":"clicks", "clickurl":"clickurl", "custombannercode":"custombannercode", "cid":"cid", "purchase_type":"purchase_type", "track_impressions":"track_impressions", "track_clicks":"track_clicks"}}		{"formFile":"administrator\\/components\\/com_banners\\/forms\\/banner.xml", "hideFields":["checked_out","checked_out_time","version", "reset"],"ignoreChanges":["modified_by", "modified", "checked_out", "checked_out_time", "version", "imptotal", "impmade", "reset"], "convertToInt":["publish_up", "publish_down", "ordering"], "displayLookup":[{"sourceColumn":"catid","targetTable":"#__categories","targetColumn":"id","displayColumn":"title"}, {"sourceColumn":"cid","targetTable":"#__banner_clients","targetColumn":"id","displayColumn":"name"}, {"sourceColumn":"created_by","targetTable":"#__users","targetColumn":"id","displayColumn":"name"},{"sourceColumn":"modified_by","targetTable":"#__users","targetColumn":"id","displayColumn":"name"} ]}
10	Banners Category	com_banners.category	{"special":{"dbtable":"#__categories","key":"id","type":"CategoryTable","prefix":"Joomla\\\\Component\\\\Categories\\\\Administrator\\\\Table\\\\","config":"array()"},"common":{"dbtable":"#__ucm_content","key":"ucm_id","type":"Corecontent","prefix":"Joomla\\\\CMS\\\\Table\\\\","config":"array()"}}		{"common":{"core_content_item_id":"id","core_title":"title","core_state":"published","core_alias":"alias","core_created_time":"created_time","core_modified_time":"modified_time","core_body":"description", "core_hits":"hits","core_publish_up":"null","core_publish_down":"null","core_access":"access", "core_params":"params", "core_featured":"null", "core_metadata":"metadata", "core_language":"language", "core_images":"null", "core_urls":"null", "core_version":"version", "core_ordering":"null", "core_metakey":"metakey", "core_metadesc":"metadesc", "core_catid":"parent_id", "asset_id":"asset_id"}, "special": {"parent_id":"parent_id","lft":"lft","rgt":"rgt","level":"level","path":"path","extension":"extension","note":"note"}}		{"formFile":"administrator\\/components\\/com_categories\\/forms\\/category.xml", "hideFields":["asset_id","checked_out","checked_out_time","version","lft","rgt","level","path","extension"], "ignoreChanges":["modified_user_id", "modified_time", "checked_out", "checked_out_time", "version", "hits", "path"], "convertToInt":["publish_up", "publish_down"], "displayLookup":[{"sourceColumn":"created_user_id","targetTable":"#__users","targetColumn":"id","displayColumn":"name"},{"sourceColumn":"access","targetTable":"#__viewlevels","targetColumn":"id","displayColumn":"title"},{"sourceColumn":"modified_user_id","targetTable":"#__users","targetColumn":"id","displayColumn":"name"},{"sourceColumn":"parent_id","targetTable":"#__categories","targetColumn":"id","displayColumn":"title"}]}
11	Banner Client	com_banners.client	{"special":{"dbtable":"#__banner_clients","key":"id","type":"ClientTable","prefix":"Joomla\\\\Component\\\\Banners\\\\Administrator\\\\Table\\\\"}}				{"formFile":"administrator\\/components\\/com_banners\\/forms\\/client.xml", "hideFields":["checked_out","checked_out_time"], "ignoreChanges":["checked_out", "checked_out_time"], "convertToInt":[], "displayLookup":[]}
12	User Notes	com_users.note	{"special":{"dbtable":"#__user_notes","key":"id","type":"NoteTable","prefix":"Joomla\\\\Component\\\\Users\\\\Administrator\\\\Table\\\\"}}				{"formFile":"administrator\\/components\\/com_users\\/forms\\/note.xml", "hideFields":["checked_out","checked_out_time", "publish_up", "publish_down"],"ignoreChanges":["modified_user_id", "modified_time", "checked_out", "checked_out_time"], "convertToInt":["publish_up", "publish_down"],"displayLookup":[{"sourceColumn":"catid","targetTable":"#__categories","targetColumn":"id","displayColumn":"title"}, {"sourceColumn":"created_user_id","targetTable":"#__users","targetColumn":"id","displayColumn":"name"}, {"sourceColumn":"user_id","targetTable":"#__users","targetColumn":"id","displayColumn":"name"}, {"sourceColumn":"modified_user_id","targetTable":"#__users","targetColumn":"id","displayColumn":"name"}]}
13	User Notes Category	com_users.category	{"special":{"dbtable":"#__categories","key":"id","type":"CategoryTable","prefix":"Joomla\\\\Component\\\\Categories\\\\Administrator\\\\Table\\\\","config":"array()"},"common":{"dbtable":"#__ucm_content","key":"ucm_id","type":"Corecontent","prefix":"Joomla\\\\CMS\\\\Table\\\\","config":"array()"}}		{"common":{"core_content_item_id":"id","core_title":"title","core_state":"published","core_alias":"alias","core_created_time":"created_time","core_modified_time":"modified_time","core_body":"description", "core_hits":"hits","core_publish_up":"null","core_publish_down":"null","core_access":"access", "core_params":"params", "core_featured":"null", "core_metadata":"metadata", "core_language":"language", "core_images":"null", "core_urls":"null", "core_version":"version", "core_ordering":"null", "core_metakey":"metakey", "core_metadesc":"metadesc", "core_catid":"parent_id", "asset_id":"asset_id"}, "special":{"parent_id":"parent_id","lft":"lft","rgt":"rgt","level":"level","path":"path","extension":"extension","note":"note"}}		{"formFile":"administrator\\/components\\/com_categories\\/forms\\/category.xml", "hideFields":["checked_out","checked_out_time","version","lft","rgt","level","path","extension"], "ignoreChanges":["modified_user_id", "modified_time", "checked_out", "checked_out_time", "version", "hits", "path"], "convertToInt":["publish_up", "publish_down"], "displayLookup":[{"sourceColumn":"created_user_id","targetTable":"#__users","targetColumn":"id","displayColumn":"name"}, {"sourceColumn":"access","targetTable":"#__viewlevels","targetColumn":"id","displayColumn":"title"},{"sourceColumn":"modified_user_id","targetTable":"#__users","targetColumn":"id","displayColumn":"name"},{"sourceColumn":"parent_id","targetTable":"#__categories","targetColumn":"id","displayColumn":"title"}]}
\.


--
-- Data for Name: joomla_contentitem_tag_map; Type: TABLE DATA; Schema: public; Owner: joomla_user
--

COPY public.joomla_contentitem_tag_map (type_alias, core_content_id, content_item_id, tag_id, tag_date, type_id) FROM stdin;
\.


--
-- Data for Name: joomla_extensions; Type: TABLE DATA; Schema: public; Owner: joomla_user
--

COPY public.joomla_extensions (extension_id, package_id, name, type, element, changelogurl, folder, client_id, enabled, access, protected, locked, manifest_cache, params, custom_data, checked_out, checked_out_time, ordering, state, note) FROM stdin;
4	0	com_cache	component	com_cache	\N		1	1	1	1	1	{"name":"com_cache","type":"component","creationDate":"April 2006","author":"Joomla! Project","copyright":"(C) 2006 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"4.0.0","description":"COM_CACHE_XML_DESCRIPTION","group":""}			\N	\N	0	0	\N
8	0	com_cpanel	component	com_cpanel	\N		1	1	1	1	1	{"name":"com_cpanel","type":"component","creationDate":"Jun 2007","author":"Joomla! Project","copyright":"(C) 2007 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"4.0.0","description":"COM_CPANEL_XML_DESCRIPTION","group":""}			\N	\N	0	0	\N
9	0	com_installer	component	com_installer	\N		1	1	1	1	1	{"name":"com_installer","type":"component","creationDate":"April 2006","author":"Joomla! Project","copyright":"(C) 2006 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"4.0.0","description":"COM_INSTALLER_XML_DESCRIPTION","group":""}	{"cachetimeout":"6","minimum_stability":"4"}		\N	\N	0	0	\N
11	0	com_login	component	com_login	\N		1	1	1	1	1	{"name":"com_login","type":"component","creationDate":"April 2006","author":"Joomla! Project","copyright":"(C) 2006 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"4.0.0","description":"COM_LOGIN_XML_DESCRIPTION","group":""}			\N	\N	0	0	\N
12	0	com_media	component	com_media	\N		1	1	0	1	1	{"name":"com_media","type":"component","creationDate":"April 2006","author":"Joomla! Project","copyright":"(C) 2006 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"COM_MEDIA_XML_DESCRIPTION","group":"","filename":"media"}	{"upload_maxsize":"10","file_path":"images","image_path":"images","restrict_uploads":"1","allowed_media_usergroup":"3","restrict_uploads_extensions":"bmp,gif,jpg,jpeg,png,ico,webp,mp3,m4a,mp4a,ogg,mp4,mp4v,mpeg,mov,odg,odp,ods,odt,pdf,png,ppt,txt,xcf,xls,csv","check_mime":"1","image_extensions":"bmp,gif,jpg,png,jpeg,webp","audio_extensions":"mp3,m4a,mp4a,ogg","video_extensions":"mp4,mp4v,mpeg,mov,webm","doc_extensions":"odg,odp,ods,odt,pdf,ppt,txt,xcf,xls,csv","ignore_extensions":"","upload_mime":"image\\/jpeg,image\\/gif,image\\/png,image\\/bmp,image\\/webp,audio\\/ogg,audio\\/mpeg,audio\\/mp4,video\\/mp4,video\\/webm,video\\/mpeg,video\\/quicktime,application\\/msword,application\\/excel,application\\/pdf,application\\/powerpoint,text\\/plain,application\\/x-zip"}		\N	\N	0	0	\N
13	0	com_menus	component	com_menus	\N		1	1	1	1	1	{"name":"com_menus","type":"component","creationDate":"April 2006","author":"Joomla! Project","copyright":"(C) 2006 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"4.0.0","description":"COM_MENUS_XML_DESCRIPTION","group":"","filename":"menus"}	{"page_title":"","show_page_heading":0,"page_heading":"","pageclass_sfx":""}		\N	\N	0	0	\N
14	0	com_messages	component	com_messages	\N		1	1	1	1	1	{"name":"com_messages","type":"component","creationDate":"April 2006","author":"Joomla! Project","copyright":"(C) 2006 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"4.0.0","description":"COM_MESSAGES_XML_DESCRIPTION","group":""}			\N	\N	0	0	\N
17	0	com_plugins	component	com_plugins	\N		1	1	1	1	1	{"name":"com_plugins","type":"component","creationDate":"April 2006","author":"Joomla! Project","copyright":"(C) 2006 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"4.0.0","description":"COM_PLUGINS_XML_DESCRIPTION","group":""}			\N	\N	0	0	\N
18	0	com_templates	component	com_templates	\N		1	1	1	1	1	{"name":"com_templates","type":"component","creationDate":"April 2006","author":"Joomla! Project","copyright":"(C) 2006 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"4.0.0","description":"COM_TEMPLATES_XML_DESCRIPTION","group":""}	{"template_positions_display":"0","upload_limit":"10","image_formats":"gif,bmp,jpg,jpeg,png,webp","source_formats":"txt,less,ini,xml,js,php,css,scss,sass,json","font_formats":"woff,ttf,otf","compressed_formats":"zip"}		\N	\N	0	0	\N
61	0	mod_latest	module	mod_latest	\N		1	1	1	0	1	{"name":"mod_latest","type":"module","creationDate":"July 2004","author":"Joomla! Project","copyright":"(C) 2005 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"MOD_LATEST_XML_DESCRIPTION","group":"","filename":"mod_latest"}			\N	\N	0	0	\N
62	0	mod_logged	module	mod_logged	\N		1	1	1	0	1	{"name":"mod_logged","type":"module","creationDate":"January 2005","author":"Joomla! Project","copyright":"(C) 2005 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"MOD_LOGGED_XML_DESCRIPTION","group":"","filename":"mod_logged"}			\N	\N	0	0	\N
63	0	mod_login	module	mod_login	\N		1	1	1	0	1	{"name":"mod_login","type":"module","creationDate":"March 2005","author":"Joomla! Project","copyright":"(C) 2005 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"MOD_LOGIN_XML_DESCRIPTION","group":"","filename":"mod_login"}			\N	\N	0	0	\N
21	0	com_redirect	component	com_redirect	\N		1	1	0	0	1	{"name":"com_redirect","type":"component","creationDate":"April 2006","author":"Joomla! Project","copyright":"(C) 2006 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"4.0.0","description":"COM_REDIRECT_XML_DESCRIPTION","group":""}			\N	\N	0	0	\N
24	0	com_joomlaupdate	component	com_joomlaupdate	\N		1	1	0	1	1	{"name":"com_joomlaupdate","type":"component","creationDate":"February 2012","author":"Joomla! Project","copyright":"(C) 2012 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"4.0.2","description":"COM_JOOMLAUPDATE_XML_DESCRIPTION","group":""}	{"updatesource":"default","customurl":""}		\N	\N	0	0	\N
78	0	mod_tags_similar	module	mod_tags_similar	\N		0	1	1	0	1	{"name":"mod_tags_similar","type":"module","creationDate":"January 2013","author":"Joomla! Project","copyright":"(C) 2013 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.1.0","description":"MOD_TAGS_SIMILAR_XML_DESCRIPTION","group":"","filename":"mod_tags_similar"}	{"maximum":"5","matchtype":"any","owncache":"1"}		\N	\N	0	0	\N
25	0	com_tags	component	com_tags	\N		1	1	1	0	1	{"name":"com_tags","type":"component","creationDate":"December 2013","author":"Joomla! Project","copyright":"(C) 2013 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"4.0.0","description":"COM_TAGS_XML_DESCRIPTION","group":"","filename":"tags"}	{"tag_layout":"_:default","save_history":"1","history_limit":5,"show_tag_title":"0","tag_list_show_tag_image":"0","tag_list_show_tag_description":"0","tag_list_image":"","tag_list_orderby":"title","tag_list_orderby_direction":"ASC","show_headings":"0","tag_list_show_date":"0","tag_list_show_item_image":"0","tag_list_show_item_description":"0","tag_list_item_maximum_characters":0,"return_any_or_all":"1","include_children":"0","maximum":200,"tag_list_language_filter":"all","tags_layout":"_:default","all_tags_orderby":"title","all_tags_orderby_direction":"ASC","all_tags_show_tag_image":"0","all_tags_show_tag_description":"0","all_tags_tag_maximum_characters":20,"all_tags_show_tag_hits":"0","filter_field":"1","show_pagination_limit":"1","show_pagination":"2","show_pagination_results":"1","tag_field_ajax_mode":"1","show_feed_link":"1"}		\N	\N	0	0	\N
26	0	com_contenthistory	component	com_contenthistory	\N		1	1	1	0	1	{"name":"com_contenthistory","type":"component","creationDate":"May 2013","author":"Joomla! Project","copyright":"(C) 2013 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"4.0.0","description":"COM_CONTENTHISTORY_XML_DESCRIPTION","group":"","filename":"contenthistory"}			\N	\N	0	0	\N
27	0	com_ajax	component	com_ajax	\N		1	1	1	1	1	{"name":"com_ajax","type":"component","creationDate":"August 2013","author":"Joomla! Project","copyright":"(C) 2013 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"4.0.0","description":"COM_AJAX_XML_DESCRIPTION","group":"","filename":"ajax"}			\N	\N	0	0	\N
28	0	com_postinstall	component	com_postinstall	\N		1	1	1	1	1	{"name":"com_postinstall","type":"component","creationDate":"September 2013","author":"Joomla! Project","copyright":"(C) 2013 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"4.0.0","description":"COM_POSTINSTALL_XML_DESCRIPTION","group":""}			\N	\N	0	0	\N
31	0	com_privacy	component	com_privacy	\N		1	1	1	0	1	{"name":"com_privacy","type":"component","creationDate":"May 2018","author":"Joomla! Project","copyright":"(C) 2018 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.9.0","description":"COM_PRIVACY_XML_DESCRIPTION","group":"","filename":"privacy"}			\N	\N	0	0	\N
33	0	com_workflow	component	com_workflow	\N		1	1	0	1	1	{"name":"com_workflow","type":"component","creationDate":"June 2017","author":"Joomla! Project","copyright":"(C) 2018 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"4.0.0","description":"COM_WORKFLOW_XML_DESCRIPTION","group":""}	{}		\N	\N	0	0	\N
39	0	mod_articles_popular	module	mod_articles_popular	\N		0	1	1	0	1	{"name":"mod_articles_popular","type":"module","creationDate":"July 2006","author":"Joomla! Project","copyright":"(C) 2006 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"MOD_POPULAR_XML_DESCRIPTION","group":"","filename":"mod_articles_popular"}			\N	\N	0	0	\N
42	0	mod_custom	module	mod_custom	\N		0	1	1	0	1	{"name":"mod_custom","type":"module","creationDate":"July 2004","author":"Joomla! Project","copyright":"(C) 2005 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"MOD_CUSTOM_XML_DESCRIPTION","group":"","filename":"mod_custom"}			\N	\N	0	0	\N
46	0	mod_menu	module	mod_menu	\N		0	1	1	0	1	{"name":"mod_menu","type":"module","creationDate":"July 2004","author":"Joomla! Project","copyright":"(C) 2005 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"MOD_MENU_XML_DESCRIPTION","group":"","filename":"mod_menu"}			\N	\N	0	0	\N
49	0	mod_related_items	module	mod_related_items	\N		0	1	1	0	1	{"name":"mod_related_items","type":"module","creationDate":"July 2004","author":"Joomla! Project","copyright":"(C) 2005 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"MOD_RELATED_XML_DESCRIPTION","group":"","filename":"mod_related_items"}			\N	\N	0	0	\N
53	0	mod_whosonline	module	mod_whosonline	\N		0	1	1	0	1	{"name":"mod_whosonline","type":"module","creationDate":"July 2004","author":"Joomla! Project","copyright":"(C) 2005 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"MOD_WHOSONLINE_XML_DESCRIPTION","group":"","filename":"mod_whosonline"}			\N	\N	0	0	\N
57	0	mod_languages	module	mod_languages	\N		0	1	1	0	1	{"name":"mod_languages","type":"module","creationDate":"February 2010","author":"Joomla! Project","copyright":"(C) 2010 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.5.0","description":"MOD_LANGUAGES_XML_DESCRIPTION","group":"","filename":"mod_languages"}			\N	\N	0	0	\N
60	0	mod_feed	module	mod_feed	\N		1	1	1	0	1	{"name":"mod_feed","type":"module","creationDate":"July 2005","author":"Joomla! Project","copyright":"(C) 2005 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"MOD_FEED_XML_DESCRIPTION","group":"","filename":"mod_feed"}			\N	\N	0	0	\N
68	0	mod_frontend	module	mod_frontend	\N		1	1	1	0	1	{"name":"mod_frontend","type":"module","creationDate":"July 2019","author":"Joomla! Project","copyright":"(C) 2019 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"4.0.0","description":"MOD_FRONTEND_XML_DESCRIPTION","group":"","filename":"mod_frontend"}			\N	\N	0	0	\N
71	0	mod_user	module	mod_user	\N		1	1	1	0	1	{"name":"mod_user","type":"module","creationDate":"July 2019","author":"Joomla! Project","copyright":"(C) 2019 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"4.0.0","description":"MOD_USER_XML_DESCRIPTION","group":"","filename":"mod_user"}			\N	\N	0	0	\N
75	0	mod_version	module	mod_version	\N		1	1	1	0	1	{"name":"mod_version","type":"module","creationDate":"January 2012","author":"Joomla! Project","copyright":"(C) 2012 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"MOD_VERSION_XML_DESCRIPTION","group":"","filename":"mod_version"}	{"cache":"0"}		\N	\N	0	0	\N
80	0	mod_latestactions	module	mod_latestactions	\N		1	1	1	0	1	{"name":"mod_latestactions","type":"module","creationDate":"May 2018","author":"Joomla! Project","copyright":"(C) 2018 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.9.0","description":"MOD_LATESTACTIONS_XML_DESCRIPTION","group":"","filename":"mod_latestactions"}	{}		\N	\N	0	0	\N
84	0	plg_actionlog_joomla	plugin	joomla	\N	actionlog	0	1	1	0	1	{"name":"plg_actionlog_joomla","type":"plugin","creationDate":"May 2018","author":"Joomla! Project","copyright":"(C) 2018 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.9.0","description":"PLG_ACTIONLOG_JOOMLA_XML_DESCRIPTION","group":"","filename":"joomla"}	{}		\N	\N	1	0	\N
87	0	plg_authentication_cookie	plugin	cookie	\N	authentication	0	1	1	0	1	{"name":"plg_authentication_cookie","type":"plugin","creationDate":"July 2013","author":"Joomla! Project","copyright":"(C) 2013 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"PLG_AUTHENTICATION_COOKIE_XML_DESCRIPTION","group":"","filename":"cookie"}			\N	\N	1	0	\N
90	0	plg_behaviour_taggable	plugin	taggable	\N	behaviour	0	1	1	0	1	{"name":"plg_behaviour_taggable","type":"plugin","creationDate":"August 2015","author":"Joomla! Project","copyright":"(C) 2016 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"4.0.0","description":"PLG_BEHAVIOUR_TAGGABLE_XML_DESCRIPTION","group":"","filename":"taggable"}	{}		\N	\N	1	0	\N
92	0	plg_captcha_recaptcha	plugin	recaptcha	\N	captcha	0	0	1	0	1	{"name":"plg_captcha_recaptcha","type":"plugin","creationDate":"December 2011","author":"Joomla! Project","copyright":"(C) 2011 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.4.0","description":"PLG_CAPTCHA_RECAPTCHA_XML_DESCRIPTION","group":"","filename":"recaptcha"}	{"public_key":"","private_key":"","theme":"clean"}		\N	\N	1	0	\N
95	0	plg_content_contact	plugin	contact	\N	content	0	1	1	0	1	{"name":"plg_content_contact","type":"plugin","creationDate":"January 2014","author":"Joomla! Project","copyright":"(C) 2014 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.2.2","description":"PLG_CONTENT_CONTACT_XML_DESCRIPTION","group":"","filename":"contact"}			\N	\N	2	0	\N
97	0	plg_content_fields	plugin	fields	\N	content	0	1	1	0	1	{"name":"plg_content_fields","type":"plugin","creationDate":"February 2017","author":"Joomla! Project","copyright":"(C) 2017 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.7.0","description":"PLG_CONTENT_FIELDS_XML_DESCRIPTION","group":"","filename":"fields"}			\N	\N	4	0	\N
101	0	plg_content_pagebreak	plugin	pagebreak	\N	content	0	1	1	0	1	{"name":"plg_content_pagebreak","type":"plugin","creationDate":"November 2005","author":"Joomla! Project","copyright":"(C) 2005 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"PLG_CONTENT_PAGEBREAK_XML_DESCRIPTION","group":"","filename":"pagebreak"}	{"title":"1","multipage_toc":"1","showall":"1"}		\N	\N	8	0	\N
104	0	plg_editors-xtd_article	plugin	article	\N	editors-xtd	0	1	1	0	1	{"name":"plg_editors-xtd_article","type":"plugin","creationDate":"October 2009","author":"Joomla! Project","copyright":"(C) 2009 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"PLG_ARTICLE_XML_DESCRIPTION","group":"","filename":"article"}			\N	\N	1	0	\N
107	0	plg_editors-xtd_image	plugin	image	\N	editors-xtd	0	1	1	0	1	{"name":"plg_editors-xtd_image","type":"plugin","creationDate":"August 2004","author":"Joomla! Project","copyright":"(C) 2005 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"PLG_IMAGE_XML_DESCRIPTION","group":"","filename":"image"}			\N	\N	4	0	\N
111	0	plg_editors-xtd_readmore	plugin	readmore	\N	editors-xtd	0	1	1	0	1	{"name":"plg_editors-xtd_readmore","type":"plugin","creationDate":"March 2006","author":"Joomla! Project","copyright":"(C) 2006 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"PLG_READMORE_XML_DESCRIPTION","group":"","filename":"readmore"}			\N	\N	8	0	\N
113	0	plg_editors_none	plugin	none	\N	editors	0	1	1	1	1	{"name":"plg_editors_none","type":"plugin","creationDate":"September 2005","author":"Joomla! Project","copyright":"(C) 2005 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"PLG_NONE_XML_DESCRIPTION","group":"","filename":"none"}			\N	\N	2	0	\N
215	212	English (en-GB)	language	en-GB	\N		3	1	1	1	1	{"name":"English (en-GB)","type":"language","creationDate":"September 2021","author":"Joomla! Project","copyright":"(C) 2020 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"4.0.3","description":"en-GB api language","group":""}			\N	\N	0	0	\N
115	0	plg_extension_finder	plugin	finder	\N	extension	0	1	1	0	1	{"name":"plg_extension_finder","type":"plugin","creationDate":"June 2018","author":"Joomla! Project","copyright":"(C) 2019 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"4.0.0","description":"PLG_EXTENSION_FINDER_XML_DESCRIPTION","group":"","filename":"finder"}			\N	\N	1	0	\N
116	0	plg_extension_joomla	plugin	joomla	\N	extension	0	1	1	0	1	{"name":"plg_extension_joomla","type":"plugin","creationDate":"May 2010","author":"Joomla! Project","copyright":"(C) 2010 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"PLG_EXTENSION_JOOMLA_XML_DESCRIPTION","group":"","filename":"joomla"}			\N	\N	2	0	\N
117	0	plg_extension_namespacemap	plugin	namespacemap	\N	extension	0	1	1	1	1	{"name":"plg_extension_namespacemap","type":"plugin","creationDate":"May 2017","author":"Joomla! Project","copyright":"(C) 2017 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"4.0.0","description":"PLG_EXTENSION_NAMESPACEMAP_XML_DESCRIPTION","group":"","filename":"namespacemap"}	{}		\N	\N	3	0	\N
120	0	plg_fields_color	plugin	color	\N	fields	0	1	1	0	1	{"name":"plg_fields_color","type":"plugin","creationDate":"March 2016","author":"Joomla! Project","copyright":"(C) 2016 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.7.0","description":"PLG_FIELDS_COLOR_XML_DESCRIPTION","group":"","filename":"color"}			\N	\N	3	0	\N
124	0	plg_fields_list	plugin	list	\N	fields	0	1	1	0	1	{"name":"plg_fields_list","type":"plugin","creationDate":"March 2016","author":"Joomla! Project","copyright":"(C) 2016 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.7.0","description":"PLG_FIELDS_LIST_XML_DESCRIPTION","group":"","filename":"list"}			\N	\N	7	0	\N
127	0	plg_fields_sql	plugin	sql	\N	fields	0	1	1	0	1	{"name":"plg_fields_sql","type":"plugin","creationDate":"March 2016","author":"Joomla! Project","copyright":"(C) 2016 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.7.0","description":"PLG_FIELDS_SQL_XML_DESCRIPTION","group":"","filename":"sql"}			\N	\N	10	0	\N
130	0	plg_fields_textarea	plugin	textarea	\N	fields	0	1	1	0	1	{"name":"plg_fields_textarea","type":"plugin","creationDate":"March 2016","author":"Joomla! Project","copyright":"(C) 2016 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.7.0","description":"PLG_FIELDS_TEXTAREA_XML_DESCRIPTION","group":"","filename":"textarea"}			\N	\N	13	0	\N
134	0	plg_filesystem_local	plugin	local	\N	filesystem	0	1	1	0	1	{"name":"plg_filesystem_local","type":"plugin","creationDate":"April 2017","author":"Joomla! Project","copyright":"(C) 2017 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"4.0.0","description":"PLG_FILESYSTEM_LOCAL_XML_DESCRIPTION","group":"","filename":"local"}	{}		\N	\N	1	0	\N
137	0	plg_finder_content	plugin	content	\N	finder	0	1	1	0	1	{"name":"plg_finder_content","type":"plugin","creationDate":"August 2011","author":"Joomla! Project","copyright":"(C) 2011 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"PLG_FINDER_CONTENT_XML_DESCRIPTION","group":"","filename":"content"}			\N	\N	3	0	\N
141	0	plg_installer_override	plugin	override	\N	installer	0	1	1	0	1	{"name":"plg_installer_override","type":"plugin","creationDate":"June 2018","author":"Joomla! Project","copyright":"(C) 2018 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"4.0.0","description":"PLG_INSTALLER_OVERRIDE_PLUGIN_XML_DESCRIPTION","group":"","filename":"override"}			\N	\N	4	0	\N
144	0	plg_installer_webinstaller	plugin	webinstaller	\N	installer	0	1	1	0	1	{"name":"plg_installer_webinstaller","type":"plugin","creationDate":"April 2017","author":"Joomla! Project","copyright":"(C) 2018 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"4.0.0","description":"PLG_INSTALLER_WEBINSTALLER_XML_DESCRIPTION","group":"","filename":"webinstaller"}	{"tab_position":"1"}		\N	\N	5	0	\N
147	0	plg_media-action_rotate	plugin	rotate	\N	media-action	0	1	1	0	1	{"name":"plg_media-action_rotate","type":"plugin","creationDate":"January 2017","author":"Joomla! Project","copyright":"(C) 2017 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"4.0.0","description":"PLG_MEDIA-ACTION_ROTATE_XML_DESCRIPTION","group":"","filename":"rotate"}	{}		\N	\N	3	0	\N
151	0	plg_privacy_content	plugin	content	\N	privacy	0	1	1	0	1	{"name":"plg_privacy_content","type":"plugin","creationDate":"July 2018","author":"Joomla! Project","copyright":"(C) 2018 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.9.0","description":"PLG_PRIVACY_CONTENT_XML_DESCRIPTION","group":"","filename":"content"}	{}		\N	\N	4	0	\N
154	0	plg_quickicon_joomlaupdate	plugin	joomlaupdate	\N	quickicon	0	1	1	0	1	{"name":"plg_quickicon_joomlaupdate","type":"plugin","creationDate":"August 2011","author":"Joomla! Project","copyright":"(C) 2011 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"PLG_QUICKICON_JOOMLAUPDATE_XML_DESCRIPTION","group":"","filename":"joomlaupdate"}			\N	\N	1	0	\N
157	0	plg_quickicon_downloadkey	plugin	downloadkey	\N	quickicon	0	1	1	0	1	{"name":"plg_quickicon_downloadkey","type":"plugin","creationDate":"October 2019","author":"Joomla! Project","copyright":"(C) 2019 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"4.0.0","description":"PLG_QUICKICON_DOWNLOADKEY_XML_DESCRIPTION","group":"","filename":"downloadkey"}			\N	\N	4	0	\N
160	0	plg_sampledata_blog	plugin	blog	\N	sampledata	0	1	1	0	1	{"name":"plg_sampledata_blog","type":"plugin","creationDate":"July 2017","author":"Joomla! Project","copyright":"(C) 2017 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.8.0","description":"PLG_SAMPLEDATA_BLOG_XML_DESCRIPTION","group":"","filename":"blog"}			\N	\N	1	0	\N
168	0	plg_system_httpheaders	plugin	httpheaders	\N	system	0	1	1	0	1	{"name":"plg_system_httpheaders","type":"plugin","creationDate":"October 2017","author":"Joomla! Project","copyright":"(C) 2018 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"4.0.0","description":"PLG_SYSTEM_HTTPHEADERS_XML_DESCRIPTION","group":"","filename":"httpheaders"}	{}		\N	\N	7	0	\N
171	0	plg_system_log	plugin	log	\N	system	0	1	1	0	1	{"name":"plg_system_log","type":"plugin","creationDate":"April 2007","author":"Joomla! Project","copyright":"(C) 2007 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"PLG_LOG_XML_DESCRIPTION","group":"","filename":"log"}			\N	\N	10	0	\N
174	0	plg_system_privacyconsent	plugin	privacyconsent	\N	system	0	0	1	0	1	{"name":"plg_system_privacyconsent","type":"plugin","creationDate":"April 2018","author":"Joomla! Project","copyright":"(C) 2018 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.9.0","description":"PLG_SYSTEM_PRIVACYCONSENT_XML_DESCRIPTION","group":"","filename":"privacyconsent"}	{}		\N	\N	13	0	\N
178	0	plg_system_sessiongc	plugin	sessiongc	\N	system	0	1	1	0	1	{"name":"plg_system_sessiongc","type":"plugin","creationDate":"February 2018","author":"Joomla! Project","copyright":"(C) 2018 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.8.6","description":"PLG_SYSTEM_SESSIONGC_XML_DESCRIPTION","group":"","filename":"sessiongc"}			\N	\N	17	0	\N
185	0	plg_user_contactcreator	plugin	contactcreator	\N	user	0	0	1	0	1	{"name":"plg_user_contactcreator","type":"plugin","creationDate":"August 2009","author":"Joomla! Project","copyright":"(C) 2009 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"PLG_CONTACTCREATOR_XML_DESCRIPTION","group":"","filename":"contactcreator"}	{"autowebpage":"","category":"4","autopublish":"0"}		\N	\N	1	0	\N
188	0	plg_user_terms	plugin	terms	\N	user	0	0	1	0	1	{"name":"plg_user_terms","type":"plugin","creationDate":"June 2018","author":"Joomla! Project","copyright":"(C) 2018 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.9.0","description":"PLG_USER_TERMS_XML_DESCRIPTION","group":"","filename":"terms"}	{}		\N	\N	4	0	\N
189	0	plg_user_token	plugin	token	\N	user	0	1	1	0	1	{"name":"plg_user_token","type":"plugin","creationDate":"November 2019","author":"Joomla! Project","copyright":"(C) 2020 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.9.0","description":"PLG_USER_TOKEN_XML_DESCRIPTION","group":"","filename":"token"}	{}		\N	\N	5	0	\N
190	0	plg_webservices_banners	plugin	banners	\N	webservices	0	1	1	0	1	{"name":"plg_webservices_banners","type":"plugin","creationDate":"September 2019","author":"Joomla! Project","copyright":"(C) 2019 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"4.0.0","description":"PLG_WEBSERVICES_BANNERS_XML_DESCRIPTION","group":"","filename":"banners"}	{}		\N	\N	1	0	\N
192	0	plg_webservices_contact	plugin	contact	\N	webservices	0	1	1	0	1	{"name":"plg_webservices_contact","type":"plugin","creationDate":"September 2019","author":"Joomla! Project","copyright":"(C) 2019 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"4.0.0","description":"PLG_WEBSERVICES_CONTACT_XML_DESCRIPTION","group":"","filename":"contact"}	{}		\N	\N	3	0	\N
196	0	plg_webservices_menus	plugin	menus	\N	webservices	0	1	1	0	1	{"name":"plg_webservices_menus","type":"plugin","creationDate":"September 2019","author":"Joomla! Project","copyright":"(C) 2019 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"4.0.0","description":"PLG_WEBSERVICES_MENUS_XML_DESCRIPTION","group":"","filename":"menus"}	{}		\N	\N	7	0	\N
199	0	plg_webservices_newsfeeds	plugin	newsfeeds	\N	webservices	0	1	1	0	1	{"name":"plg_webservices_newsfeeds","type":"plugin","creationDate":"September 2019","author":"Joomla! Project","copyright":"(C) 2019 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"4.0.0","description":"PLG_WEBSERVICES_NEWSFEEDS_XML_DESCRIPTION","group":"","filename":"newsfeeds"}	{}		\N	\N	10	0	\N
202	0	plg_webservices_redirect	plugin	redirect	\N	webservices	0	1	1	0	1	{"name":"plg_webservices_redirect","type":"plugin","creationDate":"September 2019","author":"Joomla! Project","copyright":"(C) 2019 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"4.0.0","description":"PLG_WEBSERVICES_REDIRECT_XML_DESCRIPTION","group":"","filename":"redirect"}	{}		\N	\N	13	0	\N
205	0	plg_webservices_users	plugin	users	\N	webservices	0	1	1	0	1	{"name":"plg_webservices_users","type":"plugin","creationDate":"September 2019","author":"Joomla! Project","copyright":"(C) 2019 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"4.0.0","description":"PLG_WEBSERVICES_USERS_XML_DESCRIPTION","group":"","filename":"users"}	{}		\N	\N	16	0	\N
209	0	atum	template	atum	\N		1	1	1	0	1	{"name":"atum","type":"template","creationDate":"September 2016","author":"Joomla! Project","copyright":"(C) 2016 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"","version":"1.0","description":"TPL_ATUM_XML_DESCRIPTION","group":"","filename":"templateDetails"}			\N	\N	0	0	\N
211	0	files_joomla	file	joomla	\N		0	1	1	1	1	{"name":"files_joomla","type":"file","creationDate":"September 2021","author":"Joomla! Project","copyright":"(C) 2019 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"4.0.3","description":"FILES_JOOMLA_XML_DESCRIPTION","group":""}			\N	\N	0	0	\N
214	212	English (en-GB)	language	en-GB	\N		1	1	1	1	1	{"name":"English (en-GB)","type":"language","creationDate":"September 2021","author":"Joomla! Project","copyright":"(C) 2005 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"4.0.3","description":"en-GB administrator language","group":""}			\N	\N	0	0	\N
1	0	com_wrapper	component	com_wrapper	\N		1	1	1	0	1	{"name":"com_wrapper","type":"component","creationDate":"April 2006","author":"Joomla! Project","copyright":"(C) 2007 Open Source Matters, Inc.\\n\\t","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"4.0.0","description":"COM_WRAPPER_XML_DESCRIPTION","group":"","filename":"wrapper"}			\N	\N	0	0	\N
2	0	com_admin	component	com_admin	\N		1	1	1	1	1	{"name":"com_admin","type":"component","creationDate":"April 2006","author":"Joomla! Project","copyright":"(C) 2006 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"4.0.0","description":"COM_ADMIN_XML_DESCRIPTION","group":""}			\N	\N	0	0	\N
3	0	com_banners	component	com_banners	\N		1	1	1	0	1	{"name":"com_banners","type":"component","creationDate":"April 2006","author":"Joomla! Project","copyright":"(C) 2006 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"4.0.0","description":"COM_BANNERS_XML_DESCRIPTION","group":"","filename":"banners"}	{"purchase_type":"3","track_impressions":"0","track_clicks":"0","metakey_prefix":"","save_history":"1","history_limit":10}		\N	\N	0	0	\N
5	0	com_categories	component	com_categories	\N		1	1	1	1	1	{"name":"com_categories","type":"component","creationDate":"December 2007","author":"Joomla! Project","copyright":"(C) 2007 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"4.0.0","description":"COM_CATEGORIES_XML_DESCRIPTION","group":""}			\N	\N	0	0	\N
6	0	com_checkin	component	com_checkin	\N		1	1	1	1	1	{"name":"com_checkin","type":"component","creationDate":"April 2006","author":"Joomla! Project","copyright":"(C) 2006 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"4.0.0","description":"COM_CHECKIN_XML_DESCRIPTION","group":""}			\N	\N	0	0	\N
58	0	mod_finder	module	mod_finder	\N		0	1	0	0	1	{"name":"mod_finder","type":"module","creationDate":"August 2011","author":"Joomla! Project","copyright":"(C) 2011 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"MOD_FINDER_XML_DESCRIPTION","group":"","filename":"mod_finder"}			\N	\N	0	0	\N
7	0	com_contact	component	com_contact	\N		1	1	1	0	1	{"name":"com_contact","type":"component","creationDate":"April 2006","author":"Joomla! Project","copyright":"(C) 2006 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"4.0.0","description":"COM_CONTACT_XML_DESCRIPTION","group":"","filename":"contact"}	{"contact_layout":"_:default","show_contact_category":"hide","save_history":"1","history_limit":10,"show_contact_list":"0","presentation_style":"sliders","show_tags":"1","show_info":"1","show_name":"1","show_position":"1","show_email":"0","show_street_address":"1","show_suburb":"1","show_state":"1","show_postcode":"1","show_country":"1","show_telephone":"1","show_mobile":"1","show_fax":"1","show_webpage":"1","show_image":"1","show_misc":"1","image":"","allow_vcard":"0","show_articles":"0","articles_display_num":"10","show_profile":"0","show_user_custom_fields":["-1"],"show_links":"0","linka_name":"","linkb_name":"","linkc_name":"","linkd_name":"","linke_name":"","contact_icons":"0","icon_address":"","icon_email":"","icon_telephone":"","icon_mobile":"","icon_fax":"","icon_misc":"","category_layout":"_:default","show_category_title":"1","show_description":"1","show_description_image":"0","maxLevel":"-1","show_subcat_desc":"1","show_empty_categories":"0","show_cat_items":"1","show_cat_tags":"1","show_base_description":"1","maxLevelcat":"-1","show_subcat_desc_cat":"1","show_empty_categories_cat":"0","show_cat_items_cat":"1","filter_field":"0","show_pagination_limit":"0","show_headings":"1","show_image_heading":"0","show_position_headings":"1","show_email_headings":"0","show_telephone_headings":"1","show_mobile_headings":"0","show_fax_headings":"0","show_suburb_headings":"1","show_state_headings":"1","show_country_headings":"1","show_pagination":"2","show_pagination_results":"1","initial_sort":"ordering","captcha":"","show_email_form":"1","show_email_copy":"0","banned_email":"","banned_subject":"","banned_text":"","validate_session":"1","custom_reply":"0","redirect":"","show_feed_link":"1","sef_ids":1,"custom_fields_enable":"1"}		\N	\N	0	0	\N
15	0	com_modules	component	com_modules	\N		1	1	1	1	1	{"name":"com_modules","type":"component","creationDate":"April 2006","author":"Joomla! Project","copyright":"(C) 2006 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"4.0.0","description":"COM_MODULES_XML_DESCRIPTION","group":"","filename":"modules"}			\N	\N	0	0	\N
16	0	com_newsfeeds	component	com_newsfeeds	\N		1	1	1	0	1	{"name":"com_newsfeeds","type":"component","creationDate":"April 2006","author":"Joomla! Project","copyright":"(C) 2006 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"4.0.0","description":"COM_NEWSFEEDS_XML_DESCRIPTION","group":"","filename":"newsfeeds"}	{"newsfeed_layout":"_:default","save_history":"1","history_limit":5,"show_feed_image":"1","show_feed_description":"1","show_item_description":"1","feed_character_count":"0","feed_display_order":"des","float_first":"right","float_second":"right","show_tags":"1","category_layout":"_:default","show_category_title":"1","show_description":"1","show_description_image":"1","maxLevel":"-1","show_empty_categories":"0","show_subcat_desc":"1","show_cat_items":"1","show_cat_tags":"1","show_base_description":"1","maxLevelcat":"-1","show_empty_categories_cat":"0","show_subcat_desc_cat":"1","show_cat_items_cat":"1","filter_field":"1","show_pagination_limit":"1","show_headings":"1","show_articles":"0","show_link":"1","show_pagination":"1","show_pagination_results":"1","sef_ids":1}		\N	\N	0	0	\N
19	0	com_content	component	com_content	\N		1	1	0	1	1	{"name":"com_content","type":"component","creationDate":"April 2006","author":"Joomla! Project","copyright":"(C) 2006 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"4.0.0","description":"COM_CONTENT_XML_DESCRIPTION","group":"","filename":"content"}	{"article_layout":"_:default","show_title":"1","link_titles":"1","show_intro":"1","show_category":"1","link_category":"1","show_parent_category":"0","link_parent_category":"0","show_author":"1","link_author":"0","show_create_date":"0","show_modify_date":"0","show_publish_date":"1","show_item_navigation":"1","show_vote":"0","show_tags":"1","show_readmore":"1","show_readmore_title":"1","readmore_limit":"100","record_hits":"1","show_hits":"1","show_noauth":"0","show_publishing_options":"1","show_article_options":"1","save_history":"1","history_limit":10,"show_urls_images_frontend":"0","show_urls_images_backend":"1","targeta":0,"targetb":0,"targetc":0,"float_intro":"left","float_fulltext":"left","category_layout":"_:blog","show_category_title":"0","show_description":"0","show_description_image":"0","maxLevel":"1","show_empty_categories":"0","show_no_articles":"1","show_subcat_desc":"1","show_cat_num_articles":"0","show_base_description":"1","maxLevelcat":"-1","show_empty_categories_cat":"0","show_subcat_desc_cat":"1","show_cat_num_articles_cat":"1","num_leading_articles":"1","num_intro_articles":"4","num_links":"4","show_subcategory_content":"0","link_intro_image":"0","show_pagination_limit":"1","filter_field":"hide","show_headings":"1","list_show_date":"0","date_format":"","list_show_hits":"1","list_show_author":"1","orderby_pri":"order","orderby_sec":"rdate","order_date":"published","show_pagination":"2","show_pagination_results":"1","show_feed_link":"1","feed_summary":"0","sef_ids":1}		\N	\N	0	0	\N
22	0	com_users	component	com_users	\N		1	1	0	1	1	{"name":"com_users","type":"component","creationDate":"April 2006","author":"Joomla! Project","copyright":"(C) 2006 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"4.0.0","description":"COM_USERS_XML_DESCRIPTION","group":"","filename":"users"}	{"allowUserRegistration":"0","new_usertype":"2","guest_usergroup":"9","sendpassword":"0","useractivation":"2","mail_to_admin":"1","captcha":"","frontend_userparams":"1","site_language":"0","change_login_name":"0","reset_count":"10","reset_time":"1","minimum_length":"12","minimum_integers":"0","minimum_symbols":"0","minimum_uppercase":"0","save_history":"1","history_limit":5,"mailSubjectPrefix":"","mailBodySuffix":""}		\N	\N	0	0	\N
23	0	com_finder	component	com_finder	\N		1	1	0	0	1	{"name":"com_finder","type":"component","creationDate":"August 2011","author":"Joomla! Project","copyright":"(C) 2011 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"4.0.0","description":"COM_FINDER_XML_DESCRIPTION","group":"","filename":"finder"}	{"enabled":"0","show_description":"1","description_length":255,"allow_empty_query":"0","show_url":"1","show_autosuggest":"1","show_suggested_query":"1","show_explained_query":"1","show_advanced":"1","show_advanced_tips":"1","expand_advanced":"0","show_date_filters":"0","sort_order":"relevance","sort_direction":"desc","highlight_terms":"1","opensearch_name":"","opensearch_description":"","batch_size":"50","memory_table_limit":30000,"title_multiplier":"1.7","text_multiplier":"0.7","meta_multiplier":"1.2","path_multiplier":"2.0","misc_multiplier":"0.3","stem":"1","stemmer":"snowball","enable_logging":"0"}		\N	\N	0	0	\N
29	0	com_fields	component	com_fields	\N		1	1	1	0	1	{"name":"com_fields","type":"component","creationDate":"March 2016","author":"Joomla! Project","copyright":"(C) 2016 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"4.0.0","description":"COM_FIELDS_XML_DESCRIPTION","group":"","filename":"fields"}			\N	\N	0	0	\N
30	0	com_associations	component	com_associations	\N		1	1	1	0	1	{"name":"com_associations","type":"component","creationDate":"January 2017","author":"Joomla! Project","copyright":"(C) 2017 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"4.0.0","description":"COM_ASSOCIATIONS_XML_DESCRIPTION","group":""}			\N	\N	0	0	\N
56	0	mod_articles_categories	module	mod_articles_categories	\N		0	1	1	0	1	{"name":"mod_articles_categories","type":"module","creationDate":"February 2010","author":"Joomla! Project","copyright":"(C) 2010 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"MOD_ARTICLES_CATEGORIES_XML_DESCRIPTION","group":"","filename":"mod_articles_categories"}			\N	\N	0	0	\N
32	0	com_actionlogs	component	com_actionlogs	\N		1	1	1	0	1	{"name":"com_actionlogs","type":"component","creationDate":"May 2018","author":"Joomla! Project","copyright":"(C) 2018 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.9.0","description":"COM_ACTIONLOGS_XML_DESCRIPTION","group":""}	{"ip_logging":0,"csv_delimiter":",","loggable_extensions":["com_banners","com_cache","com_categories","com_checkin","com_config","com_contact","com_content","com_installer","com_media","com_menus","com_messages","com_modules","com_newsfeeds","com_plugins","com_redirect","com_tags","com_templates","com_users"]}		\N	\N	0	0	\N
34	0	com_mails	component	com_mails	\N		1	1	1	1	1	{"name":"com_mails","type":"component","creationDate":"January 2019","author":"Joomla! Project","copyright":"(C) 2019 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"4.0.0","description":"COM_MAILS_XML_DESCRIPTION","group":""}			\N	\N	0	0	\N
36	0	lib_phpass	library	phpass	\N		0	1	1	1	1	{"name":"lib_phpass","type":"library","creationDate":"2004-2006","author":"Solar Designer","copyright":"","authorEmail":"solar@openwall.com","authorUrl":"https:\\/\\/www.openwall.com\\/phpass\\/","version":"0.3","description":"LIB_PHPASS_XML_DESCRIPTION","group":"","filename":"phpass"}			\N	\N	0	0	\N
37	0	mod_articles_archive	module	mod_articles_archive	\N		0	1	1	0	1	{"name":"mod_articles_archive","type":"module","creationDate":"July 2006","author":"Joomla! Project","copyright":"(C) 2006 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"MOD_ARTICLES_ARCHIVE_XML_DESCRIPTION","group":"","filename":"mod_articles_archive"}			\N	\N	0	0	\N
38	0	mod_articles_latest	module	mod_articles_latest	\N		0	1	1	0	1	{"name":"mod_articles_latest","type":"module","creationDate":"July 2004","author":"Joomla! Project","copyright":"(C) 2005 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"MOD_LATEST_NEWS_XML_DESCRIPTION","group":"","filename":"mod_articles_latest"}			\N	\N	0	0	\N
40	0	mod_banners	module	mod_banners	\N		0	1	1	0	1	{"name":"mod_banners","type":"module","creationDate":"July 2006","author":"Joomla! Project","copyright":"(C) 2006 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"MOD_BANNERS_XML_DESCRIPTION","group":"","filename":"mod_banners"}			\N	\N	0	0	\N
41	0	mod_breadcrumbs	module	mod_breadcrumbs	\N		0	1	1	0	1	{"name":"mod_breadcrumbs","type":"module","creationDate":"July 2006","author":"Joomla! Project","copyright":"(C) 2006 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"MOD_BREADCRUMBS_XML_DESCRIPTION","group":"","filename":"mod_breadcrumbs"}			\N	\N	0	0	\N
43	0	mod_feed	module	mod_feed	\N		0	1	1	0	1	{"name":"mod_feed","type":"module","creationDate":"July 2005","author":"Joomla! Project","copyright":"(C) 2005 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"MOD_FEED_XML_DESCRIPTION","group":"","filename":"mod_feed"}			\N	\N	0	0	\N
44	0	mod_footer	module	mod_footer	\N		0	1	1	0	1	{"name":"mod_footer","type":"module","creationDate":"July 2006","author":"Joomla! Project","copyright":"(C) 2006 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"MOD_FOOTER_XML_DESCRIPTION","group":"","filename":"mod_footer"}			\N	\N	0	0	\N
45	0	mod_login	module	mod_login	\N		0	1	1	0	1	{"name":"mod_login","type":"module","creationDate":"July 2006","author":"Joomla! Project","copyright":"(C) 2006 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"MOD_LOGIN_XML_DESCRIPTION","group":"","filename":"mod_login"}			\N	\N	0	0	\N
47	0	mod_articles_news	module	mod_articles_news	\N		0	1	1	0	1	{"name":"mod_articles_news","type":"module","creationDate":"July 2006","author":"Joomla! Project","copyright":"(C) 2006 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"MOD_ARTICLES_NEWS_XML_DESCRIPTION","group":"","filename":"mod_articles_news"}			\N	\N	0	0	\N
48	0	mod_random_image	module	mod_random_image	\N		0	1	1	0	1	{"name":"mod_random_image","type":"module","creationDate":"July 2006","author":"Joomla! Project","copyright":"(C) 2006 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"MOD_RANDOM_IMAGE_XML_DESCRIPTION","group":"","filename":"mod_random_image"}			\N	\N	0	0	\N
50	0	mod_stats	module	mod_stats	\N		0	1	1	0	1	{"name":"mod_stats","type":"module","creationDate":"July 2004","author":"Joomla! Project","copyright":"(C) 2005 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"MOD_STATS_XML_DESCRIPTION","group":"","filename":"mod_stats"}			\N	\N	0	0	\N
51	0	mod_syndicate	module	mod_syndicate	\N		0	1	1	0	1	{"name":"mod_syndicate","type":"module","creationDate":"May 2006","author":"Joomla! Project","copyright":"(C) 2006 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"MOD_SYNDICATE_XML_DESCRIPTION","group":"","filename":"mod_syndicate"}			\N	\N	0	0	\N
52	0	mod_users_latest	module	mod_users_latest	\N		0	1	1	0	1	{"name":"mod_users_latest","type":"module","creationDate":"December 2009","author":"Joomla! Project","copyright":"(C) 2009 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"MOD_USERS_LATEST_XML_DESCRIPTION","group":"","filename":"mod_users_latest"}			\N	\N	0	0	\N
54	0	mod_wrapper	module	mod_wrapper	\N		0	1	1	0	1	{"name":"mod_wrapper","type":"module","creationDate":"October 2004","author":"Joomla! Project","copyright":"(C) 2005 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"MOD_WRAPPER_XML_DESCRIPTION","group":"","filename":"mod_wrapper"}			\N	\N	0	0	\N
55	0	mod_articles_category	module	mod_articles_category	\N		0	1	1	0	1	{"name":"mod_articles_category","type":"module","creationDate":"February 2010","author":"Joomla! Project","copyright":"(C) 2010 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"MOD_ARTICLES_CATEGORY_XML_DESCRIPTION","group":"","filename":"mod_articles_category"}			\N	\N	0	0	\N
59	0	mod_custom	module	mod_custom	\N		1	1	1	0	1	{"name":"mod_custom","type":"module","creationDate":"July 2004","author":"Joomla! Project","copyright":"(C) 2005 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"MOD_CUSTOM_XML_DESCRIPTION","group":"","filename":"mod_custom"}			\N	\N	0	0	\N
64	0	mod_loginsupport	module	mod_loginsupport	\N		1	1	1	0	1	{"name":"mod_loginsupport","type":"module","creationDate":"June 2019","author":"Joomla! Project","copyright":"(C) 2019 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"4.0.0","description":"MOD_LOGINSUPPORT_XML_DESCRIPTION","group":"","filename":"mod_loginsupport"}			\N	\N	0	0	\N
65	0	mod_menu	module	mod_menu	\N		1	1	1	0	1	{"name":"mod_menu","type":"module","creationDate":"March 2006","author":"Joomla! Project","copyright":"(C) 2006 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"MOD_MENU_XML_DESCRIPTION","group":"","filename":"mod_menu"}			\N	\N	0	0	\N
66	0	mod_popular	module	mod_popular	\N		1	1	1	0	1	{"name":"mod_popular","type":"module","creationDate":"July 2004","author":"Joomla! Project","copyright":"(C) 2005 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"MOD_POPULAR_XML_DESCRIPTION","group":"","filename":"mod_popular"}			\N	\N	0	0	\N
67	0	mod_quickicon	module	mod_quickicon	\N		1	1	1	0	1	{"name":"mod_quickicon","type":"module","creationDate":"November 2005","author":"Joomla! Project","copyright":"(C) 2005 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"MOD_QUICKICON_XML_DESCRIPTION","group":"","filename":"mod_quickicon"}			\N	\N	0	0	\N
69	0	mod_messages	module	mod_messages	\N		1	1	1	0	1	{"name":"mod_messages","type":"module","creationDate":"July 2019","author":"Joomla! Project","copyright":"(C) 2019 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"4.0.0","description":"MOD_MESSAGES_XML_DESCRIPTION","group":"","filename":"mod_messages"}			\N	\N	0	0	\N
70	0	mod_post_installation_messages	module	mod_post_installation_messages	\N		1	1	1	0	1	{"name":"mod_post_installation_messages","type":"module","creationDate":"July2019","author":"Joomla! Project","copyright":"(C) 2019 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"4.0.0","description":"MOD_POST_INSTALLATION_MESSAGES_XML_DESCRIPTION","group":"","filename":"mod_post_installation_messages"}			\N	\N	0	0	\N
72	0	mod_title	module	mod_title	\N		1	1	1	0	1	{"name":"mod_title","type":"module","creationDate":"November 2005","author":"Joomla! Project","copyright":"(C) 2005 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"MOD_TITLE_XML_DESCRIPTION","group":"","filename":"mod_title"}			\N	\N	0	0	\N
73	0	mod_toolbar	module	mod_toolbar	\N		1	1	1	0	1	{"name":"mod_toolbar","type":"module","creationDate":"November 2005","author":"Joomla! Project","copyright":"(C) 2005 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"MOD_TOOLBAR_XML_DESCRIPTION","group":"","filename":"mod_toolbar"}			\N	\N	0	0	\N
74	0	mod_multilangstatus	module	mod_multilangstatus	\N		1	1	1	0	1	{"name":"mod_multilangstatus","type":"module","creationDate":"September 2011","author":"Joomla! Project","copyright":"(C) 2011 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"MOD_MULTILANGSTATUS_XML_DESCRIPTION","group":"","filename":"mod_multilangstatus"}	{"cache":"0"}		\N	\N	0	0	\N
76	0	mod_stats_admin	module	mod_stats_admin	\N		1	1	1	0	1	{"name":"mod_stats_admin","type":"module","creationDate":"July 2004","author":"Joomla! Project","copyright":"(C) 2005 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"MOD_STATS_XML_DESCRIPTION","group":"","filename":"mod_stats_admin"}	{"serverinfo":"0","siteinfo":"0","counter":"0","increase":"0","cache":"1","cache_time":"900","cachemode":"static"}		\N	\N	0	0	\N
77	0	mod_tags_popular	module	mod_tags_popular	\N		0	1	1	0	1	{"name":"mod_tags_popular","type":"module","creationDate":"January 2013","author":"Joomla! Project","copyright":"(C) 2013 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.1.0","description":"MOD_TAGS_POPULAR_XML_DESCRIPTION","group":"","filename":"mod_tags_popular"}	{"maximum":"5","timeframe":"alltime","owncache":"1"}		\N	\N	0	0	\N
79	0	mod_sampledata	module	mod_sampledata	\N		1	1	1	0	1	{"name":"mod_sampledata","type":"module","creationDate":"July 2017","author":"Joomla! Project","copyright":"(C) 2017 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.8.0","description":"MOD_SAMPLEDATA_XML_DESCRIPTION","group":"","filename":"mod_sampledata"}	{}		\N	\N	0	0	\N
81	0	mod_privacy_dashboard	module	mod_privacy_dashboard	\N		1	1	1	0	1	{"name":"mod_privacy_dashboard","type":"module","creationDate":"June 2018","author":"Joomla! Project","copyright":"(C) 2018 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.9.0","description":"MOD_PRIVACY_DASHBOARD_XML_DESCRIPTION","group":"","filename":"mod_privacy_dashboard"}	{}		\N	\N	0	0	\N
82	0	mod_submenu	module	mod_submenu	\N		1	1	1	0	1	{"name":"mod_submenu","type":"module","creationDate":"February 2006","author":"Joomla! Project","copyright":"(C) 2006 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"MOD_SUBMENU_XML_DESCRIPTION","group":"","filename":"mod_submenu"}	{}		\N	\N	0	0	\N
83	0	mod_privacy_status	module	mod_privacy_status	\N		1	1	1	0	1	{"name":"mod_privacy_status","type":"module","creationDate":"July 2019","author":"Joomla! Project","copyright":"(C) 2019 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"4.0.0","description":"MOD_PRIVACY_STATUS_XML_DESCRIPTION","group":"","filename":"mod_privacy_status"}	{}		\N	\N	0	0	\N
85	0	plg_api-authentication_basic	plugin	basic	\N	api-authentication	0	0	1	0	1	{"name":"plg_api-authentication_basic","type":"plugin","creationDate":"November 2005","author":"Joomla! Project","copyright":"(C) 2019 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"4.0.0","description":"PLG_API-AUTHENTICATION_BASIC_XML_DESCRIPTION","group":"","filename":"basic"}	{}		\N	\N	1	0	\N
88	0	plg_authentication_joomla	plugin	joomla	\N	authentication	0	1	1	1	1	{"name":"plg_authentication_joomla","type":"plugin","creationDate":"November 2005","author":"Joomla! Project","copyright":"(C) 2005 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"PLG_AUTHENTICATION_JOOMLA_XML_DESCRIPTION","group":"","filename":"joomla"}			\N	\N	2	0	\N
89	0	plg_authentication_ldap	plugin	ldap	\N	authentication	0	0	1	0	1	{"name":"plg_authentication_ldap","type":"plugin","creationDate":"November 2005","author":"Joomla! Project","copyright":"(C) 2005 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"PLG_LDAP_XML_DESCRIPTION","group":"","filename":"ldap"}	{"host":"","port":"389","use_ldapV3":"0","negotiate_tls":"0","no_referrals":"0","auth_method":"bind","base_dn":"","search_string":"","users_dn":"","username":"admin","password":"bobby7","ldap_fullname":"fullName","ldap_email":"mail","ldap_uid":"uid"}		\N	\N	3	0	\N
91	0	plg_behaviour_versionable	plugin	versionable	\N	behaviour	0	1	1	0	1	{"name":"plg_behaviour_versionable","type":"plugin","creationDate":"August 2015","author":"Joomla! Project","copyright":"(C) 2016 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"4.0.0","description":"PLG_BEHAVIOUR_VERSIONABLE_XML_DESCRIPTION","group":"","filename":"versionable"}	{}		\N	\N	2	0	\N
93	0	plg_captcha_recaptcha_invisible	plugin	recaptcha_invisible	\N	captcha	0	0	1	0	1	{"name":"plg_captcha_recaptcha_invisible","type":"plugin","creationDate":"November 2017","author":"Joomla! Project","copyright":"(C) 2017 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.8","description":"PLG_CAPTCHA_RECAPTCHA_INVISIBLE_XML_DESCRIPTION","group":"","filename":"recaptcha_invisible"}	{"public_key":"","private_key":"","theme":"clean"}		\N	\N	2	0	\N
94	0	plg_content_confirmconsent	plugin	confirmconsent	\N	content	0	0	1	0	1	{"name":"plg_content_confirmconsent","type":"plugin","creationDate":"May 2018","author":"Joomla! Project","copyright":"(C) 2018 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.9.0","description":"PLG_CONTENT_CONFIRMCONSENT_XML_DESCRIPTION","group":"","filename":"confirmconsent"}	{}		\N	\N	1	0	\N
96	0	plg_content_emailcloak	plugin	emailcloak	\N	content	0	1	1	0	1	{"name":"plg_content_emailcloak","type":"plugin","creationDate":"November 2005","author":"Joomla! Project","copyright":"(C) 2005 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"PLG_CONTENT_EMAILCLOAK_XML_DESCRIPTION","group":"","filename":"emailcloak"}	{"mode":"1"}		\N	\N	3	0	\N
98	0	plg_content_finder	plugin	finder	\N	content	0	1	1	0	1	{"name":"plg_content_finder","type":"plugin","creationDate":"December 2011","author":"Joomla! Project","copyright":"(C) 2011 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"PLG_CONTENT_FINDER_XML_DESCRIPTION","group":"","filename":"finder"}			\N	\N	5	0	\N
99	0	plg_content_joomla	plugin	joomla	\N	content	0	1	1	0	1	{"name":"plg_content_joomla","type":"plugin","creationDate":"November 2010","author":"Joomla! Project","copyright":"(C) 2010 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"PLG_CONTENT_JOOMLA_XML_DESCRIPTION","group":"","filename":"joomla"}			\N	\N	6	0	\N
100	0	plg_content_loadmodule	plugin	loadmodule	\N	content	0	1	1	0	1	{"name":"plg_content_loadmodule","type":"plugin","creationDate":"November 2005","author":"Joomla! Project","copyright":"(C) 2005 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"PLG_LOADMODULE_XML_DESCRIPTION","group":"","filename":"loadmodule"}	{"style":"xhtml"}		\N	\N	7	0	\N
102	0	plg_content_pagenavigation	plugin	pagenavigation	\N	content	0	1	1	0	1	{"name":"plg_content_pagenavigation","type":"plugin","creationDate":"January 2006","author":"Joomla! Project","copyright":"(C) 2006 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"PLG_PAGENAVIGATION_XML_DESCRIPTION","group":"","filename":"pagenavigation"}	{"position":"1"}		\N	\N	9	0	\N
103	0	plg_content_vote	plugin	vote	\N	content	0	0	1	0	1	{"name":"plg_content_vote","type":"plugin","creationDate":"November 2005","author":"Joomla! Project","copyright":"(C) 2005 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"PLG_VOTE_XML_DESCRIPTION","group":"","filename":"vote"}			\N	\N	10	0	\N
105	0	plg_editors-xtd_contact	plugin	contact	\N	editors-xtd	0	1	1	0	1	{"name":"plg_editors-xtd_contact","type":"plugin","creationDate":"October 2016","author":"Joomla! Project","copyright":"(C) 2016 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.7.0","description":"PLG_EDITORS-XTD_CONTACT_XML_DESCRIPTION","group":"","filename":"contact"}			\N	\N	2	0	\N
106	0	plg_editors-xtd_fields	plugin	fields	\N	editors-xtd	0	1	1	0	1	{"name":"plg_editors-xtd_fields","type":"plugin","creationDate":"February 2017","author":"Joomla! Project","copyright":"(C) 2017 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.7.0","description":"PLG_EDITORS-XTD_FIELDS_XML_DESCRIPTION","group":"","filename":"fields"}			\N	\N	3	0	\N
108	0	plg_editors-xtd_menu	plugin	menu	\N	editors-xtd	0	1	1	0	1	{"name":"plg_editors-xtd_menu","type":"plugin","creationDate":"August 2016","author":"Joomla! Project","copyright":"(C) 2016 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.7.0","description":"PLG_EDITORS-XTD_MENU_XML_DESCRIPTION","group":"","filename":"menu"}			\N	\N	5	0	\N
109	0	plg_editors-xtd_module	plugin	module	\N	editors-xtd	0	1	1	0	1	{"name":"plg_editors-xtd_module","type":"plugin","creationDate":"October 2015","author":"Joomla! Project","copyright":"(C) 2015 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.5.0","description":"PLG_MODULE_XML_DESCRIPTION","group":"","filename":"module"}			\N	\N	6	0	\N
110	0	plg_editors-xtd_pagebreak	plugin	pagebreak	\N	editors-xtd	0	1	1	0	1	{"name":"plg_editors-xtd_pagebreak","type":"plugin","creationDate":"August 2004","author":"Joomla! Project","copyright":"(C) 2005 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"PLG_EDITORSXTD_PAGEBREAK_XML_DESCRIPTION","group":"","filename":"pagebreak"}			\N	\N	7	0	\N
112	0	plg_editors_codemirror	plugin	codemirror	\N	editors	0	1	1	0	1	{"name":"plg_editors_codemirror","type":"plugin","creationDate":"28 March 2011","author":"Marijn Haverbeke","copyright":"Copyright (C) 2014 - 2021 by Marijn Haverbeke <marijnh@gmail.com> and others","authorEmail":"marijnh@gmail.com","authorUrl":"https:\\/\\/codemirror.net\\/","version":"5.62.2","description":"PLG_CODEMIRROR_XML_DESCRIPTION","group":"","filename":"codemirror"}	{"lineNumbers":"1","lineWrapping":"1","matchTags":"1","matchBrackets":"1","marker-gutter":"1","autoCloseTags":"1","autoCloseBrackets":"1","autoFocus":"1","theme":"default","tabmode":"indent"}		\N	\N	1	0	\N
164	0	plg_system_cache	plugin	cache	\N	system	0	0	1	0	1	{"name":"plg_system_cache","type":"plugin","creationDate":"February 2007","author":"Joomla! Project","copyright":"(C) 2007 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"PLG_CACHE_XML_DESCRIPTION","group":"","filename":"cache"}	{"browsercache":"0","cachetime":"15"}		\N	\N	3	0	\N
114	0	plg_editors_tinymce	plugin	tinymce	\N	editors	0	1	1	0	1	{"name":"plg_editors_tinymce","type":"plugin","creationDate":"2005-2021","author":"Tiny Technologies, Inc","copyright":"Tiny Technologies, Inc","authorEmail":"N\\/A","authorUrl":"https:\\/\\/www.tiny.cloud","version":"5.8.2","description":"PLG_TINY_XML_DESCRIPTION","group":"","filename":"tinymce"}	{"configuration":{"toolbars":{"2":{"toolbar1":["bold","underline","strikethrough","|","undo","redo","|","bullist","numlist","|","pastetext"]},"1":{"menu":["edit","insert","view","format","table","tools"],"toolbar1":["bold","italic","underline","strikethrough","|","alignleft","aligncenter","alignright","alignjustify","|","formatselect","|","bullist","numlist","|","outdent","indent","|","undo","redo","|","link","unlink","anchor","code","|","hr","table","|","subscript","superscript","|","charmap","pastetext","preview"]},"0":{"menu":["edit","insert","view","format","table","tools"],"toolbar1":["bold","italic","underline","strikethrough","|","alignleft","aligncenter","alignright","alignjustify","|","styleselect","|","formatselect","fontselect","fontsizeselect","|","searchreplace","|","bullist","numlist","|","outdent","indent","|","undo","redo","|","link","unlink","anchor","image","|","code","|","forecolor","backcolor","|","fullscreen","|","table","|","subscript","superscript","|","charmap","emoticons","media","hr","ltr","rtl","|","cut","copy","paste","pastetext","|","visualchars","visualblocks","nonbreaking","blockquote","template","|","print","preview","codesample","insertdatetime","removeformat"]}},"setoptions":{"2":{"access":["1"],"skin":"0","skin_admin":"0","mobile":"0","drag_drop":"1","path":"","entity_encoding":"raw","lang_mode":"1","text_direction":"ltr","content_css":"1","content_css_custom":"","relative_urls":"1","newlines":"0","use_config_textfilters":"0","invalid_elements":"script,applet,iframe","valid_elements":"","extended_elements":"","resizing":"1","resize_horizontal":"1","element_path":"1","wordcount":"1","image_advtab":"0","advlist":"1","autosave":"1","contextmenu":"1","custom_plugin":"","custom_button":""},"1":{"access":["6","2"],"skin":"0","skin_admin":"0","mobile":"0","drag_drop":"1","path":"","entity_encoding":"raw","lang_mode":"1","text_direction":"ltr","content_css":"1","content_css_custom":"","relative_urls":"1","newlines":"0","use_config_textfilters":"0","invalid_elements":"script,applet,iframe","valid_elements":"","extended_elements":"","resizing":"1","resize_horizontal":"1","element_path":"1","wordcount":"1","image_advtab":"0","advlist":"1","autosave":"1","contextmenu":"1","custom_plugin":"","custom_button":""},"0":{"access":["7","4","8"],"skin":"0","skin_admin":"0","mobile":"0","drag_drop":"1","path":"","entity_encoding":"raw","lang_mode":"1","text_direction":"ltr","content_css":"1","content_css_custom":"","relative_urls":"1","newlines":"0","use_config_textfilters":"0","invalid_elements":"script,applet,iframe","valid_elements":"","extended_elements":"","resizing":"1","resize_horizontal":"1","element_path":"1","wordcount":"1","image_advtab":"1","advlist":"1","autosave":"1","contextmenu":"1","custom_plugin":"","custom_button":""}}},"sets_amount":3,"html_height":"550","html_width":"750"}		\N	\N	3	0	\N
118	0	plg_fields_calendar	plugin	calendar	\N	fields	0	1	1	0	1	{"name":"plg_fields_calendar","type":"plugin","creationDate":"March 2016","author":"Joomla! Project","copyright":"(C) 2016 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.7.0","description":"PLG_FIELDS_CALENDAR_XML_DESCRIPTION","group":"","filename":"calendar"}			\N	\N	1	0	\N
119	0	plg_fields_checkboxes	plugin	checkboxes	\N	fields	0	1	1	0	1	{"name":"plg_fields_checkboxes","type":"plugin","creationDate":"March 2016","author":"Joomla! Project","copyright":"(C) 2016 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.7.0","description":"PLG_FIELDS_CHECKBOXES_XML_DESCRIPTION","group":"","filename":"checkboxes"}			\N	\N	2	0	\N
121	0	plg_fields_editor	plugin	editor	\N	fields	0	1	1	0	1	{"name":"plg_fields_editor","type":"plugin","creationDate":"March 2016","author":"Joomla! Project","copyright":"(C) 2016 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.7.0","description":"PLG_FIELDS_EDITOR_XML_DESCRIPTION","group":"","filename":"editor"}			\N	\N	4	0	\N
122	0	plg_fields_imagelist	plugin	imagelist	\N	fields	0	1	1	0	1	{"name":"plg_fields_imagelist","type":"plugin","creationDate":"March 2016","author":"Joomla! Project","copyright":"(C) 2016 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.7.0","description":"PLG_FIELDS_IMAGELIST_XML_DESCRIPTION","group":"","filename":"imagelist"}			\N	\N	5	0	\N
123	0	plg_fields_integer	plugin	integer	\N	fields	0	1	1	0	1	{"name":"plg_fields_integer","type":"plugin","creationDate":"March 2016","author":"Joomla! Project","copyright":"(C) 2016 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.7.0","description":"PLG_FIELDS_INTEGER_XML_DESCRIPTION","group":"","filename":"integer"}	{"multiple":"0","first":"1","last":"100","step":"1"}		\N	\N	6	0	\N
125	0	plg_fields_media	plugin	media	\N	fields	0	1	1	0	1	{"name":"plg_fields_media","type":"plugin","creationDate":"March 2016","author":"Joomla! Project","copyright":"(C) 2016 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.7.0","description":"PLG_FIELDS_MEDIA_XML_DESCRIPTION","group":"","filename":"media"}			\N	\N	8	0	\N
126	0	plg_fields_radio	plugin	radio	\N	fields	0	1	1	0	1	{"name":"plg_fields_radio","type":"plugin","creationDate":"March 2016","author":"Joomla! Project","copyright":"(C) 2016 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.7.0","description":"PLG_FIELDS_RADIO_XML_DESCRIPTION","group":"","filename":"radio"}			\N	\N	9	0	\N
128	0	plg_fields_subform	plugin	subform	\N	fields	0	1	1	0	1	{"name":"plg_fields_subform","type":"plugin","creationDate":"June 2017","author":"Joomla! Project","copyright":"(C) 2019 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"4.0.0","description":"PLG_FIELDS_SUBFORM_XML_DESCRIPTION","group":"","filename":"subform"}			\N	\N	11	0	\N
129	0	plg_fields_text	plugin	text	\N	fields	0	1	1	0	1	{"name":"plg_fields_text","type":"plugin","creationDate":"March 2016","author":"Joomla! Project","copyright":"(C) 2016 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.7.0","description":"PLG_FIELDS_TEXT_XML_DESCRIPTION","group":"","filename":"text"}			\N	\N	12	0	\N
131	0	plg_fields_url	plugin	url	\N	fields	0	1	1	0	1	{"name":"plg_fields_url","type":"plugin","creationDate":"March 2016","author":"Joomla! Project","copyright":"(C) 2016 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.7.0","description":"PLG_FIELDS_URL_XML_DESCRIPTION","group":"","filename":"url"}			\N	\N	14	0	\N
132	0	plg_fields_user	plugin	user	\N	fields	0	1	1	0	1	{"name":"plg_fields_user","type":"plugin","creationDate":"March 2016","author":"Joomla! Project","copyright":"(C) 2016 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.7.0","description":"PLG_FIELDS_USER_XML_DESCRIPTION","group":"","filename":"user"}			\N	\N	15	0	\N
133	0	plg_fields_usergrouplist	plugin	usergrouplist	\N	fields	0	1	1	0	1	{"name":"plg_fields_usergrouplist","type":"plugin","creationDate":"March 2016","author":"Joomla! Project","copyright":"(C) 2016 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.7.0","description":"PLG_FIELDS_USERGROUPLIST_XML_DESCRIPTION","group":"","filename":"usergrouplist"}			\N	\N	16	0	\N
135	0	plg_finder_categories	plugin	categories	\N	finder	0	1	1	0	1	{"name":"plg_finder_categories","type":"plugin","creationDate":"August 2011","author":"Joomla! Project","copyright":"(C) 2011 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"PLG_FINDER_CATEGORIES_XML_DESCRIPTION","group":"","filename":"categories"}			\N	\N	1	0	\N
136	0	plg_finder_contacts	plugin	contacts	\N	finder	0	1	1	0	1	{"name":"plg_finder_contacts","type":"plugin","creationDate":"August 2011","author":"Joomla! Project","copyright":"(C) 2011 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"PLG_FINDER_CONTACTS_XML_DESCRIPTION","group":"","filename":"contacts"}			\N	\N	2	0	\N
138	0	plg_finder_newsfeeds	plugin	newsfeeds	\N	finder	0	1	1	0	1	{"name":"plg_finder_newsfeeds","type":"plugin","creationDate":"August 2011","author":"Joomla! Project","copyright":"(C) 2011 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"PLG_FINDER_NEWSFEEDS_XML_DESCRIPTION","group":"","filename":"newsfeeds"}			\N	\N	4	0	\N
139	0	plg_finder_tags	plugin	tags	\N	finder	0	1	1	0	1	{"name":"plg_finder_tags","type":"plugin","creationDate":"February 2013","author":"Joomla! Project","copyright":"(C) 2013 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"PLG_FINDER_TAGS_XML_DESCRIPTION","group":"","filename":"tags"}			\N	\N	5	0	\N
140	0	plg_installer_folderinstaller	plugin	folderinstaller	\N	installer	0	1	1	0	1	{"name":"plg_installer_folderinstaller","type":"plugin","creationDate":"May 2016","author":"Joomla! Project","copyright":"(C) 2016 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.6.0","description":"PLG_INSTALLER_FOLDERINSTALLER_PLUGIN_XML_DESCRIPTION","group":"","filename":"folderinstaller"}			\N	\N	2	0	\N
142	0	plg_installer_packageinstaller	plugin	packageinstaller	\N	installer	0	1	1	0	1	{"name":"plg_installer_packageinstaller","type":"plugin","creationDate":"May 2016","author":"Joomla! Project","copyright":"(C) 2016 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.6.0","description":"PLG_INSTALLER_PACKAGEINSTALLER_PLUGIN_XML_DESCRIPTION","group":"","filename":"packageinstaller"}			\N	\N	1	0	\N
143	0	plg_installer_urlinstaller	plugin	urlinstaller	\N	installer	0	1	1	0	1	{"name":"plg_installer_urlinstaller","type":"plugin","creationDate":"May 2016","author":"Joomla! Project","copyright":"(C) 2016 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.6.0","description":"PLG_INSTALLER_URLINSTALLER_PLUGIN_XML_DESCRIPTION","group":"","filename":"urlinstaller"}			\N	\N	3	0	\N
145	0	plg_media-action_crop	plugin	crop	\N	media-action	0	1	1	0	1	{"name":"plg_media-action_crop","type":"plugin","creationDate":"January 2017","author":"Joomla! Project","copyright":"(C) 2017 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"4.0.0","description":"PLG_MEDIA-ACTION_CROP_XML_DESCRIPTION","group":"","filename":"crop"}	{}		\N	\N	1	0	\N
146	0	plg_media-action_resize	plugin	resize	\N	media-action	0	1	1	0	1	{"name":"plg_media-action_resize","type":"plugin","creationDate":"January 2017","author":"Joomla! Project","copyright":"(C) 2017 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"4.0.0","description":"PLG_MEDIA-ACTION_RESIZE_XML_DESCRIPTION","group":"","filename":"resize"}	{}		\N	\N	2	0	\N
148	0	plg_privacy_actionlogs	plugin	actionlogs	\N	privacy	0	1	1	0	1	{"name":"plg_privacy_actionlogs","type":"plugin","creationDate":"July 2018","author":"Joomla! Project","copyright":"(C) 2018 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.9.0","description":"PLG_PRIVACY_ACTIONLOGS_XML_DESCRIPTION","group":"","filename":"actionlogs"}	{}		\N	\N	1	0	\N
149	0	plg_privacy_consents	plugin	consents	\N	privacy	0	1	1	0	1	{"name":"plg_privacy_consents","type":"plugin","creationDate":"July 2018","author":"Joomla! Project","copyright":"(C) 2018 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.9.0","description":"PLG_PRIVACY_CONSENTS_XML_DESCRIPTION","group":"","filename":"consents"}	{}		\N	\N	2	0	\N
150	0	plg_privacy_contact	plugin	contact	\N	privacy	0	1	1	0	1	{"name":"plg_privacy_contact","type":"plugin","creationDate":"July 2018","author":"Joomla! Project","copyright":"(C) 2018 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.9.0","description":"PLG_PRIVACY_CONTACT_XML_DESCRIPTION","group":"","filename":"contact"}	{}		\N	\N	3	0	\N
152	0	plg_privacy_message	plugin	message	\N	privacy	0	1	1	0	1	{"name":"plg_privacy_message","type":"plugin","creationDate":"July 2018","author":"Joomla! Project","copyright":"(C) 2018 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.9.0","description":"PLG_PRIVACY_MESSAGE_XML_DESCRIPTION","group":"","filename":"message"}	{}		\N	\N	5	0	\N
153	0	plg_privacy_user	plugin	user	\N	privacy	0	1	1	0	1	{"name":"plg_privacy_user","type":"plugin","creationDate":"May 2018","author":"Joomla! Project","copyright":"(C) 2018 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.9.0","description":"PLG_PRIVACY_USER_XML_DESCRIPTION","group":"","filename":"user"}	{}		\N	\N	6	0	\N
155	0	plg_quickicon_extensionupdate	plugin	extensionupdate	\N	quickicon	0	1	1	0	1	{"name":"plg_quickicon_extensionupdate","type":"plugin","creationDate":"August 2011","author":"Joomla! Project","copyright":"(C) 2011 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"PLG_QUICKICON_EXTENSIONUPDATE_XML_DESCRIPTION","group":"","filename":"extensionupdate"}			\N	\N	2	0	\N
156	0	plg_quickicon_overridecheck	plugin	overridecheck	\N	quickicon	0	1	1	0	1	{"name":"plg_quickicon_overridecheck","type":"plugin","creationDate":"June 2018","author":"Joomla! Project","copyright":"(C) 2018 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"4.0.0","description":"PLG_QUICKICON_OVERRIDECHECK_XML_DESCRIPTION","group":"","filename":"overridecheck"}			\N	\N	3	0	\N
158	0	plg_quickicon_privacycheck	plugin	privacycheck	\N	quickicon	0	1	1	0	1	{"name":"plg_quickicon_privacycheck","type":"plugin","creationDate":"June 2018","author":"Joomla! Project","copyright":"(C) 2018 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.9.0","description":"PLG_QUICKICON_PRIVACYCHECK_XML_DESCRIPTION","group":"","filename":"privacycheck"}	{}		\N	\N	5	0	\N
159	0	plg_quickicon_phpversioncheck	plugin	phpversioncheck	\N	quickicon	0	1	1	0	1	{"name":"plg_quickicon_phpversioncheck","type":"plugin","creationDate":"August 2016","author":"Joomla! Project","copyright":"(C) 2016 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.7.0","description":"PLG_QUICKICON_PHPVERSIONCHECK_XML_DESCRIPTION","group":"","filename":"phpversioncheck"}			\N	\N	6	0	\N
161	0	plg_sampledata_multilang	plugin	multilang	\N	sampledata	0	1	1	0	1	{"name":"plg_sampledata_multilang","type":"plugin","creationDate":"July 2018","author":"Joomla! Project","copyright":"(C) 2018 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"4.0.0","description":"PLG_SAMPLEDATA_MULTILANG_XML_DESCRIPTION","group":"","filename":"multilang"}			\N	\N	2	0	\N
162	0	plg_system_accessibility	plugin	accessibility	\N	system	0	0	1	0	1	{"name":"plg_system_accessibility","type":"plugin","creationDate":"2020-02-15","author":"Joomla! Project","copyright":"(C) 2020 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"4.0.0","description":"PLG_SYSTEM_ACCESSIBILITY_XML_DESCRIPTION","group":"","filename":"accessibility"}	{}		\N	\N	1	0	\N
163	0	plg_system_actionlogs	plugin	actionlogs	\N	system	0	1	1	0	1	{"name":"plg_system_actionlogs","type":"plugin","creationDate":"May 2018","author":"Joomla! Project","copyright":"(C) 2018 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.9.0","description":"PLG_SYSTEM_ACTIONLOGS_XML_DESCRIPTION","group":"","filename":"actionlogs"}	{}		\N	\N	2	0	\N
165	0	plg_system_debug	plugin	debug	\N	system	0	1	1	0	1	{"name":"plg_system_debug","type":"plugin","creationDate":"December 2006","author":"Joomla! Project","copyright":"(C) 2006 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"PLG_DEBUG_XML_DESCRIPTION","group":"","filename":"debug"}	{"profile":"1","queries":"1","memory":"1","language_files":"1","language_strings":"1","strip-first":"1","strip-prefix":"","strip-suffix":""}		\N	\N	4	0	\N
166	0	plg_system_fields	plugin	fields	\N	system	0	1	1	0	1	{"name":"plg_system_fields","type":"plugin","creationDate":"March 2016","author":"Joomla! Project","copyright":"(C) 2016 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.7.0","description":"PLG_SYSTEM_FIELDS_XML_DESCRIPTION","group":"","filename":"fields"}			\N	\N	5	0	\N
167	0	plg_system_highlight	plugin	highlight	\N	system	0	1	1	0	1	{"name":"plg_system_highlight","type":"plugin","creationDate":"August 2011","author":"Joomla! Project","copyright":"(C) 2011 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"PLG_SYSTEM_HIGHLIGHT_XML_DESCRIPTION","group":"","filename":"highlight"}			\N	\N	6	0	\N
169	0	plg_system_languagecode	plugin	languagecode	\N	system	0	0	1	0	1	{"name":"plg_system_languagecode","type":"plugin","creationDate":"November 2011","author":"Joomla! Project","copyright":"(C) 2011 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"PLG_SYSTEM_LANGUAGECODE_XML_DESCRIPTION","group":"","filename":"languagecode"}			\N	\N	8	0	\N
170	0	plg_system_languagefilter	plugin	languagefilter	\N	system	0	0	1	0	1	{"name":"plg_system_languagefilter","type":"plugin","creationDate":"July 2010","author":"Joomla! Project","copyright":"(C) 2010 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"PLG_SYSTEM_LANGUAGEFILTER_XML_DESCRIPTION","group":"","filename":"languagefilter"}			\N	\N	9	0	\N
172	0	plg_system_logout	plugin	logout	\N	system	0	1	1	0	1	{"name":"plg_system_logout","type":"plugin","creationDate":"April 2009","author":"Joomla! Project","copyright":"(C) 2009 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"PLG_SYSTEM_LOGOUT_XML_DESCRIPTION","group":"","filename":"logout"}			\N	\N	11	0	\N
175	0	plg_system_redirect	plugin	redirect	\N	system	0	0	1	0	1	{"name":"plg_system_redirect","type":"plugin","creationDate":"April 2009","author":"Joomla! Project","copyright":"(C) 2009 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"PLG_SYSTEM_REDIRECT_XML_DESCRIPTION","group":"","filename":"redirect"}			\N	\N	14	0	\N
176	0	plg_system_remember	plugin	remember	\N	system	0	1	1	0	1	{"name":"plg_system_remember","type":"plugin","creationDate":"April 2007","author":"Joomla! Project","copyright":"(C) 2007 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"PLG_REMEMBER_XML_DESCRIPTION","group":"","filename":"remember"}			\N	\N	15	0	\N
177	0	plg_system_sef	plugin	sef	\N	system	0	1	1	0	1	{"name":"plg_system_sef","type":"plugin","creationDate":"December 2007","author":"Joomla! Project","copyright":"(C) 2007 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"PLG_SEF_XML_DESCRIPTION","group":"","filename":"sef"}			\N	\N	16	0	\N
179	0	plg_system_skipto	plugin	skipto	\N	system	0	1	1	0	1	{"name":"plg_system_skipto","type":"plugin","creationDate":"February 2020","author":"Joomla! Project","copyright":"(C) 2019 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"4.0.0","description":"PLG_SYSTEM_SKIPTO_XML_DESCRIPTION","group":"","filename":"skipto"}	{}		\N	\N	18	0	\N
180	0	plg_system_stats	plugin	stats	\N	system	0	0	1	0	1	{"name":"plg_system_stats","type":"plugin","creationDate":"November 2013","author":"Joomla! Project","copyright":"(C) 2013 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.5.0","description":"PLG_SYSTEM_STATS_XML_DESCRIPTION","group":"","filename":"stats"}	{"mode":3,"lastrun":1633190958,"unique_id":"e11e39b28d71529af897db739a6ca4950d04bc5a","interval":12}		\N	\N	19	0	\N
183	0	plg_twofactorauth_totp	plugin	totp	\N	twofactorauth	0	0	1	0	1	{"name":"plg_twofactorauth_totp","type":"plugin","creationDate":"August 2013","author":"Joomla! Project","copyright":"(C) 2013 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.2.0","description":"PLG_TWOFACTORAUTH_TOTP_XML_DESCRIPTION","group":"","filename":"totp"}			\N	\N	1	0	\N
184	0	plg_twofactorauth_yubikey	plugin	yubikey	\N	twofactorauth	0	0	1	0	1	{"name":"plg_twofactorauth_yubikey","type":"plugin","creationDate":"September 2013","author":"Joomla! Project","copyright":"(C) 2013 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.2.0","description":"PLG_TWOFACTORAUTH_YUBIKEY_XML_DESCRIPTION","group":"","filename":"yubikey"}			\N	\N	2	0	\N
186	0	plg_user_joomla	plugin	joomla	\N	user	0	1	1	0	1	{"name":"plg_user_joomla","type":"plugin","creationDate":"December 2006","author":"Joomla! Project","copyright":"(C) 2006 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"PLG_USER_JOOMLA_XML_DESCRIPTION","group":"","filename":"joomla"}	{"autoregister":"1","mail_to_user":"1","forceLogout":"1"}		\N	\N	2	0	\N
187	0	plg_user_profile	plugin	profile	\N	user	0	0	1	0	1	{"name":"plg_user_profile","type":"plugin","creationDate":"January 2008","author":"Joomla! Project","copyright":"(C) 2008 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.0.0","description":"PLG_USER_PROFILE_XML_DESCRIPTION","group":"","filename":"profile"}	{"register-require_address1":"1","register-require_address2":"1","register-require_city":"1","register-require_region":"1","register-require_country":"1","register-require_postal_code":"1","register-require_phone":"1","register-require_website":"1","register-require_favoritebook":"1","register-require_aboutme":"1","register-require_tos":"1","register-require_dob":"1","profile-require_address1":"1","profile-require_address2":"1","profile-require_city":"1","profile-require_region":"1","profile-require_country":"1","profile-require_postal_code":"1","profile-require_phone":"1","profile-require_website":"1","profile-require_favoritebook":"1","profile-require_aboutme":"1","profile-require_tos":"1","profile-require_dob":"1"}		\N	\N	3	0	\N
191	0	plg_webservices_config	plugin	config	\N	webservices	0	1	1	0	1	{"name":"plg_webservices_config","type":"plugin","creationDate":"September 2019","author":"Joomla! Project","copyright":"(C) 2019 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"4.0.0","description":"PLG_WEBSERVICES_CONFIG_XML_DESCRIPTION","group":"","filename":"config"}	{}		\N	\N	2	0	\N
193	0	plg_webservices_content	plugin	content	\N	webservices	0	1	1	0	1	{"name":"plg_webservices_content","type":"plugin","creationDate":"September 2019","author":"Joomla! Project","copyright":"(C) 2019 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"4.0.0","description":"PLG_WEBSERVICES_CONTENT_XML_DESCRIPTION","group":"","filename":"content"}	{}		\N	\N	4	0	\N
194	0	plg_webservices_installer	plugin	installer	\N	webservices	0	1	1	0	1	{"name":"plg_webservices_installer","type":"plugin","creationDate":"June 2020","author":"Joomla! Project","copyright":"(C) 2020 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"4.0.0","description":"PLG_WEBSERVICES_INSTALLER_XML_DESCRIPTION","group":"","filename":"installer"}	{}		\N	\N	5	0	\N
195	0	plg_webservices_languages	plugin	languages	\N	webservices	0	1	1	0	1	{"name":"plg_webservices_languages","type":"plugin","creationDate":"September 2019","author":"Joomla! Project","copyright":"(C) 2019 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"4.0.0","description":"PLG_WEBSERVICES_LANGUAGES_XML_DESCRIPTION","group":"","filename":"languages"}	{}		\N	\N	6	0	\N
197	0	plg_webservices_messages	plugin	messages	\N	webservices	0	1	1	0	1	{"name":"plg_webservices_messages","type":"plugin","creationDate":"September 2019","author":"Joomla! Project","copyright":"(C) 2019 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"4.0.0","description":"PLG_WEBSERVICES_MESSAGES_XML_DESCRIPTION","group":"","filename":"messages"}	{}		\N	\N	8	0	\N
198	0	plg_webservices_modules	plugin	modules	\N	webservices	0	1	1	0	1	{"name":"plg_webservices_modules","type":"plugin","creationDate":"September 2019","author":"Joomla! Project","copyright":"(C) 2019 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"4.0.0","description":"PLG_WEBSERVICES_MODULES_XML_DESCRIPTION","group":"","filename":"modules"}	{}		\N	\N	9	0	\N
200	0	plg_webservices_plugins	plugin	plugins	\N	webservices	0	1	1	0	1	{"name":"plg_webservices_plugins","type":"plugin","creationDate":"September 2019","author":"Joomla! Project","copyright":"(C) 2019 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"4.0.0","description":"PLG_WEBSERVICES_PLUGINS_XML_DESCRIPTION","group":"","filename":"plugins"}	{}		\N	\N	11	0	\N
201	0	plg_webservices_privacy	plugin	privacy	\N	webservices	0	1	1	0	1	{"name":"plg_webservices_privacy","type":"plugin","creationDate":"September 2019","author":"Joomla! Project","copyright":"(C) 2019 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"4.0.0","description":"PLG_WEBSERVICES_PRIVACY_XML_DESCRIPTION","group":"","filename":"privacy"}	{}		\N	\N	12	0	\N
203	0	plg_webservices_tags	plugin	tags	\N	webservices	0	1	1	0	1	{"name":"plg_webservices_tags","type":"plugin","creationDate":"September 2019","author":"Joomla! Project","copyright":"(C) 2019 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"4.0.0","description":"PLG_WEBSERVICES_TAGS_XML_DESCRIPTION","group":"","filename":"tags"}	{}		\N	\N	14	0	\N
204	0	plg_webservices_templates	plugin	templates	\N	webservices	0	1	1	0	1	{"name":"plg_webservices_templates","type":"plugin","creationDate":"September 2019","author":"Joomla! Project","copyright":"(C) 2019 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"4.0.0","description":"PLG_WEBSERVICES_TEMPLATES_XML_DESCRIPTION","group":"","filename":"templates"}	{}		\N	\N	15	0	\N
206	0	plg_workflow_featuring	plugin	featuring	\N	workflow	0	1	1	0	1	{"name":"plg_workflow_featuring","type":"plugin","creationDate":"March 2020","author":"Joomla! Project","copyright":"(C) 2020 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"4.0.0","description":"PLG_WORKFLOW_FEATURING_XML_DESCRIPTION","group":"","filename":"featuring"}	{}		\N	\N	1	0	\N
207	0	plg_workflow_notification	plugin	notification	\N	workflow	0	1	1	0	1	{"name":"plg_workflow_notification","type":"plugin","creationDate":"May 2020","author":"Joomla! Project","copyright":"(C) 2020 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"4.0.0","description":"PLG_WORKFLOW_NOTIFICATION_XML_DESCRIPTION","group":"","filename":"notification"}	{}		\N	\N	2	0	\N
208	0	plg_workflow_publishing	plugin	publishing	\N	workflow	0	1	1	0	1	{"name":"plg_workflow_publishing","type":"plugin","creationDate":"March 2020","author":"Joomla! Project","copyright":"(C) 2020 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"4.0.0","description":"PLG_WORKFLOW_PUBLISHING_XML_DESCRIPTION","group":"","filename":"publishing"}	{}		\N	\N	3	0	\N
210	0	cassiopeia	template	cassiopeia	\N		0	1	1	0	1	{"name":"cassiopeia","type":"template","creationDate":"February 2017","author":"Joomla! Project","copyright":"(C) 2017 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"","version":"1.0","description":"TPL_CASSIOPEIA_XML_DESCRIPTION","group":"","filename":"templateDetails"}	{"logoFile":"","fluidContainer":"0","sidebarLeftWidth":"3","sidebarRightWidth":"3"}		\N	\N	0	0	\N
212	0	English (en-GB) Language Pack	package	pkg_en-GB	\N		0	1	1	1	1	{"name":"English (en-GB) Language Pack","type":"package","creationDate":"September 2021","author":"Joomla! Project","copyright":"(C) 2019 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"4.0.3.1","description":"en-GB language pack","group":"","filename":"pkg_en-GB"}			\N	\N	0	0	\N
213	212	English (en-GB)	language	en-GB	\N		0	1	1	1	1	{"name":"English (en-GB)","type":"language","creationDate":"September 2021","author":"Joomla! Project","copyright":"(C) 2006 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"4.0.3","description":"en-GB site language","group":""}			\N	\N	0	0	\N
173	0	plg_system_logrotation	plugin	logrotation	\N	system	0	1	1	0	1	{"name":"plg_system_logrotation","type":"plugin","creationDate":"May 2018","author":"Joomla! Project","copyright":"(C) 2018 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.9.0","description":"PLG_SYSTEM_LOGROTATION_XML_DESCRIPTION","group":"","filename":"logrotation"}	{"lastrun":1633190920}		\N	\N	12	0	\N
20	0	com_config	component	com_config	\N		1	1	0	1	1	{"name":"com_config","type":"component","creationDate":"April 2006","author":"Joomla! Project","copyright":"(C) 2006 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"4.0.0","description":"COM_CONFIG_XML_DESCRIPTION","group":"","filename":"config"}	{"filters":{"1":{"filter_type":"NH","filter_tags":"","filter_attributes":""},"9":{"filter_type":"NH","filter_tags":"","filter_attributes":""},"6":{"filter_type":"BL","filter_tags":"","filter_attributes":""},"7":{"filter_type":"BL","filter_tags":"","filter_attributes":""},"2":{"filter_type":"NH","filter_tags":"","filter_attributes":""},"3":{"filter_type":"BL","filter_tags":"","filter_attributes":""},"4":{"filter_type":"BL","filter_tags":"","filter_attributes":""},"5":{"filter_type":"BL","filter_tags":"","filter_attributes":""},"8":{"filter_type":"NONE","filter_tags":"","filter_attributes":""}}}		\N	\N	0	0	\N
219	0	Russian (ru-RU) Language Pack	package	pkg_ru-RU			0	1	1	0	0	{"name":"Russian (ru-RU) Language Pack","type":"package","creationDate":"14\\/09\\/2021","author":"Russian Translation Team","copyright":"Copyright (C) 2005 - 2021 Open Source Matters, Inc.","authorEmail":"smart@joomlaportal.ru","authorUrl":"https:\\/\\/joomlaportal.ru","version":"4.0.3.1","description":"<h3 style='font-weight: 400'>Joomla 4.0.3 Russian Language Pack<\\/h3><div style='font-weight: 400'><p>\\u041e\\u0444\\u0438\\u0446\\u0438\\u0430\\u043b\\u044c\\u043d\\u0430\\u044f \\u043b\\u043e\\u043a\\u0430\\u043b\\u0438\\u0437\\u0430\\u0446\\u0438\\u044f Joomla, \\u043a\\u043e\\u0442\\u043e\\u0440\\u0430\\u044f \\u043f\\u043e\\u0434\\u0434\\u0435\\u0440\\u0436\\u0438\\u0432\\u0430\\u0435\\u0442\\u0441\\u044f \\u0440\\u0443\\u0441\\u0441\\u043a\\u043e\\u044f\\u0437\\u044b\\u0447\\u043d\\u044b\\u043c \\u0441\\u043e\\u043e\\u0431\\u0449\\u0435\\u0441\\u0442\\u0432\\u043e\\u043c.<br>\\u041c\\u044b \\u0440\\u0430\\u0434\\u044b \\u043f\\u0440\\u0435\\u0434\\u043b\\u043e\\u0436\\u0435\\u043d\\u0438\\u044f\\u043c \\u0438 \\u043f\\u043e\\u043c\\u043e\\u0449\\u0438 \\u0432 \\u043b\\u043e\\u043a\\u0430\\u043b\\u0438\\u0437\\u0430\\u0446\\u0438\\u0438 Joomla! \\u0421\\u043e\\u043e\\u0431\\u0449\\u0438\\u0442\\u044c \\u043e \\u043f\\u0440\\u043e\\u0431\\u043b\\u0435\\u043c\\u0435 \\u0438\\u043b\\u0438 \\u0432\\u043d\\u0435\\u0441\\u0442\\u0438 \\u0438\\u0441\\u043f\\u0440\\u0430\\u0432\\u043b\\u0435\\u043d\\u0438\\u0435 \\u0432\\u044b \\u043c\\u043e\\u0436\\u0435\\u0442\\u0435 \\u043d\\u0430 \\u0441\\u0442\\u0440\\u0430\\u043d\\u0438\\u0446\\u0435 <a href='https:\\/\\/github.com\\/JPathRu\\/localisation' target='_blank'>Github<\\/a>.<\\/p><ul><li><a href='https:\\/\\/joomlaportal.ru' target='_blank'>\\u041f\\u043e\\u0440\\u0442\\u0430\\u043b Joomla \\u043f\\u043e-\\u0440\\u0443\\u0441\\u0441\\u043a\\u0438<\\/a>,<\\/li><li><a href='https:\\/\\/joomlaforum.ru' target='_blank'>\\u0424\\u043e\\u0440\\u0443\\u043c \\u0440\\u0443\\u0441\\u0441\\u043a\\u043e\\u0439 \\u043f\\u043e\\u0434\\u0434\\u0435\\u0440\\u0436\\u043a\\u0438 Joomla<\\/a>,<\\/li><li><a href='https:\\/\\/joomlaportal.ru\\/russian-joomla' target='_blank'>\\u041e\\u0444\\u0438\\u0446\\u0438\\u0430\\u043b\\u044c\\u043d\\u0430\\u044f \\u0441\\u0442\\u0440\\u0430\\u043d\\u0438\\u0446\\u0430 \\u043b\\u043e\\u043a\\u0430\\u043b\\u0438\\u0437\\u0430\\u0446\\u0438\\u0438<\\/a>.<\\/li><\\/ul><\\/div>","group":"","filename":"pkg_ru-RU"}	{}		\N	\N	0	0	\N
222	219	Russianru-RU	language	ru-RU			0	1	0	0	0	{"name":"Russian (ru-RU)","type":"language","creationDate":"14\\/09\\/2021","author":"Russian Translation Team","copyright":"Copyright (C) 2005 - 2021 Open Source Matters, Inc.","authorEmail":"smart@joomlaportal.ru","authorUrl":"https:\\/\\/joomlaportal.ru","version":"4.0.3.1","description":"<p>Russian language pack (site) for Joomla!<\\/p>","group":"","filename":"install"}	{}		\N	\N	0	0	\N
35	0	lib_joomla	library	joomla	\N		0	1	1	1	1	{"name":"lib_joomla","type":"library","creationDate":"2008","author":"Joomla! Project","copyright":"(C) 2008 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"https:\\/\\/www.joomla.org","version":"13.1","description":"LIB_JOOMLA_XML_DESCRIPTION","group":"","filename":"joomla"}	{"mediaversion":"e1881511346f14caff50f872e4a1b9d8"}		\N	\N	0	0	\N
10	0	com_languages	component	com_languages	\N		1	1	1	1	1	{"name":"com_languages","type":"component","creationDate":"April 2006","author":"Joomla! Project","copyright":"(C) 2006 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"4.0.0","description":"COM_LANGUAGES_XML_DESCRIPTION","group":""}	{"administrator":"ru-RU","site":"ru-RU"}		\N	\N	0	0	\N
182	0	plg_system_webauthn	plugin	webauthn	\N	system	0	0	1	0	1	{"name":"plg_system_webauthn","type":"plugin","creationDate":"2019-07-02","author":"Joomla! Project","copyright":"(C) 2020 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"4.0.0","description":"PLG_SYSTEM_WEBAUTHN_DESCRIPTION","group":"","filename":"webauthn"}	{}		\N	\N	21	0	\N
86	0	plg_api-authentication_token	plugin	token	\N	api-authentication	0	1	1	0	1	{"name":"plg_api-authentication_token","type":"plugin","creationDate":"November 2019","author":"Joomla! Project","copyright":"(C) 2020 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"4.0.0","description":"PLG_API-AUTHENTICATION_TOKEN_XML_DESCRIPTION","group":"","filename":"token"}	{}		\N	\N	2	0	\N
181	0	plg_system_updatenotification	plugin	updatenotification	\N	system	0	1	1	0	1	{"name":"plg_system_updatenotification","type":"plugin","creationDate":"May 2015","author":"Joomla! Project","copyright":"(C) 2015 Open Source Matters, Inc.","authorEmail":"admin@joomla.org","authorUrl":"www.joomla.org","version":"3.5.0","description":"PLG_SYSTEM_UPDATENOTIFICATION_XML_DESCRIPTION","group":"","filename":"updatenotification"}	{"lastrun":1633212754}		\N	\N	20	0	\N
\.


--
-- Data for Name: joomla_fields; Type: TABLE DATA; Schema: public; Owner: joomla_user
--

COPY public.joomla_fields (id, asset_id, context, group_id, title, name, label, default_value, type, note, description, state, required, only_use_in_subform, checked_out, checked_out_time, ordering, params, fieldparams, language, created_time, created_user_id, modified_time, modified_by, access) FROM stdin;
\.


--
-- Data for Name: joomla_fields_categories; Type: TABLE DATA; Schema: public; Owner: joomla_user
--

COPY public.joomla_fields_categories (field_id, category_id) FROM stdin;
\.


--
-- Data for Name: joomla_fields_groups; Type: TABLE DATA; Schema: public; Owner: joomla_user
--

COPY public.joomla_fields_groups (id, asset_id, context, title, note, description, state, checked_out, checked_out_time, ordering, params, language, created, created_by, modified, modified_by, access) FROM stdin;
\.


--
-- Data for Name: joomla_fields_values; Type: TABLE DATA; Schema: public; Owner: joomla_user
--

COPY public.joomla_fields_values (field_id, item_id, value) FROM stdin;
\.


--
-- Data for Name: joomla_finder_filters; Type: TABLE DATA; Schema: public; Owner: joomla_user
--

COPY public.joomla_finder_filters (filter_id, title, alias, state, created, created_by, created_by_alias, modified, modified_by, checked_out, checked_out_time, map_count, data, params) FROM stdin;
\.


--
-- Data for Name: joomla_finder_links; Type: TABLE DATA; Schema: public; Owner: joomla_user
--

COPY public.joomla_finder_links (link_id, url, route, title, description, indexdate, md5sum, published, state, access, language, publish_start_date, publish_end_date, start_date, end_date, list_price, sale_price, type_id, object) FROM stdin;
\.


--
-- Data for Name: joomla_finder_links_terms; Type: TABLE DATA; Schema: public; Owner: joomla_user
--

COPY public.joomla_finder_links_terms (link_id, term_id, weight) FROM stdin;
\.


--
-- Data for Name: joomla_finder_logging; Type: TABLE DATA; Schema: public; Owner: joomla_user
--

COPY public.joomla_finder_logging (searchterm, md5sum, query, hits, results) FROM stdin;
\.


--
-- Data for Name: joomla_finder_taxonomy; Type: TABLE DATA; Schema: public; Owner: joomla_user
--

COPY public.joomla_finder_taxonomy (id, parent_id, lft, rgt, level, path, title, alias, state, access, language) FROM stdin;
1	0	0	1	0		ROOT	root	1	1	*
\.


--
-- Data for Name: joomla_finder_taxonomy_map; Type: TABLE DATA; Schema: public; Owner: joomla_user
--

COPY public.joomla_finder_taxonomy_map (link_id, node_id) FROM stdin;
\.


--
-- Data for Name: joomla_finder_terms; Type: TABLE DATA; Schema: public; Owner: joomla_user
--

COPY public.joomla_finder_terms (term_id, term, stem, common, phrase, weight, soundex, links, language) FROM stdin;
\.


--
-- Data for Name: joomla_finder_terms_common; Type: TABLE DATA; Schema: public; Owner: joomla_user
--

COPY public.joomla_finder_terms_common (term, language, custom) FROM stdin;
i	en	0
me	en	0
my	en	0
myself	en	0
we	en	0
our	en	0
ours	en	0
ourselves	en	0
you	en	0
your	en	0
yours	en	0
yourself	en	0
yourselves	en	0
he	en	0
him	en	0
his	en	0
himself	en	0
she	en	0
her	en	0
hers	en	0
herself	en	0
it	en	0
its	en	0
itself	en	0
they	en	0
them	en	0
their	en	0
theirs	en	0
themselves	en	0
what	en	0
which	en	0
who	en	0
whom	en	0
this	en	0
that	en	0
these	en	0
those	en	0
am	en	0
is	en	0
are	en	0
was	en	0
were	en	0
be	en	0
been	en	0
being	en	0
have	en	0
has	en	0
had	en	0
having	en	0
do	en	0
does	en	0
did	en	0
doing	en	0
would	en	0
should	en	0
could	en	0
ought	en	0
i'm	en	0
you're	en	0
he's	en	0
she's	en	0
it's	en	0
we're	en	0
they're	en	0
i've	en	0
you've	en	0
we've	en	0
they've	en	0
i'd	en	0
you'd	en	0
he'd	en	0
she'd	en	0
we'd	en	0
they'd	en	0
i'll	en	0
you'll	en	0
he'll	en	0
she'll	en	0
we'll	en	0
they'll	en	0
isn't	en	0
aren't	en	0
wasn't	en	0
weren't	en	0
hasn't	en	0
haven't	en	0
hadn't	en	0
doesn't	en	0
don't	en	0
didn't	en	0
won't	en	0
wouldn't	en	0
shan't	en	0
shouldn't	en	0
can't	en	0
cannot	en	0
couldn't	en	0
mustn't	en	0
let's	en	0
that's	en	0
who's	en	0
what's	en	0
here's	en	0
there's	en	0
when's	en	0
where's	en	0
why's	en	0
how's	en	0
a	en	0
an	en	0
the	en	0
and	en	0
but	en	0
if	en	0
or	en	0
because	en	0
as	en	0
until	en	0
while	en	0
of	en	0
at	en	0
by	en	0
for	en	0
with	en	0
about	en	0
against	en	0
between	en	0
into	en	0
through	en	0
during	en	0
before	en	0
after	en	0
above	en	0
below	en	0
to	en	0
from	en	0
up	en	0
down	en	0
in	en	0
out	en	0
on	en	0
off	en	0
over	en	0
under	en	0
again	en	0
further	en	0
then	en	0
once	en	0
here	en	0
there	en	0
when	en	0
where	en	0
why	en	0
how	en	0
all	en	0
any	en	0
both	en	0
each	en	0
few	en	0
more	en	0
most	en	0
other	en	0
some	en	0
such	en	0
no	en	0
nor	en	0
not	en	0
only	en	0
own	en	0
same	en	0
so	en	0
than	en	0
too	en	0
very	en	0
\.


--
-- Data for Name: joomla_finder_tokens; Type: TABLE DATA; Schema: public; Owner: joomla_user
--

COPY public.joomla_finder_tokens (term, stem, common, phrase, weight, context, language) FROM stdin;
\.


--
-- Data for Name: joomla_finder_tokens_aggregate; Type: TABLE DATA; Schema: public; Owner: joomla_user
--

COPY public.joomla_finder_tokens_aggregate (term_id, term, stem, common, phrase, term_weight, context, context_weight, total_weight, language) FROM stdin;
\.


--
-- Data for Name: joomla_finder_types; Type: TABLE DATA; Schema: public; Owner: joomla_user
--

COPY public.joomla_finder_types (id, title, mime) FROM stdin;
1	Category	
2	Contact	
3	Article	
4	News Feed	
5	Tag	
\.


--
-- Data for Name: joomla_history; Type: TABLE DATA; Schema: public; Owner: joomla_user
--

COPY public.joomla_history (version_id, item_id, version_note, save_date, editor_user_id, character_count, sha1_hash, version_data, keep_forever) FROM stdin;
\.


--
-- Data for Name: joomla_languages; Type: TABLE DATA; Schema: public; Owner: joomla_user
--

COPY public.joomla_languages (lang_id, asset_id, lang_code, title, title_native, sef, image, description, metakey, metadesc, sitename, published, access, ordering) FROM stdin;
1	0	en-GB	English (en-GB)	English (United Kingdom)	en	en_gb					1	1	2
2	89	ru-RU	Russian (ru-RU)	Русский (Россия)	ru	ru_ru		\N			0	1	1
\.


--
-- Data for Name: joomla_mail_templates; Type: TABLE DATA; Schema: public; Owner: joomla_user
--

COPY public.joomla_mail_templates (template_id, extension, language, subject, body, htmlbody, attachments, params) FROM stdin;
com_config.test_mail	com_config	       	COM_CONFIG_SENDMAIL_SUBJECT	COM_CONFIG_SENDMAIL_BODY			{"tags":["sitename","method"]}
com_contact.mail	com_contact	       	COM_CONTACT_ENQUIRY_SUBJECT	COM_CONTACT_ENQUIRY_TEXT			{"tags":["sitename","name","email","subject","body","url","customfields"]}
com_contact.mail.copy	com_contact	       	COM_CONTACT_COPYSUBJECT_OF	COM_CONTACT_COPYTEXT_OF			{"tags":["sitename","name","email","subject","body","url","customfields"]}
com_users.massmail.mail	com_users	       	COM_USERS_MASSMAIL_MAIL_SUBJECT	COM_USERS_MASSMAIL_MAIL_BODY			{"tags":["subject","body","subjectprefix","bodysuffix"]}
com_users.password_reset	com_users	       	COM_USERS_EMAIL_PASSWORD_RESET_SUBJECT	COM_USERS_EMAIL_PASSWORD_RESET_BODY			{"tags":["name","email","sitename","link_text","link_html","token"]}
com_users.reminder	com_users	       	COM_USERS_EMAIL_USERNAME_REMINDER_SUBJECT	COM_USERS_EMAIL_USERNAME_REMINDER_BODY			{"tags":["name","username","sitename","email","link_text","link_html"]}
plg_system_updatenotification.mail	plg_system_updatenotification	       	PLG_SYSTEM_UPDATENOTIFICATION_EMAIL_SUBJECT	PLG_SYSTEM_UPDATENOTIFICATION_EMAIL_BODY			{"tags":["newversion","curversion","sitename","url","link","releasenews"]}
plg_user_joomla.mail	plg_user_joomla	       	PLG_USER_JOOMLA_NEW_USER_EMAIL_SUBJECT	PLG_USER_JOOMLA_NEW_USER_EMAIL_BODY			{"tags":["name","sitename","url","username","password","email"]}
com_actionlogs.notification	com_actionlogs	       	COM_ACTIONLOGS_EMAIL_SUBJECT	COM_ACTIONLOGS_EMAIL_BODY	COM_ACTIONLOGS_EMAIL_HTMLBODY		{"tags":["message","date","extension"]}
com_privacy.userdataexport	com_privacy	       	COM_PRIVACY_EMAIL_DATA_EXPORT_COMPLETED_SUBJECT	COM_PRIVACY_EMAIL_DATA_EXPORT_COMPLETED_BODY			{"tags":["sitename","url"]}
com_privacy.notification.export	com_privacy	       	COM_PRIVACY_EMAIL_REQUEST_SUBJECT_EXPORT_REQUEST	COM_PRIVACY_EMAIL_REQUEST_BODY_EXPORT_REQUEST			{"tags":["sitename","url","tokenurl","formurl","token"]}
com_privacy.notification.remove	com_privacy	       	COM_PRIVACY_EMAIL_REQUEST_SUBJECT_REMOVE_REQUEST	COM_PRIVACY_EMAIL_REQUEST_BODY_REMOVE_REQUEST			{"tags":["sitename","url","tokenurl","formurl","token"]}
com_privacy.notification.admin.export	com_privacy	       	COM_PRIVACY_EMAIL_ADMIN_REQUEST_SUBJECT_EXPORT_REQUEST	COM_PRIVACY_EMAIL_ADMIN_REQUEST_BODY_EXPORT_REQUEST			{"tags":["sitename","url","tokenurl","formurl","token"]}
com_privacy.notification.admin.remove	com_privacy	       	COM_PRIVACY_EMAIL_ADMIN_REQUEST_SUBJECT_REMOVE_REQUEST	COM_PRIVACY_EMAIL_ADMIN_REQUEST_BODY_REMOVE_REQUEST			{"tags":["sitename","url","tokenurl","formurl","token"]}
com_users.registration.user.admin_activation	com_users	       	COM_USERS_EMAIL_ACCOUNT_DETAILS	COM_USERS_EMAIL_REGISTERED_WITH_ADMIN_ACTIVATION_BODY_NOPW			{"tags":["name","sitename","activate","siteurl","username"]}
com_users.registration.user.admin_activation_w_pw	com_users	       	COM_USERS_EMAIL_ACCOUNT_DETAILS	COM_USERS_EMAIL_REGISTERED_WITH_ADMIN_ACTIVATION_BODY			{"tags":["name","sitename","activate","siteurl","username","password_clear"]}
com_users.registration.user.self_activation	com_users	       	COM_USERS_EMAIL_ACCOUNT_DETAILS	COM_USERS_EMAIL_REGISTERED_WITH_ACTIVATION_BODY_NOPW			{"tags":["name","sitename","activate","siteurl","username"]}
com_users.registration.user.self_activation_w_pw	com_users	       	COM_USERS_EMAIL_ACCOUNT_DETAILS	COM_USERS_EMAIL_REGISTERED_WITH_ACTIVATION_BODY			{"tags":["name","sitename","activate","siteurl","username","password_clear"]}
com_users.registration.user.registration_mail	com_users	       	COM_USERS_EMAIL_ACCOUNT_DETAILS	COM_USERS_EMAIL_REGISTERED_BODY_NOPW			{"tags":["name","sitename","activate","siteurl","username"]}
com_users.registration.user.registration_mail_w_pw	com_users	       	COM_USERS_EMAIL_ACCOUNT_DETAILS	COM_USERS_EMAIL_REGISTERED_BODY			{"tags":["name","sitename","activate","siteurl","username","password_clear"]}
com_users.registration.admin.new_notification	com_users	       	COM_USERS_EMAIL_ACCOUNT_DETAILS	COM_USERS_EMAIL_REGISTERED_NOTIFICATION_TO_ADMIN_BODY			{"tags":["name","sitename","siteurl","username"]}
com_users.registration.user.admin_activated	com_users	       	COM_USERS_EMAIL_ACTIVATED_BY_ADMIN_ACTIVATION_SUBJECT	COM_USERS_EMAIL_ACTIVATED_BY_ADMIN_ACTIVATION_BODY			{"tags":["name","sitename","siteurl","username"]}
com_users.registration.admin.verification_request	com_users	       	COM_USERS_EMAIL_ACTIVATE_WITH_ADMIN_ACTIVATION_SUBJECT	COM_USERS_EMAIL_ACTIVATE_WITH_ADMIN_ACTIVATION_BODY			{"tags":["name","sitename","email","username","activate"]}
plg_system_privacyconsent.request.reminder	plg_system_privacyconsent	       	PLG_SYSTEM_PRIVACYCONSENT_EMAIL_REMIND_SUBJECT	PLG_SYSTEM_PRIVACYCONSENT_EMAIL_REMIND_BODY			{"tags":["sitename","url","tokenurl","formurl","token"]}
com_messages.new_message	com_messages	       	COM_MESSAGES_NEW_MESSAGE	COM_MESSAGES_NEW_MESSAGE_BODY			{"tags":["subject","message","fromname","sitename","siteurl","fromemail","toname","toemail"]}
\.


--
-- Data for Name: joomla_menu; Type: TABLE DATA; Schema: public; Owner: joomla_user
--

COPY public.joomla_menu (id, menutype, title, alias, note, path, link, type, published, parent_id, level, component_id, checked_out, checked_out_time, "browserNav", access, img, template_style_id, params, lft, rgt, home, language, client_id, publish_up, publish_down) FROM stdin;
1		Menu_Item_Root	root					1	0	0	0	\N	\N	0	0		0		0	43	0	*	0	\N	\N
2	main	com_banners	Banners		Banners	index.php?option=com_banners	component	1	1	1	3	\N	\N	0	0	class:bookmark	0		1	10	0	*	1	\N	\N
3	main	com_banners	Banners		Banners/Banners	index.php?option=com_banners&view=banners	component	1	2	2	3	\N	\N	0	0	class:banners	0		2	3	0	*	1	\N	\N
4	main	com_banners_categories	Categories		Banners/Categories	index.php?option=com_categories&view=categories&extension=com_banners	component	1	2	2	5	\N	\N	0	0	class:banners-cat	0		4	5	0	*	1	\N	\N
5	main	com_banners_clients	Clients		Banners/Clients	index.php?option=com_banners&view=clients	component	1	2	2	3	\N	\N	0	0	class:banners-clients	0		6	7	0	*	1	\N	\N
6	main	com_banners_tracks	Tracks		Banners/Tracks	index.php?option=com_banners&view=tracks	component	1	2	2	3	\N	\N	0	0	class:banners-tracks	0		8	9	0	*	1	\N	\N
7	main	com_contact	Contacts		Contacts	index.php?option=com_contact	component	1	1	1	7	\N	\N	0	0	class:address-book	0		11	20	0	*	1	\N	\N
8	main	com_contact_contacts	Contacts		Contacts/Contacts	index.php?option=com_contact&view=contacts	component	1	7	2	7	\N	\N	0	0	class:contact	0		12	13	0	*	1	\N	\N
9	main	com_contact_categories	Categories		Contacts/Categories	index.php?option=com_categories&view=categories&extension=com_contact	component	1	7	2	5	\N	\N	0	0	class:contact-cat	0		14	15	0	*	1	\N	\N
10	main	com_newsfeeds	News Feeds		News Feeds	index.php?option=com_newsfeeds	component	1	1	1	16	\N	\N	0	0	class:rss	0		23	28	0	*	1	\N	\N
11	main	com_newsfeeds_feeds	Feeds		News Feeds/Feeds	index.php?option=com_newsfeeds&view=newsfeeds	component	1	10	2	16	\N	\N	0	0	class:newsfeeds	0		24	25	0	*	1	\N	\N
12	main	com_newsfeeds_categories	Categories		News Feeds/Categories	index.php?option=com_categories&view=categories&extension=com_newsfeeds	component	1	10	2	5	\N	\N	0	0	class:newsfeeds-cat	0		26	27	0	*	1	\N	\N
13	main	com_finder	Smart Search		Smart Search	index.php?option=com_finder	component	1	1	1	23	\N	\N	0	0	class:search-plus	0		29	38	0	*	1	\N	\N
14	main	com_tags	Tags		Tags	index.php?option=com_tags&view=tags	component	1	1	1	25	\N	\N	0	1	class:tags	0		39	40	0		1	\N	\N
15	main	com_associations	Multilingual Associations		Multilingual Associations	index.php?option=com_associations&view=associations	component	1	1	1	30	\N	\N	0	0	class:language	0		21	22	0	*	1	\N	\N
16	main	mod_menu_fields	Contact Custom Fields		contact/Custom Fields	index.php?option=com_fields&context=com_contact.contact	component	1	7	2	29	\N	\N	0	0	class:messages-add	0		16	17	0	*	1	\N	\N
17	main	mod_menu_fields_group	Contact Custom Fields Group		contact/Custom Fields Group	index.php?option=com_fields&view=groups&context=com_contact.contact	component	1	7	2	29	\N	\N	0	0	class:messages-add	0		18	19	0	*	1	\N	\N
18	main	com_finder_index	Smart-Search-Index		Smart Search/Index	index.php?option=com_finder&view=index	component	1	13	2	23	\N	\N	0	0	class:finder	0		30	31	0	*	1	\N	\N
19	main	com_finder_maps	Smart-Search-Maps		Smart Search/Maps	index.php?option=com_finder&view=maps	component	1	13	2	23	\N	\N	0	0	class:finder-maps	0		32	33	0	*	1	\N	\N
20	main	com_finder_filters	Smart-Search-Filters		Smart Search/Filters	index.php?option=com_finder&view=filters	component	1	13	2	23	\N	\N	0	0	class:finder-filters	0		34	35	0	*	1	\N	\N
21	main	com_finder_searches	Smart-Search-Searches		Smart Search/Searches	index.php?option=com_finder&view=searches	component	1	13	2	23	\N	\N	0	0	class:finder-searches	0		36	37	0	*	1	\N	\N
101	mainmenu	Home	home		home	index.php?option=com_content&view=featured	component	1	1	1	19	\N	\N	0	1		0	{"featured_categories":[""],"layout_type":"blog","blog_class_leading":"","blog_class":"","num_leading_articles":"1","num_intro_articles":"3","num_links":"0","link_intro_image":"","orderby_pri":"","orderby_sec":"front","order_date":"","show_pagination":"2","show_pagination_results":"1","show_title":"","link_titles":"","show_intro":"","info_block_position":"","info_block_show_title":"","show_category":"","link_category":"","show_parent_category":"","link_parent_category":"","show_associations":"","show_author":"","link_author":"","show_create_date":"","show_modify_date":"","show_publish_date":"","show_item_navigation":"","show_vote":"","show_readmore":"","show_readmore_title":"","show_hits":"","show_tags":"","show_noauth":"","show_feed_link":"1","feed_summary":"","menu-anchor_title":"","menu-anchor_css":"","menu_image":"","menu_image_css":"","menu_text":1,"menu_show":1,"page_title":"","show_page_heading":"1","page_heading":"","pageclass_sfx":"","menu-meta_description":"","robots":""}	41	42	1	*	0	\N	\N
\.


--
-- Data for Name: joomla_menu_types; Type: TABLE DATA; Schema: public; Owner: joomla_user
--

COPY public.joomla_menu_types (id, asset_id, menutype, title, description, client_id) FROM stdin;
1	0	mainmenu	Main Menu	The main menu for the site	0
\.


--
-- Data for Name: joomla_messages; Type: TABLE DATA; Schema: public; Owner: joomla_user
--

COPY public.joomla_messages (message_id, user_id_from, user_id_to, folder_id, date_time, state, priority, subject, message) FROM stdin;
\.


--
-- Data for Name: joomla_messages_cfg; Type: TABLE DATA; Schema: public; Owner: joomla_user
--

COPY public.joomla_messages_cfg (user_id, cfg_name, cfg_value) FROM stdin;
\.


--
-- Data for Name: joomla_modules; Type: TABLE DATA; Schema: public; Owner: joomla_user
--

COPY public.joomla_modules (id, asset_id, title, note, content, ordering, "position", checked_out, checked_out_time, publish_up, publish_down, published, module, access, showtitle, params, client_id, language) FROM stdin;
2	40	Login			1	login	\N	\N	\N	\N	1	mod_login	1	1		1	*
3	41	Popular Articles			3	cpanel	\N	\N	\N	\N	1	mod_popular	3	1	{"count":"5","catid":"","user_id":"0","layout":"_:default","moduleclass_sfx":"","cache":"0", "bootstrap_size": "12","header_tag":"h2"}	1	*
4	42	Recently Added Articles			4	cpanel	\N	\N	\N	\N	1	mod_latest	3	1	{"count":"5","ordering":"c_dsc","catid":"","user_id":"0","layout":"_:default","moduleclass_sfx":"","cache":"0", "bootstrap_size": "12","header_tag":"h2"}	1	*
8	43	Toolbar			1	toolbar	\N	\N	\N	\N	1	mod_toolbar	3	1		1	*
9	44	Notifications			3	icon	\N	\N	\N	\N	1	mod_quickicon	3	1	{"context":"update_quickicon","header_icon":"icon-sync","show_jupdate":"1","show_eupdate":"1","show_oupdate":"1","show_privacy":"1","layout":"_:default","moduleclass_sfx":"","cache":1,"cache_time":900,"style":"0","module_tag":"div","bootstrap_size":"12","header_tag":"h2","header_class":""}	1	*
10	45	Logged-in Users			2	cpanel	\N	\N	\N	\N	1	mod_logged	3	1	{"count":"5","name":"1","layout":"_:default","moduleclass_sfx":"","cache":"0", "bootstrap_size": "12","header_tag":"h2"}	1	*
12	46	Admin Menu			1	menu	\N	\N	\N	\N	1	mod_menu	3	1	{"layout":"","moduleclass_sfx":"","shownew":"1","showhelp":"1","cache":"0"}	1	*
15	49	Title			1	title	\N	\N	\N	\N	1	mod_title	3	1		1	*
17	51	Breadcrumbs			1	breadcrumbs	\N	\N	\N	\N	1	mod_breadcrumbs	1	1	{"moduleclass_sfx":"","showHome":"1","homeText":"","showComponent":"1","separator":"","cache":"0","cache_time":"0","cachemode":"itemid"}	0	*
79	52	Multilanguage status			2	status	\N	\N	\N	\N	1	mod_multilangstatus	3	1	{"layout":"_:default","moduleclass_sfx":"","cache":"0"}	1	*
86	53	Joomla Version			1	status	\N	\N	\N	\N	1	mod_version	3	1	{"layout":"_:default","moduleclass_sfx":"","cache":"0"}	1	*
87	55	Sample Data			0	cpanel	\N	\N	\N	\N	1	mod_sampledata	6	1	{"bootstrap_size": "12","header_tag":"h2"}	1	*
89	68	Privacy Dashboard			0	cpanel	\N	\N	\N	\N	1	mod_privacy_dashboard	6	1	{"bootstrap_size": "12","header_tag":"h2"}	1	*
90	65	Login Support			1	sidebar	\N	\N	\N	\N	1	mod_loginsupport	1	1	{"forum_url":"https://forum.joomla.org/","documentation_url":"https://docs.joomla.org/","news_url":"https://www.joomla.org/announcements.html","automatic_title":1,"prepare_content":1,"layout":"_:default","moduleclass_sfx":"","cache":1,"cache_time":900,"module_tag":"div","bootstrap_size":"0","header_tag":"h3","header_class":"","style":"0"}	1	*
91	72	System Dashboard			1	cpanel-system	\N	\N	\N	\N	1	mod_submenu	1	0	{"menutype":"*","preset":"system","layout":"_:default","moduleclass_sfx":"","module_tag":"div","bootstrap_size":"12","header_tag":"h2","header_class":"","style":"System-none"}	1	*
92	73	Content Dashboard			1	cpanel-content	\N	\N	\N	\N	1	mod_submenu	1	0	{"menutype":"*","preset":"content","layout":"_:default","moduleclass_sfx":"","module_tag":"div","bootstrap_size":"12","header_tag":"h2","header_class":"","style":"System-none"}	1	*
93	74	Menus Dashboard			1	cpanel-menus	\N	\N	\N	\N	1	mod_submenu	1	0	{"menutype":"*","preset":"menus","layout":"_:default","moduleclass_sfx":"","module_tag":"div","bootstrap_size":"12","header_tag":"h2","header_class":"","style":"System-none"}	1	*
94	75	Components Dashboard			1	cpanel-components	\N	\N	\N	\N	1	mod_submenu	1	0	{"menutype":"*","preset":"components","layout":"_:default","moduleclass_sfx":"","module_tag":"div","bootstrap_size":"12","header_tag":"h2","header_class":"","style":"System-none"}	1	*
95	76	Users Dashboard			1	cpanel-users	\N	\N	\N	\N	1	mod_submenu	1	0	{"menutype":"*","preset":"users","layout":"_:default","moduleclass_sfx":"","module_tag":"div","bootstrap_size":"12","header_tag":"h2","header_class":"","style":"System-none"}	1	*
96	86	Popular Articles			3	cpanel-content	\N	\N	\N	\N	1	mod_popular	3	1	{"count":"5","catid":"","user_id":"0","layout":"_:default","moduleclass_sfx":"","cache":"0", "bootstrap_size": "12","header_tag":"h2"}	1	*
97	87	Recently Added Articles			4	cpanel-content	\N	\N	\N	\N	1	mod_latest	3	1	{"count":"5","ordering":"c_dsc","catid":"","user_id":"0","layout":"_:default","moduleclass_sfx":"","cache":"0", "bootstrap_size": "12","header_tag":"h2"}	1	*
98	88	Logged-in Users			2	cpanel-users	\N	\N	\N	\N	1	mod_logged	3	1	{"count":"5","name":"1","layout":"_:default","moduleclass_sfx":"","cache":"0", "bootstrap_size": "12","header_tag":"h2"}	1	*
99	77	Frontend Link			5	status	\N	\N	\N	\N	1	mod_frontend	1	1		1	*
100	78	Messages			4	status	\N	\N	\N	\N	1	mod_messages	3	1		1	*
101	79	Post Install Messages			3	status	\N	\N	\N	\N	1	mod_post_installation_messages	3	1		1	*
102	80	User Status			6	status	\N	\N	\N	\N	1	mod_user	3	1		1	*
103	70	Site			1	icon	\N	\N	\N	\N	1	mod_quickicon	1	1	{"context":"site_quickicon","header_icon":"icon-desktop","show_users":"1","show_articles":"1","show_categories":"1","show_media":"1","show_menuItems":"1","show_modules":"1","show_plugins":"1","show_templates":"1","layout":"_:default","moduleclass_sfx":"","cache":1,"cache_time":900,"style":"0","module_tag":"div","bootstrap_size":"12","header_tag":"h2","header_class":""}	1	*
104	71	System			2	icon	\N	\N	\N	\N	1	mod_quickicon	1	1	{"context":"system_quickicon","header_icon":"icon-wrench","show_global":"1","show_checkin":"1","show_cache":"1","layout":"_:default","moduleclass_sfx":"","cache":1,"cache_time":900,"style":"0","module_tag":"div","bootstrap_size":"12","header_tag":"h2","header_class":""}	1	*
105	82	3rd Party			4	icon	\N	\N	\N	\N	1	mod_quickicon	1	1	{"context":"mod_quickicon","header_icon":"icon-boxes","load_plugins":"1","layout":"_:default","moduleclass_sfx":"","cache":1,"cache_time":900,"style":"0","module_tag":"div","bootstrap_size":"12","header_tag":"h2","header_class":""}	1	*
1	39	Main Menu			1	sidebar-right	\N	\N	2021-10-02 21:33:34	\N	-2	mod_menu	1	1	{"menutype":"mainmenu","startLevel":"0","endLevel":"0","showAllChildren":"1","tag_id":"","class_sfx":"","window_open":"","layout":"_:default","moduleclass_sfx":"","cache":"1","cache_time":"900","cachemode":"itemid"}	0	*
106	83	Help Dashboard			1	cpanel-help	\N	\N	\N	\N	1	mod_submenu	1	0	{"menutype":"*","preset":"help","layout":"_:default","moduleclass_sfx":"","style":"System-none","module_tag":"div","bootstrap_size":"12","header_tag":"h2","header_class":""}	1	*
107	84	Privacy Requests			1	cpanel-privacy	\N	\N	\N	\N	1	mod_privacy_dashboard	1	1	{"layout":"_:default","moduleclass_sfx":"","cache":1,"cache_time":900,"cachemode":"static","style":"0","module_tag":"div","bootstrap_size":"12","header_tag":"h2","header_class":""}	1	*
108	85	Privacy Status			1	cpanel-privacy	\N	\N	\N	\N	1	mod_privacy_status	1	1	{"layout":"_:default","moduleclass_sfx":"","cache":1,"cache_time":900,"cachemode":"static","style":"0","module_tag":"div","bootstrap_size":"12","header_tag":"h2","header_class":""}	1	*
88	67	Latest Actions			1		\N	\N	\N	\N	0	mod_latestactions	6	0	{"count":5,"layout":"_:default","moduleclass_sfx":"","automatic_title":0,"cache":1,"cache_time":900,"cachemode":"static","style":"0","module_tag":"div","bootstrap_size":"12","header_tag":"h2","header_class":""}	1	*
16	50	Login Form			1	sidebar-right	\N	\N	2021-10-02 21:33:26	\N	-2	mod_login	1	1	{"pretext":"","posttext":"","login":"","logout":"","customRegLinkMenu":"","greeting":1,"name":0,"profilelink":0,"usetext":0,"layout":"_:default","moduleclass_sfx":"","style":"0","module_tag":"div","bootstrap_size":"0","header_tag":"h3","header_class":""}	0	*
110	91	Меню		\N	1	sidebar-right	\N	\N	\N	\N	1	mod_menu	1	1	{"menutype":"mainmenu","base":"","startLevel":1,"endLevel":0,"showAllChildren":1,"tag_id":"","class_sfx":"","window_open":"","layout":"_:collapse-default","moduleclass_sfx":"","cache":1,"cache_time":900,"cachemode":"itemid","style":"0","module_tag":"div","bootstrap_size":"0","header_tag":"h3","header_class":""}	0	*
109	90	Вход на сайт		\N	1	sidebar-right	\N	\N	\N	\N	1	mod_login	1	1	{"pretext":"","posttext":"","login":"","logout":"","customRegLinkMenu":"","greeting":1,"name":0,"profilelink":0,"usetext":0,"layout":"_:default","moduleclass_sfx":"","style":"0","module_tag":"div","bootstrap_size":"0","header_tag":"h3","header_class":""}	0	*
\.


--
-- Data for Name: joomla_modules_menu; Type: TABLE DATA; Schema: public; Owner: joomla_user
--

COPY public.joomla_modules_menu (moduleid, menuid) FROM stdin;
1	0
2	0
3	0
4	0
6	0
7	0
8	0
9	0
10	0
12	0
14	0
15	0
17	0
79	0
86	0
87	0
89	0
90	0
91	0
92	0
93	0
94	0
95	0
96	0
97	0
98	0
99	0
100	0
101	0
102	0
103	0
104	0
105	0
106	0
107	0
108	0
88	0
16	0
109	0
110	0
\.


--
-- Data for Name: joomla_newsfeeds; Type: TABLE DATA; Schema: public; Owner: joomla_user
--

COPY public.joomla_newsfeeds (catid, id, name, alias, link, published, numarticles, cache_time, checked_out, checked_out_time, ordering, rtl, access, language, params, created, created_by, created_by_alias, modified, modified_by, metakey, metadesc, metadata, publish_up, publish_down, description, version, hits, images) FROM stdin;
\.


--
-- Data for Name: joomla_overrider; Type: TABLE DATA; Schema: public; Owner: joomla_user
--

COPY public.joomla_overrider (id, constant, string, file) FROM stdin;
\.


--
-- Data for Name: joomla_postinstall_messages; Type: TABLE DATA; Schema: public; Owner: joomla_user
--

COPY public.joomla_postinstall_messages (postinstall_message_id, extension_id, title_key, description_key, action_key, language_extension, language_client_id, type, action_file, action, condition_file, condition_method, version_introduced, enabled) FROM stdin;
4	211	PLG_SYSTEM_UPDATENOTIFICATION_POSTINSTALL_UPDATECACHETIME	PLG_SYSTEM_UPDATENOTIFICATION_POSTINSTALL_UPDATECACHETIME_BODY	PLG_SYSTEM_UPDATENOTIFICATION_POSTINSTALL_UPDATECACHETIME_ACTION	plg_system_updatenotification	1	action	site://plugins/system/updatenotification/postinstall/updatecachetime.php	updatecachetime_postinstall_action	site://plugins/system/updatenotification/postinstall/updatecachetime.php	updatecachetime_postinstall_condition	3.6.3	1
5	211	PLG_SYSTEM_HTTPHEADERS_POSTINSTALL_INTRODUCTION_TITLE	PLG_SYSTEM_HTTPHEADERS_POSTINSTALL_INTRODUCTION_BODY	PLG_SYSTEM_HTTPHEADERS_POSTINSTALL_INTRODUCTION_ACTION	plg_system_httpheaders	1	action	site://plugins/system/httpheaders/postinstall/introduction.php	httpheaders_postinstall_action	site://plugins/system/httpheaders/postinstall/introduction.php	httpheaders_postinstall_condition	4.0.0	1
1	211	PLG_TWOFACTORAUTH_TOTP_POSTINSTALL_TITLE	PLG_TWOFACTORAUTH_TOTP_POSTINSTALL_BODY	PLG_TWOFACTORAUTH_TOTP_POSTINSTALL_ACTION	plg_twofactorauth_totp	1	action	site://plugins/twofactorauth/totp/postinstall/actions.php	twofactorauth_postinstall_action	site://plugins/twofactorauth/totp/postinstall/actions.php	twofactorauth_postinstall_condition	3.2.0	0
2	211	COM_CPANEL_WELCOME_BEGINNERS_TITLE	COM_CPANEL_WELCOME_BEGINNERS_MESSAGE		com_cpanel	1	message					3.2.0	0
3	211	COM_CPANEL_MSG_STATS_COLLECTION_TITLE	COM_CPANEL_MSG_STATS_COLLECTION_BODY		com_cpanel	1	message			admin://components/com_admin/postinstall/statscollection.php	admin_postinstall_statscollection_condition	3.5.0	0
6	211	COM_ADMIN_POSTINSTALL_MSG_FLOC_BLOCKER_TITLE	COM_ADMIN_POSTINSTALL_MSG_FLOC_BLOCKER_DESCRIPTION		com_admin	1	message					3.9.27	0
\.


--
-- Data for Name: joomla_privacy_consents; Type: TABLE DATA; Schema: public; Owner: joomla_user
--

COPY public.joomla_privacy_consents (id, user_id, state, created, subject, body, remind, token) FROM stdin;
\.


--
-- Data for Name: joomla_privacy_requests; Type: TABLE DATA; Schema: public; Owner: joomla_user
--

COPY public.joomla_privacy_requests (id, email, requested_at, status, request_type, confirm_token, confirm_token_created_at) FROM stdin;
\.


--
-- Data for Name: joomla_redirect_links; Type: TABLE DATA; Schema: public; Owner: joomla_user
--

COPY public.joomla_redirect_links (id, old_url, new_url, referer, comment, hits, published, created_date, modified_date, header) FROM stdin;
\.


--
-- Data for Name: joomla_schemas; Type: TABLE DATA; Schema: public; Owner: joomla_user
--

COPY public.joomla_schemas (extension_id, version_id) FROM stdin;
211	4.0.3-2021-09-05
\.


--
-- Data for Name: joomla_session; Type: TABLE DATA; Schema: public; Owner: joomla_user
--

COPY public.joomla_session (session_id, client_id, guest, "time", data, userid, username) FROM stdin;
\\x326175697631766274326e36746b6833366f6e6a736f65357530	1	0	1633211596	joomla|s:2600:"TzoyNDoiSm9vbWxhXFJlZ2lzdHJ5XFJlZ2lzdHJ5IjozOntzOjc6IgAqAGRhdGEiO086ODoic3RkQ2xhc3MiOjU6e3M6Nzoic2Vzc2lvbiI7Tzo4OiJzdGRDbGFzcyI6NDp7czo3OiJjb3VudGVyIjtpOjEwNjtzOjU6InRpbWVyIjtPOjg6InN0ZENsYXNzIjozOntzOjU6InN0YXJ0IjtpOjE2MzMyMTAwNzc7czo0OiJsYXN0IjtpOjE2MzMyMTE1OTU7czozOiJub3ciO2k6MTYzMzIxMTU5NTt9czo2OiJjbGllbnQiO086ODoic3RkQ2xhc3MiOjE6e3M6NzoiYWRkcmVzcyI7czoxMToiOTUuMzEuNDMuODAiO31zOjU6InRva2VuIjtzOjMyOiI5NDQ3YmYzZjhhZWEwZDNjYWNiZmVhZWVmMmMzOWUwZiI7fXM6ODoicmVnaXN0cnkiO086MjQ6Ikpvb21sYVxSZWdpc3RyeVxSZWdpc3RyeSI6Mzp7czo3OiIAKgBkYXRhIjtPOjg6InN0ZENsYXNzIjo0OntzOjEzOiJjb21fbGFuZ3VhZ2VzIjtPOjg6InN0ZENsYXNzIjoxOntzOjk6Imluc3RhbGxlZCI7Tzo4OiJzdGRDbGFzcyI6Mzp7czo2OiJmaWx0ZXIiO2E6MTp7czo2OiJzZWFyY2giO3M6MDoiIjt9czo5OiJjbGllbnRfaWQiO2k6MDtzOjQ6Imxpc3QiO2E6Mjp7czoxMjoiZnVsbG9yZGVyaW5nIjtzOjg6Im5hbWUgQVNDIjtzOjU6ImxpbWl0IjtzOjI6IjIwIjt9fX1zOjEzOiJjb21faW5zdGFsbGVyIjtPOjg6InN0ZENsYXNzIjoxOntzOjg6Indhcm5pbmdzIjtPOjg6InN0ZENsYXNzIjoxOntzOjg6Im9yZGVyY29sIjtOO319czoxMToiY29tX21vZHVsZXMiO086ODoic3RkQ2xhc3MiOjM6e3M6NDoiZWRpdCI7Tzo4OiJzdGRDbGFzcyI6MTp7czo2OiJtb2R1bGUiO086ODoic3RkQ2xhc3MiOjI6e3M6MjoiaWQiO2E6MTp7aTowO2k6MTY7fXM6NDoiZGF0YSI7Tjt9fXM6MzoiYWRkIjtPOjg6InN0ZENsYXNzIjoxOntzOjY6Im1vZHVsZSI7Tzo4OiJzdGRDbGFzcyI6Mjp7czoxMjoiZXh0ZW5zaW9uX2lkIjtOO3M6NjoicGFyYW1zIjtOO319czo3OiJtb2R1bGVzIjtPOjg6InN0ZENsYXNzIjoyOntzOjE6IjAiO086ODoic3RkQ2xhc3MiOjI6e3M6OToiY2xpZW50X2lkIjtpOjA7czo0OiJsaXN0IjthOjQ6e3M6OToiZGlyZWN0aW9uIjtzOjM6ImFzYyI7czo1OiJsaW1pdCI7aToyMDtzOjg6Im9yZGVyaW5nIjtzOjEwOiJhLnBvc2l0aW9uIjtzOjU6InN0YXJ0IjtkOjA7fX1zOjk6ImNsaWVudF9pZCI7czoxOiIwIjt9fXM6MTE6ImNvbV9wbHVnaW5zIjtPOjg6InN0ZENsYXNzIjoyOntzOjQ6ImVkaXQiO086ODoic3RkQ2xhc3MiOjE6e3M6NjoicGx1Z2luIjtPOjg6InN0ZENsYXNzIjoyOntzOjI6ImlkIjthOjE6e2k6MDtpOjg2O31zOjQ6ImRhdGEiO047fX1zOjc6InBsdWdpbnMiO086ODoic3RkQ2xhc3MiOjM6e3M6NjoiZmlsdGVyIjthOjU6e3M6Njoic2VhcmNoIjtzOjA6IiI7czo3OiJlbmFibGVkIjtzOjA6IiI7czo2OiJmb2xkZXIiO3M6MDoiIjtzOjc6ImVsZW1lbnQiO3M6MDoiIjtzOjY6ImFjY2VzcyI7czowOiIiO31zOjQ6Imxpc3QiO2E6NDp7czoxMjoiZnVsbG9yZGVyaW5nIjtzOjEwOiJmb2xkZXIgQVNDIjtzOjU6ImxpbWl0IjtzOjE6IjAiO3M6OToic29ydFRhYmxlIjtzOjY6ImZvbGRlciI7czoxNDoiZGlyZWN0aW9uVGFibGUiO3M6MzoiQVNDIjt9czoxMDoibGltaXRzdGFydCI7aTowO319fXM6MTQ6IgAqAGluaXRpYWxpemVkIjtiOjA7czo5OiJzZXBhcmF0b3IiO3M6MToiLiI7fXM6NDoidXNlciI7TzoyMDoiSm9vbWxhXENNU1xVc2VyXFVzZXIiOjE6e3M6MjoiaWQiO2k6NjA1O31zOjE5OiJwbGdfc3lzdGVtX3dlYmF1dGhuIjtPOjg6InN0ZENsYXNzIjoxOntzOjk6InJldHVyblVybCI7czo0NToiaHR0cHM6Ly9vdHVzLmludGVybmFsL2FkbWluaXN0cmF0b3IvaW5kZXgucGhwIjt9czoxMToiYXBwbGljYXRpb24iO086ODoic3RkQ2xhc3MiOjE6e3M6NToicXVldWUiO2E6MDp7fX19czoxNDoiACoAaW5pdGlhbGl6ZWQiO2I6MDtzOjk6InNlcGFyYXRvciI7czoxOiIuIjt9";	605	otus
\\x736f7134626e3366616e68386731706c3230753931747168356c	0	1	1633210096	joomla|s:900:"TzoyNDoiSm9vbWxhXFJlZ2lzdHJ5XFJlZ2lzdHJ5IjozOntzOjc6IgAqAGRhdGEiO086ODoic3RkQ2xhc3MiOjQ6e3M6Nzoic2Vzc2lvbiI7Tzo4OiJzdGRDbGFzcyI6NDp7czo3OiJjb3VudGVyIjtpOjE7czo1OiJ0aW1lciI7Tzo4OiJzdGRDbGFzcyI6Mzp7czo1OiJzdGFydCI7aToxNjMzMjEwMDk2O3M6NDoibGFzdCI7aToxNjMzMjEwMDk2O3M6Mzoibm93IjtpOjE2MzMyMTAwOTY7fXM6NjoiY2xpZW50IjtPOjg6InN0ZENsYXNzIjoxOntzOjc6ImFkZHJlc3MiO3M6MTQ6IjE5My4xMTguNTMuMjAyIjt9czo1OiJ0b2tlbiI7czozMjoiYzc2OTdiNDc1MDdkNjY1MDE2ZmYzM2U2NDJhNTVlNTkiO31zOjg6InJlZ2lzdHJ5IjtPOjI0OiJKb29tbGFcUmVnaXN0cnlcUmVnaXN0cnkiOjM6e3M6NzoiACoAZGF0YSI7Tzo4OiJzdGRDbGFzcyI6MDp7fXM6MTQ6IgAqAGluaXRpYWxpemVkIjtiOjA7czo5OiJzZXBhcmF0b3IiO3M6MToiLiI7fXM6NDoidXNlciI7TzoyMDoiSm9vbWxhXENNU1xVc2VyXFVzZXIiOjE6e3M6MjoiaWQiO2k6MDt9czoxOToicGxnX3N5c3RlbV93ZWJhdXRobiI7Tzo4OiJzdGRDbGFzcyI6MTp7czo5OiJyZXR1cm5VcmwiO3M6MjE6Imh0dHBzOi8vNjIuODQuMTE5LjQwLyI7fX1zOjE0OiIAKgBpbml0aWFsaXplZCI7YjowO3M6OToic2VwYXJhdG9yIjtzOjE6Ii4iO30=";	0	
\\x75627369346d6f73733865663437743333676667303765746436	0	1	1633216114	joomla|s:776:"TzoyNDoiSm9vbWxhXFJlZ2lzdHJ5XFJlZ2lzdHJ5IjozOntzOjc6IgAqAGRhdGEiO086ODoic3RkQ2xhc3MiOjM6e3M6Nzoic2Vzc2lvbiI7Tzo4OiJzdGRDbGFzcyI6NDp7czo1OiJ0aW1lciI7Tzo4OiJzdGRDbGFzcyI6Mzp7czo1OiJzdGFydCI7aToxNjMzMjEwNTU2O3M6NDoibGFzdCI7aToxNjMzMjE1Mjc0O3M6Mzoibm93IjtpOjE2MzMyMTYxMTQ7fXM6NzoiY291bnRlciI7aTo5O3M6NjoiY2xpZW50IjtPOjg6InN0ZENsYXNzIjoxOntzOjc6ImFkZHJlc3MiO3M6MTE6Ijk1LjMxLjQzLjgwIjt9czo1OiJ0b2tlbiI7czozMjoiMGJkMzk5NTJlNDkyM2U0MjI3ZjE4ZTVkOThhMzYxOTkiO31zOjg6InJlZ2lzdHJ5IjtPOjI0OiJKb29tbGFcUmVnaXN0cnlcUmVnaXN0cnkiOjM6e3M6NzoiACoAZGF0YSI7Tzo4OiJzdGRDbGFzcyI6MDp7fXM6MTQ6IgAqAGluaXRpYWxpemVkIjtiOjA7czo5OiJzZXBhcmF0b3IiO3M6MToiLiI7fXM6NDoidXNlciI7TzoyMDoiSm9vbWxhXENNU1xVc2VyXFVzZXIiOjE6e3M6MjoiaWQiO2k6MDt9fXM6MTQ6IgAqAGluaXRpYWxpemVkIjtiOjA7czo5OiJzZXBhcmF0b3IiO3M6MToiLiI7fQ==";	0	
\.


--
-- Data for Name: joomla_tags; Type: TABLE DATA; Schema: public; Owner: joomla_user
--

COPY public.joomla_tags (id, parent_id, lft, rgt, level, path, title, alias, note, description, published, checked_out, checked_out_time, access, params, metadesc, metakey, metadata, created_user_id, created_time, created_by_alias, modified_user_id, modified_time, images, urls, hits, language, version, publish_up, publish_down) FROM stdin;
1	0	0	1	0		ROOT	root			1	\N	\N	1					605	2021-10-02 19:08:16.544668		605	2021-10-02 19:08:16.544668			0	*	1	\N	\N
\.


--
-- Data for Name: joomla_template_overrides; Type: TABLE DATA; Schema: public; Owner: joomla_user
--

COPY public.joomla_template_overrides (id, template, hash_id, extension_id, state, action, client_id, created_date, modified_date) FROM stdin;
\.


--
-- Data for Name: joomla_template_styles; Type: TABLE DATA; Schema: public; Owner: joomla_user
--

COPY public.joomla_template_styles (id, template, client_id, home, title, inheritable, parent, params) FROM stdin;
10	atum	1	1	Atum - Default	0		{"hue":"hsl(214, 63%, 20%)","bg-light":"#f0f4fb","text-dark":"#495057","text-light":"#ffffff","link-color":"#2a69b8","special-color":"#001b4c","monochrome":"0","loginLogo":"","loginLogoAlt":"","logoBrandLarge":"","logoBrandLargeAlt":"","logoBrandSmall":"","logoBrandSmallAlt":""}
11	cassiopeia	0	1	Cassiopeia - Default	0		{"brand":"1","logoFile":"","siteTitle":"","siteDescription":"","useFontScheme":"0","colorName":"colors_standard","fluidContainer":"0","stickyHeader":0,"backTop":0}
\.


--
-- Data for Name: joomla_ucm_base; Type: TABLE DATA; Schema: public; Owner: joomla_user
--

COPY public.joomla_ucm_base (ucm_id, ucm_item_id, ucm_type_id, ucm_language_id) FROM stdin;
\.


--
-- Data for Name: joomla_ucm_content; Type: TABLE DATA; Schema: public; Owner: joomla_user
--

COPY public.joomla_ucm_content (core_content_id, core_type_alias, core_title, core_alias, core_body, core_state, core_checked_out_time, core_checked_out_user_id, core_access, core_params, core_featured, core_metadata, core_created_user_id, core_created_by_alias, core_created_time, core_modified_user_id, core_modified_time, core_language, core_publish_up, core_publish_down, core_content_item_id, asset_id, core_images, core_urls, core_hits, core_version, core_ordering, core_metakey, core_metadesc, core_catid, core_type_id) FROM stdin;
\.


--
-- Data for Name: joomla_update_sites; Type: TABLE DATA; Schema: public; Owner: joomla_user
--

COPY public.joomla_update_sites (update_site_id, name, type, location, enabled, last_check_timestamp, extra_query, checked_out, checked_out_time) FROM stdin;
1	Joomla! Core	collection	https://update.joomla.org/core/list.xml	1	1633210081		\N	\N
2	Accredited Joomla! Translations	collection	https://update.joomla.org/language/translationlist_4.xml	1	1633210081		\N	\N
3	Joomla! Update Component Update Site	extension	https://update.joomla.org/core/extensions/com_joomlaupdate.xml	1	1633210081		\N	\N
\.


--
-- Data for Name: joomla_update_sites_extensions; Type: TABLE DATA; Schema: public; Owner: joomla_user
--

COPY public.joomla_update_sites_extensions (update_site_id, extension_id) FROM stdin;
1	211
2	212
3	24
2	219
\.


--
-- Data for Name: joomla_updates; Type: TABLE DATA; Schema: public; Owner: joomla_user
--

COPY public.joomla_updates (update_id, update_site_id, extension_id, name, description, element, type, folder, client_id, version, data, detailsurl, infourl, changelogurl, extra_query) FROM stdin;
1334	2	0	Arabic Unitag		pkg_ar-AA	package		0	4.0.2.1		https://update.joomla.org/language/details4/ar-AA_details.xml			
1335	2	0	Chinese, Simplified		pkg_zh-CN	package		0	4.0.3.1		https://update.joomla.org/language/details4/zh-CN_details.xml			
1336	2	0	Chinese, Traditional		pkg_zh-TW	package		0	4.0.3.1		https://update.joomla.org/language/details4/zh-TW_details.xml			
1337	2	0	Czech		pkg_cs-CZ	package		0	4.0.3.1		https://update.joomla.org/language/details4/cs-CZ_details.xml			
1338	2	0	Danish		pkg_da-DK	package		0	4.0.3.1		https://update.joomla.org/language/details4/da-DK_details.xml			
1339	2	0	Dutch		pkg_nl-NL	package		0	4.0.3.1		https://update.joomla.org/language/details4/nl-NL_details.xml			
1340	2	0	English, Australia		pkg_en-AU	package		0	4.0.4.1		https://update.joomla.org/language/details4/en-AU_details.xml			
1341	2	0	English, USA		pkg_en-US	package		0	4.0.4.1		https://update.joomla.org/language/details4/en-US_details.xml			
1342	2	0	Flemish		pkg_nl-BE	package		0	4.0.3.1		https://update.joomla.org/language/details4/nl-BE_details.xml			
1343	2	0	French		pkg_fr-FR	package		0	4.0.3.1		https://update.joomla.org/language/details4/fr-FR_details.xml			
1344	2	0	Georgian		pkg_ka-GE	package		0	4.0.3.1		https://update.joomla.org/language/details4/ka-GE_details.xml			
1345	2	0	German		pkg_de-DE	package		0	4.0.3.1		https://update.joomla.org/language/details4/de-DE_details.xml			
1346	2	0	German, Austria		pkg_de-AT	package		0	4.0.3.1		https://update.joomla.org/language/details4/de-AT_details.xml			
1347	2	0	German, Liechtenstein		pkg_de-LI	package		0	4.0.3.1		https://update.joomla.org/language/details4/de-LI_details.xml			
1348	2	0	German, Luxembourg		pkg_de-LU	package		0	4.0.3.1		https://update.joomla.org/language/details4/de-LU_details.xml			
1349	2	0	German, Switzerland		pkg_de-CH	package		0	4.0.3.1		https://update.joomla.org/language/details4/de-CH_details.xml			
1350	2	0	Greek		pkg_el-GR	package		0	4.0.3.1		https://update.joomla.org/language/details4/el-GR_details.xml			
1351	2	0	Hungarian		pkg_hu-HU	package		0	4.0.3.1		https://update.joomla.org/language/details4/hu-HU_details.xml			
1352	2	0	Italian		pkg_it-IT	package		0	4.0.3.1		https://update.joomla.org/language/details4/it-IT_details.xml			
1353	2	0	Japanese		pkg_ja-JP	package		0	4.0.3.1		https://update.joomla.org/language/details4/ja-JP_details.xml			
1354	2	0	Norwegian Bokmål		pkg_nb-NO	package		0	4.0.1.1		https://update.joomla.org/language/details4/nb-NO_details.xml			
1355	2	0	Persian Farsi		pkg_fa-IR	package		0	4.0.1.4		https://update.joomla.org/language/details4/fa-IR_details.xml			
1356	2	0	Polish		pkg_pl-PL	package		0	4.0.3.1		https://update.joomla.org/language/details4/pl-PL_details.xml			
1357	2	0	Portuguese, Brazil		pkg_pt-BR	package		0	4.0.3.1		https://update.joomla.org/language/details4/pt-BR_details.xml			
1358	2	0	Portuguese, Portugal		pkg_pt-PT	package		0	4.0.0-rc4.2		https://update.joomla.org/language/details4/pt-PT_details.xml			
1359	2	0	Romanian		pkg_ro-RO	package		0	4.0.3.1		https://update.joomla.org/language/details4/ro-RO_details.xml			
1360	2	0	Slovak		pkg_sk-SK	package		0	4.0.3.3		https://update.joomla.org/language/details4/sk-SK_details.xml			
1361	2	0	Slovenian		pkg_sl-SI	package		0	4.0.3.2		https://update.joomla.org/language/details4/sl-SI_details.xml			
1362	2	0	Spanish		pkg_es-ES	package		0	4.0.3.1		https://update.joomla.org/language/details4/es-ES_details.xml			
1363	2	0	Swedish		pkg_sv-SE	package		0	4.0.2.4		https://update.joomla.org/language/details4/sv-SE_details.xml			
1364	2	0	Tamil, India		pkg_ta-IN	package		0	4.0.3.1		https://update.joomla.org/language/details4/ta-IN_details.xml			
1365	2	0	Thai		pkg_th-TH	package		0	4.0.3.1		https://update.joomla.org/language/details4/th-TH_details.xml			
1366	2	0	Turkish		pkg_tr-TR	package		0	4.0.3.1		https://update.joomla.org/language/details4/tr-TR_details.xml			
1367	2	0	Ukrainian		pkg_uk-UA	package		0	4.0.3.2		https://update.joomla.org/language/details4/uk-UA_details.xml			
1368	2	0	Welsh		pkg_cy-GB	package		0	4.0.3.1		https://update.joomla.org/language/details4/cy-GB_details.xml			
\.


--
-- Data for Name: joomla_user_keys; Type: TABLE DATA; Schema: public; Owner: joomla_user
--

COPY public.joomla_user_keys (id, user_id, token, series, "time", uastring) FROM stdin;
\.


--
-- Data for Name: joomla_user_notes; Type: TABLE DATA; Schema: public; Owner: joomla_user
--

COPY public.joomla_user_notes (id, user_id, catid, subject, body, state, checked_out, checked_out_time, created_user_id, created_time, modified_user_id, modified_time, review_time, publish_up, publish_down) FROM stdin;
\.


--
-- Data for Name: joomla_user_profiles; Type: TABLE DATA; Schema: public; Owner: joomla_user
--

COPY public.joomla_user_profiles (user_id, profile_key, profile_value, ordering) FROM stdin;
\.


--
-- Data for Name: joomla_user_usergroup_map; Type: TABLE DATA; Schema: public; Owner: joomla_user
--

COPY public.joomla_user_usergroup_map (user_id, group_id) FROM stdin;
605	8
\.


--
-- Data for Name: joomla_usergroups; Type: TABLE DATA; Schema: public; Owner: joomla_user
--

COPY public.joomla_usergroups (id, parent_id, lft, rgt, title) FROM stdin;
1	0	1	18	Public
2	1	8	15	Registered
3	2	9	14	Author
4	3	10	13	Editor
5	4	11	12	Publisher
6	1	4	7	Manager
7	6	5	6	Administrator
8	1	16	17	Super Users
9	1	2	3	Guest
\.


--
-- Data for Name: joomla_users; Type: TABLE DATA; Schema: public; Owner: joomla_user
--

COPY public.joomla_users (id, name, username, email, password, block, "sendEmail", "registerDate", "lastvisitDate", activation, params, "lastResetTime", "resetCount", "otpKey", otep, "requireReset") FROM stdin;
605	otus	otus	admin@otus.internal	$2y$10$ee0z44g0xFwyhgmujF0baeLDPJSrB8fPYTuLWhj9rqgH8NrD8vUbG	0	1	2021-10-02 16:08:22	2021-10-02 21:35:56	0		\N	0			0
\.


--
-- Data for Name: joomla_viewlevels; Type: TABLE DATA; Schema: public; Owner: joomla_user
--

COPY public.joomla_viewlevels (id, title, ordering, rules) FROM stdin;
1	Public	0	[1]
2	Registered	2	[6,2,8]
3	Special	3	[6,3,8]
5	Guest	1	[9]
6	Super Users	4	[8]
\.


--
-- Data for Name: joomla_webauthn_credentials; Type: TABLE DATA; Schema: public; Owner: joomla_user
--

COPY public.joomla_webauthn_credentials (id, user_id, label, credential) FROM stdin;
\.


--
-- Data for Name: joomla_workflow_associations; Type: TABLE DATA; Schema: public; Owner: joomla_user
--

COPY public.joomla_workflow_associations (item_id, stage_id, extension) FROM stdin;
\.


--
-- Data for Name: joomla_workflow_stages; Type: TABLE DATA; Schema: public; Owner: joomla_user
--

COPY public.joomla_workflow_stages (id, asset_id, ordering, workflow_id, published, title, description, "default", checked_out_time, checked_out) FROM stdin;
1	57	1	1	1	COM_WORKFLOW_BASIC_STAGE		1	\N	\N
\.


--
-- Data for Name: joomla_workflow_transitions; Type: TABLE DATA; Schema: public; Owner: joomla_user
--

COPY public.joomla_workflow_transitions (id, asset_id, ordering, workflow_id, published, title, description, from_stage_id, to_stage_id, options, checked_out_time, checked_out) FROM stdin;
1	58	1	1	1	UNPUBLISH		-1	1	{"publishing":"0"}	\N	\N
2	59	2	1	1	PUBLISH		-1	1	{"publishing":"1"}	\N	\N
3	60	3	1	1	TRASH		-1	1	{"publishing":"-2"}	\N	\N
4	61	4	1	1	ARCHIVE		-1	1	{"publishing":"2"}	\N	\N
5	62	5	1	1	FEATURE		-1	1	{"featuring":"1"}	\N	\N
6	63	6	1	1	UNFEATURE		-1	1	{"featuring":"0"}	\N	\N
7	64	7	1	1	PUBLISH_AND_FEATURE		-1	1	{"publishing":"1","featuring":"1"}	\N	\N
\.


--
-- Data for Name: joomla_workflows; Type: TABLE DATA; Schema: public; Owner: joomla_user
--

COPY public.joomla_workflows (id, asset_id, published, title, description, extension, "default", ordering, created, created_by, modified, modified_by, checked_out_time, checked_out) FROM stdin;
1	56	1	COM_WORKFLOW_BASIC_WORKFLOW		com_content.article	1	1	2021-10-02 19:08:17.130703	605	2021-10-02 19:08:17.130703	605	\N	\N
\.


--
-- Name: joomla_action_log_config_id_seq; Type: SEQUENCE SET; Schema: public; Owner: joomla_user
--

SELECT pg_catalog.setval('public.joomla_action_log_config_id_seq', 20, false);


--
-- Name: joomla_action_logs_extensions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: joomla_user
--

SELECT pg_catalog.setval('public.joomla_action_logs_extensions_id_seq', 19, false);


--
-- Name: joomla_action_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: joomla_user
--

SELECT pg_catalog.setval('public.joomla_action_logs_id_seq', 40, true);


--
-- Name: joomla_assets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: joomla_user
--

SELECT pg_catalog.setval('public.joomla_assets_id_seq', 91, true);


--
-- Name: joomla_banner_clients_id_seq; Type: SEQUENCE SET; Schema: public; Owner: joomla_user
--

SELECT pg_catalog.setval('public.joomla_banner_clients_id_seq', 1, false);


--
-- Name: joomla_banners_id_seq; Type: SEQUENCE SET; Schema: public; Owner: joomla_user
--

SELECT pg_catalog.setval('public.joomla_banners_id_seq', 1, false);


--
-- Name: joomla_categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: joomla_user
--

SELECT pg_catalog.setval('public.joomla_categories_id_seq', 8, false);


--
-- Name: joomla_contact_details_id_seq; Type: SEQUENCE SET; Schema: public; Owner: joomla_user
--

SELECT pg_catalog.setval('public.joomla_contact_details_id_seq', 1, false);


--
-- Name: joomla_content_id_seq; Type: SEQUENCE SET; Schema: public; Owner: joomla_user
--

SELECT pg_catalog.setval('public.joomla_content_id_seq', 1, false);


--
-- Name: joomla_content_types_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: joomla_user
--

SELECT pg_catalog.setval('public.joomla_content_types_type_id_seq', 10000, false);


--
-- Name: joomla_extensions_extension_id_seq; Type: SEQUENCE SET; Schema: public; Owner: joomla_user
--

SELECT pg_catalog.setval('public.joomla_extensions_extension_id_seq', 222, true);


--
-- Name: joomla_fields_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: joomla_user
--

SELECT pg_catalog.setval('public.joomla_fields_groups_id_seq', 1, false);


--
-- Name: joomla_fields_id_seq; Type: SEQUENCE SET; Schema: public; Owner: joomla_user
--

SELECT pg_catalog.setval('public.joomla_fields_id_seq', 1, false);


--
-- Name: joomla_finder_filters_filter_id_seq; Type: SEQUENCE SET; Schema: public; Owner: joomla_user
--

SELECT pg_catalog.setval('public.joomla_finder_filters_filter_id_seq', 1, false);


--
-- Name: joomla_finder_links_link_id_seq; Type: SEQUENCE SET; Schema: public; Owner: joomla_user
--

SELECT pg_catalog.setval('public.joomla_finder_links_link_id_seq', 1, false);


--
-- Name: joomla_finder_taxonomy_id_seq; Type: SEQUENCE SET; Schema: public; Owner: joomla_user
--

SELECT pg_catalog.setval('public.joomla_finder_taxonomy_id_seq', 2, false);


--
-- Name: joomla_finder_terms_term_id_seq; Type: SEQUENCE SET; Schema: public; Owner: joomla_user
--

SELECT pg_catalog.setval('public.joomla_finder_terms_term_id_seq', 1, false);


--
-- Name: joomla_finder_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: joomla_user
--

SELECT pg_catalog.setval('public.joomla_finder_types_id_seq', 5, true);


--
-- Name: joomla_history_version_id_seq; Type: SEQUENCE SET; Schema: public; Owner: joomla_user
--

SELECT pg_catalog.setval('public.joomla_history_version_id_seq', 1, false);


--
-- Name: joomla_languages_lang_id_seq; Type: SEQUENCE SET; Schema: public; Owner: joomla_user
--

SELECT pg_catalog.setval('public.joomla_languages_lang_id_seq', 2, true);


--
-- Name: joomla_menu_id_seq; Type: SEQUENCE SET; Schema: public; Owner: joomla_user
--

SELECT pg_catalog.setval('public.joomla_menu_id_seq', 102, false);


--
-- Name: joomla_menu_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: joomla_user
--

SELECT pg_catalog.setval('public.joomla_menu_types_id_seq', 2, false);


--
-- Name: joomla_messages_message_id_seq; Type: SEQUENCE SET; Schema: public; Owner: joomla_user
--

SELECT pg_catalog.setval('public.joomla_messages_message_id_seq', 1, false);


--
-- Name: joomla_modules_id_seq; Type: SEQUENCE SET; Schema: public; Owner: joomla_user
--

SELECT pg_catalog.setval('public.joomla_modules_id_seq', 110, true);


--
-- Name: joomla_newsfeeds_id_seq; Type: SEQUENCE SET; Schema: public; Owner: joomla_user
--

SELECT pg_catalog.setval('public.joomla_newsfeeds_id_seq', 1, false);


--
-- Name: joomla_overrider_id_seq; Type: SEQUENCE SET; Schema: public; Owner: joomla_user
--

SELECT pg_catalog.setval('public.joomla_overrider_id_seq', 1, false);


--
-- Name: joomla_postinstall_messages_postinstall_message_id_seq; Type: SEQUENCE SET; Schema: public; Owner: joomla_user
--

SELECT pg_catalog.setval('public.joomla_postinstall_messages_postinstall_message_id_seq', 6, true);


--
-- Name: joomla_privacy_consents_id_seq; Type: SEQUENCE SET; Schema: public; Owner: joomla_user
--

SELECT pg_catalog.setval('public.joomla_privacy_consents_id_seq', 1, false);


--
-- Name: joomla_privacy_requests_id_seq; Type: SEQUENCE SET; Schema: public; Owner: joomla_user
--

SELECT pg_catalog.setval('public.joomla_privacy_requests_id_seq', 1, false);


--
-- Name: joomla_redirect_links_id_seq; Type: SEQUENCE SET; Schema: public; Owner: joomla_user
--

SELECT pg_catalog.setval('public.joomla_redirect_links_id_seq', 1, false);


--
-- Name: joomla_tags_id_seq; Type: SEQUENCE SET; Schema: public; Owner: joomla_user
--

SELECT pg_catalog.setval('public.joomla_tags_id_seq', 2, false);


--
-- Name: joomla_template_overrides_id_seq; Type: SEQUENCE SET; Schema: public; Owner: joomla_user
--

SELECT pg_catalog.setval('public.joomla_template_overrides_id_seq', 1, false);


--
-- Name: joomla_template_styles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: joomla_user
--

SELECT pg_catalog.setval('public.joomla_template_styles_id_seq', 12, false);


--
-- Name: joomla_ucm_base_ucm_id_seq; Type: SEQUENCE SET; Schema: public; Owner: joomla_user
--

SELECT pg_catalog.setval('public.joomla_ucm_base_ucm_id_seq', 1, false);


--
-- Name: joomla_ucm_content_core_content_id_seq; Type: SEQUENCE SET; Schema: public; Owner: joomla_user
--

SELECT pg_catalog.setval('public.joomla_ucm_content_core_content_id_seq', 1, false);


--
-- Name: joomla_update_sites_update_site_id_seq; Type: SEQUENCE SET; Schema: public; Owner: joomla_user
--

SELECT pg_catalog.setval('public.joomla_update_sites_update_site_id_seq', 4, false);


--
-- Name: joomla_updates_update_id_seq; Type: SEQUENCE SET; Schema: public; Owner: joomla_user
--

SELECT pg_catalog.setval('public.joomla_updates_update_id_seq', 1368, true);


--
-- Name: joomla_user_keys_id_seq; Type: SEQUENCE SET; Schema: public; Owner: joomla_user
--

SELECT pg_catalog.setval('public.joomla_user_keys_id_seq', 1, false);


--
-- Name: joomla_user_notes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: joomla_user
--

SELECT pg_catalog.setval('public.joomla_user_notes_id_seq', 1, false);


--
-- Name: joomla_usergroups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: joomla_user
--

SELECT pg_catalog.setval('public.joomla_usergroups_id_seq', 10, false);


--
-- Name: joomla_users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: joomla_user
--

SELECT pg_catalog.setval('public.joomla_users_id_seq', 1, false);


--
-- Name: joomla_viewlevels_id_seq; Type: SEQUENCE SET; Schema: public; Owner: joomla_user
--

SELECT pg_catalog.setval('public.joomla_viewlevels_id_seq', 7, false);


--
-- Name: joomla_workflow_stages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: joomla_user
--

SELECT pg_catalog.setval('public.joomla_workflow_stages_id_seq', 2, false);


--
-- Name: joomla_workflow_transitions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: joomla_user
--

SELECT pg_catalog.setval('public.joomla_workflow_transitions_id_seq', 8, false);


--
-- Name: joomla_workflows_id_seq; Type: SEQUENCE SET; Schema: public; Owner: joomla_user
--

SELECT pg_catalog.setval('public.joomla_workflows_id_seq', 2, false);


--
-- Name: joomla_action_log_config joomla_action_log_config_pkey; Type: CONSTRAINT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_action_log_config
    ADD CONSTRAINT joomla_action_log_config_pkey PRIMARY KEY (id);


--
-- Name: joomla_action_logs_extensions joomla_action_logs_extensions_pkey; Type: CONSTRAINT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_action_logs_extensions
    ADD CONSTRAINT joomla_action_logs_extensions_pkey PRIMARY KEY (id);


--
-- Name: joomla_action_logs joomla_action_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_action_logs
    ADD CONSTRAINT joomla_action_logs_pkey PRIMARY KEY (id);


--
-- Name: joomla_action_logs_users joomla_action_logs_users_pkey; Type: CONSTRAINT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_action_logs_users
    ADD CONSTRAINT joomla_action_logs_users_pkey PRIMARY KEY (user_id);


--
-- Name: joomla_assets joomla_assets_idx_asset_name; Type: CONSTRAINT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_assets
    ADD CONSTRAINT joomla_assets_idx_asset_name UNIQUE (name);


--
-- Name: joomla_assets joomla_assets_pkey; Type: CONSTRAINT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_assets
    ADD CONSTRAINT joomla_assets_pkey PRIMARY KEY (id);


--
-- Name: joomla_associations joomla_associations_idx_context_id; Type: CONSTRAINT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_associations
    ADD CONSTRAINT joomla_associations_idx_context_id PRIMARY KEY (context, id);


--
-- Name: joomla_banner_clients joomla_banner_clients_pkey; Type: CONSTRAINT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_banner_clients
    ADD CONSTRAINT joomla_banner_clients_pkey PRIMARY KEY (id);


--
-- Name: joomla_banner_tracks joomla_banner_tracks_pkey; Type: CONSTRAINT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_banner_tracks
    ADD CONSTRAINT joomla_banner_tracks_pkey PRIMARY KEY (track_date, track_type, banner_id);


--
-- Name: joomla_banners joomla_banners_pkey; Type: CONSTRAINT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_banners
    ADD CONSTRAINT joomla_banners_pkey PRIMARY KEY (id);


--
-- Name: joomla_categories joomla_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_categories
    ADD CONSTRAINT joomla_categories_pkey PRIMARY KEY (id);


--
-- Name: joomla_contact_details joomla_contact_details_pkey; Type: CONSTRAINT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_contact_details
    ADD CONSTRAINT joomla_contact_details_pkey PRIMARY KEY (id);


--
-- Name: joomla_content_frontpage joomla_content_frontpage_pkey; Type: CONSTRAINT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_content_frontpage
    ADD CONSTRAINT joomla_content_frontpage_pkey PRIMARY KEY (content_id);


--
-- Name: joomla_content joomla_content_pkey; Type: CONSTRAINT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_content
    ADD CONSTRAINT joomla_content_pkey PRIMARY KEY (id);


--
-- Name: joomla_content_rating joomla_content_rating_pkey; Type: CONSTRAINT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_content_rating
    ADD CONSTRAINT joomla_content_rating_pkey PRIMARY KEY (content_id);


--
-- Name: joomla_content_types joomla_content_types_pkey; Type: CONSTRAINT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_content_types
    ADD CONSTRAINT joomla_content_types_pkey PRIMARY KEY (type_id);


--
-- Name: joomla_contentitem_tag_map joomla_contentitem_tag_map_pkey; Type: CONSTRAINT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_contentitem_tag_map
    ADD CONSTRAINT joomla_contentitem_tag_map_pkey PRIMARY KEY (type_id, content_item_id, tag_id);


--
-- Name: joomla_extensions joomla_extensions_pkey; Type: CONSTRAINT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_extensions
    ADD CONSTRAINT joomla_extensions_pkey PRIMARY KEY (extension_id);


--
-- Name: joomla_fields_categories joomla_fields_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_fields_categories
    ADD CONSTRAINT joomla_fields_categories_pkey PRIMARY KEY (field_id, category_id);


--
-- Name: joomla_fields_groups joomla_fields_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_fields_groups
    ADD CONSTRAINT joomla_fields_groups_pkey PRIMARY KEY (id);


--
-- Name: joomla_fields joomla_fields_pkey; Type: CONSTRAINT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_fields
    ADD CONSTRAINT joomla_fields_pkey PRIMARY KEY (id);


--
-- Name: joomla_finder_filters joomla_finder_filters_pkey; Type: CONSTRAINT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_finder_filters
    ADD CONSTRAINT joomla_finder_filters_pkey PRIMARY KEY (filter_id);


--
-- Name: joomla_finder_links joomla_finder_links_pkey; Type: CONSTRAINT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_finder_links
    ADD CONSTRAINT joomla_finder_links_pkey PRIMARY KEY (link_id);


--
-- Name: joomla_finder_links_terms joomla_finder_links_terms_pkey; Type: CONSTRAINT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_finder_links_terms
    ADD CONSTRAINT joomla_finder_links_terms_pkey PRIMARY KEY (link_id, term_id);


--
-- Name: joomla_finder_logging joomla_finder_logging_pkey; Type: CONSTRAINT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_finder_logging
    ADD CONSTRAINT joomla_finder_logging_pkey PRIMARY KEY (md5sum);


--
-- Name: joomla_finder_taxonomy_map joomla_finder_taxonomy_map_pkey; Type: CONSTRAINT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_finder_taxonomy_map
    ADD CONSTRAINT joomla_finder_taxonomy_map_pkey PRIMARY KEY (link_id, node_id);


--
-- Name: joomla_finder_taxonomy joomla_finder_taxonomy_pkey; Type: CONSTRAINT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_finder_taxonomy
    ADD CONSTRAINT joomla_finder_taxonomy_pkey PRIMARY KEY (id);


--
-- Name: joomla_finder_terms_common joomla_finder_terms_common_idx_term_language; Type: CONSTRAINT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_finder_terms_common
    ADD CONSTRAINT joomla_finder_terms_common_idx_term_language UNIQUE (term, language);


--
-- Name: joomla_finder_terms joomla_finder_terms_idx_term_language; Type: CONSTRAINT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_finder_terms
    ADD CONSTRAINT joomla_finder_terms_idx_term_language UNIQUE (term, language);


--
-- Name: joomla_finder_terms joomla_finder_terms_pkey; Type: CONSTRAINT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_finder_terms
    ADD CONSTRAINT joomla_finder_terms_pkey PRIMARY KEY (term_id);


--
-- Name: joomla_finder_types joomla_finder_types_pkey; Type: CONSTRAINT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_finder_types
    ADD CONSTRAINT joomla_finder_types_pkey PRIMARY KEY (id);


--
-- Name: joomla_finder_types joomla_finder_types_title; Type: CONSTRAINT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_finder_types
    ADD CONSTRAINT joomla_finder_types_title UNIQUE (title);


--
-- Name: joomla_history joomla_history_pkey; Type: CONSTRAINT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_history
    ADD CONSTRAINT joomla_history_pkey PRIMARY KEY (version_id);


--
-- Name: joomla_languages joomla_languages_idx_langcode; Type: CONSTRAINT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_languages
    ADD CONSTRAINT joomla_languages_idx_langcode UNIQUE (lang_code);


--
-- Name: joomla_languages joomla_languages_idx_sef; Type: CONSTRAINT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_languages
    ADD CONSTRAINT joomla_languages_idx_sef UNIQUE (sef);


--
-- Name: joomla_languages joomla_languages_pkey; Type: CONSTRAINT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_languages
    ADD CONSTRAINT joomla_languages_pkey PRIMARY KEY (lang_id);


--
-- Name: joomla_mail_templates joomla_mail_templates_idx_template_id_language; Type: CONSTRAINT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_mail_templates
    ADD CONSTRAINT joomla_mail_templates_idx_template_id_language UNIQUE (template_id, language);


--
-- Name: joomla_menu joomla_menu_idx_client_id_parent_id_alias_language; Type: CONSTRAINT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_menu
    ADD CONSTRAINT joomla_menu_idx_client_id_parent_id_alias_language UNIQUE (client_id, parent_id, alias, language);


--
-- Name: joomla_menu joomla_menu_pkey; Type: CONSTRAINT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_menu
    ADD CONSTRAINT joomla_menu_pkey PRIMARY KEY (id);


--
-- Name: joomla_menu_types joomla_menu_types_idx_menutype; Type: CONSTRAINT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_menu_types
    ADD CONSTRAINT joomla_menu_types_idx_menutype UNIQUE (menutype);


--
-- Name: joomla_menu_types joomla_menu_types_pkey; Type: CONSTRAINT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_menu_types
    ADD CONSTRAINT joomla_menu_types_pkey PRIMARY KEY (id);


--
-- Name: joomla_messages_cfg joomla_messages_cfg_idx_user_var_name; Type: CONSTRAINT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_messages_cfg
    ADD CONSTRAINT joomla_messages_cfg_idx_user_var_name UNIQUE (user_id, cfg_name);


--
-- Name: joomla_messages joomla_messages_pkey; Type: CONSTRAINT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_messages
    ADD CONSTRAINT joomla_messages_pkey PRIMARY KEY (message_id);


--
-- Name: joomla_modules_menu joomla_modules_menu_pkey; Type: CONSTRAINT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_modules_menu
    ADD CONSTRAINT joomla_modules_menu_pkey PRIMARY KEY (moduleid, menuid);


--
-- Name: joomla_modules joomla_modules_pkey; Type: CONSTRAINT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_modules
    ADD CONSTRAINT joomla_modules_pkey PRIMARY KEY (id);


--
-- Name: joomla_newsfeeds joomla_newsfeeds_pkey; Type: CONSTRAINT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_newsfeeds
    ADD CONSTRAINT joomla_newsfeeds_pkey PRIMARY KEY (id);


--
-- Name: joomla_overrider joomla_overrider_pkey; Type: CONSTRAINT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_overrider
    ADD CONSTRAINT joomla_overrider_pkey PRIMARY KEY (id);


--
-- Name: joomla_postinstall_messages joomla_postinstall_messages_pkey; Type: CONSTRAINT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_postinstall_messages
    ADD CONSTRAINT joomla_postinstall_messages_pkey PRIMARY KEY (postinstall_message_id);


--
-- Name: joomla_privacy_consents joomla_privacy_consents_pkey; Type: CONSTRAINT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_privacy_consents
    ADD CONSTRAINT joomla_privacy_consents_pkey PRIMARY KEY (id);


--
-- Name: joomla_privacy_requests joomla_privacy_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_privacy_requests
    ADD CONSTRAINT joomla_privacy_requests_pkey PRIMARY KEY (id);


--
-- Name: joomla_redirect_links joomla_redirect_links_pkey; Type: CONSTRAINT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_redirect_links
    ADD CONSTRAINT joomla_redirect_links_pkey PRIMARY KEY (id);


--
-- Name: joomla_schemas joomla_schemas_pkey; Type: CONSTRAINT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_schemas
    ADD CONSTRAINT joomla_schemas_pkey PRIMARY KEY (extension_id, version_id);


--
-- Name: joomla_session joomla_session_pkey; Type: CONSTRAINT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_session
    ADD CONSTRAINT joomla_session_pkey PRIMARY KEY (session_id);


--
-- Name: joomla_tags joomla_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_tags
    ADD CONSTRAINT joomla_tags_pkey PRIMARY KEY (id);


--
-- Name: joomla_template_overrides joomla_template_overrides_pkey; Type: CONSTRAINT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_template_overrides
    ADD CONSTRAINT joomla_template_overrides_pkey PRIMARY KEY (id);


--
-- Name: joomla_template_styles joomla_template_styles_pkey; Type: CONSTRAINT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_template_styles
    ADD CONSTRAINT joomla_template_styles_pkey PRIMARY KEY (id);


--
-- Name: joomla_ucm_base joomla_ucm_base_pkey; Type: CONSTRAINT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_ucm_base
    ADD CONSTRAINT joomla_ucm_base_pkey PRIMARY KEY (ucm_id);


--
-- Name: joomla_ucm_content joomla_ucm_content_idx_type_alias_item_id; Type: CONSTRAINT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_ucm_content
    ADD CONSTRAINT joomla_ucm_content_idx_type_alias_item_id UNIQUE (core_type_alias, core_content_item_id);


--
-- Name: joomla_ucm_content joomla_ucm_content_pkey; Type: CONSTRAINT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_ucm_content
    ADD CONSTRAINT joomla_ucm_content_pkey PRIMARY KEY (core_content_id);


--
-- Name: joomla_update_sites_extensions joomla_update_sites_extensions_pkey; Type: CONSTRAINT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_update_sites_extensions
    ADD CONSTRAINT joomla_update_sites_extensions_pkey PRIMARY KEY (update_site_id, extension_id);


--
-- Name: joomla_update_sites joomla_update_sites_pkey; Type: CONSTRAINT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_update_sites
    ADD CONSTRAINT joomla_update_sites_pkey PRIMARY KEY (update_site_id);


--
-- Name: joomla_updates joomla_updates_pkey; Type: CONSTRAINT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_updates
    ADD CONSTRAINT joomla_updates_pkey PRIMARY KEY (update_id);


--
-- Name: joomla_user_keys joomla_user_keys_pkey; Type: CONSTRAINT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_user_keys
    ADD CONSTRAINT joomla_user_keys_pkey PRIMARY KEY (id);


--
-- Name: joomla_user_keys joomla_user_keys_series; Type: CONSTRAINT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_user_keys
    ADD CONSTRAINT joomla_user_keys_series UNIQUE (series);


--
-- Name: joomla_user_notes joomla_user_notes_pkey; Type: CONSTRAINT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_user_notes
    ADD CONSTRAINT joomla_user_notes_pkey PRIMARY KEY (id);


--
-- Name: joomla_user_profiles joomla_user_profiles_idx_user_id_profile_key; Type: CONSTRAINT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_user_profiles
    ADD CONSTRAINT joomla_user_profiles_idx_user_id_profile_key UNIQUE (user_id, profile_key);


--
-- Name: joomla_user_usergroup_map joomla_user_usergroup_map_pkey; Type: CONSTRAINT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_user_usergroup_map
    ADD CONSTRAINT joomla_user_usergroup_map_pkey PRIMARY KEY (user_id, group_id);


--
-- Name: joomla_usergroups joomla_usergroups_idx_usergroup_parent_title_lookup; Type: CONSTRAINT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_usergroups
    ADD CONSTRAINT joomla_usergroups_idx_usergroup_parent_title_lookup UNIQUE (parent_id, title);


--
-- Name: joomla_usergroups joomla_usergroups_pkey; Type: CONSTRAINT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_usergroups
    ADD CONSTRAINT joomla_usergroups_pkey PRIMARY KEY (id);


--
-- Name: joomla_users joomla_users_idx_username; Type: CONSTRAINT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_users
    ADD CONSTRAINT joomla_users_idx_username UNIQUE (username);


--
-- Name: joomla_users joomla_users_pkey; Type: CONSTRAINT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_users
    ADD CONSTRAINT joomla_users_pkey PRIMARY KEY (id);


--
-- Name: joomla_viewlevels joomla_viewlevels_idx_assetgroup_title_lookup; Type: CONSTRAINT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_viewlevels
    ADD CONSTRAINT joomla_viewlevels_idx_assetgroup_title_lookup UNIQUE (title);


--
-- Name: joomla_viewlevels joomla_viewlevels_pkey; Type: CONSTRAINT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_viewlevels
    ADD CONSTRAINT joomla_viewlevels_pkey PRIMARY KEY (id);


--
-- Name: joomla_webauthn_credentials joomla_webauthn_credentials_pkey; Type: CONSTRAINT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_webauthn_credentials
    ADD CONSTRAINT joomla_webauthn_credentials_pkey PRIMARY KEY (id);


--
-- Name: joomla_workflow_associations joomla_workflow_associations_pkey; Type: CONSTRAINT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_workflow_associations
    ADD CONSTRAINT joomla_workflow_associations_pkey PRIMARY KEY (item_id, extension);


--
-- Name: joomla_workflow_stages joomla_workflow_stages_pkey; Type: CONSTRAINT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_workflow_stages
    ADD CONSTRAINT joomla_workflow_stages_pkey PRIMARY KEY (id);


--
-- Name: joomla_workflow_transitions joomla_workflow_transitions_pkey; Type: CONSTRAINT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_workflow_transitions
    ADD CONSTRAINT joomla_workflow_transitions_pkey PRIMARY KEY (id);


--
-- Name: joomla_workflows joomla_workflows_pkey; Type: CONSTRAINT; Schema: public; Owner: joomla_user
--

ALTER TABLE ONLY public.joomla_workflows
    ADD CONSTRAINT joomla_workflows_pkey PRIMARY KEY (id);


--
-- Name: _joomla_finder_tokens_aggregate_keyword_id; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX _joomla_finder_tokens_aggregate_keyword_id ON public.joomla_finder_tokens_aggregate USING btree (term_id);


--
-- Name: joomla_action_logs_idx_extension_itemid; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_action_logs_idx_extension_itemid ON public.joomla_action_logs USING btree (extension, item_id);


--
-- Name: joomla_action_logs_idx_user_id; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_action_logs_idx_user_id ON public.joomla_action_logs USING btree (user_id);


--
-- Name: joomla_action_logs_idx_user_id_extension; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_action_logs_idx_user_id_extension ON public.joomla_action_logs USING btree (user_id, extension);


--
-- Name: joomla_action_logs_idx_user_id_logdate; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_action_logs_idx_user_id_logdate ON public.joomla_action_logs USING btree (user_id, log_date);


--
-- Name: joomla_action_logs_users_idx_notify; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_action_logs_users_idx_notify ON public.joomla_action_logs_users USING btree (notify);


--
-- Name: joomla_assets_idx_lft_rgt; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_assets_idx_lft_rgt ON public.joomla_assets USING btree (lft, rgt);


--
-- Name: joomla_assets_idx_parent_id; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_assets_idx_parent_id ON public.joomla_assets USING btree (parent_id);


--
-- Name: joomla_associations_idx_key; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_associations_idx_key ON public.joomla_associations USING btree (key);


--
-- Name: joomla_banner_clients_idx_metakey_prefix; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_banner_clients_idx_metakey_prefix ON public.joomla_banner_clients USING btree (metakey_prefix);


--
-- Name: joomla_banner_clients_idx_own_prefix; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_banner_clients_idx_own_prefix ON public.joomla_banner_clients USING btree (own_prefix);


--
-- Name: joomla_banner_tracks_idx_banner_id; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_banner_tracks_idx_banner_id ON public.joomla_banner_tracks USING btree (banner_id);


--
-- Name: joomla_banner_tracks_idx_track_date; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_banner_tracks_idx_track_date ON public.joomla_banner_tracks USING btree (track_date);


--
-- Name: joomla_banner_tracks_idx_track_type; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_banner_tracks_idx_track_type ON public.joomla_banner_tracks USING btree (track_type);


--
-- Name: joomla_banners_idx_banner_catid; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_banners_idx_banner_catid ON public.joomla_banners USING btree (catid);


--
-- Name: joomla_banners_idx_language; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_banners_idx_language ON public.joomla_banners USING btree (language);


--
-- Name: joomla_banners_idx_metakey_prefix; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_banners_idx_metakey_prefix ON public.joomla_banners USING btree (metakey_prefix);


--
-- Name: joomla_banners_idx_own_prefix; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_banners_idx_own_prefix ON public.joomla_banners USING btree (own_prefix);


--
-- Name: joomla_banners_idx_state; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_banners_idx_state ON public.joomla_banners USING btree (state);


--
-- Name: joomla_categories_cat_idx; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_categories_cat_idx ON public.joomla_categories USING btree (extension, published, access);


--
-- Name: joomla_categories_idx_access; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_categories_idx_access ON public.joomla_categories USING btree (access);


--
-- Name: joomla_categories_idx_alias; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_categories_idx_alias ON public.joomla_categories USING btree (alias);


--
-- Name: joomla_categories_idx_checkout; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_categories_idx_checkout ON public.joomla_categories USING btree (checked_out);


--
-- Name: joomla_categories_idx_language; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_categories_idx_language ON public.joomla_categories USING btree (language);


--
-- Name: joomla_categories_idx_left_right; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_categories_idx_left_right ON public.joomla_categories USING btree (lft, rgt);


--
-- Name: joomla_categories_idx_path; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_categories_idx_path ON public.joomla_categories USING btree (path);


--
-- Name: joomla_contact_details_idx_access; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_contact_details_idx_access ON public.joomla_contact_details USING btree (access);


--
-- Name: joomla_contact_details_idx_catid; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_contact_details_idx_catid ON public.joomla_contact_details USING btree (catid);


--
-- Name: joomla_contact_details_idx_checkout; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_contact_details_idx_checkout ON public.joomla_contact_details USING btree (checked_out);


--
-- Name: joomla_contact_details_idx_createdby; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_contact_details_idx_createdby ON public.joomla_contact_details USING btree (created_by);


--
-- Name: joomla_contact_details_idx_featured_catid; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_contact_details_idx_featured_catid ON public.joomla_contact_details USING btree (featured, catid);


--
-- Name: joomla_contact_details_idx_language; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_contact_details_idx_language ON public.joomla_contact_details USING btree (language);


--
-- Name: joomla_contact_details_idx_state; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_contact_details_idx_state ON public.joomla_contact_details USING btree (published);


--
-- Name: joomla_content_idx_access; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_content_idx_access ON public.joomla_content USING btree (access);


--
-- Name: joomla_content_idx_alias; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_content_idx_alias ON public.joomla_content USING btree (alias);


--
-- Name: joomla_content_idx_catid; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_content_idx_catid ON public.joomla_content USING btree (catid);


--
-- Name: joomla_content_idx_checkout; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_content_idx_checkout ON public.joomla_content USING btree (checked_out);


--
-- Name: joomla_content_idx_createdby; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_content_idx_createdby ON public.joomla_content USING btree (created_by);


--
-- Name: joomla_content_idx_featured_catid; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_content_idx_featured_catid ON public.joomla_content USING btree (featured, catid);


--
-- Name: joomla_content_idx_language; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_content_idx_language ON public.joomla_content USING btree (language);


--
-- Name: joomla_content_idx_state; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_content_idx_state ON public.joomla_content USING btree (state);


--
-- Name: joomla_content_types_idx_alias; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_content_types_idx_alias ON public.joomla_content_types USING btree (type_alias);


--
-- Name: joomla_contentitem_tag_map_idx_core_content_id; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_contentitem_tag_map_idx_core_content_id ON public.joomla_contentitem_tag_map USING btree (core_content_id);


--
-- Name: joomla_contentitem_tag_map_idx_date_id; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_contentitem_tag_map_idx_date_id ON public.joomla_contentitem_tag_map USING btree (tag_date, tag_id);


--
-- Name: joomla_contentitem_tag_map_idx_tag_type; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_contentitem_tag_map_idx_tag_type ON public.joomla_contentitem_tag_map USING btree (tag_id, type_id);


--
-- Name: joomla_extensions_element_clientid; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_extensions_element_clientid ON public.joomla_extensions USING btree (element, client_id);


--
-- Name: joomla_extensions_element_folder_clientid; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_extensions_element_folder_clientid ON public.joomla_extensions USING btree (element, folder, client_id);


--
-- Name: joomla_extensions_extension; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_extensions_extension ON public.joomla_extensions USING btree (type, element, folder, client_id);


--
-- Name: joomla_fields_groups_idx_access; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_fields_groups_idx_access ON public.joomla_fields_groups USING btree (access);


--
-- Name: joomla_fields_groups_idx_checked_out; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_fields_groups_idx_checked_out ON public.joomla_fields_groups USING btree (checked_out);


--
-- Name: joomla_fields_groups_idx_context; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_fields_groups_idx_context ON public.joomla_fields_groups USING btree (context);


--
-- Name: joomla_fields_groups_idx_created_by; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_fields_groups_idx_created_by ON public.joomla_fields_groups USING btree (created_by);


--
-- Name: joomla_fields_groups_idx_language; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_fields_groups_idx_language ON public.joomla_fields_groups USING btree (language);


--
-- Name: joomla_fields_groups_idx_state; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_fields_groups_idx_state ON public.joomla_fields_groups USING btree (state);


--
-- Name: joomla_fields_idx_access; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_fields_idx_access ON public.joomla_fields USING btree (access);


--
-- Name: joomla_fields_idx_checked_out; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_fields_idx_checked_out ON public.joomla_fields USING btree (checked_out);


--
-- Name: joomla_fields_idx_context; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_fields_idx_context ON public.joomla_fields USING btree (context);


--
-- Name: joomla_fields_idx_created_user_id; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_fields_idx_created_user_id ON public.joomla_fields USING btree (created_user_id);


--
-- Name: joomla_fields_idx_language; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_fields_idx_language ON public.joomla_fields USING btree (language);


--
-- Name: joomla_fields_idx_state; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_fields_idx_state ON public.joomla_fields USING btree (state);


--
-- Name: joomla_fields_values_idx_field_id; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_fields_values_idx_field_id ON public.joomla_fields_values USING btree (field_id);


--
-- Name: joomla_fields_values_idx_item_id; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_fields_values_idx_item_id ON public.joomla_fields_values USING btree (item_id);


--
-- Name: joomla_finder_links_idx_language; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_finder_links_idx_language ON public.joomla_finder_links USING btree (language);


--
-- Name: joomla_finder_links_idx_md5; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_finder_links_idx_md5 ON public.joomla_finder_links USING btree (md5sum);


--
-- Name: joomla_finder_links_idx_published_list; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_finder_links_idx_published_list ON public.joomla_finder_links USING btree (published, state, access, publish_start_date, publish_end_date, list_price);


--
-- Name: joomla_finder_links_idx_published_sale; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_finder_links_idx_published_sale ON public.joomla_finder_links USING btree (published, state, access, publish_start_date, publish_end_date, sale_price);


--
-- Name: joomla_finder_links_idx_title; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_finder_links_idx_title ON public.joomla_finder_links USING btree (title);


--
-- Name: joomla_finder_links_idx_type; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_finder_links_idx_type ON public.joomla_finder_links USING btree (type_id);


--
-- Name: joomla_finder_links_idx_url; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_finder_links_idx_url ON public.joomla_finder_links USING btree (substr((url)::text, 0, 76));


--
-- Name: joomla_finder_links_terms_idx_link_term_weight; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_finder_links_terms_idx_link_term_weight ON public.joomla_finder_links_terms USING btree (link_id, term_id, weight);


--
-- Name: joomla_finder_links_terms_idx_term_weight; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_finder_links_terms_idx_term_weight ON public.joomla_finder_links_terms USING btree (term_id, weight);


--
-- Name: joomla_finder_logging_idx_md5sum; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_finder_logging_idx_md5sum ON public.joomla_finder_logging USING btree (md5sum);


--
-- Name: joomla_finder_logging_idx_searchterm; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_finder_logging_idx_searchterm ON public.joomla_finder_logging USING btree (searchterm);


--
-- Name: joomla_finder_taxonomy_access; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_finder_taxonomy_access ON public.joomla_finder_taxonomy USING btree (access);


--
-- Name: joomla_finder_taxonomy_alias; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_finder_taxonomy_alias ON public.joomla_finder_taxonomy USING btree (alias);


--
-- Name: joomla_finder_taxonomy_idx_parent_published; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_finder_taxonomy_idx_parent_published ON public.joomla_finder_taxonomy USING btree (parent_id, state, access);


--
-- Name: joomla_finder_taxonomy_language; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_finder_taxonomy_language ON public.joomla_finder_taxonomy USING btree (language);


--
-- Name: joomla_finder_taxonomy_level; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_finder_taxonomy_level ON public.joomla_finder_taxonomy USING btree (level);


--
-- Name: joomla_finder_taxonomy_lft_rgt; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_finder_taxonomy_lft_rgt ON public.joomla_finder_taxonomy USING btree (lft, rgt);


--
-- Name: joomla_finder_taxonomy_map_link_id; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_finder_taxonomy_map_link_id ON public.joomla_finder_taxonomy_map USING btree (link_id);


--
-- Name: joomla_finder_taxonomy_map_node_id; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_finder_taxonomy_map_node_id ON public.joomla_finder_taxonomy_map USING btree (node_id);


--
-- Name: joomla_finder_taxonomy_path; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_finder_taxonomy_path ON public.joomla_finder_taxonomy USING btree (path);


--
-- Name: joomla_finder_taxonomy_state; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_finder_taxonomy_state ON public.joomla_finder_taxonomy USING btree (state);


--
-- Name: joomla_finder_terms_common_idx_lang; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_finder_terms_common_idx_lang ON public.joomla_finder_terms_common USING btree (language);


--
-- Name: joomla_finder_terms_idx_language; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_finder_terms_idx_language ON public.joomla_finder_terms USING btree (language);


--
-- Name: joomla_finder_terms_idx_soundex_phrase; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_finder_terms_idx_soundex_phrase ON public.joomla_finder_terms USING btree (soundex, phrase);


--
-- Name: joomla_finder_terms_idx_stem_phrase; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_finder_terms_idx_stem_phrase ON public.joomla_finder_terms USING btree (stem, phrase);


--
-- Name: joomla_finder_terms_idx_term_phrase; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_finder_terms_idx_term_phrase ON public.joomla_finder_terms USING btree (term, phrase);


--
-- Name: joomla_finder_tokens_aggregate_token; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_finder_tokens_aggregate_token ON public.joomla_finder_tokens_aggregate USING btree (term);


--
-- Name: joomla_finder_tokens_idx_context; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_finder_tokens_idx_context ON public.joomla_finder_tokens USING btree (context);


--
-- Name: joomla_finder_tokens_idx_language; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_finder_tokens_idx_language ON public.joomla_finder_tokens USING btree (language);


--
-- Name: joomla_finder_tokens_idx_stem; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_finder_tokens_idx_stem ON public.joomla_finder_tokens USING btree (stem);


--
-- Name: joomla_finder_tokens_idx_word; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_finder_tokens_idx_word ON public.joomla_finder_tokens USING btree (term);


--
-- Name: joomla_history_idx_save_date; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_history_idx_save_date ON public.joomla_history USING btree (save_date);


--
-- Name: joomla_history_idx_ucm_item_id; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_history_idx_ucm_item_id ON public.joomla_history USING btree (item_id);


--
-- Name: joomla_languages_idx_access; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_languages_idx_access ON public.joomla_languages USING btree (access);


--
-- Name: joomla_languages_idx_ordering; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_languages_idx_ordering ON public.joomla_languages USING btree (ordering);


--
-- Name: joomla_mail_templates_idx_language; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_mail_templates_idx_language ON public.joomla_mail_templates USING btree (language);


--
-- Name: joomla_mail_templates_idx_template_id; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_mail_templates_idx_template_id ON public.joomla_mail_templates USING btree (template_id);


--
-- Name: joomla_menu_idx_alias; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_menu_idx_alias ON public.joomla_menu USING btree (alias);


--
-- Name: joomla_menu_idx_componentid; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_menu_idx_componentid ON public.joomla_menu USING btree (component_id, menutype, published, access);


--
-- Name: joomla_menu_idx_language; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_menu_idx_language ON public.joomla_menu USING btree (language);


--
-- Name: joomla_menu_idx_left_right; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_menu_idx_left_right ON public.joomla_menu USING btree (lft, rgt);


--
-- Name: joomla_menu_idx_menutype; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_menu_idx_menutype ON public.joomla_menu USING btree (menutype);


--
-- Name: joomla_menu_idx_path; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_menu_idx_path ON public.joomla_menu USING btree (path);


--
-- Name: joomla_messages_useridto_state; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_messages_useridto_state ON public.joomla_messages USING btree (user_id_to, state);


--
-- Name: joomla_modules_idx_language; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_modules_idx_language ON public.joomla_modules USING btree (language);


--
-- Name: joomla_modules_newsfeeds; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_modules_newsfeeds ON public.joomla_modules USING btree (module, published);


--
-- Name: joomla_modules_published; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_modules_published ON public.joomla_modules USING btree (published, access);


--
-- Name: joomla_newsfeeds_idx_access; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_newsfeeds_idx_access ON public.joomla_newsfeeds USING btree (access);


--
-- Name: joomla_newsfeeds_idx_catid; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_newsfeeds_idx_catid ON public.joomla_newsfeeds USING btree (catid);


--
-- Name: joomla_newsfeeds_idx_checkout; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_newsfeeds_idx_checkout ON public.joomla_newsfeeds USING btree (checked_out);


--
-- Name: joomla_newsfeeds_idx_createdby; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_newsfeeds_idx_createdby ON public.joomla_newsfeeds USING btree (created_by);


--
-- Name: joomla_newsfeeds_idx_language; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_newsfeeds_idx_language ON public.joomla_newsfeeds USING btree (language);


--
-- Name: joomla_newsfeeds_idx_state; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_newsfeeds_idx_state ON public.joomla_newsfeeds USING btree (published);


--
-- Name: joomla_privacy_consents_idx_user_id; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_privacy_consents_idx_user_id ON public.joomla_privacy_consents USING btree (user_id);


--
-- Name: joomla_redirect_links_idx_link_modifed; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_redirect_links_idx_link_modifed ON public.joomla_redirect_links USING btree (modified_date);


--
-- Name: joomla_redirect_links_idx_old_url; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_redirect_links_idx_old_url ON public.joomla_redirect_links USING btree (old_url);


--
-- Name: joomla_session_idx_client_id_guest; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_session_idx_client_id_guest ON public.joomla_session USING btree (client_id, guest);


--
-- Name: joomla_session_time; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_session_time ON public.joomla_session USING btree ("time");


--
-- Name: joomla_session_userid; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_session_userid ON public.joomla_session USING btree (userid);


--
-- Name: joomla_tags_cat_idx; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_tags_cat_idx ON public.joomla_tags USING btree (published, access);


--
-- Name: joomla_tags_idx_access; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_tags_idx_access ON public.joomla_tags USING btree (access);


--
-- Name: joomla_tags_idx_alias; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_tags_idx_alias ON public.joomla_tags USING btree (alias);


--
-- Name: joomla_tags_idx_checkout; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_tags_idx_checkout ON public.joomla_tags USING btree (checked_out);


--
-- Name: joomla_tags_idx_language; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_tags_idx_language ON public.joomla_tags USING btree (language);


--
-- Name: joomla_tags_idx_left_right; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_tags_idx_left_right ON public.joomla_tags USING btree (lft, rgt);


--
-- Name: joomla_tags_idx_path; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_tags_idx_path ON public.joomla_tags USING btree (path);


--
-- Name: joomla_template_overrides_idx_extension_id; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_template_overrides_idx_extension_id ON public.joomla_template_overrides USING btree (extension_id);


--
-- Name: joomla_template_overrides_idx_template; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_template_overrides_idx_template ON public.joomla_template_overrides USING btree (template);


--
-- Name: joomla_template_styles_idx_client_id; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_template_styles_idx_client_id ON public.joomla_template_styles USING btree (client_id);


--
-- Name: joomla_template_styles_idx_client_id_home; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_template_styles_idx_client_id_home ON public.joomla_template_styles USING btree (client_id, home);


--
-- Name: joomla_template_styles_idx_template; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_template_styles_idx_template ON public.joomla_template_styles USING btree (template);


--
-- Name: joomla_ucm_base_ucm_item_id; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_ucm_base_ucm_item_id ON public.joomla_ucm_base USING btree (ucm_item_id);


--
-- Name: joomla_ucm_base_ucm_language_id; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_ucm_base_ucm_language_id ON public.joomla_ucm_base USING btree (ucm_language_id);


--
-- Name: joomla_ucm_base_ucm_type_id; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_ucm_base_ucm_type_id ON public.joomla_ucm_base USING btree (ucm_type_id);


--
-- Name: joomla_ucm_content_idx_access; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_ucm_content_idx_access ON public.joomla_ucm_content USING btree (core_access);


--
-- Name: joomla_ucm_content_idx_alias; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_ucm_content_idx_alias ON public.joomla_ucm_content USING btree (core_alias);


--
-- Name: joomla_ucm_content_idx_content_type; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_ucm_content_idx_content_type ON public.joomla_ucm_content USING btree (core_type_alias);


--
-- Name: joomla_ucm_content_idx_core_checked_out_user_id; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_ucm_content_idx_core_checked_out_user_id ON public.joomla_ucm_content USING btree (core_checked_out_user_id);


--
-- Name: joomla_ucm_content_idx_core_created_user_id; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_ucm_content_idx_core_created_user_id ON public.joomla_ucm_content USING btree (core_created_user_id);


--
-- Name: joomla_ucm_content_idx_core_modified_user_id; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_ucm_content_idx_core_modified_user_id ON public.joomla_ucm_content USING btree (core_modified_user_id);


--
-- Name: joomla_ucm_content_idx_core_type_id; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_ucm_content_idx_core_type_id ON public.joomla_ucm_content USING btree (core_type_id);


--
-- Name: joomla_ucm_content_idx_created_time; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_ucm_content_idx_created_time ON public.joomla_ucm_content USING btree (core_created_time);


--
-- Name: joomla_ucm_content_idx_language; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_ucm_content_idx_language ON public.joomla_ucm_content USING btree (core_language);


--
-- Name: joomla_ucm_content_idx_modified_time; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_ucm_content_idx_modified_time ON public.joomla_ucm_content USING btree (core_modified_time);


--
-- Name: joomla_ucm_content_idx_title; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_ucm_content_idx_title ON public.joomla_ucm_content USING btree (core_title);


--
-- Name: joomla_ucm_content_tag_idx; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_ucm_content_tag_idx ON public.joomla_ucm_content USING btree (core_state, core_access);


--
-- Name: joomla_user_keys_idx_user_id; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_user_keys_idx_user_id ON public.joomla_user_keys USING btree (user_id);


--
-- Name: joomla_user_notes_idx_category_id; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_user_notes_idx_category_id ON public.joomla_user_notes USING btree (catid);


--
-- Name: joomla_user_notes_idx_user_id; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_user_notes_idx_user_id ON public.joomla_user_notes USING btree (user_id);


--
-- Name: joomla_usergroups_idx_usergroup_adjacency_lookup; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_usergroups_idx_usergroup_adjacency_lookup ON public.joomla_usergroups USING btree (parent_id);


--
-- Name: joomla_usergroups_idx_usergroup_nested_set_lookup; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_usergroups_idx_usergroup_nested_set_lookup ON public.joomla_usergroups USING btree (lft, rgt);


--
-- Name: joomla_usergroups_idx_usergroup_title_lookup; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_usergroups_idx_usergroup_title_lookup ON public.joomla_usergroups USING btree (title);


--
-- Name: joomla_users_email; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_users_email ON public.joomla_users USING btree (email);


--
-- Name: joomla_users_email_lower; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_users_email_lower ON public.joomla_users USING btree (lower((email)::text));


--
-- Name: joomla_users_idx_block; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_users_idx_block ON public.joomla_users USING btree (block);


--
-- Name: joomla_users_idx_name; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_users_idx_name ON public.joomla_users USING btree (name);


--
-- Name: joomla_webauthn_credentials_user_id; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_webauthn_credentials_user_id ON public.joomla_webauthn_credentials USING btree (user_id);


--
-- Name: joomla_workflow_associations_idx_extension; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_workflow_associations_idx_extension ON public.joomla_workflow_associations USING btree (extension);


--
-- Name: joomla_workflow_associations_idx_item_id; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_workflow_associations_idx_item_id ON public.joomla_workflow_associations USING btree (item_id);


--
-- Name: joomla_workflow_associations_idx_item_stage_extension; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_workflow_associations_idx_item_stage_extension ON public.joomla_workflow_associations USING btree (item_id, stage_id, extension);


--
-- Name: joomla_workflow_associations_idx_stage_id; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_workflow_associations_idx_stage_id ON public.joomla_workflow_associations USING btree (stage_id);


--
-- Name: joomla_workflow_stages_idx_asset_id; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_workflow_stages_idx_asset_id ON public.joomla_workflow_stages USING btree (asset_id);


--
-- Name: joomla_workflow_stages_idx_checked_out; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_workflow_stages_idx_checked_out ON public.joomla_workflow_stages USING btree (checked_out);


--
-- Name: joomla_workflow_stages_idx_default; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_workflow_stages_idx_default ON public.joomla_workflow_stages USING btree ("default");


--
-- Name: joomla_workflow_stages_idx_title; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_workflow_stages_idx_title ON public.joomla_workflow_stages USING btree (title);


--
-- Name: joomla_workflow_stages_idx_workflow_id; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_workflow_stages_idx_workflow_id ON public.joomla_workflow_stages USING btree (workflow_id);


--
-- Name: joomla_workflow_transitions_idx_asset_id; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_workflow_transitions_idx_asset_id ON public.joomla_workflow_transitions USING btree (asset_id);


--
-- Name: joomla_workflow_transitions_idx_checked_out; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_workflow_transitions_idx_checked_out ON public.joomla_workflow_transitions USING btree (checked_out);


--
-- Name: joomla_workflow_transitions_idx_from_stage_id; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_workflow_transitions_idx_from_stage_id ON public.joomla_workflow_transitions USING btree (from_stage_id);


--
-- Name: joomla_workflow_transitions_idx_title; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_workflow_transitions_idx_title ON public.joomla_workflow_transitions USING btree (title);


--
-- Name: joomla_workflow_transitions_idx_to_stage_id; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_workflow_transitions_idx_to_stage_id ON public.joomla_workflow_transitions USING btree (to_stage_id);


--
-- Name: joomla_workflow_transitions_idx_workflow_id; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_workflow_transitions_idx_workflow_id ON public.joomla_workflow_transitions USING btree (workflow_id);


--
-- Name: joomla_workflows_idx_asset_id; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_workflows_idx_asset_id ON public.joomla_workflows USING btree (asset_id);


--
-- Name: joomla_workflows_idx_checked_out; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_workflows_idx_checked_out ON public.joomla_workflows USING btree (checked_out);


--
-- Name: joomla_workflows_idx_created; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_workflows_idx_created ON public.joomla_workflows USING btree (created);


--
-- Name: joomla_workflows_idx_created_by; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_workflows_idx_created_by ON public.joomla_workflows USING btree (created_by);


--
-- Name: joomla_workflows_idx_default; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_workflows_idx_default ON public.joomla_workflows USING btree ("default");


--
-- Name: joomla_workflows_idx_extension; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_workflows_idx_extension ON public.joomla_workflows USING btree (extension);


--
-- Name: joomla_workflows_idx_modified; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_workflows_idx_modified ON public.joomla_workflows USING btree (modified);


--
-- Name: joomla_workflows_idx_modified_by; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_workflows_idx_modified_by ON public.joomla_workflows USING btree (modified_by);


--
-- Name: joomla_workflows_idx_title; Type: INDEX; Schema: public; Owner: joomla_user
--

CREATE INDEX joomla_workflows_idx_title ON public.joomla_workflows USING btree (title);


--
-- PostgreSQL database dump complete
--

