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
    |> then(& put_elem(t, 0, &1) )
  end


  @spec instruction(Round.t, any) :: t
  def instruction(%Round{} = round, a), do: round |> new |> instruction(a)

  @spec instruction(t, (Round.t -> Round.instruction) ) :: t
  def instruction({round, _instructions} = t, new_instruction_func) when is_function(new_instruction_func) do
    instruction(t, new_instruction_func.(round))
  end

  @spec instruction(t, [Round.instruction]) :: t
  def instruction({_round, instructions} = t, new_instructions) when is_list(new_instructions) do
    instructions ++ new_instructions
    |> then(& put_elem(t, 1, &1) )
  end

  @spec instruction(t, Round.instruction) :: t
  def instruction({_round, instructions} = t, new_instruction) do
    instructions ++ [new_instruction]
    |> then(& put_elem(t, 1, &1) )
  end


  defp new(round), do: {round, []}
end
