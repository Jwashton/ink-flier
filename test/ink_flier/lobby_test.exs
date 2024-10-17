defmodule InkFlierTest.Lobby do
  use ExUnit.Case

  alias InkFlier.Lobby

  test "Add game" do
    t = Lobby.new
    {t, game_id1} = Lobby.add_game(t, :fake_game1)
    {t, game_id2} = Lobby.add_game(t, :fake_game2)

    assert Lobby.game(t, game_id1) == :fake_game1
    assert Lobby.game(t, game_id2) == :fake_game2
  end

  test "Delte game" do
    t = Lobby.new
    {t, game_id1} = Lobby.add_game(t, :fake_game1)
    {t, game_id2} = Lobby.add_game(t, :fake_game2)
    t = Lobby.delete_game(t, game_id1)

    games = Lobby.games(t) |> Map.values

    assert :fake_game2 in games
    refute :fake_game1 in games
  end
end
