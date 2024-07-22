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
  alias InkFlier.Line

  typedstruct enforce: true do
    field :start, coord_list
    field :check1, line
    field :check2, line
    field :goal, line
    field :obstacles, MapSet.t(Obstacle.t)
  end

  @type coord_list :: [Coord.t]
  @type line :: {Coord.t, Coord.t}
  @type collision_reply :: :ok | {:collision, Obstacle.name_set}


  @spec new(Keyword.t) :: t
  def new(attrs), do: struct!(__MODULE__, attrs)

  defdelegate new_obstacle(coord_list), to: Obstacle, as: :new
  defdelegate new_obstacle(coord_list, name), to: Obstacle, as: :new

  @doc """
  Check if the line between a car's previous & new position collides with any track obstacles
  """
  @spec check_collision(t, Line.t) :: collision_reply
  def check_collision(t, car_line) do
    t.obstacles
    |> Enum.reduce(MapSet.new, &Obstacle.add_collision_if_found(&2, &1, car_line))
    |> collision_reply
  end

  @doc "See `check_collision/2`"
  @spec check_collision(t, Coord.t, Coord.t) :: collision_reply
  def check_collision(t, p, q), do: check_collision(t, Line.new(p, q))

  def start(t), do: t.start


  defp collision_reply(set), do: unless(MapSet.size(set) > 0, do: :ok, else: {:collision, set})
end
