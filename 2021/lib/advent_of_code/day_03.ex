defmodule AdventOfCode.Day03 do
  def part1(args) do
    inputs =
      args
      |> AdventOfCode.Load.lines()
      |> Enum.map(&String.graphemes/1)

    gamma =
      inputs
      |> most_common_per_position()
      |> Enum.join()
      |> String.to_integer(2)

    epsilon =
      inputs
      |> least_common_per_position()
      |> Enum.join()
      |> String.to_integer(2)

    gamma * epsilon
  end

  def part2(args) do
    inputs =
      args
      |> AdventOfCode.Load.lines()
      |> Enum.map(&String.graphemes/1)

    oxygen =
      inputs
      |> reduce_masked_numbers(&most_common_per_position/1)

    co2 =
      inputs
      |> reduce_masked_numbers(&least_common_per_position/1)

    oxygen * co2
  end

  defp reduce_masked_numbers(candidates, get_mask, position \\ 0)

  defp reduce_masked_numbers([candidate], _, _) do
    candidate
    |> Enum.join()
    |> String.to_integer(2)
  end

  defp reduce_masked_numbers(candidates, get_mask, position) do
    mask_at_position =
      get_mask.(candidates)
      |> Enum.at(position)

    filtered_candidates =
      candidates
      |> Enum.filter(&(Enum.at(&1, position) == mask_at_position))

    reduce_masked_numbers(filtered_candidates, get_mask, position + 1)
  end

  defp count_values_in_positions(input_numbers) do
    input_numbers
    |> Enum.zip()
    |> Enum.map(fn digits ->
      digits
      |> Tuple.to_list()
      |> Enum.reduce({0, 0}, fn
        "0", {zeros, ones} -> {zeros + 1, ones}
        "1", {zeros, ones} -> {zeros, ones + 1}
      end)
    end)
  end

  defp least_common_per_position(input_numbers) do
    input_numbers
    |> count_values_in_positions
    |> Enum.map(fn
      {zeros, ones} when zeros > ones ->
        "0"

      _ ->
        "1"
    end)
  end

  defp most_common_per_position(input_numbers) do
    input_numbers
    |> count_values_in_positions
    |> Enum.map(fn
      {zeros, ones} when zeros > ones ->
        "1"

      _ ->
        "0"
    end)
  end
end
