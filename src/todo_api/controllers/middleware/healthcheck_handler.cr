class Middleware::HealthcheckHandler
  include HTTP::Handler

  def call(context)
    if context.request.path == "/healthcheck"
      send_status(context, HTTP::Status::OK)
      return
    end

    call_next(context)
  end
end
