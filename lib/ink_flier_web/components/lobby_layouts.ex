defmodule InkFlierWeb.LobbyLayouts do
  use InkFlierWeb, :html

  embed_templates "lobby_layouts/*"

  attr :scripts, :list
  def scripts(assigns) do
    ~H"""
    <script :for={script <- @scripts || []} defer phx-track-static type="text/javascript" src={script}></script>
    """
  end
end
