defmodule InkFlier.RoundTracker do
  use TypedStruct
  import TinyMaps

  @typedoc "Given order is maintained, although currently only used for prioritizing starting positions"
  @type players :: [player_id]

  @type current_round :: integer
  @type player_id :: any

  typedstruct enforce: true do
    field :current, current_round, default: 1
    field :players, players
    field :locked_in, MapSet.t(player_id), default: MapSet.new
  end

  def new(players), do: struct!(__MODULE__, ~M{players})

  def player_moved(t, player) do
    t
    |> lock_in(player)
    |> maybe_advance_round
  end

  def locked_in?(t, player), do: player in locked_in(t)


  defp maybe_advance_round(t) do
    if MapSet.equal?(players_set(t), locked_in(t)), do: advance_round(t), else: t
  end

  defp advance_round(t) do
    t
    |> advance_current
    |> reset_locked_in
  end


  def current(t), do: t.current
  defp locked_in(t), do: t.locked_in
  defp players(t), do: t.players

  defp players_set(t), do: t |> players |> MapSet.new

  defp reset_locked_in(t), do: put_in(t.locked_in, MapSet.new)

  defp advance_current(t), do: update_in(t.current, & &1 + 1)
  defp lock_in(t, player), do: update_in(t.locked_in, &MapSet.put(&1, player))
end
