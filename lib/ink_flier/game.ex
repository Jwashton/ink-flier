defmodule InkFlier.Game do
  use TypedStruct
  alias __MODULE__.Opts
  alias __MODULE__.Validate

  typedstruct do
    field :name, InkFlier.Lobby.game_id, required: true
    field :creator, player_id
    field :track_id, InkFlier.RaceTrack.id
    field :players, players, default: []
    field :phase, phases, default: :setup
  end

  @type observer_id :: any
  @type member_id :: player_id | observer_id

  @type player_id :: any
  @type players :: [player_id]
  @type phases :: :setup | :begun

  def new(opts \\ []) do
    __MODULE__
    |> struct!(Opts.filter(opts))
    |> Opts.maybe_add_creator(opts)
  end

  def add_player(t, player_id) do
    with :ok <- Validate.player_doesnt_exist(t, player_id) do
      {:ok, add_player!(t, player_id)}
    end
  end

  def remove_player(t, player_id) do
    with :ok <- Validate.player_exists(t, player_id) do
      {:ok, remove_player!(t, player_id)}
    end
  end

  def begin(t) do
    with :ok <- Validate.atleast_one_player(t) do
      t
      |> set_phase(:begun)
      |> ok
    end
  end
  def begin!(t), do: ({:ok, t} = begin(t); t)

  def add_player!(t, player_id), do: update_in(t.players, &[player_id | &1])
  def remove_player!(t, player_id), do: update_in(t.players, &List.delete(&1, player_id))
  def set_phase(t, phase), do: put_in(t.phase, phase)

  def summary_info(t), do: t |> Map.from_struct

  def creator(t), do: t.creator
  def players(t), do: t.players |> Enum.reverse
  def track_id(t), do: t.track_id
  def name(t), do: t.name


  defp ok(t), do: {:ok, t}
end
