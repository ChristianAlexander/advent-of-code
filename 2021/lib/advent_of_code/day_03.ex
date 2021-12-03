defmodule AdventOfCode.Day03 do
  def part1(args) do
    inputs =
      args
      |> AdventOfCode.Load.lines()

    counted_values =
      inputs
      |> Enum.map(&String.graphemes/1)
      |> Enum.zip()
      |> Enum.map(fn digits ->
        digits
        |> Tuple.to_list()
        |> Enum.reduce({0, 0}, fn
          "0", {zeros, ones} -> {zeros + 1, ones}
          "1", {zeros, ones} -> {zeros, ones + 1}
        end)
      end)

    gamma =
      counted_values
      |> Enum.map(fn
        {zeros, ones} when zeros > ones ->
          "0"

        _ ->
          "1"
      end)
      |> Enum.join()
      |> String.to_integer(2)

    epsilon =
      counted_values
      |> Enum.map(fn
        {zeros, ones} when zeros < ones ->
          "0"

        _ ->
          "1"
      end)
      |> Enum.join()
      |> String.to_integer(2)

    gamma * epsilon
  end

  def part2(args) do
    inputs =
      args
      |> AdventOfCode.Load.lines()

    oxygen =
      inputs
      |> filter_common_numbers(&get_common_values_per_position/1)
      |> String.to_integer(2)

    co2 =
      inputs
      |> filter_common_numbers(&get_uncommon_values_per_position/1)
      |> String.to_integer(2)

    oxygen * co2
  end

  defp filter_common_numbers(input_numbers, get_values, place \\ 0) do
    common_value = get_values.(input_numbers) |> Enum.at(place)

    filtered_numbers =
      input_numbers
      |> Enum.filter(fn num ->
        value_in_place =
          num
          |> String.graphemes()
          |> Enum.at(place)

        value_in_place == common_value
      end)

    if filtered_numbers |> Enum.count() == 1 do
      hd(filtered_numbers)
    else
      filter_common_numbers(filtered_numbers, get_values, place + 1)
    end
  end

  defp get_common_values_per_position(input_numbers) do
    counted_values =
      input_numbers
      |> Enum.map(&String.graphemes/1)
      |> Enum.zip()
      |> Enum.map(fn digits ->
        digits
        |> Tuple.to_list()
        |> Enum.reduce({0, 0}, fn
          "0", {zeros, ones} -> {zeros + 1, ones}
          "1", {zeros, ones} -> {zeros, ones + 1}
        end)
      end)

    counted_values
    |> Enum.map(fn
      {zeros, ones} when zeros > ones ->
        "0"

      _ ->
        "1"
    end)
  end

  defp get_uncommon_values_per_position(input_numbers) do
    counted_values =
      input_numbers
      |> Enum.map(&String.graphemes/1)
      |> Enum.zip()
      |> Enum.map(fn digits ->
        digits
        |> Tuple.to_list()
        |> Enum.reduce({0, 0}, fn
          "0", {zeros, ones} -> {zeros + 1, ones}
          "1", {zeros, ones} -> {zeros, ones + 1}
        end)
      end)

    counted_values
    |> Enum.map(fn
      {zeros, ones} when zeros > ones ->
        "1"

      _ ->
        "0"
    end)
  end
end
