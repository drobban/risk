defmodule Risk.Judge do
  use GenServer

  @impl true
  def init(_state) do
    state = %Risk.Judge.State{}
    {:ok, state}
  end

  @impl true
  def handle_cast({:add_player, %Risk.Player{} = player}, state) do
    state = state |> update_in([Access.key(:play_order)], &Enum.shuffle(&1 ++ [player]))
    {:noreply, state}
  end

  @impl true
  def handle_call(:get_play_order, _from, state) do
    {:reply, state.play_order, state}
  end

  @impl true
  def handle_call(:next_player, _from, state) do
    [next | players] = state.play_order
    players = if !is_nil(state.current_player), do: players ++ [state.current_player], else: players

    state =
      state
      |> Map.put(:play_order, players)
      |> Map.put(:current_player, next)

    {:reply, next, state}
  end

  @impl true
  def handle_call(:next_phase, _from, state) do
    [next | phases] = state.phases
    phases = if !is_nil(state.current_phase), do: phases ++ [state.current_phase], else: phases

    state =
      state
      |> Map.put(:phases, phases)
      |> Map.put(:current_phase, next)

    {:reply, next, state}
  end
end
