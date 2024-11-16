defmodule InkFlier.LobbyServer do
  use GenServer

  alias InkFlier.GameSupervisor
  alias InkFlier.GameServer
  alias InkFlier.GameStoreServer

  @type game_id :: any
  @type games :: [game_id]

  @name __MODULE__

  def start_link(opts), do: GenServer.start_link(__MODULE__, :ok, Keyword.put(opts, :name, @name))

  def start_game(game_opts) do
    game_id = generate_id()
    :ok = GameStoreServer.track_game_id(game_id)
    {:ok, _pid} = GameSupervisor.start_game(Keyword.put(game_opts, :id, game_id))

    {:ok, game_id}
  end

  def delete_game(game_id) do
    :ok = GameSupervisor.delete_game(game_id)
    :ok = GameStoreServer.untrack_game_id(game_id)
  end

  def games, do: GenServer.call(@name, :games)
  def games_info, do: GenServer.call(@name, :games_info)

  def whereis(game_id), do: game_id |> GameServer.via |> GenServer.whereis


  @impl GenServer
  def init(:ok), do: {:ok, nil}

  @impl GenServer
  def handle_call(:games, _, t), do: {:reply, GameStoreServer.games, t}

  @impl GenServer
  def handle_call(:games_info, _, t) do
    GameStoreServer.games
    |> Enum.map(&GameServer.summary_info/1)
    |> reply(t)
  end


  defp reply(msg, t), do: {:reply, msg, t}

  @spec generate_id :: game_id
  def generate_id do
    :crypto.strong_rand_bytes(8)
    |> Base.url_encode64(padding: false)
  end
end
