defmodule InkFlierTest.Helpers do
  alias InkFlier.RaceTrack

  def test_track do
    RaceTrack.new(
      start: [{0,0}, {-1,-1}, {-2,-2}, {-3,-3}, {-4,-4}, {-5,-5}],
      check1: {{10,0}, {15,-5}},
      check2: {{10,10}, {15,15}},
      goal: {{0,0}, {-5,-5}},
      obstacles: MapSet.new([
        RaceTrack.new_obstacle("Inner Wall", [{0,0}, {10,0}, {10,10}, {0,10}, {0,0}]),
        RaceTrack.new_obstacle("Outer Wall", [{-5,-5}, {15,-5}, {15,15}, {-5,15}, {-5,-5}]),
      ])
    )
  end
end
