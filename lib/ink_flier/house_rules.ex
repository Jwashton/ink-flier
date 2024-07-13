defmodule InkFlier.HouseRules do
  defstruct []

  # TODO This will have the default rules, by default, then can override others.
  def new, do: struct!(__MODULE__)
end
