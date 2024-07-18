defmodule InkFlier.Line do
  @moduledoc """
  Functions for working with line segments and determining intersections

  Code in this module adapted from [Check if two line segments intersect](https://www.geeksforgeeks.org/check-if-two-given-line-segments-intersect) article, by Ansh Riyal
  """

  alias InkFlier.Coord

  @type t :: {Coord.t, Coord.t}

  @spec new(Coord.t, Coord.t) :: t
  def new(p, q), do: {p, q}

  @doc """
  The main function which returns true if the line segments intersect
  """
  @spec intersect?(t, t) :: boolean
  # TODO change p1 to px, etc
  def intersect?({p1, q1}, {p2, q2}) do
    o1 = orientation(p1, q1, p2)
    o2 = orientation(p1, q1, q2)
    o3 = orientation(p2, q2, p1)
    o4 = orientation(p2, q2, q1)

    cond do
      # General case
      (o1 != o2) and (o3 != o4) -> true

      # Special Cases

      # p1, q1 and p2 are collinear and p2 lies on segment p1q1
      (o1 == :collinear) and on_segment?(p1, p2, q1) -> true

      # p1 , q1 and q2 are collinear and q2 lies on segment p1q1
      (o2 == 0) and on_segment?(p1, q2, q1) -> true

      # p2 , q2 and p1 are collinear and p1 lies on segment p2q2
      (o3 == 0) and on_segment?(p2, p1, q2) -> true

      # p2 , q2 and q1 are collinear and q1 lies on segment p2q2
      (o4 == 0) and on_segment?(p2, q1, q2) -> true

      true -> false
    end

  end

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
