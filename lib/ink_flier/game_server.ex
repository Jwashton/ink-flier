defmodule InkFlier.GameServer do
  use GenServer

  alias InkFlier.Game

  def start_link(opts) do
    {id, opts} = Keyword.pop!(opts, :id)
    opts = Keyword.put(opts, :name, id)
    GenServer.start_link(__MODULE__, opts, name: via(id))
  end

  def join(id, player), do: GenServer.call(via(id), {:join, player})
  def remove(id, player), do: GenServer.call(via(id), {:remove, player})

  def creator(id), do: GenServer.call(via(id), :creator)
  def players(id), do: GenServer.call(via(id), :players)
  def starting_info(id), do: GenServer.call(via(id), :starting_info)

  def via(id), do: {:via, Registry, {Registry.Game, id}}


  @impl GenServer
  def init(opts) do
    {:ok, Game.new(opts)}
  end

  @impl GenServer
  def handle_call({:join, player}, _, t) do
    case Game.add_player(t, player) do
      {:ok, t} ->
        if Game.notify_module(t) do
          Game.notify_module(t).broadcast({:player_joined, Game.name(t), player})
        end
        {:reply, :ok, t}

      {:error, _} = error -> {:reply, error, t}
    end
  end

  @impl GenServer
  def handle_call({:remove, player}, _, t), do: reply_with_ok_or_error(t, Game.remove_player(t, player))

  @impl GenServer
  def handle_call(:creator, _, t), do: {:reply, Game.creator(t), t}

  @impl GenServer
  def handle_call(:players, _, t), do: {:reply, Game.players(t), t}

  @impl GenServer
  def handle_call(:starting_info, _, t), do: {:reply, Game.starting_info(t), t}


  # TODO note already exists, this is getting deleted and/or re-extract/dry'd a little later
  defp reply_with_ok_or_error(t, reply) do
    case reply do
      {:ok, t} -> {:reply, :ok, t}
      {:error, _} = error -> {:reply, error, t}
    end
  end
end
