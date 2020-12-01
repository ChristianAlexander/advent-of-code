defmodule Mix.Tasks.D01.P1 do
  use Mix.Task

  import AdventOfCode.Day01

  @shortdoc "Day 01 Part 1"
  def run(args) do
    input =
      File.stream!(Path.join(File.cwd!(), "lib/inputs/d01.txt"))
      |> Stream.map(&Integer.parse/1)
      |> Stream.filter(&(!is_atom(&1)))
      |> Stream.map(&elem(&1, 0))

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_1: fn -> input |> part1() end}),
      else:
        input
        |> part1()
        |> IO.inspect(label: "Part 1 Results")
  end
end
