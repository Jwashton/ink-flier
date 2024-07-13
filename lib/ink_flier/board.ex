defmodule InkFlier.Board do
  alias InkFlier.Coord
  alias InkFlier.RaceTrack

  defstruct ~w(race_track current_positions)a

  @type t :: %__MODULE__{
    race_track: RaceTrack.t,
    current_positions: %{player_id => Coord.t},
  }

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
    |> Map.new
    |> then(&set_current_positions(t, &1))
  end

  def race_track(t), do: t.race_track
  def current_positions(t), do: t.current_positions


  defp set_current_positions(t, new), do: Map.put(t, :current_positions, new)

  defp players_in_order(players, true), do: Enum.shuffle(players)
  defp players_in_order(players, _), do: players
end
