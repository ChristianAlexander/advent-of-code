defmodule AdventOfCode.Day06 do
  def part1(args) do
    String.split(args, "\n\n")
    |> Enum.map(fn group ->
      group
      |> String.split("\n", trim: true)
      |> Enum.flat_map(fn person ->
        String.codepoints(person)
      end)
      |> MapSet.new()
      |> Enum.count()
    end)
    |> Enum.sum()
  end

  def part2(args) do
    String.split(args, "\n\n")
    |> Enum.map(fn group ->
      group
      |> String.split("\n", trim: true)
      |> Enum.map(fn person ->
        String.codepoints(person) |> MapSet.new()
      end)
      |> Enum.reduce(&MapSet.intersection(&1, &2))
      |> Enum.count()
    end)
    |> Enum.sum()
  end
end
