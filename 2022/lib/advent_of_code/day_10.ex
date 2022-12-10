defmodule AdventOfCode.Day10 do
  def part1(args) do
    target_cycles = [20, 60, 100, 140, 180, 220]

    cycle_values =
      AdventOfCode.Load.lines(args)
      |> Enum.map(&String.split/1)
      |> Enum.reduce({1, 1, []}, fn
        ["noop"], {cycle, x, history} ->
          {cycle + 1, x, history}

        ["addx", amount], {cycle, x, history} ->
          amount = String.to_integer(amount)
          {cycle + 2, x + amount, [{cycle + 2, x + amount} | history]}
      end)
      |> elem(2)
      |> Enum.reverse()

    target_cycles
    |> Enum.map(fn target_cycle ->
      {_, value} =
        Enum.take_while(cycle_values, fn {cycle, _} -> cycle <= target_cycle end)
        |> List.last()

      value * target_cycle
    end)
    |> Enum.sum()
  end

  def part2(args) do
    cycle_values =
      AdventOfCode.Load.lines(args)
      |> Enum.map(&String.split/1)
      |> Enum.reduce({1, 1, [1]}, fn
        ["noop"], {cycle, x, history} ->
          {cycle + 1, x, [x | history]}

        ["addx", amount], {cycle, x, history} ->
          amount = String.to_integer(amount)
          {cycle + 2, x + amount, Enum.concat([x + amount, x], history)}
      end)
      |> elem(2)
      |> Enum.reverse()
      |> Enum.take(240)

    crt_values =
      Enum.zip(0..239, cycle_values)
      |> Enum.map(fn {cycle, value} ->
        if rem(cycle, 40) in (value - 1)..(value + 1), do: "#", else: "."
      end)

    0..5
    |> Enum.map(fn row ->
      Enum.drop(crt_values, row * 40) |> Enum.take(40) |> Enum.join()
    end)
  end
end
