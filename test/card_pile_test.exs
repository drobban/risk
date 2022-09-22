defmodule CardPileTest do
  use ExUnit.Case

  test "Card pile scencarios" do
    {:ok, pid} = GenServer.start_link(Risk.CardPile, nil, name: :CardPileTest)

    # Circle through pile
    for _x <- 1..120 do
      card = GenServer.call(pid, :pick)
      assert card != nil
      :ok = GenServer.cast(pid, {:put, card})
    end

  end
end
