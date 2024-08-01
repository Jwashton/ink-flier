defmodule InkFlierTest.Game do
  use ExUnit.Case

  alias InkFlierTest.Helpers
  alias InkFlier.Game

  test "start" do
    assert {:ok, _pid} = Game.start_link([:a, :b], Helpers.test_track, self())
    assert_receive {:starting_positions, %{a: {-1,-1}, b: {-2,-2}}}
  end

  # test "move" do
  # end

  # test "resign" do
  # end
  # test "get_current_game_state" do
  # end
end
