defmodule InkFlierWeb.LobbyLayouts do
  use InkFlierWeb, :html

  embed_templates "lobby_layouts/*"

  attr :scripts, :list, required: true
  def scripts(assigns) do
    ~H"""
    <script>window.userToken = "<%= assigns[:user_token] %>";</script>
    <script :for={script <- @scripts} defer phx-track-static type="text/javascript" src={script}></script>
    """
  end
end
