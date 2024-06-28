class Game < ApplicationRecord
  before_create :generate_token

  def generate_token
    self.token = TokenService.generate_token
  end
end
