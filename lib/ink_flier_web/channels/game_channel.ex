defmodule InkFlierWeb.GameChannel do
  use InkFlierWeb, :channel
  import TinyMaps

  alias InkFlier.GameServer
  alias InkFlierWeb.LobbyChannel
  alias InkFlierWeb.Endpoint

  def topic(game_id), do: "game:" <> to_string(game_id)

  def notify_game_deleted(game_id), do: :ok = Endpoint.broadcast(topic(game_id), "game_deleted", %{})

  def player_join(game_id, player) do
    if GameServer.join(game_id, player), do: broadcast_players_updated(game_id)
  end

  def player_leave(game_id, player) do
    if GameServer.remove(game_id, player), do: broadcast_players_updated(game_id)
  end


  @impl Phoenix.Channel
  def join("game:" <> game_id, payload, socket) do
    if authorized?(payload) do
      socket = assign(socket, game_id: game_id)

      {:ok, %{players: GameServer.players(game_id)}, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  @impl Phoenix.Channel
  def handle_in("join", _params, socket) do
    player_join(socket.assigns.game_id, socket.assigns.user)
    {:reply, :ok, socket}
  end

  @impl Phoenix.Channel
  def handle_in("leave", ~m{target}, socket) do
    player_leave(socket.assigns.game_id, target)
    {:reply, :ok, socket}
  end

  @impl Phoenix.Channel
  def handle_in("leave", _params, socket) do
    player_leave(socket.assigns.game_id, socket.assigns.user)
    {:reply, :ok, socket}
  end


  defp broadcast_players_updated(game_id) do
    :ok = Endpoint.broadcast(topic(game_id), "players_updated", %{players: GameServer.players(game_id)})
    :ok = LobbyChannel.notify_game_updated(game_id)
  end

  defp authorized?(_payload), do: true
end
