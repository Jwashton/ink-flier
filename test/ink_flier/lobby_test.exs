defmodule InkFlierTest.Lobby do
  use ExUnit.Case

  alias InkFlier.Lobby.Server
  alias InkFlier.Game

  defmodule MockGame do
    def new(track) do
      nil
    end

    def track(t) do
      :hi_imaginary_game1
    end
  end


  test "Initial state" do
    # Ecto.UUID.generate
    # |> IO.inspect(charlists: :as_lists, label: "uuid")

    assert Server.games == %{}
  end

  test "Create game" do
    # raise "NEXT This is supervisor stuff right? Games will be processes (just use spawn for now for testing) that will need to be supervised by this lobby. Is there a special module I read about in the Elixir book when a module's job is just to start and track processes? Where it keeps their pids and updates them if the process crashes?"

    # {:ok, game1_pid} = Game.start_link(:whatever_game_data)
    :ok = Server.set_game_module(MockGame)
    {:ok, game_id} = Server.create_game(:imaginary_track_number)

    assert game_id in Server.games |> Map.keys
    # assert Server.get(game_id) |> Game.track == :imaginary_game1
  end


  # TODO note, the tests might bleed together since Lobby is a process, and it's started in the Application file. Possible the tests don't reset it for every test. Check later

end
