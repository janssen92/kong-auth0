local utils = require("kong.plugins.auth0.utils")
local lu = require("luaunit")

TestUtils = require("tests.mockable_case"):extend()

function TestUtils:setUp()
  TestUtils.super:setUp()
end

function TestUtils:tearDown()
  TestUtils.super:tearDown()
end

function TestUtils:testOptions()
  local opts = utils.get_options({
    client_id = 1,
    domain = "d",
    timeout = 2,
    redirect_uri = "/r",
    scope = "openid",
    logout_path = "/log",
    audience = "aud"
  }, {var = {request_uri = "/path"},
    req = {get_uri_args = function() return nil end}})

  lu.assertEquals(opts.client_id, 1)
  lu.assertEquals(opts.discovery, "d/.well-known/openid-configuration")
  lu.assertEquals(opts.scope, "openid")
  lu.assertEquals(opts.response_type, "code")
  lu.assertEquals(opts.ssl_verify, "no")
  lu.assertEquals(opts.token_endpoint_auth_method, "client_secret_post")
  lu.assertEquals(opts.redirect_uri, "/r")
  lu.assertEquals(opts.logout_path, "/log")
  lu.assertEquals(opts.redirect_after_logout_uri, "d/v2/logout")
end


lu.run()
