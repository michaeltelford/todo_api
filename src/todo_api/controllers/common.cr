# Allow any CORS request and default the content type.
before_all do |env|
  env.response.headers.add("Access-Control-Allow-Origin", "*")
  env.response.content_type = "application/json"
end

# CORS pre-flight requests.
options "/*" do |env|
  env.response.headers.add("Access-Control-Allow-Methods", "POST,PUT,PATCH")
  env.response.headers.add(
    "Access-Control-Allow-Headers",
    "Content-Type,If-Modified-Since,Cache-Control"
  )
  env.response.headers.add("Access-Control-Max-Age", "86400") # 24 hours.
end

# Healthcheck.
get "/healthcheck" {}

# Creates the DB model if it doesn't already exists.
post "/migrate" { List.migrate }
