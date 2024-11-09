defmodule InkFlierTest.LobbyServerApplicationStarted do
  use ExUnit.Case

  alias InkFlier.LobbyServer
  alias InkFlier.GameServer


  test "Application correctly starts LobbyServer (and his required GameSupervisor)" do
    Application.put_env(:ink_flier, :supervise_games, true)

    assert LobbyServer.games == []
    {:ok, game_id} = LobbyServer.start_game(creator: "Robin")
    assert GameServer.creator(game_id) == "Robin"
  end
end
