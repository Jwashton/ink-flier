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
    {:ok, game_id1} = LobbyServer2.start_game(@lobby)
    {:ok, game_id2} = LobbyServer2.start_game(@lobby, creator: "Bob")
    assert LobbyServer2.games(@lobby) == [game_id1, game_id2]
  end

  # test "Get data from running games by their game_id" do
  # end
end
