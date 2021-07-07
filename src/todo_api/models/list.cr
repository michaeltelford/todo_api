class List < Model
  MAX_LISTS_PER_USER = 20

  getter id : Int32
  getter user_email : String
  getter user_name : String?
  property name : String
  property todos : JSON::Any
  property additional_users : JSON::Any
  getter created_on : Time
  getter updated_on : Time

  def initialize(
    @id, @user_email, @user_name, @name, @todos, @additional_users, @created_on, @updated_on
  )
  end

  def initialize(@user_email, @user_name, @name, @todos, @additional_users)
    @id = 0
    @created_on = Time.local
    @updated_on = Time.local
  end

  def initialize(rs : DB::ResultSet)
    initialize(
      rs.read(Int32),
      rs.read(String),
      rs.read(String?),
      rs.read(String),
      rs.read(JSON::Any),
      rs.read(JSON::Any),
      rs.read(Time),
      rs.read(Time)
    )
  end

  # Get a single list by ID.
  def self.get(id : String) : List?
    sql = <<-SQL
          SELECT id, user_email, user_name, name, todos, additional_users, created_on, updated_on
          FROM list
          WHERE id = $1
          LIMIT 1;
          SQL
    open { |db| db.query_one(sql, id) { |rs| new(rs) } } rescue nil
  end

  # Get all lists that the user has access to.
  def self.all(user_email : String) : Array(List)
    lists = Array(List).new

    sql = <<-SQL
          SELECT id, user_email, user_name, name, todos, additional_users, created_on, updated_on
          FROM list
          WHERE user_email = $1
          OR (additional_users)::jsonb ? $1
          ORDER BY created_on;
          SQL
    open do |db|
      db.query(sql, user_email) { |rs| rs.each { lists << new(rs) } }
    end

    lists
  end

  # Delete this list.
  def delete
    sql = "DELETE FROM list WHERE id = $1;"
    open { |db| db.exec(sql, @id) }
  end

  # Upsert this list.
  def save
    @id > 0 ? update : create
  end

  # Returns wether the user has access to this list.
  def has_access?(current_user_email) : Bool
    return false unless current_user_email

    (@user_email == current_user_email) || (@additional_users.as_a.includes?(current_user_email))
  end

  # Insert/create this list.
  private def create
    sql = "SELECT COUNT(id) FROM list WHERE user_email = $1;"
    num_lists = open { |db| db.scalar(sql, @user_email).as(Int64) }
    raise "Max lists achieved" if num_lists >= MAX_LISTS_PER_USER

    sql = <<-SQL
          INSERT INTO list(user_email, user_name, name, todos, additional_users)
          VALUES ($1, $2, $3, $4, $5);
          SQL
    open do |db|
      db.exec(sql, @user_email, @user_name, @name, @todos.to_json, @additional_users.to_json)
    end
  end

  # Update this list by its ID.
  private def update
    sql = <<-SQL
          UPDATE list
          SET name = $1, todos = $2, additional_users = $3, updated_on = $4
          WHERE id = $5;
          SQL
    open { |db| db.exec(sql, @name, @todos.to_json, @additional_users.to_json, Time.local, @id) }
  end
end
