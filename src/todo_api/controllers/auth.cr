# Check if an auth'd session exists for the client.
get "/session" do |env|
  # env.session.user_id ? 200 : 401
  200
end

# Auth and start a new session for the client.
post "/auth" do |env|
  200
end
