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
        if allowed_position[:new_position] != new_position
          return invalid_movement("É obrigatório capturar usando a peça: #{allowed_position[:piece_position]}")
        end
      end

      old_row, old_col = old_position.split(',').map(&:to_i) # ["2", "3"] { |s| s.to_i }
      new_row, new_col = new_position.split(',').map(&:to_i)
      piece = @board[old_row][old_col]

      return invalid_movement unless piece == player_color || piece == "#{player_color}K"

      if piece.include?('K')
        captured_position = king_move(board, player_color, new_position, old_row, old_col, new_row, new_col)
      else
        captured_position = piece_move(player_color, allowed_position, @board, new_row, new_col, old_row, old_col)
        new_king = promote_to_king(new_row, new_col, player_color)
        piece = new_king.present? ? new_king : piece
      end

      update_board(old_row, old_col, new_row, new_col, piece, captured_position)
      valid_movement("Movimento realizado de #{old_position} para #{new_position}")
    end

    private

    def king_move(board, player_color, new_position, old_row, old_col, new_row, new_col)
      allowed_positions = KingRulesHelper.captured_piece_king(board, player_color)

      unless allowed_positions.nil?
        if allowed_positions.size.positive?
          valid_move = false
          captured = nil

          allowed_positions.each do |position|
            next if position[:new_position] != new_position

            valid_move = true
            captured = position[:captured_position]
            break
          end

          unless valid_move
            return invalid_movement("É obrigatório capturar usando a peça #{allowed_positions.first[:piece_position]}")
          end
        end
      end

      return invalid_movement unless KingRulesHelper.valid_king_move?(board, old_row, old_col, new_row, new_col)

      allowed_positions.present? ? captured : nil
    end

    def piece_move(player_color, allowed_position, board, new_row, new_col, old_row, old_col)
      up_down = player_color == 'W' ? -1 : 1
      row = nil
      col = nil

      if allowed_position
        piece_position = allowed_position[:piece_position].split(',').map(&:to_i)
        new_position = allowed_position[:new_position].split(',').map(&:to_i)

        row = (piece_position[0] - new_position[0]).abs
        col = (piece_position[1] - new_position[1]).abs
      end

      response = RulesHelper.valid_move?(board, up_down, new_row, new_col, old_row, old_col, row, col)

      return invalid_movement unless response

      allowed_position.present? ? allowed_position[:captured_position] : nil
    end

    def invalid_movement(message = nil)
      message = message.present? ? message : 'Movimento inválido: movimento não permitido pelas regras'

      { error: message, status: :unprocessable_entity }
    end

    def valid_movement(message)
      { message: message, status: :ok, board: @board }
    end

    def update_board(old_row, old_col, new_row, new_col, piece, captured_position)
      @board[old_row][old_col] = 1
      @board[new_row][new_col] = piece

      if captured_position.present?
        captured_row, captured_col = captured_position.split(',').map(&:to_i)
        @board[captured_row][captured_col] = 1
      end

      @board
    end

    def promote_to_king(row, col, player_color)
      return unless (player_color == 'B' && row == 7) || (player_color == 'W' && row.zero?)

      @board[row][col] = "#{player_color}K"
    end
  end
end
