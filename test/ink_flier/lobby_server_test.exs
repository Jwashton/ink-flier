defmodule InkFlierTest.LobbyServer do
  use ExUnit.Case

  alias InkFlier.LobbyServer

  test "Confirm server starts in application" do
    assert LobbyServer.games == %{}
  end

  describe "Restart server between tests" do
    setup [:restart_server]

    test "Add game" do
      {:ok, game_id1} = LobbyServer.add_game(:fake_game1)
      {:ok, game_id2} = LobbyServer.add_game(:fake_game2)
      games = LobbyServer.games

      assert games[game_id1] == :fake_game1
      assert games[game_id2] == :fake_game2
    end

    test "Confirm tests don't bleed" do
      assert LobbyServer.games == %{}
    end
  end


  # Application auto-starts this Server. Let's manually restart it between each test
  # so they don't "bleed" into eachother
  defp restart_server(_) do
    LobbyServer.stop
    :timer.sleep(200)
    LobbyServer.start_link([])
    :ok
  end
end
