# spec/helpers/board_helper_spec.rb

require 'rails_helper'

RSpec.describe BoardHelper do
  describe '.move' do
    let(:board) { BoardHelper.initial_board }
    let(:game) { instance_double('Game', board: board.to_json) }

    context 'when moving a regular piece' do
      it 'moves a piece to an empty valid position' do
        allow(Game).to receive(:new).and_return(game)
        old_position = '5,2'
        new_position = '4,3'
        player_color = 'W'

        result = BoardHelper.move(game, old_position, new_position, player_color)

        expect(result[:status]).to eq(:ok)
        expect(result[:message]).to include('Movimento realizado')
      end

      it 'returns an error for an invalid move' do
        allow(Game).to receive(:new).and_return(game)
        old_position = '5,2'
        new_position = '5,4'
        player_color = 'W'

        result = BoardHelper.move(game, old_position, new_position, player_color)

        expect(result[:status]).to eq(:unprocessable_entity)
        expect(result[:error]).to include('Movimento inválido')
      end
    end
  end
end
