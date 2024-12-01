defmodule Advent.Year2024.Day01 do
  defp parse_lines_into_lists(args) do
    args
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn line ->
      [a, b] = String.split(line, "   ")

      [String.to_integer(a), String.to_integer(b)]
    end)
    |> Enum.reduce([[], []], fn [a, b], [as, bs] ->
      [[a | as], [b | bs]]
    end)
  end

  def part1(args) do
    args
    |> parse_lines_into_lists()
    |> Enum.map(&Enum.sort/1)
    |> Enum.zip()
    |> Enum.reduce(0, fn {a, b}, acc ->
      acc + abs(a - b)
    end)
  end

  def part2(args) do
    [left, right] = parse_lines_into_lists(args)

    right_count_by_number =
      Enum.reduce(right, %{}, fn i, acc ->
        Map.update(acc, i, 1, &(&1 + 1))
      end)

    Enum.reduce(left, 0, fn i, acc ->
      acc + i * Map.get(right_count_by_number, i, 0)
    end)
  end
end
