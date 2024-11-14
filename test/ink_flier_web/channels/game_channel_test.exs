defmodule InkFlierWeb.GameChannelTest do
  use InkFlierWeb.ChannelCase
  import TinyMaps

  import InkFlierWebTest.ChannelSetup, only: [start_game: 1, join_lobby_channel: 1]

  alias InkFlier.LobbyServer
  alias InkFlier.GameServer
  alias InkFlierWeb.LobbyChannel

  setup do
    start_supervised!(InkFlier.GameSystem)
    :ok
  end


  describe "Join game channel" do
    setup [:start_game, :join_game_channel]

    test "Receive an *endpoint* broadcast if game is deleted while viewing it's page", ~M{game_id} do
      :ok = LobbyServer.delete_game(game_id)
      assert_received %{event: "game_deleted"}
    end

    test "No broadcast for removing players that haven't joined", ~M{game_socket} do
      push!(game_socket, "leave")
      push!(game_socket, "leave", %{target: "badPlayer"})

      refute_broadcast("players_updated", _)
    end
  end


  describe "Join both channels (lobby and game)" do
    setup [:start_game, :join_lobby_channel, :join_game_channel]

    test "Broadcast goes to multiple topics (Game AND Lobby)", ~M{game_topic, game_socket} do
      lobby_topic = LobbyChannel.topic

      push!(game_socket, "join", %{})
      %{topic: ^game_topic} = assert_broadcast("players_updated", _)
      %{topic: ^lobby_topic} = assert_broadcast("game_updated", _)
    end
  end


  describe "Join game channel and add self to game" do
    setup [:start_game, :join_game_channel, :add_self_to_game]

    test "Player can add themselves to game", ~M{game_socket, game_id} do
      assert game_socket.assigns.user in GameServer.players(game_id)
    end

    test "Player can remove themselves from game", ~M{game_socket, game_id} do
      push!(game_socket, "leave", %{})
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
  end


  defp test_socket, do: socket(InkFlierWeb.UserSocket, "user_id", %{user: "Robin"})

  defp subscribe_test_to_channel(channel, topic), do: subscribe_and_join(test_socket(), channel, topic)



  defp join_game_channel(~M{game_topic}) do
    {:ok, _join_reply, game_socket} = subscribe_test_to_channel(InkFlierWeb.GameChannel, game_topic)
    ~M{game_socket}
  end

  defp add_self_to_game(~M{game_socket}) do
    push!(game_socket, "join")
    assert_broadcast("players_updated", _)
    :ok
  end
end
