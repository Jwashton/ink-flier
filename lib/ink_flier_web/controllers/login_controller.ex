defmodule InkFlierWeb.LoginController do
  use InkFlierWeb, :controller

  def new(conn, _params) do
    conn
    |> assign_user
    |> render(:new, layout: false)
  end

  def create(conn, %{"user_name" => raw_user} = _params) do
    conn
    |> put_session(:user, raw_user)
    |> redirect(to: ~p"/login")
  end

  def delete(conn, _params) do
    conn
    |> delete_session(:user)
    |> redirect(to: ~p"/login")
  end


  defp assign_user(conn) do
    assign(conn, :user, get_session(conn, :user))
  end
end
