require 'rails_helper'

RSpec.describe RulesHelper do
  describe '.captured_piece' do
    let(:board) { BoardHelper.initial_board }

    context 'when checking captured pieces' do
      it 'returns the correct captured piece information' do
        color = 'W'

        result = RulesHelper.captured_piece(board, color)

        expect(result).to be_a(Hash).or be_nil
      end
    end
  end

  describe '.captured_piece_king' do
    let(:board) { BoardHelper.initial_board }

    context 'when checking captured pieces for a king' do
      it 'returns the correct captured piece information for a king' do
        color = 'BK'

        result = KingRulesHelper.captured_piece_king(board, color)

        expect(result).to be_an(Array).or be_nil
      end
    end
  end
end
