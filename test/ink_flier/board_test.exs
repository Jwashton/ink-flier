defmodule InkFlierTest.Board do
  use ExUnit.Case

  alias InkFlierTest.Helpers
  alias InkFlier.Board

  test "new and start" do
    players = [:a, :b, :c]
    expected_positions = %{
      a: {0,0},
      b: {-1,-1},
      c: {-2,-2},
    }

    board =
      Helpers.test_track
      |> Board.new
      |> Board.start(players, false)

    assert board |> Board.current_positions == expected_positions
  end
end
