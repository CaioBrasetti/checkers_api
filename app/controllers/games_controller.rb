class GamesController < ApplicationController
  def create
    @game = Game.new

    if @game.save
      render json: { game_id: @game.id, player2_token: @game.player2_token }, status: :created
    else
      render json: { errors: @game.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
