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
      |> Enum.reduce({0, 0}, &handle_naive_instructions/2)

    horizontal * vertical
  end

  defp handle_naive_instructions({:u, count}, {x, y}) do
    {x, y - count}
  end

  defp handle_naive_instructions({:d, count}, {x, y}) do
    {x, y + count}
  end

  defp handle_naive_instructions({:f, count}, {x, y}) do
    {x + count, y}
  end

  def part2(args) do
    instructions =
      args
      |> AdventOfCode.Load.lines()
      |> Enum.map(&Parser.parse/1)

    {horizontal, vertical, _} =
      instructions
      |> Enum.reduce({0, 0, 0}, &handle_aim_instructions/2)

    horizontal * vertical
  end

  defp handle_aim_instructions({:u, count}, {x, y, aim}) do
    {x, y, aim - count}
  end

  defp handle_aim_instructions({:d, count}, {x, y, aim}) do
    {x, y, aim + count}
  end

  defp handle_aim_instructions({:f, count}, {x, y, aim}) do
    {x + count, y + aim * count, aim}
  end
end
