defmodule InkFlier.Lobby do
  alias InkFlier.GameStoreServer
  alias InkFlier.GameSupervisor
  alias InkFlier.GameServer

  @type game_id :: any
  @type games :: [game_id]

  def start_game(game_opts) do
    with :ok <- validate_auto_join(game_opts) do
      game_id = generate_id()
      :ok = GameStoreServer.track_game_id(game_id)
      {:ok, _pid} = GameSupervisor.start_game(Keyword.put(game_opts, :name, game_id))

      {:ok, game_id}
    end
  end

  def delete_game(game_id) do
    :ok = GameSupervisor.delete_game(game_id)
    :ok = GameStoreServer.untrack_game_id(game_id)
  end

  defdelegate games, to: GameStoreServer
  def games_info, do: Enum.map(games(), &GameServer.summary_info/1)


  defp generate_id do
    :crypto.strong_rand_bytes(8)
    |> Base.url_encode64(padding: false)
  end

  defp validate_auto_join(opts) do
    cond do
      Keyword.get(opts, :join) == true and !Keyword.has_key?(opts, :creator) ->
        {:error, :set_creator_to_auto_join}

      true -> :ok
    end
  end
end
