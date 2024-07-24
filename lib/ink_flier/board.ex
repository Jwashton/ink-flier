defmodule InkFlier.Board do
  use TypedStruct

  alias InkFlier.RaceTrack
  alias InkFlier.Car

  typedstruct do
    field :race_track, RaceTrack.t, enforce: true
    field :players, %{player_id => Car.t}
  end

  @type player_id :: any

  @spec new(RaceTrack.t) :: t
  def new(race_track) do
    struct!(__MODULE__, race_track: race_track)
  end

  @spec start(t, [player_id], boolean) :: t
  def start(t, players, random_pole_position?) do
    track_start_coords = RaceTrack.start(t.race_track)

    players
    |> players_in_order(random_pole_position?)
    |> Enum.zip(track_start_coords)
    |> Enum.map(&coord_to_car_tuple/1)
    |> then(&set_players(t, &1))
  end

  def race_track(t), do: t.race_track
  def players(t), do: t.players

  def current_positions(t) do
    players(t)
    |> Enum.map(&car_to_coord_tuple/1)
    |> Map.new
  end


  defp set_players(t, new), do: Map.put(t, :players, new)

  defp coord_to_car_tuple({player, coord}), do: {player, Car.new(coord)}
  defp car_to_coord_tuple({player, car}), do: {player, Car.position(car)}

  defp players_in_order(players, true), do: Enum.shuffle(players)
  defp players_in_order(players, _), do: players
end
