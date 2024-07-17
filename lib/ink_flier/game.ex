defmodule InkFlier.Game do
  use TypedStruct

  alias InkFlier.HouseRules
  alias InkFlier.RaceTrack
  alias InkFlier.Board

  typedstruct enforce: true do
    field :board, Board.t
    # field :players...
  end

  def new(players, track, house_rules \\ HouseRules.new) do
    with :ok <- validate_track(track),
         :ok <- validate_house_rules(house_rules) do

      track
      |> Board.new
      |> Board.start(players, house_rules.random_pole_position?)
      |> then(& struct!(__MODULE__, board: &1))
      |> ok
    end
  end

  def current_positions(t), do: Board.current_positions(t.board)


  defp validate_track(%RaceTrack{}), do: :ok
  defp validate_track(_), do: {:error, :invalid_track}

  defp validate_house_rules(%HouseRules{}), do: :ok
  defp validate_house_rules(_), do: {:error, :invalid_house_rules}

  defp ok(t), do: {:ok, t}
end
