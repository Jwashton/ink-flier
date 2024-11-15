defmodule InkFlierTest.GameSupervisor do
  use ExUnit.Case

  alias InkFlier.GameSupervisor

  setup do
    start_supervised!(GameSupervisor)
    :ok
  end


  test "Start supervised games" do
    {:ok, _pid} = GameSupervisor.start_game(id: 3211, creator: "Bob")
    assert GameSupervisor.count_children.active == 1
  end

  test "Delete supervised games" do
    {:ok, _pid} = GameSupervisor.start_game(id: 321)

    GameSupervisor.delete_game!(321)
    assert GameSupervisor.count_children.active == 0
  end
end
