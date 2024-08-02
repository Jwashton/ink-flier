defmodule InkFlier.Game do
  use GenServer
  import TinyMaps

  alias __MODULE__.State
  alias InkFlier.RaceTrack
  alias InkFlier.Coord
  alias InkFlier.Board
  alias InkFlier.Car

  @type player_id :: any
  @type players :: [player_id]
  @type house_rules_placeholder :: :TODO

  @spec start_link(players, RaceTrack.t, pid, house_rules_placeholder) :: {:ok, pid}
  def start_link(players, track, notify_target, _house_rules \\ nil), do:
    GenServer.start_link(__MODULE__, ~M{players, track, notify_target})

  @spec move(pid, player_id, Coord.t) :: {:ok, {:speed, integer}} | :TODO
  def move(pid, player, coord), do:
    GenServer.call(pid, {:move, player, coord})


  @impl GenServer
  def init(start_info) do
    start_info
    |> State.new
    |> notify_starting_positions
    |> ok
  end

  @impl GenServer
  def handle_call({:move, player, coord}, _, state) do
    speed =
      state
      |> State.board
      |> Board.car(player)
      |> Car.move(coord)
      |> Car.speed

    state
    |> reply({:ok, {:speed, speed}})
  end


  defp notify_starting_positions(state) do
    state
    |> State.notify_target
    |> send({:starting_positions, State.current_positions(state)})

    state
  end

  defp ok(state), do: {:ok, state}
  defp reply(state, reply), do: {:reply, reply, state}
end
