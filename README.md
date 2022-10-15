# pghdrkit: PostgREST Header Kit
A set of functions for adding special features to your application that uses PostgREST API calls to your PostgreSQL database, including:

- ⬜️ rate limiting
- ✅ IP whitelisting 
- ✅ IP blacklisting
- ⬜️ request logging
- ⬜️ request filtering
- ⬜️ request routing
- ⬜️ user whitelisting by uid or email (Supabase-specific)
- ⬜️ user blacklisting by uid or email (Supabase-specific)

## Function Reference

### basic header functions

#### hdr.headers()
get all header values as a json object

##### parameters
none

##### returns
json object


#### hdr.header(item text)
get a header value

##### parameters
name: item 
type: text
description: name of header to retrieve

##### returns
text

### ip functions and ip lists

#### hdr.ip()
get the ip address of the current user

##### parameters
none

##### returns
text

#### hdr.white_list()
get the white list of ip addresses

##### parameters
none

##### returns
array of ip addresses - inet[]

#### hdr.black_list()
get the black list of ip addresses

##### parameters
none

##### returns
array of ip addresses - inet[]

#### hdr.in_black_list(ip inet)
determine if the given ip is in the black list

##### parameters
ip - inet (internet address)

##### returns
boolean

#### hdr.in_black_list()
determine if the current user's ip is in the black list

##### parameters
none

##### returns
boolean

#### hdr.in_white_list(ip inet)
determine if the given ip is in the white list

##### parameters
ip - inet (internet address)

##### returns
boolean

#### hdr.in_white_list()
determine if the current user's ip is in the white list

##### parameters
none

##### returns
boolean


### header objects (shortcuts)

#### hdr.host()
get host, i.e. "localhost:3000"

##### parameters
none

##### returns
text

#### hdr.origin()
get origin, i.e. "http://localhost:8100"

##### parameters
none

##### returns
text

#### hdr.referer()
get referer, i.e. "http://localhost:8100/"

##### parameters
none

##### returns
text

#### hdr.agent()
get user-agent string

##### parameters
none

##### returns
text

#### hdr.client()
get x-client-info, i.e. "supabase-js/1.35.7"

##### parameters
none

##### returns
text

#### hdr.role() / hdr.consumer()
get role (consumer), i.e. "anon-key"

##### parameters
none

##### returns
text

#### hdr.api_host() / hdr.domain()
get api server, i.e. "xxxxxxxxxxxxxxxx.supabase.co"

##### parameters
none

##### returns
text

#### hdr.projectref() / hdr.ref()
get project ref #, i.e. "xxxxxxxxxxxxxxxx"

##### parameters
none

##### returns
text

