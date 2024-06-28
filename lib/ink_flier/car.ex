defmodule InkFlier.Car do
  alias InkFlier.Coord

  defstruct position: nil, previous_position: nil

  def new(start_coord), do: struct!(__MODULE__, position: start_coord, previous_position: start_coord)

  def legal_moves(t) do
    t.position
    |> Coord.all_adjacent
    |> MapSet.put(t.position)
  end

  def target(t) when t.position == t.previous_position, do: t.position
end
