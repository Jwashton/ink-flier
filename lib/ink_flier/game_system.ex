defmodule InkFlier.GameSystem do
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, Keyword.put(opts, :name, __MODULE__))
  end


  @impl Supervisor
  def init(:ok) do
    children = [
      InkFlier.GameSupervisor,
      InkFlier.LobbyServer,
      InkFlier.GameStoreServer,
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
