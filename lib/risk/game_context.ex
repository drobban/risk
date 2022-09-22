defmodule Risk.GameContext do
  alias Risk.GameBoard, as: GameBoard
  alias Risk.MissionCard, as: MissionCard
  alias Risk.Continent, as: Continent

  @enforce_keys [:card_pile, :judge]
  defstruct [
    :card_pile,
    :judge,
    players: %{},
    game_board: %GameBoard{},
    mission_cards: [
      %MissionCard{
        mission_rule: &(&1 + &2),
        mission_description: "Conquer the continents of Asia and Africa",
        color_code: nil
      },
      %MissionCard{
        mission_rule: &(&1 + &2),
        mission_description:
          "Destroy all black troops, if you are the black troop then occupy 24 territories of your choice",
        color_code: :black
      },
      %MissionCard{
        mission_rule: &(&1 + &2),
        mission_description:
          "Destroy all gray troops, if you are the gray troop then occupy 24 territories of your choice",
        color_code: :gray
      },
      %MissionCard{
        mission_rule: &(&1 + &2),
        mission_description: "Conquer the continents of North America and Australia",
        color_code: nil
      },
      %MissionCard{
        mission_rule: &(&1 + &2),
        mission_description:
          "Destroy all blue troops, if you are the blue troop then occupy 24 territories of your choice",
        color_code: :blue
      },
      %MissionCard{
        mission_rule: &(&1 + &2),
        mission_description: "Conquer the continents of North America and Africa",
        color_code: nil
      },
      %MissionCard{
        mission_rule: &(&1 + &2),
        mission_description: "Conquer the continents of Asia and South America",
        color_code: nil
      },
      %MissionCard{
        mission_rule: &(&1 + &2),
        mission_description:
          "Destroy all green troops, if you are the green troop then occupy 24 territories of your choice",
        color_code: :green
      },
      %MissionCard{
        mission_rule: &(&1 + &2),
        mission_description:
          "Destroy all yellow troops, if you are the yellow troop then occupy 24 territories of your choice",
        color_code: :yellow
      },
      %MissionCard{
        mission_rule: &(&1 + &2),
        mission_description:
          "Destroy all red troops, if you are the red troop then occupy 24 territories of your choice",
        color_code: :red
      },
      %MissionCard{
        mission_rule: &(&1 + &2),
        mission_description:
          "Conquer 18 territories of your choice then occupy each with at least 2 armies",
        color_code: nil
      },
      %MissionCard{
        mission_rule: &(&1 + &2),
        mission_description: "Conquer 24 territories of your choice",
        color_code: nil
      }
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
  ]
end
