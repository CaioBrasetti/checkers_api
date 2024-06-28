class Game < ApplicationRecord
  after_create :generate_token

  private

  def generate_token
    update(token: TokenService.generate_token(id))
  end
end
