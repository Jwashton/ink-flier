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
    ~M{user, game_id} = socket.assigns

    case GameServer.join(game_id, user) do
      :ok ->
        players = GameServer.players(game_id)

        game_wrapper =
          game_id
          |> GameServer.starting_info
          |> Map.put(:id, game_id)

        broadcast(socket, "player_joined", ~M{players})
        Endpoint.broadcast(RoomChannel.main_topic, "game_updated", game_wrapper)

      _no_state_change -> nil
    end

    {:reply, :ok, socket}
  end

  @impl Phoenix.Channel
  def handle_in("leave", params, socket) do
    target = Map.get(params, "target", socket.assigns.user)
    ~M{game_id} = socket.assigns

    broadcast_on_success(socket, game_id, target, &GameServer.remove/2, "player_left")
    {:reply, :ok, socket}
  end


  defp broadcast_on_success(socket, game_id, target, server_command, success_msg) do
    case server_command.(game_id, target) do
      :ok ->
        players = GameServer.players(game_id)

        # two broadcasts, one to this page's topic and another to different page's topic: Lobby (who
        # also wants to live-js-update the page on player-change)
        broadcast(socket, success_msg, ~M{players})
      _no_state_change -> nil
    end
  end

  defp authorized?(_payload) do
    true
  end
end
