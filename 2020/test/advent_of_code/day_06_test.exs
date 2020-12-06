defmodule AdventOfCode.Day06Test do
  use ExUnit.Case

  import AdventOfCode.Day06

  test "part1" do
    input = """
    abc

    a
    b
    c

    ab
    ac

    a
    a
    a
    a

    b
    """

    result = part1(input)

    assert result == 11
  end

  test "part2" do
    input = """
    abc

    a
    b
    c

    ab
    ac

    a
    a
    a
    a

    b
    """

    result = part2(input)

    assert result == 6
  end
end
