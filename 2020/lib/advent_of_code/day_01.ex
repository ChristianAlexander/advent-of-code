defmodule AdventOfCode.Day01 do
  def part1(args) do
    res =
      Stream.flat_map(args, fn x ->
        Stream.map(args, fn y ->
          if x + y == 2020 do
            {x, y}
          end
        end)
      end)
      |> Stream.filter(&(!is_nil(&1)))
      |> Enum.take(1)

    case res do
      [{a, b}] -> a * b
      _ -> nil
    end
  end

  def part2(args) do
    x_y =
      Enum.flat_map(args, fn x ->
        Stream.map(args, fn y ->
          {x, y}
        end)
        |> Stream.filter(fn {x, y} -> x + y <= 2020 end)
      end)

    res =
      Stream.flat_map(x_y, fn {x, y} ->
        Stream.map(args, fn z ->
          if x + y + z == 2020 do
            {x, y, z}
          end
        end)
      end)
      |> Stream.filter(&(!is_nil(&1)))
      |> Enum.take(1)

    case res do
      [{a, b, c}] -> a * b * c
      _ -> nil
    end
  end
end
