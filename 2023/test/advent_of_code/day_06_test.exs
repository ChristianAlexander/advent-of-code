defmodule AdventOfCode.Day06Test do
  use ExUnit.Case

  import AdventOfCode.Day06

  @shared_input """
  Time:      7  15   30
  Distance:  9  40  200
  """

  test "part1" do
    result = part1(@shared_input)

    assert result == 288
  end

  test "part2" do
    result = part2(@shared_input)

    assert result == 71503
  end
end
