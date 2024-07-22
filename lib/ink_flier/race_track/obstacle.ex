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

  @type t :: {name :: String.t, coord_list}
  @type coord_list :: InkFlier.RaceTrack.coord_list

  @spec new(coord_list) :: t
  @spec new(String.t, coord_list) :: t
  def new(name \\ "Obstacle", coord_list), do: {name, coord_list}

  def name(t), do: elem(t, 0)
  def coord_list(t), do: elem(t, 1)
end

