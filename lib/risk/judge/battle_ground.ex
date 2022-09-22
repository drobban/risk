defmodule Risk.Judge.BattleGround do
  @enforce_keys [:attacker, :defender, :force_amount, :territory]
  defstruct [:attacker, :defender, :force_amount, :territory]
end
