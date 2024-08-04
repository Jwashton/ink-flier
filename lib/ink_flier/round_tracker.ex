defmodule InkFlier.RoundTracker do
  use TypedStruct

  @type current_round :: integer

  typedstruct enforce: true do
    field :current, current_round, default: 1
  end

  def new, do: struct!(__MODULE__)

  def advance(t) do
    update_in(t.current, & &1 + 1)
  end

  def current(t), do: t.current
end
