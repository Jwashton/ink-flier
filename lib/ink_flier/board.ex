defmodule InkFlier.Board do
  @moduledoc """
  Abstraction for tracking players and their current car position
  """
  use TypedStruct

  alias InkFlier.Game
  alias InkFlier.Car
  alias InkFlier.Coord
  alias InkFlier.HouseRules

  typedstruct enforce: true do
    field :positions, %{Game.player_id => Car.t}
    field :players, [Game.player_id], default: []
  end

  @doc "Create a new board"
  @spec new([Game.player_id], [Coord.t]) :: t
  @spec new([Game.player_id], RaceTrack.start, HouseRules.random_pole_position?) :: t
  def new(players, track_start_coords, random_pole_position? \\ false), do:
    new(players, track_start_coords, random_pole_position?, &Enum.shuffle/1)

  @doc false
  def new(players, track_start_coords, random_pole_position?, randomizer_func) do
    players
    |> players_in_order(random_pole_position?, randomizer_func)
    |> Enum.zip(track_start_coords)
    |> Enum.map(&coord_to_car_tuple/1)
    |> Map.new
  end

  @doc "Get each player's current car positon"
  @spec current_positions(t) :: %{Game.player_id => Coord.t}
  def current_positions(t) do
    t
    |> Enum.map(&car_to_coord_tuple/1)
    |> Map.new
  end


  defp coord_to_car_tuple({player, coord}), do: {player, Car.new(coord)}
  defp car_to_coord_tuple({player, car}), do: {player, Car.position(car)}

  defp players_in_order(players, _random_pole_position? = false, _), do: players
  defp players_in_order(players, _random_pole_position? = true, randomizer_func), do: randomizer_func.(players)


  # def speed(t, player), do: t[player] |> Car.speed
  # def legal_move?(t, player, coord), do: t[player] |> Car.legal_move?(coord)

  # def move(t, player, coord), do: t[player] |> update_in(&Car.move(&1, coord))
end
