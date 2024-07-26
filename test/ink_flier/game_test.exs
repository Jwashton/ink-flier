defmodule InkFlierTest.Game do
  use ExUnit.Case

  alias InkFlierTest.Helpers
  alias InkFlier.Game
  # new
  #   - HouseRules
  # add players
  # select track
  # begin
  #   - player starting positions
  # *broadcast:
  #   %PlayerInfo?{
  #     player_1: %PlayerInfo{
  #       current_position: {1,1}
  #     }
  #     crash return?
  #     disconected return?
  #
  #     current_positions:
  #     legal_moves: %{
  #       player_1: MapSet.new([{1,1}, {1,2}...]),
  #       player_2: MapSet.new([{1,1}, {1,2}...]),
  #     }
  #   }
  # move

  # try things in wrong phase and confirm error

  # move events:
  # - lock_in_move
  # - leave_game
  # - win
  # - crash?


  test "new game" do
    game = Game.new
    assert game |> Game.players == []
    assert game |> Game.track == nil
  end

  test "Can add multiple players" do
    game =
      Game.new
      |> Game.add_player("Chris")
      |> Game.add_player([:player_1, :bob])
    assert game |> Game.players == ["Chris", :player_1, :bob]
  end

  test "Can change tracks multiple times (to view different ones or something) but eventually 1 will be locked in" do
    track1 = Helpers.test_track
    track2 = Helpers.test_track |> Map.put(:start, [{99,99}])

    game =
      Game.new
      |> Game.select_track(track1)
      |> Game.select_track(track2)

    assert game |> Game.track == track2
  end

  test "After lockin, (phase has changed), can't add players or change track anymore" do
    # NOTE might need some {:ok.../{:error... tuples, we'll see
  end
end
