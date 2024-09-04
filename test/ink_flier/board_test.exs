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

  test "remaining_players" do
    assert Board.new([:c, :b, :a], Helpers.test_track)
    |> Board.crash(:b)
    |> Board.remaining_players == [:c, :a]
  end

  describe "move" do
    test "normally returns :ok" do
      normal_move = {-2,-2}
      reply =
        Board.new([:a, :b, :c], Helpers.test_track)
        |> Board.move(:a, normal_move)
      assert {:ok, t} = reply
      assert %{a: ^normal_move} = t |> Board.current_positions
    end

    test "returns :error if crash" do
      crash_move = {99,99}
      reply =
        Board.new([:a, :b, :c], Helpers.test_track)
        |> Board.move(:a, crash_move)
      assert {{:collision, %MapSet{}}, t} = reply
      assert %{a: ^crash_move} = t |> Board.current_positions
    end

    test "updates crashed list/remaining_players" do
      crash_move = {99,99}
      {{:collision, _obstacles}, t} =
        Board.new([:a, :b, :c], Helpers.test_track)
        |> Board.move(:a, crash_move)
      assert t |> Board.remaining_players == [:b, :c]
    end
  end
end
