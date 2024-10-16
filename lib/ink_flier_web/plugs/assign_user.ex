defmodule InkFlierWeb.Plugs.AssignUser do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    current_user = get_session(conn, :user)
    conn = assign(conn, :user, current_user)

    if current_user do
      token = Phoenix.Token.sign(conn, "user socket", current_user)
      assign(conn, :user_token, token)
    else
      conn
    end
  end
end
