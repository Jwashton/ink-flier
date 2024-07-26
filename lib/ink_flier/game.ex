defmodule InkFlier.Game do
  use TypedStruct

  typedstruct enforce: true do
    field :players, players, default: []
    field :track, RaceTrack.t, enforce: false
  end

  @type player_id :: any
  @type players :: [player_id]

  @spec new :: t
  def new, do: struct!(__MODULE__)

  @spec add_player(t, players) :: t
  def add_player(t, list) when is_list(list), do: t |> update_players(& &1 ++ list)

  @spec add_player(t, player_id) :: t
  def add_player(t, player_id), do: t |> update_players(& &1 ++ [player_id])

  def select_track(t, track), do: Map.put(t, :track, track)

  def players(t), do: t.players
  def track(t), do: t.track


  defp update_players(t, update_func), do: update_in(t.players, update_func)
end
