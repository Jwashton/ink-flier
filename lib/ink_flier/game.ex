defmodule InkFlier.Game do
  use GenServer
  import TinyMaps

  alias __MODULE__.State

  @type player_id :: any
  @type players :: [player_id]

  def start_link(players, track, notify_target, _house_rules \\ nil) do
    GenServer.start_link(__MODULE__, ~M{players, track, notify_target})
  end


  @impl GenServer
  def init(start_info) do
    start_info
    |> State.new
    |> notify_starting_positions
    |> ok
  end


  defp notify_starting_positions(state) do
    state
    |> State.notify_target
    |> send({:starting_positions, State.current_positions(state)})

    state
  end

  defp ok(state), do: {:ok, state}
end
