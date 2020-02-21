module Model
  CONNECTION_STRING = ENV["DB_CONNECTION_STRING"]

  def exec
    db = DB.open(CONNECTION_STRING)
    yield(db)
  ensure
    db.close if db rescue nil
  end
end
