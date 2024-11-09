defmodule InkFlier.GameSupervisor do
  use DynamicSupervisor
  alias InkFlier.GameServer

  @name __MODULE__

  def start_link(opts) do
    DynamicSupervisor.start_link(__MODULE__, :ok, Keyword.put(opts, :name, @name))
  end

  def start_game(game_opts), do: DynamicSupervisor.start_child(@name, {GameServer, game_opts})
  def start_game!(game_opts), do: {:ok, _pid} = start_game(game_opts)

  def delete_game(pid), do: DynamicSupervisor.terminate_child(@name, pid)
  def delete_game!(pid), do: :ok = delete_game(pid)

  def count_children, do: DynamicSupervisor.count_children(@name)


  @impl DynamicSupervisor
  def init(:ok), do: DynamicSupervisor.init(strategy: :one_for_one)
end
