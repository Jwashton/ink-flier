defmodule InkFlierTest.Lobby do
  use ExUnit.Case

  alias InkFlier.Lobby

  test "Initial state" do
    # Ecto.UUID.generate
    # |> IO.inspect(charlists: :as_lists, label: "uuid")

    assert Lobby.games == %{}
  end

  test "Create game" do
    raise "NEXT This is supervisor stuff right? Games will be processes (just use spawn for now for testing) that will need to be supervised by this lobby. Is there a special module I read about in the Elixir book when a module's job is just to start and track processes? Where it keeps their pids and updates them if the process crashes?"
  end
end
