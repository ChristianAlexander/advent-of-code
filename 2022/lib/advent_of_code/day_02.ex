defmodule AdventOfCode.Day02 do
  defp score({them, me}) do
    result = move_score(me)

    outcome = outcome(them, me)

    result +
      case outcome do
        :win -> 6
        :tie -> 3
        _ -> 0
      end
  end

  def move_score(:rock), do: 1
  def move_score(:paper), do: 2
  def move_score(:scissors), do: 3

  def outcome(a, a), do: :tie
  def outcome(:scissors, :rock), do: :win
  def outcome(:rock, :paper), do: :win
  def outcome(:paper, :scissors), do: :win
  def outcome(_, _), do: :lose

  def map_move(move) when move in ["A", "X"], do: :rock
  def map_move(move) when move in ["B", "Y"], do: :paper
  def map_move(move) when move in ["C", "Z"], do: :scissors

  def parse_game_one(input) do
    [them, me] = String.split(input)

    {map_move(them), map_move(me)}
  end

  def part1(args) do
    args
    |> AdventOfCode.Load.lines()
    |> Enum.map(&parse_game_one/1)
    |> Enum.map(&score/1)
    |> Enum.sum()
  end

  def parse_game_two(input) do
    [them, outcome] = String.split(input)

    {map_move(them), expected_outcome(outcome)}
  end

  def expected_outcome("X"), do: :lose
  def expected_outcome("Y"), do: :tie
  def expected_outcome("Z"), do: :win

  def move_for_outcome(move, :tie), do: move

  def move_for_outcome(move, :lose) do
    case move do
      :rock -> :scissors
      :paper -> :rock
      :scissors -> :paper
    end
  end

  def move_for_outcome(move, :win) do
    case move do
      :scissors -> :rock
      :rock -> :paper
      :paper -> :scissors
    end
  end

  def part2(args) do
    args
    |> AdventOfCode.Load.lines()
    |> Enum.map(&parse_game_two/1)
    |> Enum.map(fn {move, outcome} -> {move, move_for_outcome(move, outcome)} end)
    |> Enum.map(&score/1)
    |> Enum.sum()
  end
end
