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
  The main function which returns true if the line segments (a & b) intersect
  """
  @spec intersect?(t, t) :: boolean
  def intersect?({ap, aq} = _a, {bp, bq} = _b) do
    o1 = orientation(ap, aq, bp)
    o2 = orientation(ap, aq, bq)
    o3 = orientation(bp, bq, ap)
    o4 = orientation(bp, bq, aq)

    cond do
      (o1 != o2) and (o3 != o4) -> true

      o1 == :collinear and on_segment?(ap, bp, aq) -> true
      o2 == :collinear and on_segment?(ap, bq, aq) -> true
      o3 == :collinear and on_segment?(bp, ap, bq) -> true
      o4 == :collinear and on_segment?(bp, aq, bq) -> true

      true -> false
    end
  end

  @doc """
  Find the orientation of an ordered triplet of coordinates (p, q, r)

  See [Orientation of 3 ordered points](https://www.geeksforgeeks.org/orientation-3-ordered-points/amp) for details of formula

  ## Examples
      Clockwise
      .p....q...
      ........r.

      Counterclockwise
      ....r.....
      .p....q...

      Collinear
      .p....q..r....
  """
  @spec orientation(Coord.t, Coord.t, Coord.t) :: :clockwise | :counterclockwise | :collinear
  def orientation({px, py} = _p, {qx, qy} = _q, {rx, ry} = _r) do
    val = (qy - py) * (rx - qx) - (qx - px) * (ry - qy)

    cond do
      val > 0 -> :clockwise
      val < 0 -> :counterclockwise
      val == 0 -> :collinear
    end
  end

  @doc """
  Given three collinear points p, q, r, check if point q lies on line segment 'pr'

  - Will return unpredictable results if the points AREN'T collinear
  - eg. If given `p=(1,1) q=(2,2) r=(5,3)`, this returns true even though they are NOT all on a segment. However
  they also aren't collinear, so as stated above, are not meant to be given to this function
  """
  @spec on_segment?(Coord.t, Coord.t, Coord.t) :: boolean
  def on_segment?({px, py} = _p, {qx, qy} = _q, {rx, ry} = _r) do
    qx <= max(px, rx) and
    qx >= min(px, rx) and
    qy <= max(py, ry) and
    qy >= min(py, ry)
  end
end
