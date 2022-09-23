defmodule JudgeTest do
  require Logger
  use ExUnit.Case

  test "Test next player" do
    {:ok, pid} = GenServer.start_link(Risk.Judge, nil)

    GenServer.cast(pid, {:add_player, %Risk.Player{name: "David", guid: 111}})
    GenServer.cast(pid, {:add_player, %Risk.Player{name: "Berit", guid: 112}})
    GenServer.cast(pid, {:add_player, %Risk.Player{name: "Ceasar", guid: 113}})

    [p1, p2, p3] = GenServer.call(pid, :get_play_order)
    for _x <- 1..9 do
      assert p1 == GenServer.call(pid, :next_player)
      assert p2 == GenServer.call(pid, :next_player)
      assert p3 == GenServer.call(pid, :next_player)
    end

  end

  test "Test next phase" do
    {:ok, pid} = GenServer.start_link(Risk.Judge, nil)

    GenServer.cast(pid, {:add_player, %Risk.Player{name: "David", guid: 111}})
    GenServer.cast(pid, {:add_player, %Risk.Player{name: "Berit", guid: 112}})
    GenServer.cast(pid, {:add_player, %Risk.Player{name: "Ceasar", guid: 113}})

    [phase1, phase2, phase3, phase4, phase5, phase6] = %Risk.Judge.State{}.phases
    for _x <- 1..12 do
      assert phase1 == GenServer.call(pid, :next_phase)
      assert phase2 == GenServer.call(pid, :next_phase)
      assert phase3 == GenServer.call(pid, :next_phase)
      assert phase4 == GenServer.call(pid, :next_phase)
      assert phase5 == GenServer.call(pid, :next_phase)
      assert phase6 == GenServer.call(pid, :next_phase)
    end
  end

end
