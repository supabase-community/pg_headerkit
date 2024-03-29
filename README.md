# pg_headerkit: PostgREST Header Kit
A set of functions for adding special features to your application that use PostgREST API calls to your PostgreSQL database.  These functions can be used inside PostgreSQL functions that can give your application the following capabilities at the database level:

- ⬜️ rate limiting
- ⬜️ IP allowlisting 
- ⬜️ IP denylisting
- ⬜️ request logging
- ⬜️ request filtering
- ⬜️ request routing
- ⬜️ user allowlisting by uid or email (Supabase-specific)
- ⬜️ user denylisting by uid or email (Supabase-specific)

### Article
See: [PostgREST Header Hacking](https://github.com/burggraf/postgrest-header-hacking)

### Function Reference

| function                       | description                                             | parameters  | returns                        |
| ------------------------------ | ------------------------------------------------------- | ----------- | ------------------------------ |
| hdr.headers()                  | get all header values as a json object                  | none        | json object                    |
| hdr.header(item text)          | get a header value                                      | item (text) | text                           |
| hdr.ip()                       | get the ip address of the current user                  | none        | text                           |
| hdr.allow_list()               | get the allow list of ip addresses                      | none        | inet[] (array of ip addresses) |
| hdr.deny_list()                | get the deny list of ip addresses                       | none        | inet[] (array of ip addresses) |
| hdr.in_deny_list(ip inet)      | determine if the given ip is in the deny list           | ip (inet)   | boolean                        |
| hdr.in_allow_list(ip inet)     | determine if the given ip is in the allow list          | ip (inet)   | boolean                        |
| hdr.in_deny_list()             | determine if the current user's ip is in the deny list  | none        | boolean                        |
| hdr.in_allow_list()            | determine if the current user's ip is in the allow list | none        | boolean                        |
| hdr.host()                     | get host, i.e. "localhost:3000"                         | none        | text                           |
| hdr.origin()                   | get origin, i.e. "http://localhost:8100"                | none        | text                           |
| hdr.referer()                  | get referer, i.e. "http://localhost:8100/"              | none        | text                           |
| hdr.agent()                    | get user-agent string                                   | none        | text                           |
| hdr.client()                   | get x-client-info, i.e. "supabase-js/1.35.7"            | none        | text                           |
| hdr.role()<br>hdr.consumer()   | get role (consumer), i.e. "anon-key"                    | none        | text                           |
| hdr.api_host()<br>hdr.domain() | get api server, i.e. "xxxxxxxxxxxxxxxx.supabase.co"     | none        | text                           |
| hdr.projectref()<br>hdr.ref()  | get project ref #, i.e. "xxxxxxxxxxxxxxxx"              | none        | text                           |
| hdr.is_mobile()                | is mobile?                                              | none        | boolean                        |
| hdr.is_iphone()                | is iphone?                                              | none        | boolean                        |
| hdr.is_ipad()                  | is ipad?                                                | none        | boolean                        |
| hdr.is_android()               | is android?                                             | none        | boolean                        |


## Install on Supabase + AWS

Make sure you have the full Postgres connection string.

1. Get the installer
   1. `curl -OL https://raw.githubusercontent.com/aws/pg_tle/main/tools/pg_tle_manage_local_extension/pg_tle_manage_local_extension.sh`
2. Make it executable
   1. `chmod 744 pg_tle_manage_local_extension.sh`
3. Run the install command
   1. `./pg_tle_manage_local_extension.sh -a install -c "postgresql://postgres:pass@host:5432/postgres" -n pg_headerkit -p ./`
4. Check that the extension is installed properly
   1. `./pg_tle_manage_local_extension.sh -a list -c "postgresql://postgres:pass@host:5432/postgres" -n pg_headerkit -p ./`