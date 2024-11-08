defmodule InkFlierWeb.LobbyChannelTest do
  use InkFlierWeb.ChannelCase
  import TinyMaps
  alias InkFlier.LobbyServer
  alias InkFlier.GameSupervisor

  @lobby __MODULE__.LobbyServer
  @game_starter __MODULE__.GameSupervisor

  setup do
    start_supervised!({GameSupervisor, name: @game_starter})
    start_supervised!({LobbyServer, name: @lobby, game_supervisor: @game_starter})
    :ok
  end


  describe "Start games then join lobby" do
    setup [:start_game, :join_lobby]

    test "Should return a list of started games", ~M{join_reply} do
      assert [game1 | []] = join_reply
      assert game1.creator == "BillyBob"
    end

    test "Push delete also works", ~M{socket, game_id} do
      push(socket, "delete_game", game_id) |> assert_reply(:ok)

      assert LobbyServer.games_info(@lobby) |> length == 0
      assert_broadcast "game_deleted", %{game_id: ^game_id}
    end
  end

  describe "Push: create_game" do
    setup [:join_lobby, :push_create_game]

    test "actually creats a game" do
      assert LobbyServer.games_info(@lobby) |> length == 1
    end

    test "broadcasts the resulting game" do
      assert_broadcast "game_created", %{creator: "Robin"}
    end
  end



  defp start_game(_) do
    {:ok, game_id} = LobbyServer.start_game(@lobby, creator: "BillyBob")
    ~M{game_id}
  end

  defp join_lobby(_) do
    {:ok, join_reply, socket} =
      InkFlierWeb.UserSocket
      |> socket("user_id", %{user: "Robin", lobby: @lobby})
      |> subscribe_and_join(InkFlierWeb.LobbyChannel, "lobby:main")
    ~M{join_reply, socket}
  end

  defp push_create_game(~M{socket}) do
    # push/3 by itself is async. Use assert_reply/4 to wait for reply and not cause a race
    push(socket, "create_game", %{}) |> assert_reply(:ok)
    :ok
  end
end
