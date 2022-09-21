defmodule Risk.Player do
  @enforce_keys [:name, :guid]
  defstruct [
    :name,
    :guid,
    color: nil,
    risk_cards: [],
    mission_card: nil,
    status: :waiting,
    reinforcements: 0
  ]
end
