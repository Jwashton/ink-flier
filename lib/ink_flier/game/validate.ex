defmodule InkFlier.Game.Validate do
  alias InkFlier.Game

  def player_exists(t, player_id) do
    if player_id in Game.players(t), do: :ok, else: {:error, :no_such_player}
  end

  def player_doesnt_exist(t, player_id) do
    unless player_id in Game.players(t), do: :ok, else: {:error, :player_already_in_game}
  end

  def atleast_one_player(t) do
    if length(Game.players(t)) >= 1, do: :ok, else: {:error, :requires_atleast_one_player}
  end
end
