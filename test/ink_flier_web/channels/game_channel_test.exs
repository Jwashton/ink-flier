defmodule InkFlierWeb.GameChannelTest do
  use InkFlierWeb.ChannelCase
  import TinyMaps
  import InkFlierWebTest.ChannelSetup, only: [start_game: 1, join_game_channel: 1]

  alias InkFlier.Lobby
  alias InkFlier.GameServer

  setup do
    start_supervised!(InkFlier.GameSystem)
    :ok
  end


  describe "Join game channel" do
    setup [:start_game, :join_game_channel]

    test "Receive an *endpoint* broadcast if game is deleted while viewing it's page", ~M{game_id} do
      :ok = Lobby.delete_game(game_id)
      assert_received %{event: "game_deleted"}
    end

    test "No broadcast for removing players that haven't joined", ~M{game_socket} do
      push!(game_socket, "leave")
      push!(game_socket, "leave", %{target: "badPlayer"})

      refute_broadcast("players_updated", _)
    end

    @tag :skip
    test "Invalid start game replies (not broadcasts) error messages", ~M{game_socket, game_id} do
      ref = push(game_socket, "start")

      assert GameServer.summary_info(game_id).phase == :adding_players
      refute_broadcast("game_started", _)

      assert_reply(ref, :error, {:todoErrorMsgShape, :requires_atleast_one_player})
    end
  end


  describe "Join game channel and add self to game" do
    setup [:start_game, :join_game_channel, :add_self_to_game]

    test "Player can add themselves to game", ~M{game_socket, game_id} do
      assert game_socket.assigns.user in GameServer.players(game_id)
    end

    test "Player can remove themselves from game", ~M{game_socket, game_id} do
      push!(game_socket, "leave")
      assert_broadcast("players_updated", _)

      refute game_socket.assigns.user in GameServer.players(game_id)
    end

    test "Player can remove *other* target from game", ~M{game_socket, game_id} do
      :ok = GameServer.join(game_id, "Betsy")

      push!(game_socket, "leave", %{target: "Betsy"})
      assert_broadcast("players_updated", _)

      assert game_socket.assigns.user in GameServer.players(game_id)
      refute "Betsy" in GameServer.players(game_id)
    end

    test "Start game", ~M{game_socket, game_id} do
      push!(game_socket, "start")
      assert GameServer.summary_info(game_id).phase == :started
      assert_broadcast("game_started", _)
    end
  end


  defp add_self_to_game(~M{game_socket}) do
    push!(game_socket, "join")
    assert_broadcast("players_updated", _)
    :ok
  end
end
