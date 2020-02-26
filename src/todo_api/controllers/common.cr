# Healthcheck.
get "/healthcheck" {}

# Creates the DB model if it doesn't already exists.
post "/migrate" { List.migrate }
