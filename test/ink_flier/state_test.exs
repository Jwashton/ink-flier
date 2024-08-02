defmodule InkFlierTest.State do
  use ExUnit.Case

  alias InkFlierTest.Helpers
  alias InkFlier.Game.State

  test "Move car" do
    assert [:a, :b]
    |> State.new(Helpers.test_track)
    |> State.move(:a, {99,99})
    |> State.current_positions
    |> Map.get(:a) == {99,99}
  end
end
