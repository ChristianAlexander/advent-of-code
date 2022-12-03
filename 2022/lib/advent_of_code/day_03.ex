defmodule AdventOfCode.Day03 do
  defp split_bags(bag) do
    len = String.length(bag)

    String.split_at(bag, div(len, 2))
  end

  defp bag_to_priority(compartments) do
    compartments
    |> Tuple.to_list()
    |> Enum.map(fn compartment ->
      String.to_charlist(compartment) |> Enum.map(&priority/1)
    end)
    |> List.to_tuple()
  end

  defp to_sets(compartments) do
    compartments
    |> Tuple.to_list()
    |> Enum.map(&MapSet.new/1)
    |> List.to_tuple()
  end

  defp find_overlap({left, right}) do
    MapSet.intersection(left, right)
  end

  defp priority(item) do
    if item > 90 do
      item - 96
    else
      item - 38
    end
  end

  def part1(args) do
    args = AdventOfCode.Load.lines(args)

    args
    |> Enum.map(&split_bags/1)
    |> Enum.map(&bag_to_priority/1)
    |> Enum.map(&to_sets/1)
    |> Enum.flat_map(&find_overlap/1)
    |> Enum.sum()
  end

  def part2(args) do
    args = AdventOfCode.Load.lines(args)

    args
    |> Enum.map(fn bag ->
      bag
      |> String.to_charlist()
      |> Enum.map(&priority/1)
      |> MapSet.new()
    end)
    |> Enum.chunk_every(3)
    |> Enum.flat_map(fn bag_sets ->
      Enum.reduce(bag_sets, &MapSet.intersection/2)
    end)
    |> Enum.sum()
  end
end
