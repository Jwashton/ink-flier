defmodule InkFlier.GameSupervisor do
  use DynamicSupervisor
  alias InkFlier.GameServer
  alias InkFlierWeb.GameChannel

  @name __MODULE__

  def start_link(opts), do: DynamicSupervisor.start_link(__MODULE__, :ok, Keyword.put(opts, :name, @name))

  def start_game!(game_opts), do: {:ok, _pid} = start_game(game_opts)
  def start_game(game_opts), do: DynamicSupervisor.start_child(@name, {GameServer, game_opts})

  def delete_game!(game_id), do: :ok = delete_game(game_id)
  def delete_game(game_id) do
    :ok = DynamicSupervisor.terminate_child(@name, GameServer.whereis(game_id))
    :ok = GameChannel.notify_game_deleted(game_id)
  end

  def count_children, do: DynamicSupervisor.count_children(@name)


  @impl DynamicSupervisor
  def init(:ok), do: DynamicSupervisor.init(strategy: :one_for_one)
end
