require 'thor'
require 'colorize'
require 'pry'
require_relative 'dice'
require_relative 'players'
require_relative 'score_table'

module DiceGame
  class Game < Thor
    RULES_GAME_OPTION = 'r'.freeze
    START_GAME_OPTION = 's'.freeze

    default_task :help

    desc 'start', 'Initiate the game'
    def start
      say_hello
    end

    desc 'about', 'Read the game rules'
    def about
      open('game_rules.txt') do |file|
        say file.read.yellow
      end
    end

    no_commands do

      # Public: say hello to user and provide options
      def say_hello
        say 'Welcome to Dice game.'.green
        option = ask('press R to read the rules. Press S to start the game.'.yellow)
        game_option(option)
      end

      # Public: display and start the game based on option selected by user
      #
      # option - the command line option user entered
      def game_option(option)
        case option.downcase
        when RULES_GAME_OPTION
          open('game_rules.txt') do |file|
            say file.read.yellow
          end
          ask('Press enter to start the game'.yellow)
          initialize_game
        when START_GAME_OPTION
          say '-------------'\
               'starting the game'\
               '-------------'.green
          show_wait_cursor(3)
          initialize_game
        end
      end

      # Public: Initialize all the things needed to start the game
      def initialize_game
        @winner = false
        @players = DiceGame::Players.new
        @score_table = DiceGame::ScoreTable.new
        @dice = DiceGame::Dice.new

        count ||= ask('Please enter number of players, max 3'.yellow)
        @score_table.initialize_scores(@players.number_of_players(count.to_i))
        start_game
      end

      # Public: start the game
      def start_game
        player = 0

        until @winner == true
          say '--------------------'.light_blue
          player = 0 if player >= @score_table.total_players
          play(player, 5)
          player += 1
        end

        @score_table.display_winner

        display_all_scores
      end

      # Public: handle the rolling of dice and the turns for user
      #
      # player     - player who has to roll the dice
      # dice_count - number of dice left to roll
      def play(player, dice_count)
        say 'Player:' + player.to_s.red
        ask('enter to roll dice')
        values = @dice.roll(dice_count)
        show_wait_cursor(3)
        score, unused_dice, @winner = @score_table.update_score(values, player)
        say 'score for this roll: ' + score.to_s.red
        say 'Current score: ' + @score_table.score_table[player].to_s.yellow

        if unused_dice > 0
          say 'you still have dice which did not contribute to score'.yellow
          play(player, unused_dice)
        end
      end

      # Public: display the score table
      def display_all_scores
        show_wait_cursor(3)
        all_scores = @score_table.score_table
        say '----------------------'.yellow
        all_scores.each { |s| say 'player:' + all_scores.index(s).to_s.blue + ' score: ' + s.to_s.red }
        say '----------------------'.yellow
      end

      def show_wait_cursor(seconds,fps=10)
        chars = %w[| / - \\]
        delay = 1.0/fps
        (seconds*fps).round.times{ |i|
          print chars[i % chars.length]
          sleep delay
          print "\b"
        }
      end
    end
  end
end
