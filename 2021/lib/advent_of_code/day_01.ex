defmodule AdventOfCode.Day01 do
  def part1(args) do
    args = args |> AdventOfCode.Load.numeric_lines() |> Enum.into([])

    [_head | rest] = args

    Enum.zip(args, rest) |> Enum.filter(fn {a, b} -> a < b end) |> Enum.count()
  end

  def part2(args) do
    args = args |> AdventOfCode.Load.numeric_lines() |> Enum.into([])

    x =
      args
      |> Enum.with_index()
      |> Enum.map(fn {_, index} ->
        get_three_sums(index, args)
      end)
      |> Enum.filter(&Function.identity/1)

    [_head | rest] = x

    Enum.zip(x, rest) |> Enum.filter(fn {a, b} -> a < b end) |> Enum.count()
  end

  def get_three_sums(position, args) do
    x = args |> Enum.slice(position..-1) |> Enum.take(3)

    if Enum.count(x) < 3 do
      nil
    else
      Enum.sum(x)
    end
  end
end
