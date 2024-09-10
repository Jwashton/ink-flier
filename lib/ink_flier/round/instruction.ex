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
    {round, instructions} = reply
    instructions =
      instructions
      |> Kernel.++([{:notify_room, {:player_locked_in, player}}])
      |> Kernel.++([{:notify_player, player, {:ok, {:speed, Round.speed(round, player)}}}])

    {round, instructions}
  end

  def new_round(reply, round_number) do
    {round, instructions} = reply
    instructions =
      instructions
      |> Kernel.++([{:notify_room, {:new_round, round_number}}])

    {round, instructions}
  end

  def send_summary(reply, :all) do
    {round, instructions} = reply
    board = Round.start_of_round_board(round)

    inners =
      for player <- Board.players(board) do
        {:player_position, player, %{
          coord: Board.current_position(board, player),
          speed: Board.speed(board, player),
        }}
      end

    instructions =
      inners
      |> Enum.reduce(instructions, fn inner, new_instructions ->
        Kernel.++(new_instructions, [{:notify_room, inner}])
      end)

    {round, instructions}
  end

  def send_summary(reply, member) do
    add_instruction_for_each_player_position(reply, &Reply.add_instruction(&2, {:notify_member, member, &1}))
  end


  defp add_instruction_for_each_player_position(reply, instruction_func) do
    {round, _instruction} = reply
    board = Round.start_of_round_board(round)

    for player <- Board.players(board) do
      {:player_position, player, %{
        coord: Board.current_position(board, player),
        speed: Board.speed(board, player),
      }}
    end
    |> Enum.reduce(reply, instruction_func)
  end
end
