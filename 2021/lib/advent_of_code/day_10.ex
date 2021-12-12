defmodule AdventOfCode.Day10 do
  @char_pairs %{
    "(" => ")",
    "[" => "]",
    "{" => "}",
    "<" => ">"
  }

  def part1(args) do
    args
    |> AdventOfCode.Load.lines()
    |> Enum.map(&String.graphemes/1)
    |> Enum.map(&get_corruption_score/1)
    |> Enum.sum()
  end

  defp get_corruption_score(line) do
    line
    |> Enum.reduce_while(
      :queue.new(),
      fn char, expected_chars ->
        if Map.has_key?(@char_pairs, char) do
          {:cont, :queue.in(Map.get(@char_pairs, char), expected_chars)}
        else
          with {:value, ^char} <- :queue.peek_r(expected_chars) do
            {_, expected_chars} = :queue.out_r(expected_chars)

            {:cont, expected_chars}
          else
            _ ->
              {:halt, char}
          end
        end
      end
    )
    |> score_corruption()
  end

  defp score_corruption(")"), do: 3
  defp score_corruption("]"), do: 57
  defp score_corruption("}"), do: 1197
  defp score_corruption(">"), do: 25137
  defp score_corruption(_), do: 0

  defp score_incomplete(")"), do: 1
  defp score_incomplete("]"), do: 2
  defp score_incomplete("}"), do: 3
  defp score_incomplete(">"), do: 4

  defp score_incomplete(chars, acc \\ 0)

  defp score_incomplete([char], acc) do
    acc * 5 + score_incomplete(char)
  end

  defp score_incomplete([char | rest], acc) do
    score_incomplete(
      rest,
      acc * 5 + score_incomplete(char)
    )
  end

  def part2(args) do
    scores =
      args
      |> AdventOfCode.Load.lines()
      |> Enum.map(&String.graphemes/1)
      |> Enum.filter(&(get_corruption_score(&1) == 0))
      |> Enum.map(fn chars ->
        Enum.reduce(chars, :queue.new(), fn char, expected_chars ->
          if Map.has_key?(@char_pairs, char) do
            :queue.in(Map.get(@char_pairs, char), expected_chars)
          else
            {_, queue} = :queue.out_r(expected_chars)
            queue
          end
        end)
        |> :queue.to_list()
        |> Enum.reverse()
        |> score_incomplete()
      end)
      |> Enum.sort()

    Enum.at(scores, div(length(scores), 2))
  end
end
