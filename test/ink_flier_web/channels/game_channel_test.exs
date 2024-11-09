defmodule InkFlierWeb.GameChannelTest do
  use InkFlierWeb.ChannelCase
  import TinyMaps
  alias InkFlier.LobbyServer

  @lobby_topic "lobby:main"

  setup do
    start_supervised!(InkFlier.GameSystem)
    :ok
  end


  describe "Join both lobby and game channels" do
    setup [:start_game, :join_lobby, :join_game]

    test "Broadcast goes to multiple topics (Game AND Lobby)", ~M{game_topic, game_socket} do
      push(game_socket, "join", %{}) |> assert_reply(:ok)
      %{topic: ^game_topic} = assert_broadcast("players_updated", _)
      %{topic: @lobby_topic} = assert_broadcast("game_updated", _)
    end
  end

  # test "game doesn't exist, redirect gracefully" do

  defp test_socket, do: socket(InkFlierWeb.UserSocket, "user_id", %{user: "Robin"})
  defp subscribe_test_to_channel(channel, topic), do: subscribe_and_join(test_socket(), channel, topic)

  defp start_game(_) do
    {:ok, game_id} = LobbyServer.start_game(creator: "BillyBob")
    game_topic = "game:" <> game_id
    ~M{game_id, game_topic}
  end

  defp join_lobby(_) do
    {:ok, _join_reply, _lobby_socket} = subscribe_test_to_channel(InkFlierWeb.LobbyChannel, @lobby_topic)
    :ok
  end

  defp join_game(~M{game_topic}) do
    {:ok, _join_reply, game_socket} = subscribe_test_to_channel(InkFlierWeb.GameChannel, game_topic)
    ~M{game_socket}
  end
end
