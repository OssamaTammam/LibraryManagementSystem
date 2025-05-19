# frozen_string_literal: true

# app/lib/json_web_token.rb
class JsonWebToken
  # secret to encode and decode token
  HMAC_SECRET = ENV["JWT_SECRET"]

  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    # sign token with application secret
    JWT.encode(payload, HMAC_SECRET)
  end

  def self.decode(token)
    # get payload; first index in decoded Array
    body = JWT.decode(token, HMAC_SECRET)[0]
    HashWithIndifferentAccess.new(body)
    # rescue from all decode errors
  rescue JWT::DecodeError => _e
    # raise custom error to be handled by custom handler
    raise(ErrorHandler::AuthenticationError, I18n.t("authentication.suspicious_token"))
  end
end
