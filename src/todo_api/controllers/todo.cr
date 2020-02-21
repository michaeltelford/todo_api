### Filters / Helpers

# Returns 200 and the entity JSON unless nil; otherwise status is returned.
private def respond(env, entity, or status : Int32)
  if entity
    env.response.content_type = "application/json"
    env.response.status = HTTP::Status::OK
    env.response.print(entity.to_json)
  else
    env.response.status = HTTP::Status.new(status)
  end
end

### Endpoints

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
