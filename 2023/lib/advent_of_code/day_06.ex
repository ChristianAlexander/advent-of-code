defmodule AdventOfCode.Day06 do
  def parse_one(line) do
    numeric_regex = ~r/\d+/

    Regex.scan(numeric_regex, line)
    |> List.flatten()
    |> Enum.map(&String.to_integer/1)
  end

  defp calculate_score({time, distance}) do
    d = :math.pow(time, 2) - 4 * -distance
    x1 = (-1 * time + :math.sqrt(d)) / -2
    x2 = (-1 * time - :math.sqrt(d)) / -2

    min_search_time = ceil(min(x1, x2))
    max_search_time = floor(max(x1, x2))

    hold_times = min_search_time..max_search_time

    lowest_hold_time =
      hold_times
      |> Enum.find(fn hold_time ->
        total_distance = (time - hold_time) * hold_time
        total_distance > distance
      end)

    highest_hold_time =
      Enum.reverse(hold_times)
      |> Enum.find(fn hold_time ->
        total_distance = (time - hold_time) * hold_time
        total_distance > distance
      end)

    highest_hold_time - lowest_hold_time + 1
  end

  def part1(args) do
    games =
      args
      |> AdventOfCode.Load.lines()
      |> Enum.map(&parse_one/1)
      |> Enum.zip()

    Enum.map(games, &calculate_score/1)
    |> Enum.reduce(1, &Kernel.*(&1, &2))
  end

  def parse_two(line) do
    numeric_regex = ~r/\d+/

    Regex.scan(numeric_regex, line)
    |> List.flatten()
    |> Enum.join("")
    |> String.to_integer()
  end

  def part2(args) do
    [time, distance] =
      args
      |> AdventOfCode.Load.lines()
      |> Enum.map(&parse_two/1)

    calculate_score({time, distance})
  end
end
