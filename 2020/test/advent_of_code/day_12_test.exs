defmodule AdventOfCode.Day12Test do
  use ExUnit.Case

  import AdventOfCode.Day12

  test "part1" do
    input = """
    F10
    N3
    F7
    R90
    F11
    """

    result = part1(input)

    assert result == 25
  end

  test "part2" do
    input = """
    F10
    N3
    F7
    R90
    F11
    """

    result = part2(input)

    assert result == 286
  end

  test "rotations" do
    assert AdventOfCode.Day12.Part2Ship.rotate({50, 25}, "R", 90) == {25, -50}
    assert AdventOfCode.Day12.Part2Ship.rotate({25, -50}, "R", 90) == {-50, -25}
    assert AdventOfCode.Day12.Part2Ship.rotate({-50, -25}, "R", 90) == {-25, 50}
    assert AdventOfCode.Day12.Part2Ship.rotate({-25, 50}, "R", 90) == {50, 25}
    assert AdventOfCode.Day12.Part2Ship.rotate({50, 25}, "R", 180) == {-50, -25}
  end
end
