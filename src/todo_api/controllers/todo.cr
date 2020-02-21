# List all todos belonging to the user.
get "/todo/:user_id" do
  user_id = "19384673"
  Todo.get(user_id)
end

# Update the todos belonging to the user.
# JSON body will contain the updated data... so it will.
put "/todo/:user_id" do
  "Boomsk!"
end
