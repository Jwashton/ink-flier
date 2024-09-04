defmodule InkFlierTest.RaceTrack do
  use ExUnit.Case

  alias InkFlierTest.Helpers
  alias InkFlier.RaceTrack
  alias InkFlier.Car

  @t Helpers.test_track

  test "Check for collisions" do
    assert RaceTrack.check_collision(@t, {11,0}, {11,1}) == :ok
    assert RaceTrack.check_collision(@t, {14,14}, {99,99}) == {:collision, MapSet.new(["Outer Wall"])}
    assert RaceTrack.check_collision(@t, {-99,-99}, {99,99}) == {:collision, MapSet.new(["Outer Wall", "Inner Wall"])}
  end

  test "Can just give a car to check if it crashed on it's last move" do
    car =
      Car.new({14,14})
      |> Car.move({99,99})
    assert RaceTrack.check_collision(@t, car) == {:collision, MapSet.new(["Outer Wall"])}
  end
end
