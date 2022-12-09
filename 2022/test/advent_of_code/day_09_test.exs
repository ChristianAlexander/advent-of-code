defmodule AdventOfCode.Day09Test do
  use ExUnit.Case

  import AdventOfCode.Day09

  test "part1" do
    input = """
    R 4
    U 4
    L 3
    D 1
    R 4
    D 1
    L 5
    R 2
    """

    result = part1(input)

    assert result == 13
  end

  test "touching?" do
    assert touching?({2, 2}, {2, 2})
  end

  test "follow" do
    assert follow({3, 1}, {1, 1}) == {2, 1}
    assert follow({3, 2}, {1, 1}) == {2, 2}
  end

  test "transform" do
    assert transform({0, 0}, ["R", 4]) == [{1, 0}, {2, 0}, {3, 0}, {4, 0}]
  end

  test "part2" do
    input = """
    R 5
    U 8
    L 8
    D 3
    R 17
    D 10
    L 25
    U 20
    """

    result = part2(input)

    assert result == 36
  end
end
