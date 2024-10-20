defmodule InkFlierTest.Game do
  use ExUnit.Case

  alias InkFlier.Game

  test "Player can join a game" do
    creator = "Batman"
    game =
      creator
      |> Game.new
      |> Game.add_player("James")
      |> Game.add_player("Batman")
    assert game |> Game.players == ["James", "Batman"]
  end
end
