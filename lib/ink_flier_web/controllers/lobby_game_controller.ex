defmodule InkFlierWeb.LobbyGameController do
  use InkFlierWeb, :controller
  import TinyMaps

  alias InkFlier.GameServer

  # def home(conn, ~m{game_id, _join} = params) do
  #   params =
  #     params
  #     |> Map.delete("join")
  #     |> Map.delete("game_id")

  #   case GameServer.join(game_id, conn.assigns.user) do
  #     :ok -> conn
  #     {:error, _} = error -> put_flash(conn, :error, inspect(error))
  #   end
  #   |> redirect(to: current_path(conn, params))
  # end

  def home(conn, ~m{game_id}) do
    raise """next
    if whereis gameid (or something), assign like below, otherwise assign: bad game, or something
    """
    # ~M{creator, players} = GameServer.summary_info(game_id)
    [creator, players] = [nil, nil]

    conn
    |> assign(~M{creator, players, game_id})
    |> render
  end
end
