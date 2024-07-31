defmodule InkFlier.Game.State do
  use TypedStruct

  alias InkFlier.Game
  alias InkFlier.RaceTrack

  typedstruct enforce: true do
    field :players, Game.players
    field :track, RaceTrack.t
    field :notify_target, Game.notify_target
    # field :house_rules
  end

  def new(args), do: struct!(__MODULE__, args)

  def notify_target(t), do: t.notify_target

  def current_positions(t) do
    track_start_coords = RaceTrack.start(t.track)
    random_pole_position? = false

    t.players
    |> players_in_order(random_pole_position?)
    |> Enum.zip(track_start_coords)
    |> Map.new
  end


  defp players_in_order(players, random_pole_position?)
  defp players_in_order(players, false), do: players
end
