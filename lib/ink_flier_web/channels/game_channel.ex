defmodule InkFlierWeb.GameChannel do
  use InkFlierWeb, :channel
  import TinyMaps

  alias Phoenix.Channel
  alias InkFlier.GameServer
  alias InkFlierWeb.LobbyChannel
  alias InkFlierWeb.Endpoint

  def notify_game_deleted(game_id), do: :ok = Endpoint.broadcast(topic(game_id), "game_deleted", %{})

  def player_join(game_id, player), do: broadcast_on_success(&GameServer.join/2, game_id, player)
  def player_leave(game_id, player), do: broadcast_on_success(&GameServer.remove/2, game_id, player)


  @impl Channel
  def join("game:" <> game_id, _payload, socket) do
    socket = assign(socket, game_id: game_id)
    {:ok, %{players: GameServer.players(game_id)}, socket}
  end

  @impl Channel
  def handle_in("join", _params, socket) do
    player_join(socket.assigns.game_id, socket.assigns.user)
    {:reply, :ok, socket}
  end

  @impl Channel
  def handle_in("leave", ~m{target}, socket) do
    player_leave(socket.assigns.game_id, target)
    {:reply, :ok, socket}
  end

  @impl Channel
  def handle_in("leave", _params, socket) do
    player_leave(socket.assigns.game_id, socket.assigns.user)
    {:reply, :ok, socket}
  end

  # @impl Channel
  # def handle_in("start"), _, socket) do
  # end


  defp broadcast_on_success(add_or_remove_player, game_id, player) do
    if add_or_remove_player.(game_id, player) == :ok, do: broadcast_players_updated(game_id)
  end

  defp broadcast_players_updated(game_id) do
    :ok = Endpoint.broadcast(topic(game_id), "players_updated", %{players: GameServer.players(game_id)})
    :ok = LobbyChannel.notify_game_updated(game_id)
  end

  defp topic(game_id), do: "game:" <> to_string(game_id)
end
