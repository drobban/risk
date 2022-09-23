defmodule RiskTest do
  use ExUnit.Case
  doctest Risk
  alias Risk.Game.Context, as: GameContext

  test "Game Context card count" do
    n_mission_cards = Enum.count(%GameContext{card_pile: "fake", judge: "fake"}.mission_cards)
    assert n_mission_cards == 12
  end
end
