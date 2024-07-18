defmodule InkFlierTest.Line do
  use ExUnit.Case

  alias InkFlier.Line

  describe "Orientation" do
    test "Clockwise" do
      assert Line.orientation({0,0}, {10,0}, {11,-1}) == :clockwise
    end

    test "Counterclockwise" do
      assert Line.orientation({0,0}, {10,0}, {8,1}) == :counterclockwise
    end

    test "Collinear" do
      assert Line.orientation({0,0}, {10,0}, {15,0}) == :collinear
    end
  end

  test "on_segment?/3" do
    assert Line.on_segment?({0,0}, {5,0}, {10,0})
    refute Line.on_segment?({0,0}, {15,0}, {10,0})
  end
end
