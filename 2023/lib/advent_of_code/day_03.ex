defmodule AdventOfCode.Day03 do
  defmodule Parser do
    import NimbleParsec

    location_number = integer(min: 1) |> pre_traverse({:with_location, []})

    location_symbol =
      choice([
        replace(
          choice([
            string("-"),
            string("@"),
            string("/"),
            string("&"),
            string("#"),
            string("%"),
            string("+"),
            string("="),
            string("$")
          ]),
          :symbol
        ),
        replace(string("*"), :gear)
      ])
      |> pre_traverse({:with_location, []})

    defp with_location(_rest, args, context, _line, offset) do
      {[{offset, hd(args)}], context}
    end

    defparsecp(
      :line_parser,
      repeat(
        choice([
          location_number,
          location_symbol,
          ignore(string("."))
        ])
      )
    )

    def parse(line) do
      {:ok, results, _, _, _, _} = line_parser(line)

      results
    end
  end

  defp adjacency_points({x, y}, value) do
    string_length = String.length(to_string(value))

    [{x - 1, y}, {x + string_length, y}] ++
      Enum.flat_map(-1..string_length, fn i -> [{x + i, y - 1}, {x + i, y + 1}] end)
  end

  defp parse_schematic(args) do
    args
    |> AdventOfCode.Load.lines()
    |> Enum.map(&Parser.parse/1)
    |> Enum.with_index()
    |> Enum.flat_map(fn {line, line_number} ->
      Enum.map(line, fn {column_number, value} -> {{column_number, line_number}, value} end)
    end)
  end

  def part1(args) do
    schematic = parse_schematic(args)

    {symbols, numbers} = Enum.split_with(schematic, fn {_, value} -> is_atom(value) end)

    symbol_locations = symbols |> Enum.map(&elem(&1, 0)) |> Enum.into(MapSet.new())

    numbers
    |> Enum.filter(fn {location, value} ->
      Enum.any?(adjacency_points(location, value), fn location ->
        MapSet.member?(symbol_locations, location)
      end)
    end)
    |> Enum.map(&elem(&1, 1))
    |> Enum.sum()
  end

  def part2(args) do
    schematic = parse_schematic(args)

    gear_locations =
      Enum.filter(schematic, fn {_, value} -> value == :gear end)
      |> Enum.map(&elem(&1, 0))

    numbers = Enum.filter(schematic, fn {_, value} -> is_number(value) end)

    Enum.flat_map(numbers, fn {location, value} ->
      Enum.filter(adjacency_points(location, value), fn location ->
        Enum.member?(gear_locations, location)
      end)
      |> Enum.map(fn neighbor -> {neighbor, value} end)
    end)
    |> Enum.group_by(&elem(&1, 0))
    |> Enum.filter(fn {_, values} -> length(values) == 2 end)
    |> Enum.map(fn {_, [{_, a}, {_, b}]} -> a * b end)
    |> Enum.sum()
  end
end
