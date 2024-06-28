class AddPlayer2TokenToGame < ActiveRecord::Migration[7.1]
  def change
    add_column :games, :player2_token, :string
  end
end
