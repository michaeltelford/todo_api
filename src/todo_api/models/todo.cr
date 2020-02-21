class Todo
  extend Model

  getter id : Int32
  getter user_id : String
  getter user_name : String?
  getter todos : JSON::Any
  getter created_on : Time
  getter updated_on : Time

  def initialize(@id, @user_id, @user_name, @todos, @created_on, @updated_on); end

  def initialize(rs : DB::ResultSet)
    initialize(
      rs.read(Int32),
      rs.read(String),
      rs.read(String?),
      rs.read(JSON::Any),
      rs.read(Time),
      rs.read(Time)
    )
  end

  def self.get(user_id : String) : Todo?
    todo = nil
    sql = "SELECT * FROM todos WHERE user_id = $1 LIMIT 1"
    exec do |db|
      db.query_one(sql, user_id) { |rs| todo = new(rs) }
    end
    todo
  rescue _ex : DB::Error
    nil
  end
end
