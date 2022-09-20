defmodule Risk.GameBoard do
  alias Risk.Territory, as: Territory

  defstruct territories: [
              # Scandinavia
              %Territory{name: "Sweden", borders: ["Norway", "Finland", "Denmark"]},
              %Territory{name: "Norway", borders: ["Sweden", "Finland"]},
              %Territory{name: "Denmark", borders: ["Sweden"]},
              %Territory{name: "Finland", borders: ["Sweden", "Norway"]}
            ]
end
