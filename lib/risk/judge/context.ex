defmodule Risk.Judge.Context do
  alias Risk.Judge.State, as: JudgeState

  defstruct play_order: [],
            current_player: nil,
            phases: [
              JudgeState.ReStep1,
              JudgeState.ReStep2,
              JudgeState.ReStep3,
              JudgeState.Battle,
              JudgeState.TroopMovement,
              JudgeState.CheckVictor
            ],
            current_phase: nil,
            battle_ground: nil
end
