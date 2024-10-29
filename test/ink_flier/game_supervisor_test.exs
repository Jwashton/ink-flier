defmodule InkFlierTest.GameSupervisor do
  use ExUnit.Case

  alias InkFlier.GameSupervisor

  @name TestGameSupervisor

  setup do
    start_supervised!({GameSupervisor, name: @name})
    :ok
  end


  test "Start supervised games" do
    {:ok, _pid} = GameSupervisor.start_game(@name, id: 3211, creator: "Bob")
    assert DynamicSupervisor.count_children(@name).active == 1
  end

  test "Delete supervised games" do
    {:ok, game_pid} = GameSupervisor.start_game(@name, id: 321)

    GameSupervisor.delete_game!(@name, game_pid)
    assert DynamicSupervisor.count_children(@name).active == 0
  end
end
