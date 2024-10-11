defmodule InkFlier.Game do
  @type t :: :todo
  @type player_id :: any
  @type observer_id :: any
  @type member_id :: player_id | observer_id

  use Agent

  def start_link(initial_value) do
    Agent.start_link(fn -> initial_value end)
  end

  def value(pid) do
    Agent.get(pid, & &1)
  end

  def increment(pid) do
    Agent.update(pid, &(&1 + 1))
  end
end
