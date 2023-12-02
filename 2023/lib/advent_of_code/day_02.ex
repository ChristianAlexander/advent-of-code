defmodule AdventOfCode.Day02 do
  defmodule Game do
    defstruct [:id, :rounds]
  end

  defmodule Parser do
    import NimbleParsec

    game_id = ignore(string("Game ")) |> integer(min: 1) |> ignore(string(": "))

    color =
      choice([
        replace(string("red"), :red),
        replace(string("green"), :green),
        replace(string("blue"), :blue)
      ])

    cube = integer(min: 1) |> ignore(string(" ")) |> concat(color) |> reduce(:transform_cube)

    defparsecp(
      :game_id,
      game_id
    )

    defparsecp(:cube_list, repeat(cube |> ignore(optional(string(", ")))))

    defp transform_cube([count, color]) do
      {color, count}
    end

    defp parse_round(round_string) do
      {:ok, round, _, _, _, _} = cube_list(round_string)

      round
    end

    def parse(line) do
      {:ok, [id], rounds, _, _, _} = game_id(line)

      rounds =
        rounds
        |> String.split("; ")
        |> Enum.map(&parse_round/1)

      %Game{id: id, rounds: rounds}
    end
  end

  def part1(args) do
    lines = AdventOfCode.Load.lines(args)

    lines
    |> Enum.map(&Parser.parse/1)
    |> Enum.filter(fn %{rounds: rounds} ->
      rounds
      |> List.flatten()
      |> Enum.all?(fn {color, count} ->
        cond do
          color == :red && count > 12 -> false
          color == :green && count > 13 -> false
          color == :blue && count > 14 -> false
          true -> true
        end
      end)
    end)
    |> Enum.map(fn %{id: id} -> id end)
    |> Enum.sum()
  end

  def part2(args) do
    lines = AdventOfCode.Load.lines(args)

    lines
    |> Enum.map(&Parser.parse/1)
    |> Enum.map(fn %{rounds: rounds} ->
      rounds
      |> List.flatten()
      |> Enum.reduce(%{}, fn {color, count}, acc ->
        Map.update(acc, color, count, &max(count, &1))
      end)
      |> Enum.reduce(1, fn {_color, count}, acc ->
        acc * count
      end)
    end)
    |> Enum.sum()
  end
end
