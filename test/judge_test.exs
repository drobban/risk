defmodule JudgeTest do
  require Logger
  use ExUnit.Case
  alias Risk.Judge.Event, as: JudgeEvent

  test "Test next player" do
    {:ok, judge} = Risk.Judge.start_link()

    GenStateMachine.cast(judge, {JudgeEvent.AddPlayer, %Risk.Player{name: "David", guid: 111}})
    GenStateMachine.cast(judge, {JudgeEvent.AddPlayer, %Risk.Player{name: "Berit", guid: 112}})
    GenStateMachine.cast(judge, {JudgeEvent.AddPlayer, %Risk.Player{name: "Ceasar", guid: 113}})

    [p1, p2, p3] = GenStateMachine.call(judge, JudgeEvent.GetPlayOrder)

    for _x <- 1..9 do
      assert p1 == GenStateMachine.call(judge, JudgeEvent.NextPlayer)
      assert p2 == GenStateMachine.call(judge, JudgeEvent.NextPlayer)
      assert p3 == GenStateMachine.call(judge, JudgeEvent.NextPlayer)
    end
  end

  test "Test next phase" do
    {:ok, judge} = Risk.Judge.start_link()

    GenStateMachine.cast(judge, {JudgeEvent.AddPlayer, %Risk.Player{name: "David", guid: 111}})
    GenStateMachine.cast(judge, {JudgeEvent.AddPlayer, %Risk.Player{name: "Berit", guid: 112}})
    GenStateMachine.cast(judge, {JudgeEvent.AddPlayer, %Risk.Player{name: "Ceasar", guid: 113}})

    [phase1, phase2, phase3, phase4, phase5, phase6] = %Risk.Judge.Context{}.phases

    for _x <- 1..12 do
      assert phase1 == GenStateMachine.call(judge, JudgeEvent.NextPhase)
      assert phase2 == GenStateMachine.call(judge, JudgeEvent.NextPhase)
      assert phase3 == GenStateMachine.call(judge, JudgeEvent.NextPhase)
      assert phase4 == GenStateMachine.call(judge, JudgeEvent.NextPhase)
      assert phase5 == GenStateMachine.call(judge, JudgeEvent.NextPhase)
      assert phase6 == GenStateMachine.call(judge, JudgeEvent.NextPhase)
    end
  end
end
