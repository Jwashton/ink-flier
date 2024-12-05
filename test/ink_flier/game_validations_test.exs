defmodule InkFlierTest.GameValidations do
  use ExUnit.Case

  alias InkFlier.Game

  test "add_player/2" do
    game        = Game.new
    {:ok, game} = Game.add_player(game, "James")
    reply       = Game.add_player(game, "James")

    assert reply == {:error, :player_already_in_game}
  end

  test "remove_player/2" do
    game        = Game.add_player!(Game.new, "James")
    {:ok, game} = Game.remove_player(game, "James")
    reply       = Game.remove_player(game, "James")

    assert reply == {:error, :no_such_player}
  end

  test "begin/1" do
    assert Game.new |> Game.begin == {:error, :requires_atleast_one_player}
  end
end
