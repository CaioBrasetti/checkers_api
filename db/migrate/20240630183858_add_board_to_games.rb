class AddBoardToGames < ActiveRecord::Migration[7.1]
  def change
    add_column :games, :board, :json
  end
end
