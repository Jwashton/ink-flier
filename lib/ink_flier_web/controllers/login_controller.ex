defmodule InkFlierWeb.LoginController do
  use InkFlierWeb, :controller

  def new(conn, _params) do
    conn
    |> render(:new, layout: false)
  end

  def create(conn, params) do
    %{"user_name" => raw_user, "return_to" => return_to} = params
                                                           |> dbg(charlists: :as_lists)

    user = String.trim(raw_user)

    if user == "" do
      conn
      |> put_flash(:error, "Can't be blank")
      |> redirect_to_self
    else
      conn
      |> put_session(:user, user)
      |> redirect_to_self
    end
  end

  def delete(conn, _params) do
    conn
    |> delete_session(:user)
    |> redirect_to_self
  end


  defp redirect_to_self(conn) do
    redirect(conn, to: conn.assigns.return_to)
  end
end
