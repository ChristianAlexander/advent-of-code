defmodule AdventOfCode.Day13 do
  def part1(args) do
    AdventOfCode.Load.lines(args)
    |> Enum.map(fn line -> Code.string_to_quoted!(line) end)
    |> Enum.chunk_every(2)
    |> Enum.map(fn [a, b] -> compare(a, b) end)
    |> Enum.with_index()
    |> Enum.filter(&(elem(&1, 0) == :lt))
    |> Enum.map(&(elem(&1, 1) + 1))
    |> Enum.sum()
  end

  defp compare(a, a), do: nil

  defp compare(a, b) when is_integer(a) and is_integer(b) do
    if a < b do
      :lt
    else
      :gt
    end
  end

  defp compare(a, b) when is_integer(a) and is_list(b), do: compare([a], b)

  defp compare(a, b) when is_list(a) and is_integer(b), do: compare(a, [b])

  defp compare(a, b) do
    result =
      Enum.zip(a, b)
      |> Enum.reduce_while(nil, fn {a, b}, _ ->
        case compare(a, b) do
          nil -> {:cont, nil}
          result -> {:halt, result}
        end
      end)

    if result == nil do
      if length(a) < length(b), do: :lt, else: :gt
    else
      result
    end
  end

  def part2(args) do
    sorted =
      AdventOfCode.Load.lines(args)
      |> Enum.concat(["[[2]]", "[[6]]"])
      |> Enum.map(fn line -> Code.string_to_quoted!(line) end)
      |> Enum.sort(fn a, b -> compare(a, b) != :gt end)

    position_of_two = Enum.find_index(sorted, fn elem -> elem == [[2]] end) + 1
    position_of_six = Enum.find_index(sorted, fn elem -> elem == [[6]] end) + 1

    position_of_two * position_of_six
  end
end
