defmodule InkFlierTest.Game do
  use ExUnit.Case

  alias InkFlier.Game
  alias InkFlierTest.Helpers

  @players ~w(a b c)a
  @track Helpers.test_track

  test "New game returns starting position" do
    assert {:ok, _game, starting_positions} = Game.new(@players, @track)

    assert %{
      {0,0} => :a,
      {-1,-1} => :b,
      {-2,-2} => :c,
    } = starting_positions
  end

  test "New game possible errors" do
    assert {:error, :invalid_track} = Game.new(@players, %{})
    assert {:error, :invalid_house_rules} = Game.new(@players, @track, %{})
  end

  # test "New game stores, at the very least, current positions" do
  #   assert {:ok, game, _starting_positions} = Game.new(@players, @track)
  # end
end
