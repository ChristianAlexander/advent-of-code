defmodule AdventOfCode.Day09 do
  def part1(args) do
    map =
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

    map
    |> Map.to_list()
    |> Enum.filter(fn {cell, height} ->
      adjacent_cells(map, cell)
      |> Enum.all?(&(height < &1))
    end)
    |> Enum.map(fn {_, height} -> risk(height) end)
    |> Enum.sum()
  end

  defp risk(height) do
    height + 1
  end

  defp adjacent_cells(map, {cell_x, cell_y}) do
    (cell_x - 1)..(cell_x + 1)
    |> Enum.flat_map(fn x ->
      (cell_y - 1)..(cell_y + 1)
      |> Enum.map(fn y ->
        case {x, y} do
          {^cell_x, ^cell_y} -> nil
          point -> Map.get(map, point)
        end
      end)
    end)
    |> Enum.filter(&Function.identity/1)
  end

  defp neighbor_cells(map, {cell_x, cell_y}) do
    [
      {cell_x - 1, cell_y},
      {cell_x + 1, cell_y},
      {cell_x, cell_y - 1},
      {cell_x, cell_y + 1}
    ]
    |> Enum.map(fn cell -> {cell, Map.get(map, cell)} end)
    |> Enum.filter(fn {_, height} -> height end)
  end

  def part2(args) do
    map =
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

    find_all_basins(map, [])
    |> Enum.map(&MapSet.size/1)
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.product()
  end

  defp find_all_basins(map, []) do
    basin = find_basin_bounds(map, MapSet.new(), MapSet.new(), [{0, 0}])

    find_all_basins(map, [basin])
  end

  defp find_all_basins(map, basins) do
    excluded = basins |> Enum.reduce(fn basin, acc -> MapSet.union(basin, acc) end)

    case find_candidate_basin_seed(map, excluded) do
      nil ->
        basins

      {seed, _} ->
        basin = find_basin_bounds(map, excluded, MapSet.new(), [seed])
        find_all_basins(map, [basin | basins])
    end
  end

  defp find_candidate_basin_seed(map, excluded) do
    map
    |> Map.to_list()
    |> Enum.reject(fn
      {_, 9} ->
        true

      {cell, _} ->
        MapSet.member?(excluded, cell)
    end)
    |> Enum.at(0)
  end

  defp find_basin_bounds(_, _, validated, []), do: validated

  defp find_basin_bounds(map, excluded, validated, edges) do
    new_edges =
      edges
      |> Enum.flat_map(fn edge ->
        neighbor_cells(map, edge)
        |> Enum.map(fn
          {_, 9} -> nil
          {cell, _} -> cell
        end)
        |> Enum.filter(&Function.identity/1)
      end)
      |> Enum.reject(&MapSet.member?(MapSet.union(excluded, validated), &1))

    validated = MapSet.union(validated, MapSet.new(edges))

    find_basin_bounds(map, excluded, validated, new_edges)
  end
end
