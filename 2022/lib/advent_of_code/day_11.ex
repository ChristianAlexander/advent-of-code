defmodule AdventOfCode.Day11 do
  def part1(args) do
    monkeys =
      AdventOfCode.Load.lines(args)
      |> Enum.chunk_every(6)
      |> Enum.map(&parse_monkey/1)
      |> Map.new()

    [max, second] =
      Enum.reduce(1..20, monkeys, fn _, monkeys -> run_round(monkeys) end)
      |> Enum.map(fn {_k, v} -> v.inspection_count end)
      |> Enum.sort(:desc)
      |> Enum.take(2)

    max * second
  end

  defp parse_operation("new = old * old"), do: fn old -> old * old end

  defp parse_operation("new = old * " <> rest) do
    rest = String.to_integer(rest)

    fn old -> old * rest end
  end

  defp parse_operation("new = old + " <> rest) do
    rest = String.to_integer(rest)

    fn old -> old + rest end
  end

  defp parse_monkey(lines) do
    "Monkey " <> monkey_id = Enum.at(lines, 0)
    monkey_id = String.trim(monkey_id, ":") |> String.to_integer()
    "Starting items: " <> items = Enum.at(lines, 1) |> String.trim()

    "Operation: " <> operation_expression = Enum.at(lines, 2) |> String.trim()
    operation = parse_operation(operation_expression)

    "Test: divisible by " <> test = Enum.at(lines, 3) |> String.trim()
    test = String.to_integer(test)

    "If true: throw to monkey " <> true_target_monkey = Enum.at(lines, 4) |> String.trim()
    true_target_monkey = String.to_integer(true_target_monkey)

    "If false: throw to monkey " <> false_target_monkey = Enum.at(lines, 5) |> String.trim()
    false_target_monkey = String.to_integer(false_target_monkey)

    items =
      String.split(items, ", ")
      |> Enum.map(&String.to_integer/1)

    {monkey_id,
     %{
       id: monkey_id,
       items: items,
       test: test,
       operation: operation,
       true_target_monkey: true_target_monkey,
       false_target_monkey: false_target_monkey,
       inspection_count: 0
     }}
  end

  defp run_round(monkeys) do
    max_monkey_id = map_size(monkeys) - 1

    Enum.reduce(0..max_monkey_id, monkeys, fn id, monkeys ->
      monkey = Map.get(monkeys, id)
      monkey_throw(monkey, monkeys)
    end)
  end

  defp monkey_throw(%{items: []}, monkeys), do: monkeys

  defp monkey_throw(%{items: [item | rest]} = monkey, monkeys) do
    item = monkey.operation.(item)
    item = div(item, 3)

    updated_monkey = %{
      monkey
      | items: rest,
        inspection_count: monkey.inspection_count + 1
    }

    target_monkey_id =
      if rem(item, monkey.test) == 0,
        do: monkey.true_target_monkey,
        else: monkey.false_target_monkey

    target_monkey = Map.get(monkeys, target_monkey_id)

    target_monkey = Map.update!(target_monkey, :items, &Enum.concat(&1, [item]))

    monkey_throw(
      updated_monkey,
      monkeys
      |> Map.put(monkey.id, updated_monkey)
      |> Map.put(target_monkey_id, target_monkey)
    )
  end

  def part2(args) do
    monkeys =
      AdventOfCode.Load.lines(args)
      |> Enum.chunk_every(6)
      |> Enum.map(&parse_monkey/1)
      |> Map.new()

    mod =
      Enum.map(monkeys, fn {_k, v} -> v.test end)
      |> MapSet.new()
      |> Enum.reduce(fn a, b -> a * b end)

    [max, second] =
      Enum.reduce(1..10000, monkeys, fn _, monkeys ->
        run_round_b(monkeys, mod)
      end)
      |> Enum.map(fn {_k, v} -> v.inspection_count end)
      |> Enum.sort(:desc)
      |> Enum.take(2)

    max * second
  end

  defp run_round_b(monkeys, mod) do
    max_monkey_id = map_size(monkeys) - 1

    Enum.reduce(0..max_monkey_id, monkeys, fn id, monkeys ->
      monkey = Map.get(monkeys, id)
      monkey_throw_b(monkey, monkeys, mod)
    end)
  end

  defp monkey_throw_b(%{items: []}, monkeys, _mod), do: monkeys

  defp monkey_throw_b(%{items: [item | rest]} = monkey, monkeys, mod) do
    item = monkey.operation.(item)
    item = rem(item, mod)

    updated_monkey = %{
      monkey
      | items: rest,
        inspection_count: monkey.inspection_count + 1
    }

    target_monkey_id =
      if rem(item, monkey.test) == 0,
        do: monkey.true_target_monkey,
        else: monkey.false_target_monkey

    target_monkey = Map.get(monkeys, target_monkey_id)

    target_monkey = Map.update!(target_monkey, :items, &Enum.concat(&1, [item]))

    monkey_throw_b(
      updated_monkey,
      monkeys
      |> Map.put(monkey.id, updated_monkey)
      |> Map.put(target_monkey_id, target_monkey),
      mod
    )
  end
end
