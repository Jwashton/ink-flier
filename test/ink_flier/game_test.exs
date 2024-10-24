defmodule InkFlierTest.Game do
  use ExUnit.Case

  alias InkFlier.Game

  test "Player can join a game" do
    creator = "Batman"
    game =
      creator
      |> Game.new
      |> Game.add_player!("James")
      |> Game.add_player!("Batman")
    assert game |> Game.players == ["James", "Batman"]
  end

  test "Same player can't join twice" do
    game = Game.new("Creator")
    {:ok, game} = Game.add_player(game, "James")
    {:ok, game} = Game.add_player(game, "Batman")
    assert {:error, :player_already_in_game} == Game.add_player(game, "James")
  end

  test "remove_player!/2" do
    game =
      Game.new("Creator")
      |> Game.add_player!("James")
      |> Game.add_player!("Batman")
      |> Game.remove_player!("James")
    assert game |> Game.players == ["Batman"]
  end

  test "remove_player/2" do
    game =
      Game.new("Creator")
      |> Game.add_player!("James")
      |> Game.add_player!("Batman")

    {:ok, game} = Game.remove_player(game, "James")
    assert game |> Game.players == ["Batman"]

    {:error, :no_such_player_to_remove} = Game.remove_player(game, "James")
  end
end
