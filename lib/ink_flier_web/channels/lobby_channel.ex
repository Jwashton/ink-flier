defmodule InkFlierWeb.LobbyChannel do
  use InkFlierWeb, :channel
  import TinyMaps

  alias Phoenix.Channel
  alias InkFlier.Lobby
  alias InkFlier.GameServer
  alias InkFlierWeb.Endpoint
  alias InkFlierWeb.GameChannel

  @main_topic "lobby:main"

  def topic, do: @main_topic

  def notify_game_updated(game_id), do: Endpoint.broadcast(@main_topic, "game_updated", GameServer.summary_info(game_id))


  @impl Channel
  def join(@main_topic, _payload, socket), do: {:ok, Lobby.games_info |> Enum.reverse, socket}

  @impl Channel
  def handle_in("create_game", track_id, socket), do: create_game(socket, track_id)

  @impl Channel
  def handle_in("create_and_join_game", track_id, socket), do: create_game(socket, track_id, true)

  @impl Channel
  def handle_in("delete_game", game_id, socket) do
    :ok = Lobby.delete_game(game_id)

    broadcast(socket, "game_deleted", ~M{game_id})
    {:reply, :ok, socket}
  end

  @impl Channel
  def handle_in("join_game", game_id, socket) do
    GameChannel.player_join(game_id, socket.assigns.user)
    {:reply, :ok, socket}
  end

  @impl Channel
  def handle_in("leave_game", game_id, socket) do
    GameChannel.player_leave(game_id, socket.assigns.user)
    {:reply, :ok, socket}
  end


  defp create_game(socket, track_id, join \\ false) do
    {:ok, game_id} = Lobby.start_game(creator: socket.assigns.user, track_id: track_id, join: join)

    broadcast(socket, "game_created", GameServer.summary_info(game_id))
    {:reply, :ok, socket}
  end
end
