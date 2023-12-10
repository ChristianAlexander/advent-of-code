defmodule AdventOfCode.Day10 do
  @tile_types ["|", "-", "L", "J", "F", "7", "."]

  def adjacent_spaces({{x, y}, "|"}), do: [{x, y - 1}, {x, y + 1}]
  def adjacent_spaces({{x, y}, "-"}), do: [{x - 1, y}, {x + 1, y}]
  def adjacent_spaces({{x, y}, "L"}), do: [{x, y - 1}, {x + 1, y}]
  def adjacent_spaces({{x, y}, "J"}), do: [{x, y - 1}, {x - 1, y}]
  def adjacent_spaces({{x, y}, "F"}), do: [{x, y + 1}, {x + 1, y}]
  def adjacent_spaces({{x, y}, "7"}), do: [{x, y + 1}, {x - 1, y}]
  def adjacent_spaces({{x, y}, "S"}), do: [{x - 1, y}, {x + 1, y}, {x, y - 1}, {x, y + 1}]
  def adjacent_spaces({_, "."}), do: []

  def connectable_neighbors({location, _} = point, map) do
    adjacent_spaces(point)
    |> Enum.filter(fn neighbor_location ->
      if Map.has_key?(map, neighbor_location) do
        neighbor_value = Map.get(map, neighbor_location)

        # Does the neighbor consider the current point a neighbor?
        {neighbor_location, neighbor_value}
        |> adjacent_spaces()
        |> Enum.member?(location)
      else
        # Neighbor doesn't exist
        false
      end
    end)
  end

  def determine_point_type({location, _} = point, map) do
    # Given the point's observed neighbors…
    observed_neighbors = MapSet.new(connectable_neighbors(point, map))

    # …find the tile type that would have the same neighbors
    @tile_types
    |> Enum.find(fn tile_type ->
      MapSet.new(adjacent_spaces({location, tile_type}))
      |> MapSet.equal?(observed_neighbors)
    end)
  end

  def parse_map(args) do
    args
    |> AdventOfCode.Load.lines()
    |> Enum.with_index()
    |> Enum.flat_map(fn {line, line_number} ->
      line
      |> String.codepoints()
      |> Enum.with_index()
      |> Enum.map(fn {tile, tile_number} ->
        {{tile_number, line_number}, tile}
      end)
    end)
    |> Enum.into(%{})
  end

  def to_edges(map) do
    Enum.flat_map(map, fn {location, _} = point ->
      adjacent_spaces(point)
      |> Enum.filter(fn neighbor_location ->
        Map.has_key?(map, neighbor_location)
      end)
      |> Enum.map(fn neighbor_location ->
        {location, neighbor_location}
      end)
    end)
  end

  def part1(args) do
    map = parse_map(args)

    {start_location, _} = start_space = Enum.find(map, fn {_, tile} -> tile == "S" end)
    start_type = determine_point_type(start_space, map)

    map = Map.put(map, start_location, start_type)

    graph =
      Graph.new()
      |> Graph.add_edges(to_edges(map))

    Graph.bellman_ford(graph, start_location)
    |> Map.values()
    |> Enum.filter(fn
      :infinity -> false
      _ -> true
    end)
    |> Enum.max()
  end

  def count_inside_points(map, y, maximum_x) do
    {_, result, _} =
      Enum.map(0..maximum_x, fn x -> Map.get(map, {x, y}) end)
      |> Enum.reduce({nil, 0, false}, fn
        # If we have crossed an edge, we are inside the loop
        ".", {previous_corner, count, true} ->
          {previous_corner, count + 1, true}

        ".", acc ->
          acc

        "-", acc ->
          acc

        # Every time we encounter a "|", we cross an edge
        "|", {previous_corner, count, has_crossed} ->
          {previous_corner, count, not has_crossed}

        # When we traverse from an L to a 7, we cross an edge
        "7", {"L", count, has_crossed} ->
          {nil, count, not has_crossed}

        # When we traverse from an F to a J, we cross an edge
        "J", {"F", count, has_crossed} ->
          {nil, count, not has_crossed}

        # For all other corner situations, record the corner and continue
        corner, {_, count, has_crossed} ->
          {corner, count, has_crossed}
      end)

    result
  end

  def part2(args) do
    map = parse_map(args)
    maximum_x = Enum.max(Enum.map(map, fn {{x, _}, _} -> x end))
    maximum_y = Enum.max(Enum.map(map, fn {{_, y}, _} -> y end))

    {start_location, _} = start_space = Enum.find(map, fn {_, tile} -> tile == "S" end)
    start_type = determine_point_type(start_space, map)

    map = Map.put(map, start_location, start_type)

    connections =
      Enum.flat_map(map, fn {location, _} = point ->
        adjacent_spaces(point)
        |> Enum.filter(fn neighbor_location ->
          Map.has_key?(map, neighbor_location)
        end)
        |> Enum.map(fn neighbor_location ->
          {location, neighbor_location}
        end)
      end)

    loop_members =
      Graph.new()
      |> Graph.add_edges(connections)
      |> Graph.reachable([start_location])
      |> MapSet.new()

    # Replace all unconnected pipes with the background character
    map =
      map
      |> Enum.map(fn {location, value} ->
        if MapSet.member?(loop_members, location), do: {location, value}, else: {location, "."}
      end)
      |> Enum.into(%{})

    # Count each row
    0..maximum_y
    |> Enum.map(fn y -> count_inside_points(map, y, maximum_x) end)
    |> Enum.sum()
  end
end
