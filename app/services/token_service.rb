class TokenService
  SECRET_KEY = Rails.application.credentials.secret_key_base

  def self.generate_token(game_id)
    payload = { game_id: game_id }
    JWT.encode(payload, SECRET_KEY, 'HS256')
  end

  def self.decode_token(token)
    decoded = JWT.decode(token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new(decoded)
  rescue JWT::DecodeError
    nil
  end
end
