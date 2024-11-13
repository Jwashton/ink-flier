defmodule InkFlierWeb.GameChannelTest do
  use InkFlierWeb.ChannelCase
  import TinyMaps
  alias InkFlier.LobbyServer
  alias InkFlier.GameServer

  @lobby_topic "lobby:main"

  setup do
    start_supervised!(InkFlier.GameSystem)
    :ok
  end


  describe "Join both lobby and game channels" do
    setup [:start_game, :join_lobby_channel, :join_game_channel]

    test "Broadcast goes to multiple topics (Game AND Lobby)", ~M{game_topic, game_socket} do
      push(game_socket, "join", %{}) |> assert_reply(:ok)
      %{topic: ^game_topic} = assert_broadcast("players_updated", _)
      %{topic: @lobby_topic} = assert_broadcast("game_updated", _)
    end
  end

  describe "Start game page" do
    setup [:start_game, :join_game_channel]

    test "If game is deleted while viewing it's page, receive an endpoint broadcast", ~M{game_id} do
      # NOTE Different from a handle_in or handle_info, Endpoint.broadcast goes straight to js
      # unless intercepted by channel's handle_out
      :ok = LobbyServer.delete_game(game_id)
      assert_received %{event: "game_deleted"}
    end
  end

  # describe "Join game channel and add self to game" do
  describe "TODO" do
    # setup [:start_game, :join_game_channel, :add_self_to_game]
    setup [:start_game, :join_game_channel]

    test "Player can remove themselves from game", ~M{game_socket, game_id} do
      push(game_socket, "join") |> assert_reply(:ok)
      assert game_socket.assigns.user in GameServer.players(game_id)
      assert_broadcast("players_updated", _)
    end

    # test "Player can remove other target from game" do
    #   push(game_socket, "join") |> assert_reply(:ok)

    #   push(game_socket, "leave", %{}) |> assert_reply(:ok)
    #   refute game_socket.assigns.user in GameServer.players(game_id)
    #   assert_broadcast("players_updated", _)
    # end
  end



  defp test_socket, do: socket(InkFlierWeb.UserSocket, "user_id", %{user: "Robin"})
  defp subscribe_test_to_channel(channel, topic), do: subscribe_and_join(test_socket(), channel, topic)

  defp start_game(_) do
    {:ok, game_id} = LobbyServer.start_game(creator: "BillyBob")
    game_topic = "game:" <> game_id
    ~M{game_id, game_topic}
  end

  defp join_lobby_channel(_) do
    {:ok, _join_reply, _lobby_socket} = subscribe_test_to_channel(InkFlierWeb.LobbyChannel, @lobby_topic)
    :ok
  end

  defp join_game_channel(~M{game_topic}) do
    {:ok, _join_reply, game_socket} = subscribe_test_to_channel(InkFlierWeb.GameChannel, game_topic)
    ~M{game_socket}
  end
end
