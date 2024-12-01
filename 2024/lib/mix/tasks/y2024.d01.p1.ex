defmodule Elixir.Mix.Tasks.Y2024.D01.P1 do
  use Mix.Task

  import Elixir.Advent.Year2024.Day01

  @shortdoc "Day 01 Part 1"
  def run(args) do
    input = Advent.Input.get!(1, 2024)

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_1: fn -> input |> part1() end}),
      else:
        input
        |> part1()
        |> IO.inspect(label: "Part 1 Results")
  end
end
