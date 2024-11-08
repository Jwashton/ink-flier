defmodule InkFlierWeb.GameChannelTest do
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


  test "Broadcast goes to multiple topics (Game AND Lobby)" do
    {:ok, game_id} = LobbyServer.start_game(@lobby, creator: "BillyBob")
    game_topic = "game:" <> game_id

    {:ok, _join_reply, game_socket} =
      InkFlierWeb.UserSocket
      |> socket("user_id", %{user: "Robin", lobby: @lobby})
      |> subscribe_and_join(InkFlierWeb.GameChannel, game_topic)

    {:ok, _join_reply, _lobby_socket} =
      InkFlierWeb.UserSocket
      |> socket("user_id", %{user: "Robin", lobby: @lobby})
      |> subscribe_and_join(InkFlierWeb.LobbyChannel, "lobby:main")

    push(game_socket, "join", %{}) |> assert_reply(:ok)
    %{topic: ^game_topic} = assert_broadcast("players_updated", _)
    %{topic: "lobby:main"} = assert_broadcast("game_updated", _)
  end

  # test "game doesn't exist, redirect gracefully" do
end
