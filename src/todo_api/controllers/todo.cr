get "/todo/:user_id" do
  "List all todos belonging to the user"
end

put "/todo/:user_id" do
  # JSON body will contain the updated data... so it will.
  "Update all todos belonging to the user"
end
