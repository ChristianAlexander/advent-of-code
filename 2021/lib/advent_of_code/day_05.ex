defmodule AdventOfCode.Day05 do
  defmodule Parser do
    import NimbleParsec

    point =
      integer(min: 1)
      |> ignore(string(","))
      |> integer(min: 1)

    defparsecp(
      :parse_inner,
      point |> ignore(string(" -> ")) |> concat(point)
    )

    def parse(line) do
      {:ok, [x1, y1, x2, y2], _, _, _, _} = parse_inner(line)

      {{x1, y1}, {x2, y2}}
    end
  end

  defp is_horizontal({{_, y1}, {_, y2}}), do: y1 == y2
  defp is_vertical({{x1, _}, {x2, _}}), do: x1 == x2

  defp fill(line = {{x1, y1}, {x2, y2}}, area) do
    cond do
      is_vertical(line) ->
        Enum.reduce(y1..y2, area, fn y, area ->
          Map.update(area, {x1, y}, 1, &(&1 + 1))
        end)

      is_horizontal(line) ->
        Enum.reduce(x1..x2, area, fn x, area ->
          Map.update(area, {x, y1}, 1, &(&1 + 1))
        end)

      true ->
        Enum.zip(x1..x2, y1..y2)
        |> Enum.reduce(area, fn {x, y}, area ->
          Map.update(area, {x, y}, 1, &(&1 + 1))
        end)
    end
  end

  def part1(args) do
    lines =
      args
      |> AdventOfCode.Load.lines()
      |> Enum.map(&Parser.parse/1)
      |> Enum.filter(&(is_vertical(&1) or is_horizontal(&1)))

    Enum.reduce(lines, Map.new(), &fill/2) |> Map.values() |> Enum.count(&(&1 >= 2))
  end

  def part2(args) do
    lines =
      args
      |> AdventOfCode.Load.lines()
      |> Enum.map(&Parser.parse/1)

    Enum.reduce(lines, Map.new(), &fill/2) |> Map.values() |> Enum.count(&(&1 >= 2))
  end
end
