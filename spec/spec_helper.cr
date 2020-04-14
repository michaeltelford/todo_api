require "spec"
require "spec-kemal"
require "../src/todo_api"

CONNECTION_STRING = ENV["DATABASE_URL"]

def open
  db = DB.open(CONNECTION_STRING)
  yield(db)
ensure
  db.close if db rescue nil
end

def to_row(rs : DB::ResultSet, table : Symbol)
  # We ignore the timestamps because they're a nuisance to assert.
  case table
  when :list
    rs.read(Int32, String, String?, JSON::Any)
  else
    raise "Unknown table type"
  end
ensure
  rs.close
end
