module Model
  CONNECTION_STRING = ENV["DB_CONNECTION_STRING"]
  # All SQL should be idempotent e.g. using IF NOT EXISTS etc.
  MIGRATION_SQL = "
  CREATE TABLE IF NOT EXISTS todos (
    id serial NOT NULL PRIMARY KEY,
    user_id text NOT NULL UNIQUE,
    user_name text NULL,
    todos json NOT NULL,
    created_on TIMESTAMP NOT NULL DEFAULT CURRENT_DATE,
    updated_on TIMESTAMP NOT NULL DEFAULT CURRENT_DATE
  );
  "

  def exec
    db = DB.open(CONNECTION_STRING)
    yield(db)
  ensure
    db.close if db rescue nil
  end

  def migrate
    exec { |db| db.exec(MIGRATION_SQL) }
  end
end
