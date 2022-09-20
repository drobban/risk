defmodule Risk.GameBoard do
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
              }
            ]
end
