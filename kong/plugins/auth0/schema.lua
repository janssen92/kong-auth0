return {
  no_consumer = true,
  fields = {
    client_id = { type = "string", required = true },
    domain = { type = "string", required = true, default = "https://ACCID.REGION.auth0.com" },
    timeout = { type = "number", required = false },
    redirect_uri = { type = "string", required = false, default = "/cb" },
    scope = { type = "string", required = false, default = "openid profile email" },
    logout_path = { type = "string", required = false, default = '/logout' },
    audience = { type = "string", required = false }
  }
}
