defmodule InkFlierTest.GameStoreServer do
  use ExUnit.Case
  alias InkFlier.GameStoreServer

  setup do
    start_supervised!(InkFlier.GameStoreServer)
    :ok
  end

  test "Game ids are saved in order" do
    :ok = GameStoreServer.track_game_id("Apple")
    :ok = GameStoreServer.track_game_id("Banana")
    :ok = GameStoreServer.track_game_id("Coconut")

    :ok = GameStoreServer.untrack_game_id("Banana")

    assert GameStoreServer.games == ["Apple", "Banana"]
  end
end
