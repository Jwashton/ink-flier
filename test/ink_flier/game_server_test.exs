defmodule InkFlierTest.GameServer do
  use ExUnit.Case

  alias InkFlier.GameServer

  test "Games can be started & retrieved with a lobby-generated id" do
    {:ok, _pid} = GameServer.start_link(name: 123, creator: "Robin")
    assert GameServer.creator(123) == "Robin"
  end

  test "A player can join" do
    {:ok, _pid} = GameServer.start_link(name: 123, creator: "Batman")
    :ok = GameServer.join(123, "Robin")
    :ok = GameServer.join(123, "Bruce")

    assert GameServer.players(123) == ["Robin", "Bruce"]
  end

  test "remove player" do
    {:ok, _pid} = GameServer.start_link(name: 123, creator: "Batman")
    :ok = GameServer.join(123, "Bruce")

    :ok = GameServer.remove(123, "Bruce")
    assert GameServer.players(123) == []

    assert {:error, _no_such_player} = GameServer.remove(123, "Badplayer")
  end

  test "start_link can take track_id" do
    opts = [name: 123, creator: "Bob", track_id: :some_track]
    {:ok, _pid} = GameServer.start_link(opts)
    assert %{track_id: :some_track} = GameServer.summary_info(123)
  end

  test "Check if game for id exists" do
    {:ok, _pid} = GameServer.start_link(name: 123, creator: "Robin")
    assert GameServer.whereis(123)
    refute GameServer.whereis(:badId)
  end
end
