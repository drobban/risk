defmodule Risk.Judge.Context do
  defstruct play_order: [],
            current_player: nil,
            phases: [:re_step1, :re_step2, :re_step3, :battle, :troop_movement, :check_victor],
            current_phase: nil,
            battle_ground: nil
end
