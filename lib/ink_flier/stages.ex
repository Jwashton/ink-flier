defmodule InkFlier.Stages do
  defstruct stage: :adding_players

  def new, do: struct!(__MODULE__)

  def check(_t, _event), do: :error
end
