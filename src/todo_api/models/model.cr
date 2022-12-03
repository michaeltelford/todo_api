class Model
  include JSON::Serializable

  def now(timezone = "UTC")
    Time.local(Time::Location.load(timezone))
  end
end
