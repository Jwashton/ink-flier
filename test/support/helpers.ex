defmodule InkFlierTest.Helpers do

  def test_track do
    # TODO use RaceTrack.new

    start = {{0,0}, {-5,-5}}
    struct!(InkFlier.RaceTrack,
      inner_wall: [{0,0}, {10,0}, {10,10}, {0,10}, {0,0}],
      outer_wall: [{-5,-5}, {15,-5}, {15,15}, {-5,15}, {-5,-5}],
      start: start,
      check1: {{10,0}, {15,-5}},
      check2: {{10,10}, {15,15}},
      goal: start
    )
  end
end
