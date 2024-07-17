defmodule InkFlier.Line do
  @moduledoc """
  Functions for working with Lines and determining intersections

  Code in this module adapted from [Check if two line segments intersect](https://www.geeksforgeeks.org/check-if-two-given-line-segments-intersect) article, by Ansh Riyal
  """

  alias InkFlier.Coord

  @doc """
  Find the orientation of an ordered triplet of coordinates (p, q, r)

  See [Orientation of 3 ordered points](https://www.geeksforgeeks.org/orientation-3-ordered-points/amp) for details of formula

  ## Examples
      Clockwise
      .a....b...
      ........c.

      Counterclockwise
      ....c.....
      .a....b...

      Collinear
      .a....b..c....
  """
  @spec orientation(Coord.t, Coord.t, Coord.t) :: :clockwise | :counterclockwise | :collinear
  def orientation({px, py}, {qx, qy}, {rx, ry}) do
    val = (qy - py) * (rx - qx) - (qx - px) * (ry - qy)

    cond do
      val > 0 -> :clockwise
      val < 0 -> :counterclockwise
      val == 0 -> :collinear
    end
  end

  @doc """
  Given three collinear points p, q, r, check if point q lies on line segment 'pr'
  """
  @spec on_segment?(Coord.t, Coord.t, Coord.t) :: boolean
  def on_segment?({px, py}, {qx, qy}, {rx, ry}) do
    if (qx <= max(px, rx)) and
       (qx >= min(px, rx)) and
       (qy <= max(py, ry)) and
       (qy >= min(py, ry)) do
      true
    else
      false
    end
  end
end
