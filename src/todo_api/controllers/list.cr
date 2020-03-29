# Get the user's todo lists.
get "/lists" do |env|
  halt env, 401 unless authorized?(env)

  email = env.session.string("email")
  lists = List.list(email)

  { lists: lists }.to_json
end

# Get the todo list by ID, providing it belongs to the user.
get "/list/:id" do |env|
  halt env, 401 unless authorized?(env)

  list_id = env.params.url["id"]
  list = List.get(list_id)

  halt env, 404 unless list
  halt env, 401 unless allow_access?(env, list)

  { list: list }.to_json
end

# Create a todo list belonging to the user.
post "/list" do |env|
  halt env, 401 unless authorized?(env)

  json = env.params.json.as(Hash)
  halt env, 400 unless json["list"]?
  payload = json["list"].as(Hash)
  halt env, 400 unless payload["name"]? && payload["todos"]?

  name    = payload["name"].to_s
  todos   = payload["todos"].as(JSON::Any)
  session = get_user_session(env)

  list = List.new(session[:email], session[:name], name, todos)
  list.save rescue halt env, 400

  halt env, 201
end

# Update the todo list by ID, providing it belongs to the user.
put "/list/:id" do |env|
  halt env, 401 unless authorized?(env)

  json = env.params.json.as(Hash)
  halt env, 400 unless json["list"]?
  payload = json["list"].as(Hash)
  halt env, 400 unless payload["name"]? && payload["todos"]?

  name  = payload["name"].to_s
  todos = payload["todos"].as(JSON::Any)

  list_id = env.params.url["id"]
  list = List.get(list_id)

  halt env, 404 unless list
  halt env, 401 unless allow_access?(env, list)

  list.name  = name
  list.todos = todos

  list.save rescue halt env, 400
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
