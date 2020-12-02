defmodule AdventOfCode.Day02 do
  def part1(args) do
    policy_regex = ~r/(?<min>\d+)-(?<max>\d+)\s(?<ch>.):\s(?<password>.*)/

    Stream.map(args, fn entry ->
      Regex.named_captures(policy_regex, entry)
    end)
    |> Stream.filter(&evaluate_policy/1)
    |> Enum.count()
  end

  def evaluate_policy(input) do
    with {min, _} = Integer.parse(Map.fetch!(input, "min")),
         {max, _} = Integer.parse(Map.fetch!(input, "max")) do
      ch = Map.fetch!(input, "ch")
      password = Map.fetch!(input, "password")

      c =
        String.codepoints(password)
        |> Enum.reduce(0, fn x, acc ->
          if x == ch do
            acc + 1
          else
            acc
          end
        end)

      c >= min && c <= max
    end
  end

  def part2(args) do
    policy_regex = ~r/(?<p1>\d+)-(?<p2>\d+)\s(?<ch>.):\s(?<password>.*)/

    Stream.map(args, fn entry ->
      Regex.named_captures(policy_regex, entry)
    end)
    |> Stream.filter(&evaluate_second_policy/1)
    |> Enum.count()
  end

  def evaluate_second_policy(input) do
    with {p1, _} = Integer.parse(Map.fetch!(input, "p1")),
         {p2, _} = Integer.parse(Map.fetch!(input, "p2")) do
      ch = Map.fetch!(input, "ch")
      password = Map.fetch!(input, "password")

      codepoints = String.codepoints(password)

      p1_matches = Enum.fetch!(codepoints, p1 - 1) == ch
      p2_matches = Enum.fetch!(codepoints, p2 - 1) == ch

      (p1_matches || p2_matches) && !(p1_matches && p2_matches)
    end
  end
end
