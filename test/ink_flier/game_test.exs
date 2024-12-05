defmodule InkFlierTest.Game do
  use ExUnit.Case

  alias InkFlier.Game

  test "new/1 takes optional flags" do
    game = Game.new(creator: "Batman", track_id: 123)

    assert game |> Game.creator == "Batman"
    assert game |> Game.track_id == 123
  end

  test "add_player!/2" do
    game =
      Game.new
      |> Game.add_player!("James")
      |> Game.add_player!("Batman")

    assert game |> Game.players == ["James", "Batman"]
  end

  test "remove_player!/2" do
    game =
      Game.new
      |> Game.add_player!("James")
      |> Game.remove_player!("James")

    assert game |> Game.players == []
  end


  describe "Phases" do
    test "Starting phase" do
      assert Game.summary_info(Game.new).phase == :setup
    end

    test "start/1" do
      game =
        Game.new
        |> Game.add_player!("James")
        |> Game.begin!

      assert Game.summary_info(game).phase == :begun
    end
  end

  test "summary_info/1 returns players in correct order" do
    game =
      Game.new
      |> Game.add_player!("James")
      |> Game.add_player!("Batman")
    assert Game.summary_info(game).players == ["James", "Batman"]
  end
end
