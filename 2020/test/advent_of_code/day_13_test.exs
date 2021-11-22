defmodule AdventOfCode.Day13Test do
  use ExUnit.Case

  import AdventOfCode.Day13

  test "part1" do
    input = """
    939
    7,13,x,x,59,x,31,19
    """

    result = part1(input)

    assert result == 295
  end

  test "part2" do
    input = """
    939
    7,13,x,x,59,x,31,19
    """

    result = part2(input)

    assert result == 1_068_781
  end
end
