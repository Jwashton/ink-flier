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
    # TODO handle_continue

    st = State.new(start_info)
    track_start_coords = RaceTrack.start(st.track)
    random_pole_position? = false

    starting_positions =
      st.players
      |> players_in_order(random_pole_position?)
      |> Enum.zip(track_start_coords)
      |> Map.new

    send(st.notify_target, {:starting_positions, starting_positions})

    {:ok, st}
  end


  defp players_in_order(players, random_pole_position?)
  defp players_in_order(players, false), do: players
end
