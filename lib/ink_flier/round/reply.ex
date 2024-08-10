defmodule InkFlier.Round.Reply do
  @moduledoc """
  Helper module for managing a Round's reply, which consists of the Round itself, plus a list of Instructions
  """

  alias InkFlier.Round

  @type t :: {Round.t, [Round.instruction]}


  @spec round(Round.t, any) :: t
  def round(%Round{} = round, a), do: round |> new |> round(a)

  @spec round(t, (Round.t -> Round.t)) :: t
  def round({round, _} = t, round_updater) do
    round
    |> round_updater.()
    |> update_round(t)
  end


  @spec instruction(Round.t, any) :: t
  def instruction(%Round{} = round, a), do: round |> new |> instruction(a)

  @spec instruction(t, (Round.t -> Round.instruction) ) :: t
  def instruction({round, _} = t, new_instruction_func) when is_function(new_instruction_func) do
    instruction(t, new_instruction_func.(round))
  end

  @spec instruction(t, [Round.instruction]) :: t
  def instruction({_, instructions} = t, new_instructions) when is_list(new_instructions) do
    instructions ++ new_instructions
    |> update_instructions(t)
  end

  @spec instruction(t, Round.instruction) :: t
  def instruction(t, new_instruction) do
    instruction(t, [new_instruction])
  end


  defp new(round), do: {round, []}

  defp update_round(round, t), do: put_elem(t, 0, round)
  defp update_instructions(instructions, t), do: put_elem(t, 1, instructions)
end
