defmodule AdventOfCode.Day05 do
  defmodule Parser do
    import NimbleParsec

    seeds = ignore(string("seeds: ")) |> repeat(choice([integer(min: 1), ignore(string(" "))]))

    mapping_header =
      unwrap_and_tag(ascii_string([?a..?z], min: 1), :source)
      |> ignore(string("-to-"))
      |> unwrap_and_tag(ascii_string([?a..?z], min: 1), :destination)
      |> ignore(string(" map:\n"))

    mapping =
      unwrap_and_tag(integer(min: 1), :destination)
      |> ignore(string(" "))
      |> unwrap_and_tag(integer(min: 1), :source_start)
      |> ignore(string(" "))
      |> unwrap_and_tag(integer(min: 1), :source_range)

    defparsecp(
      :seed_parser,
      seeds
    )

    defparsecp(
      :mapping_parser,
      mapping_header |> repeat(choice([tag(mapping, :mapping), ignore(string("\n"))]))
    )

    defp parse_mapping(mapping) do
      {:ok, results, _, _, _, _} = mapping_parser(mapping)

      source = Keyword.get(results, :source)
      destination = Keyword.get(results, :destination)

      mappings =
        Keyword.get_values(results, :mapping)
        |> Enum.sort_by(fn [_dest, start, _range] -> start end)
        |> Enum.map(fn [
                         destination: destination,
                         source_start: source_start,
                         source_range: source_range
                       ] ->
          {source_start..(source_start + source_range - 1), destination}
        end)

      {source, {destination, mappings}}
    end

    def parse([seed_data | mappings]) do
      {:ok, seeds, _, _, _, _} = seed_parser(seed_data)

      seeds = Enum.map(seeds, fn seed -> {"seed", seed} end)

      mappings =
        Enum.map(mappings, &parse_mapping/1)
        |> Enum.into(%{})

      {seeds, mappings}
    end
  end

  defp get_location({"location", value}, _mappings), do: value

  defp get_location({source, value}, mappings) do
    {destination, dest_mappings} = Map.get(mappings, source)

    next_value =
      Enum.find_value(dest_mappings, value, fn {start.._end = range, destination} ->
        if value in range do
          destination + (value - start)
        else
          nil
        end
      end)

    get_location({destination, next_value}, mappings)
  end

  def part1(args) do
    {seeds, mappings} =
      args
      |> String.split("\n\n", trim: true)
      |> Parser.parse()

    Enum.map(seeds, &get_location(&1, mappings))
    |> Enum.min()
  end

  def map_ranges(x..x, _, accumulated_ranges) do
    accumulated_ranges
  end

  def map_ranges(remaining_range, [], accumulated_ranges) do
    [remaining_range | accumulated_ranges]
  end

  def map_ranges(x..y, [{_a..b, _dest} | rest], acc) when x >= b, do: map_ranges(x..y, rest, acc)

  def map_ranges(x..y, [{a.._b, _dest} | _] = possible_ranges, acc) when x < a do
    map_ranges(min(a, y)..y, possible_ranges, [x..(a - 1) | acc])
  end


  def map_ranges(x..y, [{a..b, dest} | _] = possible_ranges, acc) when x == a do
    dest_mapped_range = dest..(dest + (min(b, y) - a))


    map_ranges(min(b + 1, y)..y, possible_ranges, [dest_mapped_range | acc])
  end

  def map_ranges(x..y, [{a..b, dest} | _ ] = possible_ranges, acc) when x > a do
    dest_mapped_range = (x - a) + dest..(dest + (min(b, y) - a))

    map_ranges(min(b + 1, y)..y, possible_ranges, [dest_mapped_range | acc])
  end

  defp map_source_to_destinations({"location", ranges}, _mappings), do: ranges

  defp map_source_to_destinations({source, ranges}, mappings) do
    {destination, dest_mappings} = Map.get(mappings, source)

    mapped_ranges = Enum.flat_map(ranges, fn range ->
      candidate_mappings = Enum.filter(dest_mappings, fn {source_range, _} -> not Range.disjoint?(source_range, range) end)
      map_ranges(range, candidate_mappings, []) end)

    map_source_to_destinations({destination, mapped_ranges}, mappings)
  end

  def part2(args) do
    {seeds, mappings} =
      args
      |> String.split("\n\n", trim: true)
      |> Parser.parse()

      seed_ranges =
    Enum.chunk_every(seeds, 2)
    |> Enum.map(fn [{_, first}, {_, length}] -> first..(first + length - 1) end)

    map_source_to_destinations({"seed", seed_ranges}, mappings)
    |> Enum.map(&(&1.first))
    |> Enum.min()
  end
end
