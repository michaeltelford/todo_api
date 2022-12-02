class Middleware::HealthcheckHandler
  include HTTP::Handler

  def call(context)
    if ["/health", "/healthcheck"].includes?(context.request.path)
      send_status(context, HTTP::Status::OK)
      return
    end

    call_next(context)
  end
end
