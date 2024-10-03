defmodule InkFlierWeb.LoginController do
  use InkFlierWeb, :controller

  def new(conn, _params) do
    render(conn, :new, layout: false)
  end
end
