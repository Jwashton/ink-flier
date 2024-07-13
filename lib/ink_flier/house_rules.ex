defmodule InkFlier.HouseRules do
  @moduledoc """
  Customizeable house rules

  ## Fields
  - random_pole_position?- When true, players will be assigned to starting positions on the track in random desierability order, instead of the order they are given to Game.new
  """

  defstruct [
    random_pole_position?: false
  ]

  def new(attrs \\ []), do: struct!(__MODULE__, attrs)
end
