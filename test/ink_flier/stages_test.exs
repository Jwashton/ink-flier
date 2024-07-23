defmodule InkFlierTest.Stages do
  use ExUnit.Case

  alias InkFlier.Stages

  # - initial_setup
  #   - add_player
  #   - choose_track
  # TODO I think I might need to drive this from Game.<differentActions>, including Game.initialize and/or Game.start
  #   - One of it's rule checks will probably drive additions to Stages, and might not need seperate Stages_test module (altho lower level tests are nicer. But let's see if it works out one level up)


  # locking_in_turns
  # processing
  #   -anyWinners?
  #   -back to locking_in_turns
  # game_over

  test "Stage doesn't change if wrong action taken" do
    stages = Stages.new
    result = Stages.check(stages, :completely_wrong_event)

    assert result == :error
    assert stages.stage == :adding_players
  end

  describe "Adding Players" do
    test "Adding a new player doesn't change stage" do
      stages = Stages.new

      assert {:ok, stages} = Stages.check(stages, :add_player)
      assert stages.stage == :adding_players
    end

    test "Can't add player in other states" do
      stages = Stages.new
      stages = %{stages | stage: :some_other_stage}

      assert :error = Stages.check(stages, :add_player)
    end

    # TODO next
    # result = Stages.check(stages, {:start_game, number_of_players})
  end
end
