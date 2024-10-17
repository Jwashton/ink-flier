defmodule InkFlier.Lobby do
  use TypedStruct

  alias InkFlier.Game

  typedstruct enforce: true do
    field :next_game_id, game_id, default: 1
    field :games, games, default: %{}
  end

  @type game_id :: integer
  @type games :: %{game_id => Game.t}

  def new, do: struct!(__MODULE__)

  def add_game(t, game) do
    game_id = t.next_game_id
    t =
      t
      |> add_game_under_id(game_id, game)
      |> inc_next_game_id

    {t, game_id}
  end

  def delete_game(t, game_id), do: update_in(t.games, &Map.delete(&1, game_id))

  def games(t), do: t.games
  def game(t, game_id), do: t.games[game_id]


  defp add_game_under_id(t, game_id, game), do: update_in(t.games, &Map.put(&1, game_id, game))
  defp inc_next_game_id(t), do: update_in(t.next_game_id, & &1 + 1)
end
