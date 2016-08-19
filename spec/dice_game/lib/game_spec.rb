require 'spec_helper'

RSpec.describe DiceGame::Game do
  let(:game) { DiceGame::Game.new }

  before do
    allow(game).to receive(:say)
    allow(game).to receive(:ask).and_return(option)
    allow(game).to receive(:show_wait_cursor)
  end

  let(:option) { 'R' }

  describe '#say_hello' do
    subject { game.say_hello }

    before do
      allow(game).to receive(:game_option)
    end

    it 'displays welcome message' do
      expect(game).to receive(:say).with('Welcome to Dice game.'.green)
      subject
    end

    it 'asks for user input' do
      expect(game).to receive(:ask).with('press R to read the rules. Press S to start the game.'.yellow)
      subject
    end

    it 'calls game_option with option' do
      expect(game).to receive(:game_option).with(option)
      subject
    end
  end

  describe '#game_option' do
    subject { game.game_option(option) }

    before do
      allow(game).to receive(:initialize_game)
    end

    let(:option) { 'R' }

    context 'when user inputs option R' do
      before do
        allow(game).to receive(:open).with('game_rules.txt').and_return(txt_file)
      end

      let(:txt_file) { double(File, read: {}) }

      it 'opens and reads the file' do
        expect(game).to receive(:open).with('game_rules.txt')
        subject
      end
    end

    context 'when user inputs option S' do
      let(:option) { 'S' }

      it 'prints start game message' do
        expect(game).to receive(:say).exactly(1).times
        subject
      end

      it 'calls initialize_game' do
        expect(game).to receive(:initialize_game)
        subject
      end
    end

    context 'when user inputs some other value' do
      let(:option) { 'A' }

      it 'does nothing' do
        expect(game).to_not receive(:initialize_game)
        subject
      end
    end
  end

  describe '#initialize_game' do
    subject { game.initialize_game }

    before do
      allow(game).to receive(:start_game)
    end

    it 'initializes winner to false' do
      subject
      expect(game.instance_variable_get(:@winner)).to_not be nil
    end

    it 'creates new score_table' do
      subject
      expect(game.instance_variable_get(:@score_table)).to_not be nil
    end

    it 'creates new dice' do
      subject
      expect(game.instance_variable_get(:@dice)).to_not be nil
    end

    it 'asks user for number of players' do
      expect(game).to receive(:ask).with('Please enter number of players, max 3'.yellow)
      subject
    end
  end

  describe '#start_game' do
    subject { game.start_game }

    before do
      allow(game).to receive(:play)
      allow(game).to receive(:display_all_scores)
      allow_any_instance_of(DiceGame::ScoreTable).to receive(:display_winner)
      game.instance_variable_set(:@winner, value)
      game.instance_variable_set(:@score_table, score_table)
    end

    let(:score_table) { instance_double(DiceGame::ScoreTable, display_winner: {}, total_players: 2) }

    context 'when there is a winner' do
      let(:value) { true }

      it 'calls display winner' do
        expect(score_table).to receive(:display_winner)
        subject
      end
      it 'calls display all scores' do
        expect(game).to receive(:display_all_scores)
        subject
      end
    end
  end

  describe '#play' do
    subject { game.play(player, dice_count) }

    before do
      allow_any_instance_of(DiceGame::Dice).to receive(:roll).and_return([1, 1, 1])
      allow_any_instance_of(DiceGame::ScoreTable).to receive(:update_score).and_return([10, unused_dice.to_i, false])
      game.instance_variable_set(:@dice, dice)
      game.instance_variable_set(:@score_table, score_table)
    end

    let(:player) { 0 }
    let(:dice_count) { 3 }
    let(:unused_dice) { 0 }
    let(:dice) { instance_double(DiceGame::Dice, roll: [1, 1, 1]) }
    let(:score_table) do
      instance_double(
        DiceGame::ScoreTable,
        display_winner: {},
        update_score: [10, unused_dice.to_i, false],
        score_table: [100]
      )
    end

    it 'calls roll dice' do
      expect(dice).to receive(:roll).with(3)
      subject
    end

    it 'calls update score' do
      expect(score_table).to receive(:update_score)
      subject
    end
  end

  describe '#display_all_scores' do
    subject { game.display_all_scores }

    before do
      game.instance_variable_set(:@score_table, score_table)
    end

    let(:score_table) do
      instance_double(
        DiceGame::ScoreTable,
        score_table: [10, 10]
      )
    end

    it 'displays all scores' do
      expect(game).to receive(:say).exactly(4).times
      subject
    end
  end
end
