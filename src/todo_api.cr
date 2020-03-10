# Server API providing CRUD operations on the TODO data model.
module TodoAPI
  VERSION = "0.1.0"
end

# Assert the required ENV vars.
required_env = %w[
  PORT DB_CONNECTION_STRING SESSIONS_SECRET SECURE_SESSIONS
  TOKEN_EXCHANGE_URL CLIENT_ID CLIENT_SECRET REDIRECT_URI
]
unless required_env.all? { |var| ENV[var]? }
  raise "ENV must include: #{required_env}"
end

# Require shards/libs.
require "http"
require "db"
require "pg"
require "kemal"
require "kemal-session"
require "jwt"
require "debug"

# Require local files.
require "./todo_api/models/model"
require "./todo_api/models/**"
require "./todo_api/controllers/**"

# Init client session config.
Kemal::Session.config do |config|
  config.cookie_name = "session_id"
  config.secret = ENV["SESSIONS_SECRET"]
  config.gc_interval = 2.minutes
  config.timeout = Time::Span.new(1, 0, 0) # 1 hour after last user interaction.
  config.secure = (ENV["SECURE_SESSIONS"].downcase == "true")
end

# Start the HTTP Server.
Kemal.run do |config|
  server = config.server.not_nil!
  server.bind_tcp("0.0.0.0", ENV["PORT"].to_i)
end
