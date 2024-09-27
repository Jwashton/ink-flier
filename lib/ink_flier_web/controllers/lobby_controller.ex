defmodule InkFlierWeb.LobbyController do
  use InkFlierWeb, :controller

  def home(conn, _params) do
    render(conn, :home, layout: false)
  end
end
