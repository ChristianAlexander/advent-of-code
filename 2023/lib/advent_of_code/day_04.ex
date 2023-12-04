defmodule AdventOfCode.Day04 do
  defmodule Parser do
    import NimbleParsec

    card_id =
      ignore(string("Card") |> repeat(string(" "))) |> integer(min: 1) |> ignore(string(":"))

    numbers = repeat(choice([integer(min: 1), ignore(string(" ")), replace(string("|"), :pipe)]))

    defparsecp(
      :line_parser,
      card_id
      |> concat(numbers)
    )

    def parse(line) do
      {:ok, [game_id | rest], _, _, _, _} = line_parser(line)

      {called_numbers, [_ | your_numbers]} =
        Enum.split_while(rest, fn number -> number != :pipe end)

      {game_id, called_numbers, your_numbers}
    end
  end

  def count_matches({_id, called_numbers, your_numbers}) do
    called_numbers = MapSet.new(called_numbers)

    Enum.count(your_numbers, &MapSet.member?(called_numbers, &1))
  end

  def part1(args) do
    args
    |> AdventOfCode.Load.lines()
    |> Enum.map(&Parser.parse/1)
    |> Enum.map(fn card ->
      case count_matches(card) do
        0 ->
          0

        1 ->
          1

        x ->
          Integer.pow(2, x - 1)
      end
    end)
    |> Enum.sum()
  end

  def score_card(card, cards_by_card) do
    sub_cards = Map.get(cards_by_card, card)

    if sub_cards == [] do
      1
    else
      Enum.reduce(sub_cards, 1, fn sub_card, acc -> acc + score_card(sub_card, cards_by_card) end)
    end
  end

  def part2(args) do
    cards =
      args
      |> AdventOfCode.Load.lines()
      |> Enum.map(&Parser.parse/1)

    matches_by_card =
      Enum.map(cards, fn {id, _, _} = card ->
        {id, count_matches(card)}
      end)

    cards_by_card =
      Enum.map(matches_by_card, fn
        {id, 0} ->
          {id, []}

        {id, matches} ->
          {id, Enum.map((id + 1)..(id + matches), fn target_card -> target_card end)}
      end)
      |> Enum.into(%{})

    Map.keys(cards_by_card)
    |> Enum.map(fn card -> score_card(card, cards_by_card) end)
    |> Enum.sum()
  end
end
