module Blackjack
  class Deck
    SUITS = %w[clubs spades hearts diamonds].freeze
    FACES = [*(2..10), "Jack", "Queen", "King", "Ace"].freeze

    attr_reader :cards

    def initialize
      @cards = build_deck
    end

    def deal
      @cards.pop
    end

    private

    def build_deck
      combos = SUITS.product(FACES)
      combos.map do |suit, face|
        Blackjack::Card.new(face, suit, calculate_value(face))
      end.shuffle!
    end

    def calculate_value(face)
      case face
      when "Ace" then 11
      when "Jack", "Queen", "King" then 10
      else face
      end
    end
  end
end
