defmodule InkFlier.Round.Instructions do
  @moduledoc """
  Instruction list of notifications to be sent to the entire room or to individual players/observers
  """

  alias InkFlier.Round
  alias InkFlier.Round.Instruction

  @type t :: [Round.instruction]

  def new, do: []

  defdelegate player_locked_in(t, player), to: Instruction
  defdelegate new_round(t, round_number), to: Instruction
  defdelegate send_summary(t, target), to: Instruction


  # @spec add_instruction(t, (Round.t -> Round.instruction) ) :: t
  # def add_instruction(t, new_instruction_func) when is_function(new_instruction_func) do
  #   add_instruction(t, new_instruction_func.(round))
  # end

  @spec add_instruction(t, [Round.instruction]) :: t
  def add_instruction(t, new_instructions) when is_list(new_instructions) do
    t ++ new_instructions
  end

  @spec add_instruction(t, Round.instruction) :: t
  def add_instruction(t, new_instruction) do
    add_instruction(t, [new_instruction])
  end
end
