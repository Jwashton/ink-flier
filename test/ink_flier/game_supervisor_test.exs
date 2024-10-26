defmodule InkFlierTest.GameSupervisor do
  use ExUnit.Case

  alias InkFlier.GameSupervisor

  @name TestGameSupervisor

  test "Start supervised games" do
    {:ok, _pid} = GameSupervisor.start_link(name: @name)
    {:ok, _pid} = GameSupervisor.start_game(@name, id: 3211, creator: "Bob")

    assert DynamicSupervisor.count_children(@name).active == 1
  end
end
