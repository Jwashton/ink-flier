defmodule InkFlier.Game do
  use TypedStruct

  alias InkFlier.HouseRules
  alias InkFlier.RaceTrack
  alias InkFlier.Board

  typedstruct enforce: true do
    field :board, Board.t
  end

  def new(players, track, house_rules \\ HouseRules.new) do
    with :ok <- validate_track(track),
         :ok <- validate_house_rules(house_rules) do

      board =
        track
        |> Board.new
        |> Board.start(players, house_rules.random_pole_position?)

      # {:ok, :TODO_game, starting_positions}
      {:ok, :TODO_game, Board.current_positions(board)}
    end
  end


  defp validate_track(%RaceTrack{}), do: :ok
  defp validate_track(_), do: {:error, :invalid_track}

  defp validate_house_rules(%HouseRules{}), do: :ok
  defp validate_house_rules(_), do: {:error, :invalid_house_rules}
end
