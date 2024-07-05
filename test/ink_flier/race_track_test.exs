defmodule InkFlierTest.RaceTrack do
  use ExUnit.Case

  alias InkFlier.RaceTrack

  @track struct!(RaceTrack,
    inner_wall: [{0,0}, {10,0}, {10,10}, {0,10}, {0,0}],
    outer_wall: [{-5,-5}, {15,-5}, {15,15}, {-5,15}, {-5,-5}],
    start_line: {{0,0}, {-5,-5}},
    checkline_1: {{10,0}, {15,-5}},
    checkline_2: {{10,10}, {15,15}}
  )

  test "TODO" do
  end
end
