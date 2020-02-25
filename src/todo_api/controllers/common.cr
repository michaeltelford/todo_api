# Healthcheck.
get "/healthcheck" {}

# Creates the DB model if it doesn't already exists.
post "/migrate" do |env|
  List.migrate
end
