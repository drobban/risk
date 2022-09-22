defmodule Risk.CardPile.Initial do
  alias Risk.RiskCard, as: RiskCard
  @moduledoc """
  The Initial module defines a initial struct to be used by the CardPile gen_server

  The setup is according to the Risk game rule.
  """

  defstruct active: [
              %RiskCard{territory: "Eastern Australia", value: 10},
              %RiskCard{territory: "Southern Europe", value: 10},
              %RiskCard{territory: "Japan", value: 10},
              %RiskCard{territory: "Indonesia", value: 10},
              %RiskCard{territory: "Eastern United States", value: 10},
              %RiskCard{territory: "Western United States", value: 10},
              %RiskCard{territory: "Northwest Territory", value: 10},
              %RiskCard{territory: "Central America", value: 10},
              %RiskCard{territory: "Brazil", value: 10},
              %RiskCard{territory: "Great Britain", value: 10},
              %RiskCard{territory: "Western Europe", value: 10},
              %RiskCard{territory: "Northern Europe", value: 10},
              %RiskCard{territory: "Western Australia", value: 10},
              %RiskCard{territory: "South Africa", value: 10},
              %RiskCard{territory: "Congo", value: 1},
              %RiskCard{territory: "Egypt", value: 1},
              %RiskCard{territory: "New Guinea", value: 1},
              %RiskCard{territory: "China", value: 1},
              %RiskCard{territory: "Alaska", value: 1},
              %RiskCard{territory: "Siam", value: 1},
              %RiskCard{territory: "Mongolia", value: 1},
              %RiskCard{territory: "Argentina", value: 1},
              %RiskCard{territory: "Kamchatka", value: 1},
              %RiskCard{territory: "Peru", value: 1},
              %RiskCard{territory: "Iceland", value: 1},
              %RiskCard{territory: "Venezuela", value: 1},
              %RiskCard{territory: "East Africa", value: 1},
              %RiskCard{territory: "Middle East", value: 1},
              %RiskCard{territory: "Ural", value: 5},
              %RiskCard{territory: "Yakutsk", value: 5},
              %RiskCard{territory: "Greenland", value: 5},
              %RiskCard{territory: "Madagascar", value: 5},
              %RiskCard{territory: "Alberta", value: 5},
              %RiskCard{territory: "Irkutsk", value: 5},
              %RiskCard{territory: "Scandinavia", value: 5},
              %RiskCard{territory: "Ukraine", value: 5},
              %RiskCard{territory: "Siberia", value: 5},
              %RiskCard{territory: "North Africa", value: 5},
              %RiskCard{territory: "Ontario", value: 5},
              %RiskCard{territory: "Quebec", value: 5},
              %RiskCard{territory: "India", value: 5},
              %RiskCard{territory: "Afghanistan", value: 5}
            ],
            discard: [
              %RiskCard{territory: "Joker", value: 0},
              %RiskCard{territory: "Joker", value: 0}
            ]
end
