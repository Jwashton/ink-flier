defmodule InkFlier.Round.Instruction do
  alias InkFlier.Round
  alias InkFlier.Board
  alias InkFlier.Round.Reply

  @doc """
  Instructions after locking in a player

  ## Examples
      iex> {_round, instructions} =
      ...> Round.new(board, round_number) |>
      ...> Round.move(:player_1, valid_destination)
      iex> instructions
      [
        {:notify_room, {:player_locked_in, :player_1}},
        {:notify_player, :player_1, {:ok, {:speed, 1}}}
      ]

  """
  def player_locked_in(reply, player) do
    reply
    |> Reply.add_instruction({:notify_room, {:player_locked_in, player}})
    |> Reply.add_instruction(&{:notify_player, player, {:ok, {:speed, Round.speed(&1, player)}}})
  end

  def new_round(reply, round_number) do
    reply
    |> Reply.add_instruction({:notify_room, {:new_round, round_number}})
  end

  def send_summary({round, _instructions}=reply, :all) do
    reply
    |> wrap_player_positions(Round.start_of_round_board(round), &Reply.add_instruction(&2, {:notify_room, &1}))
  end


  defp wrap_player_positions(reply, board, wrap_func) do
    board
    |> player_position_tuples
    |> Enum.reduce(reply, wrap_func)
  end

  defp player_position_tuples(board) do
    for player <- Board.players(board) do
      {:player_position, player, %{
        coord: Board.current_position(board, player),
        speed: Board.speed(board, player),
      }}
    end
  end
end
