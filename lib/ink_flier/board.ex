defmodule InkFlier.Board do
  alias InkFlier.Game
  alias InkFlier.Car

  @type t :: %{Game.player_id => Car.t}

  def new(players, track_start_coords, random_pole_position?) do
    players
    |> players_in_order(random_pole_position?)
    |> Enum.zip(track_start_coords)
    |> Enum.map(&coord_to_car_tuple/1)
    |> Map.new
  end

  def current_positions(t) do
    t
    |> Enum.map(&car_to_coord_tuple/1)
    |> Map.new
  end



  defp coord_to_car_tuple({player, coord}), do: {player, Car.new(coord)}
  defp car_to_coord_tuple({player, car}), do: {player, Car.position(car)}

  defp players_in_order(players, random_pole_position?)
  # TODO
  # defp players_in_order(players, true), do: ...
  defp players_in_order(players, false), do: players


  def speed(t, player), do: t[player] |> Car.speed
  def legal_move?(t, player, coord), do: t[player] |> Car.legal_move?(coord)
end
