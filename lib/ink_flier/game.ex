defmodule InkFlier.Game do
  use TypedStruct
  import TinyMaps

  alias InkFlier.Game.Server
  alias InkFlier.Board
  alias InkFlier.RaceTrack
  alias InkFlier.RoundTracker

  @type summary :: %{
    round: RoundTracker.current_round,
    positions: %{RoundTracker.player_id => Coord.t},
  }

  typedstruct enforce: true do
    field :board, Board.t
    field :round_tracker, RoundTracker.t
    field :notify_target, Server.notify_target, required: false
    field :track, RaceTrack.t
    # field :house_rules
  end

  def new(~M{players, track, notify_target}) do
    track_start_coords = RaceTrack.start(track)
    random_pole_position? = false
    board = Board.new(players, track_start_coords, random_pole_position?)
    round_tracker = RoundTracker.new(players)

    struct!(__MODULE__, ~M{board, round_tracker, track, notify_target})
  end
  def new(players, track, notify_target \\ nil), do: new(~M{players, track, notify_target})

  def move(t, player, coord) do
    t
    |> do_move(player, coord)
    |> update_round_tracker(&RoundTracker.lock_in(&1, player))
  end

  @doc false
  defp do_move(t, player, coord), do: t |> update_board(&Board.move(&1, player, coord))

  @spec summary(t) :: summary
  def summary(t) do
    %{
      round: current_round(t),
      positions: current_positions(t),
    }
  end

  def round_changed?(t, previous_t), do: current_round(t) > current_round(previous_t)

  def check_legal_move(t, player, coord) do
    if legal_move?(t, player, coord), do: :ok, else: {:error, :illegal_destination}
  end

  def check_already_locked_in(t, player) do
    unless locked_in?(t, player), do: :ok, else: {:error, :already_locked_in}
  end


  def notify_target(t), do: t.notify_target

  def current_positions(t), do: t.board |> Board.current_positions
  def speed(t, player), do: t.board |> Board.speed(player)
  defp current_round(t), do: t.round_tracker |> RoundTracker.current
  defp locked_in?(t, player), do: t.round_tracker |> RoundTracker.locked_in?(player)
  defp legal_move?(t, player, coord), do: t.board |> Board.legal_move?(player, coord)

  defp update_round_tracker(t, func), do: update_in(t.round_tracker, func)
  defp update_board(t, func), do: update_in(t.board, func)
end
