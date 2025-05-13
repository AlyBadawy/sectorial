module Securial
  module Middleware
    class RequestLoggerTag
      def initialize(app)
        @app = app
      end

      def call(env)
        request = ActionDispatch::Request.new(env)
        request_id = request.request_id || SecureRandom.uuid

        Securial::ENGINE_LOGGER.tagged("Securial", "RequestID:#{request_id}") do
          @app.call(env)
        end
      end
    end
  end
end
