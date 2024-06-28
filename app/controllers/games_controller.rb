class GamesController < ApplicationController
  before_action :find_game, only: %i[join_game]

  def create
    @game = Game.new

    if @game.save
      render json:
      {
        game_id: @game.id,
        player2_token: @game.player2_token,
        status: @game.status
      }, status: :created
    else
      render json: { errors: @game.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def join_game
    token_player = request.headers['token']
    token_game = @game.player2_token

    if TokenService.validade_token(token_player, token_game)
      @game.update(status: 'player_1 turn')
      head :ok
    else
      render json: { error: 'Token inválido' }, status: :bad_request
    end
  end

  private

  def find_game
    @game = Game.find(params[:id])
  end
end
