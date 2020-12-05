defmodule Mix.Tasks.D05.P1 do
  use Mix.Task

  import AdventOfCode.Day05

  @shortdoc "Day 05 Part 1"
  def run(args) do
    input = File.stream!(Path.join(File.cwd!(), "lib/inputs/d05.txt"))

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_1: fn -> input |> part1() end}),
      else:
        input
        |> part1()
        |> IO.inspect(label: "Part 1 Results")
  end
end
