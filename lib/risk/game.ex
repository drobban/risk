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
    # Logger.debug("#{inspect(data, pretty: true, limit: :infinity)}")
    Logger.debug(state)
    {:next_state, state, data}
  end

  def handle_event(:cast, {:connection, pid} = _event, :player_announcements = state, data) do
    connections = data.connections |> Map.put(pid, :waiting)
    data = data |> Map.put(:connections, connections)
    {:next_state, state, data}
  end

  def handle_event(:cast, {:ready, pid} = _event, :player_announcements = state, data) do
    connections = data.connections |> Map.put(pid, :done)
    data = data |> Map.put(:connections, connections)

    status = Enum.reduce(connections, MapSet.new(), fn {_k, v}, acc -> acc |> MapSet.put(v) end)

    case MapSet.to_list(status) do
      [:done] ->
        {:next_state, :preperation, data}
      _ ->
        {:next_state, state, data}
    end
  end

  def handle_event(:cast, event, state, data) do
    Logger.debug("Event: #{inspect event} not accepted in State: #{inspect state}")
    {:next_state, state, data}
  end

  def handle_event({:call, from}, :get_status, _state, data) do
    {:keep_state_and_data, [{:reply, from, data}]}
  end
end
