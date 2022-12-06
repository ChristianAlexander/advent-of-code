defmodule AdventOfCode.Day06 do
  defp find_index_of_unique_subset(items, subset_length) do
    items
    |> Enum.with_index()
    |> Enum.reduce_while([], fn
      {ch, _}, acc when length(acc) < subset_length ->
        {:cont, [ch | acc]}

      {ch, index}, acc ->
        working_set = [ch | Enum.slice(acc, 0..(subset_length - 2))]

        if length(Enum.uniq(working_set)) == subset_length do
          {:halt, index + 1}
        else
          {:cont, working_set}
        end
    end)
  end

  def part1(args) do
    String.trim(args)
    |> String.codepoints()
    |> find_index_of_unique_subset(4)
  end

  def part2(args) do
    String.trim(args)
    |> String.codepoints()
    |> find_index_of_unique_subset(14)
  end
end
