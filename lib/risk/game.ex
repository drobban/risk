defmodule Risk.Game do
  require Logger
  use GenStateMachine, callback_mode: [:handle_event_function, :state_enter]
  alias Risk.Game.Context, as: GameContext
  alias Risk.Player, as: Player
  alias Risk.Game.Logic, as: Logic
  alias Risk.Game.Event, as: GameEvent
  alias Risk.Game.State, as: GameState
  alias Risk.Judge.Event, as: JudgeEvent
  alias Risk.Judge.State, as: JudgeState

  @max_players 6
  @min_players 2

  @moduledoc """
  Event: Game.Event.Connection - Game.State.PlayerAnnouncement
  Accepts %Player{} and appends to list of connected players.
  Maximum of 6 players.

  Event: Game.Event.Ready - Game.State.PlayerAnnouncement
  When a minimum of 2 players and all are ready. Game steps to next state
  """

  def start_link(name) do
    {:ok, card_pile} = GenServer.start_link(Risk.CardPile, nil)
    {:ok, judge} = Risk.Judge.start_link()

    GenStateMachine.start_link(
      Risk.Game,
      {GameState.PlayerAnnouncement, %GameContext{card_pile: card_pile, judge: judge}},
      name: String.to_atom(name)
    )
  end

  def handle_event(
        {:call, from},
        {GameEvent.Connection, %Player{} = player} = _event,
        GameState.PlayerAnnouncement = state,
        ctx
      ) do
    # Accept maximum players else reject.
    case Enum.count(ctx.players) < @max_players do
      true ->
        players = ctx.players |> Map.put(player.guid, player)
        GenServer.cast(ctx.judge, {JudgeEvent.AddPlayer, player})
        new_ctx = ctx |> Map.put(:players, players)
        {:next_state, state, new_ctx, [{:reply, from, {state, :ok}}]}

      false ->
        {:next_state, state, ctx, [{:reply, from, {state, :error, ["Game full"]}}]}
    end
  end

  def handle_event(
        {:call, from},
        {GameEvent.Ready, guid} = _event,
        GameState.PlayerAnnouncement = state,
        ctx
      ) do
    ctx = ctx |> put_in([Access.key(:players), guid, Access.key(:status)], :done)

    status = player_status(ctx.players)

    # All ready and at least two players, step to next state.
    case {MapSet.to_list(status), Enum.count(ctx.players) < @min_players} do
      {[:done], false} ->
        JudgeState.ReStep1 = GenStateMachine.call(ctx.judge, JudgeEvent.Done)
        {:next_state, GameState.Preperation, ctx, [{:reply, from, {state, :ok}}]}

      _ ->
        {:next_state, state, ctx, [{:reply, from, {state, :ok}}]}
    end
  end

  def handle_event(
        {:call, from},
        {GameEvent.ColorSelect, color, guid},
        GameState.Preperation = state,
        ctx
      ) do
    ctx = ctx |> put_in([Access.key(:players), guid, Access.key(:color)], color)
    ctx = ctx |> put_in([Access.key(:players), guid, Access.key(:status)], :color_done)

    status = player_status(ctx.players)

    case MapSet.to_list(status) do
      [:color_done] ->
        {:next_state, GameState.Deployment, ctx, [{:reply, from, {state, :ok}}]}

      _ ->
        {:next_state, state, ctx, [{:reply, from, {state, :ok}}]}
    end
  end

  def handle_event(
        {:call, from},
        {GameEvent.Deploy, amount, territory, guid},
        GameState.Deployment = state,
        ctx
      ) do
    case Logic.set_if_legal(ctx, amount, territory, guid) do
      {:ok, ctx} ->
        {:next_state, state, ctx, [{:reply, from, {state, :ok}}]}

      {:error, ctx} ->
        {:next_state, state, ctx,
         [{:reply, from, {state, :error, ["Probably illegal territory"]}}]}
    end
  end

  def handle_event({:call, from}, {GameEvent.Done, guid}, GameState.Deployment = state, ctx) do
    # Need to check that all territories have at least one troop.
    troops = ctx.players[guid].reinforcements == 0
    legal_defence = Logic.player_defence_legal(ctx, guid)

    ctx =
      case {troops, legal_defence} do
        {true, true} ->
          ctx |> put_in([Access.key(:players), guid, Access.key(:status)], :deploy_done)

        {_, _} ->
          ctx
      end

    case {troops, legal_defence, MapSet.to_list(player_status(ctx.players))} do
      {true, true, [:deploy_done]} ->
        # Start it up. lets play and inform who is first up
        next_player = GenStateMachine.call(ctx.judge, JudgeEvent.NextPlayer)
        {:next_state, GameState.Game, ctx, [{:reply, from, {GameState.Game, next_player}}]}

      {true, true, _} ->
        # Not all players are ready yet.
        {:next_state, state, ctx, [{:reply, from, {state, :ok}}]}

      {false, true, _} ->
        {:next_state, state, ctx, [{:reply, from, {state, :error, ["Troops left to deploy"]}}]}

      {true, false, _} ->
        {:next_state, state, ctx, [{:reply, from, {state, :error, ["You have undefended land"]}}]}

      {false, false, _} ->
        {:next_state, state, ctx,
         [{:reply, from, {state, :error, ["Deploy all troops with at least 1 in each"]}}]}
    end
  end

  def handle_event({:call, from}, {GameEvent.Done, guid}, GameState.Game = state, ctx) do
    judge_ctx = GenStateMachine.call(ctx.judge, JudgeEvent.GetStatus)

    case judge_ctx.current_player.guid do
      ^guid ->
        # perform task
        next_phase = GenStateMachine.call(ctx.judge, JudgeEvent.Done)
        {:next_state, state, ctx, [{:reply, from, {state, next_phase}}]}

      _ ->
        {:next_state, state, ctx, [{:reply, from, {state, :wrong_user}}]}
    end
  end

  def handle_event(:cast, event, state, data) do
    valid_event = Enum.member?(GameEvent.enums(), event)
    valid_state = Enum.member?(GameState.enums(), state)
    Logger.debug("State: #{inspect(state)}")

    case {valid_event, valid_state} do
      {false, false} ->
        Logger.error("Event: #{inspect(event)} & State: #{inspect(state)} invalid")

      {true, false} ->
        Logger.error("State: #{inspect(state)} invalid")

      {false, true} ->
        Logger.error("Event: #{inspect(event)} invalid")

      {true, true} ->
        Logger.debug("Event: #{inspect(event)} not accepted in State: #{inspect(state)}")
    end

    {:next_state, state, data}
  end

  def handle_event({:call, from}, GameEvent.GetStatus, _state, data) do
    {:keep_state_and_data, [{:reply, from, data}]}
  end

  def handle_event(:enter, _event, GameState.Game = state, data) do
    new_data =
      data
      |> put_in([Access.key(:players)], Logic.reset_player_status(data.players))

    # Assign initial set of cards
    Logger.debug("State: #{inspect(state)}")
    {:next_state, state, new_data}
  end

  # STATE ENTER callbacks

  def handle_event(:enter, _event, GameState.Preperation = state, data) do
    new_data =
      data
      |> put_in([Access.key(:players)], Logic.reset_player_status(data.players))
      |> Logic.assign_risk_cards()

    Logger.debug("State: #{inspect(state)}")
    {:next_state, state, new_data}
  end

  def handle_event(:enter, _event, GameState.Deployment = state, data) do
    # Assign mission cards
    new_data =
      data
      |> put_in([Access.key(:players)], Logic.reset_player_status(data.players))
      |> Logic.assign_mission_cards()
      |> Logic.fillup()

    Logger.debug("State: #{inspect(state)}")
    {:next_state, state, new_data}
  end

  def handle_event(:enter, _event, state, data) do
    Logger.debug("State: #{inspect(state)}")
    {:next_state, state, data}
  end

  def player_status(players) do
    Enum.reduce(players, MapSet.new(), fn {_k, v}, acc ->
      acc |> MapSet.put(v.status)
    end)
  end
end
