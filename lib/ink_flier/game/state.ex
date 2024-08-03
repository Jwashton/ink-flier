defmodule InkFlier.Game.State do
  use TypedStruct
  import TinyMaps

  alias InkFlier.Game
  alias InkFlier.Board
  alias InkFlier.Car
  alias InkFlier.RaceTrack

  typedstruct enforce: true do
    # field :house_rules
    field :notify_target, Game.notify_target, required: false
    field :track, RaceTrack.t
    field :board, Board.t
  end

  def new(~M{players, track, notify_target}) do
    track_start_coords = RaceTrack.start(track)
    random_pole_position? = false

    board = Board.new(players, track_start_coords, random_pole_position?)

    struct!(__MODULE__, ~M{board, track, notify_target})
  end
  def new(players, track, notify_target \\ nil), do: new(~M{players, track, notify_target})

  def move(t, player, coord), do:
    update_in(t.board[player], &Car.move(&1, coord))

  def check_legal_move(t, player, coord) do
    if t.board[player] |> Car.legal_move?(coord) do
      :ok
    else
      {:error, :illegal_destination}
    end
  end

  def speed(t, player), do: t.board[player] |> Car.speed

  def notify_target(t), do: t.notify_target

  def current_positions(t), do: t |> board |> Board.current_positions

  def players(t), do: Map.keys(t.board)

  def board(t), do: t.board
end
