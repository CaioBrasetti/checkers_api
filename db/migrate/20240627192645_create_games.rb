class CreateGames < ActiveRecord::Migration[7.1]
  def change
    create_table :games do |t|
      t.string :token
      t.integer :player1_pieces, default: 12
      t.integer :player2_pieces, default: 12

      t.timestamps
    end
  end
end
