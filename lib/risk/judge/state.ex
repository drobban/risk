import EnumType

defenum Risk.Judge.State do
  value(Init, :init)
  value(ReStep1, :re_step1)
  value(ReStep2, :re_step2)
  value(ReStep3, :re_step3)
  value(Battle, :battle)
  value(TroopMovement, :troop_movement)
  value(CheckVictor, :check_victor)
end
