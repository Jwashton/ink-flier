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


  def games(t), do: t.games
end
