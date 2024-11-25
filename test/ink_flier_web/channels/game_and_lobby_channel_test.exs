defmodule InkFlierWebTest.GameAndLobbyChannel do
  use InkFlierWeb.ChannelCase
  import TinyMaps
  import InkFlierWebTest.ChannelSetup, only: [start_game: 1, join_lobby_channel: 1, join_game_channel: 1]

  alias InkFlierWeb.LobbyChannel
  alias InkFlierWeb.GameChannel
  alias InkFlier.GameServer

  setup do
    start_supervised!(InkFlier.GameSystem)
    :ok
  end

  describe "Join both channels (lobby and game)" do
    setup do: %{lobby_topic: LobbyChannel.topic}
    setup [:start_game, :join_lobby_channel, :join_game_channel]

    test "When player joins game, a broadcast goes to multiple topics (Game AND Lobby)", ~M{game_topic, lobby_topic, game_socket} do
      push!(game_socket, "join")

      %{topic: ^game_topic} = assert_broadcast("players_updated", _)
      %{topic: ^lobby_topic} = assert_broadcast("game_updated", _)
    end

    test "GameChannel.player_join/2", ~M{game_topic, lobby_topic, game_id} do
      :ok = GameChannel.player_join(game_id, "Bran")

      %{topic: ^game_topic} = assert_broadcast("players_updated", players_reply)
      %{topic: ^lobby_topic} = assert_broadcast("game_updated", game_reply)

      assert %{name: ^game_id} = game_reply
      assert %{players: ["Bran"]} = players_reply
      assert GameServer.players(game_id) == ["Bran"]
    end
  end
end
