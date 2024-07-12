defmodule InkFlierTest.Helpers do

  def test_track do
    struct!(InkFlier.RaceTrack,
      inner_wall: [{0,0}, {10,0}, {10,10}, {0,10}, {0,0}],
      outer_wall: [{-5,-5}, {15,-5}, {15,15}, {-5,15}, {-5,-5}],
      start_line: {{0,0}, {-5,-5}},
      checkline_1: {{10,0}, {15,-5}},
      checkline_2: {{10,10}, {15,15}}
    )
  end
end
