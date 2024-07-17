defmodule InkFlierTest.Game do
  use ExUnit.Case

  alias InkFlier.Game
  alias InkFlierTest.Helpers

  @players ~w(a b c)a
  @track Helpers.test_track

  test "New game will hold Board and things like starting positions" do
    assert {:ok, game} = Game.new(@players, @track)
    assert %{b: {-1,-1}} = Game.current_positions(game)
  end

  test "New game possible errors" do
    assert {:error, :invalid_track} = Game.new(@players, %{})
    assert {:error, :invalid_house_rules} = Game.new(@players, @track, %{})
  end
end
