defmodule InkFlierWeb.LoginController do
  use InkFlierWeb, :controller
  import TinyMaps

  plug :default_return_to, "/login"

  def new(conn, ~m{return_to}) do
    conn
    |> assign(:return_to, return_to)
    |> new(nil)
  end

  def new(conn, _params) do
    conn
    |> render(:new, layout: false)
  end

  def create(conn, ~m{user_name, return_to}) do
    user = String.trim(user_name)

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

  def delete(conn, ~m{return_to}) do
    conn
    |> delete_session(:user)
    |> redirect(to: return_to)
  end


  defp default_return_to(conn, default_return_to) do
    return_to = conn.assigns[:return_to] || default_return_to
    assign(conn, :return_to, return_to)
  end
end
