class Model
  CONNECTION_STRING = ENV["DB_CONNECTION_STRING"]

  def self.exec
    db = DB.open(CONNECTION_STRING)
    yield(db)
  ensure
    db.close if db rescue nil
  end

  def exec(&block : DB::Database -> _)
    Model.exec(&block)
  end
end
