defmodule InkFlierTest.Stages do
  use ExUnit.Case

  alias InkFlier.Stages

  # adding_players
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
