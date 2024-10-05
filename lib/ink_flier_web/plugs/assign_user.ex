defmodule InkFlierWeb.Plugs.AssignUser do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    assign(conn, :user, get_session(conn, :user))
  end
end
