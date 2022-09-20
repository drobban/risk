defmodule RiskTest do
  use ExUnit.Case
  doctest Risk

  test "Game Context card count" do
    n_mission_cards = Enum.count(%Risk.GameContext{}.mission_cards)
    n_risk_cards = Enum.count(%Risk.GameContext{}.risk_cards)
    assert n_mission_cards == 12
    assert n_risk_cards == 42
  end

  test "Initial setup consistency" do
    card_territories = summarize_territories_cards(%Risk.GameContext{}.risk_cards)
    territories = summarize_territories_continents(%Risk.GameContext{}.continents)

    data = Enum.reject(card_territories, fn territory -> Enum.member?(territories, territory) end)

    assert data == []
  end

  defp summarize_territories_cards(cards) do
    Enum.reduce(cards, [], fn card, acc -> acc ++ [card.territory] end)
  end

  defp summarize_territories_continents(continents) do
    Enum.reduce(continents, [], fn continent, acc -> acc ++ continent.territories end)
  end
end
