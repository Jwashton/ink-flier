defmodule InkFlierTest.Line do
  use ExUnit.Case

  alias InkFlier.Line

  describe "Orientation" do
    test "Clockwise" do
      # .a....b...
      # ........c.
      a = {0,0}
      b = {10,0}
      c = {11,-1}

      assert Line.orientation(a,b,c) == :clockwise
    end

    test "Counterclockwise" do
      # ....c.....
      # .a....b...
      a = {0,0}
      b = {10,0}
      c = {8,1}

      assert Line.orientation(a,b,c) == :counterclockwise
    end

    test "Collinear" do
      # .a....b..c....
      a = {0,0}
      b = {10,0}
      c = {15,0}

      assert Line.orientation(a,b,c) == :collinear

    end
  end
end
