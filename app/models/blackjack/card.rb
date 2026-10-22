module Blackjack
  class Card
    attr_reader :face, :suit, :value

    def initialize(face, suit, value)
      @face = face
      @suit = suit
      @value = value # 11,10,10 (scoring value)
    end
  end
end
