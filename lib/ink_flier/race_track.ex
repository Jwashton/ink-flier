defmodule InkFlier.RaceTrack do
  @moduledoc """
  Struct and helpers for building a Race Track

  ## Keys
  - inner_wall: List of points that, when connected, draw the line of a track wall. Similar to svg points attribute in html

  - outer_wall: Same requirements as inner_wall

  - start- List of coords for start positions, in order of desierability ([best_start_pos, second_best_start_pos, ...])
    - TODO: `def new` may also take a line type, which should convert into a coord_list, starting with the first point of the given line

  - check1/check2- lines that must be crossed for valid win

  - goal- Usually the same as the line of the `start` coords, but can be anywhere as long as you have to pass through the `check`'s to reach it
  """

  defstruct ~w(inner_wall outer_wall start check1 check2 goal)a

  alias InkFlier.Coord

  @type t :: %__MODULE__{
    inner_wall: coord_list,
    outer_wall: coord_list,
    start: coord_list,
    check1: line,
    check2: line,
    goal: line
  }

  @type coord_list :: [Coord.t]
  @type line :: {Coord.t, Coord.t}

  @spec new(Keyword.t) :: t
  def new(attrs \\ []) do
    # start =
    #   case Keyword.get(:start) do
    #     {a, b} ->
    #     coord_list -> coord_list
    #   end
    struct!(__MODULE__, attrs)
  end
end
