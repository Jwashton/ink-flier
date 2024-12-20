defmodule InkFlierWeb.ChannelCase do
  @moduledoc """
  This module defines the test case to be used by
  channel tests.

  Such tests rely on `Phoenix.ChannelTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use InkFlierWeb.ChannelCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate
  import Phoenix.ChannelTest

  using do
    quote do
      # Import conveniences for testing with channels
      import InkFlierWeb.ChannelCase
      import Phoenix.ChannelTest

      # The default endpoint for testing
      @endpoint InkFlierWeb.Endpoint
    end
  end

  # push/3 by itself is async. Use assert_reply/4 to wait for reply and not cause a race
  def push!(socket, msg, payload \\ %{}) do
    push(socket, msg, payload)
    |> assert_reply(:ok)
  end

  setup tags do
    InkFlier.DataCase.setup_sandbox(tags)
    :ok
  end
end
