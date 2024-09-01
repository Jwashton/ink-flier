defmodule InkFlier.Round.Instruction do
  alias InkFlier.Round
  alias InkFlier.Round.Reply

  def player_locked_in(reply, player) do
    reply
    |> Reply.add_instruction({:notify_room, {:player_locked_in, player}})
    |> Reply.add_instruction(&{:notify_player, player, {:ok, {:speed, Round.speed(&1, player)}}})
  end
end
