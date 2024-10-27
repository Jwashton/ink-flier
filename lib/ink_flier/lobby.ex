defmodule InkFlier.Lobby do
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

  def games(t), do: t.games |> Enum.reverse
  def game_supervisor(t), do: t.game_supervisor

  def track_game_id(t, id), do: update_in(t.games, &[id | &1])
end
