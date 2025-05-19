module Securial
  module Identity
    extend ActiveSupport::Concern

    included do
      before_action :authenticate_user!
    end

    class_methods do
      def skip_authentication!(**options)
        skip_before_action :authenticate_user!, **options
      end
    end

    private

    def authenticate_user!
      auth_header = request.headers["Authorization"]
      if auth_header.present? && auth_header.start_with?("Bearer ")
        token = auth_header.split(" ").last
        begin
          decoded_token = JwtHelper.decode(token)
          Current.session = Session.find_by!(id: decoded_token["jti"], revoked: false)
        rescue JWT::DecodeError, ActiveRecord::RecordNotFound => e
          render status: :unauthorized, json: { error: "Invalid token: #{e.message}" }
        end
      else
        render status: :unauthorized, json: { error: "Missing or invalid Authorization header" }
      end
    end

    def start_new_session_for(user)
      user.sessions.create!(
        user_agent: request.user_agent,
        ip_address: request.remote_ip,
        refresh_token: SecureRandom.hex(64),
        last_refreshed_at: Time.current,
        refresh_token_expires_at: 1.week.from_now,
      ).tap do |session|
        Current.session = session
      end
    end

    def create_jwt_for_current_session
      JwtHelper.encode(Current.session)
    end
  end
end
