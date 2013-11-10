module LaunchKey
  module Middleware
    ##
    # A response middleware for Faraday that parses error responses returned by
    # the API and raises them as {Errors::APIError}.
    class RaiseErrors < Faraday::Response::Middleware

      ##
      # HTTP response statuses that can be interpeted as a success.
      SUCCESS_CODES = 200..399

      def call(env)
        response = @app.call(env)
        response.on_complete do |env|
          if error?(response)
            raise_error(response)
          end
        end
        response
      end

      private

      def error?(response)
        !SUCCESS_CODES.include?(response.status) || unsuccessful?(response.body)
      end

      def unsuccessful?(body)
        body.is_a?(::Hash) && body.has_key?('successful') &&
          !body['successful']
      end

      def raise_error(response)
        case response.body
        when ::Hash
          raise Errors::APIError.new(
            response.body['message'], response.body['message_code'], response
          )
        else
          raise Errors::APIError.new(
            'Unknown error', nil, response
          )
        end
      end
    end # RaiseErrors
  end # Middleware
end # LaunchKey
