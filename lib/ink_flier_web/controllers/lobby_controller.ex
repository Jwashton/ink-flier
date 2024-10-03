defmodule InkFlierWeb.LobbyController do
  use InkFlierWeb, :controller

  def home(conn, _params) do
    conn
    |> assign_player_id
    |> render(:home, layout: false)
  end


  defp assign_player_id(conn) do
    assign(conn, :player_id, :TODO)
  end
end
