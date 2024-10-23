defmodule InkFlierTest.GameSupervisor do
  use ExUnit.Case

  alias InkFlier.GameSupervisor

  @name TestGameSupervisor

  test "Start supervised games" do
    :ok = GameSupervisor.start_link(name: @name)
    :ok = GameSupervisor.start_game(123)

    DynamicSupervisor.which_children(@name)
    |> dbg(charlists: :as_lists)

    # TODO next GameServer.start_link wont take {id, creator} but instead %StartOpts or regular map. Maybe all required or maybe just id to start with and creator/track/start_time/special-rules/anyOtherGameStartData can get away with being blank
  end
end
