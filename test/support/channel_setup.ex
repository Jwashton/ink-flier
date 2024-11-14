defmodule InkFlierWebTest.ChannelSetup do
  use InkFlierWeb.ChannelCase
  import TinyMaps

  alias InkFlier.LobbyServer

  def start_game(_) do
    {:ok, game_id} = LobbyServer.start_game(creator: "BillyBob")
    game_topic = "game:" <> game_id
    ~M{game_id, game_topic}
  end
end
