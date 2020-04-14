class Model
  CONNECTION_STRING = ENV["DATABASE_URL"]

  def self.open
    db = DB.open(CONNECTION_STRING)
    yield(db)
  ensure
    db.close if db rescue nil
  end

  def open(&block : DB::Database -> _)
    Model.open(&block)
  end
end
