require "rails_helper"

RSpec.describe Blackjack::Hand do
  subject(:hand) { described_class.new }

  context "when initialized" do
    it "starts with zero cards" do
      expect(hand.cards).to be_empty
    end
  end

  describe "#add" do
    let(:ace) { Blackjack::Card.new("Ace", "spades", 11) }
    let(:king) { Blackjack::Card.new("King", "hearts", 10) }

    context "when receiving cards" do
      it "adds cards to the hand" do
        hand.add(ace)
        hand.add(king)

        expect(hand.cards).to contain_exactly(ace, king)
      end
    end
  end

  describe "#value" do
    let(:ace) { Blackjack::Card.new("Ace", "spades", 11) }
    let(:king) { Blackjack::Card.new("King", "hearts", 10) }
    let(:queen) { Blackjack::Card.new("Queen", "clubs", 10) }
    let(:five) { Blackjack::Card.new(5, "diamonds", 5) }
    let(:eight) { Blackjack::Card.new(8, "hearts", 8) }
    let(:nine) { Blackjack::Card.new(9, "clubs", 9) }

    context "when receiving numbered cards" do
      it "calculates their total value" do
        hand.add(five)
        hand.add(eight)

        expect(hand.value).to be(13)
      end
    end

    context "when receiving face cards" do
      it "calculates their total value" do
        hand.add(king)
        hand.add(eight)

        expect(hand.value).to be(18)
      end
    end

    context "when receiving an ace" do
      it "counts the ace as 11 when the total is under 21" do
        hand.add(ace)
        hand.add(eight)

        expect(hand.value).to be(19)
      end

      it "counts the ace as 1 when the total exceeds 21" do
        hand.add(ace)
        hand.add(eight)
        hand.add(eight)

        expect(hand.value).to be(17)
      end
    end

    context "when receiving multiple aces" do
      let(:second_ace) { Blackjack::Card.new("Ace", "diamonds", 11) }

      it "adjusts the value of aces to avoid exceeding 21" do
        hand.add(ace)
        hand.add(second_ace)
        hand.add(nine)

        expect(hand.value).to be(21)
      end
    end

    context "when the hand exceeds 21" do
      it "returns the total value of the cards" do
        hand.add(king)
        hand.add(queen)
        hand.add(five)

        expect(hand.value).to be(25)
      end
    end

    context "when receiving a natural blackjack" do
      it "has a value of 21" do
        hand.add(ace)
        hand.add(king)

        expect(hand.value).to be(21)
      end
    end
  end
end
