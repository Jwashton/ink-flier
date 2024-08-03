defmodule InkFlierTest.Game do
  use ExUnit.Case

  alias InkFlierTest.Helpers
  alias InkFlier.Game

  test "start" do
    assert {:ok, _pid} = Game.start_link([:a, :b], Helpers.test_track, self())
    assert_receive {:starting_positions, %{a: {-1,-1}, b: {-2,-2}}}
  end

  test "current_positions" do
    {:ok, pid} = Game.start_link([:a, :b], Helpers.test_track, self())
    assert Game.current_positions(pid) == %{a: {-1,-1}, b: {-2,-2}}
  end

  describe "move" do
    test "Move once locks in" do
      destination = {0,-1}

      {:ok, pid} = Game.start_link([:a, :b], Helpers.test_track, self())

      assert {:ok, {:speed, 1}} = Game.move(pid, :a, destination)
      assert %{a: ^destination} = Game.current_positions(pid)
      assert_receive {:player_locked_in, :a}
    end

    # illegal move

    # Both players moved = next round
    #   - Send all current_positions

    # test "legal_move?" do
    # # NOTE extra interface function, yes. For drawing the x,y places you're allowed to hover over. Like the chess board
    # end

    # move results in crash
    # move results in win (after everyone locked in)
    #   - multiple winners possible

    # Can't move again until all locked in
  end

  # test "resign" do
  # end
  # test "get_current_game_state" do
  # end
end
