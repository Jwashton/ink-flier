defmodule InkFlier.Round.Instruction do
  alias InkFlier.Board

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
  def player_locked_in(player, speed) do
    [
      {:notify_room, {:player_locked_in, player}},
      {:notify_player, player, {:ok, {:speed, speed}}},
    ]
  end

  def new_round(round_number), do: {:notify_room, {:new_round, round_number}}

  def send_summary(board, :all) do
    for position <- positions(board), do: {:notify_room, position}
  end

  def send_summary(board, member) do
    for position <- positions(board), do: {:notify_member, member, position}
  end


  defp positions(board) do
    for player <- Board.players(board) do
      {:player_position, player, %{
        coord: Board.current_position(board, player),
        speed: Board.speed(board, player),
      }}
    end
  end
end
