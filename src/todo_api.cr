# Server API providing CRUD operations on the TODO data model.
module TodoAPI
  VERSION = "0.1.0"

  REQUIRED_ENV_VARS = %w[
    PORT DATABASE_URL SESSIONS_SECRET SECURE_SESSIONS
    TOKEN_EXCHANGE_URL CLIENT_ID CLIENT_SECRET CLIENT_AUTH_URI
  ]

  # Assert the required ENV vars are present.
  def self.assert_env_vars
    unless REQUIRED_ENV_VARS.all? { |var| ENV[var]? }
      raise "ENV must include: #{REQUIRED_ENV_VARS}"
    end
  end

  # Set the client origin URI (for CORS headers) in ENV.
  def self.set_env_client_uri
    auth_uri = URI.parse(ENV["CLIENT_AUTH_URI"])
    raise "Invalid CLIENT_AUTH_URI" unless auth_uri.absolute?

    client_uri = "#{auth_uri.scheme}://#{auth_uri.host}"
    client_uri += ":#{auth_uri.port}" if auth_uri.port

    ENV["CLIENT_URI"] = client_uri
  end
end

# Require standard libs / shards.
require "uri"
require "json"
require "http"
require "db"
require "pg"
require "jwt"
require "kemal"
require "kemal-session"
# require "debug"

# Pre-requisites for loading code...
TodoAPI.assert_env_vars
TodoAPI.set_env_client_uri

# Require local code files.
require "./todo_api/models/model"
require "./todo_api/models/**"
require "./todo_api/controllers/auth"
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
