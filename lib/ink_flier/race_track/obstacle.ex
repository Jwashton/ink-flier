defmodule InkFlier.RaceTrack.Obstacle do
  @moduledoc """
  Abstraction for Obstacles on the RaceTrack

  Includes both the track walls and any smaller obstacles

  Note that neither track wall is actually **required**. It's possible to imagine a track with 1 or 0 walls, and the cars
  are on an infinite field but still have to aim for specific check and goal -points

  ### :name field
  Name is just a small quick label for what the car ran into, so repeated names are fine (Such as
  multiple "Boulder"s or generic "Obstacle"s)

  Examples:
  ```
  "Inner Track", "Outer Track", "Rock", "River", "Median", "Obstacle"
  ```

  ### :wall_lines field
  This shouldn't be entered manually, and should instead always be generated with `new/1` or `new/2`. Doing
  so builds this from the provided `coord_list`

  Which means those two fields are redundant; we're storing both anyways so the `chunk_every` loop only has run
  once, when the Obstacle is created (and not EVERY time we check it for collisions)
  """

  use TypedStruct
  import TinyMaps

  alias InkFlier.Line
  alias InkFlier.Coord

  typedstruct enforce: true do
    field :name, name
    field :coord_list, coord_list
    field :wall_lines, [Line.t]
  end

  @type name :: String.t
  @type coord_list :: [Coord.t]

  @type name_set :: MapSet.t(name)


  @spec new(coord_list) :: t
  @spec new(name, coord_list) :: t
  def new(name \\ "Obstacle", coord_list) do
    struct!(__MODULE__, ~M{name, coord_list, wall_lines: build_wall_lines(coord_list)})
  end

  @doc """
  Add Obstacle's name to a MapSet if Obstacle was collided into

  Given an Obstacle and the line a car just travelled along, check for a collision. If one is found, add
  this Obstacle's name to a given MapSet
  """
  @spec add_collision_if_found(name_set, t, Line.t) :: name_set
  def add_collision_if_found(set, t, car_line) do
    if collision?(car_line, t.wall_lines), do: MapSet.put(set, t.name), else: set
  end


  defp build_wall_lines(coord_list) do
    coord_list
    |> Stream.chunk_every(2, 1, :discard)
    |> Enum.map(fn [p,q] -> Line.new(p,q) end)
  end

  defp collision?(car_line, wall_lines), do: Enum.find(wall_lines, &Line.intersect?(&1, car_line))
end
