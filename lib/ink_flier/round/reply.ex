defmodule InkFlier.Round.Reply do
  @moduledoc """
  Helper module for managing a Round's reply, which consists of the Round itself, plus a list of Instructions
  """

  alias InkFlier.Round

  @type t :: Round.reply

  @spec update_round(Round.t, any) :: t
  def update_round(%Round{} = round, a), do: round |> new |> update_round(a)

  @spec update_round(t, (Round.t -> Round.t)) :: t
  def update_round({round, _} = t, round_updater) do
    round
    |> round_updater.()
    |> set_round(t)
  end


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

  defp set_round(round, t), do: put_elem(t, 0, round)
  defp set_instructions(instructions, t), do: put_elem(t, 1, instructions)
end
