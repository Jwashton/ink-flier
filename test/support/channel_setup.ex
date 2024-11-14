defmodule InkFlierWebTest.ChannelSetup do
  use InkFlierWeb.ChannelCase
  import TinyMaps

  alias InkFlier.LobbyServer
  alias InkFlierWeb.LobbyChannel
  alias InkFlierWeb.GameChannel

  def start_game(context) do
    creator = context[:game_creator] || "Billy"

    {:ok, game_id} = LobbyServer.start_game(creator: creator)
    game_topic = "game:" <> game_id

    ~M{game_id, game_topic}
  end

  def join_lobby_channel(_) do
    {:ok, lobby_join_reply, lobby_socket} = subscribe_test_to_channel(LobbyChannel, LobbyChannel.topic)
    ~M{lobby_join_reply, lobby_socket}
  end

  def join_game_channel(~M{game_topic}) do
    {:ok, _join_reply, game_socket} = subscribe_test_to_channel(GameChannel, game_topic)
    ~M{game_socket}
  end


  defp test_socket, do: socket(InkFlierWeb.UserSocket, "user_id", %{user: "Robin"})
  defp subscribe_test_to_channel(channel, topic), do: subscribe_and_join(test_socket(), channel, topic)
end
