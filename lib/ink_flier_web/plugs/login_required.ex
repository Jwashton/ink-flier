defmodule InkFlierWeb.Plugs.LoginRequired do
  use InkFlierWeb, :controller
  # import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    case get_session(conn, :user) do
      nil ->
        conn
        |> put_flash(:info, "You must be logged in")
        |> redirect(to: ~p"/login?return_to=#{current_path(conn)}")
        |> halt()

      _ ->
        conn
    end
  end
end
