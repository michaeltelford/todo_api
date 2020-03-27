class List < Model
  getter   id         : Int32
  getter   user_id    : String
  getter   user_name  : String?
  property name       : String
  property todos      : JSON::Any
  getter   created_on : Time
  getter   updated_on : Time

  JSON.mapping(
    id:         Int32,
    user_id:    String,
    user_name:  String?,
    name:       String,
    todos:      JSON::Any,
    created_on: Time,
    updated_on: Time,
  )

  def initialize(@id, @user_id, @user_name, @name, @todos, @created_on, @updated_on)
    super()
  end

  def initialize(@user_id, @user_name, @name, @todos)
    @id = 0
    @created_on = Time.local
    @updated_on = Time.local

    super()
  end

  def initialize(rs : DB::ResultSet)
    initialize(
      rs.read(Int32),
      rs.read(String),
      rs.read(String?),
      rs.read(String),
      rs.read(JSON::Any),
      rs.read(Time),
      rs.read(Time)
    )
  end

  # All SQL should be idempotent e.g. using IF NOT EXISTS etc.
  def self.migrate
    sql = "
    CREATE TABLE IF NOT EXISTS list (
      id SERIAL NOT NULL PRIMARY KEY,
      user_id TEXT NOT NULL,
      user_name TEXT NULL,
      name TEXT NOT NULL,
      todos JSON NOT NULL,
      created_on TIMESTAMP NOT NULL DEFAULT CURRENT_DATE,
      updated_on TIMESTAMP NOT NULL DEFAULT CURRENT_DATE
    );
    "
    open { |db| db.exec(sql) }
  end

  def self.get(id : String) : List?
    sql = "SELECT * FROM list WHERE id = $1 LIMIT 1;"
    open { |db| db.query_one(sql, id) { |rs| new(rs) } } rescue nil
  end

  def self.list(user_id : String) : Array(List)
    lists = Array(List).new

    sql = "SELECT * FROM list WHERE user_id = $1 LIMIT 1;"
    open { |db| db.query(sql, user_id) { |rs| lists << new(rs) } } rescue nil

    lists
  end

  def delete
    sql = "DELETE FROM list WHERE id = $1;"
    open { |db| db.exec(sql, @id) }
  end

  def save
    @id > 0 ? update : create
  end

  private def create
    sql = "INSERT INTO list(user_id, user_name, name, todos) VALUES ($1, $2, $3, $4);"
    open { |db| db.exec(sql, @user_id, @user_name, @name, @todos.to_json) }
  end

  private def update
    sql = "UPDATE list SET name = $1, todos = $2, updated_on = $3 WHERE id = $4;"
    open { |db| db.exec(sql, @name, @todos.to_json, Time.local, @id) }
  end
end
