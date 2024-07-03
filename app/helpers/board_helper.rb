module BoardHelper
  class << self
    def initial_board
      [
        [0, 'B', 0, 'B', 0, 'B', 0, 'B'],
        ['B', 0, 'B', 0, 'B', 0, 'B', 0],
        [0, 'B', 0, 'B', 0, 'B', 0, 'B'],
        [1, 0, 1, 0, 1, 0, 1, 0],
        [0, 1, 0, 1, 0, 1, 0, 1],
        ['W', 0, 'W', 0, 'W', 0, 'W', 0],
        [0, 'W', 0, 'W', 0, 'W', 0, 'W'],
        ['W', 0, 'W', 0, 'W', 0, 'W', 0]
      ]
    end

    def move(game, old_position, new_position, player_color)
      @board = JSON.parse(game.board)
      allowed_position = RulesHelper.captured_piece(@board, player_color)

      unless allowed_position.nil?
        return invalid_movement unless allowed_position[:new_position] == new_position
      end

      old_row, old_col = old_position.split(',').map(&:to_i) # ["2", "3"] { |s| s.to_i }
      new_row, new_col = new_position.split(',').map(&:to_i)
      piece = @board[old_row][old_col]

      return invalid_movement unless piece == player_color

      if piece.include?('K')
        # return invalid_movement unless RulesHelper.valid_king_move?(@board, old_row, old_col, new_row, new_col)

        # update_board(old_row, old_col, new_row, new_col, piece)
        # valid_movement("Movimento realizado de #{old_position} para #{new_position}")
      else
        up_down = player_color == 'W' ? -1 : 1
        row = nil
        col = nil

        if allowed_position
          piece_position = allowed_position[:piece_position].split(',').map(&:to_i)
          new_position = allowed_position[:new_position].split(',').map(&:to_i)

          row = (piece_position[0] - new_position[0]).abs
          col = (piece_position[1] - new_position[1]).abs
        end

        response = RulesHelper.valid_move?(@board, up_down, new_row, new_col, old_row, old_col, row, col)

        return invalid_movement unless response

        promote_to_king(new_row, new_col, player_color)
        update_board(old_row, old_col, new_row, new_col, piece, allowed_position)
        valid_movement("Movimento realizado de #{old_position} para #{new_position}")
      end
    end

    private

    def valid_movement(message)
      { message: message, status: :ok, board: @board }
    end

    def invalid_movement
      { error: 'Movimento inválido: movimento não permitido pelas regras', status: :unprocessable_entity }
    end

    def update_board(old_row, old_col, new_row, new_col, piece, allowed_position)
      @board[old_row][old_col] = 1
      @board[new_row][new_col] = piece

      captured_row, captured_col = allowed_position[:captured_position].split(',').map(&:to_i) if allowed_position.present?
      @board[captured_row][captured_col] = 1 if allowed_position.present?

      @board
    end

    def promote_to_king(row, col, player_color)
      return unless (player_color == 'B' && row == 7) || (player_color == 'W' && row.zero?)

      @board[row][col] = "#{player_color}K"
    end
  end
end
