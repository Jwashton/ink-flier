defmodule InkFlierWeb.GameHTML do
  use InkFlierWeb, :html

  embed_templates "game_html/*"

  def lobby(assigns) do
    ~H"""
    Hi I'm html
    """
  end
end
