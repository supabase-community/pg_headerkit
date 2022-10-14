CREATE SCHEMA IF NOT EXISTS hdr;

CREATE OR REPLACE FUNCTION hdr.get_headers() RETURNS json
    LANGUAGE sql STABLE
    AS $$
    SELECT COALESCE(current_setting('request.headers', true)::json, '{}'::json);
$$;

CREATE OR REPLACE FUNCTION hdr.get_header(item text) RETURNS text
    LANGUAGE sql STABLE
    AS $$
    SELECT COALESCE((current_setting('request.headers', true)::json)->>item, '')
$$;
