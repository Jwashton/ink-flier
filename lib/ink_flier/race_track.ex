defmodule InkFlier.RaceTrack do
  @moduledoc """
  Struct and helpers for building a Race Track

  ## Keys
  - inner_wall: List of points that, when connected, draw the line of a track wall. Similar to svg points attribute in html

  - outer_wall: Same requirements as inner_wall

  - start- List of coords for start positions, in order of desierability ([best_start_pos, second_best_start_pos, ...])

  - check1/check2- lines that must be crossed for valid win

  - goal- Usually the same as the line of the `start` coords, but can be anywhere as long as you have to pass through the `check`'s to reach it
  """

  use TypedStruct

  alias InkFlier.Coord

  typedstruct enforce: true do
    field :inner_wall, coord_list
    field :outer_wall, coord_list
    field :start, coord_list
    field :check1, line
    field :check2, line
    field :goal, line
  end

  @type coord_list :: [Coord.t]
  @type line :: {Coord.t, Coord.t}
  @type collision_object :: :inner_wall | :outer_wall


  @spec new(Keyword.t) :: t
  def new(attrs), do: struct!(__MODULE__, attrs)

  @spec check_collision(t, Coord.t, Coord.t) :: :ok | {:collision, collision_object}
  def check_collision(t, _a, _b) do
    [t.inner_wall, t.outer_wall]
    |> Enum.find(fn wall ->
      _wall_lines = Enum.chunk_every(wall, 2, 1, :discard)
    end)

    # TODO hc
    {:collision, :outer_wall}
  end

  # @doc false
  # def

  def start(t), do: t.start
end
