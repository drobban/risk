defmodule Risk.Continent do
  @enforce_keys [:name, :bonus, :territories]
  defstruct [:name, :bonus, :territories]
end
