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
end
