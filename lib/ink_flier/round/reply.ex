defmodule InkFlier.Round.Reply do
  @moduledoc """
  An abstraction for returning both an updated Round and a of notification Instructions
  """

  alias InkFlier.Round

  @type t :: {Round.t, [Round.instruction]}

  def new(round), do: {round, []}

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

#   def round(t), do: elem(t, 0)
#   def instructions(t), do: elem(t, 1)


  defp set_instructions(instructions, t), do: put_elem(t, 1, instructions)
end
