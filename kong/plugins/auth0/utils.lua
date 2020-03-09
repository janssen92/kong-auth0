local cjson = require("cjson")

local M = {}

function M.get_options(config, ngx)
  return {
    client_id = config.client_id,
    timeout = config.timeout,
    discovery = config.domain and config.domain .. "/.well-known/openid-configuration",
    redirect_after_logout_uri = config.domain and config.domain .. "/v2/logout",
    authorization_params = config.audience and {audience=config.audience},
    scope = config.scope and config.scope or "openid profile email",
    redirect_uri = config.redirect_uri and config.redirect_uri or "/cb",
    logout_path = config.logout_path and  config.logout_path or "/logout",
    token_signing_alg_values_expected = "RS256",
    response_type = "code",
    ssl_verify = "no",
    token_endpoint_auth_method = "client_secret_post"
  }
end

function M.exit(httpStatusCode, message, ngxCode)
  ngx.status = httpStatusCode
  ngx.say(message)
  ngx.exit(ngxCode)
end

function M.clearHeaders()
  ngx.req.clear_header("cookie")
  ngx.req.clear_header("authorization")
end

function M.injectAccessToken(accessToken)
  if accessToken then
    ngx.req.set_header("X-Access-Token", accessToken)
  end
end

function M.injectUser(user)
  if user then
    local tmp_user = user
    tmp_user.id = user.sub
    tmp_user.username = user.preferred_username
    ngx.ctx.authenticated_credential = tmp_user
    local userinfo = cjson.encode(user)
    ngx.req.set_header("X-Userinfo", ngx.encode_base64(userinfo))
  end
end

function M.has_bearer_access_token()
  local header = ngx.req.get_headers()['Authorization']
  if header and header:find(" ") then
    local divider = header:find(' ')
    if string.lower(header:sub(0, divider-1)) == string.lower("Bearer") then
      return true
    end
  end
  return false
end

return M
