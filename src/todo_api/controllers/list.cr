# Get the todo list belonging to the user.
get "/list/:user_id" do |env|
  halt env, 401 unless authorized?(env)

  user_id = env.params.url["user_id"]
  list = List.get(user_id)
  halt env, 400 unless list

  list.to_json
end

# Update the todos belonging to the user.
put "/list/:user_id" do |env|
  halt env, 401 unless authorized?(env)

  user_id = env.params.url["user_id"]
  payload = env.params.json.as(Hash)
  halt env, 400 unless payload["list"]? && payload["list"].as(Hash)["todos"]?

  todos = payload["list"].as(Hash)["todos"].as(JSON::Any)
  list = List.get(user_id)
  halt env, 400 unless list

  list.todos = todos
  list.save
end

# Helper method used in any endpoints requiring auth.
# Note, before_all has a bug and doesn't filter the path.
private def authorized?(env)
  env.session.bool?("logged_in")
end
