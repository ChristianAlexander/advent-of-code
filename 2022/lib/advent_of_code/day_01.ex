defmodule AdventOfCode.Day01 do
  defp load_sums(args) do
    args = args |> AdventOfCode.Load.lines(false) |> Enum.to_list()

    args
    |> Enum.reduce([0], fn
      "", acc ->
        [0 | acc]

      line, acc ->
        [current | rest] = acc

        {line, _} = Integer.parse(line)

        [current + line | rest]
    end)
  end

  def part1(args) do
    args
    |> load_sums()
    |> Enum.max()
  end

  def part2(args) do
    args
    |> load_sums()
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.sum()
  end
end
