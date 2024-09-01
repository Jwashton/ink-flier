defmodule InkFlier.Round.Reply do
  @moduledoc """
  Helper module for managing a Round's reply, which consists of the Round itself, plus a list of Instructions
  """

  alias InkFlier.Round
  alias InkFlier.Round.Instruction

  @type t :: {Round.t, [Round.instruction]}

  defdelegate player_locked_in(t, player), to: Instruction


  @spec add_instruction(Round.t, any) :: t
  def add_instruction(%Round{} = round, a), do: round |> new |> add_instruction(a)

  @spec add_instruction(t, (Round.t -> Round.instruction) ) :: t
  def add_instruction({round, _} = t, new_instruction_func) when is_function(new_instruction_func) do
    add_instruction(t, new_instruction_func.(round))
  end

  @spec add_instruction(t, [Round.instruction]) :: t
  def add_instruction({_, instructions} = t, new_instructions) when is_list(new_instructions) do
    instructions ++ new_instructions
    |> set_instructions(t)
  end

  @spec add_instruction(t, Round.instruction) :: t
  def add_instruction(t, new_instruction) do
    add_instruction(t, [new_instruction])
  end


  defp new(round), do: {round, []}

  defp set_instructions(instructions, t), do: put_elem(t, 1, instructions)
end
