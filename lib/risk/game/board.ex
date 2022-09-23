defmodule Risk.Game.Board do
  alias Risk.Territory, as: Territory

  defstruct territories: [
              # Australia
              %Territory{name: "Eastern Australia", borders: ["Western Australia", "New Guinea"]},
              %Territory{
                name: "Western Australia",
                borders: ["Eastern Australia", "New Guinea", "Indonesia"]
              },
              %Territory{
                name: "Indonesia",
                borders: ["Siam", "Western Australia", "New Guinea", "Indonesia"]
              },
              %Territory{
                name: "New Guinea",
                borders: ["Western Australia", "Eastern Australia", "Indonesia"]
              },
              # Asia
              %Territory{name: "Siam", borders: ["Siam", "Indonesia"]},
              %Territory{name: "India", borders: ["Siam", "China", "Middle East", "Afghanistan"]},
              %Territory{
                name: "China",
                borders: ["India", "Siam", "Ural", "Siberia", "Afghanistan", "Mongolia"]
              },
              %Territory{
                name: "Mongolia",
                borders: ["China", "Siberia", "Irkutsk", "Kamchatka", "Japan"]
              },
              %Territory{name: "Japan", borders: ["Mongolia", "Kamchatka"]},
              %Territory{
                name: "Kamchatka",
                borders: ["Mongolia", "Japan", "Irkutsk", "Yakutsk", "Alaska"]
              },
              %Territory{
                name: "Irkutsk",
                borders: ["Siberia", "Yakutsk", "Kamchatka", "Mongolia"]
              },
              %Territory{name: "Yakutsk", borders: ["Siberia", "Irkutsk", "Kamchatka"]},
              %Territory{
                name: "Siberia",
                borders: ["Yakutsk", "Irkutsk", "Mongolia", "China", "Ural"]
              },
              %Territory{name: "Ural", borders: ["Siberia", "China", "Afghanistan", "Ukraine"]},
              %Territory{
                name: "Afghanistan",
                borders: ["Ural", "China", "India", "Middle East", "Ukraine"]
              },
              %Territory{
                name: "Middle East",
                borders: [
                  "East Africa",
                  "Egypt",
                  "Southern Europe",
                  "Ukraine",
                  "Afghanistan",
                  "India"
                ]
              },
              # Europe
              %Territory{
                name: "Ukraine",
                borders: [
                  "Ural",
                  "Afghanistan",
                  "Middle East",
                  "Southern Europe",
                  "Northern Europe",
                  "Scandinavia"
                ]
              },
              %Territory{
                name: "Southern Europe",
                borders: [
                  "Egypt",
                  "North Africa",
                  "Western Europe",
                  "Northern Europe",
                  "Ukraine",
                  "Middle East"
                ]
              },
              %Territory{
                name: "Northern Europe",
                borders: [
                  "Southern Europe",
                  "Western Europe",
                  "Great Britain",
                  "Scandinavia",
                  "Ukraine"
                ]
              },
              %Territory{
                name: "Scandinavia",
                borders: ["Northern Europe", "Great Britain", "Iceland", "Ukraine"]
              },
              %Territory{
                name: "Western Europe",
                borders: ["North Africa", "Great Britain", "Northern Europe", "Southern Europe"]
              },
              %Territory{
                name: "Great Britain",
                borders: ["Western Europe", "Iceland", "Scandinavia", "Northern Europe"]
              },
              %Territory{
                name: "Iceland",
                borders: ["Great Britain", "Greenland", "Scandinavia"]
              },
              # Africa
              %Territory{
                name: "South Africa",
                borders: ["Congo", "East Africa", "Madagascar"]
              },
              %Territory{
                name: "Congo",
                borders: ["South Africa", "North Africa", "East Africa"]
              },
              %Territory{
                name: "East Africa",
                borders: [
                  "South Africa",
                  "Congo",
                  "North Africa",
                  "Egypt",
                  "Middle East",
                  "Madagascar"
                ]
              },
              %Territory{
                name: "Madagascar",
                borders: ["South Africa", "East Africa"]
              },
              %Territory{
                name: "North Africa",
                borders: [
                  "Brazil",
                  "Western Europe",
                  "Southern Europe",
                  "Egypt",
                  "East Africa",
                  "Congo"
                ]
              },
              %Territory{
                name: "Egypt",
                borders: ["North Africa", "Southern Europe", "Middle East", "East Africa"]
              },
              # South America
              %Territory{
                name: "Argentina",
                borders: ["Peru", "Brazil"]
              },
              %Territory{
                name: "Peru",
                borders: ["Argentina", "Venezuela", "Brazil"]
              },
              %Territory{
                name: "Brazil",
                borders: ["Argentina", "Peru", "Venezuela", "North Africa"]
              },
              %Territory{
                name: "Venezuela",
                borders: ["Peru", "Central America", "Brazil"]
              },
              # North America
              %Territory{
                name: "Central America",
                borders: ["Venezuela", "Western United States", "Eastern United States"]
              },
              %Territory{
                name: "Western United States",
                borders: ["Central America", "Alberta", "Ontario", "Eastern United States"]
              },
              %Territory{
                name: "Eastern United States",
                borders: ["Central America", "Western United States", "Ontario", "Quebec"]
              },
              %Territory{
                name: "Alberta",
                borders: ["Western United States", "Alaska", "Northwest Territory", "Ontario"]
              },
              %Territory{
                name: "Ontario",
                borders: [
                  "Western United States",
                  "Alberta",
                  "Northwest Territory",
                  "Greenland",
                  "Quebec",
                  "Eastern United States"
                ]
              },
              %Territory{
                name: "Quebec",
                borders: ["Eastern United States", "Ontario", "Greenland"]
              },
              %Territory{
                name: "Alaska",
                borders: ["Kamchatka", "Northwest Territory", "Alberta"]
              },
              %Territory{
                name: "Northwest Territory",
                borders: ["Alberta", "Alaska", "Greenland", "Ontario"]
              },
              %Territory{
                name: "Greenland",
                borders: ["Quebec", "Ontario", "Northwest Territory", "Iceland"]
              }
            ]
end
