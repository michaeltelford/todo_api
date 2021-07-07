# Exchange the auth code for a JWT token, used in subsequent requests.
post "/session" do |env|
  auth_code = parse_auth_code(env) rescue halt env, 400
  id_token = exchange_code(auth_code)
  payload = decode_token(id_token)

  {
    session: {
      token:   id_token,
      name:    payload["name"].as_s,
      email:   payload["email"].as_s,
      picture: payload["picture"].as_s,
    },
  }.to_json
rescue
  halt env, 401
end

# Helper method used in any endpoints requiring auth. Sets the authorised
# user's name and email if successful.
# Note, kemal's before_all has a bug and doesn't filter the path so can't be used.
def authorized?(env) : Bool
  auth = env.request.headers["Authorization"]
  id_token = auth.split("Bearer ").last
  payload = decode_token(id_token)

  set_current_user(env, payload)
  true
rescue
  false
end

# Helper method used in any endpoints requiring auth.
# Returns true if the user has access to the given list.
def allow_access?(env, list : List) : Bool
  current_user_email = env.get?("current_user_email")
  list.has_access?(current_user_email)
end

# Returns the authorised user's username and email.
def get_current_user(env) : Tuple(String, String, String?)
  {
    env.get("current_user_email").as(String),
    env.get("current_user_name").as(String),
    env.get?("current_user_picture").as?(String),
  }
end

# Set the current user in the env from an JWT payload.
private def set_current_user(env, payload)
  env.set("current_user_email", payload["email"].as_s)
  env.set("current_user_name", payload["name"].as_s)
  env.set("current_user_picture", payload["picture"].as_s) if payload["picture"]?
end

# Extract the authorization_code from the request.
private def parse_auth_code(env) : String
  payload = env.params.json.as(Hash)
  payload["authorization_code"].as(String)
end

# Exchange an auth0 authorization code for a JWT ID token.
private def exchange_code(auth_code : String) : String
  url = ENV["TOKEN_EXCHANGE_URL"]
  headers = HTTP::Headers{
    "Content-Type" => "application/x-www-form-urlencoded",
    "Accept"       => "application/json",
  }
  payload = {
    "grant_type"    => "authorization_code",
    "client_id"     => ENV["CLIENT_ID"],
    "client_secret" => ENV["CLIENT_SECRET"],
    "code"          => auth_code,
    "redirect_uri"  => ENV["CLIENT_AUTH_URI"],
  }

  HTTP::Client.post(url, headers, form: payload) do |response|
    body = response.body_io.gets_to_end
    unless response.success?
      puts "Token exchange failure: #{response.status} #{body}"
      raise "Token exchange failure"
    end

    json = Hash(String, String | Int32).from_json(body)
    # We discard the access & refresh tokens, as they're not needed.
    return json["id_token"].as(String)
  end
end

# Verify and validate the JWT token, returning its payload.
private def decode_token(token)
  payload, _ = JWT.decode(
    token, ENV["RSA_PUBLIC_KEY"], JWT::Algorithm::RS256, aud: ENV["CLIENT_ID"]
  )
  payload
rescue ex
  puts "Token decode failure: #{ex.message}"
  raise "Token decode failure"
end
