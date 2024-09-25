defmodule InkFlierWeb.GameController do
  use InkFlierWeb, :controller

  def sandbox(conn, _params) do
    render(conn, :sandbox
      # root_layout: {InkFlierWeb.GameLayouts, :root},
      # layout: {InkFlierWeb.GameLayouts, :app}
    )
  end

  def lobby(conn, _params) do
    render(conn, :lobby)
  end
end
