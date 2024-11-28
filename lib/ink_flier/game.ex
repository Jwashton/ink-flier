defmodule InkFlier.Game do
  use TypedStruct

  typedstruct do
    field :name, InkFlier.Lobby.game_id, required: true
    field :creator, player_id
    field :track_id, InkFlier.RaceTrack.id
    field :players, players, default: []
  end

  @type observer_id :: any
  @type member_id :: player_id | observer_id

  @type player_id :: any
  @type players :: [player_id]

  def new(opts \\ []) do
    filtered_fields = Keyword.filter(opts, fn {k,_v} ->
      k in [:creator, :track_id, :players, :name]
    end)

    struct!(__MODULE__, filtered_fields)
    |> maybe_auto_join(opts)
  end

  def add_player(t, player_id) do
    with :ok <- check_player_doesnt_exist(t, player_id) do
      {:ok, add_player!(t, player_id)}
    end
  end

  def remove_player(t, player_id) do
    with :ok <- check_player_exists(t, player_id) do
      {:ok, remove_player!(t, player_id)}
    end
  end

  def add_player!(t, player_id), do: update_in(t.players, &[player_id | &1])
  def remove_player!(t, player_id), do: update_in(t.players, &List.delete(&1, player_id))

  def summary_info(t), do: t |> Map.from_struct
  def creator(t), do: t.creator
  def players(t), do: t.players |> Enum.reverse
  def track_id(t), do: t.track_id
  def notify_module(t), do: t.notify_module
  def name(t), do: t.name


  defp maybe_auto_join(t, opts) do
    if Keyword.get(opts, :join), do: add_player!(t, Keyword.get(opts, :creator)), else: t
  end

  defp check_player_exists(t, player_id) do
    if player_id in t.players, do: :ok, else: {:error, :no_such_player}
  end

  defp check_player_doesnt_exist(t, player_id) do
    unless player_id in t.players, do: :ok, else: {:error, :player_already_in_game}
  end
end
