defmodule InkFlierTest.LobbyServerAndGameServer do
  use ExUnit.Case

  alias InkFlier.LobbyServer
  alias InkFlier.GameServer
  alias Phoenix.PubSub

  @lobby __MODULE__.LobbyServer

  setup do
    start_supervised!({LobbyServer, name: @lobby})

    PubSub.subscribe(InkFlier.PubSub, LobbyServer.topic)
    :ok
  end

  test "Lobby sends a pubsub notification when games add player" do
    {:ok, game_id} = LobbyServer.start_game(@lobby, [])
    :ok = GameServer.join(game_id, "Robin")
    assert_received {:player_joined, _game_id, "Robin"}
  end
end
