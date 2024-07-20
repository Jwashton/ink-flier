defmodule InkFlierTest.Line do
  use ExUnit.Case

  alias InkFlier.Line

  describe "intersect?/2" do
    test "X-shape lines" do
      assert Line.intersect?(
        Line.new({10,0}, {0,10}),
        Line.new({0,0}, {10,10}))
    end

    test "parallel lines" do
      refute Line.intersect?(
        Line.new({1,1}, {10,1}),
        Line.new({1,2}, {10,2}))
    end

    test "2 unconnected segments on the same slope" do
      refute Line.intersect?(
        Line.new({-5,-5}, {0,0}),
        Line.new({1,1}, {10,10}))
    end

    test "2 connected segments on the same slope" do
      assert Line.intersect?(
        Line.new({0,0}, {10,0}),
        Line.new({5,0}, {15,0}))
    end

    test "T-shape (touching right on end of line)" do
      assert Line.intersect?(
        Line.new({0,0}, {10,0}),
        Line.new({10,10}, {10,-10}))
    end

    test "Unconnected but very close to line tip & diagonally hanging above it" do
      refute Line.intersect?(
        Line.new({0,0}, {10,0}),
        Line.new({9,11}, {11,9}))
    end
  end

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
