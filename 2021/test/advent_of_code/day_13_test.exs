defmodule AdventOfCode.Day13Test do
  use ExUnit.Case

  import AdventOfCode.Day13

  @shared_input """
  6,10
  0,14
  9,10
  0,3
  10,4
  4,11
  6,0
  6,12
  4,1
  0,13
  10,12
  3,4
  3,0
  8,4
  1,10
  2,14
  8,10
  9,0

  fold along y=7
  fold along x=5
  """

  test "part1" do
    input = @shared_input
    result = part1(input)

    assert result == 17
  end

  # Short of OCR, part 2 doesn't really have any tests.
  @tag :skip
  test "part2" do
    input = nil
    result = part2(input)

    assert result
  end
end
