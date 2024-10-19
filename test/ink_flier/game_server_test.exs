defmodule InkFlierTest.GameServer do
  use ExUnit.Case

  alias InkFlier.GameServer

  test "Games can be started & retrieved with a lobby-generated id" do
    {:ok, _pid} = GameServer.start_link({123, "Robin"})
    assert GameServer.creator(123) == "Robin"
  end
end
