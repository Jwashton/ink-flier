defmodule InkFlier.Game.Server do
  use GenServer
  import TinyMaps

  alias InkFlier.Game
  alias InkFlier.RaceTrack
  alias InkFlier.Coord

  @type house_rules_placeholder :: :TODO
  @type summary :: %{
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

  @spec summary(pid) :: summary
  def summary(pid), do: GenServer.call(pid, :summary)


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
      |> maybe_notify_round_change(previous_state: t)
      |> reply_with_speed(player)
    else
      error -> reply(t, error)
    end
  end

  @impl GenServer
  def handle_call(:summary, _, t) do
    t
    |> build_summary
    |> reply_message(t)
  end


  defp maybe_notify_round_change(t, previous_state: previous_state) do
    if Game.current_round(t) > Game.current_round(previous_state) do
      notify(t, {:new_round, build_summary(t)})
    else
      t
    end
  end

  defp build_summary(t) do
    %{
      round: Game.current_round(t),
      positions: Game.current_positions(t),
    }
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
