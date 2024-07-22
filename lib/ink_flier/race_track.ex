defmodule InkFlier.RaceTrack do
  @moduledoc """
  Struct and helpers for building a Race Track

  ## Keys
  - *start*- List of coords for start positions, in order of desierability ([best_start_pos, second_best_start_pos, ...])

  - *check1*/*check2*- lines that must be crossed for valid win

  - *goal*- Usually the same as the line of the `start` coords, but can be anywhere as long as you have to pass through the `check`'s to reach it

  - *obstacles*
    - See `InkFlier.RaceTrack.Obstacle`
    - Recommended (but not required) obstacles are "Inner Track" and "Outer Track"
  """

  use TypedStruct

  alias InkFlier.RaceTrack.Obstacle
  alias InkFlier.Coord

  typedstruct enforce: true do
    field :start, coord_list
    field :check1, line
    field :check2, line
    field :goal, line
    field :obstacles, MapSet.t(obstacle)
  end

  @type coord_list :: [Coord.t]
  @type line :: {Coord.t, Coord.t}
  @type obstacle :: Obstacle.t


  @spec new(Keyword.t) :: t
  def new(attrs), do: struct!(__MODULE__, attrs)

  @spec check_collision(t, Coord.t, Coord.t) :: :ok | {:collision, collision_object}
  def check_collision(t, _a, _b) do
    [t.inner_wall, t.outer_wall]
    |> Enum.find(fn wall ->
      _wall_lines = Enum.chunk_every(wall, 2, 1, :discard)
    end)
  defdelegate new_obstacle(coord_list), to: Obstacle, as: :new
  defdelegate new_obstacle(coord_list, name), to: Obstacle, as: :new

    # TODO hc
    {:collision, :outer_wall}
  end

  # @doc false
  # def

  def start(t), do: t.start
end
