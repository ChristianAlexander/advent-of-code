defmodule AdventOfCode.Day01 do
  def part1(args) do
    args = args |> AdventOfCode.Load.numeric_lines() |> Enum.to_list()
    Enum.zip(args, Enum.drop(args, 1)) |> Enum.filter(fn {a, b} -> a < b end) |> Enum.count()
  end

  def part2(args) do
    args = args |> AdventOfCode.Load.numeric_lines() |> Enum.to_list()

    three_measurements =
      Enum.zip([args, Enum.drop(args, 1), Enum.drop(args, 2)])
      |> Enum.map(fn {a, b, c} -> a + b + c end)

    Enum.zip(three_measurements, Enum.drop(three_measurements, 1))
    |> Enum.filter(fn {a, b} -> a < b end)
    |> Enum.count()
  end
end
