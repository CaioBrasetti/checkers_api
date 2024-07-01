class Game < ApplicationRecord
  before_create :generate_tokens_to_players
  after_create :create_board

  def generate_tokens_to_players
    self.player1_token = generate_token
    self.player2_token = generate_token
  end

  def generate_token
    TokenService.generate_token
  end

  private

  def create_board
    initial_board = BoardHelper.initial_board
    update!(board: initial_board.to_json)
  end
end
