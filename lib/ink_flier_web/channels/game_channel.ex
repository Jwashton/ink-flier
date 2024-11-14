defmodule InkFlierWeb.GameChannel do
  use InkFlierWeb, :channel
  import TinyMaps

  alias InkFlier.GameServer
  alias InkFlierWeb.LobbyChannel
  alias InkFlierWeb.Endpoint

  def topic(game_id), do: "game:" <> game_id

  def notify_game_deleted(game_id), do: Endpoint.broadcast(topic(game_id), "game_deleted", %{})


  @impl Phoenix.Channel
  def join("game:" <> game_id, payload, socket) do
    if authorized?(payload) do
      socket = assign(socket, game_id: game_id)
      players = GameServer.players(game_id)

      {:ok, ~M{players}, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  @impl Phoenix.Channel
  def handle_in("join", _params, socket) do
    update_game_and_broadcast_on_success(socket, &GameServer.join/2, socket.assigns.user)
  end

  @impl Phoenix.Channel
  def handle_in("leave", ~m{target}, socket) do
    update_game_and_broadcast_on_success(socket, &GameServer.remove/2, target)
  end

  @impl Phoenix.Channel
  def handle_in("leave", _params, socket) do
    update_game_and_broadcast_on_success(socket, &GameServer.remove/2, socket.assigns.user)
  end


  defp update_game_and_broadcast_on_success(socket, add_or_remove_player, target) do
    ~M{game_id} = socket.assigns
    case add_or_remove_player.(game_id, target) do
      :ok ->
        broadcast(socket, "players_updated", %{players: GameServer.players(game_id)})
        LobbyChannel.notify_game_updated(game_id)

      _no_state_change -> nil
    end
    {:reply, :ok, socket}
  end

  defp authorized?(_payload), do: true
end
