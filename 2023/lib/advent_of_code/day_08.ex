defmodule AdventOfCode.Day08 do
  defmodule Parser do
    import NimbleParsec

    position = repeat(ascii_string([?A..?Z, ?0..?9], 3))

    entry =
      position
      |> ignore(string(" = ("))
      |> concat(position)
      |> ignore(string(", "))
      |> concat(position)

    defparsecp(
      :parse_entry,
      entry
    )

    def parse(input) do
      [directions, map] = String.split(input, "\n\n")

      directions = String.graphemes(directions)

      map =
        map
        |> String.split("\n", trim: true)
        |> Enum.map(fn line ->
          {:ok, [key, left, right], _, _, _, _} = parse_entry(line)

          {key, {left, right}}
        end)
        |> Enum.into(%{})

      {directions, map}
    end
  end

  defmodule RC do
    def gcd(a, 0), do: abs(a)
    def gcd(a, b), do: gcd(b, rem(a, b))

    def lcm(a, b), do: div(abs(a * b), gcd(a, b))
  end

  def step_one("ZZZ", _directions, _map, _direction_index, count), do: count

  def step_one(current, directions, map, direction_index, count) do
    {left, right} = map[current]

    if Enum.at(directions, rem(direction_index, length(directions))) == "L" do
      step_one(left, directions, map, direction_index + 1, count + 1)
    else
      step_one(right, directions, map, direction_index + 1, count + 1)
    end
  end

  def part1(args) do
    {directions, map} = Parser.parse(args)

    step_one("AAA", directions, map, 0, 0)
  end

  def step_two(<<_a::size(8), _b::size(8), "Z">>, _directions, _map, _direction_index, count),
    do: count

  def step_two(current, directions, map, direction_index, count) do
    {left, right} = map[current]

    if Enum.at(directions, rem(direction_index, length(directions))) == "L" do
      step_two(left, directions, map, direction_index + 1, count + 1)
    else
      step_two(right, directions, map, direction_index + 1, count + 1)
    end
  end

  def part2(args) do
    {directions, map} = Parser.parse(args)

    starting_points = Map.keys(map) |> Enum.filter(&String.ends_with?(&1, "A"))

    Enum.map(starting_points, fn starting_point ->
      step_two(starting_point, directions, map, 0, 0)
    end)
    |> Enum.reduce(&RC.lcm/2)
  end
end
