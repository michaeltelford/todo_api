# Get the user's todo lists.
get "/list/:user_id" do |env|
  halt env, 401 unless authorized?(env)

  user_id = env.params.url["user_id"]
  list = List.get(user_id)
  halt env, 400 unless list

  list.to_json
end

# Get the todo list by ID, providing it belongs to the user.
get "/list/:id" do |env|
end

# Create a todo list belonging to the user.
post "/list" do |env|
end

# Update the todo list by ID, providing it belongs to the user.
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

# Delete the todo list by ID, providing it belongs to the user.
delete "/list/:id" do |env|
end
