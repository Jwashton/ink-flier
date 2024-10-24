defmodule InkFlierTest.GameServer do
  use ExUnit.Case

  alias InkFlier.GameServer

  test "Games can be started & retrieved with a lobby-generated id" do
    {:ok, _pid} = GameServer.start_link({123, "Robin"})
    assert GameServer.creator(123) == "Robin"
  end

  test "starting_info/1" do
    {:ok, _pid} = GameServer.start_link({123, "Batman"})
    assert %{creator: "Batman", players: []} = GameServer.starting_info(123)
  end

  test "A player can join" do
    {:ok, _pid} = GameServer.start_link({123, "Batman"})
    :ok = GameServer.join(123, "Robin")
    :ok = GameServer.join(123, "Bruce")

    assert GameServer.players(123) == ["Robin", "Bruce"]
  end

  test "remove player" do
    {:ok, _pid} = GameServer.start_link({123, "Batman"})
    :ok = GameServer.join(123, "Bruce")

    :ok = GameServer.remove(123, "Bruce")
    assert GameServer.players(123) == []

    assert {:error, _no_such_player} = GameServer.remove(123, "Badplayer")
  end

  test "start_link can take some extra options" do
    opts = %{id: 123, creator: "Bob", track: :some_track}
    {:ok, _pid} = GameServer.start_link(opts)
  end
end
