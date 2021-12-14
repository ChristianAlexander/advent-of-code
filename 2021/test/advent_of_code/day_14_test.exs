defmodule AdventOfCode.Day14Test do
  use ExUnit.Case

  import AdventOfCode.Day14

  @shared_input """
  NNCB

  CH -> B
  HH -> N
  CB -> H
  NH -> C
  HB -> C
  HC -> B
  HN -> C
  NN -> C
  BH -> H
  NC -> B
  NB -> B
  BN -> B
  BB -> N
  BC -> B
  CC -> N
  CN -> C
  """

  test "part1" do
    input = @shared_input
    result = part1(input)

    assert result == 1588
  end

  test "part2" do
    input = @shared_input
    result = part2(input)

    assert result == 2_188_189_693_529
  end
end
