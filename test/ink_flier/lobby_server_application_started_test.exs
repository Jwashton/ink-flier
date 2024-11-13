defmodule InkFlierTest.LobbyServerApplicationStarted do
  @moduledoc """
  Special task to run these: `mix test.integration`
  """
  use ExUnit.Case

  alias InkFlier.LobbyServer
  alias InkFlier.GameServer

  @tag integration: true
  test "Application correctly starts LobbyServer (and his required GameSupervisor)" do
    assert LobbyServer.games == []
    {:ok, game_id} = LobbyServer.start_game(creator: "Robin")
    assert GameServer.creator(game_id) == "Robin"
  end
end
