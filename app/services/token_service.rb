class TokenService
  def self.generate_token
    SecureRandom.hex(32)
  end

  def self.validate_token(header_token, player_token)
    header_token == player_token
  end
end
