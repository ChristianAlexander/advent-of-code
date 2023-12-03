defmodule AdventOfCode.Day03Test do
  use ExUnit.Case

  import AdventOfCode.Day03

  @shared_input """
  467..114..
  ...*......
  ..35..633.
  ......#...
  617*......
  .....+.58.
  ..592.....
  ......755.
  ...$.*....
  .664.598..
  """

  test "part1" do
    result = part1(@shared_input)

    assert result == 4361
  end

  test "part2" do
    result = part2(@shared_input)

    assert result == 467_835
  end
end
