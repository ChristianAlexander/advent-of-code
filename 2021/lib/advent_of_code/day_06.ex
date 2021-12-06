defmodule AdventOfCode.Day06 do
  def part1(args) do
    fish =
      args
      |> AdventOfCode.Load.lines()
      |> Enum.flat_map(&String.split(&1, ","))
      |> Enum.map(&String.to_integer/1)
      |> Enum.reduce(Map.new(), fn x, acc -> Map.update(acc, x, 1, &(&1 + 1)) end)

    transform_fish_map(fish, 80)
    |> Map.values()
    |> Enum.sum()
  end

  def transform_fish_map(fish_map, 0), do: fish_map

  def transform_fish_map(fish_map, count) do
    Map.to_list(fish_map)
    |> Enum.reduce(Map.new(), fn
      {0, count}, acc ->
        Map.update(acc, 6, count, &(&1 + count))
        |> Map.put(8, count)

      {key, count}, acc ->
        Map.update(acc, key - 1, count, &(&1 + count))
    end)
    |> transform_fish_map(count - 1)
  end

  def part2(args) do
    fish =
      args
      |> AdventOfCode.Load.lines()
      |> Enum.flat_map(&String.split(&1, ","))
      |> Enum.map(&String.to_integer/1)
      |> Enum.reduce(Map.new(), fn x, acc -> Map.update(acc, x, 1, &(&1 + 1)) end)

    transform_fish_map(fish, 256)
    |> Map.values()
    |> Enum.sum()
  end
end
