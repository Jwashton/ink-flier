defmodule InkFlierTest.Game do
  use ExUnit.Case

  alias InkFlierTest.Helpers
  alias InkFlier.Game

  test "start" do
    _pid = start_test_game()
    assert_receive {:starting_positions, %{a: {-1,-1}, b: {-2,-2}}}
  end

  test "current_positions" do
    pid = start_test_game()
    assert Game.current_positions(pid) == %{a: {-1,-1}, b: {-2,-2}}
  end

  describe "move" do
    test "Move once locks in" do
      pid = start_test_game()

      destination = {0,-1}

      assert {:ok, {:speed, 1}} = Game.move(pid, :a, destination)
      assert %{a: ^destination} = Game.current_positions(pid)
      assert_receive {:player_locked_in, :a}
    end

    test "Illegal move detected" do
      pid = start_test_game()

      unchanged_position = {-1,-1}
      illegal_destination = {99,99}

      assert {:error, :illegal_destination} = Game.move(pid, :a, illegal_destination)
      assert %{a: ^unchanged_position} = Game.current_positions(pid)
    end

    # Can't move again until all locked in

    # Both players moved = next round
    #   - Send all current_positions

    # test "legal_move?" do
    # # NOTE extra interface function, yes. For drawing the x,y places you're allowed to hover over. Like the chess board
    # end

    # move results in crash
    # move results in win (after everyone locked in)
    #   - multiple winners possible
  end

  # test "resign" do
  # end
  # test "get_current_game_state" do
  # end


  defp start_test_game do
    {:ok, pid} = Game.start_link([:a, :b], Helpers.test_track, self())

    pid
  end
end
