defmodule InkFlierTest.Lobby do
  use ExUnit.Case

  alias InkFlier.Lobby

  test "Create game" do
    game = :fake_game

    {lobby, game_id} =
      Lobby.new
      |> Lobby.create_game(game)

    assert Lobby.game(game_id) == game
  end
end
