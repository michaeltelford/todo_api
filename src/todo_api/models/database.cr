class Database
  CONNECTION_STRING = ENV["DATABASE_URL"]

  @@db : DB::Database = DB.open(CONNECTION_STRING)

  def self.run : DB::Database
    @@db
  end

  def self.disconnect
    @@db.close
  rescue ex
    puts "Error closing DB connection: #{ex.message}"
  end
end
