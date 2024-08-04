defmodule InkFlier.Game.Server do
  use GenServer
  import TinyMaps

  alias InkFlier.Game
  alias InkFlier.RaceTrack
  alias InkFlier.Coord

  @type house_rules_placeholder :: :TODO
  @type current_game_state :: %{
    round: Game.round,
    positions: %{Game.player_id => Coord.t},
  }

  @spec start_link(Game.players, RaceTrack.t, pid, house_rules_placeholder) :: {:ok, pid}
  def start_link(players, track, notify_target, _house_rules \\ nil), do:
    GenServer.start_link(__MODULE__, ~M{players, track, notify_target})

  @spec move(pid, Game.player_id, Coord.t) ::
      {:ok, {:speed, integer}}
      | {:error, error_description :: atom}
  def move(pid, player, coord), do: GenServer.call(pid, {:move, player, coord})

  @spec current_game_state(pid) :: current_game_state
  def current_game_state(pid), do: GenServer.call(pid, :current_game_state)


  @impl GenServer
  def init(start_info) do
    start_info
    |> Game.new
    |> notify_starting_positions
    |> ok
  end

  @impl GenServer
  def handle_call({:move, player, coord}, _, t) do
    with :ok <- Game.check_legal_move(t, player, coord),
         :ok <- Game.check_already_locked_in(t, player) do
      t
      |> Game.move(player, coord)
      |> notify({:player_locked_in, player})
      |> reply_with_speed(player)
    else
      error -> reply(t, error)
    end
  end

  @impl GenServer
  def handle_call(:current_positions, _, t) do
    t
    |> Game.current_positions
    |> reply_message(t)
  end

  @impl GenServer
  def handle_call(:current_game_state, _, t) do
    round = Game.round(t)
    positions = Game.current_positions(t)

    reply(t, ~M{round, positions})
  end

  defp notify_starting_positions(t), do: notify(t, {:starting_positions, Game.current_positions(t)})

  defp ok(t), do: {:ok, t}

  defp reply(t, message), do: {:reply, message, t}

  defp reply_message(message, t), do: reply(t, message)

  defp reply_with_speed(t, player), do: reply(t, {:ok, {:speed, Game.speed(t, player)}})

  defp notify(t, message) do
    t
    |> Game.notify_target
    |> send(message)

    t
  end
end
