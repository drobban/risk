defmodule StateTest do
  require Logger
  alias Risk.GameContext, as: GameContext
  use ExUnit.Case


  defp create_machine(_) do
    {:ok, pid} = GenStateMachine.start_link(Risk.Game, {:player_announcements, %GameContext{}})

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
    end
  end

end
