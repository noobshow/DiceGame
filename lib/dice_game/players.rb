module DiceGame
  class Players
    attr_reader :players

    # Public: Sets the number of players
    #
    # number - number of players
    #
    # Returns the number of players in the game
    def number_of_players(number)
      return @players if @players

      if number > 3 || number == 0
        @players = 3
      else
        @players = number
      end
    end
  end
end
