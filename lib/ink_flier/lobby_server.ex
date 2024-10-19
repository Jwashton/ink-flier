defmodule InkFlier.LobbyServer do
  use GenServer
  alias InkFlier.Lobby

  @name __MODULE__

  def start_link(opts \\ []) do
    opts = Keyword.put_new(opts, :name, @name)
    GenServer.start_link(__MODULE__, :ok, opts)
  end
  def stop, do: GenServer.whereis(@name) && GenServer.stop(@name)

  def add_game(name \\ @name, game), do: GenServer.call(name, {:add_game, game})
  def delete_game(name \\ @name, game_id), do: GenServer.call(name, {:delete_game, game_id})
  def games(name \\ @name), do: GenServer.call(name, :games)


  @impl GenServer
  def init(:ok), do: {:ok, Lobby.new}

  @impl GenServer
  def handle_call({:add_game, game}, _from, t) do
    {t, game_id} = Lobby.add_game(t, game)
    {:reply, {:ok, game_id}, t}
  end

  @impl GenServer
  def handle_call({:delete_game, game_id}, _from, t), do: {:reply, :ok, Lobby.delete_game(t, game_id)}

  @impl GenServer
  def handle_call(:games, _from, t), do: {:reply, Lobby.games(t), t}
end
