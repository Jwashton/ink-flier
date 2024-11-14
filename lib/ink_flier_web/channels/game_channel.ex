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

      {:ok, %{players: GameServer.players(game_id)}, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  @impl Phoenix.Channel
  def handle_in("join", _params, socket), do: update_game_and_broadcast_on_success(socket, &GameServer.join/2)

  @impl Phoenix.Channel
  def handle_in("leave", ~m{target}, socket), do: update_game_and_broadcast_on_success(socket, &GameServer.remove/2, target)

  @impl Phoenix.Channel
  def handle_in("leave", _params, socket), do: update_game_and_broadcast_on_success(socket, &GameServer.remove/2)


  defp update_game_and_broadcast_on_success(socket, add_or_remove_player, target \\ nil) do
    target = target || socket.assigns.user
    game_id = socket.assigns.game_id

    game_id
    |> add_or_remove_player.(target)
    |> broadcast_on_success(game_id, socket)
    |> ok
  end


  defp broadcast_on_success(:ok, game_id, socket) do
    :ok = broadcast(socket, "players_updated", %{players: GameServer.players(game_id)})
    :ok = LobbyChannel.notify_game_updated(game_id)

    socket
  end
  defp broadcast_on_success(_, _, socket), do: socket


  defp ok(socket), do: {:reply, :ok, socket}
  defp authorized?(_payload), do: true
end
