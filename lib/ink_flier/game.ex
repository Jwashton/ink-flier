defmodule InkFlier.Game do
  use TypedStruct
  import TinyMaps

  typedstruct enforce: true do
    field :creator, player_id
  end

  @type player_id :: any
  @type observer_id :: any
  @type member_id :: player_id | observer_id

  def new(creator), do: struct!(__MODULE__, ~M{creator})

  def creator(t), do: t.creator
end
