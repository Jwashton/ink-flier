defmodule InkFlierWeb.LobbyChannelTest do
  use InkFlierWeb.ChannelCase
  alias InkFlier.LobbyServer
  alias InkFlier.GameSupervisor

  @lobby __MODULE__.LobbyServer
  @game_starter __MODULE__.GameSupervisor

  setup do
    start_supervised!({GameSupervisor, name: @game_starter})
    start_supervised!({LobbyServer, name: @lobby, game_supervisor: @game_starter})
    :ok
  end


  describe "join" do
    setup [:start_game]

    test "Should get a list of started games" do
      {:ok, game_list_reply, _socket} =
        InkFlierWeb.UserSocket
        |> socket("user_id", %{user: "Robin", lobby: @lobby})
        |> subscribe_and_join(InkFlierWeb.LobbyChannel, "lobby:main")

      assert [game_reply | []] = game_list_reply
      assert game_reply.creator == "BillyBob"
    end
  end

  describe "Push: create_game" do
    test "actually creats a game" do
      InkFlierWeb.UserSocket
      |> socket("user_id", %{user: "Robin", lobby: @lobby})
      |> subscribe_and_join!(InkFlierWeb.LobbyChannel, "lobby:main")
      |> push("create_game", %{})

      assert_broadcast _msg, _payload
      # Needs to happen after assert_broadcast or time.sleeper, since push/3 is async aparently
      assert LobbyServer.games_info(@lobby) |> length == 1
    end

    test "broadcasts the resulting game" do
      InkFlierWeb.UserSocket
      |> socket("user_id", %{user: "Robin", lobby: @lobby})
      |> subscribe_and_join!(InkFlierWeb.LobbyChannel, "lobby:main")
      |> push("create_game", %{})

      assert_broadcast "game_created", %{creator: "Robin"}
    end
  end


  defp start_game(_) do
    {:ok, _game_id} = LobbyServer.start_game(@lobby, creator: "BillyBob")
    :ok
  end


  # test "ping replies with status ok", %{socket: socket} do
  #   ref = push(socket, "ping", %{"hello" => "there"})
  #   assert_reply ref, :ok, %{"hello" => "there"}
  # end

  # test "shout broadcasts to room:lobby", %{socket: socket} do
  #   push(socket, "shout", %{"hello" => "all"})
  #   assert_broadcast "shout", %{"hello" => "all"}
  # end

  # test "broadcasts are pushed to the client", %{socket: socket} do
  #   broadcast_from!(socket, "broadcast", %{"some" => "data"})
  #   assert_push "broadcast", %{"some" => "data"}
  # end
end
