defmodule InkFlierTest.LobbyServer do
  use ExUnit.Case

  alias InkFlier.LobbyServer

  test "Confirm server starts in application" do
    # DON'T call with Testlobby name, we're checking if global application LobbyServer started here
    assert LobbyServer.games == %{}
  end

  describe "Restart server between tests" do
    setup [:restart_server]

    test "Add game" do
      {:ok, game_id1} = LobbyServer.add_game(TestLobby, :fake_game1)
      {:ok, game_id2} = LobbyServer.add_game(TestLobby, :fake_game2)
      games = LobbyServer.games(TestLobby)

      assert games[game_id1] == :fake_game1
      assert games[game_id2] == :fake_game2
    end

    test "Confirm tests don't bleed" do
      assert LobbyServer.games(TestLobby) == %{}
    end
  end


  # Application auto-starts this Server. Let's manually restart a non-application one
  # between each test so they don't "bleed" into eachother
  defp restart_server(_) do
    LobbyServer.start_link([name: TestLobby])
    :ok
  end
end
