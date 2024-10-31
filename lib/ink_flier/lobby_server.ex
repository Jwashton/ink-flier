defmodule InkFlier.LobbyServer do
  @moduledoc """
  Process for managing Games (GameServer processes)

  LobbyServer (this) and GameSupervisor are started in Application. LobbyServer tells GameSupervisor when
  to start & stop games. It also keeps a cache list of those Game processes' names

    -Note the 2 things being maintained in parallel:
      - The actual GameServer processes (supervised by GameSupervisor)
      - The list of the via-names of those processes (kept in the state of *this* process)

  Also responsible for sending pubsub notifications to lobby subscribers for events like "game #237
  had a player join" or "game #930 ended"

  May control a "General lobby chat" later
  """

  use GenServer

  alias InkFlier.Lobby
  alias InkFlier.GameSupervisor
  alias InkFlier.GameServer

  @name __MODULE__
  @topic "room:lobby"

  @doc """
  On start, LobbyServer needs to know the Name of the GameSupervisor he's using.
  That can be overridden (in tests, for example), but otherwise will just use GameSupervisor's system default
  """
  def start_link(opts) do
    opts = Keyword.put_new(opts, :name, @name)
    game_supervisor = Keyword.get(opts, :game_supervisor, GameSupervisor.default_name)

    GenServer.start_link(__MODULE__, game_supervisor, opts)
  end

  def start_game(name \\ @name, game_opts) do
    game_opts = Keyword.put(game_opts, :notify_module, __MODULE__)
    GenServer.call(name, {:start_game, game_opts})
  end
  def delete_game(name \\ @name, game_id), do: GenServer.call(name, {:delete_game, game_id})
  def games(name \\ @name), do: GenServer.call(name, :games)
  def games_info(name \\ @name), do: GenServer.call(name, :games_info)

  def whereis(game_id), do: game_id |> GameServer.via |> GenServer.whereis
  def topic, do: @topic

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
