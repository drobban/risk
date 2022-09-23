defmodule Risk.Game do
  require Logger
  use GenStateMachine, callback_mode: [:handle_event_function, :state_enter]
  alias Risk.Game.Context, as: GameContext
  alias Risk.Player, as: Player
  alias Risk.Game.Logic, as: Logic

  def start_link(name) do
    {:ok, card_pile} = GenServer.start_link(Risk.CardPile, nil)
    {:ok, judge} = Risk.Judge.start_link()

    GenStateMachine.start_link(
      Risk.Game,
      {:player_announcements, %GameContext{card_pile: card_pile, judge: judge}},
      name: String.to_atom(name)
    )
  end

  def handle_event(:enter, _event, :preperation = state, data) do
    new_data =
      data
      |> put_in([Access.key(:players)], Logic.reset_player_status(data.players))
      |> Logic.assign_risk_cards()

    Logger.debug("State: #{inspect(state)}")
    {:next_state, state, new_data}
  end

  def handle_event(:enter, _event, :deployment = state, data) do
    # Assign mission cards
    new_data =
      data
      |> put_in([Access.key(:players)], Logic.reset_player_status(data.players))
      |> Logic.assign_mission_cards()
      |> Logic.fillup()

    Logger.debug("State: #{inspect(state)}")
    {:next_state, state, new_data}
  end

  def handle_event(:enter, _event, :game = state, data) do
    new_data =
      data
      |> put_in([Access.key(:players)], Logic.reset_player_status(data.players))

    # Assign initial set of cards
    Logger.debug("State: #{inspect(state)}")
    {:next_state, state, new_data}
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
    GenServer.cast(data.judge, {:add_player, player})
    new_data = data |> Map.put(:players, players)

    {:next_state, state, new_data}
  end

  def handle_event(:cast, {:ready, guid} = _event, :player_announcements = state, data) do
    data = data |> put_in([Access.key(:players), guid, Access.key(:status)], :done)

    status = player_status(data.players)

    case MapSet.to_list(status) do
      [:done] ->
        :re_step1 = GenStateMachine.call(data.judge, :done)
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

  def handle_event(:cast, {:deploy, amount, territory, guid}, :deployment = state, data) do
    data = Logic.set_if_legal(data, amount, territory, guid)
    {:next_state, state, data}
  end

  def handle_event({:call, from}, {:done, guid}, :deployment = state, data) do
    # Need to check that all territories have at least one troop.
    data =
      if data.players[guid].reinforcements == 0 do
        data |> put_in([Access.key(:players), guid, Access.key(:status)], :deploy_done)
      else
        data
      end

    status = player_status(data.players)

    case MapSet.to_list(status) do
      [:deploy_done] ->
        # Start it up. lets play and inform who is first up
        next_player = GenStateMachine.call(data.judge, :next_player)
        {:next_state, :game, data, [{:reply, from, {:game, next_player}}]}

      _ ->
        {:next_state, state, data, [{:reply, from, {state, nil}}]}
    end
  end

  def handle_event({:call, from}, {:done, guid}, :game = state, ctx) do
    judge_ctx = GenStateMachine.call(ctx.judge, :get_status)
    case judge_ctx.current_player.guid do
      ^guid ->
        # perform task
        next_phase = GenStateMachine.call(ctx.judge, :done)
        {:next_state, state, ctx, [{:reply, from, {state, next_phase}}]}
      _ ->
        {:next_state, state, ctx, [{:reply, from, {state, :wrong_user}}]}

    end
  end

  def handle_event(:cast, event, state, data) do
    Logger.debug("Event: #{inspect(event)} not accepted in State: #{inspect(state)}")
    {:next_state, state, data}
  end

  def handle_event({:call, from}, :get_status, _state, data) do
    {:keep_state_and_data, [{:reply, from, data}]}
  end

  def player_status(players) do
    Enum.reduce(players, MapSet.new(), fn {_k, v}, acc ->
      acc |> MapSet.put(v.status)
    end)
  end
end
