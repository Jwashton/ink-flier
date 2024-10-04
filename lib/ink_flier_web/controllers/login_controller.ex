defmodule InkFlierWeb.LoginController do
  use InkFlierWeb, :controller

  def new(conn, _params) do
    conn
    |> assign_user
    |> render(:new, layout: false)
  end

  def create(conn, _params) do
    conn
    |> assign_user
    |> render(:new, layout: false)
  end


  defp assign_user(conn), do: assign(conn, :user, :TODO)
end
