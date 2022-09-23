defmodule GameTest do
  require Logger
  alias Risk.Game.Context, as: GameContext
  use ExUnit.Case

  defp create_machine(_) do
    {:ok, pile_pid} = GenServer.start_link(Risk.CardPile, nil)
    {:ok, judge_pid} = Risk.Judge.start_link()

    {:ok, pid} =
      GenStateMachine.start_link(
        Risk.Game,
        {:player_announcements, %GameContext{card_pile: pile_pid, judge: judge_pid}}
      )

    %{pid: pid}
  end

  describe "Risk Game machine" do
    setup [:create_machine]

    test "connections", %{pid: pid} do
      status = GenStateMachine.cast(pid, {:connection, %Risk.Player{name: "David", guid: 111}})
      assert status == :ok
      status = GenStateMachine.cast(pid, {:connection, %Risk.Player{name: "Bertil", guid: 112}})
      assert status == :ok
      status = GenStateMachine.cast(pid, {:connection, %Risk.Player{name: "Ceasar", guid: 113}})
      assert status == :ok
      ctx = GenStateMachine.call(pid, :get_status)
      assert Enum.count(ctx.players) == 3

      status = GenStateMachine.cast(pid, {:ready, 111})
      assert status == :ok
      status = GenStateMachine.cast(pid, {:ready, 112})
      assert status == :ok
      status = GenStateMachine.cast(pid, {:ready, 113})
      assert status == :ok

      status = GenStateMachine.cast(pid, {:color_select, :red, 111})
      assert status == :ok
      status = GenStateMachine.cast(pid, {:color_select, :blue, 112})
      assert status == :ok
      status = GenStateMachine.cast(pid, {:color_select, :green, 113})
      assert status == :ok

      ctx = GenStateMachine.call(pid, :get_status)
      assert ctx.players[111].mission_card != nil
      assert ctx.players[112].mission_card != nil
      assert ctx.players[113].mission_card != nil

      assert ctx.players[111].reinforcements == 35
      assert ctx.players[112].reinforcements == 35
      assert ctx.players[113].reinforcements == 35

      card = Enum.at(ctx.players[111].risk_cards, 0)
      enemy_card = Enum.at(ctx.players[112].risk_cards, 0)
      :ok = GenStateMachine.cast(pid, {:deploy, 10, card.territory, 111})
      :ok = GenStateMachine.cast(pid, {:deploy, 10, enemy_card.territory, 111})

      ctx = GenStateMachine.call(pid, :get_status)

      forces = Enum.find(ctx.game_board.territories, fn x -> x.name == card.territory end).forces
      assert forces == 10
      assert ctx.players[111].reinforcements == 25

      forces =
        Enum.find(ctx.game_board.territories, fn x -> x.name == enemy_card.territory end).forces

      assert forces == 0

      {:deployment, _data} = GenStateMachine.call(pid, {:done, 111})
      {:deployment, _data} = GenStateMachine.call(pid, {:done, 112})

      card = Enum.at(ctx.players[113].risk_cards, 0)
      :ok = GenStateMachine.cast(pid, {:deploy, 35, card.territory, 113})

      {:deployment, _data} = GenStateMachine.call(pid, {:done, 113})
      ctx = GenStateMachine.call(pid, :get_status)
      status = Risk.Game.player_status(ctx.players)
      assert Enum.count(status) == 2

      # Deploy done
      card = Enum.at(ctx.players[111].risk_cards, 0)
      :ok = GenStateMachine.cast(pid, {:deploy, 25, card.territory, 111})
      card = Enum.at(ctx.players[112].risk_cards, 0)
      :ok = GenStateMachine.cast(pid, {:deploy, 35, card.territory, 112})
      {:deployment, _data} = GenStateMachine.call(pid, {:done, 111})
      {:game, next_player} = GenStateMachine.call(pid, {:done, 112})

      assert next_player != nil
    end
  end
end
