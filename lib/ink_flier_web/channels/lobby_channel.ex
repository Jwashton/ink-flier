defmodule InkFlierWeb.LobbyChannel do
  use InkFlierWeb, :channel
  import TinyMaps

  alias InkFlier.LobbyServer

  @main_topic "lobby:main"

  @impl Phoenix.Channel
  def join(@main_topic, payload, socket) do
    if authorized?(payload) do
      games =
        LobbyServer.games_info
        |> Enum.reverse
        |> Enum.map(fn {id, game_info} ->
          ~M{id, players: game_info.players, creator: game_info.creator}
        end)

      {:ok, games, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  @impl Phoenix.Channel
  def handle_in("create_game", _track_id, socket) do
    user = socket.assigns.user
    {:ok, game_id} = LobbyServer.start_game(creator: user)
    game_wrapper = %{id: game_id, creator: user, players: []}

    broadcast(socket, "game_created", game_wrapper)
    {:reply, :ok, socket}
  end

  @impl Phoenix.Channel
  def handle_in("delete_game", game_id, socket) do
    :ok = LobbyServer.delete_game(game_id)
    broadcast(socket, "game_deleted", ~M{game_id})
    {:reply, :ok, socket}
  end

  def main_topic, do: @main_topic


  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
