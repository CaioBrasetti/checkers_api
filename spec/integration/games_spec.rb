require 'rails_helper'

RSpec.describe 'Games API', type: :request do
  describe 'POST /games' do
    it 'creates a new game' do
      post '/games'

      expect(response).to have_http_status(:created)

      json_response = JSON.parse(response.body)
      expect(json_response['game_id']).not_to be_nil
      expect(json_response['status']).to eq('waiting for opponent')
    end
  end

  describe "POST /join_game" do
    let(:game) { Game.create(player1_token: 'token1', player2_token: nil, status: 'waiting for player 2') }

    context "with valid token" do
      it "allows a player to join the game" do
        headers = { 'token' => game.player2_token }

        post "/join_game", headers: headers, params: { id: game.id }

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('player_1 turn')
      end
    end
  end

  describe "POST /join_game" do
    let(:game) { Game.create(player1_token: 'token1', player2_token: nil, status: 'waiting for player 2') }

    context "with invalid token" do
      it "returns an error" do
        headers = { 'token' => 'invalid_token' }

        post "/join_game", headers: headers, params: { id: game.id }

        expect(response).to have_http_status(:bad_request)
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq('Token inválido')
      end
    end
  end
end
