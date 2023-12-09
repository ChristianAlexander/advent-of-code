defmodule AdventOfCode.Day09 do
  defp read_input(args) do
    args
    |> AdventOfCode.Load.lines()
    |> Enum.map(fn line ->
      line |> String.split(" ", trim: true) |> Enum.map(&String.to_integer/1)
    end)
  end

  defp form_triangle(elements), do: form_triangle(elements, [elements])

  defp form_triangle(current_elements, acc) do
    if(Enum.all?(current_elements, &(&1 == 0))) do
      acc
    else
      next_elements =
        current_elements
        |> Enum.zip(Enum.drop(current_elements, 1))
        |> Enum.map(fn {x, y} -> y - x end)

      form_triangle(next_elements, [next_elements | acc])
    end
  end

  defp predict_next_element(triangle) do
    triangle
    |> Enum.reduce(0, fn row, acc ->
      List.last(row) + acc
    end)
  end

  defp predict_previous_element(triangle) do
    triangle
    |> Enum.reduce(0, fn [first_element | _], acc ->
      first_element - acc
    end)
  end

  def part1(args) do
    args
    |> read_input()
    |> Enum.map(&form_triangle/1)
    |> Enum.map(&predict_next_element/1)
    |> Enum.sum()
  end

  def part2(args) do
    args
    |> read_input()
    |> Enum.map(&form_triangle/1)
    |> Enum.map(&predict_previous_element/1)
    |> Enum.sum()
  end
end
