defmodule Risk.Game.Logic do
  def reset_player_status(players) do
    Enum.reduce(players, %{}, fn {k, v}, acc ->
      player = v |> put_in([Access.key(:status)], :waiting)
      acc |> put_in([Access.key(k)], player)
    end)
  end

  def assign_mission_cards(ctx) do
    colors =
      Enum.reduce(ctx.players, [], fn {_k, player}, acc -> acc ++ [player.color] end) ++ [nil]

    missions =
      Enum.filter(ctx.mission_cards, fn mission -> Enum.member?(colors, mission.color_code) end)
      |> Enum.shuffle()

    players =
      Enum.zip_reduce(missions, ctx.players, ctx.players, fn mission, {guid, player}, acc ->
        player = player |> Map.put(:mission_card, mission)
        acc |> Map.put(guid, player)
      end)

    ctx |> Map.put(:players, players)
  end

  def assign_risk_cards(ctx) do
    card_list = Enum.shuffle(ctx.risk_cards)

    player_list =
      ctx.players |> Enum.reduce([], fn {_k, v}, acc -> [v | acc] end) |> Enum.shuffle()

    handed_players = serve_until_empty(player_list, card_list)

    Enum.reduce(handed_players, ctx, fn player, acc ->
      acc |> put_in([Access.key(:players), player.guid], player)
    end)
  end

  def serve_until_empty(players, []) do
    players
  end

  def serve_until_empty(players, cards) do
    [player | rest] = players
    {card, cards} = List.pop_at(cards, 0)
    player = player |> Map.put(:risk_cards, player.risk_cards ++ [card])

    serve_until_empty(rest ++ [player], cards)
  end
end
