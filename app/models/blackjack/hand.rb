# require "pry"
require_relative "card"

module Blackjack
  class Hand
    attr_reader :cards

    def initialize
      @cards = []
    end

    def add(card)
      @cards << card
    end

    def value
      total_value = @cards.sum(&:value)
      aces = @cards.count { |card| card.face == "Ace" }

      while total_value > 21 && aces.positive?
        total_value -= 10
        aces -= 1
      end

      total_value
    end
  end
end


# hand = Blackjack::Hand.new
# ace  = Blackjack::Card.new("Ace", "spades", 11)
# king =  Blackjack::Card.new("King", "hearts", 10)
# ate =  Blackjack::Card.new("Eight", "hearts", 8)

# hand.add(king)
# hand.add(ace)
# hand.add(ate)
# hand.value
