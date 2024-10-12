defmodule InkFlierTest.Lobby do
  use ExUnit.Case

  alias InkFlier.Lobby

  test "Create game" do
    t = Lobby.new
    {t, game_id1} = Lobby.create_game(t, :fake_game1)
    {t, game_id2} = Lobby.create_game(t, :fake_game2)

    assert Lobby.game(t, game_id1) == :fake_game1
    assert Lobby.game(t, game_id2) == :fake_game2
  end
end
