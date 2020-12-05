defmodule AdventOfCode.Day05 do
  def part1(passes) do
    Enum.map(passes, fn pass ->
      String.codepoints(pass)
      |> Enum.reduce(init_seat_bounds(), fn direction, acc ->
        filter_seat_bounds(acc, direction)
      end)
      |> get_seat_id()
    end)
    |> Enum.max()
  end

  def init_seat_bounds do
    %{
      front: 0,
      back: 127,
      left: 0,
      right: 7
    }
  end

  def filter_seat_bounds(%{front: front, back: back} = bounds, "F") do
    distance = div(back - front + 1, 2)
    Map.put(bounds, :back, back - distance)
  end

  def filter_seat_bounds(%{front: front, back: back} = bounds, "B") do
    distance = div(back - front + 1, 2)
    Map.put(bounds, :front, front + distance)
  end

  def filter_seat_bounds(%{left: left, right: right} = bounds, "L") do
    distance = div(right - left + 1, 2)
    Map.put(bounds, :right, right - distance)
  end

  def filter_seat_bounds(%{left: left, right: right} = bounds, "R") do
    distance = div(right - left + 1, 2)
    Map.put(bounds, :left, left + distance)
  end

  def filter_seat_bounds(bounds, _), do: bounds

  def get_seat_id(%{front: row, left: column}) do
    row * 8 + column
  end

  def part2(passes) do
    populated_seats =
      Enum.map(passes, fn pass ->
        String.codepoints(pass)
        |> Enum.reduce(init_seat_bounds(), fn direction, acc ->
          filter_seat_bounds(acc, direction)
        end)
      end)
      |> Enum.reduce(%{}, fn %{front: row, left: column}, acc ->
        Map.put(acc, row, [column | Map.get(acc, row, [])])
      end)

    row =
      Enum.drop_while(0..126, fn row ->
        length(Map.get(populated_seats, row, [])) < 8
      end)
      |> Enum.drop_while(fn row ->
        length(Map.get(populated_seats, row, [])) == 8
      end)
      |> List.first()

    column =
      Enum.find(0..7, fn col ->
        !Enum.member?(Map.get(populated_seats, row), col)
      end)

    row * 8 + column
  end
end
