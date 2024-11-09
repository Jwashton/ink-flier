defmodule InkFlier.LobbyServer do
  @moduledoc """
  Process for managing Games (GameServer processes)

  LobbyServer (this) and GameSupervisor are started in Application. LobbyServer tells GameSupervisor when
  to start & stop games. It also keeps a cache list of those Game processes' names

    -Note the 2 things being maintained in parallel:
      - The actual GameServer processes (supervised by GameSupervisor)
      - The list of the via-names of those processes (kept in the state of *this* process)
  """

  use GenServer

  alias InkFlier.Lobby
  alias InkFlier.GameSupervisor
  alias InkFlier.GameServer

  @name __MODULE__

  def start_link(opts), do: GenServer.start_link(__MODULE__, :ok, Keyword.put(opts, :name, @name))

  def start_game(game_opts), do: GenServer.call(@name, {:start_game, game_opts})
  def delete_game(game_id), do: GenServer.call(@name, {:delete_game, game_id})
  def games, do: GenServer.call(@name, :games)
  def games_info, do: GenServer.call(@name, :games_info)

  def whereis(game_id), do: game_id |> GameServer.via |> GenServer.whereis


  @impl GenServer
  def init(:ok), do: {:ok, Lobby.new}

  @impl GenServer
  def handle_call({:start_game, game_opts}, _, t) do
    game_id = Lobby.generate_id
    game_opts = Keyword.put(game_opts, :id, game_id)

    t = Lobby.track_game_id(t, game_id)
    GameSupervisor.start_game!(game_opts)

    {:reply, {:ok, game_id}, t}
  end

  @impl GenServer
  def handle_call({:delete_game, game_id}, _, t) do
    t = Lobby.untrack_game_id(t, game_id)
    GameSupervisor.delete_game(whereis(game_id))

    {:reply, :ok, t}
  end

  @impl GenServer
  def handle_call(:games, _, t), do: {:reply, Lobby.games(t), t}

  @impl GenServer
  def handle_call(:games_info, _, t) do
    t
    |> Lobby.games
    |> Enum.map(&GameServer.summary_info/1)
    |> reply(t)
  end


  defp reply(msg, t), do: {:reply, msg, t}
end
