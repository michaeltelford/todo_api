module Helpers
  # Returns the status and data (unless nil?). Defaults to 200 OK with no body.
  def respond(env, status : Int32 = 200, data = nil)
    env.response.status = HTTP::Status.new(status)

    if data
      env.response.content_type = "application/json"
      env.response.print(data.to_json)
    end
  end

  # Returns 200 with the entity JSON or status (if entity.nil?). Use like:
  # ```
  # list = List.get(user_id) # list could be nil but there's no need to check.
  # respond(env, list, or: 400)
  # ```
  def respond(env, entity, or status : Int32)
    entity ? respond(env, data: entity) : respond(env, status)
  end
end
