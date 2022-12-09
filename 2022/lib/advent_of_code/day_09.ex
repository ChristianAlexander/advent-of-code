defmodule AdventOfCode.Day09 do
  def part1(args) do
    parse_instructions(args)
    |> instructions_to_positions()
    |> chain_follow(1)
    |> MapSet.new()
    |> Enum.count()
  end

  defp instructions_to_positions(instructions) do
    Enum.reduce(instructions, [{0, 0}], fn instruction, locations ->
      current = List.last(locations)

      Enum.concat(locations, transform(current, instruction))
    end)
  end

  def part2(args) do
    parse_instructions(args)
    |> instructions_to_positions()
    |> chain_follow(9)
    |> MapSet.new()
    |> Enum.count()
  end

  def parse_instructions(args) do
    AdventOfCode.Load.lines(args)
    |> Enum.map(&String.split/1)
    |> Enum.map(fn [direction, amount] -> [direction, String.to_integer(amount)] end)
  end

  def touching?({hx, hy}, {tx, ty}) do
    max(abs(hx - tx), abs(hy - ty)) < 2
  end

  def follow({hx, hy} = head, {tx, ty} = tail) do
    if touching?(head, tail) do
      tail
    else
      x =
        cond do
          hx == tx -> tx
          hx < tx -> tx - 1
          hx > tx -> tx + 1
        end

      y =
        cond do
          hy == ty -> ty
          hy < ty -> ty - 1
          hy > ty -> ty + 1
        end

      {x, y}
    end
  end

  def transform(_, [_, 0]), do: []
  def transform({x, y}, ["U", n]), do: [{x, y + 1} | transform({x, y + 1}, ["U", n - 1])]
  def transform({x, y}, ["D", n]), do: [{x, y - 1} | transform({x, y - 1}, ["D", n - 1])]
  def transform({x, y}, ["L", n]), do: [{x - 1, y} | transform({x - 1, y}, ["L", n - 1])]
  def transform({x, y}, ["R", n]), do: [{x + 1, y} | transform({x + 1, y}, ["R", n - 1])]

  def chain_follow(path, 0), do: path

  def chain_follow(head_path, segment_count) do
    Enum.reduce(head_path, [{0, 0}], fn head, tail_path ->
      current = hd(tail_path)

      next = follow(head, current)

      [next | tail_path]
    end)
    |> Enum.reverse()
    |> chain_follow(segment_count - 1)
  end
end
