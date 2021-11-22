defmodule VM do
  defmodule Parser do
    import NimbleParsec

    instruction =
      choice([
        string("nop") |> replace(:nop),
        string("acc") |> replace(:acc),
        string("jmp") |> replace(:jmp)
      ])

    parameter =
      choice([
        string("-") |> replace(:neg),
        ignore(string("+"))
      ])
      |> integer(min: 0)
      |> reduce(:to_number)

    defp to_number([:neg, number]) do
      number * -1
    end

    defp to_number([number]) do
      number
    end

    defparsecp(
      :parse_inner,
      instruction |> ignore(ascii_char([?\s])) |> concat(parameter) |> eos
    )

    def parse(line) do
      {:ok, result, _, _, _, _} = parse_inner(line)

      result |> List.to_tuple()
    end
  end

  def initialize(instructions) do
    %{
      visited: MapSet.new(),
      instructions: instructions,
      acc: 0,
      ip: 0
    }
  end

  def compute(%{visited: visited, instructions: instructions, acc: acc, ip: ip} = state) do
    if MapSet.member?(visited, ip) do
      {:loop, acc}
    else
      visited = MapSet.put(visited, ip)
      {acc, ip} = execute(acc, ip, Map.get(instructions, ip))

      if ip == Enum.count(instructions) do
        {:halt, acc}
      else
        compute(
          state
          |> Map.put(:acc, acc)
          |> Map.put(:visited, visited)
          |> Map.put(:ip, ip)
        )
      end
    end
  end

  def execute(acc, ip, {:nop, _}) do
    {acc, ip + 1}
  end

  def execute(acc, ip, {:acc, x}) do
    {acc + x, ip + 1}
  end

  def execute(acc, ip, {:jmp, x}) do
    {acc, ip + x}
  end
end
