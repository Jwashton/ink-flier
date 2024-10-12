defmodule InkFlier.LobbyServer do
  use GenServer
  alias InkFlier.Lobby

  def start_link(_), do: GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  def stop, do: GenServer.whereis(__MODULE__) && GenServer.stop(__MODULE__)

  def add_game(game), do: GenServer.call(__MODULE__, {:add_game, game})
  def games, do: GenServer.call(__MODULE__, :games)


  @impl GenServer
  def init(:ok), do: {:ok, Lobby.new}

  @impl GenServer
  def handle_call({:add_game, game}, _from, t) do
    {t, game_id} = Lobby.add_game(t, game)
    {:reply, {:ok, game_id}, t}
  end

  @impl GenServer
  def handle_call(:games, _from, t), do: {:reply, Lobby.games(t), t}
end
