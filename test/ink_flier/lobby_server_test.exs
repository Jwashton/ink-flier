defmodule InkFlierTest.LobbyServer do
  use ExUnit.Case

  alias InkFlier.LobbyServer
  alias InkFlier.GameServer

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

    # test "Start a supervised Game process" do
    #   # TODO add_game should prob turn into create_game to do these together?

    #   {:ok, game_id} = LobbyServer.create_game(TestLobby, "CreatorBatman")
    #   assert GameServer.creator(game_id) == "CreatorBatman"
    # end

    # test "TODO" do
    #   game =
    #     Game.new("Batman")
    #     |> Game.add_player("Robin")
    #   raise "Not quite. Maybe just make Game into a server right now, then make Lobby into a Supervisor / Register, THEN test for Game.add_player does a send_info or whatever notify to Lobby?"

    #   :ok = LobbyServer.add_game(TestLobby, game)
    # end
  end


  # Application auto-starts this Server. Let's manually restart a non-application one
  # between each test so they don't "bleed" into eachother
  defp restart_server(_) do
    LobbyServer.start_link([name: TestLobby])
    :ok
  end
end
