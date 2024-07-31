defmodule InkFlier.Game.State do
  use TypedStruct

  alias InkFlier.Game

  typedstruct enforce: true do
    field :players, Game.players
    field :track, InkFlier.RaceTrack.t
    field :notify_target, Game.notify_target
    # field :house_rules
  end

  def new(args), do: struct!(__MODULE__, args)
end
