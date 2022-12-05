defmodule AdventOfCode.Day05 do
  defmodule Parser do
    import NimbleParsec

    crate =
      ignore(string("["))
      |> ascii_char([?A..?Z])
      |> ignore(string("]"))
      |> optional(ignore(string(" ")))

    empty_space = string("   ") |> optional(string(" ")) |> replace(:empty)

    defparsecp(:inner_parse, repeat(choice([crate, empty_space])))

    instruction =
      ignore(string("move "))
      |> integer(min: 1, max: 2)
      |> ignore(string(" from "))
      |> integer(1)
      |> ignore(string(" to "))
      |> integer(1)

    defparsecp(:inner_parse_instruction, instruction)

    def parse(line) do
      {:ok, results, _, _, _, _} = inner_parse(line)

      results
    end

    def parse_instruction(line) do
      {:ok, results, _, _, _, _} = inner_parse_instruction(line)

      results
    end
  end

  def part1(args) do
    args = AdventOfCode.Load.lines(args)

    {definitions, instructions} = Enum.split_while(args, &(not String.starts_with?(&1, " 1")))

    box_definitions =
      definitions
      |> Enum.map(&Parser.parse/1)
      |> Enum.flat_map(&Enum.with_index/1)
      |> Enum.reduce(%{}, fn
        {:empty, _}, acc ->
          acc

        {val, idx}, acc ->
          Map.update(acc, idx + 1, [val], fn existing ->
            Enum.concat(existing, [val])
          end)
      end)

    instructions =
      instructions
      |> Enum.drop(1)
      |> Enum.map(&Parser.parse_instruction/1)

    results =
      Enum.reduce(instructions, box_definitions, fn [count, source, destination], definitions ->
        {items, source_tail} = Enum.split(Map.get(definitions, source), count)

        definitions
        |> Map.update!(destination, fn dest_vals ->
          Enum.concat(Enum.reverse(items), dest_vals)
        end)
        |> Map.put(source, source_tail)
      end)

    results |> Enum.map(fn {_, v} -> hd(v) end) |> List.to_string()
  end

  def part2(args) do
    args = AdventOfCode.Load.lines(args)

    {definitions, instructions} = Enum.split_while(args, &(not String.starts_with?(&1, " 1")))

    box_definitions =
      definitions
      |> Enum.map(&Parser.parse/1)
      |> Enum.flat_map(&Enum.with_index/1)
      |> Enum.reduce(%{}, fn
        {:empty, _}, acc ->
          acc

        {val, idx}, acc ->
          Map.update(acc, idx + 1, [val], fn existing ->
            Enum.concat(existing, [val])
          end)
      end)

    instructions =
      instructions
      |> Enum.drop(1)
      |> Enum.map(&Parser.parse_instruction/1)

    results =
      Enum.reduce(instructions, box_definitions, fn [count, source, destination], definitions ->
        {items, source_tail} = Enum.split(Map.get(definitions, source), count)

        definitions
        |> Map.update!(destination, fn dest_vals ->
          Enum.concat(items, dest_vals)
        end)
        |> Map.put(source, source_tail)
      end)

    results |> Enum.map(fn {_, v} -> hd(v) end) |> List.to_string()
  end
end
