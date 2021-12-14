defmodule AdventOfCode.Day14 do
  def part1(args) do
    {pairs, substitutions, final_template_char} = parse(args)

    1..10
    |> Enum.reduce(pairs, fn _, pairs ->
      expand(pairs, substitutions)
    end)
    |> get_character_frequencies(final_template_char)
    |> calculate_score()
  end

  def part2(args) do
    {pairs, substitutions, final_template_char} = parse(args)

    1..40
    |> Enum.reduce(pairs, fn _, pairs ->
      expand(pairs, substitutions)
    end)
    |> get_character_frequencies(final_template_char)
    |> calculate_score()
  end

  defp parse(args) do
    [template | substitutions] = args |> AdventOfCode.Load.lines()

    template = String.graphemes(template)

    substitutions =
      substitutions
      |> Enum.map(fn substitution ->
        [pair, result] = String.split(substitution, " -> ")
        [a, b] = String.graphemes(pair)

        {{a, b}, result}
      end)
      |> Enum.into(Map.new())

    pairs =
      template
      |> Enum.zip(Enum.drop(template, 1))
      |> Enum.reduce(Map.new(), fn pair, acc ->
        Map.update(acc, pair, 1, &(&1 + 1))
      end)

    {pairs, substitutions, List.last(template)}
  end

  defp expand(template_pair_counts, substitutions) do
    template_pair_counts
    |> Enum.reduce(Map.new(), fn {{a, b} = pair, count}, acc ->
      sub = Map.get(substitutions, pair)

      Map.update(acc, {a, sub}, count, &(&1 + count))
      |> Map.update({sub, b}, count, &(&1 + count))
    end)
  end

  defp get_character_frequencies(pairs, final_template_char) do
    pairs
    |> Enum.map(fn {{a, _}, count} -> {a, count} end)
    |> Enum.reduce(Map.new(), fn
      {x, count}, acc -> Map.update(acc, x, count, &(&1 + count))
    end)
    |> Map.update(final_template_char, 1, &(&1 + 1))
  end

  defp calculate_score(character_frequencies) do
    Enum.max(character_frequencies |> Map.values()) -
      Enum.min(character_frequencies |> Map.values())
  end
end
