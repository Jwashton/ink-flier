defmodule InkFlierWeb.LobbyChannelTest do
  use InkFlierWeb.ChannelCase
  import TinyMaps

  import InkFlierWebTest.ChannelSetup, only: [start_game: 1, join_lobby_channel: 1]

  alias InkFlier.LobbyServer

  setup do
    start_supervised!(InkFlier.GameSystem)
    :ok
  end


  describe "Start games then join lobby" do
    setup [:start_game, :join_lobby_channel]

    test "On joining the channel, should receive a list of started games", ~M{lobby_join_reply} do
      assert [game1 | []] = lobby_join_reply
      assert game1.creator == "BillyBob"
    end

    test "Push delete also works", ~M{lobby_socket, game_id} do
      push!(lobby_socket, "delete_game", game_id)

      assert LobbyServer.games_info |> length == 0
      assert_broadcast "game_deleted", %{game_id: ^game_id}
    end
  end

  describe "Push: create_game" do
    setup [:join_lobby_channel, :push_create_game]

    test "actually creats a game" do
      assert LobbyServer.games_info |> length == 1
    end

    test "broadcasts the resulting game" do
      assert_broadcast "game_created", %{creator: "Robin"}
    end
  end


  defp push_create_game(~M{lobby_socket}) do
    push!(lobby_socket, "create_game", %{})
    :ok
  end
end
