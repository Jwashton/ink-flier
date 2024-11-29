defmodule InkFlierWeb.GameControllerTest do
  use InkFlierWeb.ConnCase
  import TinyMaps

  alias InkFlier.Lobby
  alias InkFlier.GameServer
  alias InkFlier.GameSystem

  setup do: (start_supervised!(GameSystem); :ok)

  describe "Login" do
    setup [:login]

    test "Page loads normally when game exists", ~M{conn} do
      {:ok, game_id} = Lobby.start_game(creator: "BillyBob")

      conn = get(conn, ~p"/lobby/game/#{game_id}")
      assert html_response(conn, 200) =~ "Game id: #{game_id}"
    end

    test "If game doesn't exist, don't crash", ~M{conn} do
      conn = get(conn, ~p"/lobby/game/badGameId")
      assert html_response(conn, 404) =~ "does not exist"
    end

    @tag :skip
    test "If game started, go to correct phase page", ~M{conn} do
      {:ok, game_id} = Lobby.start_game(creator: "BillyBob", join: true)
      :ok = GameServer.start(game_id)

      assert html_response(conn, 200) =~ "Positions"
    end
  end


  defp login(~M{conn}), do: [conn: init_test_session(conn, %{user: "Bob"})]
end
