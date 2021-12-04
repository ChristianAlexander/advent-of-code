defmodule AdventOfCode.Day04 do
  defp parse_boards(lines, boards \\ [])

  defp parse_boards([], boards), do: boards

  defp parse_boards(lines, boards) do
    board =
      Enum.take(lines, 5)
      |> Enum.map(&String.trim/1)
      |> Enum.map(&String.split/1)
      |> Enum.map(fn items ->
        items
        |> Enum.map(&String.to_integer/1)
        |> Enum.map(&{&1, false})
      end)

    parse_boards(Enum.drop(lines, 5), [board | boards])
  end

  def part1(args) do
    lines =
      args
      |> AdventOfCode.Load.lines()

    caller_numbers =
      hd(lines)
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)

    boards = parse_boards(tl(lines))

    Enum.reduce_while(caller_numbers, boards, fn caller_number, boards ->
      updated_boards = Enum.map(boards, &mark_board(&1, caller_number))
      bingo_board = Enum.find(updated_boards, &is_bingo/1)

      if bingo_board do
        {:halt, {bingo_board, caller_number}}
      else
        {:cont, updated_boards}
      end
    end)
    |> score_board()
  end

  def part2(args) do
    lines =
      args
      |> AdventOfCode.Load.lines()

    caller_numbers =
      hd(lines)
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)

    boards = parse_boards(tl(lines))

    Enum.reduce_while(caller_numbers, boards, fn
      # Once we are down to one board, run it to completion
      caller_number, [board] ->
        board = mark_board(board, caller_number)

        if is_bingo(board) do
          {:halt, {board, caller_number}}
        else
          {:cont, [board]}
        end

      # Run boards, filtering out winners
      caller_number, boards ->
        updated_boards =
          Enum.map(boards, &mark_board(&1, caller_number))
          |> Enum.reject(&is_bingo/1)

        {:cont, updated_boards}
    end)
    |> score_board()
  end

  defp mark_board(board, called_number) do
    board
    |> Enum.map(fn row ->
      Enum.map(row, fn
        {^called_number, false} ->
          {called_number, true}

        x ->
          x
      end)
    end)
  end

  defp score_board({board, final_call}) do
    unchecked_values =
      board
      |> List.flatten()
      |> Enum.map(fn
        {value, false} -> value
        _ -> 0
      end)
      |> Enum.sum()

    unchecked_values * final_call
  end

  defp is_bingo(board) do
    Enum.any?(
      board,
      fn row -> Enum.all?(row, &elem(&1, 1)) end
    ) or is_vertical_match(board)
  end

  defp is_vertical_match(board, column \\ 0)

  defp is_vertical_match(_, 5), do: false

  defp is_vertical_match(board, column) do
    board
    |> Enum.map(&Enum.at(&1, column))
    |> Enum.all?(&elem(&1, 1)) or
      is_vertical_match(board, column + 1)
  end
end
