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

  test "Should get a list of started games on join" do
    {:ok, _game_id} = LobbyServer.start_game(@lobby, creator: "BillyBob")

    {:ok, reply, _socket} =
      InkFlierWeb.UserSocket
      |> socket("user_id", %{user: "Robin", lobby: @lobby})
      |> subscribe_and_join(InkFlierWeb.LobbyChannel, "lobby:main")

    assert %{todo: 321} in reply
  end

  # test "next" do
  #   # push(socket, "create_game", %{})
  #   # assert_broadcast "game_created", reply
  # end

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
