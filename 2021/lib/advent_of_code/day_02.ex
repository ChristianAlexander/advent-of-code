defmodule AdventOfCode.Day02 do
  defmodule Parser do
    import NimbleParsec

    instruction =
      choice([
        string("forward") |> replace(:f),
        string("down") |> replace(:d),
        string("up") |> replace(:u)
      ])

    defparsec(
      :parse,
      instruction |> ignore(string(" ")) |> integer(min: 1)
    )
  end

  def part1(args) do
    instructions =
      args
      |> AdventOfCode.Load.lines()
      |> Enum.map(&AdventOfCode.Day02.Parser.parse/1)
      |> Enum.map(fn {:ok, [direction, count], _, _, _, _} ->
        {direction, count}
      end)

    horizontal =
      instructions
      |> Enum.filter(fn {direction, _} -> direction == :f end)
      |> Enum.map(fn {_, amount} -> amount end)
      |> Enum.sum()

    vertical =
      instructions
      |> Enum.reject(fn {direction, _} -> direction == :f end)
      |> Enum.map(fn
        {:d, amount} -> amount
        {:u, amount} -> -1 * amount
      end)
      |> Enum.sum()

    horizontal * vertical
  end

  def part2(args) do
    instructions =
      args
      |> AdventOfCode.Load.lines()
      |> Enum.map(&AdventOfCode.Day02.Parser.parse/1)
      |> Enum.map(fn {:ok, [direction, count], _, _, _, _} ->
        {direction, count}
      end)

    {horizontal, vertical, _} =
      instructions
      |> Enum.reduce({0, 0, 0}, fn
        {:u, count}, {x, y, aim} ->
          {x, y, aim - count}

        {:d, count}, {x, y, aim} ->
          {x, y, aim + count}

        {:f, count}, {x, y, aim} ->
          {x + count, y + aim * count, aim}
      end)

    horizontal * vertical
  end
end
