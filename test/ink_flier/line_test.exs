defmodule InkFlierTest.Line do
  use ExUnit.Case

  alias InkFlier.Line

  describe "Orientation" do
    test "Clockwise" do
      [a,b,c] = [{0,0}, {10,0}, {11,-1}]
      assert Line.orientation(a,b,c) == :clockwise
    end

    test "Counterclockwise" do
      [a,b,c] = [{0,0}, {10,0}, {8,1}]
      assert Line.orientation(a,b,c) == :counterclockwise
    end

    test "Collinear" do
      [a,b,c] = [{0,0}, {10,0}, {15,0}]
      assert Line.orientation(a,b,c) == :collinear
    end
  end
end
