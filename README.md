# Blackjack

A single player Blackjack web app built with Ruby on Rails. The player will compete against a dealer, aiming to get as close to 21 as possible without going over.

## Features

- Standard 52 card deck, which is shuffled at the start of each game.
- Cards are dealt alternately between player and dealer, one after another.
- Player actions: Hit (draw a card) and Stand (no more cards)
- **Important**: Dealer automatically draws until reaching 17 or higher. Dealer never hits on 17.
- Ace values will adjust between 1 and 11 to produce the best valid hand.
- Detection of natural and immediate Blackjack, busts, wins, losses, and pushes.
- Dealer's hole card remains hidden until the round finishes.
- Ability to start a new game after completing a round.
- The game state persists across HTTP requests using Rails sessions.

## Getting Started

### Prerequisites

- Ruby 3.3.2
- Rails 8.0.5.1
- Bundler

### Installation

Clone/pull down the repo and install dependencies:

```bash
git clone <repository-url>
cd <repository-name>
bundle install
```

Start the Rails server:

```bash
bin/rails server
```

Open http://localhost:3000 in browser to play.

## Running Tests

The application uses RSpec.

Run all tests:

```bash
bundle exec rspec
```

Or run individual suites:

```bash
bundle exec rspec spec/models
bundle exec rspec spec/requests
```

Model specs cover card values, deck behavior, hand scoring, player actions, dealer behavior, and win conditions.

Request specs cover Rails routes, gameplay interactions, and state persistence across HTTP requests.

## Architecture

The game logic is built using plain Ruby classes, independent of Rails controllers.

- **Blackjack::Card** — Represents a playing card and its value.
- **Blackjack::Deck** — Builds, shuffles, and deals cards.
- **Blackjack::Hand** — Manages cards and calculates scores, including flexible Ace values.
- **Blackjack::Game** — Coordinates gameplay, player actions, dealer behavior, and outcomes.
- **GamesController** — Handles HTTP requests and connects the web interface to the game.

### State Management

The app uses Rails sessions to maintain a single game per browser session.

The game logic itself is written with plain Ruby classes in a `Blackjack::` domain, allowing for multiple card games once the user reaches the browser session

The game is serialized using Ruby's `Marshal` and stored as a Base64-encoded string in the session. On subsequent requests and browser reloads, the controller restores the game, applies the player's action, and saves the updated state.

This keeps persistence simple for a small, single-player demonstration without introducing unnecessary database models. 

For a production application, JSON-based serialization or database-backed persistence would be preferable to `Marshal`.

### Testing Approach

The game also supports injecting a predefined deck, allowing tests to control the order of cards dealt. Obviously this won't affect actual gameplay (would be cheating) but makes it possible to reliably test specific scenarios such as busts, natural Blackjack, and dealer behavior without depending on randomized draws. 

The core game logic is tested independently from the Rails request/controller flow.
