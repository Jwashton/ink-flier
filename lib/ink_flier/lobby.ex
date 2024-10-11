defmodule InkFlier.Lobby do
  use GenServer

  def start_link(_), do: GenServer.start_link(__MODULE__, :ok, name: __MODULE__)

  def create_game(track), do: GenServer.call(__MODULE__, {:create_game, track})

  def games, do: GenServer.call(__MODULE__, :games)


  @impl GenServer
  def init(:ok) do
    {:ok, %{}}
  end

  @impl GenServer
  def handle_call({:create_game, track}, _from, state) do
    {:reply, "hi", state}
  end

  @impl GenServer
  def handle_call(:games, _from, state), do: {:reply, state, state}
end
