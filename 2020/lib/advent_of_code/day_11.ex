defmodule AdventOfCode.Day11 do
  defmodule Part1 do
    def next_value(count, :empty) do
      if count == 0 do
        :occupied
      else
        :empty
      end
    end

    def next_value(count, :occupied) do
      if count >= 4 do
        :empty
      else
        :occupied
      end
    end

    def next_value(_, value), do: value

    def neighbor_occupied_count(_, map, row, column) do
      [
        {row - 1, column - 1},
        {row - 1, column},
        {row - 1, column + 1},
        {row, column - 1},
        {row, column + 1},
        {row + 1, column - 1},
        {row + 1, column},
        {row + 1, column + 1}
      ]
      |> Enum.map(fn cell -> Map.get(map, cell, :nothing) end)
      |> Enum.filter(fn x -> x == :occupied end)
      |> Enum.count()
    end
  end

  defmodule Part2 do
    def next_value(count, :empty) do
      if count == 0 do
        :occupied
      else
        :empty
      end
    end

    def next_value(count, :occupied) do
      if count >= 5 do
        :empty
      else
        :occupied
      end
    end

    def next_value(_, value), do: value

    def neighbor_occupied_count({row_max, column_max}, map, row, column) do
      x =
        [
          get_slope_stream({row_max, column_max}, {row, column}, {-1, -1}),
          get_slope_stream({row_max, column_max}, {row, column}, {-1, 0}),
          get_slope_stream({row_max, column_max}, {row, column}, {-1, 1}),
          get_slope_stream({row_max, column_max}, {row, column}, {0, -1}),
          get_slope_stream({row_max, column_max}, {row, column}, {0, 1}),
          get_slope_stream({row_max, column_max}, {row, column}, {1, -1}),
          get_slope_stream({row_max, column_max}, {row, column}, {1, 0}),
          get_slope_stream({row_max, column_max}, {row, column}, {1, 1})
        ]
        |> Enum.map(fn stream ->
          Map.get(
            map,
            Enum.find(stream, fn x ->
              Map.get(map, x, :floor) != :floor
            end),
            :floor
          )
        end)

      x
      |> Enum.filter(fn x -> x == :occupied end)
      |> Enum.count()
    end

    defp get_slope_stream({row_max, column_max}, origin, {dy, dx}) do
      init = next_in_direction(origin, {dy, dx}, {row_max, column_max})

      if init == nil do
        []
      else
        Stream.unfold(init, fn current ->
          if current == nil do
            nil
          else
            next_coords = next_in_direction(current, {dy, dx}, {row_max, column_max})
            {current, next_coords}
          end
        end)
      end
    end

    defp next_in_direction({row, column}, {dy, dx}, {row_max, column_max}) do
      if row + dy > row_max ||
           row + dy < 0 ||
           column + dx > column_max ||
           column + dx < 0 do
        nil
      else
        {row + dy, column + dx}
      end
    end
  end

  def part1(args) do
    map =
      args
      |> String.split("\n", trim: true)
      |> Stream.map(&String.trim/1)
      |> parse_map()

    map
    |> run_until_steady(&Part1.neighbor_occupied_count/4, &Part1.next_value/2)
    |> occupied_count()
  end

  defp print_map(map) do
    {{row_max, column_max}, _} = Enum.max_by(map, fn {{a, b}, _} -> a + b end)

    0..row_max
    |> Enum.each(fn row ->
      val =
        0..column_max
        |> Enum.map(fn column -> Map.get(map, {row, column}) end)
        |> Enum.map(fn
          :empty -> "L"
          :occupied -> "#"
          :floor -> "."
        end)

      IO.puts("#{val |> Enum.join("")}")
    end)

    IO.puts("\n")
  end

  defp run_until_steady(map, get_neighbor_count, get_next_value) do
    print_map(map)
    next = tick(map, get_neighbor_count, get_next_value)

    if Map.equal?(map, next) do
      next
    else
      run_until_steady(next, get_neighbor_count, get_next_value)
    end
  end

  defp occupied_count(map) do
    map
    |> Map.values()
    |> Enum.filter(fn value -> value == :occupied end)
    |> Enum.count()
  end

  defp tick(map, get_neighbor_count, get_next_value) do
    {{row_max, column_max}, _} = Enum.max_by(map, fn {{a, b}, _} -> a + b end)

    map
    |> Enum.map(fn {{row, column}, value} ->
      {{row, column},
       get_next_value.(get_neighbor_count.({row_max, column_max}, map, row, column), value)}
    end)
    |> Map.new()
  end

  defp parse_map(lines) do
    lines
    |> Enum.with_index()
    |> Enum.map(fn {row, i} ->
      String.codepoints(row)
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {char, j}, acc ->
        case char do
          "L" -> Map.put(acc, {i, j}, :empty)
          "#" -> Map.put(acc, {i, j}, :occupied)
          "." -> Map.put(acc, {i, j}, :floor)
          _ -> acc
        end
      end)
    end)
    |> Enum.reduce(&Map.merge(&1, &2))
  end

  def part2(args) do
    map =
      args
      |> String.split("\n", trim: true)
      |> Stream.map(&String.trim/1)
      |> parse_map()

    map
    |> run_until_steady(&Part2.neighbor_occupied_count/4, &Part2.next_value/2)
    |> occupied_count()
  end
end
