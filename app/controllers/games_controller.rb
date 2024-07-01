class GamesController < ApplicationController
  before_action :find_game, only: %i[join_game change_position check_game_status check_board_pieces]
  before_action :check_token, only: %i[change_position check_game_status check_board_pieces]

  def create
    @game = Game.new

    if @game.save
      render json:
      {
        game_id: @game.id,
        player1_token: @game.player1_token,
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

    if validate_token(token_player, token_game)
      @game.update(status: 'player_1 turn')

      render json:
      {
        status: @game.status
      }, status: :ok
    else
      render json: { error: 'Token inválido' }, status: :bad_request
    end
  end

  def change_position
    header_token = request.headers['token']

    case header_token
    when @game.player1_token
      handle_player_turn('W', 'player_1 turn', 'player_2 turn')
    when @game.player2_token
      handle_player_turn('B', 'player_2 turn', 'player_1 turn')
    else
      render json: { error: 'Token inválido' }, status: :bad_request
    end
  end

  def check_game_status
    render json: { message: "Status atual da partida: #{@game.status}" }, status: response[:status]
  end

  def check_board_pieces
    board = JSON.parse(@game.board)

    render json: { message: "Board: #{board}" }, status: :ok
  end

  private

  def handle_player_turn(color, current_status, next_status)
    return unless @game.status == current_status

    response = BoardHelper.move(@game, params['old_position'], params['new_position'], color)

    if response[:status] == :ok
      @game.update(board: response[:board].to_json, status: next_status)
      render json: { message: response[:message] }, status: response[:status]
    else
      render json: { error: response[:error] }, status: response[:status]
    end
  end

  def check_token
    header_token = request.headers['token']

    game = Game.find(params[:id])

    unless header_token == game.player1_token || header_token == game.player2_token
      render json: { error: 'Token inválido' }, status: :bad_request
    end
  end

  def validate_token(header_token, player_token)
    TokenService.validade_token(header_token, player_token)
  end

  def find_game
    @game = Game.find(params[:id])
  end
end
