defmodule InkFlierTest.Game do
  use ExUnit.Case

  alias InkFlier.Game
  alias InkFlier.HouseRules
  alias InkFlierTest.Helpers

  @players ~w(a b c)a
  @track Helpers.test_track
  @house_rules HouseRules.new

  test "New game returns starting position" do
    assert {:ok, _game, starting_positions} = Game.new(@players, @track, @house_rules)

    assert %{
      {0,0} => :a,
      {-1,-1} => :b,
      {-2,-2} => :c,
    } = starting_positions
  end

  test "New game possible errors" do
    assert {:error, :invalid_track} = Game.new(@players, %{}, @house_rules)
    assert {:error, :invalid_house_rules} = Game.new(@players, @track, %{})
  end

  # test "New game returns useable game struct" do
  #   assert {:ok, game, _starting_positions} = Game.new(@players, @track, @house_rules)
  # end
end
