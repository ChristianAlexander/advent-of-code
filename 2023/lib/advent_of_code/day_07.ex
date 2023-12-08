defmodule AdventOfCode.Day07 do
  def parse(line) do
    [cards, bid] = String.split(line, " ")

    cards =
      cards
      |> String.graphemes()

    {cards, bid}
  end

  defp card_to_number("2"), do: 2
  defp card_to_number("3"), do: 3
  defp card_to_number("4"), do: 4
  defp card_to_number("5"), do: 5
  defp card_to_number("6"), do: 6
  defp card_to_number("7"), do: 7
  defp card_to_number("8"), do: 8
  defp card_to_number("9"), do: 9
  defp card_to_number("T"), do: 10
  defp card_to_number("J"), do: 11
  defp card_to_number("Q"), do: 12
  defp card_to_number("K"), do: 13
  defp card_to_number("A"), do: 14

  defp card_to_number_part_two("J"), do: 1
  defp card_to_number_part_two(x), do: card_to_number(x)

  defp hand_rank("High card"), do: 1
  defp hand_rank("One pair"), do: 2
  defp hand_rank("Two pair"), do: 3
  defp hand_rank("Three of a kind"), do: 4
  defp hand_rank("Full house"), do: 5
  defp hand_rank("Four of a kind"), do: 6
  defp hand_rank("Five of a kind"), do: 7

  defp score_as_poker_hand(cards) do
    card_aggregations =
      Enum.reduce(cards, %{}, fn card, acc ->
        Map.update(acc, card, 1, &(&1 + 1))
      end)

    card_values = Enum.map(cards, &card_to_number/1)

    cond do
      # High card
      Enum.all?(card_aggregations, fn {_, x} -> x == 1 end) ->
        [hand_rank("High card") | card_values]

      # 5 of a kind
      Enum.any?(card_aggregations, fn {_, x} -> x == 5 end) ->
        [hand_rank("Five of a kind") | card_values]

      # 4 of a kind
      Enum.any?(card_aggregations, fn {_, x} -> x == 4 end) ->
        [hand_rank("Four of a kind") | card_values]

      # Full house
      Enum.any?(card_aggregations, fn {_, x} -> x == 3 end) and
          Enum.any?(card_aggregations, fn {_, x} -> x == 2 end) ->
        [hand_rank("Full house") | card_values]

      # 3 of a kind
      Enum.any?(card_aggregations, fn {_, x} -> x == 3 end) ->
        [hand_rank("Three of a kind") | card_values]

      # 2 pair
      Enum.count(card_aggregations, fn {_, x} -> x == 2 end) == 2 ->
        [hand_rank("Two pair") | card_values]

      # 1 pair
      Enum.any?(card_aggregations, fn {_, x} -> x == 2 end) ->
        [hand_rank("One pair") | card_values]
    end
  end

  defp score_as_poker_hand_two(cards) do
    card_aggregations =
      Enum.reduce(cards, %{}, fn card, acc ->
        Map.update(acc, card, 1, &(&1 + 1))
      end)

    card_values = Enum.map(cards, &card_to_number_part_two/1)

    joker_count = Map.get(card_aggregations, "J", 0)
    card_aggregations_without_joker = Map.delete(card_aggregations, "J")

    is_full_house =
      Enum.any?(card_aggregations_without_joker, fn {_, x} -> x == 3 end) and
        Enum.any?(card_aggregations_without_joker, fn {_, x} -> x == 2 end)

    is_joker_full_house_one =
      Enum.any?(card_aggregations_without_joker, fn {_, x} -> x == 3 end) and
        Enum.any?(card_aggregations_without_joker, fn {_, x} -> x == 1 end) and joker_count == 1

    is_joker_full_house_two =
      Enum.any?(card_aggregations_without_joker, fn {_, x} -> x == 2 end) and joker_count == 2

    is_joker_full_house_three =
      Enum.count(card_aggregations_without_joker, fn {_, x} -> x == 2 end) == 2 and
        joker_count == 1

    is_two_pair_with_joker =
      (Enum.count(card_aggregations_without_joker, fn {_, x} -> x == 2 end) == 1 and
         joker_count == 1) or
        Enum.count(card_aggregations_without_joker, fn {_, x} -> x == 2 end) == 2

    cond do
      joker_count >= 4 ->
        [hand_rank("Five of a kind") | card_values]

      Enum.any?(card_aggregations_without_joker, fn {_, x} -> x + joker_count == 5 end) ->
        [hand_rank("Five of a kind") | card_values]

      Enum.any?(card_aggregations_without_joker, fn {_, x} -> x + joker_count == 4 end) ->
        [hand_rank("Four of a kind") | card_values]

      is_full_house or is_joker_full_house_one or is_joker_full_house_two or
          is_joker_full_house_three ->
        [hand_rank("Full house") | card_values]

      Enum.any?(card_aggregations, fn {_, x} -> x + joker_count == 3 end) ->
        [hand_rank("Three of a kind") | card_values]

      is_two_pair_with_joker ->
        [hand_rank("Two pair") | card_values]

      Enum.any?(card_aggregations, fn {_, x} -> x + joker_count == 2 end) ->
        [hand_rank("One pair") | card_values]

      true ->
        [hand_rank("High card") | card_values]
    end
  end

  def part1(args) do
    args
    |> AdventOfCode.Load.lines()
    |> Enum.map(&parse/1)
    |> Enum.map(fn {cards, bid} ->
      x = score_as_poker_hand(cards)

      {x, String.to_integer(bid)}
    end)
    |> Enum.sort_by(fn {x, _} -> x end, :asc)
    |> Enum.with_index()
    |> Enum.map(fn {{_, bid}, index} -> bid * (index + 1) end)
    |> Enum.sum()
  end

  def part2(args) do
    args
    |> AdventOfCode.Load.lines()
    |> Enum.map(&parse/1)
    |> Enum.map(fn {cards, bid} ->
      x = score_as_poker_hand_two(cards)

      {x, String.to_integer(bid)}
    end)
    |> Enum.sort_by(fn {x, _} -> x end, :asc)
    |> Enum.with_index()
    |> Enum.map(fn {{_, bid}, index} -> bid * (index + 1) end)
    |> Enum.sum()
  end
end
