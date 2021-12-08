defmodule AdventOfCode.Day08 do
  def part1(args) do
    args
    |> AdventOfCode.Load.lines()
    |> Enum.flat_map(fn x ->
      x
      |> String.split()
      |> Enum.take(-4)
    end)
    |> Enum.filter(fn x ->
      x = String.graphemes(x)
      Enum.member?([2, 3, 4, 7], length(x))
    end)
    |> Enum.count()
  end

  defp process_display(values, outputs) do
    first_pass =
      values
      |> Enum.map(&match_letter(%{}, &1))
      |> Enum.filter(&Function.identity/1)
      |> Enum.into(Map.new())

    full_mapping =
      values
      |> Enum.map(&match_letter(first_pass, &1))
      |> Enum.into(Map.new())

    outputs
    |> Enum.map(fn output ->
      output = MapSet.new(output)

      Enum.find(full_mapping, fn {_, set} ->
        MapSet.equal?(output, set)
      end)
      |> elem(0)
    end)
    |> Enum.join()
    |> String.to_integer()
  end

  def part2(args) do
    args =
      args
      |> AdventOfCode.Load.lines()
      |> Enum.map(fn x ->
        x = String.split(x)
        examples = Enum.take(x, 10) |> Enum.map(&String.graphemes/1)
        outputs = Enum.take(x, -4) |> Enum.map(&String.graphemes/1)

        {examples, outputs}
      end)

    Enum.map(args, fn {examples, outputs} ->
      process_display(examples, outputs)
    end)
    |> Enum.sum()
  end

  defp match_letter(_, letter) when length(letter) == 2, do: {1, MapSet.new(letter)}
  defp match_letter(_, letter) when length(letter) == 3, do: {7, MapSet.new(letter)}
  defp match_letter(_, letter) when length(letter) == 4, do: {4, MapSet.new(letter)}
  defp match_letter(_, letter) when length(letter) == 7, do: {8, MapSet.new(letter)}

  defp match_letter(%{1 => oneset, 4 => fourset}, letter) when length(letter) == 5 do
    letter = MapSet.new(letter)

    cond do
      MapSet.subset?(oneset, letter) ->
        {3, letter}

      MapSet.intersection(fourset, letter) |> Enum.count() == 3 ->
        {5, letter}

      true ->
        {2, letter}
    end
  end

  defp match_letter(%{1 => oneset, 4 => fourset}, letter) when length(letter) == 6 do
    letter = MapSet.new(letter)

    cond do
      MapSet.subset?(fourset, letter) ->
        {9, letter}

      MapSet.subset?(oneset, letter) ->
        {0, letter}

      true ->
        {6, MapSet.new(letter)}
    end
  end

  defp match_letter(_, _), do: nil
end
