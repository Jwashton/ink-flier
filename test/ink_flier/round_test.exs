defmodule InkFlierTest.Round do
  use ExUnit.Case

  alias InkFlier.Round
  alias InkFlier.Board
  alias InkFlierTest.Helpers

  @board Board.new([:a, :b], Helpers.test_track)

  test "new" do
    assert {_round, instructions} = Round.new(@board, 1)
    assert instructions == [
      {:notify_room, {:new_round, 1}},
      {:notify_room, {:player_position, :a, %{coord: {-1,-1}, speed: 0}}},
      {:notify_room, {:player_position, :b, %{coord: {-2,-2}, speed: 0}}},
    ]
  end

  test "summary gives positions from START of round. (Pending moves will show up @ start of NEXT round)" do
    original_position_a = {-1,-1}
    original_position_b = {-2,-2}
    pending_move = {0,-1}

    {original_round, _} =
      @board
      |> Round.new(1)
      |> move(:a, pending_move)

    {unchanged_round, instructions} =
      original_round
      |> Round.summary(:observer_1)

    assert unchanged_round == original_round
    assert instructions == [
      {:notify_member, :observer_1, {:new_round, 1}},
      {:notify_member, :observer_1, {:player_position, :a, %{coord: original_position_a, speed: 0}}},
      {:notify_member, :observer_1, {:player_position, :b, %{coord: original_position_b, speed: 0}}},
    ]
  end

  describe "move" do
    test "Normal valid move locks player in" do
      destination = {-1,-2}
      {round, instructions} =
        @board
        |> Round.new(1)
        |> move(:b, destination)

      assert instructions == [
        {:notify_room, {:player_locked_in, :b}},
        {:notify_player, :b, {:speed, 1}}
      ]
      assert round |> Round.upcomming_move(:b) == destination
    end

    test "Illegal move- bad destination" do
      unchanged_position = {-1,-1}
      illegal_destination = {99,99}
      {round, instructions} =
        @board
        |> Round.new(1)
        |> move(:a, illegal_destination)

      assert instructions == [{:notify_player, :a, {:error, :illegal_destination}}]
      assert round |> Round.upcomming_move(:a) == unchanged_position
    end

    test "Can't move again until all locked in" do
      move1 = {0,-1}
      move2 = {2,-1}
      {round, instructions} =
        @board
        |> Round.new(1)
        |> move(:a, move1)
        |> move(:a, move2)

      assert instructions == [{:notify_player, :a, {:error, :already_locked_in}}]
      assert round |> Round.upcomming_move(:a) == move1
    end

    test "When all players have moved, round ends" do
      move_a = {0,-1}
      move_b = {-1,-2}
      {round, instructions} =
        @board
        |> Round.new(1)
        |> move(:a, move_a)
        |> move(:b, move_b)

      assert instructions == [
        {:notify_room, {:player_locked_in, :b}},
        {:notify_player, :b, {:speed, 1}},
        {:end_of_round, 1},
      ]
      assert round |> Round.upcomming_move(:a) == move_a
      assert round |> Round.upcomming_move(:b) == move_b
    end
  end

  raise "TODO next, different versions of crash move"
  # describe "Crash move" do
  #   test "Multiple players remaining = game continues" do
  #     move_a = {0,0}
  #     move_b = {-1,-2}
  #     move_c = {-2,-3}
  #     {round, instructions} =
  #       Board.new([:a, :b, :c], [{-1,-1}, {-2,-2}, {-3,-3}, {-4,-4}])
  #       |> Round.new(1)
  #       |> move(:a, move_a)
  #       |> move(:b, move_b)
  #       |> move(:c, move_c)

  #     assert instructions
  #     |> Enum.drop(2) == [
  #       {:notify_room, {:crash, :a, move_a}},
  #       {:end_of_round, 1},
  #     ]
  #   end
  # end


  # NOTE Normally we would process all recieved instructions after each step. Can skip that in tests, since previous
  # instructions will have been checked in other tests
  defp move({t, _previous_instructions}, player, destination), do: Round.move(t, player, destination)
end

# [x] start
# move
# - [x] normal
# - [x] illegal
#   - [x] too far
#   - [x] already locked in
#   - [x] last one to lock in
# - crash (similar (or same?) as resign)
#   - [ ] if multiple players remaining, game continues w/o crasher
#   - if down to 1 player after crashes, they win
#   - if down to 0 players after crashes, all players from start of round win
# - cross any combination of check/goal lines
#   - win with correct combo
#     - All lines crossed in order
#       - In previous turns leading up to this last crossing
#       - Or you can cross multiple lines in a single turn
#     - confirm multiple players can win on the last round
# resign
#   - if players resigned, they count as locked in
#     - so round can still end
# [x] get-everything (summary)
# - Doesn't send players locked-in position; send their position as-of BEGINING of current round; Everyone will get update of new positions after round ends and next one starts
# legal_move?
# - extra interface function needed, yes. For drawing the x,y places you're allowed to hover over. Like the chess board
