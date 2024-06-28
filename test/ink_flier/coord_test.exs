defmodule InkFlierTest.Coord do
  use ExUnit.Case

  alias InkFlier.Coord

  test "Basic shift up, using normal up/right coord direction" do
    assert {1,1} |> Coord.up == {1,2}
  end

  test "Get all_adjacent" do
    assert Coord.all_adjacent({2,2}) == MapSet.new([
      {1,1},
      {1,2},
      {1,3},

      {2,1},
      {2,3},

      {3,1},
      {3,2},
      {3,3},
    ])
  end

  test "Offset between 2 coords" do
    assert Coord.get_offset({1,1}, {3,1}) == {2,0}
    assert Coord.get_offset({3,3}, {1,1}) == {-2,-2}
  end

  test "Apply offset to a coord" do
    assert Coord.apply_offset({1,1}, {2,-1}) == {3,0}
  end
end
