defmodule InkFlier.Lobby do
  use TypedStruct

  typedstruct enforce: true do
    field :games, games, default: []
  end

  @type game_id :: any
  @type games :: [game_id]

  def new, do: struct!(__MODULE__)

  @spec generate_id :: game_id
  def generate_id do
    :crypto.strong_rand_bytes(8)
    |> Base.url_encode64(padding: false)
  end

  def games(t), do: t.games |> Enum.reverse

  def track_game_id(t, id), do: update_in(t.games, &[id | &1])
  def untrack_game_id(t, id), do: update_in(t.games, &List.delete(&1, id))
end
