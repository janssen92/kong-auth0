package = "kong-auth0"
version = "1.1.0-0"
source = {
    url = "git://github.com/janssen92/kong-auth0",
    tag = "v1.0.0",
    dir = "kong-auth0"
}
description = {
    summary = "A Kong plugin for connecting to Auth0 via auth0",
    detailed = [[
        kong-auth0 is a Kong plugin for implementing the OpenID Connect Relying Party.

        When used as an OpenID Connect Relying Party it authenticates users against an OpenID Connect Provider using OpenID Connect Discovery and the Basic Client Profile (i.e. the Authorization Code flow).

        It maintains sessions for authenticated users by leveraging lua-resty-session thus offering a configurable choice between storing the session state in a client-side browser cookie or use in of the server-side storage mechanisms shared-memory|memcache|redis.

        It supports server-wide caching of resolved Discovery documents and validated Access Tokens.

        It can be used as a reverse proxy terminating OAuth/OpenID Connect in front of an origin server so that the origin server/services can be protected with the relevant standards without implementing those on the server itself.
    ]],
    homepage = "https://github.com/janssen92/kong-auth0",
    license = "Apache 2.0"
}
dependencies = {
    "lua-resty-openidc ~> 1.7.2"
}
build = {
    type = "builtin",
    modules = {
    ["kong.plugins.auth0.handler"] = "kong/plugins/auth0/handler.lua",
    ["kong.plugins.auth0.schema"] = "kong/plugins/auth0/schema.lua",
    ["kong.plugins.auth0.utils"] = "kong/plugins/auth0/utils.lua"
    }
}
