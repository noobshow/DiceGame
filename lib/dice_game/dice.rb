module DiceGame
  class Dice
    attr_accessor :values

    # Public: handle the rolling of dice
    #
    # count - number of dice to roll
    #
    # Returns the array of values after dice is rolled
    def roll(count)
      @values = []
      generator = Random.new
      (1..count).each { @values << generator.rand(1..6) }
      @values
    end
  end
end
