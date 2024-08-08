defmodule InkFlier.HouseRules do
  @moduledoc """
  Customizeable house rules
  """

  use TypedStruct

  @typedoc "When true, players will be assigned to starting positions on the track in random desierability order, instead of the order they are given to Game.new"
  @type random_pole_position? :: boolean

  typedstruct enforce: true do
    field :random_pole_position?, random_pole_position?, default: false
  end

  def new(attrs \\ []), do: struct!(__MODULE__, attrs)
end
