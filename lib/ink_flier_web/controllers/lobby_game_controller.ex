defmodule InkFlierWeb.LobbyGameController do
  use InkFlierWeb, :controller
  import TinyMaps

  def home(conn, ~m{game_id}) do
    conn
    |> assign(:game_id, game_id)
    |> render
  end

  # def home(conn, _) do
  #   conn
  #   |> put_flash(:error, "Missing game id in url, eg. lobby/game/28")
  #   |> redirect(to: ~p"/lobby")
  # end
end
