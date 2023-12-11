defmodule AdventOfCode.Day11 do
  def parse_map(args) do
    args
    |> AdventOfCode.Load.lines()
    |> Enum.with_index()
    |> Enum.flat_map(fn {line, y} ->
      line
      |> String.codepoints()
      |> Enum.with_index()
      |> Enum.filter(fn {tile, _} ->
        tile == "#"
      end)
      |> Enum.map(fn {_, x} -> {x, y} end)
    end)
  end

  def expand_map(map, scaling_factor \\ 2) do
    width = map |> Enum.map(fn {x, _} -> x end) |> Enum.max()
    height = map |> Enum.map(fn {_, y} -> y end) |> Enum.max()

    empty_columns =
      0..width
      |> Enum.reject(fn target_x -> Enum.any?(map, fn {x, _} -> x == target_x end) end)

    empty_rows =
      0..height
      |> Enum.reject(fn target_y -> Enum.any?(map, fn {_, y} -> y == target_y end) end)

    map
    |> Enum.map(fn {x, y} ->
      empty_columns_before_this =
        Enum.count(Enum.filter(empty_columns, fn empty_x -> empty_x < x end))

      empty_rows_before_this = Enum.count(Enum.filter(empty_rows, fn empty_y -> empty_y < y end))

      {x + empty_columns_before_this * (scaling_factor - 1),
       y + empty_rows_before_this * (scaling_factor - 1)}
    end)
  end

  defp distance({x1, y1}, {x2, y2}) do
    abs(x1 - x2) + abs(y1 - y2)
  end

  def part1(args) do
    galaxy_points =
      parse_map(args)
      |> expand_map()

    Combinatorics.n_combinations(2, galaxy_points)
    |> Enum.map(fn [point1, point2] -> distance(point1, point2) end)
    |> Enum.sum()
  end

  def part2(args, scaling_factor \\ 1_000_000) do
    galaxy_points =
      parse_map(args)
      |> expand_map(scaling_factor)

    Combinatorics.n_combinations(2, galaxy_points)
    |> Enum.map(fn [point1, point2] -> distance(point1, point2) end)
    |> Enum.sum()
  end
end
