defmodule AdventOfCode.Day02 do
  defmodule Parser do
    import NimbleParsec

    range = integer(min: 1) |> ignore(string("-")) |> integer(min: 1)

    password = repeat(ascii_char([?a..?z]))

    defparsec(
      :policy,
      range
      |> ignore(string(" "))
      |> ascii_char([?a..?z])
      |> ignore(string(": "))
      |> concat(password)
    )
  end

  def part1(args) do
    Stream.map(args, fn entry ->
      {:ok, [min, max, ch | password], _, _, _, _} = Parser.policy(entry)

      %{min: min, max: max, ch: ch, password: password}
    end)
    |> Stream.filter(&evaluate_policy/1)
    |> Enum.count()
  end

  defp evaluate_policy(%{min: min, max: max, ch: ch, password: password}) do
    c = Enum.count(password, &(&1 == ch))

    c >= min && c <= max
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
