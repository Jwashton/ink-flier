defmodule InkFlierWeb.LobbyChannelTest do
  use InkFlierWeb.ChannelCase
  import TinyMaps
  import InkFlierWebTest.ChannelSetup, only: [start_game: 1, join_lobby_channel: 1]

  alias InkFlier.Lobby
  alias InkFlier.GameServer

  setup do
    start_supervised!(InkFlier.GameSystem)
    :ok
  end


  describe "Join lobby channel" do
    setup do: %{user: "Robin"}
    setup [:join_lobby_channel]

    test "Push create_game to the lobby: creates a game & broadcasts the result", ~M{lobby_socket} do
      push!(lobby_socket, "create_game")

      assert Lobby.games_info |> length == 1
      assert_broadcast "game_created", %{creator: "Robin"}
    end

    test "Creating a game stores track number", ~M{lobby_socket} do
      push!(lobby_socket, "create_game", 22)

      assert_broadcast "game_created", ~M{name}
      assert %{track_id: 22} = GameServer.summary_info(name)
    end

    test "Create & join game at same time", ~M{lobby_socket} do
      push!(lobby_socket, "create_and_join_game")

      assert_broadcast "game_created", ~M{name}
      assert GameServer.summary_info(name).players == ["Robin"]
    end
  end


  describe "Start games then join lobby" do
    setup do: %{user: "Spiderman"}
    setup [:start_game, :join_lobby_channel]

    test "On joining the channel, should receive a list of started games", ~M{lobby_join_reply} do
      assert [game1 | []] = lobby_join_reply
      assert game1.creator == "Spiderman"
    end

    test "Push delete also works", ~M{lobby_socket, game_id} do
      push!(lobby_socket, "delete_game", game_id)

      assert Lobby.games_info |> length == 0
      assert_broadcast "game_deleted", %{game_id: ^game_id}
    end

    test "Join game can be done from lobby (don't need to be on game's channel/page)", ~M{lobby_socket, game_id} do
      push!(lobby_socket, "join_game", game_id)
      assert GameServer.summary_info(game_id).players == ["Spiderman"]
    end

    test "Leave game can also be done from lobby", ~M{lobby_socket, game_id} do
      :ok = GameServer.join(game_id, "Spiderman")
      push!(lobby_socket, "leave_game", game_id)

      assert GameServer.summary_info(game_id).players == []
    end
  end
end
