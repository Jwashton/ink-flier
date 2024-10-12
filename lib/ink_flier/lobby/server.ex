defmodule InkFlier.Lobby.Server do
  use GenServer
  alias InkFlier.Lobby

  def start_link(_), do: GenServer.start_link(__MODULE__, :ok, name: __MODULE__)

  def create_game(track), do: GenServer.call(__MODULE__, {:create_game, track})

  def games, do: GenServer.call(__MODULE__, :games)


  @impl GenServer
  def init(:ok) do
    {:ok, Lobby.new}
  end

  @impl GenServer
  def handle_call({:create_game, _track}, _from, lobby) do
    {:reply, "hi", lobby}
  end

  @impl GenServer
  def handle_call(:games, _from, lobby) do
    {:reply, Lobby.games(lobby), lobby}
  end
end
