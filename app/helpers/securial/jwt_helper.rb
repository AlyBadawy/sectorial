module Securial
  module JwtHelper
    def self.encode(session)
      return nil unless session && session.class == Session

      base_payload = {
        jti: session.id,
        exp: 3.minutes.from_now.to_i,
        sub: "session-access-token",
        refresh_count: session.refresh_count,

      }

      session_payload = {
        ip: session.ip_address,
        agent: session.user_agent,
      }

      payload = base_payload.merge(session_payload)

      token = JWT::Token.new(payload: payload, header: { kid: "hmac" })
      token.sign!(algorithm: "HS256", key: "secret")

      token.jwt
    end

    def self.decode(token)
      encoded_token = JWT::EncodedToken.new(token)
      encoded_token.verify_signature!(algorithm: "HS256", key: "secret")
      encoded_token.verify_claims!(:exp, :jti)
      encoded_token.payload
    end
  end
end
