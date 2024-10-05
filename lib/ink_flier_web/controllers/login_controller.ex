defmodule InkFlierWeb.LoginController do
  use InkFlierWeb, :controller

  plug :assign_user

  def new(conn, _params) do
    conn
    |> render(:new, layout: false)
  end

  def create(conn, %{"user_name" => raw_user} = _params) do
    user = String.trim(raw_user)

    if user == "" do
      conn
      |> put_flash(:error, "Can't be blank")
      |> redirect(to: ~p"/login")
    else
      conn
      |> put_session(:user, user)
      |> redirect(to: ~p"/login")
    end
  end

  def delete(conn, _params) do
    conn
    |> delete_session(:user)
    |> redirect(to: ~p"/login")
  end


  defp assign_user(conn, _opts) do
    assign(conn, :user, get_session(conn, :user))
  end
end
