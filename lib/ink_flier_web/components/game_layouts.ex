defmodule InkFlierWeb.GameLayouts do
  @moduledoc """
  This module holds different layouts used by your application.

  See the `layouts` directory for all templates available.
  The "root" layout is a skeleton rendered as part of the
  application router. The "app" layout is set as the default
  layout on both `use InkFlierWeb, :controller` and
  `use InkFlierWeb, :live_view`.
  """
  use InkFlierWeb, :html

  embed_templates "game_layouts/*"
end
