defmodule AdventOfCode.Day02 do
  defmodule Parser do
    import NimbleParsec

    instruction =
      choice([
        string("forward") |> replace(:f),
        string("down") |> replace(:d),
        string("up") |> replace(:u)
      ])

    defparsecp(
      :parse_inner,
      instruction |> ignore(string(" ")) |> integer(min: 1)
    )

    def parse(entry) do
      {:ok, [direction, count], _, _, _, _} = parse_inner(entry)

      {direction, count}
    end
  end

  def part1(args) do
    instructions =
      args
      |> AdventOfCode.Load.lines()
      |> Enum.map(&Parser.parse/1)

    {horizontal, vertical} =
      instructions
      |> Enum.reduce({0, 0}, fn
        {:u, count}, {x, y} ->
          {x, y - count}

        {:d, count}, {x, y} ->
          {x, y + count}

        {:f, count}, {x, y} ->
          {x + count, y}
      end)

    horizontal * vertical
  end

  def part2(args) do
    instructions =
      args
      |> AdventOfCode.Load.lines()
      |> Enum.map(&Parser.parse/1)

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
