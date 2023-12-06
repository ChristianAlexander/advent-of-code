defmodule AdventOfCode.Day05Test do
  use ExUnit.Case

  import AdventOfCode.Day05

  @shared_input """
  seeds: 79 14 55 13

  seed-to-soil map:
  50 98 2
  52 50 48

  soil-to-fertilizer map:
  0 15 37
  37 52 2
  39 0 15

  fertilizer-to-water map:
  49 53 8
  0 11 42
  42 0 7
  57 7 4

  water-to-light map:
  88 18 7
  18 25 70

  light-to-temperature map:
  45 77 23
  81 45 19
  68 64 13

  temperature-to-humidity map:
  0 69 1
  1 0 69

  humidity-to-location map:
  60 56 37
  56 93 4
  """

  test "part1" do
    result = part1(@shared_input)

    assert result == 35
  end

  test "map_ranges 0..10" do
    result =
      map_ranges(0..10, [{2..4, 10}, {7..8, 20}], [])
      |> Enum.sort()

    assert result == [0..1, 10..12, 5..6, 20..21, 9..10] |> Enum.sort()
  end

  test "map_ranges mid" do
    result =
      map_ranges(3..15, [{2..4, 10}, {7..8, 20}], [])
      |> Enum.sort()

    assert result == [11..12, 5..6, 20..21, 9..15] |> Enum.sort()
  end

  test "part2" do
    result = part2(@shared_input)

    assert result == 46
  end
end
