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
    ~M{game_id} = socket.assigns
    target = socket.assigns.user

    game_id
    |> GameServer.join(target)
    |> broadcast_on_success(socket, game_id)

    {:reply, :ok, socket}
  end

  @impl Phoenix.Channel
  def handle_in("leave", params, socket) do
    ~M{game_id} = socket.assigns
    target = Map.get(params, "target", socket.assigns.user)

    game_id
    |> GameServer.remove(target)
    |> broadcast_on_success(socket, game_id)

  {:reply, :ok, socket}
  end

  defp broadcast_on_success(:ok, socket, game_id) do
    players = GameServer.players(game_id)
    broadcast(socket, "players_updated", ~M{players})
    LobbyChannel.notify_game_updated(game_id)
  end
  defp broadcast_on_success(_, _, _), do: nil

  defp authorized?(_payload), do: true
end
