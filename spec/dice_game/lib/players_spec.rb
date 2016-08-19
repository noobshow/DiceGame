require 'spec_helper'

RSpec.describe DiceGame::Players do
  let(:players) { DiceGame::Players.new }

  describe '#number_of_players' do
    subject { players.number_of_players(count) }

    let(:count) { 5 }

    context 'when player count is greater than 3' do
      let(:count) { 6 }

      it 'returns 3' do
        expect(subject).to eq(3)
      end
    end

    context 'when player count is 0' do
      let(:count) { 0 }

      it 'returns 3' do
        expect(subject).to eq(3)
      end
    end

    context 'when player count is between 0 and 3' do
      let(:count) { 2 }

      it 'returns count' do
        expect(subject).to eq(count)
      end
    end
  end
end
