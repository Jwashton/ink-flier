defmodule InkFlierTest.Game do
  use ExUnit.Case

  alias InkFlier.Game
  # new
  #   - HouseRules
  # add players
  # select track
  # begin
  #   - player starting positions
  # *broadcast:
  #   %PlayerInfo?{
  #     player_1: %PlayerInfo{
  #       current_position: {1,1}
  #     }
  #     crash return?
  #     disconected return?
  #
  #
  #
  #
  #     current_positions:
  #     legal_moves: %{
  #       player_1: MapSet.new([{1,1}, {1,2}...]),
  #       player_2: MapSet.new([{1,1}, {1,2}...]),
  #     }
  #   }
  # move

  # try things in wrong phase and confirm error
  # move events:
  # - lock_in_move
  # - leave_game
  # - win
  # - crash?


  test "new game" do
    game = Game.new
    assert game |> Game.players == []
    assert game |> Game.track == nil
  end
end
