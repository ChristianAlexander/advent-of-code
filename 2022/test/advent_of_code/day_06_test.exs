defmodule AdventOfCode.Day06Test do
  use ExUnit.Case

  import AdventOfCode.Day06

  @shared_input """
  mjqjpqmgbljsphdztnvjfqwrcgsmlb
  """

  test "part1" do
    input = @shared_input
    result = part1(input)

    assert result == 7
  end

  test "part2" do
    input = @shared_input
    result = part2(input)

    assert result == 19
  end
end
