defmodule InkFlierWeb.LobbyController do
  use InkFlierWeb, :controller
  # import TinyMaps

  alias InkFlier.RaceTrack

  @tracks %{
      1 => RaceTrack.new(
        start: [{-1,-1}, {-2,-2}, {-3,-3}, {-4,-4}],
        check1: {{10,0}, {15,-5}},
        check2: {{10,10}, {15,15}},
        goal: {{0,0}, {-5,-5}},
        obstacles: MapSet.new([
          RaceTrack.new_obstacle("Inner Wall", [{0,0}, {10,0}, {10,10}, {0,10}, {0,0}]),
          RaceTrack.new_obstacle("Outer Wall", [{-5,-5}, {15,-5}, {15,15}, {-5,15}, {-5,-5}]),
        ])
      ),
      2 => RaceTrack.new(
        start: [{-1,-1}, {-2,-2}, {-3,-3}, {-4,-4}],
        check1: {{10,0}, {15,-5}},
        check2: {{10,10}, {15,15}},
        goal: {{0,0}, {-5,-5}},
        obstacles: MapSet.new([
          RaceTrack.new_obstacle("Rock", [{0,0}, {1,0}, {1,1}, {0,1}, {0,0}]),
        ])
      ),
    }

#   def home(conn, ~m{create}) do
#     conn
#     |> assign(:tracks, @tracks)
#     |> render(:home, layout: false)
#   end

  def home(conn, _params) do
    conn
    |> assign(:tracks, @tracks)
    |> render(:home, layout: false)
  end
end
