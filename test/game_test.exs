defmodule GameTest do
  require Logger
  use ExUnit.Case

  test "Game logic functions - Mission assignment" do
    ctx = %Risk.GameContext{
      players: %{
        111 => %Risk.Player{name: "david", guid: 111, color: :red},
        222 => %Risk.Player{name: "bertil", guid: 222, color: :blue},
        333 => %Risk.Player{name: "berit", guid: 333, color: :black},
        444 => %Risk.Player{name: "nils", guid: 444, color: :gray},
        555 => %Risk.Player{name: "sam", guid: 555, color: :yellow},
        109 => %Risk.Player{name: "gudrun", guid: 109, color: :green}
      }
    }

    ctx = Risk.Game.Logic.assign_mission_cards(ctx)
    for {_guid, player} <- ctx.players do
      assert player.mission_card != nil
    end
  end

  test "Game logic functions - Risk card assignment" do
    ctx = %Risk.GameContext{
      players: %{
        111 => %Risk.Player{name: "david", guid: 111, color: :red},
        222 => %Risk.Player{name: "bertil", guid: 222, color: :yellow},
        333 => %Risk.Player{name: "gudrun", guid: 333, color: :green}
      }
    }

    ctx = Risk.Game.Logic.assign_risk_cards(ctx)

    sum =
      Enum.reduce(ctx.players, 0, fn {_guid, player}, acc ->
        acc + Enum.count(player.risk_cards)
      end)

    assert sum == 42
  end
end
