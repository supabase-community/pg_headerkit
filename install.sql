CREATE SCHEMA IF NOT EXISTS hdr;

CREATE TABLE IF NOT EXISTS hdr.white_list (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  ip inet NOT NULL,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS hdr.black_list (
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

-- get the white list
CREATE OR REPLACE FUNCTION hdr.white_list() RETURNS inet[]
    LANGUAGE sql IMMUTABLE
    AS $$
    SELECT array_agg(ip) FROM (SELECT ip FROM hdr.white_list) AS ip;
$$;

-- get the black list
CREATE OR REPLACE FUNCTION hdr.black_list() RETURNS inet[]
    LANGUAGE sql IMMUTABLE
    AS $$
    SELECT array_agg(ip) FROM (SELECT ip FROM hdr.black_list) AS ip;
$$;

-- Is the given ip in the black list?
CREATE OR REPLACE FUNCTION hdr.in_black_list(ip inet) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $$
    SELECT 
      ip = ANY (hdr.black_list())
$$;

-- Is the current user's ip in the white list?
CREATE OR REPLACE FUNCTION hdr.in_black_list() RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $$
    SELECT CASE 
      WHEN hdr.ip() = '' THEN false
      ELSE 
      (hdr.ip())::inet = ANY (hdr.black_list())
    END
$$;

-- Is the given ip in the white list?
CREATE OR REPLACE FUNCTION hdr.in_white_list(ip inet) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $$
    SELECT 
      ip = ANY (hdr.white_list())
$$;

-- Is the current user's ip in the white list?
CREATE OR REPLACE FUNCTION hdr.in_white_list() RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $$
    SELECT CASE 
      WHEN hdr.ip() = '' THEN false
      ELSE 
      (hdr.ip())::inet = ANY (hdr.white_list())
    END
$$;
