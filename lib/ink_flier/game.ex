defmodule InkFlier.Game do
  use TypedStruct
  import TinyMaps
  import Access, only: [key: 1]

  alias InkFlier.Game.Server
  alias InkFlier.Board
  alias InkFlier.Car
  alias InkFlier.RaceTrack
  alias InkFlier.RoundTracker

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
    |> lock_in_player_for_round(player)
  end

  def check_legal_move(t, player, coord) do
    if legal_move?(t, player, coord), do: :ok, else: {:error, :illegal_destination}
  end

  def check_already_locked_in(t, player) do
    unless locked_in?(t, player), do: :ok, else: {:error, :already_locked_in}
  end

  defp car(t, player), do: get_in(t, car_key(player))

  defp car_key(player), do: [key(:board), key(player)]


  def board(t), do: t.board
  def notify_target(t), do: t.notify_target
  def round_tracker(t), do: t.round_tracker

  def current_positions(t), do: t |> board |> Board.current_positions
  def current_round(t), do: t |> round_tracker |> RoundTracker.current
  defp locked_in?(t, player), do: t |> round_tracker |> RoundTracker.locked_in?(player)
  def speed(t, player), do: t |> car(player) |> Car.speed
  def legal_move?(t, player, coord), do: t |> car(player) |> Car.legal_move?(coord)

  defp do_move(t, player, coord), do: update_in(t, car_key(player), &Car.move(&1, coord))
  defp lock_in_player_for_round(t, player), do:
    update_in(t.round_tracker, &RoundTracker.player_moved(&1, player))
end
