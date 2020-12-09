defmodule AdventOfCode.Day09 do
  def part1(args, lookback) do
    input =
      String.split(args, "\n", trim: true)
      |> Enum.map(fn x ->
        {v, _} = Integer.parse(x)
        v
      end)

    Enum.at(
      input,
      lookback..(Enum.count(input) - lookback)
      |> Enum.find(fn skip_count ->
        !set_contains_sum_to_value(
          Enum.drop(input, skip_count - lookback)
          |> Enum.take(lookback)
          |> MapSet.new(),
          Enum.at(input, skip_count)
        )
      end)
    )
  end

  def set_contains_sum_to_value(set, value) do
    Enum.any?(
      set,
      fn x ->
        MapSet.member?(
          MapSet.delete(set, value),
          value - x
        )
      end
    )
  end

  def part2(args, lookback) do
    bad_entry = part1(args, lookback)

    input =
      String.split(args, "\n", trim: true)
      |> Enum.map(fn x ->
        {v, _} = Integer.parse(x)
        v
      end)

    bad_entry_index = Enum.find_index(input, &(&1 == bad_entry))

    (bad_entry_index - 1)..0
    |> Task.async_stream(&find_range(input, &1, &1 + 1, bad_entry_index),
      ordered: false
    )
    |> Stream.map(fn {:ok, x} -> x end)
    |> Enum.find(&(&1 != nil))
  end

  @spec find_range(any, any, any, any) :: nil | number
  def find_range(_, _, max, target) when max == target do
    nil
  end

  def find_range(input, min, max, target) do
    range = Enum.map(min..max, &Enum.at(input, &1))
    sum = range |> Enum.sum()

    if sum > Enum.at(input, target) do
      nil
    else
      if sum == Enum.at(input, target) do
        Enum.min(range) + Enum.max(range)
      else
        find_range(input, min, max + 1, target)
      end
    end
  end
end
