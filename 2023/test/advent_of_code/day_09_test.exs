defmodule AdventOfCode.Day09Test do
  use ExUnit.Case

  import AdventOfCode.Day09

  @shared_input """
  0 3 6 9 12 15
  1 3 6 10 15 21
  10 13 16 21 30 45
  """

  test "part1" do
    result = part1(@shared_input)

    assert result == 114
  end

  test "part2" do
    result = part2(@shared_input)

    assert result == 2
  end
end
