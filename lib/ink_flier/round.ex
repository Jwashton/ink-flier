defmodule InkFlier.Round do
  @moduledoc """
  Abstraction for a single round of the game

  It tracks who has & hasn't locked in, and manages moves on the new board for this round

  Produces lists of instructions for notifying players (or the entire room) of events
  like "a player locked in" or "the round ended"
  """
  use TypedStruct

  alias InkFlier.Game
  alias InkFlier.Board

  @type reply :: {t, [instruction]}

  @type instruction ::
      {:notify_room, room_instruction} |
      {:notify_player, Game.player_id, player_instruction}

  @type room_instruction ::
      {:new_round, integer} |
      {:player_position, Game.player_id, %{coord: Coord.t, speed: integer}} |
      {:player_locked_in, Game.player_id}

  @type player_instruction ::
      {:speed, integer} |
      {:error, :illegal_destination}

  typedstruct enforce: true do
    field :board, Board.t
    field :locked_in, MapSet.t(Game.player_id), default: MapSet.new
  end

  @doc "Build a new round and initial notification instructions"
  @spec new(Board.t, integer) :: reply
  def new(current_board, round_number) do
    t = struct!(__MODULE__, board: current_board)

    instructions =
      for player <- Board.players(current_board) do
        {:notify_room, {:player_position, player, %{
          coord: Board.current_position(current_board, player),
          speed: Board.speed(current_board, player),
        }}}
      end
      |> prepend({:notify_room, {:new_round, round_number}})

    {t, instructions}
  end

  @doc false
  def move({t, _previous_instructions}, player, destination), do: move(t, player, destination)

  @doc """
  Attempt to move a player in the current round

  This is the main function of the game

  Many replies to an attempted move are possible. They are listed in the `t:reply/0` type.
  Some examples:
  - "Normal move that was sucessful"
  - "Normal move by final player, so round ends"
  - "Illegal move, attempted to move too far"
  - "Illegal move, this player already locked in"
  """
  @spec move(t, Game.player_id, Coord.t) :: reply
  def move(t, player, destination) do
    if t.board |> Board.legal_move?(player, destination) do
      t =
        t
        |> do_move(player, destination)
        |> lock_in(player)

      instructions =
        [
          {:notify_room, {:player_locked_in, player}},
          {:notify_player, player, {:speed, speed(t, player)}}
        ]

      {t, instructions}
    else
      instructions =
        [
          {:notify_player, player, {:error, :illegal_destination}}
        ]

      {t, instructions}
    end
  end


  defp prepend(list, item), do: [item | list]


  @doc false
  def upcomming_move(t, player), do: t.board |> Board.current_position(player)
  defp speed(t, player), do: t.board |> Board.speed(player)

  defp do_move(t, player, destination), do: update_in(t.board, &Board.move(&1, player, destination))
  defp lock_in(t, player), do: update_in(t.locked_in, &MapSet.put(&1, player))
end
