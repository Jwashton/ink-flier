defmodule InkFlier.GameServer do
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
