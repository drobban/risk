defmodule Risk.Game do
  require Logger
  use GenStateMachine, callback_mode: [:handle_event_function, :state_enter]
  alias Risk.GameContext, as: GameContext

  def start_link(name) do
    GenStateMachine.start_link(Risk.Game, {:player_announcements, %GameContext{}},
      name: String.to_atom(name)
    )
  end

  def handle_event(:enter, _event, state, data) do
    Logger.debug("#{inspect(data)}")
    {:next_state, state, data}
  end

  def handle_event(:cast, {:connection, pid} = _event, state, data) do
    connections = data.connections ++ [pid]
    data = data |> Map.put(:connections, connections)
    {:next_state, state, data}
  end

  def handle_event({:call, from}, :get_count, _state, data) do
    {:keep_state_and_data, [{:reply, from, data}]}
  end
end
