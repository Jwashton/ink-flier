defmodule InkFlier.RaceTrack do
  @enforce_keys ~w(inner_wall outer_wall start_line checkline_1 checkline_2)a
  defstruct @enforce_keys
end
