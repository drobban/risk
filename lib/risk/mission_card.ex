defmodule Risk.MissionCard do
  # Mission rule will hold a rule function that is applied to game context to check for winners.
  @enforce_keys [:mission_rule, :mission_description]
  defstruct [:mission_rule, :mission_description]
end
