defmodule InkFlierTest.Game do
  use ExUnit.Case

  alias InkFlier.Game
  alias InkFlier.HouseRules
  alias InkFlierTest.Helpers

  @players ~w(a b c)a
  @track Helpers.test_track
  @house_rules HouseRules.new

  # test "New game" do
  #   assert {:ok, _game, _starting_positions} = Game.new(@players, @track, @house_rules)
  # end

  test "New game possible errors" do
    assert {:error, :invalid_track} = Game.new(@players, %{}, @house_rules)
    assert {:error, :invalid_house_rules} = Game.new(@players, @track, %{})
  end
end
