defmodule Risk.Judge do
  require Logger
  use GenStateMachine, callback_mode: [:handle_event_function, :state_enter]
  alias Risk.Judge.Context, as: Context
  alias Risk.Player, as: Player

  def start_link() do
    GenStateMachine.start_link(Risk.Judge, {:init, %Context{}})
  end

  def handle_event(:enter, _event, _state, _ctx) do
    # Logger.debug("Entered: #{state}")
    {:keep_state_and_data, []}
  end

  def handle_event(:cast, {:add_player, %Player{} = player}, :init = state, ctx) do
    new_ctx = ctx |> update_in([Access.key(:play_order)], &Enum.shuffle(&1 ++ [player]))
    {:next_state, state, new_ctx}
  end

  def handle_event({:call, from}, :done, :init = state, ctx) do
    handle_event({:call, from}, :next_phase, state, ctx)
  end

  def handle_event({:call, from}, :done, :re_step1 = state, ctx) do
    # Add some checking, perhaps more then one player is a requirement?
    # {:next_state, :re_step1, ctx, [{:reply, from, :re_step1}]}
    handle_event({:call, from}, :next_phase, state, ctx)
  end

  def handle_event({:call, from}, :done, :re_step2 = state, ctx) do
    # Add some checking, perhaps more then one player is a requirement?
    # {:next_state, :re_step1, ctx, [{:reply, from, :re_step1}]}
    handle_event({:call, from}, :next_phase, state, ctx)
  end

  def handle_event({:call, from}, :done, :check_victor, ctx) do
    {:next_state, :new_round, ctx, [{:reply, from, :new_round}]}
  end

  def handle_event({:call, from}, :get_play_order, _state, ctx) do
    {:keep_state_and_data, [{:reply, from, ctx.play_order}]}
  end

  def handle_event({:call, from}, :get_status, _state, ctx) do
    {:keep_state_and_data, [{:reply, from, ctx}]}
  end

  def handle_event({:call, from}, :next_player, state, ctx) do
    [next | players] = ctx.play_order

    players = if !is_nil(ctx.current_player), do: players ++ [ctx.current_player], else: players

    ctx =
      ctx
      |> Map.put(:play_order, players)
      |> Map.put(:current_player, next)

    {:next_state, state, ctx, [{:reply, from, next}]}
  end

  def handle_event({:call, from}, :next_phase, _state, ctx) do
    [next | phases] = ctx.phases
    phases = if !is_nil(ctx.current_phase), do: phases ++ [ctx.current_phase], else: phases

    ctx =
      ctx
      |> Map.put(:phases, phases)
      |> Map.put(:current_phase, next)

    {:next_state, next, ctx, [{:reply, from, next}]}
  end
end
