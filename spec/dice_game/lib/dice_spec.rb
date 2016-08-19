require 'spec_helper'

RSpec.describe DiceGame::Dice do
  let(:dice) { DiceGame::Dice.new }

  describe '#roll' do
    context 'when dice is rolled' do
      subject { dice.roll(count) }

      let(:count) { 5 }

      it 'returns a set of Array of integers' do
        expect(subject.is_a?(Array)).to eq(true)
      end

      context 'when called with different count' do
        let(:count) { 3 }

        it 'returns array containing that many numbers' do
          expect(subject.size).to eq(3)
        end
      end
    end
  end
end
