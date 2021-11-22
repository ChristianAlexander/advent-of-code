defmodule AdventOfCode.Day08 do
  def part1(args) do
    {:loop, result} =
      String.split(args, "\n", trim: true)
      |> Enum.map(&VM.Parser.parse/1)
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {x, i}, acc -> Map.put(acc, i, x) end)
      |> VM.initialize()
      |> VM.compute()

    result
  end

  def replace_jmp_nop(instructions, index) do
    i = Map.get(instructions, index)

    Map.put(
      instructions,
      index,
      case i do
        {:jmp, x} -> {:nop, x}
        {:nop, x} -> {:jmp, x}
        x -> x
      end
    )
  end

  def part2(args) do
    instructions =
      String.split(args, "\n", trim: true)
      |> Enum.map(&VM.Parser.parse/1)
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {x, i}, acc -> Map.put(acc, i, x) end)

    {:halt, result} =
      0..Enum.count(instructions)
      |> Enum.map(&replace_jmp_nop(instructions, &1))
      |> Enum.filter(fn x -> x != :no end)
      |> Enum.map(&VM.initialize/1)
      |> Enum.map(&VM.compute/1)
      |> Enum.find(fn {result_type, _} -> result_type == :halt end)

    result
  end
end
