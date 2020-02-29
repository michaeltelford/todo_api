# Allow any CORS request.
before_all do |env|
  env.response.headers.add("Access-Control-Allow-Origin", "*")
end

# CORS pre-flight requests.
options "/*" do |env|
  env.response.headers.add("Access-Control-Allow-Method", "*")
  env.response.headers.add("Access-Control-Allow-Headers", "*")
end

# Healthcheck.
get "/healthcheck" {}

# Creates the DB model if it doesn't already exists.
post "/migrate" { List.migrate }
