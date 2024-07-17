defmodule InkFlierTest.RaceTrack do
  use ExUnit.Case

  alias InkFlierTest.Helpers
  alias InkFlier.RaceTrack

  test "Check for collisions" do
    t = Helpers.test_track

    # assert RaceTrack.check_collision(t, :TODO) = :ok
    assert RaceTrack.check_collision(t, {14,14}, {99,99}) == {:collision, :outer_wall}
  end

  # # TODO does clipping the cornor on the exact point count? I think so
  # assert RaceTrack.check_collision(t, {11,9}, {9,11}) = {:collision, :inner_wall}
end
