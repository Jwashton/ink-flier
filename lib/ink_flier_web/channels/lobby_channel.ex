defmodule InkFlierWeb.LobbyChannel do
  use InkFlierWeb, :channel
  import TinyMaps

  alias InkFlier.LobbyServer
  alias InkFlier.GameServer
  alias InkFlierWeb.Endpoint

  @main_topic "lobby:main"

  def topic, do: @main_topic

  def notify_game_updated(game_id), do: Endpoint.broadcast(@main_topic, "game_updated", GameServer.summary_info(game_id))


  @impl Phoenix.Channel
  def join(@main_topic, payload, socket) do
    if authorized?(payload) do
      {:ok, LobbyServer.games_info |> Enum.reverse, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  @impl Phoenix.Channel
  def handle_in("create_game", _track_id, socket) do
    {:ok, game_id} = LobbyServer.start_game(creator: socket.assigns.user)

    broadcast(socket, "game_created", GameServer.summary_info(game_id))
    {:reply, :ok, socket}
  end

  @impl Phoenix.Channel
  def handle_in("delete_game", game_id, socket) do
    :ok = LobbyServer.delete_game(game_id)

    broadcast(socket, "game_deleted", ~M{game_id})
    {:reply, :ok, socket}
  end


  defp authorized?(_payload), do: true
end
