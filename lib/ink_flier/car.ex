defmodule InkFlier.Car do
  use TypedStruct

  alias InkFlier.Coord

  typedstruct enforce: true do
    field :position, Coord.t
    field :previous_position, Coord.t
  end

  def new(start_coord), do: struct!(__MODULE__, position: start_coord, previous_position: start_coord)

  def legal_moves(t) do
    t
    |> target
    |> Coord.all_adjacent_and_original
  end

  def move(t, new_coord), do: %{t | position: new_coord, previous_position: t.position}

  def speed(t), do: Coord.m_distance(t.previous_position, t.position)

  def target(t) do
    momentum = Coord.get_offset(t.previous_position, t.position)
    Coord.apply_offset(t.position, momentum)
  end
end
