defmodule InkFlierTest.LobbyServer do
  use ExUnit.Case

  alias InkFlier.LobbyServer

  test "Add game" do
    {:ok, game_id1} = LobbyServer.add_game(:fake_game1)
    {:ok, game_id2} = LobbyServer.add_game(:fake_game2)
    games = LobbyServer.games

    assert games[game_id1] == :fake_game1
    assert games[game_id2] == :fake_game2
  end
end
