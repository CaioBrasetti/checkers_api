class Game < ApplicationRecord
  before_create :generate_tokens_to_players

  def generate_tokens_to_players
    self.player1_token = generate_token
    self.player2_token = generate_token
  end

  def generate_token
    TokenService.generate_token
  end
end
