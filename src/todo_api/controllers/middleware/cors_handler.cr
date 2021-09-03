module Middleware
  # Sets the correct CORS headers for the TODO Checklist client origin.
  class CORSHandler
    include HTTP::Handler

    def initialize(@origin : String)
    end

    def call(context)
      # Allow the TODO client to make requests based on it's origin.
      context.response.headers.add("Access-Control-Allow-Origin", @origin)
      context.response.headers.add("Vary", "Origin")

      # For pre-flight requests.
      if context.request.method == "OPTIONS"
        context.response.headers.add("Access-Control-Allow-Methods", "POST,PUT,PATCH,DELETE")
        context.response.headers.add("Access-Control-Allow-Headers", "Content-Type,Authorization")
        context.response.headers.add("Access-Control-Max-Age", "86400") # 24 hours.

        return
      end

      call_next(context)
    end
  end
end
