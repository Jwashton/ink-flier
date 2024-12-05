defmodule InkFlierTest.ApplicationStarted do
  @moduledoc """
  Special task to run these: `mix test.integration`
  """
  use ExUnit.Case

  alias InkFlier.Lobby
  alias InkFlier.GameServer

  @tag integration: true
  test "Application correctly starts Lobby (and his required GameSupervisor)" do
    assert Lobby.games == []
    {:ok, game_id} = Lobby.start_game(creator: "Robin")
    assert GameServer.summary_info(game_id).creator == "Robin"
  end
end
