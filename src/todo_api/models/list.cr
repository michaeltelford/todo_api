class List
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

  def to_json
    {
      id: @id,
      user_id: @user_id,
      user_name: @user_name,
      todos: @todos,
      created_on: @created_on,
      updated_on: @updated_on
    }.to_json
  end

  def self.get(user_id : String) : List?
    sql = "SELECT * FROM list WHERE user_id = $1 LIMIT 1"
    exec { |db| db.query_one(sql, user_id) { |rs| new(rs) } }
  rescue DB::Error
    nil
  end
end
