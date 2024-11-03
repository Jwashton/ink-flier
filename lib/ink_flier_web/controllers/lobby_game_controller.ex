defmodule InkFlierWeb.LobbyGameController do
  use InkFlierWeb, :controller
  import TinyMaps

  alias InkFlier.GameServer

  def home(conn, ~m{game_id, _join} = params) do
    params =
      params
      |> Map.delete("join")
      |> Map.delete("game_id")

    case GameServer.join(game_id, conn.assigns.user) do
      :ok -> conn
      {:error, _} = error -> put_flash(conn, :error, inspect(error))
    end
    |> redirect(to: current_path(conn, params))
  end

  def home(conn, ~m{game_id}) do
    # TODO temporarily start_link a new game "321" in application... later it will need to be started from lobby

    ~M{creator, players} = GameServer.summary_info(game_id)

    conn
    # TODO don't think we're sending down players here anymore. Which means we might not need GameServer.starting_info... keep it for now is fine tho
    |> assign(~M{creator, players, game_id})
    |> render
  end
end
