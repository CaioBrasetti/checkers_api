class TokenService
  def self.generate_token
    SecureRandom.hex(32)
  end

  def self.validate_token(token_player, token_game)
    token_player == token_game
  end
end
