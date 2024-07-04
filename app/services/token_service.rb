class TokenService
  def self.generate_token
    SecureRandom.hex(32)
  end

  def self.validate_token?(header_token, game)
    header_token == game.player1_token || header_token == game.player2_token
  end
end
