defmodule InkFlierWeb.LobbyChannelTest do
  use InkFlierWeb.ChannelCase
  import TinyMaps

  import InkFlierWebTest.ChannelSetup, only: [start_game: 1]
  alias InkFlier.LobbyServer
  alias InkFlierWeb.LobbyChannel

  setup do
    start_supervised!(InkFlier.GameSystem)
    :ok
  end


  describe "Start games then join lobby" do
    setup [:start_game, :join_lobby]

    test "Should return a list of started games", ~M{join_reply} do
      assert [game1 | []] = join_reply
      assert game1.creator == "BillyBob"
    end

    test "Push delete also works", ~M{socket, game_id} do
      push!(socket, "delete_game", game_id)

      assert LobbyServer.games_info |> length == 0
      assert_broadcast "game_deleted", %{game_id: ^game_id}
    end
  end

  describe "Push: create_game" do
    setup [:join_lobby, :push_create_game]

    test "actually creats a game" do
      assert LobbyServer.games_info |> length == 1
    end

    test "broadcasts the resulting game" do
      assert_broadcast "game_created", %{creator: "Robin"}
    end
  end


  defp join_lobby(_) do
    {:ok, join_reply, socket} =
      InkFlierWeb.UserSocket
      |> socket("user_id", %{user: "Robin"})
      |> subscribe_and_join(LobbyChannel, LobbyChannel.topic)
    ~M{join_reply, socket}
  end

  defp push_create_game(~M{socket}) do
    push!(socket, "create_game", %{})
    :ok
  end
end
