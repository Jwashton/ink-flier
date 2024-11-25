defmodule InkFlierTest.Lobby do
  use ExUnit.Case

  alias InkFlier.Lobby
  alias InkFlier.GameServer

  setup do
    start_supervised!(InkFlier.GameSystem)
    :ok
  end


  test "games" do
    {:ok, game_id1} = Lobby.start_game([])
    {:ok, game_id2} = Lobby.start_game(creator: "Bob")
    assert Lobby.games == [game_id1, game_id2]
  end

  test "Can retrieve data from games by using their game_id" do
    {:ok, game_id} = Lobby.start_game(creator: "Bob")
    assert GameServer.creator(game_id) == "Bob"
  end

  test "games_info" do
    {:ok, game_id1} = Lobby.start_game([])
    {:ok, game_id2} = Lobby.start_game(creator: "Bob")

    assert [info1, info2] = Lobby.games_info
    assert %{name: ^game_id1, creator: nil} = info1
    assert %{name: ^game_id2, creator: "Bob"} = info2
  end

  test "delete_game" do
    {:ok, game_id1} = Lobby.start_game([])
    {:ok, game_id2} = Lobby.start_game(creator: "Bob")

    :ok = Lobby.delete_game(game_id1)
    assert Lobby.games == [game_id2]

    assert GameServer.whereis(game_id2)
    refute GameServer.whereis(game_id1)
  end


  describe "Start & join game at same time " do
    test "Requires creator" do
      {:error, :set_creator_if_auto_joining} = Lobby.start_game([join: true])
    end

    test "Works if given correct opts" do
      {:ok, game_id} = Lobby.start_game([creator: "Batman", join: true])
      assert GameServer.players(game_id) == ["Batman"]
    end
  end
end
