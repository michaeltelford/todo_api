include Helpers

### Endpoints

# Creates the DB model if it doesn't already exists.
post "/migrate" do |env|
  List.migrate
  respond(env, 200)
end

# Get the todo list belonging to the user.
get "/list/:user_id" do |env|
  user_id = env.params.url["user_id"]
  list = List.get(user_id)
  respond(env, list, or: 400)
end

# Update the todo list belonging to the user.
put "/list/:user_id" do |env|
  raise "TODO"
end
