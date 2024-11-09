defmodule InkFlierWeb.GameChannel do
  use InkFlierWeb, :channel
  import TinyMaps

  alias InkFlier.GameServer
  alias InkFlierWeb.LobbyChannel

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
    broadcast_on_success(socket, &GameServer.join/2)
    {:reply, :ok, socket}
  end

  @impl Phoenix.Channel
  def handle_in("leave", _params, socket) do
    broadcast_on_success(socket, &GameServer.remove/2)
    {:reply, :ok, socket}
  end


  defp broadcast_on_success(socket, game_command) do
    ~M{user, game_id} = socket.assigns

    case game_command.(game_id, user) do
      :ok ->
        players = GameServer.players(game_id)

        broadcast(socket, "players_updated", ~M{players})
        LobbyChannel.game_updated(game_id)

      _no_state_change -> nil
    end
  end

  defp authorized?(_payload), do: true
end