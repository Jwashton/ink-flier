defmodule InkFlierWeb.LobbyGameController do
  use InkFlierWeb, :controller
  import TinyMaps

  alias InkFlier.GameServer

  def home(conn, ~m{game_id, _join}) do
    :ok = GameServer.join(game_id, conn.assigns.user)
    home(conn, ~m{game_id})
  end

  def home(conn, ~m{game_id}) do
    # TODO temporarily start_link a new game "321" in application... later it will need to be started from lobby

    ~M{creator, players} = GameServer.starting_info(game_id)

    conn
    |> assign(~M{creator, players, game_id})
    |> assign(path: current_path(conn, %{}))
    |> render
  end

  # def home(conn, _) do
  #   conn
  #   |> put_flash(:error, "Missing game id in url, eg. lobby/game/28")
  #   |> redirect(to: ~p"/lobby")
  # end

end
