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
    field :obstacles, MapSet.t(obstacle)
  end

  @type coord_list :: [Coord.t]
  @type line :: {Coord.t, Coord.t}
  @type obstacle :: Obstacle.t
  @type collision_check :: :ok | {:collision, obstacle}


  @spec new(Keyword.t) :: t
  def new(attrs), do: struct!(__MODULE__, attrs)

  defdelegate new_obstacle(coord_list), to: Obstacle, as: :new
  defdelegate new_obstacle(coord_list, name), to: Obstacle, as: :new

  @doc """
  Check if the line between a car's previous & new position collides with any track obstacles
  """
  @spec check_collision(t, Line.t) :: collision_check
  def check_collision(t, car_line) do
    # NOTE Possible future optimization- This is a fair number of loops-in-loops; for each little line piece of
    # each wall or obstacle, check for intersect
    # Also, builds that list of line pieces from scratch with Enum.chunk_every
    # If this runs slow, I can start by pre-building that Enum.chunk_every ONE time when track is made and storing it
    # as extra data in the struct

    collision_set =
      t.obstacles
      |> Enum.reduce(MapSet.new, fn obstacle, collision_set ->
        wall_lines =
          obstacle
          |> Obstacle.coord_list
          |> Enum.chunk_every(2, 1, :discard)
          |> Enum.map(fn [p,q] -> Line.new(p,q) end)

        if Enum.find(wall_lines, &Line.intersect?(&1, car_line)) do
          MapSet.put(collision_set, Obstacle.name(obstacle))
        else
          collision_set
        end
      end)

    if MapSet.size(collision_set) > 0 do
      {:collision, collision_set}
    else
      :ok
    end
  end

  @doc "See `check_collision/2`"
  @spec check_collision(t, Coord.t, Coord.t) :: collision_check
  def check_collision(t, p, q), do: check_collision(t, Line.new(p, q))

  def start(t), do: t.start
end
