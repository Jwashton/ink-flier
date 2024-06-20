defmodule InkFlierWeb.GameController do
  use InkFlierWeb, :controller

  def sandbox(conn, _params) do
    render(conn, :sandbox, layout: {InkFlierWeb.Layouts, :game})
  end
end
