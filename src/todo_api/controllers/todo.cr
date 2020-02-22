include Helpers

### Endpoints

# Creates the DB model if it doesn't already exists.
post "/migrate" do |env|
  Todo.migrate
  respond(env)
end

# Get the todos belonging to the user.
get "/todo/:user_id" do |env|
  user_id = env.params.url["user_id"]
  todo = Todo.get(user_id)
  respond(env, todo, or: 400)
end

# Update the todos belonging to the user.
put "/todo/:user_id" do |env|
  raise "TODO"
end
