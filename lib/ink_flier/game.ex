defmodule InkFlier.Game do
  use TypedStruct
  import TinyMaps

  typedstruct do
    field :creator, player_id
    field :track_id, InkFlier.RaceTrack.id
    field :players, players, default: []
  end

  @type observer_id :: any
  @type member_id :: player_id | observer_id

  @type player_id :: any
  @type players :: [player_id]

  def new(opts \\ []) do
    creator = Keyword.get(opts, :creator)
    track_id = Keyword.get(opts, :track_id)
    struct!(__MODULE__, ~M{creator, track_id})
  end

  def add_player(t, player_id) do
    unless player_id in t.players do
      {:ok, add_player!(t, player_id)}
    else
      {:error, :player_already_in_game}
    end
  end
  def add_player!(t, player_id), do: update_in(t.players, &[player_id | &1])

  def remove_player(t, player_id) do
    if player_id in t.players do
      {:ok, remove_player!(t, player_id)}
    else
      {:error, :no_such_player_to_remove}
    end
  end
  def remove_player!(t, player_id), do: update_in(t.players, &List.delete(&1, player_id))

  def starting_info(t), do: %{creator: t.creator, players: t.players, track_id: t.track_id}
  def creator(t), do: t.creator
  def players(t), do: t.players |> Enum.reverse
  def track_id(t), do: t.track_id
end
