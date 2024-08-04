defmodule InkFlierTest.Game do
  use ExUnit.Case

  alias InkFlierTest.Helpers
  alias InkFlier.Game

  test "Move car" do
    assert [:a, :b]
    |> Game.new(Helpers.test_track)
    |> Game.move(:a, {99,99})
    |> Game.current_positions
    |> Map.get(:a) == {99,99}
  end
end
