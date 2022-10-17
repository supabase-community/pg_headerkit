CREATE SCHEMA IF NOT EXISTS hdr;

CREATE TABLE IF NOT EXISTS hdr.allow_list (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  ip inet NOT NULL,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS hdr.deny_list (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  ip inet NOT NULL,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now()
);

-- get all header values as a json object
CREATE OR REPLACE FUNCTION hdr.headers() RETURNS json
    LANGUAGE sql STABLE
    AS $$
    SELECT COALESCE(current_setting('request.headers', true)::json, '{}'::json);
$$;

-- get a header value
CREATE OR REPLACE FUNCTION hdr.header(item text) RETURNS text
    LANGUAGE sql STABLE
    AS $$
    SELECT COALESCE((current_setting('request.headers', true)::json)->>item, '')
$$;

-- get the ip address of the current user
CREATE OR REPLACE FUNCTION hdr.ip() RETURNS text
    LANGUAGE sql STABLE
    AS $$
    SELECT SPLIT_PART(hdr.header('x-forwarded-for') || ',', ',', 1)
$$;

-- get the allow list
CREATE OR REPLACE FUNCTION hdr.allow_list() RETURNS inet[]
    LANGUAGE sql IMMUTABLE
    AS $$
    SELECT array_agg(ip) FROM (SELECT ip FROM hdr.allow_list) AS ip;
$$;

-- get the deny list
CREATE OR REPLACE FUNCTION hdr.deny_list() RETURNS inet[]
    LANGUAGE sql IMMUTABLE
    AS $$
    SELECT array_agg(ip) FROM (SELECT ip FROM hdr.deny_list) AS ip;
$$;

-- Is the given ip in the deny list?
CREATE OR REPLACE FUNCTION hdr.in_deny_list(ip inet) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $$
    SELECT 
      ip = ANY (hdr.deny_list())
$$;

-- Is the current user's ip in the deny list?
CREATE OR REPLACE FUNCTION hdr.in_deny_list() RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $$
    SELECT CASE 
      WHEN hdr.ip() = '' THEN false
      ELSE 
      (hdr.ip())::inet = ANY (hdr.deny_list())
    END
$$;

-- Is the given ip in the allow list?
CREATE OR REPLACE FUNCTION hdr.in_allow_list(ip inet) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $$
    SELECT 
      ip = ANY (hdr.allow_list())
$$;

-- Is the current user's ip in the allow list?
CREATE OR REPLACE FUNCTION hdr.in_allow_list() RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $$
    SELECT CASE 
      WHEN hdr.ip() = '' THEN false
      ELSE 
      (hdr.ip())::inet = ANY (hdr.allow_list())
    END
$$;

-- get host, i.e. "localhost:3000"
CREATE OR REPLACE FUNCTION hdr.host() RETURNS text
    LANGUAGE sql IMMUTABLE
    AS $$
    SELECT hdr.header('host')
$$;

-- get origin, i.e. "http://localhost:8100"
CREATE OR REPLACE FUNCTION hdr.origin() RETURNS text
    LANGUAGE sql IMMUTABLE
    AS $$
    SELECT hdr.header('origin')
$$;

-- get referer, i.e. "http://localhost:8100/"
CREATE OR REPLACE FUNCTION hdr.referer() RETURNS text
    LANGUAGE sql IMMUTABLE
    AS $$
    SELECT hdr.header('referer')
$$;

-- get user-agent string
CREATE OR REPLACE FUNCTION hdr.agent() RETURNS text
    LANGUAGE sql IMMUTABLE
    AS $$
    SELECT hdr.header('user-agent')
$$;

-- get x-client-info, i.e. "supabase-js/1.35.7"
CREATE OR REPLACE FUNCTION hdr.client() RETURNS text
    LANGUAGE sql IMMUTABLE
    AS $$
    SELECT hdr.header('x-client-info')
$$;

-- get role (consumer), i.e. "anon-key"
CREATE OR REPLACE FUNCTION hdr.role() RETURNS text
    LANGUAGE sql IMMUTABLE
    AS $$
    SELECT hdr.header('x-consumer-username')
$$;

-- get consumer, i.e. "anon-key"
CREATE OR REPLACE FUNCTION hdr.consumer() RETURNS text
    LANGUAGE sql IMMUTABLE
    AS $$
    SELECT hdr.header('x-consumer-username')
$$;

-- get api server, i.e. "xxxxxxxxxxxxxxxx.supabase.co"
CREATE OR REPLACE FUNCTION hdr.api_host() RETURNS text
    LANGUAGE sql IMMUTABLE
    AS $$
    SELECT hdr.header('x-forwarded-host')
$$;

-- get api server domain, i.e. "xxxxxxxxxxxxxxxx.supabase.co"
CREATE OR REPLACE FUNCTION hdr.domain() RETURNS text
    LANGUAGE sql IMMUTABLE
    AS $$
    SELECT hdr.header('x-forwarded-host')
$$;

-- get project ref #, i.e. "xxxxxxxxxxxxxxxx"
CREATE OR REPLACE FUNCTION hdr.projectref() RETURNS text
    LANGUAGE sql IMMUTABLE
    AS $$
    SELECT hdr.header('x-forwarded-host')
    SELECT SPLIT_PART(hdr.header('x-forwarded-host') || '.', '.', 1)
$$;

-- get project ref #, i.e. "xxxxxxxxxxxxxxxx"
CREATE OR REPLACE FUNCTION hdr.ref() RETURNS text
    LANGUAGE sql IMMUTABLE
    AS $$
    SELECT hdr.header('x-forwarded-host')
    SELECT SPLIT_PART(hdr.header('x-forwarded-host') || '.', '.', 1)
$$;

-- **********************************************
-- ********* user-agent parse functions *********
-- **********************************************

-- user-agent parsing for mobile
CREATE OR REPLACE FUNCTION hdr.is_mobile() RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $$
    SELECT hdr.header('user-agent') ILIKE '%mobile%'
$$;

-- user-agent parsing for iPhone
CREATE OR REPLACE FUNCTION hdr.is_iphone() RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $$
    SELECT hdr.header('user-agent') ILIKE '%iphone%'
$$;

-- user-agent parsing for iPad
CREATE OR REPLACE FUNCTION hdr.is_ipad() RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $$
    SELECT hdr.header('user-agent') ILIKE '%ipad%'
$$;

-- user-agent parsing for Android
CREATE OR REPLACE FUNCTION hdr.is_android() RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $$
    SELECT hdr.header('user-agent') ILIKE '%android%'
$$;

