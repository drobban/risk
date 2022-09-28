defmodule GameTest do
  require Logger
  alias Risk.Game.Context, as: GameContext
  alias Risk.Game.State, as: GameState
  alias Risk.Game.Event, as: GameEvent
  use ExUnit.Case

  defp create_machine(_) do
    {:ok, pile_pid} = GenServer.start_link(Risk.CardPile, nil)
    {:ok, judge_pid} = Risk.Judge.start_link()

    {:ok, pid} =
      GenStateMachine.start_link(
        Risk.Game,
        {GameState.PlayerAnnouncement, %GameContext{card_pile: pile_pid, judge: judge_pid}}
      )

    %{pid: pid}
  end

  describe "Risk Game machine" do
    setup [:create_machine]

    test "connections", %{pid: pid} do
      {GameState.PlayerAnnouncement, _} =
        GenStateMachine.call(pid, {GameEvent.Connection, %Risk.Player{name: "David", guid: 111}})

      {GameState.PlayerAnnouncement, _} =
        GenStateMachine.call(pid, {GameEvent.Connection, %Risk.Player{name: "Bertil", guid: 112}})

      {GameState.PlayerAnnouncement, _} =
        GenStateMachine.call(pid, {GameEvent.Connection, %Risk.Player{name: "Ceasar", guid: 113}})

      ctx = GenStateMachine.call(pid, GameEvent.GetStatus)
      assert Enum.count(ctx.players) == 3

      status = GenStateMachine.call(pid, {GameEvent.Ready, 111})
      status = GenStateMachine.call(pid, {GameEvent.Ready, 112})
      status = GenStateMachine.call(pid, {GameEvent.Ready, 113})

      {GameState.Preperation, _} = GenStateMachine.call(pid, {GameEvent.ColorSelect, :red, 111})
      {GameState.Preperation, _} = GenStateMachine.call(pid, {GameEvent.ColorSelect, :blue, 112})
      {GameState.Preperation, _} = GenStateMachine.call(pid, {GameEvent.ColorSelect, :green, 113})

      ctx = GenStateMachine.call(pid, GameEvent.GetStatus)
      assert ctx.players[111].mission_card != nil
      assert ctx.players[112].mission_card != nil
      assert ctx.players[113].mission_card != nil

      assert ctx.players[111].reinforcements == 35
      assert ctx.players[112].reinforcements == 35
      assert ctx.players[113].reinforcements == 35

      card = Enum.at(ctx.players[111].risk_cards, 0)
      enemy_card = Enum.at(ctx.players[112].risk_cards, 0)

      {Risk.Game.State.Deployment, _} =
        GenStateMachine.call(pid, {GameEvent.Deploy, 10, card.territory, 111})

      {Risk.Game.State.Deployment, _} =
        GenStateMachine.call(pid, {GameEvent.Deploy, 10, enemy_card.territory, 111})

      ctx = GenStateMachine.call(pid, GameEvent.GetStatus)

      forces = Enum.find(ctx.game_board.territories, fn x -> x.name == card.territory end).forces
      assert forces == 10
      assert ctx.players[111].reinforcements == 25

      forces =
        Enum.find(ctx.game_board.territories, fn x -> x.name == enemy_card.territory end).forces

      assert forces == 0

      {GameState.Deployment, _data} = GenStateMachine.call(pid, {GameEvent.Done, 111})
      {GameState.Deployment, _data} = GenStateMachine.call(pid, {GameEvent.Done, 112})

      card = Enum.at(ctx.players[113].risk_cards, 0)

      {Risk.Game.State.Deployment, _} =
        GenStateMachine.call(pid, {GameEvent.Deploy, 35, card.territory, 113})

      {GameState.Deployment, _data} = GenStateMachine.call(pid, {GameEvent.Done, 113})
      ctx = GenStateMachine.call(pid, GameEvent.GetStatus)
      status = Risk.Game.player_status(ctx.players)
      assert Enum.count(status) == 2

      # Deploy done
      card = Enum.at(ctx.players[111].risk_cards, 0)

      {Risk.Game.State.Deployment, _} =
        GenStateMachine.call(pid, {GameEvent.Deploy, 25, card.territory, 111})

      card = Enum.at(ctx.players[112].risk_cards, 0)

      {Risk.Game.State.Deployment, _} =
        GenStateMachine.call(pid, {GameEvent.Deploy, 35, card.territory, 112})

      {GameState.Deployment, _data} = GenStateMachine.call(pid, {GameEvent.Done, 111})
      {GameState.Game, next_player} = GenStateMachine.call(pid, {GameEvent.Done, 112})

      assert next_player != nil
      {state, status} = GenStateMachine.call(pid, {GameEvent.Done, next_player.guid})
      assert status == :re_step2
      {state, status} = GenStateMachine.call(pid, {GameEvent.Done, 666})
      assert status == :wrong_user
    end
  end
end
