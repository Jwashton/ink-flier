defmodule InkFlierTest.Car do
  use ExUnit.Case

  alias InkFlier.Car

  test "TODO" do
    assert Car.new({2,2}) |> Car.legal_moves == MapSet.new([
      {1,1},
      {1,2},
      {1,3},

      {2,1},
      {2,2},
      {2,3},

      {3,1},
      {3,2},
      {3,3},
    ])
  end
end
