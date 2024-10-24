defmodule InkFlierTest.LobbyServer do
  use ExUnit.Case
  import TinyMaps

  alias InkFlier.LobbyServer
  alias InkFlier.GameSupervisor
  alias InkFlier.GameServer

  @lobby_name TestLobby
  @supervisor_name TestGameSupervisor


  test "Confirm server starts in application" do
    # DON'T call with Testlobby name, we're checking if global application LobbyServer started here
    assert LobbyServer.games == %{}
  end

  describe "Restart server between tests" do
    setup [:restart_server]

    test "Add game" do
      {:ok, game_id1} = LobbyServer.add_game(@lobby_name, :fake_game1)
      {:ok, game_id2} = LobbyServer.add_game(@lobby_name, :fake_game2)
      games = LobbyServer.games(@lobby_name)

      assert games[game_id1] == :fake_game1
      assert games[game_id2] == :fake_game2
    end

    test "Confirm tests don't bleed" do
      assert LobbyServer.games(@lobby_name) == %{}
    end

    # test "TODO" do
    #   game =
    #     Game.new("Batman")
    #     |> Game.add_player("Robin")
    #   raise "Not quite. Maybe just make Game into a server right now, then make Lobby into a Supervisor / Register, THEN test for Game.add_player does a send_info or whatever notify to Lobby?"

    #   :ok = LobbyServer.add_game(@lobby_name, game)
    # end
  end

  describe "Supervised Game Starting" do
    # setup [:game_supervisor]

    # test "Start a supervised Game process" do
    #     # TODO add_game should prob turn into create_game to do these together?


    #   {:ok, game_id} = LobbyServer.create_game(@lobby_name, %{creator: "Batman"})
    #   assert GameServer.creator(game_id) == "Batman"
    # end
  end


  # Application auto-starts this Server. Let's manually restart a non-application one
  # between each test so they don't "bleed" into eachother
  defp restart_server(_) do
    {:ok, _pid} = LobbyServer.start_link(name: @lobby_name)
    :ok
  end

  # TODO these 2 can be merged into 1, I think LobbyServer needs to know if it's manually starting
  # a non-Application-started version of GameSupervisor when IT (Lobbyserver) starts anyways
  defp game_supervisor(_) do
    {:ok, _pid} = LobbyServer.start_link(name: @lobby_name, game_supervisor_name: @supervisor_name)
    :ok
  end
end
