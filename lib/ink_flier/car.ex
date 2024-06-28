defmodule InkFlier.Car do
  alias InkFlier.Coord

  defstruct position: nil, previous_position: nil

  def new(start_coord), do: struct!(__MODULE__, position: start_coord, previous_position: start_coord)

  def legal_moves(t) do
    t
    |> target
    |> Coord.all_adjacent_and_original
  end

  def move(t, new_coord), do: %{t | position: new_coord, previous_position: t.position}

  def target(t) when t.position == t.previous_position, do: t.position
  def target(t) do
    momentum = Coord.get_offset(t.previous_position, t.position)
    Coord.apply_offset(t.position, momentum)
  end
end
