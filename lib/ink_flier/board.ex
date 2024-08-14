defmodule InkFlier.Board do
  @moduledoc """
  Abstraction for tracking players and their current car position
  """
  use TypedStruct

  alias InkFlier.Game
  alias InkFlier.Car
  alias InkFlier.Coord
  alias InkFlier.HouseRules

  @typedoc """
  All players who started the game

  Their cars will still show on board even if they crash or disconect and never leave starting position

  Original given order is maintained, which is sometimes useful for things like starting position priority
  """
  @type starting_players :: [Game.player_id]

  typedstruct enforce: true do
    field :positions, %{Game.player_id => Car.t}
    field :players, starting_players
    field :crashed, MapSet.t(Game.player_id), default: MapSet.new
  end

  @doc "Create a new board"
  @spec new([Game.player_id], RaceTrack.start) :: t
  @spec new([Game.player_id], RaceTrack.start, HouseRules.random_pole_position?) :: t
  def new(players, track_start_coords, random_pole_position? \\ false), do:
    new(players, track_start_coords, random_pole_position?, &Enum.shuffle/1)

  @doc false
  def new(players, track_start_coords, random_pole_position?, randomizer_func) do
    struct!(__MODULE__, players: players, positions:
      players
      |> players_in_order(random_pole_position?, randomizer_func)
      |> Enum.zip(track_start_coords)
      |> Enum.map(&coord_to_car_tuple/1)
      |> Map.new
    )
  end

  @doc "Get each player's current car positon"
  @spec current_positions(t) :: %{Game.player_id => Coord.t}
  def current_positions(t) do
    t.positions
    |> Enum.map(&car_to_coord_tuple/1)
    |> Map.new
  end

  @doc "Get one player's current car positon"
  @spec current_position(t, Game.player_id) :: Coord.t
  def current_position(t, player) do
    t
    |> current_positions
    |> Map.get(player)
  end

  @doc "Add a player to the list of crashed cars"
  @spec crash(t, Game.player_id) :: t
  def crash(t, player), do: update_in(t.crashed, &MapSet.put(&1, player))

  @doc "Get all original players minus any who crashed or resigned"
  @spec remaining_players(t) :: [Game.player_id]
  def remaining_players(t), do: t.players |> Enum.reject(&MapSet.member?(t.crashed, &1))

  @doc "Get players in given order"
  def players(t), do: t.players


  defp coord_to_car_tuple({player, coord}), do: {player, Car.new(coord)}
  defp car_to_coord_tuple({player, car}), do: {player, Car.position(car)}

  defp players_in_order(players, _random_pole_position? = false, _), do: players
  defp players_in_order(players, _random_pole_position? = true, randomizer_func), do: randomizer_func.(players)


  def speed(t, player), do: t.positions[player] |> Car.speed
  def legal_move?(t, player, coord), do: t.positions[player] |> Car.legal_move?(coord)

  def move(t, player, coord), do: t.positions[player] |> update_in(&Car.move(&1, coord))
end
