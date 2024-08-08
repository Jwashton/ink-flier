defmodule InkFlierTest.Round do
  use ExUnit.Case
  import TinyMaps

  alias InkFlierTest.Helpers
  alias InkFlier.Round

  # setup do
  #   round = Round.new(1, [:a, :b], Helpers.test_track)
  #   ~M{round}
  # end

  # test "new" do
  #   board = Board.new([:a, :b], [{-1,-1}, {-2,-2}, {-3,-3}, {-4,-4}])

  #   assert {_round, instructions} = Round.new(1, board, Helpers.test_track)
  #   assert instructions == [
  #     {:notify_room, {:new_round, 1}},
  #     {:notify_room, {:player_position, :a, %{coord: {-1,-1}, speed: 1}}},
  #     {:notify_room, {:player_position, :b, %{coord: {-2,-2}, speed: 1}}},
  #   ]
  # end
end
