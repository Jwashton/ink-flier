defmodule InkFlier.GameSupervisor do
  use DynamicSupervisor

  alias InkFlier.GameServer

  @typedoc "Unique global name the single GameSupervisor"
  @type name :: module

  @name __MODULE__

  def start_link(opts) do
    opts = Keyword.put_new(opts, :name, @name)
    DynamicSupervisor.start_link(__MODULE__, :ok, opts)
  end

  def start_game(name \\ @name, game_opts), do: DynamicSupervisor.start_child(name, {GameServer, game_opts})
  def start_game!(name \\ @name, game_opts), do: {:ok, _pid} = start_game(name, game_opts)


  @impl DynamicSupervisor
  def init(:ok), do: DynamicSupervisor.init(strategy: :one_for_one)
end
