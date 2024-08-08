defmodule InkFlier.Round do
  alias InkFlier.Board
  alias InkFlier.Player
  alias InkFlier.RaceTrack

  @type t :: :"TODO this t just becomes typedstruct prob"
  @type reply :: {t, [instruction]}
  @type instruction :: {:notify_room, room_instruction}
  @type room_instruction ::
      {:new_round, integer}
      | {:player_position, Game.player_id, %{coord: Coord.t, speed: integer}}


  # @spec new(integer, Board.t, RaceTrack.t) :: reply
  # def new(round_number, current_board, track) do
  #   instructions = [{:notify_room, {:new_round, round_number}}]

  # end
end
