defmodule InkFlier.Game do
  use TypedStruct

  typedstruct do
    field :creator, player_id
    field :track_id, InkFlier.RaceTrack.id
    field :players, players, default: []
    field :notify_module, module
    field :name, InkFlier.Lobby.game_id, required: true
  end

  @type observer_id :: any
  @type member_id :: player_id | observer_id

  @type player_id :: any
  @type players :: [player_id]

  def new(opts \\ []) do
    fields = Keyword.filter(opts, fn {k,_v} ->
      k in [:creator, :track_id, :players, :notify_module, :name]
    end)
    struct!(__MODULE__, fields)
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
  def notify_module(t), do: t.notify_module
  def name(t), do: t.name
end
