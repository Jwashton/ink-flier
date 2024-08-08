defmodule InkFlierTest.Round do
  use ExUnit.Case
  # import TinyMaps

  alias InkFlier.Round
  alias InkFlier.Board

  # setup do
  #   round = Round.new(1, [:a, :b], Helpers.test_track)
  #   ~M{round}
  # end

  test "new" do
    board = Board.new([:a, :b], [{-1,-1}, {-2,-2}, {-3,-3}, {-4,-4}])

    assert {_round, instructions} = Round.new(board, 1)
    assert instructions == [
      {:notify_room, {:new_round, 1}},
      {:notify_room, {:player_position, :a, %{coord: {-1,-1}, speed: 0}}},
      {:notify_room, {:player_position, :b, %{coord: {-2,-2}, speed: 0}}},
    ]
  end

  describe "move" do
    test "Normal valid move locks player in" do
      board = Board.new([:a, :b], [{-1,-1}, {-2,-2}, {-3,-3}, {-4,-4}])

      destination = {-1,-2}
      {round, instructions} =
        board
        |> Round.new(1)
        |> Round.move(:b, destination)

      assert instructions == [
        {:notify_room, {:player_locked_in, :b}},
        {:notify_player, :b, {:speed, 1}}
      ]
      assert round |> Round.upcomming_move(:b) == destination
    end

    test "Illegal move- bad destination" do
      raise "TODO next"
    end
  end
end

# [x] start
# move
# - normal
# - illegal
#   - too far
#   - already locked in
#   - last one to lock in
#     - Round change
#       - (don't Send summary, that'll happen automatically at START of NEXT round)
# - crash (similar (or same?) as resign)
# - cross any combination of check/goal lines
#   - win with correct combo
#     - All lines crossed in order
#       - In previous turns leading up to this last crossing
#       - Or you can cross multiple lines in a single turn
#     - confirm multiple players can win on the last round
# resign
# get-everything (summary)
# - Doesn't send players locked-in position; send their position as-of BEGINING of current round; Everyone will get update of new positions after round ends and next one starts
# legal_move?
# - extra interface function needed, yes. For drawing the x,y places you're allowed to hover over. Like the chess board
