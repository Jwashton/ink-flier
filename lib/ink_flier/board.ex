defmodule InkFlier.Board do
  alias InkFlier.Game
  alias InkFlier.Car

  @type t :: %{Game.player_id => Car.t}

  def new(players, track_start_coords, random_pole_position?) do
    players
    |> players_in_order(random_pole_position?)
    |> Enum.zip(track_start_coords)
    |> Enum.map(&player_and_car_tuple/1)
    |> Map.new
  end

  def current_positions(t) do
    t
    |> Enum.map(fn {player, car} ->
      {player, Car.position(car)}
    end)
    |> Map.new
  end


  defp player_and_car_tuple({player, coord}), do: {player, Car.new(coord)}

  defp players_in_order(players, random_pole_position?)
  defp players_in_order(players, false), do: players
end
