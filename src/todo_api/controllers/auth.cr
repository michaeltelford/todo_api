class TodoAPI
  def draw_auth_routes
    # Exchange the auth code for a JWT token, used in subsequent requests.
    post "/session" do |context, _|
      auth_code = parse_auth_code(context)
      id_token = exchange_code(context, auth_code)
      token = decode_token(context, id_token)

      send_json(context, {
        session: {
          token:   id_token,
          name:    token["name"].as_s,
          email:   token["email"].as_s,
          picture: token["picture"].as_s,
        },
      })

      context
    rescue
      context
    end

    # Get the current user info from the JWT token.
    get "/session" do |context, _|
      authorized?(context)

      email, name, picture = get_current_user(context)

      send_json(context, {
        session: {
          email:   email,
          name:    name,
          picture: picture,
        },
      })

      context
    rescue
      context
    end
  end
end

# Helper method used in any endpoints requiring auth. Sets the authorised
# user's name and email if successful. Raises an Exception if not.
def authorized?(context)
  auth = context.request.headers["Authorization"]
  id_token = auth.split("Bearer ").last
  payload = decode_token(context, id_token)

  set_current_user(context, payload)
rescue
  halt(context, HTTP::Status::UNAUTHORIZED)
end

# Helper method used in any endpoints requiring auth.
# Raises an Exception if the user doesn't has access to the given list.
def has_access?(context, list : List)
  current_user_email = context["current_user_email"].as(String)
  return if list.has_access?(current_user_email)

  halt(context, HTTP::Status::UNAUTHORIZED)
end

# Helper method which returns the authorised user's username and email.
def get_current_user(context) : Tuple(String, String, String?)
  {
    context["current_user_email"].as(String),
    context["current_user_name"].as(String),
    context["current_user_picture"].as?(String),
  }
end

# Set the current user in the context from an JWT payload.
private def set_current_user(context, payload)
  context["current_user_email"]   = payload["email"].as_s
  context["current_user_name"]    = payload["name"].as_s
  context["current_user_picture"] = payload["picture"].as_s if payload["picture"]?
end

# Extract the authorization_code from the request.
private def parse_auth_code(context) : String
  json = get_payload(context)
  json["authorization_code"].as_s
rescue
  halt(context, HTTP::Status::BAD_REQUEST)
end

# Exchange an auth0 authorization code for a JWT ID token.
private def exchange_code(context, auth_code : String) : String
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
      halt(context, HTTP::Status::BAD_REQUEST)
    end

    json = Hash(String, String | Int32).from_json(body)
    # We discard the access & refresh tokens, as they're not needed.
    return json["id_token"].as(String)
  end
end

# Verify and validate the JWT token, returning its payload.
private def decode_token(context, token)
  payload, _ = JWT.decode(
    token, ENV["RSA_PUBLIC_KEY"], JWT::Algorithm::RS256, aud: ENV["CLIENT_ID"]
  )
  payload
rescue ex
  puts "Token decode failure: #{ex.message}"
  halt(context, HTTP::Status::BAD_REQUEST)
end
