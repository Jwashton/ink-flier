defmodule InkFlierTest.LobbyServerApplicationStarted do
  @moduledoc """
  Multiple tests here would "bleed together" as the application-started LobbyServer (and GameSupervisor)
  don't reset between tests

  Use `lobby_server_test.exs` to test ones that DO restart those processes between each test
  """
  use ExUnit.Case

  alias InkFlier.LobbyServer
  alias InkFlier.GameServer


  test "Confirm server starts in application" do
    assert LobbyServer.games == []
    {:ok, game_id} = LobbyServer.start_game(creator: "Robin")
    assert GameServer.creator(game_id) == "Robin"
  end
end
