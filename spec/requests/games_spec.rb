
require "rails_helper"

RSpec.describe "Games", type: :request do
  let(:ace) { Blackjack::Card.new("Ace", "spades", 11) }
  let(:king) { Blackjack::Card.new("King", "hearts", 10) }
  let(:nine) { Blackjack::Card.new(9, "diamonds", 9) }
  let(:eight) { Blackjack::Card.new(8, "clubs", 8) }
  let(:seven) { Blackjack::Card.new(7, "diamonds", 7) }
  let(:six) { Blackjack::Card.new(6, "hearts", 6) }
  let(:five) { Blackjack::Card.new(5, "spades", 5) }
  let(:two) { Blackjack::Card.new(2, "hearts", 2) }

  describe "GET /" do
    context "when visiting the homepage" do
      it "displays the new game page" do
        get root_path

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Blackjack")
        expect(response.body).to include("New Game")
      end
    end
  end

  describe "POST /game" do
    context "when starting a new game" do
      it "redirects to the game page" do
        post game_path

        expect(response).to redirect_to(game_path)
      end

      it "creates and displays a new game" do
        post game_path
        follow_redirect!

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Dealer")
        expect(response.body).to include("Your Hand")
      end
    end

    context "when starting a new game after an existing game" do
      let(:first_deck) do
        Blackjack::Deck.new(cards: [two, seven, eight, king, five])
      end

      let(:second_deck) do
        Blackjack::Deck.new(cards: [two, seven, nine, king, eight])
      end

      before do
        allow(Blackjack::Deck).to receive(:new)
          .and_return(first_deck, second_deck)
      end

      it "replaces the previous game with a new one" do
        post game_path
        follow_redirect!

        expect(response.body).to include("Your score: 13")

        post game_path
        follow_redirect!

        expect(response.body).to include("Your score: 17")
        expect(response.body).not_to include("Your score: 13")
      end
    end
  end

  describe "GET /game" do
    context "when no game exists" do
      it "redirects to the homepage" do
        get game_path

        expect(response).to redirect_to(root_path)
      end
    end

    context "when a game exists" do
      before do
        post game_path
      end

      it "displays the existing game" do
        get game_path

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Your Hand")
      end

      it "preserves the game between requests" do
        get game_path
        first_response = response.body

        get game_path

        expect(response.body).to eq(first_response)
      end
    end
  end

  describe "POST /game/hit" do
    let(:deck) do
      Blackjack::Deck.new(cards: [two, seven, eight, king, five])
    end

    before do
      allow(Blackjack::Deck).to receive(:new).and_return(deck)
      post game_path
    end

    context "when the game is active" do
      it "redirects back to the game" do
        post hit_game_path

        expect(response).to redirect_to(game_path)
      end
    end

    context "when the player hits without busting" do
      it "adds another card to the player's hand" do
        get game_path
        expect(response.body).to include("Your score: 13")

        post hit_game_path
        follow_redirect!

        expect(response.body).to include("Your score: 15")
        expect(response.body).to include("2 of hearts")
      end

      it "preserves the updated hand between requests" do
        post hit_game_path

        get game_path
        expect(response.body).to include("Your score: 15")

        get game_path
        expect(response.body).to include("Your score: 15")
      end

      it "keeps the game active" do
        post hit_game_path
        follow_redirect!

        expect(response.body).to include(">Hit</button>")
        expect(response.body).to include(">Stand</button>")
      end
    end
  end

  describe "POST /game/stand" do
    let(:deck) do
      Blackjack::Deck.new(cards: [five, seven, king, six, eight])
    end

    before do
      allow(Blackjack::Deck).to receive(:new).and_return(deck)
      post game_path
    end

    context "when the player stands" do
      it "finishes the round and displays the result" do
        post stand_game_path
        follow_redirect!

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Result:")
        expect(response.body).to include("Push")
      end

      it "reveals the dealer's hidden card" do
        post stand_game_path
        follow_redirect!

        expect(response.body).not_to include("[Hidden Card]")
        expect(response.body).to include("7 of diamonds")
        expect(response.body).to include("5 of spades")
      end

      it "removes hit and stand buttons when finished" do
        post stand_game_path
        follow_redirect!

        expect(response.body).not_to include(">Hit</button>")
        expect(response.body).not_to include(">Stand</button>")
      end
    end
  end

  describe "player bust" do
    let(:deck) do
      Blackjack::Deck.new(cards: [five, seven, eight, king, king])
    end

    before do
      allow(Blackjack::Deck).to receive(:new).and_return(deck)
      post game_path
    end

    context "when the player hits and exceeds 21" do
      it "ends the game and declares the dealer the winner" do
        post hit_game_path
        follow_redirect!

        expect(response.body).to include("Your score: 23")
        expect(response.body).to include("Dealer wins")
        expect(response.body).not_to include(">Hit</button>")
        expect(response.body).not_to include(">Stand</button>")
      end
    end
  end

  describe "natural blackjack" do
    let(:deck) do
      Blackjack::Deck.new(cards: [nine, king, eight, ace])
    end

    before do
      allow(Blackjack::Deck).to receive(:new).and_return(deck)
      post game_path
    end

    context "when the player is dealt blackjack" do
      it "immediately displays the winning result" do
        follow_redirect!

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Your score: 21")
        expect(response.body).to include("Result:")
        expect(response.body).to include("Player wins")
      end

      it "does not display hit or stand buttons" do
        follow_redirect!

        expect(response.body).not_to include(">Hit</button>")
        expect(response.body).not_to include(">Stand</button>")
      end
    end
  end
end
