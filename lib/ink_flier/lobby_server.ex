defmodule InkFlier.LobbyServer do
  use GenServer

  alias InkFlier.Lobby
  alias InkFlier.GameSupervisor
  alias InkFlier.GameServer

  @name __MODULE__

  @doc """
  On start, LobbyServer needs to know the Name of the GameSupervisor he's using.
  That can be overridden (in tests, for example), but otherwise will just use GameSupervisor's system default
  """
  def start_link(opts) do
    opts = Keyword.put_new(opts, :name, @name)
    game_supervisor = Keyword.get(opts, :game_supervisor, GameSupervisor.default_name)

    GenServer.start_link(__MODULE__, game_supervisor, opts)
  end

  def start_game(name \\ @name, game_opts), do: GenServer.call(name, {:start_game, game_opts})
  def delete_game(name \\ @name, game_id), do: GenServer.call(name, {:delete_game, game_id})
  def games(name \\ @name), do: GenServer.call(name, :games)
  def games_info(name \\ @name), do: GenServer.call(name, :games_info)

  def whereis(game_id), do: game_id |> GameServer.via |> GenServer.whereis


  @impl GenServer
  def init(game_supervisor), do: {:ok, Lobby.new(game_supervisor)}

  @impl GenServer
  def handle_call({:start_game, game_opts}, _, t) do
    game_id = Lobby.generate_id
    game_opts = Keyword.put(game_opts, :id, game_id)

    t = Lobby.track_game_id(t, game_id)
    t
    |> Lobby.game_supervisor
    |> GameSupervisor.start_game!(game_opts)

    {:reply, {:ok, game_id}, t}
  end

  @impl GenServer
  def handle_call({:delete_game, game_id}, _, t) do
    t = Lobby.untrack_game_id(t, game_id)
    t
    |> Lobby.game_supervisor
    |> GameSupervisor.delete_game(whereis(game_id))

    {:reply, :ok, t}
  end

  @impl GenServer
  def handle_call(:games, _, t), do: {:reply, Lobby.games(t), t}

  @impl GenServer
  def handle_call(:games_info, _, t) do
    t
    |> Lobby.games
    |> Enum.map(&game_info_tuple/1)
    |> reply(t)
  end


  defp reply(msg, t), do: {:reply, msg, t}

  defp game_info_tuple(game_id), do: {game_id, GameServer.starting_info(game_id)}
end
