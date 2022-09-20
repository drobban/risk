defmodule Risk.RiskCard do
  @enforce_keys [:territory, :value]
  defstruct [:territory, :value]
end
