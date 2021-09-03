# API HTTP helper methods to be used by controller routes.

# Here we update HTTP::Server::Context to provide a Hash for passing around data per request.
class HTTP::Server::Context
  @context_data = {} of String => String

  def []=(key : String, value : String)
    @context_data[key] = value
  end

  def [](key : String, default : String? = nil) : String | Nil
    @context_data.fetch(key, default)
  end
end

# Returns a Hash like Object representing the JSON request body.
# You should call this from a `parse_*` method and `halt(...)` on `rescue`.
def get_payload(context) : JSON::Any
  body = context.request.body
  raise "Missing request body" unless body

  JSON.parse(body.gets_to_end)
end

# Sets the response status.
def send_status(context, status : HTTP::Status)
  context.response.status = status

  context
end

# Sets the response status and correct JSON headers and body.
def send_json(context, payload, status = HTTP::Status::OK)
  json = payload.to_json

  # The status and headers must be set **before** the body.
  context.response.status = status
  context.response.content_type = "application/json"
  context.response.content_length = json.size
  context.response.print(json)

  context
end

# Sets the desired status and raises an error. This will return the status as long as your
# handler has a `rescue { context }` block (which it should). If you're getting a generic error
# it's likely that you're missing the `rescue` when calling this method.
def halt(context, status : HTTP::Status)
  send_status(context, status)
  raise "A HTTP Handler was deliberately halted. If you're seeing this message in development it's probably because your handler is missing a `rescue { context }` block."
end
