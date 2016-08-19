require 'colorize'

module DiceGame
  class ScoreTable
    attr_reader :total_players, :score_table

    TABLE =
      [
        [0],
        [0, 100, 200, 1000, 1100, 1200],
        [0, 0, 0, 200, 0, 0],
        [0, 0, 0, 300, 0, 0],
        [0, 0, 0, 400, 0, 0],
        [0, 50, 100, 500, 550, 600],
        [0, 0, 0, 600, 0, 0]
      ].freeze

    # Public: Computes score for the current role
    #
    # dice   - the dice (Array of values) rolled
    # player - the player who rolled the dice
    #
    # Returns array containing score for current roll, number of dice not contributing dice
    # and boolean value indicating if the player won
    def update_score(dice, player)
      count_hash = dice.each_with_object(Hash.new(0)) { |v, hash| hash[v] = dice.count(v) }
      final_score = 0
      unused_dice = 0

      count_hash.each do |k, v|
        unused_dice += 1 if TABLE[k][v] == 0
        final_score += TABLE[k][v]
      end

      unused_dice = 0 if final_score == 0
      [final_score, unused_dice, update_player_score(player, final_score)]
    end

    # Public: Updates the player's score
    #
    # player - the player for whom the score needs to be updated
    # score  - score that needs to be added
    #
    # Returns true if the player has won else false
    def update_player_score(player, score)
      @score_table[player] += score
      return true if @score_table[player] >= 3000
      false
    end

    # Public: Displays the winner who has highest score
    def display_winner
      winner = @score_table.index { |score| score >= 3000 }
      return unless winner

      puts '--------------------------------'.red
      puts 'We have a winner!'.green
      puts 'Player ' + winner.to_s.blue
      puts ' has won with score of ' + @score_table[winner].to_s.green
      puts '--------------------------------'.red
    end

    # Public: Initialize the scoring table based on number of players
    #
    # total_players - Number of players in the game
    #
    # Returns nothing
    def initialize_scores(total_players)
      @total_players ||= total_players
      @score_table = Array.new(total_players, 0)
    end
  end
end
