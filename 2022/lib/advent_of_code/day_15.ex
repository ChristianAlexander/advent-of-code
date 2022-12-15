defmodule AdventOfCode.Day15 do
  def part1(args, y) do
    locations =
      AdventOfCode.Load.lines(args)
      |> Enum.map(fn line ->
        [sensor, beacon] = parse_input_line(line)

        distance = manhattan_distance(sensor, beacon)

        {sensor, distance, beacon}
      end)

    beacon_locations = Enum.map(locations, &elem(&1, 2)) |> MapSet.new()

    min_x = Enum.map(locations, fn {{x, _}, distance, _} -> x - distance end) |> Enum.min()
    max_x = Enum.map(locations, fn {{x, _}, distance, _} -> x + distance end) |> Enum.max()

    min_x..max_x
    |> Enum.filter(fn x ->
      is_within_distance_of_any(locations, {x, y}) and
        not MapSet.member?(beacon_locations, {x, y})
    end)
    |> Enum.count()
  end

  defp parse_input_line(line) do
    line
    |> String.replace_leading("Sensor at ", "")
    |> String.split(": closest beacon is at ")
    |> Enum.map(&parse_location/1)
    |> Enum.map(&List.to_tuple/1)
  end

  defp parse_location(location) do
    String.split(location, ", ")
    |> Enum.map(&String.slice(&1, 2..-1))
    |> Enum.map(&String.to_integer/1)
  end

  defp manhattan_distance({ax, ay}, {bx, by}) do
    abs(ax - bx) + abs(ay - by)
  end

  defp is_within_distance_of_any(locations, target) do
    Enum.any?(locations, fn {location, range, _} ->
      manhattan_distance(location, target) <= range
    end)
  end

  defp impossible_values_in_row(locations, row) do
    locations
    |> Enum.reduce([], fn {{x, y}, distance, _}, acc ->
      vert = abs(row - y)

      if vert > distance do
        acc
      else
        horiz = distance - vert

        [(x - horiz)..(x + horiz) | acc]
      end
    end)
    |> Enum.sort()
  end

  defp find_solution(exclusion_ranges, full_range) do
    exclusion_ranges
    |> Enum.flat_map(fn a..b -> [a - 1, b + 1] end)
    |> Enum.filter(&Enum.member?(full_range, &1))
    |> Enum.filter(fn value -> not Enum.any?(exclusion_ranges, &Enum.member?(&1, value)) end)
  end

  def part2(args, min_val, max_val) do
    locations =
      AdventOfCode.Load.lines(args)
      |> Enum.map(fn line ->
        [sensor, beacon] = parse_input_line(line)

        distance = manhattan_distance(sensor, beacon)

        {sensor, distance, beacon}
      end)

    impossibles =
      min_val..max_val
      |> Enum.map(&impossible_values_in_row(locations, &1))

    [{x, y}] =
      impossibles
      |> Enum.map(&find_solution(&1, min_val..max_val))
      |> Enum.with_index()
      |> Enum.flat_map(fn {all_x, y} ->
        Enum.map(all_x, &{&1, y})
      end)
      |> MapSet.new()
      |> MapSet.to_list()

    x * 4_000_000 + y
  end
end
