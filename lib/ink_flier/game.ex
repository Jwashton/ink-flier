defmodule InkFlier.Game do
  use GenServer
  import TinyMaps

  alias __MODULE__.State
  alias InkFlier.RaceTrack
  alias InkFlier.Coord

  @type player_id :: any
  @type players :: [player_id]
  @type house_rules_placeholder :: :TODO

  @spec start_link(players, RaceTrack.t, pid, house_rules_placeholder) :: {:ok, pid}
  def start_link(players, track, notify_target, _house_rules \\ nil), do:
    GenServer.start_link(__MODULE__, ~M{players, track, notify_target})

  @spec move(pid, player_id, Coord.t) :: {:ok, {:speed, integer}} | :TODO
  def move(pid, player, coord), do:
    GenServer.call(pid, {:move, player, coord})

  @spec current_positions(pid) :: %{player_id => Coord.t}
  def current_positions(pid), do:
    GenServer.call(pid, :current_positions)

  @impl GenServer
  def init(start_info) do
    start_info
    |> State.new
    |> notify_starting_positions
    |> ok
  end

  @impl GenServer
  def handle_call({:move, player, coord}, _, state) do
    with :ok <- State.check_legal_move(state, player, coord) do
      state
      |> State.move(player, coord)
      |> notify_player_locked_in(player)
      |> reply_with_speed(player)
    else
      error -> reply(state, error)
    end
  end

  @impl GenServer
  def handle_call(:current_positions, _, state) do
    state
    |> State.current_positions
    |> then(& reply(state, &1) )
  end


  defp notify_player_locked_in(state, player) do
    state
    |> State.notify_target
    |> send({:player_locked_in, player})

    state
  end

  defp notify_starting_positions(state) do
    state
    |> State.notify_target
    |> send({:starting_positions, State.current_positions(state)})

    state
  end

  defp ok(state), do: {:ok, state}

  defp reply(state, msg), do: {:reply, msg, state}

  defp reply_with_speed(state, player), do: reply(state, {:ok, {:speed, State.speed(state, player)}})
end
