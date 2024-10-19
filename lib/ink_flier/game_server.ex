defmodule InkFlier.GameServer do
  use GenServer

  def start_link({id, _creator}), do: GenServer.start_link(__MODULE__, :ok, name: via(id))
  def creator(_id) do
    # TODO hc
    "Robin"
  end

  @impl GenServer
  def init(:ok) do
    {:ok, []}
  end


  defp via(id), do: {:via, Registry, {Registry.Game, id}}
end
