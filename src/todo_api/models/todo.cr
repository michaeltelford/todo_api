class Todo < Model
  def list(user_id)
    sql = "select user_name from todos limit 1"
    exec { |db| db.query_one sql, as: { String } }
  end
end
