defmodule InkFlier.LobbyServer2 do
  use GenServer

  alias InkFlier.Lobby2

  @name __MODULE__

  def start_link(opts) do
    opts = Keyword.put_new(opts, :name, @name)
    game_supervisor = Keyword.fetch!(opts, :game_supervisor)
    GenServer.start_link(__MODULE__, game_supervisor, opts)
  end


  @impl GenServer
  def init(game_supervisor), do: {:ok, Lobby2.new(game_supervisor)}
end
