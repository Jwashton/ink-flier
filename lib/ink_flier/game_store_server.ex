defmodule InkFlier.GameStoreServer do
  use GenServer
  alias InkFlier.GameStore

  @name __MODULE__

  def start_link(opts), do: GenServer.start_link(@name, :ok, Keyword.put(opts, :name, @name))
  def track_game_id(game_id), do: GenServer.call(@name, {:track_game_id, game_id})
  def untrack_game_id(game_id), do: GenServer.call(@name, {:untrack_game_id, game_id})
  def games, do: GenServer.call(@name, :games)


  @impl GenServer
  def init(:ok), do: {:ok, GameStore.new}

  @impl GenServer
  def handle_call({:track_game_id, game_id}, _, t), do: {:reply, :ok, GameStore.track_game_id(t, game_id)}

  @impl GenServer
  def handle_call({:untrack_game_id, game_id}, _, t), do: {:reply, :ok, GameStore.untrack_game_id(t, game_id)}

  @impl GenServer
  def handle_call(:games, _, t), do: {:reply, GameStore.games(t), t}
end
