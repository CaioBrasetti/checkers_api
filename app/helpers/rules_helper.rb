module RulesHelper
  class << self
    def valid_move?(board, up_down, new_row, new_col, old_row, old_col)
      return unless new_col.positive?
      return unless new_row.positive?

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

    def king_allowed_positions(board, old_position, color)
      old_row, old_col = old_position.split(',').map(&:to_i)
      moves = []

      return unless color.include?('K')
       # add logica da dama aqui
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
