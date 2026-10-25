# require "pry"
require_relative "deck"
require_relative "card"
require_relative "hand"

module Blackjack
  class Game
    attr_reader :deck, :status, :player_hand, :dealer_hand, :outcome

    def initialize(deck: Blackjack::Deck.new)
      @deck = deck
      @player_hand = Blackjack::Hand.new # Both start as empty arrays and get dealt
      @dealer_hand = Blackjack::Hand.new
      @status = :not_started
      @outcome = nil
    end

    def start
      2.times do
        @player_hand.add(@deck.deal)
        @dealer_hand.add(@deck.deal)
      end
      @status = :playing
    end

    def hit
      raise "Game is not active" unless @status == :playing

      @player_hand.add(@deck.deal)

      if @player_hand.bust?
        @status = :finished
        @outcome = :dealer_wins
      end
    end


  end
end

# king = Blackjack::Card.new("King", "hearts", 10)
# eight = Blackjack::Card.new(8, "clubs", 8)
# seven = Blackjack::Card.new(7, "diamonds", 7)
# five = Blackjack::Card.new(5, "spades", 5)
# two = Blackjack::Card.new(2, "hearts", 2)

# deck = Blackjack::Deck.new(cards: [five, seven, eight, king, five])
# game = Blackjack::Game.new(deck: deck)
# game.start
# game.hit
