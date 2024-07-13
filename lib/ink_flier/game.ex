defmodule InkFlier.Game do
  alias InkFlier.HouseRules
  alias InkFlier.RaceTrack

  def new(players, track, house_rules \\ HouseRules.new) do
    with :ok <- validate_track(track),
         :ok <- validate_house_rules(house_rules) do
      players_in_order = players_in_order(players, house_rules.random_pole_position?)

      starting_positions =
        track
        |> RaceTrack.start
        |> Enum.zip(players_in_order)
        |> Map.new

      {:ok, :TODO_game, starting_positions}
    end
  end


  defp validate_track(%RaceTrack{}), do: :ok
  defp validate_track(_), do: {:error, :invalid_track}

  defp validate_house_rules(%HouseRules{}), do: :ok
  defp validate_house_rules(_), do: {:error, :invalid_house_rules}

  defp players_in_order(players, true), do: Enum.shuffle(players)
  defp players_in_order(players, _), do: players
end
