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

  def crash(player, destination, obstacle_name_set) do
    {:notify_room, {:crash, player, destination, obstacle_name_set}}
  end

  def error(player, msg) do
    {:notify_player, player, {:error, msg}}
  end

  def new_round(round_number, :all), do: {:notify_room, {:new_round, round_number}}
  def new_round(round_number, member), do: {:notify_member, member, {:new_round, round_number}}

  def end_of_round(round_number), do: {:end_of_round, round_number}

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
