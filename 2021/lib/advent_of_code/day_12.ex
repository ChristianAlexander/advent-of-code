defmodule AdventOfCode.Day12 do
  def part1(args) do
    args |> construct_graph |> walk(&walkable/3) |> Enum.count()
  end

  def part2(args) do
    args |> construct_graph |> walk(&walkable_with_one_duplciate_small_cave/3) |> Enum.count()
  end

  defp construct_graph(args) do
    edges =
      args
      |> AdventOfCode.Load.lines()
      |> Enum.map(&String.split(&1, "-"))

    vertices = edges |> List.flatten() |> Enum.uniq()

    graph = :digraph.new()

    vertices
    |> Enum.each(fn vertex ->
      :digraph.add_vertex(graph, vertex)
    end)

    edges
    |> Enum.each(fn
      [a, "end"] ->
        :digraph.add_edge(graph, a, "end")

      ["start", b] ->
        :digraph.add_edge(graph, "start", b)

      [a, b] ->
        :digraph.add_edge(graph, a, b)
        :digraph.add_edge(graph, b, a)
    end)

    graph
  end

  defp walk(graph, neighbor_filter, current_path \\ ["start"], visited \\ MapSet.new())

  defp walk(graph, neighbor_filter, current_path, visited) do
    :digraph.out_neighbours(graph, hd(current_path))
    |> Enum.filter(&neighbor_filter.(&1, visited, current_path))
    |> Enum.flat_map(fn
      "end" ->
        [["end" | current_path]]

      next ->
        walk(
          graph,
          neighbor_filter,
          [next | current_path],
          MapSet.union(visited, MapSet.new([next]))
        )
    end)
  end

  defp walkable(vertex, visited, _) do
    String.upcase(vertex) == vertex or not MapSet.member?(visited, vertex)
  end

  defp walkable_with_one_duplciate_small_cave(vertex, visited, current_path) do
    walkable(vertex, visited, current_path) or not has_duplicate_small_cave(current_path)
  end

  defp has_duplicate_small_cave(path) do
    path
    |> Enum.filter(&(String.downcase(&1) == &1))
    |> Enum.group_by(&Function.identity/1)
    |> Enum.any?(&(length(elem(&1, 1)) > 1))
  end
end
