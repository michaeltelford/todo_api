# Server API providing CRUD operations on the TODO data model.
module TodoAPI
  VERSION = "0.1.0"
end

# Require shards.
require "kemal"

# Require local files.
require "./todo_api/models/**"
require "./todo_api/controllers/**"

# Start the HTTP Server.
Kemal.run
