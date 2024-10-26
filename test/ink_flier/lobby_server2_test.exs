defmodule InkFlierTest.LobbyServer2 do
  use ExUnit.Case

  alias InkFlier.LobbyServer2
  alias InkFlier.GameSupervisor

  @lobby TestLobbyServer2
  @game_starter TestGameSupervisor

  setup do
    {:ok, _} = GameSupervisor.start_link(name: @game_starter)
    {:ok, _} = LobbyServer2.start_link(name: @lobby, game_supervisor: @game_starter)
    :ok
  end


  test "Keeps track of started games" do
    # game_id = LobbyServer2.start_game(@lobby,
  end
end
