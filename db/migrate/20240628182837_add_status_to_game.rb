class AddStatusToGame < ActiveRecord::Migration[7.1]
  def change
    add_column :games, :status, :string, default: 'waiting for opponent'
  end
end
