defmodule Risk.CardPile do
  use GenServer

  @impl true
  def init(_state) do
    stacks = %Risk.CardPile.Initial{}
    {:ok, stacks}
  end

  @impl true
  def handle_call(:pick, _from, %Risk.CardPile.Initial{active: [], discard: discarded} = stacks) do
    [card|cards] = Enum.shuffle(discarded)
    new_stacks = stacks |> Map.put(:active, cards) |> Map.put(:discard, [])

    {:reply, card, new_stacks}
  end

  @impl true
  def handle_call(:pick, _from, %Risk.CardPile.Initial{active: active, discard: discarded} = stacks) do
    [card | cards] = stacks.active
    new_stacks = stacks |> Map.put(:active, cards)

    {:reply, card, new_stacks}
  end

  @impl true
  def handle_cast({:put, %Risk.RiskCard{} = card}, stacks) do
    new_stacks = stacks |> Map.put(:discard, stacks.discard ++ [card])
    {:noreply, new_stacks}
  end
end
