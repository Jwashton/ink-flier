defmodule InkFlierTest.GameServer do
  use ExUnit.Case
  import TinyMaps

  alias InkFlierTest.Helpers
  alias InkFlier.Game.Server
  alias InkFlier.Game

  setup do
    {:ok, pid} = Server.start_link([:a, :b], Helpers.test_track, self())
    ~M{pid}
  end


  test "start" do
    assert_receive {:starting_positions, %{a: {-1,-1}, b: {-2,-2}}}
  end

  test "summary/1 contains all needed game data; current_positions", c do
    assert %{a: {-1,-1}, b: {-2,-2}} = Server.summary(c.pid).positions
  end

  test "summary updates round correctly", c do
    assert %{round: 1} = Server.summary(c.pid)

    {:ok, _speed} = Server.move(c.pid, :a, {0,-1})
    {:ok, _speed} = Server.move(c.pid, :b, {-1,-2})

    assert %{round: 2} = Server.summary(c.pid)
  end

  describe "move" do
    test "Move once locks in", c do
      destination = {0,-1}

      assert {:ok, {:speed, 1}} = Server.move(c.pid, :a, destination)
      assert %{a: ^destination} = Server.summary(c.pid).positions
      assert_receive {:player_locked_in, :a}
    end

    test "Illegal move detected", c do
      unchanged_position = {-1,-1}
      illegal_destination = {99,99}

      assert {:error, :illegal_destination} = Server.move(c.pid, :a, illegal_destination)
      assert %{a: ^unchanged_position} = Server.summary(c.pid).positions
    end

    test "Can't move again until all locked in", c do
      {:ok, _speed} = Server.move(c.pid, :a, {0,-1})

      assert {:error, :already_locked_in} = Server.move(c.pid, :a, {0,-1})
    end

    test "On round change, notify everyone the new positions", c do
      destination_a = {0,-1}
      destination_b = {-1,-2}

      {:ok, _speed} = Server.move(c.pid, :a, destination_a)
      refute_receive {:new_round, _}
      {:ok, _speed} = Server.move(c.pid, :b, destination_b)

      assert_receive {:new_round, summary}
      assert %{round: 2} = summary
      assert %{a: ^destination_a, b: ^destination_b} = summary.positions
    end

    test "Both players moved = Unlocked and able to move again", c do
      {:ok, _speed} = Server.move(c.pid, :a, {0,-1})
      {:ok, _speed} = Server.move(c.pid, :b, {-1,-2})

      assert {:ok, _speed} = Server.move(c.pid, :a, {1,-1})
    end

    test "1 player wins", c do
      :sys.replace_state(c.pid, &Game.manual_move(&1, :a, {-1,0}))
      {:ok, :crossed_win_line} = Server.move(c.pid, :a, {0,0})
      {:ok, _speed} = Server.move(c.pid, :b, {-1,-2})
      assert_receive {:winners, [:a]}

      # TODO this is going to need to do the intersect/collide stuff, but with goal line for win
      # Win needs to use check1 & 2, which will have to have been tracked (tested)
    end

    # move results in win (after everyone locked in)
    #   - multiple winners possible


    # test "move results in crash" do
    # # TODO maybe implement Resign first
    # end
  end

  # test "legal_move?" do
  # # NOTE extra interface function, yes. For drawing the x,y places you're allowed to hover over. Like the chess board
  # end

  # test "resign" do
  # end

  # Houserule setting for if you cross finish AND crash (into far wall or w/e) in same move, is it win or loss
  #   - We'll default to Win
end
