defmodule InkFlierWeb.RoomChannel do
  use InkFlierWeb, :channel
  import TinyMaps

  alias InkFlier.Game
  alias InkFlier.LobbyServer

  @impl true
  def join("room:lobby", payload, socket) do
    if authorized?(payload) do
      games =
        LobbyServer.games
        |> Enum.sort_by(&elem(&1, 0), :desc)
        |> Enum.map(fn {id, game} ->
          %{id: id, creator: Game.creator(game)}
        end)

      {:ok, games, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  @impl true
  def handle_in("create_game", _track_id, socket) do
    user = socket.assigns.user
    game = Game.new(user)
    {:ok, game_id} = LobbyServer.add_game(game)

    # # TODO dry
    # games =
    #   LobbyServer.games
    #   |> Enum.sort_by(&elem(&1, 0), :desc)
    #   |> Enum.map(fn {id, game} ->
    #     %{id: id, creator: Game.creator(game)}
    #   end)

    game_wrapper = %{id: game_id, creator: Game.creator(game)}

    broadcast(socket, "game_created", game_wrapper)
    {:reply, :ok, socket}
  end

  @impl true
  def handle_in("delete_game", game_id, socket) do
    :ok = LobbyServer.delete_game(game_id)
    broadcast(socket, "game_deleted", ~M{game_id})
    {:reply, :ok, socket}
  end


  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
