defmodule InkFlier.LobbyServer2 do
  use GenServer

  alias InkFlier.Lobby2

  @name __MODULE__

  def start_link(opts) do
    opts = Keyword.put_new(opts, :name, @name)
    game_supervisor = Keyword.fetch!(opts, :game_supervisor)

    GenServer.start_link(__MODULE__, game_supervisor, opts)
  end

  def start_game(name \\ @name, game_opts \\ []), do: GenServer.call(name, {:start_game, game_opts})
  def games(name \\ @name), do: GenServer.call(name, :games)


  @impl GenServer
  def init(game_supervisor), do: {:ok, Lobby2.new(game_supervisor)}

  @impl GenServer
  def handle_call({:start_game, game_opts}, _, t) do
    game_id = Lobby2.generate_id
    raise "here next"
    # TODO (next test) :ok = started gameserver...

    {:reply, {:ok, game_id}, Lobby2.track_game_id(t, game_id)}
  end

  @impl GenServer
  def handle_call(:games, _, t), do: {:reply, Lobby2.games(t), t}
end
