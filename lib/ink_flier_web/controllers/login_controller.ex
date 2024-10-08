defmodule InkFlierWeb.LoginController do
  use InkFlierWeb, :controller

  plug :default_return_to, "/login"

  def new(conn, _params) do
    conn
    |> render(:new, layout: false)
  end

  def create(conn, params) do
    %{"user_name" => raw_user, "return_to" => return_to} = params
    user = String.trim(raw_user)

    if user == "" do
      conn
      |> put_flash(:error, "Can't be blank")
      |> redirect(to: return_to)
    else
      conn
      |> put_session(:user, user)
      |> redirect(to: return_to)
    end
  end

  def delete(conn, params) do
    %{"return_to" => return_to} = params

    conn
    |> delete_session(:user)
    |> redirect(to: return_to)
  end


  defp default_return_to(conn, default_return_to) do
    return_to = conn.assigns[:return_to] || default_return_to
    assign(conn, :return_to, return_to)
  end
end
