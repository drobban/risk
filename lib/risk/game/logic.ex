defmodule Risk.Game.Logic do
  require Logger
  @army_size %{3 => 35, 4 => 30, 5 => 25, 6 => 20}

  def fillup(ctx) do
    n_players = Enum.count(ctx.players)

    Enum.reduce(ctx.players, ctx, fn {guid, player}, acc ->
      player = player |> Map.put(:reinforcements, @army_size[n_players])
      acc |> put_in([Access.key(:players), guid], player)
    end)
  end

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
    player_list = GenServer.call(ctx.judge, :get_play_order)

    handed_players = serve_until_joker(player_list, ctx.card_pile, nil)

    Enum.reduce(handed_players, ctx, fn player, acc ->
      acc |> put_in([Access.key(:players), player.guid], player)
    end)
  end

  def serve_until_joker(players, card_pile, %Risk.RiskCard{territory: "Joker"} = card) do
    :ok = GenServer.cast(card_pile, {:put, card})
    players
  end

  def serve_until_joker(players, card_pile, card) do
    card = if is_nil(card), do: GenServer.call(card_pile, :pick), else: card

    [player | rest] = players
    player = player |> Map.put(:risk_cards, player.risk_cards ++ [card])

    serve_until_joker(rest ++ [player], card_pile, GenServer.call(card_pile, :pick))
  end

  def set_if_legal(ctx, amount, territory_name, guid) do
    territory_names =
      Enum.reduce(ctx.players[guid].risk_cards, [], fn card, acc -> acc ++ [card.territory] end)

    territories = ctx.game_board.territories
    idx = Enum.find_index(territories, fn territory -> territory.name == territory_name end)
    members = Enum.member?(territory_names, territory_name)
    size_ok = amount <= ctx.players[guid].reinforcements

    if members and !is_nil(idx) and size_ok do
      territories =
        List.update_at(territories, idx, fn territory ->
          territory |> update_in([Access.key(:forces)], &(&1 + amount))
        end)

      ctx
      |> put_in([Access.key(:game_board), Access.key(:territories)], territories)
      |> update_in([Access.key(:players), guid, Access.key(:reinforcements)], &(&1 - amount))
    else
      ctx
    end
  end
end
