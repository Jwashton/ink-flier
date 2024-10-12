defmodule InkFlier.Lobby.Server do
  use GenServer
  alias InkFlier.Lobby

  def start_link(_), do: GenServer.start_link(__MODULE__, :ok, name: __MODULE__)

  def create_game(track), do: GenServer.call(__MODULE__, {:create_game, track})

  def games, do: GenServer.call(__MODULE__, :games)

  def set_game_module(module), do: GenServer.call(__MODULE__, {:set_game_module, module})


  @impl GenServer
  def init(:ok) do
    {:ok, Lobby.new}
  end

  @impl GenServer
  def handle_call({:create_game, track}, _from, lobby) do
    {lobby, id} = Lobby.create_game(lobby, track)

    {:reply, {:ok, id}, lobby}
  end

  @impl GenServer
  def handle_call(:games, _from, lobby) do
    {:reply, Lobby.games(lobby), lobby}
  end

  @impl GenServer
  def handle_call({:set_game_module, module}, _from, lobby) do
    {:reply, :ok, Lobby.set_game_module(lobby, module)}
  end
end
