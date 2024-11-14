defmodule InkFlierWebTest.ChannelSetup do
  use InkFlierWeb.ChannelCase
  import TinyMaps

  alias InkFlier.LobbyServer
  alias InkFlierWeb.LobbyChannel
  alias InkFlierWeb.GameChannel

  def start_game(context) do
    {:ok, game_id} = LobbyServer.start_game(creator: user(context))
    game_topic = "game:" <> game_id

    ~M{game_id, game_topic}
  end

  def join_lobby_channel(context) do
    {:ok, lobby_join_reply, lobby_socket} = subscribe_test_to_channel(context, LobbyChannel, LobbyChannel.topic)
    ~M{lobby_join_reply, lobby_socket}
  end

  def join_game_channel(context) do
    ~M{game_topic} = context

    {:ok, _game_join_reply, game_socket} = subscribe_test_to_channel(context, GameChannel, game_topic)
    ~M{game_socket}
  end


  defp subscribe_test_to_channel(context, channel, topic) do
    context
    |> user
    |> test_socket
    |> subscribe_and_join(channel, topic)
  end

  defp user(context), do: context[:user] || "Billy"
  defp test_socket(user), do: socket(InkFlierWeb.UserSocket, "user_id", ~M{user})
end
