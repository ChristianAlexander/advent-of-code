defmodule AdventOfCode.Day01Test do
  use ExUnit.Case

  import AdventOfCode.Day01

  @shared_input """
  1000
  2000
  3000

  4000

  5000
  6000

  7000
  8000
  9000

  10000
  """

  test "part1" do
    result = part1(@shared_input)

    assert result == 24000
  end

  test "part2" do
    result = part2(@shared_input)

    assert result == 45000
  end
end
