defmodule InkFlierTest.Lobby do
  use ExUnit.Case

  alias InkFlier.Lobby

  test "Initial state" do
    assert Lobby.games == %{}
  end
end
