defmodule Risk.Game do
  require Logger
  use GenStateMachine, callback_mode: [:handle_event_function, :state_enter]
  alias Risk.GameContext, as: GameContext
  alias Risk.Player, as: Player
  alias Risk.Game.Logic, as: Logic

  def start_link(name) do
    GenStateMachine.start_link(Risk.Game, {:player_announcements, %GameContext{}},
      name: String.to_atom(name)
    )
  end

  def handle_event(:enter, _event, :preperation = state, data) do
    new_data = data |> put_in([Access.key(:players)], Logic.reset_player_status(data.players))
    new_data = Logic.assign_risk_cards(new_data)

    {:next_state, state, new_data}
  end

  def handle_event(:enter, _event, :deployment = state, data) do
    # Assign mission cards
    Logger.debug("State: #{inspect(state)}")
    {:next_state, state, data}
  end

  def handle_event(:enter, _event, state, data) do
    Logger.debug("State: #{inspect(state)}")
    {:next_state, state, data}
  end

  def handle_event(
        :cast,
        {:connection, %Player{} = player} = _event,
        :player_announcements = state,
        data
      ) do
    players = data.players |> Map.put(player.guid, player)
    new_data = data |> Map.put(:players, players)
    {:next_state, state, new_data}
  end

  def handle_event(:cast, {:ready, guid} = _event, :player_announcements = state, data) do
    data = data |> put_in([Access.key(:players), guid, Access.key(:status)], :done)

    status = player_status(data.players)

    case MapSet.to_list(status) do
      [:done] ->
        {:next_state, :preperation, data}

      _ ->
        {:next_state, state, data}
    end
  end

  def handle_event(:cast, {:color_select, color, guid}, :preperation = state, data) do
    data = data |> put_in([Access.key(:players), guid, Access.key(:color)], color)
    data = data |> put_in([Access.key(:players), guid, Access.key(:status)], :color_done)

    status = player_status(data.players)

    case MapSet.to_list(status) do
      [:color_done] ->
        {:next_state, :deployment, data}

      _ ->
        {:next_state, state, data}
    end
  end

  def handle_event(:cast, event, state, data) do
    Logger.debug("Event: #{inspect(event)} not accepted in State: #{inspect(state)}")
    {:next_state, state, data}
  end

  def handle_event({:call, from}, :get_status, _state, data) do
    {:keep_state_and_data, [{:reply, from, data}]}
  end

  defp player_status(players) do
    Enum.reduce(players, MapSet.new(), fn {_k, v}, acc ->
      acc |> MapSet.put(v.status)
    end)
  end
end
