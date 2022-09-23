defmodule Risk.Judge.BattleGround do
  @enforce_keys [:attacker, :defender, :force_amount, :defence, :territory]
  defstruct [:attacker, :defender, :force_amount, :defence, :territory]
end
