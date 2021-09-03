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
def assert_env_vars
  unless REQUIRED_ENV_VARS.all? { |var| ENV[var]? }
    raise "ENV must include: #{REQUIRED_ENV_VARS}"
  end
end

# Set the client origin URI (for CORS headers) in ENV.
def set_env_client_uri
  auth_uri = URI.parse(ENV["CLIENT_AUTH_URI"])
  raise "Invalid CLIENT_AUTH_URI" unless auth_uri.absolute?

  client_uri = "#{auth_uri.scheme}://#{auth_uri.host}"
  client_uri += ":#{auth_uri.port}" if auth_uri.port

  ENV["CLIENT_URI"] = client_uri

  puts "CLIENT_URI: '#{ENV["CLIENT_URI"]}'"
end

# Decode and set the RSA_PUBLIC_KEY in ENV.
def set_rsa_public_key
  rsa_public_key = ENV["RSA_PUBLIC_KEY"]
  decoded_rsa = Base64.decode_string(rsa_public_key)

  ENV["RSA_PUBLIC_KEY"] = decoded_rsa

  puts "RSA_PUBLIC_KEY: '#{ENV["RSA_PUBLIC_KEY"]}'"
end

# Returns true if running in "production" mode.
def production?
  ENV["TODO_ENV"]? === "production"
end
