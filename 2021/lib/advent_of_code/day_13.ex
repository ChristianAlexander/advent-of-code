defmodule AdventOfCode.Day13 do
  def part1(args) do
    {map, splits} = parse(args)

    splits
    |> Enum.take(1)
    |> fold(map)
    |> Enum.count()
  end

  defp parse(args) do
    instructions =
      args
      |> AdventOfCode.Load.lines()
      |> Enum.map(fn
        "fold along x=" <> value ->
          {:fold, {:x, String.to_integer(value)}}

        "fold along y=" <> value ->
          {:fold, {:y, String.to_integer(value)}}

        point ->
          String.split(point, ",") |> Enum.map(&String.to_integer/1)
      end)

    {points, splits} =
      instructions
      |> Enum.split_with(fn
        [_x, _y] -> true
        _ -> false
      end)

    map =
      points
      |> Enum.reduce(Map.new(), fn [x, y], acc ->
        Map.put(acc, {x, y}, 1)
      end)

    {map, splits}
  end

  defp fold(folds, paper) do
    folds
    |> Enum.reduce(
      paper,
      fn
        {:fold, {:x, fold_at}}, map ->
          Enum.reduce(
            map,
            Map.new(),
            fn
              {{x, y}, _}, acc when x < fold_at ->
                Map.put(acc, {x, y}, "#")

              {{x, y}, _}, acc ->
                Map.put(acc, {fold_at + (fold_at - x), y}, "#")
            end
          )

        {:fold, {:y, fold_at}}, map ->
          Enum.reduce(
            map,
            Map.new(),
            fn
              {{x, y}, _}, acc when y < fold_at ->
                Map.put(acc, {x, y}, "#")

              {{x, y}, _}, acc ->
                Map.put(acc, {x, fold_at + (fold_at - y)}, "#")
            end
          )
      end
    )
  end

  defp render_paper(paper) do
    width = Enum.map(paper, fn {{x, _}, _} -> x end) |> Enum.max()
    height = Enum.map(paper, fn {{_, y}, _} -> y end) |> Enum.max()

    0..height
    |> Enum.each(fn y ->
      0..width
      |> Enum.map(fn x ->
        Map.get(paper, {x, y}, ".")
      end)
      |> Enum.join("")
      |> IO.puts()
    end)
  end

  def part2(args) do
    {map, splits} = parse(args)

    splits
    |> fold(map)
    |> render_paper()
  end
end
