# Get the user's todo lists.
get "/lists" do |env|
  halt env, 401 unless authorized?(env)

  email, _ = get_current_user(env)
  lists = List.all(email)

  {lists: lists}.to_json
end

# Get the todo list by ID, providing it belongs to the user.
get "/list/:id" do |env|
  halt env, 401 unless authorized?(env)

  list_id = env.params.url["id"]
  list = List.get(list_id)

  halt env, 404 unless list
  halt env, 401 unless allow_access?(env, list)

  {list: list}.to_json
end

# Create a todo list belonging to the user.
post "/list" do |env|
  halt env, 401 unless authorized?(env)

  list_name, todos, additional_users = parse_request(env) rescue halt env, 400
  email, user_name = get_current_user(env)

  list = List.new(email, user_name, list_name, todos, additional_users)
  list.save rescue halt env, 400

  halt env, 201
end

# Update the todo list by ID, providing it belongs to the user.
put "/list/:id" do |env|
  halt env, 401 unless authorized?(env)

  name, todos, additional_users = parse_request(env) rescue halt env, 400
  list_id = env.params.url["id"]
  list = List.get(list_id)

  halt env, 404 unless list
  halt env, 401 unless allow_access?(env, list)

  list.name = name
  list.todos = todos
  list.additional_users = additional_users

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

private def parse_request(env) : Tuple
  json = env.params.json
  body = json["list"].as(Hash(String, JSON::Any))

  {
    body["name"].as_s,
    body["todos"],
    body["additional_users"],
  }
end
