defmodule Risk.GameContext do
  alias Risk.GameBoard, as: GameBoard
  alias Risk.MissionCard, as: MissionCard
  alias Risk.RiskCard, as: RiskCard
  alias Risk.Continent, as: Continent

  defstruct players: %{},
            game_board: %GameBoard{},
            mission_cards: [
              %MissionCard{
                mission_rule: &(&1 + &2),
                mission_description: "Conquer the continents of Asia and Africa"
              },
              %MissionCard{
                mission_rule: &(&1 + &2),
                mission_description:
                  "Destroy all black troops, if you are the black troop then occupy 24 territories of your choice"
              },
              %MissionCard{
                mission_rule: &(&1 + &2),
                mission_description:
                  "Destroy all gray troops, if you are the gray troop then occupy 24 territories of your choice"
              },
              %MissionCard{
                mission_rule: &(&1 + &2),
                mission_description: "Conquer the continents of North America and Australia"
              },
              %MissionCard{
                mission_rule: &(&1 + &2),
                mission_description:
                  "Destroy all blue troops, if you are the blue troop then occupy 24 territories of your choice"
              },
              %MissionCard{
                mission_rule: &(&1 + &2),
                mission_description: "Conquer the continents of North America and Africa"
              },
              %MissionCard{
                mission_rule: &(&1 + &2),
                mission_description: "Conquer the continents of Asia and South America"
              },
              %MissionCard{
                mission_rule: &(&1 + &2),
                mission_description:
                  "Destroy all green troops, if you are the green troop then occupy 24 territories of your choice"
              },
              %MissionCard{
                mission_rule: &(&1 + &2),
                mission_description:
                  "Destroy all yellow troops, if you are the yellow troop then occupy 24 territories of your choice"
              },
              %MissionCard{
                mission_rule: &(&1 + &2),
                mission_description:
                  "Destroy all red troops, if you are the red troop then occupy 24 territories of your choice"
              },
              %MissionCard{
                mission_rule: &(&1 + &2),
                mission_description:
                  "Conquer 18 territories of your choice then occupy each with at least 2 armies"
              },
              %MissionCard{
                mission_rule: &(&1 + &2),
                mission_description: "Conquer 24 territories of your choice"
              }
            ],
            risk_cards: [
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
            continents: [
              %Continent{
                name: "Australia",
                bonus: 2,
                territories: ["Eastern Australia", "Indonesia", "New Guinea", "Western Australia"]
              },
              %Continent{
                name: "Africa",
                bonus: 3,
                territories: [
                  "Congo",
                  "East Africa",
                  "Egypt",
                  "Madagascar",
                  "North Africa",
                  "South Africa"
                ]
              },
              %Continent{
                name: "Europe",
                bonus: 5,
                territories: [
                  "Great Britain",
                  "Iceland",
                  "Northern Europe",
                  "Scandinavia",
                  "Southern Europe",
                  "Ukraine",
                  "Western Europe"
                ]
              },
              %Continent{
                name: "South America",
                bonus: 2,
                territories: ["Argentina", "Brazil", "Peru", "Venezuela"]
              },
              %Continent{
                name: "North America",
                bonus: 5,
                territories: [
                  "Alaska",
                  "Alberta",
                  "Central America",
                  "Eastern United States",
                  "Greenland",
                  "Northwest Territory",
                  "Ontario",
                  "Quebec",
                  "Western United States"
                ]
              },
              %Continent{
                name: "Asia",
                bonus: 7,
                territories: [
                  "Afghanistan",
                  "China",
                  "India",
                  "Irkutsk",
                  "Japan",
                  "Kamchatka",
                  "Middle East",
                  "Mongolia",
                  "Siam",
                  "Siberia",
                  "Ural",
                  "Yakutsk"
                ]
              }
            ]
end
