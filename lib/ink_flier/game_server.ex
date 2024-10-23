defmodule InkFlier.GameServer do
  use GenServer

  alias InkFlier.Game

  def start_link({id, creator}), do: GenServer.start_link(__MODULE__, creator, name: via(id))
  def join(id, player), do: GenServer.call(via(id), {:join, player})
  def remove(id, player), do: GenServer.call(via(id), {:remove, player})
  def creator(id), do: GenServer.call(via(id), :creator)
  def players(id), do: GenServer.call(via(id), :players)
  def starting_info(id), do: GenServer.call(via(id), :starting_info)


  @impl GenServer
  def init(creator) do
    {:ok, Game.new(creator)}
  end

  @impl GenServer
  def handle_call({:join, player}, _, t) do
    case Game.add_player(t, player) do
      {:ok, t} -> {:reply, :ok, t}
      {:error, _} = error -> {:reply, error, t}
    end
  end

  @impl GenServer
  def handle_call({:remove, player}, _, t) do
    case Game.remove_player(t, player) do
      {:ok, t} -> {:reply, :ok, t}
      {:error, _} = error -> {:reply, error, t}
    end
  end

  @impl GenServer
  def handle_call(:creator, _, t), do: {:reply, Game.creator(t), t}

  @impl GenServer
  def handle_call(:players, _, t), do: {:reply, Game.players(t), t}

  @impl GenServer
  def handle_call(:starting_info, _, t), do: {:reply, Game.starting_info(t), t}


  defp via(id), do: {:via, Registry, {Registry.Game, id}}
end
