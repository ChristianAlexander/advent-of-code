defmodule AdventOfCode.Day02Test do
  use ExUnit.Case

  import AdventOfCode.Day02

  @shared_input """
  A Y
  B X
  C Z
  """

  test "part1" do
    result = part1(@shared_input)

    assert result == 15
  end

  test "part2" do
    result = part2(@shared_input)

    assert result == 12
  end
end
