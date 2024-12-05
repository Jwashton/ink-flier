defmodule InkFlier.GameServer do
  use GenServer

  alias InkFlier.Game

  def start_link(opts), do: GenServer.start_link(__MODULE__, opts, name: opts |> Keyword.get(:name) |> via)

  def join(id, player), do: GenServer.call(via(id), {:join, player})
  def remove(id, player), do: GenServer.call(via(id), {:remove, player})

  def players(id), do: GenServer.call(via(id), :players)
  def summary_info(id), do: GenServer.call(via(id), :summary_info)
  def begin(id), do: GenServer.call(via(id), :begin)

  def via(id), do: {:via, Registry, {Registry.Game, id}}
  def whereis(id), do: via(id) |> GenServer.whereis


  @impl GenServer
  def init(opts), do: {:ok, Game.new(opts)}

  @impl GenServer
  def handle_call({:join, player}, _, t), do: reply_with_ok_or_error(t, Game.add_player(t, player))

  @impl GenServer
  def handle_call({:remove, player}, _, t), do: reply_with_ok_or_error(t, Game.remove_player(t, player))

  @impl GenServer
  def handle_call(:creator, _, t), do: {:reply, Game.creator(t), t}

  @impl GenServer
  def handle_call(:players, _, t), do: {:reply, Game.players(t), t}

  @impl GenServer
  def handle_call(:summary_info, _, t), do: {:reply, Game.summary_info(t), t}

  @impl GenServer
  def handle_call(:begin, _, t), do: reply_with_ok_or_error(t, Game.begin(t))


  defp reply_with_ok_or_error(t, reply) do
    case reply do
      {:ok, t} -> {:reply, :ok, t}
      {:error, _} = error -> {:reply, error, t}
    end
  end
end
