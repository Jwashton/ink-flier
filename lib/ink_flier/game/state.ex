defmodule InkFlier.Game.State do
  use TypedStruct
  import TinyMaps

  alias InkFlier.Game
  alias InkFlier.Car
  alias InkFlier.RaceTrack

  typedstruct enforce: true do
    # field :house_rules
    field :notify_target, Game.notify_target
    field :track, RaceTrack.t
    field :board, %{Game.player_id => Car.t}
  end

  def new(~M{players, track, notify_target}) do
    track_start_coords = RaceTrack.start(track)
    random_pole_position? = false

    board =
      players
      |> players_in_order(random_pole_position?)
      |> Enum.zip(track_start_coords)
      |> Enum.map(&player_and_car_tuple/1)
      |> Map.new

    struct!(__MODULE__, ~M{board, track, notify_target})
  end

  def notify_target(t), do: t.notify_target

  def current_positions(t) do
    t.board
    |> Enum.map(fn {player, car} ->
      {player, Car.position(car)}
    end)
    |> Map.new
  end

  def players(t), do: Map.keys(t.board)

  defp player_and_car_tuple({player, coord}), do: {player, Car.new(coord)}

  defp players_in_order(players, random_pole_position?)
  defp players_in_order(players, false), do: players
end
