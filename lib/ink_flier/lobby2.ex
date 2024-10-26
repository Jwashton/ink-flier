defmodule InkFlier.Lobby2 do
  use TypedStruct
  import TinyMaps

  typedstruct enforce: true do
    field :game_supervisor, InkFlier.GameSupervisor.name
    field :games, games, default: []
  end

  @type game_id :: any
  @type games :: [game_id]

  def new(game_supervisor), do: struct!(__MODULE__, ~M{game_supervisor})

  def generate_id do
    :crypto.strong_rand_bytes(8)
    |> Base.url_encode64(padding: false)
  end
end
