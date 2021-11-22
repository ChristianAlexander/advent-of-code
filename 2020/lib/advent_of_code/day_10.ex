defmodule AdventOfCode.Day10 do
  def part1(args) do
    input =
      String.split(args, "\n", trim: true)
      |> Enum.map(fn x ->
        {v, _} = Integer.parse(x)
        v
      end)
      |> Enum.sort_by(fn x -> x end)

    counts =
      1..(Enum.count(input) - 1)
      |> Enum.map(fn i -> Enum.at(input, i) - Enum.at(input, i - 1) end)
      |> Enum.reduce(%{1 => 1, 3 => 1}, fn x, acc ->
        Map.put(acc, x, Map.get(acc, x) + 1)
      end)

    Map.get(counts, 1) * Map.get(counts, 3)
  end

  def possible_next_numbers(current) do
    [current + 1, current + 2, current + 3]
  end

  def add_possibilities(_, []) do
    []
  end

  def add_possibilities(list, [a]) do
    [[a | list]]
  end

  def add_possibilities(list, [a, b]) do
    [[a | list], [b | list]]
  end

  def add_possibilities(list, [a, b, c]) do
    [[a | list], [b | list], [c | list]]
  end

  def expand(possibilities, input_set) do
    all_next_numbers =
      input_set
      |> Enum.map(fn x ->
        {x, possible_next_numbers(x) |> Enum.filter(&MapSet.member?(input_set, &1))}
      end)
      |> Map.new()

    Enum.reduce(possibilities, [], fn x, acc ->
      nexts = Map.get(all_next_numbers, List.first(x))

      add_possibilities(x, nexts) ++ acc
    end)
  end

  def is_valid(list, max) do
    Enum.member?(list, max)
  end

  def profile_2() do
    input = """
    28
    33
    18
    42
    31
    14
    46
    20
    48
    47
    24
    23
    49
    45
    19
    38
    39
    11
    1
    32
    25
    35
    8
    17
    7
    9
    4
    2
    34
    10
    3
    """

    part2(input)
  end

  def part2(args) do
    String.split(args, "\n", trim: true)
    |> Enum.map(fn x ->
      {v, _} = Integer.parse(x)
      v
    end)
    |> Enum.sort_by(fn x -> -x end)
    |> Enum.reduce(%{}, fn x, acc ->
      if map_size(acc) == 0 do
        Map.put(acc, x, 1)
      else
      end
    end)

    # input_set = input |> MapSet.new()

    # solve_2([], [[0]], input_set) |> Enum.count()
    nil
  end

  def solve_2(verified_results, working_list, input_set) do
    expanded = expand(working_list, input_set)

    IO.inspect({Enum.count(Enum.at(expanded, 0)), Enum.count(input_set)})

    max = Enum.max(input_set)

    # once we have used all the numbers, return our result
    if Enum.count(Enum.at(expanded, 0)) == Enum.count(input_set) do
      Enum.concat([verified_results, expanded])
    else
      solve_2(
        verified_results ++
          Enum.filter(expanded, fn [head | _] -> head == max end),
        expanded,
        input_set
      )
    end
  end
end
