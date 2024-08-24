defmodule InkFlier.Board do
  @moduledoc """
  Abstraction for tracking players and their current car position
  """
  use TypedStruct
  import TinyMaps

  alias InkFlier.Game
  alias InkFlier.Car
  alias InkFlier.Coord
  alias InkFlier.HouseRules
  alias InkFlier.RaceTrack

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
    field :track, RaceTrack.t
  end

  @doc "Create a new board"
  @spec new([Game.player_id], RaceTrack.t) :: t
  @spec new([Game.player_id], RaceTrack.t, HouseRules.random_pole_position?) :: t
  def new(players, track, random_pole_position? \\ false), do:
    new(players, track, random_pole_position?, &Enum.shuffle/1)

  @doc false
  def new(players, track, random_pole_position?, randomizer_func) do
    positions =
      players
      |> players_in_order(random_pole_position?, randomizer_func)
      |> Enum.zip(RaceTrack.start(track))
      |> Enum.map(&coord_to_car_tuple/1)
      |> Map.new
    struct!(__MODULE__, ~M{track, players, positions})
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


  @doc "Get all original players minus any who crashed or resigned"
  @spec remaining_players(t) :: [Game.player_id]
  def remaining_players(t), do: t.players |> Enum.reject(&MapSet.member?(t.crashed, &1))

  @doc "Get players in given order"
  def players(t), do: t.players

  @doc """
  Moves a player and announces wether a crash occured

  Only notifies about collisions. The move IS always preformed, even if it results in a crash

  Actual illegal attempted moves, such as wrong speed or going not-on-your-turn, are checked elsewhere
  """
  @spec move(t, Game.player_id, Coord.t) :: {:ok, t} | {RaceTrack.collision_notification, t}
  def move(t, player, coord) do
    t = force_move(t, player, coord)

    case RaceTrack.check_collision(t.track, t.positions[player]) do
      :ok -> {:ok, t}
      {:collision, _} = collision_notification -> {collision_notification, crash(t, player)}
    end
  end


  defp coord_to_car_tuple({player, coord}), do: {player, Car.new(coord)}
  defp car_to_coord_tuple({player, car}), do: {player, Car.position(car)}

  defp players_in_order(players, _random_pole_position? = false, _), do: players
  defp players_in_order(players, _random_pole_position? = true, randomizer_func), do: randomizer_func.(players)


  def speed(t, player), do: t.positions[player] |> Car.speed
  def legal_move?(t, player, coord), do: t.positions[player] |> Car.legal_move?(coord)

  @doc "Move the player without checking for crashes"
  @spec force_move(t, Game.player_id, Coord.t) :: t
  def force_move(t, player, coord), do: t.positions[player] |> update_in(&Car.move(&1, coord))
  @doc false
  def crash(t, player), do: update_in(t.crashed, &MapSet.put(&1, player))
end
