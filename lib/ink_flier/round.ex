defmodule InkFlier.Round do
  alias InkFlier.Board

  @type t :: :"TODO this t just becomes typedstruct prob"
  @type reply :: {t, [instruction]}
  @type instruction :: {:notify_room, room_instruction}
  @type room_instruction ::
      {:new_round, integer}
      | {:player_position, Game.player_id, %{coord: Coord.t, speed: integer}}


  @spec new(Board.t, integer) :: reply
  def new(current_board, round_number) do
    {:TODO,
      for player <- Board.players(current_board) do
      {:notify_room, {:player_position, player, %{
        coord: Board.current_position(current_board, player),
        speed: Board.speed(current_board, player),
      }}}
      end
      |> prepend({:notify_room, {:new_round, round_number}})
    }
  end

  def move(_t, _player, _destination) do
    {:TODO,
      [
        {:notify_room, {:player_locked_in, :b}},
        {:notify_player, :b, {:speed, 1}}
      ]
    }
  end

  defp prepend(list, item), do: [item | list]
end
