require 'spec_helper'

RSpec.describe DiceGame::ScoreTable do
  let(:score_table) { DiceGame::ScoreTable.new }

  describe '#update_score' do
    subject { score_table.update_score(dice, player) }

    before do
      allow(score_table).to receive(:update_player_score).and_return(false)
    end

    let(:dice) { [1, 1, 1, 5, 5] }
    let(:player) { 0 }

    context 'when dice is empty array' do
      let(:dice) { [] }
      it 'returns 0' do
        expect(subject).to eq([0, 0, false])
      end
    end

    context 'when no dice contributes to score' do
      let(:dice) { [2, 3, 4, 3, 2] }

      it 'returns final score 0' do
        expect(subject).to eq([0, 0, false])
      end
    end

    context 'when at least one dice contributes to score' do
      let(:dice) { [1, 1, 1, 2, 3] }

      it 'returns final score greater than 0' do
        expect(subject).to eq([1000, 2, false])
      end

      it 'returns unused_dice dice value of greater than 0' do
        expect(subject).to eq([1000, 2, false])
      end
    end

    context 'when all dice contribute to score' do
      let(:dice) { [1, 1, 1] }

      it 'returns unused_dice value of 0' do
        expect(subject).to eq([1000, 0, false])
      end
    end
  end

  describe '#display_winner' do
    subject { score_table.display_winner }

    before do
      score_table.instance_variable_set(:@score_table, [3001, 0, 0])
      allow(STDOUT).to receive(:puts)
    end

    let(:table) { [3001, 0, 0] }
    context 'when there is a winner' do
      it 'display winner' do
        expect(STDOUT).to receive(:puts).exactly(5).times
        subject
      end
    end

    context 'when there is no actual winner' do
      let(:table) { [200, 0, 0] }

      it 'returns nothing' do
        expect(subject).to be nil
      end
    end
  end

  describe '#update_player_score' do
    subject { score_table.update_player_score(player, score) }

    before do
      score_table.instance_variable_set(:@score_table, [0, 0, 0])
    end

    let(:player) { 0 }
    let(:score) { 200 }
    context 'when player score is less than 3000' do
      it 'sets the player score' do
        subject
        expect(score_table.instance_variable_get(:@score_table)).to eq([200, 0, 0])
      end

      it 'returns false' do
        expect(subject).to eq(false)
      end
    end

    context 'when player score reaches more than 3000' do
      let(:player) { 0 }
      let(:score) { 3001 }

      it 'sets the player score' do
        subject
        expect(score_table.instance_variable_get(:@score_table)).to eq([3001, 0, 0])
      end

      it 'returns false' do
        expect(subject).to eq(true)
      end
    end
  end

  describe '#initialize_scores' do
    subject { score_table.initialize_scores(3) }

    it 'initializes score_table' do
      subject
      expect(score_table.instance_variable_get(:@score_table)).to eq([0, 0, 0])
    end
  end
end
