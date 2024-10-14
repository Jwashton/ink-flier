defmodule InkFlierWeb.RoomChannel do
  use InkFlierWeb, :channel
  import TinyMaps

  alias InkFlier.Game
  alias InkFlier.LobbyServer

  @impl true
  def join("room:lobby", payload, socket) do
    if authorized?(payload) do
      games =
        LobbyServer.games
        |> Enum.sort_by(&elem(&1, 0), :desc)
        |> Enum.map(fn {id, game} ->
          %{id: id, creator: Game.creator(game)}
        end)

      {:ok, games, socket}
      # {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  @impl true
  def handle_in("create_game", _track_id, socket) do
    user = socket.assigns.user
    game = Game.new(user)
    {:ok, game_id} = LobbyServer.add_game(game)

    broadcast(socket, "game_created", ~M{game_id, user})
    {:reply, :ok, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (room:lobby).
  @impl true
  def handle_in("shout", payload, socket) do
    broadcast(socket, "shout", payload)
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
