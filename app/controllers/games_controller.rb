class GamesController < ApplicationController
  def new
  end

  def create
    game = Blackjack::Game.new
    game.start

    save_game(game)

    redirect_to game_path
  end

  def show
    return redirect_to root_path unless session[:game]

    @game = load_game
  end

  def hit
    game = load_game
    game.hit

    save_game(game)

    redirect_to game_path
  end

  def stand
    game = load_game
    game.stand

    save_game(game)

    redirect_to game_path
  end

  private

  def save_game(game)
    session[:game] = Base64.strict_encode64(Marshal.dump(game))
  end

  def load_game
    Marshal.load(Base64.strict_decode64(session[:game]))
  end
end
