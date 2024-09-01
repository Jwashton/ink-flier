defmodule InkFlier.Round.Instruction do
  alias InkFlier.Round
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
end
