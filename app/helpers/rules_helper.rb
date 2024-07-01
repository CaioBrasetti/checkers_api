module RulesHelper
  class << self
    def valid_king_move?(board, old_row, old_col, new_row, new_col)
      row_diff = (new_row - old_row).abs
      col_diff = (new_col - old_col).abs

      row_diff == col_diff && board[new_row][new_col] == 1
    end

    def valid_move?(board, up_down, new_row, new_col, old_row, old_col)
      row_diff = new_row - old_row
      col_diff = (new_col - old_col).abs

      up_or_down?(row_diff, up_down) &&
        diagonal?(col_diff) &&
        empty_position?(board, new_row, new_col)
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
