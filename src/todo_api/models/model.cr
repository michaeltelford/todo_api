class Model
  include JSON::Serializable

  def now(timezone = "Europe/Dublin")
    Time.local(Time::Location.load(timezone))
  end
end
