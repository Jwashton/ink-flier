defmodule InkFlier.Round.Instruction do
  alias InkFlier.Round
  alias InkFlier.Board
  # TODO not actually t, t = Instructions
  #   but I'm pretty sure this is going to merge with Instructions which isn't doing much except concatenating lists

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
  def player_locked_in(t, player) do
    # TODO next continue converting things. Round calling -> .player_locked_in here, converting these replys to Instructions list
    reply
    |> Reply.add_instruction({:notify_room, {:player_locked_in, player}})
    |> Reply.add_instruction(&{:notify_player, player, {:ok, {:speed, Round.speed(&1, player)}}})
  end

  def new_round(t, round_number) do
    Instructions.add_instruction(t, {:notify_room, {:new_round, round_number}})
  end

  def send_summary(t, board, :all) do
    add_instruction_for_each_player_position(t, board, &Instructions.add_instruction(&2, {:notify_room, &1}))
  end

  def send_summary(t, board, member) do
    add_instruction_for_each_player_position(t, board, &Instructions.add_instruction(&2, {:notify_member, member, &1}))
  end


  defp add_instruction_for_each_player_position(t, board, instruction_func) do
    for player <- Board.players(board) do
      {:player_position, player, %{
        coord: Board.current_position(board, player),
        speed: Board.speed(board, player),
      }}
    end
    |> Enum.reduce(reply, instruction_func)
  end
end
