defmodule CardPileTest do
  use ExUnit.Case

  test "Card pile scencarios" do
    {:ok, pid} = GenServer.start_link(Risk.CardPile, nil)

    # Circle through pile
    for _x <- 1..120 do
      card = GenServer.call(pid, :pick)
      assert card != nil
      :ok = GenServer.cast(pid, {:put, card})
    end
  end

  test "Card pile count initial active" do
    {:ok, pid} = GenServer.start_link(Risk.CardPile, nil)
    count = GenServer.call(pid, :card_count)
    assert count == 42
  end

  test "Card pile added jokers to active" do
    {:ok, pid} = GenServer.start_link(Risk.CardPile, nil)
    for _x <- 1..42 do
      card = GenServer.call(pid, :pick)
      assert card != nil
    end

    card = GenServer.call(pid, :pick)
    assert card == %Risk.RiskCard{territory: "Joker", value: 0}
    count = GenServer.call(pid, :card_count)
    assert count == 1
  end
end
