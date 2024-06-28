defmodule InkFlierTest.Car do
  use ExUnit.Case

  alias InkFlier.Car

  test "Car.legal_moves/1" do
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

    # TODO These will be different if car has momentum (will need to use target)
  end

  describe "Car.target/1" do
    test "No-momentum car will target it's current position" do
      assert Car.new({1,1}) |> Car.target == {1,1}
    end

#     test "Target after 1 move with 1 momentum" do
#       car =
#         Car.new({1,1})
#         |> Car.move({2,1})
#       assert car |> Car.target == {3,1}
#     end

#     test "2 moves may have even more momentum" do
#       car =
#         Car.new({1,1})
#         |> Car.move({2,1})
#         |> Car.move({4,1})
#       assert car |> Car.target == {6,1}
#     end
  end
end
