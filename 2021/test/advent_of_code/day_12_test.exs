defmodule AdventOfCode.Day12Test do
  use ExUnit.Case

  import AdventOfCode.Day12

  @shared_input """
  start-A
  start-b
  A-c
  A-b
  b-d
  A-end
  b-end
  """

  test "part1" do
    input = @shared_input
    result = part1(input)

    assert result == 10
  end

  test "part2" do
    input = @shared_input
    result = part2(input)

    assert result == 36
  end
end
