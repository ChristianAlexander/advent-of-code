defmodule AdventOfCode.Day01 do
  def part1(args) do
    args
    |> AdventOfCode.Load.lines()
    |> Enum.map(fn line ->
      line
      |> String.graphemes()
      |> Enum.map(fn char ->
        case Integer.parse(to_string(char), 10) do
          {int, _} -> int
          :error -> nil
        end
      end)
      |> Enum.filter(&Function.identity/1)
    end)
    |> Enum.map(fn numbers -> {List.first(numbers), List.last(numbers)} end)
    |> Enum.map(fn {first, last} -> to_string(first) <> to_string(last) end)
    |> Enum.map(&String.to_integer/1)
    |> Enum.sum()
  end

  defmodule Parser do
    import NimbleParsec

    number = ascii_string([?0..?9], 1)

    word_number =
      choice([
        replace(string("one"), "1"),
        replace(string("two"), "2"),
        replace(string("three"), "3"),
        replace(string("four"), "4"),
        replace(string("five"), "5"),
        replace(string("six"), "6"),
        replace(string("seven"), "7"),
        replace(string("eight"), "8"),
        replace(string("nine"), "9")
      ])

    reverse_word_number =
      choice([
        replace(string("eno"), "1"),
        replace(string("owt"), "2"),
        replace(string("eerht"), "3"),
        replace(string("ruof"), "4"),
        replace(string("evif"), "5"),
        replace(string("xis"), "6"),
        replace(string("neves"), "7"),
        replace(string("thgie"), "8"),
        replace(string("enin"), "9")
      ])

    defparsecp(
      :value,
      repeat(choice([number, word_number, ignore(ascii_char([?a..?z, ?A..?Z]))]))
    )

    defparsecp(
      :value_reverse,
      repeat(choice([number, reverse_word_number, ignore(ascii_char([?a..?z, ?A..?Z]))]))
    )

    def parse(line) do
      {:ok, [first_number | _], _, _, _, _} = value(line)
      {:ok, [last_number | _], _, _, _, _} = value_reverse(String.reverse(line))

      {first_number, last_number}
    end
  end

  def part2(args) do
    args
    |> AdventOfCode.Load.lines()
    |> Enum.map(&Parser.parse/1)
    |> Enum.map(fn {first, last} -> first <> last end)
    |> Enum.map(&String.to_integer/1)
    |> Enum.sum()
  end
end
