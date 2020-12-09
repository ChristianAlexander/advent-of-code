defmodule Mix.Tasks.D09.P1 do
  use Mix.Task

  import AdventOfCode.Day09

  @shortdoc "Day 09 Part 1"
  def run(args) do
    input = File.read!(Path.join(File.cwd!(), "lib/inputs/d09.txt"))

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_1: fn -> input |> part1(25) end}),
      else:
        input
        |> part1(25)
        |> IO.inspect(label: "Part 1 Results")
  end
end
