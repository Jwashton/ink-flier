defmodule InkFlier.Lobby do
  use TypedStruct

  alias InkFlier.Game

  typedstruct enforce: true do
    field :next_game_id, game_id, default: 1
    field :games, games, default: %{}
    field :game_module, any, default: Game
  end

  @type game_id :: integer
  @type games :: %{game_id => Game.t}

  def new, do: struct!(__MODULE__)

  def create_game(t, track) do
    game = t.game_module.new(track)
    game_id = t.next_game_id

    t =
      t
      |> update_games(&Map.put(&1, game_id, game))
      |> inc_next_game_id

    {t, game_id}
  end


  def games(t), do: t.games

  def set_game_module(t, module), do: put_in(t.game_module, module)
  def update_games(t, func), do: update_in(t.games, func)
  def inc_next_game_id(t), do: update_in(t.next_game_id, & &1 + 1)
end
