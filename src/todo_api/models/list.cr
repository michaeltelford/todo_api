class List
  extend Model

  getter   id         : Int32
  getter   user_id    : String
  getter   user_name  : String?
  property todos      : JSON::Any
  getter   created_on : Time
  getter   updated_on : Time

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

  # All SQL should be idempotent e.g. using IF NOT EXISTS etc.
  def self.migrate
    sql = "
    CREATE TABLE IF NOT EXISTS list (
      id serial NOT NULL PRIMARY KEY,
      user_id text NOT NULL UNIQUE,
      user_name text NULL,
      todos json NOT NULL,
      created_on TIMESTAMP NOT NULL DEFAULT CURRENT_DATE,
      updated_on TIMESTAMP NOT NULL DEFAULT CURRENT_DATE
    );
    "
    exec { |db| db.exec(sql) }
  end

  def self.get(user_id : String) : List?
    sql = "SELECT * FROM list WHERE user_id = $1 LIMIT 1"
    exec { |db| db.query_one(sql, user_id) { |rs| new(rs) } }
  rescue DB::Error
    nil
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

  def save
    sql = "
    INSERT INTO list(user_id, user_name, todos, updated_on)
    VALUES ($1, $2, $3, $4);
    "
    # exec { |db| db.exec(sql, @user_id, @user_name, @todos, @updated_on) }
  end
end
