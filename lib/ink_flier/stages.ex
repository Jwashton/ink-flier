defmodule InkFlier.Stages do
  use TypedStruct

  typedstruct enforce: true do
    field :stage, stage, default: :initial_setup
    field :player_ids, any, enforce: false
  end

  # TODO add all possible stages here to type after deciding the last few
  @type stage :: :todo

#   def new, do: struct!(__MODULE__)

#   def check(%{stage: :adding_players} = t, :add_player), do: {:ok, t}

#   def check(_t, _event), do: :error
end
