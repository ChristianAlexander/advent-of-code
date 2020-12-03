defmodule AdventOfCode.Day03 do
  def part1(args) do
    width = String.length(Enum.fetch!(args, 0))
    map = parse_map(args)

    count_trees(map, get_slope(3, 1, width))
  end

  defp count_trees(map, slope) do
    count_trees(map, slope, {0,0}, 0)
  end

  defp count_trees(map, slope, {x, y}, count) do
    if y >= length(map) do
      count
    else
      count_trees(map, slope, slope.(x, y), count + get_space(map, x, y))
    end
  end

  defp get_space(map, x, y) do
    Enum.fetch!(map, y) |> Enum.fetch!(x)
  end

  defp get_slope(right, down, width) do
    fn x, y -> {rem(x + right, width), y + down} end
  end

  defp parse_map(lines) do
    lines
    |> Enum.reduce([], fn row, out_acc ->
      out_acc ++
        [
          String.codepoints(row)
          |> Enum.reduce([], fn char, acc ->
            case char do
              "." -> acc ++ [0]
              "#" -> acc ++ [1]
              _ -> acc
            end
          end)
        ]
    end)
  end

  def part2(args) do
    width = String.length(Enum.fetch!(args, 0))
    map = parse_map(args)

    [
      {1, 1},
      {3, 1},
      {5, 1},
      {7, 1},
      {1, 2}
    ]
    |> Enum.map(fn {right, down} -> get_slope(right, down, width) end)
    |> Enum.map(&(count_trees(map, &1)))
    |> Enum.reduce(&(&1*&2))
  end
end
