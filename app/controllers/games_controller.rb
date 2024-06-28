class GamesController < ApplicationController
  def create
    @game = Game.new

    if @game.save
      render json: @game, status: :created
    else
      render json: { errors: @game.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
