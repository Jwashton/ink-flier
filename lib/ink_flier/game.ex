defmodule InkFlier.Game do
  use TypedStruct
  import TinyMaps
  import Access, only: [key: 1]

  alias InkFlier.Game.Server
  alias InkFlier.Board
  alias InkFlier.Car
  alias InkFlier.RaceTrack
  alias InkFlier.RoundTracker

  @typedoc "Given order is maintained, although currently only used for prioritizing starting positions"
  @type players :: [Game.player_id]

  @type player_id :: any

  typedstruct enforce: true do
    field :board, Board.t
    field :players, players
    field :round_tracker, RoundTracker.t
    field :locked_in, MapSet.t(player_id), default: MapSet.new
    field :notify_target, Server.notify_target, required: false
    field :track, RaceTrack.t
    # field :house_rules
  end

  def new(~M{players, track, notify_target}) do
    track_start_coords = RaceTrack.start(track)
    random_pole_position? = false
    board = Board.new(players, track_start_coords, random_pole_position?)
    round_tracker = RoundTracker.new

    struct!(__MODULE__, ~M{board, track, notify_target, players, round_tracker})
  end
  def new(players, track, notify_target \\ nil), do: new(~M{players, track, notify_target})

  def move(t, player, coord) do
    t
    |> do_move(player, coord)
    |> lock_in(player)
    |> maybe_advance_round
  end

  def check_legal_move(t, player, coord) do
    if legal_move?(t, player, coord), do: :ok, else: {:error, :illegal_destination}
  end

  def check_already_locked_in(t, player) do
    unless locked_in?(t, player), do: :ok, else: {:error, :already_locked_in}
  end

  def board(t), do: t.board
  def notify_target(t), do: t.notify_target
  def locked_in(t), do: t.locked_in
  def players(t), do: t.players
  def round_tracker(t), do: t.round_tracker

  def current_round(t), do: t |> round_tracker |> RoundTracker.current
  def current_positions(t), do: t |> board |> Board.current_positions

  def speed(t, player), do: t |> car(player) |> Car.speed
  def legal_move?(t, player, coord), do: t |> car(player) |> Car.legal_move?(coord)


  defp maybe_advance_round(t) do
    if MapSet.equal?(players_set(t), locked_in(t)), do: advance_round(t), else: t
  end

  defp players_set(t), do: t |> players |> MapSet.new

  defp car(t, player), do: get_in(t, car_key(player))

  defp advance_round(t) do
    t
    |> Map.update!(:round_tracker, &RoundTracker.advance/1)
    |> reset_locked_in
  end

  defp reset_locked_in(t), do: put_in(t.locked_in, MapSet.new)
  defp lock_in(t, player), do: update_in(t.locked_in, &MapSet.put(&1, player))

  defp do_move(t, player, coord), do: update_in(t, car_key(player), &Car.move(&1, coord))

  defp locked_in?(t, player), do: player in locked_in(t)

  defp car_key(player), do: [key(:board), key(player)]
end
