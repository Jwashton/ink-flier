defmodule InkFlierWeb.GameControllerTest do
  use InkFlierWeb.ConnCase
  import TinyMaps

  describe "Login" do
    setup [:login]

    test "Page loads normally when game exists", ~M{conn} do
      start_supervised!(InkFlier.GameSystem)
      {:ok, game_id} = InkFlier.LobbyServer.start_game(creator: "BillyBob")

      conn = get(conn, ~p"/lobby/game/#{game_id}")
      assert html_response(conn, 200) =~ "Game id: #{game_id}"
    end

    test "If game doesn't exist, don't crash", ~M{conn} do
      conn = get(conn, ~p"/lobby/game/badGameId")
      assert html_response(conn, 404) =~ "does not exist"
    end
  end


  defp login(~M{conn}), do: [conn: init_test_session(conn, %{user: "Bob"})]
end