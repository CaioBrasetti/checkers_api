module RulesHelper
  class << self
    def valid_move?(board, up_down, new_row, new_col, old_row, old_col)
      return unless new_col >= 0 && new_row >= 0

      row_diff = new_row - old_row
      col_diff = (new_col - old_col).abs

      up_or_down?(row_diff, up_down) &&
        diagonal?(col_diff) &&
        empty_position?(board, new_row, new_col)
    end

    def valid_king_move?(board, old_row, old_col, new_row, new_col)
      row_diff = (new_row - old_row).abs
      col_diff = (new_col - old_col).abs

      row_diff == col_diff && board[new_row][new_col] == 1
    end

    def allowed_positions(board, old_position, color)
      board = JSON.parse(board)

      old_row, old_col = old_position.split(',').map(&:to_i)
      return if [0, 1].include?(board[old_row][old_col])

      return king_allowed_positions(board, old_row, old_col, color) if board[old_row][old_col].include?('K')

      moves = []

      up_down = color == 'W' ? -1 : 1

      possible_positions = [
        [old_row + up_down, old_col - 1],
        [old_row + up_down, old_col + 1]
      ]

      possible_positions.each do |new_row, new_col|
        moves << [new_row, new_col] if valid_move?(board, up_down, new_row, new_col, old_row, old_col)
      end

      moves
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

    private

    def up_or_down?(row_diff, up_down)
      row_diff == up_down
    end

    def diagonal?(col_diff)
      col_diff == 1
    end

    def empty_position?(board, new_row, new_col)
      board[new_row][new_col] == 1
    end
  end
end
