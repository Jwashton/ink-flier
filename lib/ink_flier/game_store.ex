defmodule InkFlier.GameStore do
  use TypedStruct

  typedstruct enforce: true do
    field :games, InkFlier.LobbyServer.games, default: []
  end

  def new, do: struct!(__MODULE__)
  def games(t), do: t.games |> Enum.reverse

  def track_game_id(t, id), do: update_in(t.games, &[id | &1])
  def untrack_game_id(t, id), do: update_in(t.games, &List.delete(&1, id))
end
