defmodule Main do
  def contains_duplicate_digit(value) do
    value
    |> MapSet.new()
    |> Enum.count() < Enum.count(value)
  end

  def contains_an_exactly_double_digit(value) do
    value
    |> Enum.reduce(%{}, fn x, acc ->
      Map.update(acc, x, 1, fn count -> count + 1 end)
    end)
    |> Map.values()
    |> Enum.any?(&(&1 == 2))
  end

  def contains_ascending_digits(value) do
    [head | rest] = value

    rest
    |> Enum.reduce_while(head, fn curr, prev ->
      if(curr < prev) do
        {:halt, false}
      else
        {:cont, curr}
      end
    end) != false
  end

  def main do
    284_639..748_759
    |> Stream.map(&Integer.digits/1)
    |> Stream.filter(&contains_ascending_digits/1)
    # |> Stream.filter(&contains_duplicate_digit/1)
    |> Stream.filter(&contains_an_exactly_double_digit/1)
    |> Enum.count()
    |> IO.puts()
  end
end

Main.main()
