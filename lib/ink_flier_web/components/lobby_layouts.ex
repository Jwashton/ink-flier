defmodule InkFlierWeb.LobbyLayouts do
  use InkFlierWeb, :html

  embed_templates "lobby_layouts/*"

  attr :scripts, :list
  def extra_scripts(assigns) do
    ~H"""
    <script :for={script <- @scripts || []} defer phx-track-static type="text/javascript" src={script}></script>
    """
  end

  attr :styles, :list
  def extra_styles(assigns) do
    ~H"""
    <link :for={style <- @styles || []} phx-track-static rel="stylesheet" href={style} />
    """
  end
end
