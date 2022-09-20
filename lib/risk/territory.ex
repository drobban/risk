defmodule Risk.Territory do
  @enforce_keys [:name, :borders]
  defstruct [:name, :borders, occupant: nil, forces: 0]
end
