# Require standard libs / shards.
require "uri"
require "json"
require "http"
require "db"
require "pg"
require "jwt"
require "kemal"
require "base64"
# require "debug"

# Server API providing CRUD operations on the TODO data model.
module TodoAPI
  VERSION = "0.1.0"

  REQUIRED_ENV_VARS = %w[
    CLIENT_AUTH_URI
    CLIENT_ID
    CLIENT_SECRET
    DATABASE_URL
    PORT
    TOKEN_EXCHANGE_URL
    RSA_PUBLIC_KEY
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

    puts "CLIENT_URI: '#{ENV["CLIENT_URI"]}'"
  end

  # Decode and set the RSA_PUBLIC_KEY in ENV.
  def self.set_rsa_public_key
    rsa_public_key = ENV["RSA_PUBLIC_KEY"]
    decoded_rsa = Base64.decode_string(rsa_public_key)

    ENV["RSA_PUBLIC_KEY"] = decoded_rsa

    puts "RSA_PUBLIC_KEY: '#{ENV["RSA_PUBLIC_KEY"]}'"
  end
end

# Pre-requisites for loading code...
TodoAPI.assert_env_vars
TodoAPI.set_env_client_uri
TodoAPI.set_rsa_public_key

# Require local code files.
require "./todo_api/models/database" # Establishes a connection.
require "./todo_api/models/model"
require "./todo_api/models/**"
require "./todo_api/controllers/auth"
require "./todo_api/controllers/**"

# Start the HTTP Server.
Kemal.run do |config|
  server = config.server.not_nil!
  server.bind_tcp("0.0.0.0", ENV["PORT"].to_i)
end

Database.disconnect
