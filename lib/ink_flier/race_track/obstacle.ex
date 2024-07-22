defmodule InkFlier.RaceTrack.Obstacle do
  @moduledoc """
  Abstraction for Obstacles on the RaceTrack

  Includes both the track walls and any smaller obstacles

  Note that neither track wall is actually **required**. It's possibly to imagine a track with 1 or 0 walls, and the cars
  were on an infinite field but still had to aim for specific check and goal -points

  Name is just a small quick label for what the car ran into, so repeated names are fine (Such as
  multiple "Boulder"s or generic "Obstacle"s)

  Examples:
  ```
  "Inner Track", "Outer Track", "Rock", "River", "Median", "Obstacle"
  ```

  """

  alias InkFlier.Line

  @type t :: {name, coord_list}

  @type name :: String.t
  @type coord_list :: InkFlier.RaceTrack.coord_list
  @type name_set :: MapSet.t(name)

  @spec new(coord_list) :: t
  @spec new(String.t, coord_list) :: t
  def new(name \\ "Obstacle", coord_list), do: {name, coord_list}

  def name(t), do: elem(t, 0)
  def coord_list(t), do: elem(t, 1)

  @doc """
  Turn the coordinate list that builds an Obstacle (like the inner_wall of the RaceTrack) into a list of lines

  Useful for checking collisions
  """
  @spec wall_lines(t) :: [Line.t]
  def wall_lines(t) do
    t
    |> coord_list
    |> Stream.chunk_every(2, 1, :discard)
    |> Enum.map(fn [p,q] -> Line.new(p,q) end)
  end

  @doc """
  Add Obstacle's name to a MapSet if Obstacle was collided into

  Given an Obstacle and the line a car just travelled along, check for a collision. If one is found, add
  this Obstacle's name to a given MapSet
  """
  @spec add_collision_if_found(name_set, t, Line.t) :: name_set
  def add_collision_if_found(set, t, car_line) do
    if collision?(car_line, wall_lines(t)), do: MapSet.put(set, name(t)), else: set
  end


  defp collision?(car_line, wall_lines), do: Enum.find(wall_lines, &Line.intersect?(&1, car_line))
end
