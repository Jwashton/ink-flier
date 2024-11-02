defmodule InkFlierWeb.LobbyGameChannel do
  use InkFlierWeb, :channel
  import TinyMaps

  alias InkFlier.GameServer
  alias InkFlierWeb.RoomChannel
  alias InkFlierWeb.Endpoint

  @impl Phoenix.Channel
  def join("lobby_game:" <> game_id, payload, socket) do
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
    broadcast_on_success(socket, &GameServer.join/2, "player_joined")
    {:reply, :ok, socket}
  end

  @impl Phoenix.Channel
  def handle_in("leave", _params, socket) do
    broadcast_on_success(socket, &GameServer.remove/2, "player_left")
    {:reply, :ok, socket}
  end


  defp broadcast_on_success(socket, server_command, success_msg) do
    ~M{user, game_id} = socket.assigns

    case server_command.(game_id, user) do
      :ok ->
        players = GameServer.players(game_id)

        game_wrapper =
          game_id
          |> GameServer.starting_info
          |> Map.put(:id, game_id)

        broadcast(socket, success_msg, ~M{players})
        Endpoint.broadcast(RoomChannel.main_topic, "game_updated", game_wrapper)

      _no_state_change -> nil
    end


  end

  defp authorized?(_payload) do
    true
  end
end
