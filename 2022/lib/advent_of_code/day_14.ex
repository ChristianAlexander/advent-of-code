defmodule AdventOfCode.Day14 do
  def part1(args) do
    AdventOfCode.Load.lines(args)
    |> Enum.map(fn line ->
      String.split(line, " -> ")
      |> Enum.map(fn point ->
        String.split(point, ",") |> Enum.map(&String.to_integer/1) |> List.to_tuple()
      end)
    end)
    |> Enum.flat_map(&points_along_path/1)
    |> MapSet.new()
    |> count_sand_placement()
  end

  defp points_along_path(steps) when length(steps) < 2, do: []

  defp points_along_path([{from_x, from_y} | [{to_x, to_y} | _] = tail]) do
    Enum.flat_map(from_x..to_x, fn x ->
      Enum.map(from_y..to_y, fn y -> {x, y} end)
    end)
    |> Enum.concat(points_along_path(tail))
  end

  defp count_sand_placement(map, count \\ 0) do
    sand_source = {500, 0}

    case place_sand(map, sand_source) do
      {:ok, map} -> count_sand_placement(map, count + 1)
      {:abyss, _} -> count
    end
  end

  defp place_sand(map, {_, 1000}), do: {:abyss, map}

  defp place_sand(map, {x, y}) do
    if MapSet.member?(map, {x, y + 1}) do
      if MapSet.member?(map, {x - 1, y + 1}) do
        if MapSet.member?(map, {x + 1, y + 1}) do
          {:ok, MapSet.put(map, {x, y})}
        else
          place_sand(map, {x + 1, y + 1})
        end
      else
        place_sand(map, {x - 1, y + 1})
      end
    else
      place_sand(map, {x, y + 1})
    end
  end

  def part2(args) do
    map =
      AdventOfCode.Load.lines(args)
      |> Enum.map(fn line ->
        String.split(line, " -> ")
        |> Enum.map(fn point ->
          String.split(point, ",") |> Enum.map(&String.to_integer/1) |> List.to_tuple()
        end)
      end)
      |> Enum.flat_map(&points_along_path/1)
      |> MapSet.new()

    lowest_point = map |> Enum.map(&elem(&1, 1)) |> Enum.max()

    low_bar = lowest_point + 2

    Enum.concat(map, points_along_path([{-1000, low_bar}, {1000, low_bar}]))
    |> MapSet.new()
    |> count_until_blocked()
  end

  defp count_until_blocked(map, count \\ 1) do
    sand_source = {500, 0}

    case place_sand(map, sand_source) do
      {:ok, map} ->
        if MapSet.member?(map, sand_source) do
          count
        else
          count_until_blocked(map, count + 1)
        end
    end
  end
end
