defmodule InkFlierTest.Game do
  use ExUnit.Case
  import TinyMaps

  alias InkFlierTest.Helpers
  alias InkFlier.Game

  setup do
    {:ok, pid} = Game.start_link([:a, :b], Helpers.test_track, self())
    ~M{pid}
  end


  test "start" do
    assert_receive {:starting_positions, %{a: {-1,-1}, b: {-2,-2}}}
  end

  test "current_positions", c do
    assert Game.current_positions(c.pid) == %{a: {-1,-1}, b: {-2,-2}}
  end

  describe "move" do
    test "Move once locks in", c do
      destination = {0,-1}

      assert {:ok, {:speed, 1}} = Game.move(c.pid, :a, destination)
      assert %{a: ^destination} = Game.current_positions(c.pid)
      assert_receive {:player_locked_in, :a}
    end

    test "Illegal move detected", c do
      unchanged_position = {-1,-1}
      illegal_destination = {99,99}

      assert {:error, :illegal_destination} = Game.move(c.pid, :a, illegal_destination)
      assert %{a: ^unchanged_position} = Game.current_positions(c.pid)
    end

    test "Can't move again until all locked in", c do
      {:ok, _speed} = Game.move(c.pid, :a, {0,-1})

      assert {:error, :already_locked_in} = Game.move(c.pid, :a, {0,-1})
    end

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
end
