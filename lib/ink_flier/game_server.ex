defmodule InkFlier.GameServer do
  use GenServer

  alias InkFlier.Game

  def start_link({id, creator}), do: GenServer.start_link(__MODULE__, creator, name: via(id))
  def creator(id), do: GenServer.call(via(id), :creator)
  def starting_info(id), do: GenServer.call(via(id), :starting_info)


  @impl GenServer
  def init(creator) do
    {:ok, Game.new(creator)}
  end

  @impl GenServer
  def handle_call(:creator, _, t), do: {:reply, Game.creator(t), t}

  @impl GenServer
  def handle_call(:starting_info, _, t), do: {:reply, Game.starting_info(t), t}


  defp via(id), do: {:via, Registry, {Registry.Game, id}}
end
