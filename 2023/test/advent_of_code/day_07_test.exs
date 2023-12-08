defmodule AdventOfCode.Day07Test do
  use ExUnit.Case

  import AdventOfCode.Day07

  @shared_input """
  32T3K 765
  T55J5 684
  KK677 28
  KTJJT 220
  QQQJA 483
  """

  test "part1" do
    result = part1(@shared_input)

    assert result == 6440
  end

  test "part2" do
    result = part2(@shared_input)

    assert result == 5905
  end
end
