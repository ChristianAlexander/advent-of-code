defmodule AdventOfCode.Day04 do
  defmodule Parser do
    import NimbleParsec

    assignment = integer(min: 1) |> ignore(string("-")) |> integer(min: 1)

    defparsecp(:assignment_pair, assignment |> ignore(string(",")) |> concat(assignment))

    def parse(line) do
      {:ok, [a_start, a_end, b_start, b_end], _, _, _, _} = assignment_pair(line)

      {MapSet.new(a_start..a_end), MapSet.new(b_start..b_end)}
    end
  end

  def part1(args) do
    args = AdventOfCode.Load.lines(args)

    args
    |> Stream.map(&Parser.parse/1)
    |> Stream.filter(fn {a, b} -> MapSet.subset?(a, b) or MapSet.subset?(b, a) end)
    |> Enum.count()
  end

  def part2(args) do
    args = AdventOfCode.Load.lines(args)

    args
    |> Stream.map(&Parser.parse/1)
    |> Stream.reject(fn {a, b} -> MapSet.disjoint?(a, b) end)
    |> Enum.count()
  end
end
