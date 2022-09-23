defmodule JudgeTest do
  require Logger
  use ExUnit.Case

  test "Test next player" do
    {:ok, judge} = Risk.Judge.start_link()

    GenStateMachine.cast(judge, {:add_player, %Risk.Player{name: "David", guid: 111}})
    GenStateMachine.cast(judge, {:add_player, %Risk.Player{name: "Berit", guid: 112}})
    GenStateMachine.cast(judge, {:add_player, %Risk.Player{name: "Ceasar", guid: 113}})

    [p1, p2, p3] = GenStateMachine.call(judge, :get_play_order)
    for _x <- 1..9 do
      assert p1 == GenStateMachine.call(judge, :next_player)
      assert p2 == GenStateMachine.call(judge, :next_player)
      assert p3 == GenStateMachine.call(judge, :next_player)
    end

  end

  test "Test next phase" do
    {:ok, judge} = Risk.Judge.start_link()

    GenStateMachine.cast(judge, {:add_player, %Risk.Player{name: "David", guid: 111}})
    GenStateMachine.cast(judge, {:add_player, %Risk.Player{name: "Berit", guid: 112}})
    GenStateMachine.cast(judge, {:add_player, %Risk.Player{name: "Ceasar", guid: 113}})

    [phase1, phase2, phase3, phase4, phase5, phase6] = %Risk.Judge.Context{}.phases
    for _x <- 1..12 do
      assert phase1 == GenStateMachine.call(judge, :next_phase)
      assert phase2 == GenStateMachine.call(judge, :next_phase)
      assert phase3 == GenStateMachine.call(judge, :next_phase)
      assert phase4 == GenStateMachine.call(judge, :next_phase)
      assert phase5 == GenStateMachine.call(judge, :next_phase)
      assert phase6 == GenStateMachine.call(judge, :next_phase)
    end
  end

end
