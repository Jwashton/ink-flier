defmodule InkFlier.Game do
  use GenServer
  import TinyMaps

  alias __MODULE__.State
  alias InkFlier.RaceTrack

  @type player_id :: any
  @type players :: [player_id]

  def start_link(players, track, notify_target, _house_rules \\ nil) do
    GenServer.start_link(__MODULE__, ~M{players, track, notify_target})
  end


  @impl GenServer
  def init(start_info) do
    state = State.new(start_info)
    track_start_coords = RaceTrack.start(state.track)
    random_pole_position? = false

    starting_positions =
      state.players
      |> players_in_order(random_pole_position?)
      |> Enum.zip(track_start_coords)
      |> Map.new

    state
    |> notify({:starting_positions, starting_positions})
    |> ok
  end


  defp players_in_order(players, random_pole_position?)
  defp players_in_order(players, false), do: players

  defp notify(state, msg), do: state |> State.notify_target |> send(msg)
  defp ok(state), do: {:ok, state}
end
