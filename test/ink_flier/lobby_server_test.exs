defmodule InkFlierTest.LobbyServer do
  use ExUnit.Case

  alias InkFlier.LobbyServer
  alias InkFlier.GameSupervisor
  alias InkFlier.GameServer

  @lobby TestLobbyServer
  @game_starter TestGameSupervisor

  setup do
    start_supervised!({GameSupervisor, name: @game_starter})
    start_supervised!({LobbyServer, name: @lobby, game_supervisor: @game_starter})
    :ok
  end


  test "Keeps track of started games" do
    {:ok, game_id1} = LobbyServer.start_game(@lobby, [])
    {:ok, game_id2} = LobbyServer.start_game(@lobby, creator: "Bob")
    assert LobbyServer.games(@lobby) == [game_id1, game_id2]
  end

  test "Get data from running games by their game_id" do
    {:ok, game_id} = LobbyServer.start_game(@lobby, creator: "Bob")
    assert GameServer.creator(game_id) == "Bob"
  end

  test "List all games and their starting_info" do
    {:ok, game_id1} = LobbyServer.start_game(@lobby, [])
    {:ok, game_id2} = LobbyServer.start_game(@lobby, creator: "Bob")

    assert [{^game_id1, info1}, {^game_id2, info2}] = LobbyServer.games_info(@lobby)
    assert %{creator: nil} = info1
    assert %{creator: "Bob"} = info2
  end
end
