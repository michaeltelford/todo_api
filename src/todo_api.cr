# Server API providing CRUD operations on the TODO data model.
module TodoAPI
  VERSION = "0.1.0"
end

# Assert the required ENV vars.
required_env = %w[PORT DB_CONNECTION_STRING]
unless required_env.all? { |var| ENV[var]? }
  raise "ENV must include: #{required_env}"
end

# Require shards.
require "db"
require "pg"
require "kemal"
require "debug"

# Require local files.
require "./todo_api/models/model"
require "./todo_api/models/**"
require "./todo_api/controllers/**"

# Start the HTTP Server.
Kemal.run do |config|
  server = config.server.not_nil!
  server.bind_tcp("0.0.0.0", ENV["PORT"].to_i)
end
