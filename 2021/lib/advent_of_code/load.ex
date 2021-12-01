defmodule AdventOfCode.Load do
  def numeric_lines(input_string) do
    input_string
    |> lines
    |> Stream.map(&Integer.parse/1)
    |> Stream.filter(&(!is_atom(&1)))
    |> Stream.map(&elem(&1, 0))
  end

  def lines(input_string) do
    input_string
    |> String.split("\n", trim: true)
  end
end
