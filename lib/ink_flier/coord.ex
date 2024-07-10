defmodule InkFlier.Coord do
  @type t :: {integer(), integer()}

  def up({x,y}), do: {x,y+1}
  def down({x,y}), do: {x,y-1}
  def left({x,y}), do: {x-1,y}
  def right({x,y}), do: {x+1,y}

  def right_up(t), do: t |> right |> up
  def right_down(t), do: t |> right |> down
  def left_down(t), do: t |> left |> down
  def left_up(t), do: t |> left |> up

  def all_adjacent(t) do
    all_adjacent_funcs()
    |> Enum.reduce(MapSet.new, fn slide_direction, coord_set ->
      MapSet.put(coord_set, slide_direction.(t))
    end)
  end

  def all_adjacent_and_original(t) do
    t
    |> all_adjacent
    |> MapSet.put(t)
  end

  def get_offset({x1,y1}, {x2,y2}), do: {x2-x1, y2-y1}
  def apply_offset({x1,y1}, {x2,y2}), do: {x2+x1, y2+y1}

  def m_distance({x1,y1}, {x2,y2}), do: abs(x1-x2) + abs(y1-y2)

  def cardinal_funcs, do: [&up/1, &down/1, &left/1, &right/1]
  def diagonal_funcs, do: [&right_up/1, &right_down/1, &left_down/1, &left_up/1]
  def all_adjacent_funcs, do: cardinal_funcs() ++ diagonal_funcs()
end