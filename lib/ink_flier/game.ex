defmodule InkFlier.Game do
  use TypedStruct

  typedstruct enforce: true do
    field :players, [player_id], default: []
    field :track, RaceTrack.t, enforce: false
  end

  @type player_id :: any

  @spec new :: t
  def new, do: struct!(__MODULE__)

  def players(t), do: t.players
  def track(t), do: t.track
end
