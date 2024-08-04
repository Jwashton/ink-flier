defmodule InkFlierTest.GameServer do
  use ExUnit.Case
  import TinyMaps

  alias InkFlierTest.Helpers
  alias InkFlier.Game.Server

  setup do
    {:ok, pid} = Server.start_link([:a, :b], Helpers.test_track, self())
    ~M{pid}
  end


  test "start" do
    assert_receive {:starting_positions, %{a: {-1,-1}, b: {-2,-2}}}
  end

  test "current_positions", c do
    assert Server.current_positions(c.pid) == %{a: {-1,-1}, b: {-2,-2}}
  end

  describe "move" do
    test "Move once locks in", c do
      destination = {0,-1}

      assert {:ok, {:speed, 1}} = Server.move(c.pid, :a, destination)
      assert %{a: ^destination} = Server.current_positions(c.pid)
      assert_receive {:player_locked_in, :a}
    end

    test "Illegal move detected", c do
      unchanged_position = {-1,-1}
      illegal_destination = {99,99}

      assert {:error, :illegal_destination} = Server.move(c.pid, :a, illegal_destination)
      assert %{a: ^unchanged_position} = Server.current_positions(c.pid)
    end

    test "Can't move again until all locked in", c do
      {:ok, _speed} = Server.move(c.pid, :a, {0,-1})

      assert {:error, :already_locked_in} = Server.move(c.pid, :a, {0,-1})
    end

    test "Both players moved = next round", c do
      assert %{round: 1} = Server.current_game_state(c.pid)

      # {:ok, _speed} = Server.move(c.pid, :a, {0,-1})
      # {:ok, _speed} = Server.move(c.pid, :b, {-1,-2})

      # assert %{round: 2} = Server.current_game_state(c.pid)
    end

    # test "Both players moved = Unlocked and able to move again" do
    # end

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
