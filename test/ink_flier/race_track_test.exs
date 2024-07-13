defmodule InkFlierTest.RaceTrack do
  use ExUnit.Case

  alias InkFlier.RaceTrack

  test "new/1 can optionally take line as start, which should be converted into a coord list" do
    track = RaceTrack.new(start: {{0,0}, {-2,-2}})
    # assert track.start == [{0,0}, {-1,-1}, {-2,-2}]
  end
end
