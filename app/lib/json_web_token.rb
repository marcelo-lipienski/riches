# frozen_string_literal: true

class JsonWebToken
  def self.encode(payload, expires_at = 24.hours.from_now)
    payload[:exp] = expires_at.to_i
    JWT.encode(payload, ENV['JWT_SECRET'], 'HS256')
  end

  def self.decode(token)
    body = JWT.decode(token, ENV['JWT_SECRET'], algorithm: 'HS256')[0]
    HashWithIndifferentAccess.new(body)
  end
end
