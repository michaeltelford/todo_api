# List all todos belonging to the user.
get "/todo/:user_id" do
  Todo.new.list 1
end

# Update the todos belonging to the user.
# JSON body will contain the updated data... so it will.
put "/todo/:user_id" do
  "Boomsk!"
end
