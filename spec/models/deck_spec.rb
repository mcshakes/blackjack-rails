require "rails_helper"

RSpec.describe Blackjack::Deck do
  subject(:deck) { described_class.new }

  describe "#initialize" do
    let(:ace) { Blackjack::Card.new("Ace", "spades", 11) }
    let(:king) { Blackjack::Card.new("King", "hearts", 10) }
    let(:five) { Blackjack::Card.new(5, "clubs", 5) }

    context "when a game starts" do
      it "contains 52 unique cards" do
        unique_cards = deck.cards.map { |card| [ card.face, card.suit ] }

        expect(unique_cards.uniq.length).to be(52)
      end

      it "contains 13 cards of each suit" do
        suits = deck.cards.group_by(&:suit)

        expect(suits.keys).to contain_exactly(
          "clubs", "spades", "hearts", "diamonds"
        )

        suits.each_value do |cards|
          expect(cards.length).to be(13)
        end
      end
    end

    context "when cards are provided" do
      it "uses the provided cards instead of generating a new deck" do
        deck = described_class.new(cards: [ace, king, five])

        expect(deck.cards).to contain_exactly(ace, king, five)
      end

      it "maintains the order of the provided cards" do
        deck = described_class.new(cards: [ace, king, five])

        expect(deck.cards).to eq([ace, king, five])
      end

      it "deals the provided cards in reverse array order" do
        deck = described_class.new(cards: [ace, king, five])

        expect(deck.deal).to eq(five)
        expect(deck.deal).to eq(king)
        expect(deck.deal).to eq(ace)
      end
    end

    context "when an empty array is provided" do
      it "creates an empty deck instead of a new 52-card deck" do
        deck = described_class.new(cards: [])

        expect(deck.cards).to be_empty
      end
    end
  end

  describe "#deal" do
    it "loses a card every time it deals" do
      deck.deal
      deck.deal

      expect(deck.cards.length).to be(50)
    end

    it "returns a Card object" do
      expect(deck.deal).to be_a(Blackjack::Card)
    end

    it "removes the dealt card from the deck" do
      card = deck.deal

      expect(deck.cards).not_to include(card)
    end

    context "when the deck is empty" do
      it "returns nil when attempting to deal" do
        52.times { deck.deal }

        expect(deck.deal).to be_nil
      end
    end
  end
end
