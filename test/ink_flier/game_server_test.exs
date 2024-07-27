defmodule InkFlierTest.GameServer do
  use ExUnit.Case

  alias InkFlierTest.Helpers
  alias InkFlier.GameServer

  test "Main" do
    room_creator = :player_1
    {:ok, game_pid_1} = GameServer.start_link(room_creator)
    a = game_pid_1

    :ok = GameServer.add_player(a, :bob)
    :ok = GameServer.add_player(a, :mario)
    :ok = GameServer.drop_player(a, :bob)

    assert GameServer.players(a) == [:player_1, :mario]
    assert GameServer.begin_race(a) == {:error, :no_track_selected}

    :ok = GameServer.select_track(a, Helpers.test_track)
    :ok = GameServer.begin_race(a)
  end

  # TODO
  # - Also some game_pid_2 stuff in there and confirm they're seperate
  # - HouseRules, for now the only one is Random starting positions tho which I don't know how to test
end
