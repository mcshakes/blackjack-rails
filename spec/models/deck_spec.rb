require "rails_helper"

RSpec.describe Blackjack::Deck do
  context "when a game starts" do
    it "is instantiated with 52 cards" do
      deck = described_class.new
      expect(deck.cards.length).to be(52)
    end
  end

  describe "#deal" do
    it "loses a card every time it deals" do
      deck = described_class.new
      deck.deal
      deck.deal
      expect(deck.cards.length).to be(50)
    end
  end

end
