class Model
  getter db : DB::Database

  def initialize
    connection_string = ENV["DB_CONNECTION_STRING"]
    @db = DB.open(connection_string)
  end

  def finalise
    close
  end

  def exec
    yield(@db)
  rescue
    close
  end

  def close
    @db.close rescue nil
  end
end
