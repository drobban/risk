defmodule Risk.Player do
  @enforce_keys [:name, :guid]
  defstruct [:name, :guid, risk_cards: [], mission_card: nil, status: :waiting]
end
