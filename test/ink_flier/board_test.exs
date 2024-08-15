defmodule InkFlierTest.Board do
  use ExUnit.Case

  alias InkFlier.Board
  alias InkFlierTest.Helpers

  describe "Can make new Board with and without random pole positions" do
    test "Using given pole positions" do
      t = Board.new([:a, :b, :c], Helpers.test_track)
      assert t |> Board.current_positions == %{a: {-1,-1}, b: {-2,-2}, c: {-3,-3}}
    end

    test "Using random pole positions" do
      t = Board.new([:a, :b, :c], Helpers.test_track, true, &Enum.reverse/1)
      assert t |> Board.current_positions == %{c: {-1,-1}, b: {-2,-2}, a: {-3,-3}}
    end

    test "Using ACTUAL random pole positions (no module override) doesn't error" do
      t =Board.new([:a, :b, :c], Helpers.test_track, true)
      for player <- [:a, :b, :c] do
        assert t |> Board.current_positions |> Map.has_key?(player)
      end
    end
  end

  test "Board maintains list of player order" do
    t = Board.new([:b, :z, :a], Helpers.test_track)
    assert t |> Board.players == [:b, :z, :a]
  end

  test "crash and remaining_players" do
    assert Board.new([:c, :b, :a], Helpers.test_track)
    |> Board.crash(:b)
    |> Board.remaining_players == [:c, :a]
  end

  test "Board.move updates crash list if someone crashed" do
    raise "TODO next. Let's have Board module automatically update the crashed list on it's .move. We can then just check that when making the instructions list above in Round"
  end
end
