defmodule InkFlierWeb.LobbyController do
  use InkFlierWeb, :controller

  def home(conn, _params) do
    conn
    |> put_session(:player_id, "Batman")
    # |> clear_session
    |> assign_player_id
    |> render(:home, layout: false)
  end


  defp assign_player_id(conn) do
    assign(conn, :player_id, get_session(conn, :player_id))
  end
end
