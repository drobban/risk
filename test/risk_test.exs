defmodule RiskTest do
  use ExUnit.Case
  doctest Risk

  test "Game Context card count" do
    n_mission_cards = Enum.count(%Risk.GameContext{card_pile: "fake", judge: "fake"}.mission_cards)
    assert n_mission_cards == 12
  end
end
