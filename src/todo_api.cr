# Require standard libs / shards.
require "base64"
require "db"
require "http"
require "json"
require "jwt"
require "pg"
require "router"
require "uri"
require "debug"

require "./todo_api/env"

puts "Starting server..."

# Pre-requisites for loading server code...
assert_env_vars
set_env_client_uri
set_rsa_public_key

# Require local code files.
require "./todo_api/models/database" # Establishes a connection.
require "./todo_api/models/model"
require "./todo_api/models/**"
require "./todo_api/controllers/helpers"
require "./todo_api/controllers/middleware/*"
require "./todo_api/controllers/auth" # Load the auth helper funcs before the other controllers.
require "./todo_api/controllers/**"

# Server API providing CRUD operations on the TODO data model.
class TodoAPI
  VERSION = "0.1.0"

  include Router

  # Start the HTTP server.
  def run
    server = build_server

    host = ENV.fetch("HOST", "0.0.0.0")
    server.bind_tcp(host, ENV["PORT"].to_i)

    puts "HTTP API listening on: #{host}:#{ENV["PORT"]}"
    server.listen
  end

  private def build_server
    HTTP::Server.new([
      HTTP::LogHandler.new,
      HTTP::CompressHandler.new,
      HTTP::ErrorHandler.new(!production?),
      Middleware::HealthcheckHandler.new,
      Middleware::CORSHandler.new(ENV["CLIENT_URI"]),
      route_handler,
    ])
  end
end

api = TodoAPI.new

api.draw_auth_routes
api.draw_list_routes

api.run

Database.disconnect
