defmodule InkFlierWeb.LobbyGameChannel do
  use InkFlierWeb, :channel
  import TinyMaps

  alias InkFlier.GameServer

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
        broadcast(socket, "player_joined", ~M{players})

      _already_joined -> nil
    end

    {:reply, :ok, socket}
  end


  defp authorized?(_payload) do
    true
  end
end
