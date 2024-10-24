defmodule InkFlier.LobbyServer do
  use GenServer
  alias InkFlier.Lobby

  @name __MODULE__

  def start_link(opts \\ []) do
    opts = Keyword.put_new(opts, :name, @name)
    GenServer.start_link(__MODULE__, Map.get(opts, :game_supervisor_name), opts)
  end
  def stop, do: GenServer.whereis(@name) && GenServer.stop(@name)

  def add_game(name \\ @name, game), do: GenServer.call(name, {:add_game, game})
  def delete_game(name \\ @name, game_id), do: GenServer.call(name, {:delete_game, game_id})
  def games(name \\ @name), do: GenServer.call(name, :games)

  def create_game(name \\ @name, game_opts), do: GenServer.call(name, {:create_game, game_opts})


  @impl GenServer
  def init(~M{_game_supervisor_name}) do
    # {:ok, _pid} = GameSupervisor.start_link(name: game_supervisor_name)
    {:ok, Lobby.new}
  end
  def init(:ok), do: {:ok, Lobby.new}

  @impl GenServer
  def handle_call({:add_game, game}, _from, t) do
    # NOTE Keeping the game_id list in our Lobby state is kind of retdundant, since we could just ask GameSupervisor
    # to list it's children
    # Doc says that can be slow tho, so this can be used like a cache for now
    {t, game_id} = Lobby.add_game(t, game)

    {:reply, {:ok, game_id}, t}
  end

  @impl GenServer
  def handle_call({:create_game, game_opts}, _from, t) do
    {t, game_id} = Lobby.add_game(t, game)
    {:reply, {:ok, game_id}, t}
  end

  @impl GenServer
  def handle_call({:delete_game, game_id}, _from, t), do: {:reply, :ok, Lobby.delete_game(t, game_id)}

  @impl GenServer
  def handle_call(:games, _from, t), do: {:reply, Lobby.games(t), t}
end
