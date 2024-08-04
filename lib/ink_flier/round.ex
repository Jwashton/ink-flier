defmodule InkFlier.Round do
  use TypedStruct

  @type current_round :: integer

  typedstruct enforce: true do
    field :current, current_round, default: 1
  end
end
