defmodule InkFlier.Game do
  alias InkFlier.HouseRules
  alias InkFlier.RaceTrack

  def new(_players, track, house_rules) do
    with :ok <- validate_track(track),
         :ok <- validate_house_rules(house_rules) do
      {:ok, :TODO_game, :TODO_starting_positions}
    end
  end


  defp validate_track(%RaceTrack{}), do: :ok
  defp validate_track(_), do: {:error, :invalid_track}

  defp validate_house_rules(_), do: :ok
end
