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
  end

  describe "Push: create_game" do
    setup [:join_lobby, :push_create_game]

    test "actually creats a game" do
      assert_broadcast _msg, _payload
      # First do an assert_broadcast (or timer.sleep), since push/3 is async
      assert LobbyServer.games_info(@lobby) |> length == 1
    end

    test "broadcasts the resulting game" do
      assert_broadcast "game_created", %{creator: "Robin"}
    end
  end


  defp start_game(_) do
    {:ok, _game_id} = LobbyServer.start_game(@lobby, creator: "BillyBob")
    :ok
  end

  defp join_lobby(_) do
    {:ok, join_reply, socket} =
      InkFlierWeb.UserSocket
      |> socket("user_id", %{user: "Robin", lobby: @lobby})
      |> subscribe_and_join(InkFlierWeb.LobbyChannel, "lobby:main")
    ~M{join_reply, socket}
  end

  defp push_create_game(~M{socket}) do
    push(socket, "create_game", %{})
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
