defmodule InkFlierWeb.LobbyController do
  use InkFlierWeb, :controller

  alias InkFlier.RaceTrack
  # alias InkFlier.Lobby

  plug :assign, scripts: ["/assets/js/lobby_channel.js"]

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

  # def home(conn, %{"create" => _track_id_string} = params) do
  #   params = Map.delete(params, "create")
  #   game = Game.new(conn.assigns.user)
  #   {:ok, _game_id} = Lobby.add_game(game)

  #   redirect(conn, to: ~p"/lobby?#{params}")
  # end

  def home(conn, _params) do
    conn
    |> assign(:tracks, @tracks)
    # |> assign_games
    |> render(:home)
  end


  # defp assign_games(conn) do
  #   Lobby.games
  #   |> Enum.sort_by(&elem(&1, 0), :desc)
  #   |> then(& assign(conn, :games, &1) )
  # end
end
