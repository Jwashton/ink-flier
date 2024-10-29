defmodule InkFlierTest.LobbyServerAndGameServer do
  use ExUnit.Case

  alias InkFlier.LobbyServer
  alias Phoenix.PubSub

  @lobby __MODULE__.LobbyServer
  @pub_sub __MODULE__.PubSub

  setup do
    start_supervised!({LobbyServer, name: @lobby})

    start_supervised!({Phoenix.PubSub, name: @pub_sub})
    PubSub.subscribe(@pub_sub, LobbyServer.topic)
    :ok
  end

  test "Lobby sends a pubsub notification when games add player" do
    # Process.info(self(), :messages)
    # |> dbg(charlists: :as_lists)

    # PubSub.broadcast(@pub_sub, LobbyServer.topic, {:user_update, %{id: 123, name: "Shane"}})

    # Process.info(self(), :messages)
    # |> dbg(charlists: :as_lists)
  end
end
