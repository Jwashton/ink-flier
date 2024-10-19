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
end
