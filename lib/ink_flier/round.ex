defmodule InkFlier.Round do
  use TypedStruct

  alias InkFlier.Game
  alias InkFlier.Board

  @type reply :: {t, [instruction]}
  @type instruction :: {:notify_room, room_instruction}
  @type room_instruction ::
      {:new_round, integer}
      | {:player_position, Game.player_id, %{coord: Coord.t, speed: integer}}

  typedstruct enforce: true do
    field :board, Board.t
    field :locked_in, MapSet.t(Game.player_id), default: MapSet.new
  end

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

  def move(t, player, destination) do
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
  end


  defp prepend(list, item), do: [item | list]


  @doc false
  def upcomming_move(t, player), do: t.board |> Board.current_position(player)
  defp speed(t, player), do: t.board |> Board.speed(player)

  defp do_move(t, player, destination), do: update_in(t.board, &Board.move(&1, player, destination))
  defp lock_in(t, player), do: update_in(t.locked_in, &MapSet.put(&1, player))
end
