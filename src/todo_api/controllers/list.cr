# Get the user's todo lists.
get "/lists" do |env|
  halt env, 401 unless authorized?(env)
  email = env.session.string("email")

  lists = List.list(email)
  lists.to_json
end

# Get the todo list by ID, providing it belongs to the user.
get "/list/:id" do |env|
  halt env, 401 unless authorized?(env)

  list_id = env.params.url["id"]
  list = List.get(list_id)

  halt env, 404 unless list
  halt env, 401 unless allow_access?(env, list)

  list.to_json
end

# Create a todo list belonging to the user.
post "/list" do |env|
  halt env, 401 unless authorized?(env)
  payload = env.params.json.as(Hash)

  halt env, 400 unless payload["list"]?
  json = payload["list"].as(Hash)

  halt env, 400 unless json["name"]? && json["todos"]?
  name  = json["name"].to_s
  todos = json["todos"].as(JSON::Any)

  list = List.new(
    env.session.string("email"), env.session.string("name"), name, todos
  )
  list.save

  halt env, 201
end

# Update the todo list by ID, providing it belongs to the user.
put "/list/:id" do |env|
  halt env, 401 unless authorized?(env)

  list_id = env.params.url["id"]
  payload = env.params.json.as(Hash)

  halt env, 400 unless payload["list"]?
  json = payload["list"].as(Hash)

  halt env, 400 unless json["name"]? && json["todos"]?
  name  = json["name"].to_s
  todos = json["todos"].as(JSON::Any)

  list = List.get(list_id)
  halt env, 404 unless list
  halt env, 401 unless allow_access?(env, list)

  list.name  = name
  list.todos = todos

  list.save
end

# Delete the todo list by ID, providing it belongs to the user.
delete "/list/:id" do |env|
  halt env, 401 unless authorized?(env)

  list_id = env.params.url["id"]
  list = List.get(list_id)

  halt env, 404 unless list
  halt env, 401 unless allow_access?(env, list)

  list.delete

  halt env, 204
end
