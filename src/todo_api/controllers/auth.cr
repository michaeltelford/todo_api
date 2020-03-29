# Check if an auth'd session exists for the client and return it.
get "/session" do |env|
  halt env, 401 unless authorized?(env)

  { session: get_user_session(env) }.to_json
end

# Authenticate and start a new session for the client.
post "/session" do |env|
  payload = env.params.json.as(Hash)
  halt env, 401 unless payload["authorizationCode"]?

  authCode = payload["authorizationCode"].as(String)
  id_token = exchange_code(authCode) rescue halt env, 401

  payload, _ = JWT.decode(id_token, verify: false, validate: false)
  if payload["aud"].as_s != ENV["CLIENT_ID"]
    puts "payload[aud] didn't match ENV[CLIENT_ID]"
    halt env, 401
  end

  set_user_session(env, payload["name"].as_s, payload["email"].as_s)

  { session: get_user_session(env) }.to_json
end

# Delete the user session for the client.
delete "/session" do |env|
  env.session.destroy

  halt env, 204
end

# Helper method used in any endpoints requiring auth.
# Note, before_all has a bug and doesn't filter the path.
def authorized?(env) : Bool
  env.session.bool?("logged_in") ? true : false
end

# Helper method used in any endpoints requiring auth.
# Returns true if the user has access to the given list.
def allow_access?(env, list : List) : Bool
  return false unless env.session.string?("email")

  env.session.string("email") == list.user_email
end

def get_user_session(env) : NamedTuple(name: String, email: String)
  raise "Not logged in" unless env.session.bool?("logged_in")

  name = env.session.string("name")
  email = env.session.string("email")

  { name: name, email: email }
end

private def set_user_session(env, name : String, email : String) : Nil
  env.session.bool("logged_in", true)
  env.session.string("name", name)
  env.session.string("email", email)

  nil
end

# Exchange an auth0 authorization code for a JWT ID token.
private def exchange_code(authCode : String) : String
  url = ENV["TOKEN_EXCHANGE_URL"]
  headers = HTTP::Headers{
    "Content-Type" => "application/x-www-form-urlencoded",
    "Accept" => "application/json"
  }
  payload = {
    "grant_type" => "authorization_code",
    "client_id" => ENV["CLIENT_ID"],
    "client_secret" => ENV["CLIENT_SECRET"],
    "code" => authCode,
    "redirect_uri" => ENV["CLIENT_AUTH_URI"]
  }

  HTTP::Client.post(url, headers, form: payload) do |response|
    body = response.body_io.gets_to_end
    unless response.success?
      puts  "token exchange failure: #{response.status} #{body}"
      raise "Token exchange failure"
    end

    json = Hash(String, String | Int32).from_json(body)
    return json["id_token"].as(String)
  end
end
