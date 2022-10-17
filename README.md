# pghdrkit: PostgREST Header Kit
A set of functions for adding special features to your application that uses PostgREST API calls to your PostgreSQL database, including:

- ⬜️ rate limiting
- ✅ IP allowlisting 
- ✅ IP denylisting
- ⬜️ request logging
- ⬜️ request filtering
- ⬜️ request routing
- ⬜️ user allowlisting by uid or email (Supabase-specific)
- ⬜️ user denylisting by uid or email (Supabase-specific)

### Article
See: [PostgREST Header Hacking](https://github.com/burggraf/postgrest-header-hacking)

### Function Reference

| function         | description                            | parameters     | returns      |
| ---------------- | -------------------------------------- | -------------- | ------------ |
| hdr.headers()    | get all header values as a json object | none           | json object  |
| hdr.header(item text) | get a header value | item (text) | text |
| hdr.ip() | get the ip address of the current user | none | text |
| hdr.allow_list() | get the allow list of ip addresses | none | inet[] (array of ip addresses) |
| hdr.deny_list() | get the deny list of ip addresses | none | inet[] (array of ip addresses) |
| hdr.in_deny_list(ip inet) | determine if the given ip is in the deny list | ip (inet) | boolean |
| hdr.in_allow_list(ip inet) | determine if the given ip is in the allow list | ip (inet) | boolean |
| hdr.in_deny_list() | determine if the current user's ip is in the deny list | none | boolean |
| hdr.in_allow_list() | determine if the current user's ip is in the allow list | none | boolean |
| hdr.host() | get host, i.e. "localhost:3000" | none | text |
| hdr.origin() | get origin, i.e. "http://localhost:8100" | none | text |
| hdr.referer() | get referer, i.e. "http://localhost:8100/" | none | text |
| hdr.agent() | get user-agent string | none | text |
| hdr.client() | get x-client-info, i.e. "supabase-js/1.35.7" | none | text |
| hdr.role()<br>hdr.consumer() | get role (consumer), i.e. "anon-key" | none | text |
| hdr.api_host()<br>hdr.domain() | get api server, i.e. "xxxxxxxxxxxxxxxx.supabase.co" | none | text |
| hdr.projectref()<br>hdr.ref() | get project ref #, i.e. "xxxxxxxxxxxxxxxx" | none | text |
| hdr.is_mobile() | is mobile? | none | boolean |
| hdr.is_iphone() | is iphone? | none | boolean |
| hdr.is_ipad() | is ipad? | none | boolean |
| hdr.is_android() | is android? | none | boolean |


