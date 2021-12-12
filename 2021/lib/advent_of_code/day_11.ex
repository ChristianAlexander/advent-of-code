defmodule AdventOfCode.Day11 do
  def part1(args) do
    map = load_map(args)

    1..100
    |> Enum.reduce({map, 0}, fn _, {map, acc} ->
      {map, flashed_count} = step(map)

      {map, acc + flashed_count}
    end)
    |> elem(1)
  end

  def part2(args) do
    map = load_map(args)

    synchronize(map)
  end

  defp load_map(args) do
    args
    |> AdventOfCode.Load.lines()
    |> Enum.map(&String.graphemes/1)
    |> Enum.with_index()
    |> Enum.flat_map(fn {line, x} ->
      line
      |> Enum.with_index()
      |> Enum.map(fn {val, y} ->
        {{x, y}, String.to_integer(val)}
      end)
    end)
    |> Enum.into(Map.new())
  end

  defp step(map) do
    map =
      Enum.map(map, fn {key, value} ->
        {key, value + 1}
      end)
      |> Enum.into(Map.new())

    flashed_map = flash(map)
    flashed_cells = flashed_map |> Enum.filter(&(elem(&1, 1) > 9)) |> Enum.map(&elem(&1, 0))

    stepped_map =
      flashed_cells
      |> Enum.reduce(flashed_map, fn cell, map ->
        Map.put(map, cell, 0)
      end)

    {stepped_map, length(flashed_cells)}
  end

  def flash(map, flashed_cells \\ MapSet.new()) do
    just_flashed_cells =
      Enum.filter(map, fn {cell, value} ->
        value > 9 and not MapSet.member?(flashed_cells, cell)
      end)
      |> Enum.map(&elem(&1, 0))

    if length(just_flashed_cells) == 0 do
      map
    else
      just_flashed_cells
      |> Enum.reduce(map, &increment_adjacent_cells/2)
      |> flash(MapSet.union(flashed_cells, MapSet.new(just_flashed_cells)))
    end
  end

  defp increment_adjacent_cells({cell_x, cell_y}, map) do
    (cell_x - 1)..(cell_x + 1)
    |> Enum.flat_map(fn x ->
      (cell_y - 1)..(cell_y + 1)
      |> Enum.reduce([], fn y, acc ->
        if Map.has_key?(map, {x, y}), do: [{x, y} | acc], else: acc
      end)
    end)
    |> Enum.reduce(map, fn cell, map ->
      Map.update!(map, cell, &(&1 + 1))
    end)
  end

  defp synchronize(map, generation \\ 1) do
    {map, _} = step(map)

    if Enum.all?(Map.values(map), &(&1 == 0)) do
      generation
    else
      synchronize(map, generation + 1)
    end
  end
end
