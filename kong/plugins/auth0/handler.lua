local BasePlugin = require "kong.plugins.base_plugin"
local Auth0Handler = BasePlugin:extend()
local utils = require("kong.plugins.auth0.utils")

Auth0Handler.PRIORITY = 1000


function Auth0Handler:new()
  Auth0Handler.super.new(self, "auth0")
end

function Auth0Handler:access(config)
  Auth0Handler.super.access(self)
  local auth0Config = utils.get_options(config, ngx)
  handle(auth0Config)
  ngx.log(ngx.DEBUG, "Auth0Handler done")
end

function handle(auth0Config)
  local response
  if auth0Config.introspection_endpoint then
    response = introspect(auth0Config)
    if response then
      utils.injectUser(response)
    end
  end

  if response == nil then
    response = make_auth0(auth0Config)
    if response then
      if (response.user) then
        utils.injectUser(response.user)
      end
      if (response.access_token) then
        utils.injectAccessToken(response.access_token)
      end
    end
  end
end

function make_auth0(auth0Config)
  ngx.log(ngx.DEBUG, "Auth0Handler calling authenticate, requested path: " .. ngx.var.request_uri)
  local res, err = require("resty.openidc").authenticate(auth0Config)
  if err then
    if auth0Config.recovery_page_path then
      ngx.log(ngx.DEBUG, "Entering recovery page: " .. auth0Config.recovery_page_path)
      ngx.redirect(auth0Config.recovery_page_path)
    end
    utils.exit(500, err, ngx.HTTP_INTERNAL_SERVER_ERROR)
  end
  return res
end

function introspect(auth0Config)
  if utils.has_bearer_access_token() or auth0Config.bearer_only == "yes" then
    local res, err = require("resty.openidc").introspect(auth0Config)
    if err then
      if auth0Config.bearer_only == "yes" then
        ngx.header["WWW-Authenticate"] = 'Bearer realm="' .. auth0Config.realm .. '",error="' .. err .. '"'
        utils.exit(ngx.HTTP_UNAUTHORIZED, err, ngx.HTTP_UNAUTHORIZED)
      end
      return nil
    end
    ngx.log(ngx.DEBUG, "Auth0Handler introspect succeeded, requested path: " .. ngx.var.request_uri)
    return res
  end
  return nil
end


return Auth0Handler
