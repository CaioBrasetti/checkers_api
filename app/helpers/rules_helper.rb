module RulesHelper
  class << self
    def captured_piece(board, color)
      captured_positions = []

      directions = if color == 'W'
                     [
                       { row_offset: -1, col_offset: 1, capture_row_offset: -2, capture_col_offset: 2 },
                       { row_offset: -1, col_offset: -1, capture_row_offset: -2, capture_col_offset: -2 }
                     ]
                   else
                     [
                       { row_offset: 1, col_offset: 1, capture_row_offset: 2, capture_col_offset: 2 },
                       { row_offset: 1, col_offset: -1, capture_row_offset: 2, capture_col_offset: -2 },
                       { row_offset: -1, col_offset: 1, capture_row_offset: -2, capture_col_offset: 2 },
                       { row_offset: -1, col_offset: -1, capture_row_offset: -2, capture_col_offset: -2 }
                     ]
                   end

      board_size = board.size

      board.each_with_index do |row, old_row|
        row.each_with_index do |cell, old_col|
          next unless cell == color || cell == "#{color}K" # Incluindo checagem para peças rei

          directions.each do |dir|
            capture_row = old_row + dir[:capture_row_offset]
            capture_col = old_col + dir[:capture_col_offset]
            enemy_row = old_row + dir[:row_offset]
            enemy_col = old_col + dir[:col_offset]

            next unless valid_position?(enemy_row, enemy_col, board_size) &&
                        valid_position?(capture_row, capture_col, board_size)

            if opponent_colors(color).include?(board[enemy_row][enemy_col]) &&
               board[capture_row][capture_col] == 1

              captured_positions << {
                piece_position: "#{old_row},#{old_col}",
                new_position: "#{capture_row},#{capture_col}",
                captured_position: "#{enemy_row},#{enemy_col}"
              }
            end
          end
        end
      end

      captured_positions.empty? ? nil : captured_positions.first
    end

    def opponent_colors(color)
      color == 'B' ? ['W', 'WK'] : ['B', 'BK']
    end

    def valid_position?(row, col, board_size)
      row >= 0 && col >= 0 && row < board_size && col < board_size
    end

    def allowed_positions(board, old_position, color)
      board = JSON.parse(board)
      moves = []
      can_capture = color.include?('K') ? KingRulesHelper.captured_piece_king(board, color) : captured_piece(board, color)

      if can_capture
        moves << can_capture

        return moves
      end

      old_row, old_col = old_position.split(',').map(&:to_i)
      return if [0, 1].include?(board[old_row][old_col])

      return KingRulesHelper.king_allowed_positions(board, old_row, old_col, color) if board[old_row][old_col].include?('K')

      up_down = color == 'W' ? -1 : 1

      possible_positions = [
        [old_row + up_down, old_col - 1],
        [old_row + up_down, old_col + 1]
      ]

      possible_positions.each do |new_row, new_col|
        moves << [new_row, new_col] if valid_move?(board, up_down, new_row, new_col, old_row, old_col, nil, nil)
      end

      moves
    end

    def valid_move?(board, up_down, new_row, new_col, old_row, old_col, row, col)
      return unless new_col >= 0 && new_row >= 0

      diagonal = col.present? ? col : 1
      row_or_up_down = row.present? ? row : up_down

      row_diff = (new_row - old_row).abs
      col_diff = (new_col - old_col).abs

      row_or_up_down?(row_diff, row_or_up_down) &&
        diagonal?(col_diff, diagonal) &&
        empty_position?(board, new_row, new_col)
    end

    private

    def row_or_up_down?(row_diff, row_or_up_down)
      row_diff == row_or_up_down.abs
    end

    def diagonal?(col_diff, diagonal)
      col_diff == diagonal
    end

    def empty_position?(board, new_row, new_col)
      board[new_row][new_col] == 1
    end
  end
end
