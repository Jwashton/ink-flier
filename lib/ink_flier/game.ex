defmodule InkFlier.Game do
  use TypedStruct
  import TinyMaps
  import Access, only: [key: 1]

  alias InkFlier.Game.Server
  alias InkFlier.Board
  alias InkFlier.Car
  alias InkFlier.RaceTrack

  @typedoc "Given order is maintained, although currently only used for prioritizing starting positions"
  @type players :: [Game.player_id]

  @type player_id :: any
  @type round :: integer

  typedstruct enforce: true do
    field :board, Board.t
    field :players, players
    field :round, round, default: 1
    field :locked_in, MapSet.t(player_id), default: MapSet.new
    field :notify_target, Server.notify_target, required: false
    field :track, RaceTrack.t
    # field :house_rules
  end

  def new(~M{players, track, notify_target}) do
    track_start_coords = RaceTrack.start(track)
    random_pole_position? = false

    board = Board.new(players, track_start_coords, random_pole_position?)

    struct!(__MODULE__, ~M{board, track, notify_target, players})
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
  def round(t), do: t.round
  def players(t), do: t.players

  def current_positions(t), do: t |> board |> Board.current_positions

  def speed(t, player), do: t |> car(player) |> Car.speed
  def legal_move?(t, player, coord), do: t |> car(player) |> Car.legal_move?(coord)


  defp maybe_advance_round(t) do
    if MapSet.equal?(players_set(t), locked_in(t)), do: advance_round(t), else: t
  end

  defp players_set(t), do: t |> players |> MapSet.new

  defp car(t, player), do: get_in(t, car_key(player))

  defp lock_in(t, player), do: update_in(t.locked_in, &MapSet.put(&1, player))
  defp advance_round(t), do: update_in(t.round, & &1 + 1)
  defp do_move(t, player, coord), do: update_in(t, car_key(player), &Car.move(&1, coord))

  defp locked_in?(t, player), do: player in locked_in(t)

  defp car_key(player), do: [key(:board), key(player)]
end
