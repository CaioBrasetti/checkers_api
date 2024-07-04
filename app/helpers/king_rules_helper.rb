module KingRulesHelper
  class << self
    def captured_piece_king(board, color)
      captured_positions = []

      board_size = board.size - 1

      directions = [
        { row_offset: 1, col_offset: 1 },
        { row_offset: 1, col_offset: -1 },
        { row_offset: -1, col_offset: 1 },
        { row_offset: -1, col_offset: -1 }
      ]

      board.each_with_index do |row, old_row|
        row.each_with_index do |cell, old_col|
          next unless cell == "#{color}K"
          puts "Checking piece at #{old_row},#{old_col}"

          opponent_color = opponent_colors(color)

          directions.each do |dir|
            distance = 1

            loop do
              new_row = old_row + dir[:row_offset] * distance
              new_col = old_col + dir[:col_offset] * distance
              capture_row = old_row + dir[:row_offset] * (distance + 1)
              capture_col = old_col + dir[:col_offset] * (distance + 1)

              puts "Checking new position at #{new_row},#{new_col} and capture position at #{capture_row},#{capture_col}" # Mensagem de depuração

              break unless valid_king_position?(new_row, new_col, board_size) &&
              valid_king_position?(capture_row, capture_col, board_size)

              if opponent_colors(color).include?(board[new_row][new_col])
                next unless board[capture_row][capture_col] == 1

                captured_positions << {
                  piece_position: "#{old_row},#{old_col}",
                  new_position: "#{capture_row},#{capture_col}",
                  captured_position: "#{new_row},#{new_col}"
                }

                break captured_positions
              end

              distance += 1
            end
          end
        end
      end

      captured_positions.empty? ? nil : captured_positions
    end

    def opponent_colors(color)
      color == 'B' ? ['W', 'WK'] : ['B', 'BK']
    end

    def valid_king_position?(row, col, board_size)
      row.between?(0, board_size - 1) && col.between?(0, board_size - 1)
    end

    def king_allowed_positions(board, old_row, old_col, color)
      moves = []
      directions = [[1, 1], [1, -1], [-1, 1], [-1, -1]]

      directions.each do |row_dir, col_dir|
        new_row = old_row + row_dir
        new_col = old_col + col_dir

        while new_row.between?(0, 7) && new_col.between?(0, 7)
          break unless board[new_row][new_col] == 1

          moves << [new_row, new_col]
          new_row += row_dir
          new_col += col_dir
        end
      end

      moves
    end

    def valid_king_move?(board, old_row, old_col, new_row, new_col)
      row_diff = (new_row - old_row).abs
      col_diff = (new_col - old_col).abs

      row_diff == col_diff && board[new_row][new_col] == 1
    end
  end
end
