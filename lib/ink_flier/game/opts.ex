defmodule InkFlier.Game.Opts do
  alias InkFlier.Game

  def maybe_add_creator(game, opts) do
    maybe_add_player(game, Game.creator(game), auto_join?(opts))
  end

  def filter(opts) do
    allowed = struct!(Game) |> Map.from_struct |> Map.keys
    Keyword.filter(opts, fn {k,_v} -> k in allowed end)
  end


  defp auto_join?(opts), do: Keyword.get(opts, :join, false)

  defp maybe_add_player(game, player, true), do: Game.add_player!(game, player)
  defp maybe_add_player(game, _, _false), do: game
end
