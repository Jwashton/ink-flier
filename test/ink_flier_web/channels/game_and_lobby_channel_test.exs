defmodule InkFlierWebTest.GameAndLobbyChannel do
  use InkFlierWeb.ChannelCase
  import TinyMaps
  import InkFlierWebTest.ChannelSetup, only: [start_game: 1, join_lobby_channel: 1, join_game_channel: 1]

  alias InkFlierWeb.LobbyChannel

  setup do
    start_supervised!(InkFlier.GameSystem)
    :ok
  end

  describe "Join both channels (lobby and game)" do
    setup [:start_game, :join_lobby_channel, :join_game_channel]

    test "When player joins game, a broadcast goes to multiple topics (Game AND Lobby)", ~M{game_topic, game_socket} do
      lobby_topic = LobbyChannel.topic

      push!(game_socket, "join", %{})
      %{topic: ^game_topic} = assert_broadcast("players_updated", _)
      %{topic: ^lobby_topic} = assert_broadcast("game_updated", _)
    end
  end
end
