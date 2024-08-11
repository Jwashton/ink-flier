defmodule InkFlier.Round do
  @moduledoc """
  Abstraction for a single round of the game

  It tracks who has & hasn't locked in, and manages moves on the new board for this round

  Produces lists of instructions for notifying players (or the entire room) of events
  like "a player locked in" or "the round ended"
  """
  use TypedStruct
  import TinyMaps

  alias __MODULE__.Reply
  alias InkFlier.Game
  alias InkFlier.Board

  @typedoc """
  An instruction to be processed by a parent module/process

  Notification targets may be:
  - The entire room
  - An individual player
  - A room "member": usually an observer that joined partway through, but possibly a player that d/c'd then reconnected
  - The parent module/process, recieving the end_of_round notice to start next round
  """
  @type instruction ::
      {:notify_room, room_notification} |
      {:notify_member, Game.member_id, room_notification} |
      {:notify_player, Game.player_id, player_notification} |
      {:end_of_round, round_number}

  @type room_notification ::
      {:new_round, round_number} |
      {:player_position, Game.player_id, %{coord: Coord.t, speed: integer}} |
      {:player_locked_in, Game.player_id}

  @type player_notification ::
      {:speed, integer} |
      {:error, :illegal_destination} |
      {:error, :already_locked_in}

  @type round_number :: integer

  typedstruct enforce: true do
    field :board, Board.t
    field :locked_in, MapSet.t(Game.player_id), default: MapSet.new
    field :round_number, round_number
  end

  @doc "Build a new round and initial notification instructions"
  @spec new(Board.t, round_number) :: Reply.t
  def new(current_board, round_number) do
    struct!(__MODULE__, ~M{round_number, board: current_board})
    |> Reply.add_instruction({:notify_room, {:new_round, round_number}})
    |> Reply.add_instruction(player_position_notifications(current_board))
  end

  @doc """
  Attempt to move a player in the current round

  This is the main function of the game

  Many responses to an attempted move are possible. They are listed in the `t:instruction/0` type.
  Some examples:
  - "Normal move that was sucessful"
  - "Normal move by final player, so round ends"
  - "Illegal move, attempted to move too far"
  - "Illegal move, this player already locked in"
  """
  @spec move(t, Game.player_id, Coord.t) :: Reply.t
  def move(t, player, destination) do
    with :ok <- check_legal_move(t, player, destination),
         :ok <- check_not_already_locked_in(t, player) do
      t
      |> Reply.update_round(&do_move(&1, player, destination))
      |> Reply.update_round(&lock_in(&1, player))
      |> Reply.add_instruction({:notify_room, {:player_locked_in, player}})
      |> Reply.add_instruction(&{:notify_player, player, {:speed, speed(&1, player)}})
      |> maybe_end_round
    end
  end


  defp check_legal_move(t, player, destination) do
    if Board.legal_move?(t.board, player, destination), do: :ok, else: reply_error(t, player, :illegal_destination)
  end

  defp check_not_already_locked_in(t, player) do
    unless locked_in?(t, player), do: :ok, else: reply_error(t, player, :already_locked_in)
  end


  defp player_position_notifications(board) do
    for player <- Board.players(board) do
      {:notify_room, {:player_position, player, %{
        coord: Board.current_position(board, player),
        speed: Board.speed(board, player),
      }}}
    end
  end

  defp maybe_end_round({t, _} = reply) do
    unless all_locked_in?(t), do: reply, else: reply |> Reply.add_instruction({:end_of_round, t.round_number})
  end

  defp locked_in?(t, player), do: player in t.locked_in

  defp all_locked_in?(t), do: MapSet.equal?(t.locked_in, players_set(t))

  defp reply_error(t, player, msg), do: Reply.add_instruction(t, {:notify_player, player, {:error, msg}})

  defp players_set(t), do: t.board |> Board.players |> MapSet.new


  @doc false
  def upcomming_move(t, player), do: t.board |> Board.current_position(player)
  defp speed(t, player), do: t.board |> Board.speed(player)

  defp do_move(t, player, destination), do: update_in(t.board, &Board.move(&1, player, destination))
  defp lock_in(t, player), do: update_in(t.locked_in, &MapSet.put(&1, player))
end
