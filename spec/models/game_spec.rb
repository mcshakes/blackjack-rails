require "rails_helper"

RSpec.describe Blackjack::Game do
  subject(:game) { described_class.new(deck: deck) }

  let(:ace) { Blackjack::Card.new("Ace", "spades", 11) }
  let(:king) { Blackjack::Card.new("King", "hearts", 10) }
  let(:eight) { Blackjack::Card.new(8, "clubs", 8) }
  let(:seven) { Blackjack::Card.new(7, "diamonds", 7) }

  let(:deck) do
    Blackjack::Deck.new(cards: [seven, eight, king, ace])
  end

  describe "#initialize" do
    context "when creating a new game" do
      it "has a deck" do
        expect(game.deck).to eq(deck)
      end

      it "creates an empty player hand" do
        expect(game.player_hand.cards).to be_empty
      end

      it "creates an empty dealer hand" do
        expect(game.dealer_hand.cards).to be_empty
      end

      it "has not started yet" do
        expect(game.status).to eq(:not_started)
      end
    end
  end

  describe "#start" do
    context "when starting a new game" do
      before do
        game.start
      end

      it "deals two cards to the player" do
        expect(game.player_hand.cards.length).to be(2)
      end

      it "deals two cards to the dealer" do
        expect(game.dealer_hand.cards.length).to be(2)
      end

      it "deals cards in alternating order" do
        expect(game.player_hand.cards).to eq([ace, eight])
        expect(game.dealer_hand.cards).to eq([king, seven])
      end

      it "removes four cards from the deck" do
        expect(game.deck.cards.length).to be(0)
      end

      it "changes the game status to playing" do
        expect(game.status).to eq(:playing)
      end
    end
  end

  describe "#hit" do
    let(:king) { Blackjack::Card.new("King", "hearts", 10) }
    let(:eight) { Blackjack::Card.new(8, "clubs", 8) }
    let(:seven) { Blackjack::Card.new(7, "diamonds", 7) }
    let(:five) { Blackjack::Card.new(5, "spades", 5) }
    let(:two) { Blackjack::Card.new(2, "hearts", 2) }

    context "when the player hits and does not bust" do
      let(:deck) do
        Blackjack::Deck.new(cards: [two, seven, eight, king, five])
      end

      before do
        game.start
      end

      it "adds one card to the player's hand" do
        game.hit

        expect(game.player_hand.cards.length).to be(3)
      end

      it "deals the next available card" do
        game.hit

        expect(game.player_hand.cards.last).to eq(two)
      end

      it "does not change the dealer's hand" do
        game.hit

        expect(game.dealer_hand.cards.length).to be(2)
      end

      it "keeps the game in a playing state" do
        game.hit

        expect(game.status).to eq(:playing)
      end
    end

    context "when the player hits and busts" do
      let(:deck) do
        Blackjack::Deck.new(cards: [five, seven, eight, king, king])
      end

      before do
        game.start
      end

      it "recognizes that the player busted" do
        game.hit

        expect(game.player_hand.bust?).to be(true)
      end

      it "ends the game" do
        game.hit

        expect(game.status).to eq(:finished)
      end

      it "declares the dealer the winner" do
        game.hit

        expect(game.outcome).to eq(:dealer_wins)
      end
    end

    context "when the game has not started" do
      it "does not allow player to hit" do
        expect { game.hit }.to raise_error(StandardError)
      end
    end

    context "when the game has already finished" do
      let(:deck) do
        Blackjack::Deck.new(cards: [five, seven, eight, king, king])
      end

      before do
        game.start
        game.hit
      end

      it "does not allow the player to hit again" do
        expect { game.hit }.to raise_error(StandardError)
      end
    end
  end
end
