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
  alias __MODULE__.Instruction
  alias InkFlier.Game
  alias InkFlier.Board
  alias InkFlier.RaceTrack.Obstacle

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
      {:player_locked_in, Game.player_id} |
      crash_notification

  @type player_notification ::
      {:ok, {:speed, integer}} |
      {:error, :illegal_destination} |
      {:error, :already_locked_in}

  @type round_number :: integer
  @type crash_notification :: {:crash, Game.player_id, destination :: Coord.t, Obstacle.name_set}

  typedstruct enforce: true do
    field :board, Board.t
    field :start_of_round_board, Board.t
    field :locked_in, MapSet.t(Game.player_id), default: MapSet.new
    field :crashed_this_round, [crash_notification], default: []
    field :round_number, round_number
  end

  @doc "Build a new round and initial notification instructions"
  @spec new(Board.t, round_number) :: Reply.t
  def new(current_board, round_number) do
    t = struct!(__MODULE__, ~M{round_number, board: current_board, start_of_round_board: current_board})

    t
    |> Reply.add_instruction(Instruction.new_round(round_number, :all))
    |> Reply.add_instruction(Instruction.send_summary(t.start_of_round_board, :all))
  end

  @doc """
  Attempt to move a player in the current round

  This is the main function of the game

  Crashes aren't announced until end of round, after everyone (including the crasher) has locked in

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
      |> maybe_crash(player, destination)
      |> lock_in(player)
      |> Reply.add_instruction(&Instruction.player_locked_in(player, speed(&1, player)))
      |> maybe_end_round
    end
  end

  @doc """
  Ask for instructions to be sent to a room member, summarizing the current state of the round

  Useful if a new observing member joins the room or a current player d/c's and reconnects

  Given positions will be as-of round *beginning*. Wont reveal destination of players who
  happen to have already locked in and are still be waiting for the others (until start of next round,
  once *everyone* locked in)

  ## Example
      iex> {_round, instructions} = Round.summary(round, :observer_1)
      iex> instructions
      [
        {:notify_member, :observer_1, {:new_round, 7}},
        {:notify_member, :observer_1, {:player_position, :a, %{coord: {50,50}, speed: 7}}},
        {:notify_member, :observer_1, {:player_position, :b, %{coord: {99,99}, speed: 10}}},
      ]
  """
  @spec summary(t, Game.member_id) :: Reply.t
  def summary(t, member) do
    t
    |> Reply.add_instruction(Instruction.new_round(t.round_number, member))
    |> Reply.add_instruction(Instruction.send_summary(t.start_of_round_board, member))
  end


  defp check_legal_move(t, player, destination) do
    if Board.legal_move?(t.board, player, destination), do: :ok, else: reply_error(t, player, :illegal_destination)
  end

  defp check_not_already_locked_in(t, player) do
    unless locked_in?(t, player), do: :ok, else: reply_error(t, player, :already_locked_in)
  end


  defp maybe_crash(t, player, destination) do
    case Board.move(t.board, player, destination) do
      {:ok, new_board} -> put_in(t.board, new_board)

      {{:collision, obstacle_name_set}, new_board} ->
        put_in(t.board, new_board)
        |> update_crashed(&[Instruction.crash(player, destination, obstacle_name_set) | &1])
    end
  end

  defp update_crashed(t, func), do: update_in(t.crashed_this_round, func)

  defp add_crash_instructions({t, _instructions} = reply) do
    t.crashed_this_round
    |> Enum.reverse
    |> Enum.reduce(reply, &Reply.add_instruction(&2, &1))
  end

  defp maybe_end_round({t, _} = reply) do
    if all_locked_in?(t) do
      reply
      |> add_crash_instructions
      |> Reply.add_instruction({:end_of_round, t.round_number})
    else
      reply
    end
  end

  defp locked_in?(t, player), do: player in t.locked_in

  defp all_locked_in?(t), do: MapSet.equal?(t.locked_in, players_set(t))

  defp reply_error(t, player, msg), do: Reply.add_instruction(t, {:notify_player, player, {:error, msg}})

  defp players_set(t), do: t.board |> Board.players |> MapSet.new


  @doc false
  def board(t), do: t.board
  def start_of_round_board(t), do: t.start_of_round_board

  @doc false
  def upcomming_move(t, player), do: t.board |> Board.current_position(player)
  def speed(t, player), do: t.board |> Board.speed(player)

  defp lock_in(t, player), do: update_in(t.locked_in, &MapSet.put(&1, player))
end
