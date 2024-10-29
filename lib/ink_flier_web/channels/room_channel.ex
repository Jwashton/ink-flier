defmodule InkFlierWeb.RoomChannel do
  use InkFlierWeb, :channel
  import TinyMaps

  alias InkFlier.LobbyServer

  @impl true
  def join("room:lobby", payload, socket) do
    if authorized?(payload) do
      games =
        LobbyServer.games_info
        |> Enum.reverse
        |> Enum.map(fn {id, game_info} ->
          %{id: id, creator: game_info.creator}
        end)

      {:ok, games, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  @impl true
  def handle_in("create_game", _track_id, socket) do
    user = socket.assigns.user
    {:ok, game_id} = LobbyServer.start_game(creator: user)
    game_wrapper = %{id: game_id, creator: user}

    broadcast(socket, "game_created", game_wrapper)
    {:reply, :ok, socket}
  end

  @impl true
  def handle_in("delete_game", game_id, socket) do
    :ok = LobbyServer.delete_game(game_id)
    broadcast(socket, "game_deleted", ~M{game_id})
    {:reply, :ok, socket}
  end


  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
