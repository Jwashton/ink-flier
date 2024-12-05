defmodule InkFlierWeb.LobbyGameController do
  use InkFlierWeb, :controller
  import TinyMaps

  alias InkFlier.GameServer

  plug :assign, styles: ["/assets/css/lobby-game.css"]

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
    cond do
      !GameServer.whereis(game_id) ->
        conn
        |> assign(~M{game_id})
        |> put_status(404)
        |> render(:bad_game_id)

      GameServer.summary_info(game_id).phase == :begun ->
        conn
        |> assign(GameServer.summary_info(game_id))
        |> assign(~M{game_id})
        |> assign(scripts: [~p"/assets/js/game_channel.js"])
        |> render(:started)

      true ->
        conn
        |> assign(GameServer.summary_info(game_id))
        |> assign(~M{game_id})
        |> assign(scripts: [~p"/assets/js/game_channel.js"])
        |> render
    end
  end
end
