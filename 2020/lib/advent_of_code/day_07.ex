defmodule AdventOfCode.Day07 do
  defmodule Parser do
    import NimbleParsec

    bag = choice([string("bags"), string("bag")])

    colored_bag =
      repeat(
        lookahead_not(ignore(bag))
        |> ascii_char([?a..?z, ?A..?Z, ?\s])
      )
      |> reduce({List, :to_string, []})
      |> reduce(:trim)
      |> ignore(bag)

    bag_contents =
      choice([
        string("no other bags") |> replace(:no_bag),
        integer(min: 1) |> concat(colored_bag)
      ])

    defp trim([string]), do: String.trim(string)

    defp as_map([source_bag | content_bags]) do
      content_bags =
        Enum.zip(
          content_bags |> Enum.drop(1) |> Enum.take_every(2),
          content_bags |> Enum.take_every(2)
        )
        |> Map.new()

      Map.put(%{}, source_bag, content_bags)
    end

    defparsecp(
      :bag_definition,
      colored_bag
      |> ignore(string(" contain "))
      |> repeat(
        bag_contents
        |> ignore(choice([string(", "), string(".")]))
      )
      |> reduce(:as_map)
    )

    def parse(definition) do
      {:ok, [result], _, _, _, _} = bag_definition(definition)

      result
    end
  end

  def part1(args) do
    all_bags =
      String.split(args, "\n", trim: true)
      |> Enum.map(&Parser.parse/1)
      |> Enum.reduce(&Map.merge/2)

    Enum.count(all_bags, fn {k, _} -> contains_gold(all_bags, k) end)
  end

  def contains_gold(_, :no_bag) do
    false
  end

  def contains_gold(all_bags, color) do
    current_bag_contents = Map.get(all_bags, color, %{})

    Map.has_key?(current_bag_contents, "shiny gold") ||
      Enum.any?(Map.keys(current_bag_contents), &contains_gold(all_bags, &1))
  end

  def part2(args) do
    String.split(args, "\n", trim: true)
    |> Enum.map(&Parser.parse/1)
    |> Enum.reduce(&Map.merge/2)
    |> content_count("shiny gold")
  end

  def content_count(_, :no_bag) do
    0
  end

  def content_count(all_bags, color) do
    Map.get(all_bags, color, %{})
    |> Enum.map(fn {color, count} ->
      count + count * content_count(all_bags, color)
    end)
    |> Enum.sum()
  end
end
