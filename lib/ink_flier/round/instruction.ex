defmodule InkFlier.Round.Instruction do
  alias InkFlier.Round.Reply

  def player_locked_in(reply, player), do:
    Reply.add_instruction(reply, {:notify_room, {:player_locked_in, player}})
end
