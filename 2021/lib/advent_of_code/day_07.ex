defmodule AdventOfCode.Day07 do
  def part1(args) do
    positions =
      args
      |> AdventOfCode.Load.lines()
      |> Enum.flat_map(&String.split(&1, ","))
      |> Enum.map(&String.to_integer/1)
      |> Enum.reduce(Map.new(), fn x, acc -> Map.update(acc, x, 1, &(&1 + 1)) end)

    0..Enum.max(Map.keys(positions))
    |> Enum.map(fn i ->
      positions
      |> Enum.map(fn {pos, count} ->
        to_positive(i - pos) * count
      end)
      |> Enum.sum()
    end)
    |> Enum.min()
  end

  defp to_positive(x) when x < 0, do: -1 * x
  defp to_positive(x), do: x

  defp cost(0), do: 0
  defp cost(n), do: cost(n - 1) + n

  def part2(args) do
    positions =
      args
      |> AdventOfCode.Load.lines()
      |> Enum.flat_map(&String.split(&1, ","))
      |> Enum.map(&String.to_integer/1)
      |> Enum.reduce(Map.new(), fn x, acc -> Map.update(acc, x, 1, &(&1 + 1)) end)

    0..Enum.max(Map.keys(positions))
    |> Enum.map(fn i ->
      positions
      |> Enum.map(fn {pos, count} ->
        cost(to_positive(i - pos)) * count
      end)
      |> Enum.sum()
    end)
    |> Enum.min()
  end
end
