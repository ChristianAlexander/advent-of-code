defmodule AdventOfCode.Day07 do
  defmodule Parser do
    import NimbleParsec

    command =
      replace(string("$ "), :command)
      |> choice([string("cd "), string("ls")])
      |> optional(utf8_string([], min: 1))

    dir =
      replace(string("dir "), :dir)
      |> unwrap_and_tag(utf8_string([], min: 1), :name)

    file =
      unwrap_and_tag(integer(min: 1), :size)
      |> ignore(string(" "))
      |> unwrap_and_tag(utf8_string([], min: 1), :name)

    entry = choice([command, dir, file])

    defparsecp(:inner_parse, entry)

    def parse(line) do
      {:ok, results, _, _, _, _} = inner_parse(line)

      results
    end
  end

  defp construct_tree(commands) do
    Enum.reduce(commands, %{pwd: "/", tree: %{"" => %{}}}, fn
      [:command, "cd ", path], %{pwd: pwd} = acc ->
        %{acc | pwd: Path.join(pwd, path) |> Path.expand()}

      [:command, "ls"], acc ->
        acc

      [:dir, {:name, dirname}], %{pwd: pwd, tree: tree} = acc ->
        path = Path.join(pwd, dirname) |> String.split("/")

        tree = put_in(tree, path, %{})

        %{acc | tree: tree}

      [size: size, name: filename], %{pwd: pwd, tree: tree} = acc ->
        path = Path.join(pwd, filename) |> String.split("/")

        tree = put_in(tree, path, size)
        %{acc | tree: tree}
    end).tree
  end

  defp collect_sizes(x) when is_integer(x), do: []

  defp collect_sizes(tree) do
    child_sizes = Map.values(tree) |> Enum.map(&collect_sizes/1) |> List.flatten()

    [calculate_size(tree) | child_sizes]
  end

  defp calculate_size(val) when is_integer(val), do: val

  defp calculate_size(dir) do
    Map.values(dir)
    |> Enum.map(&calculate_size/1)
    |> Enum.sum()
  end

  def part1(args) do
    commands =
      AdventOfCode.Load.lines(args)
      |> Enum.map(&Parser.parse/1)

    tree = construct_tree(commands)

    directory_sizes = collect_sizes(tree)

    directory_sizes |> Enum.filter(&(&1 <= 100_000)) |> Enum.sum()
  end

  def part2(args) do
    commands =
      AdventOfCode.Load.lines(args)
      |> Enum.map(&Parser.parse/1)

    tree = construct_tree(commands)

    directory_sizes = collect_sizes(tree)

    target = Enum.max(directory_sizes) - 40_000_000

    directory_sizes
    |> Enum.sort()
    |> Enum.find(&(&1 >= target))
  end
end
