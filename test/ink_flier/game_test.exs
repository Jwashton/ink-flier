defmodule InkFlierTest.Game do
  use ExUnit.Case

  alias InkFlier.Game

  test "Player can join a game" do
    creator = "Batman"
    game = Game.new(creator)
    {:ok, game} = Game.add_player(game, "James")
    {:ok, game} = Game.add_player(game, "Batman")
    assert game |> Game.players == ["James", "Batman"]
  end
end
