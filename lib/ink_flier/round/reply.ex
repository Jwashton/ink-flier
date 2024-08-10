defmodule InkFlier.Round.Reply do
  alias InkFlier.Round

  @type t :: {Round.t, [Round.instruction]}

  @spec new(Round.t) :: t
  def new(round), do: {round, []}

  @spec round(t, (Round.t -> Round.t)) :: t
  def round({round, _} = t, round_updater) do
    round
    |> round_updater.()
    |> then(& put_elem(t, 0, &1) )
  end

  @spec instruction(t, (Round.t -> Round.instruction) ) :: t
  def instruction({round, _instructions} = t, new_instruction_func) when is_function(new_instruction_func) do
    instruction(t, new_instruction_func.(round))
  end

  @spec instruction(t, Round.instruction) :: t
  def instruction({_round, instructions} = t, new_instruction) do
    instructions ++ [new_instruction]
    |> then(& put_elem(t, 1, &1) )
  end
end
