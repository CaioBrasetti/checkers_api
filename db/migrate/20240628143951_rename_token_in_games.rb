class RenameTokenInGames < ActiveRecord::Migration[7.1]
  def change
    rename_column :games, :token, :player1_token

    change_column_null :games, :player1_token, false
  end
end
