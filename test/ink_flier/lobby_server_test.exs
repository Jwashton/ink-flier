defmodule InkFlierTest.LobbyServer do
  use ExUnit.Case

  alias InkFlier.LobbyServer
  alias InkFlier.GameServer

  @lobby __MODULE__.LobbyServer

  setup do
    # NOTE Aparently I don't need unique GameSupervisor for tests to not collide? I can just use
    # the Application-started one

    # start_supervised!({GameSupervisor, name: @game_starter})
    # start_supervised!({LobbyServer, name: @lobby, game_supervisor: @game_starter})
    start_supervised!({LobbyServer, name: @lobby})
    :ok
  end


  test "games" do
    {:ok, game_id1} = LobbyServer.start_game(@lobby, [])
    {:ok, game_id2} = LobbyServer.start_game(@lobby, creator: "Bob")
    assert LobbyServer.games(@lobby) == [game_id1, game_id2]
  end

  test "Can retrieve data from games by using their game_id" do
    {:ok, game_id} = LobbyServer.start_game(@lobby, creator: "Bob")
    assert GameServer.creator(game_id) == "Bob"
  end

  test "games_info" do
    {:ok, game_id1} = LobbyServer.start_game(@lobby, [])
    {:ok, game_id2} = LobbyServer.start_game(@lobby, creator: "Bob")

    assert [{^game_id1, info1}, {^game_id2, info2}] = LobbyServer.games_info(@lobby)
    assert %{creator: nil} = info1
    assert %{creator: "Bob"} = info2
  end

  test "delete_game" do
    {:ok, game_id1} = LobbyServer.start_game(@lobby, [])
    {:ok, game_id2} = LobbyServer.start_game(@lobby, creator: "Bob")

    :ok = LobbyServer.delete_game(@lobby, game_id1)
    assert LobbyServer.games(@lobby) == [game_id2]

    assert LobbyServer.whereis(game_id2)
    refute LobbyServer.whereis(game_id1)
  end
end
