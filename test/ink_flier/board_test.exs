defmodule InkFlierTest.Board do
  use ExUnit.Case

  alias InkFlier.Board

  describe "Can make new Board with and without random pole positions" do
    test "Using given pole positions" do
      t = Board.new([:a, :b, :c], [{-1,-1}, {-2,-2}, {-3,-3}, {-4,-4}])
      assert t |> Board.current_positions == %{a: {-1,-1}, b: {-2,-2}, c: {-3,-3}}
    end

    test "Using random pole positions" do
      t = Board.new([:a, :b, :c], [{-1,-1}, {-2,-2}, {-3,-3}, {-4,-4}], true, &Enum.reverse/1)
      assert t |> Board.current_positions == %{c: {-1,-1}, b: {-2,-2}, a: {-3,-3}}
    end

    test "Using ACTUAL random pole positions (no module override) doesn't error" do
      t =Board.new([:a, :b, :c], [{-1,-1}, {-2,-2}, {-3,-3}, {-4,-4}], true)
      for player <- [:a, :b, :c] do
        assert t |> Board.current_positions |> Map.has_key?(player)
      end
    end
  end

  test "Board maintains list of player order" do
    t = Board.new([:b, :z, :a], [{-1,-1}, {-2,-2}, {-3,-3}, {-4,-4}])
    assert t |> Board.players == [:b, :z, :a]
  end
end
