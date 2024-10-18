defmodule InkFlier.Game do
  use TypedStruct
  import TinyMaps

  typedstruct enforce: true do
    field :creator, player_id
    field :players, players, default: []
  end

  @type observer_id :: any
  @type member_id :: player_id | observer_id

  @type player_id :: any
  @type players :: [player_id]

  def new(creator), do: struct!(__MODULE__, ~M{creator})

  def add_player(t, player_id), do: update_in(t.players, &[player_id | &1])

  def creator(t), do: t.creator
  def players(t), do: t.players |> Enum.reverse
end
