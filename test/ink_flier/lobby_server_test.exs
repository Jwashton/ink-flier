defmodule InkFlierTest.LobbyServer do
  use ExUnit.Case

  alias InkFlier.LobbyServer
  alias InkFlier.GameServer

  setup do
    start_supervised!(InkFlier.GameSystem)
    :ok
  end


  test "games" do
    {:ok, game_id1} = LobbyServer.start_game([])
    {:ok, game_id2} = LobbyServer.start_game(creator: "Bob")
    assert LobbyServer.games == [game_id1, game_id2]
  end

  test "Can retrieve data from games by using their game_id" do
    {:ok, game_id} = LobbyServer.start_game(creator: "Bob")
    assert GameServer.creator(game_id) == "Bob"
  end

  test "games_info" do
    {:ok, game_id1} = LobbyServer.start_game([])
    {:ok, game_id2} = LobbyServer.start_game(creator: "Bob")

    assert [info1, info2] = LobbyServer.games_info
    assert %{name: ^game_id1, creator: nil} = info1
    assert %{name: ^game_id2, creator: "Bob"} = info2
  end

  test "delete_game" do
    {:ok, game_id1} = LobbyServer.start_game([])
    {:ok, game_id2} = LobbyServer.start_game(creator: "Bob")

    :ok = LobbyServer.delete_game(game_id1)
    assert LobbyServer.games == [game_id2]

    assert GameServer.whereis(game_id2)
    refute GameServer.whereis(game_id1)
  end
end
