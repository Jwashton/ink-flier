defmodule InkFlierWeb.LobbyController do
  use InkFlierWeb, :controller

  def home(conn, _params) do
    conn
    |> render(:home, layout: false)
  end
end
