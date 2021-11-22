defmodule AdventOfCode.Day13 do
  def part1(args) do
    [leave_time, buses] = String.split(args, "\n", trim: true)

    {leave_time, _} = Integer.parse(leave_time)

    {bus, time} =
      String.split(buses, ",", trim: true)
      |> Enum.filter(&(&1 != "x"))
      |> Enum.map(fn x ->
        {x, _} = Integer.parse(x)

        x
      end)
      |> Enum.map(fn bus_id ->
        Stream.unfold(bus_id, fn current_time ->
          {current_time, current_time + bus_id}
        end)
      end)
      |> Enum.reduce(%{}, fn bus, acc ->
        Map.put(acc, Enum.at(bus, 0), Enum.find(bus, &(&1 >= leave_time)))
      end)
      |> Enum.min_by(fn {_id, time} -> time end)

    (time - leave_time) * bus
  end

  defmodule Modular do
    def egcd(a, b) when is_integer(a) and is_integer(b), do: _egcd(abs(a), abs(b), 0, 1, 1, 0)

    defp _egcd(0, b, s, t, _u, _v), do: {b, s, t}

    defp _egcd(a, b, s, t, u, v) do
      q = div(b, a)
      r = rem(b, a)

      m = s - u * q
      n = t - v * q

      _egcd(r, a, u, v, m, n)
    end

    def inverse(e, et) do
      {g, x, _} = egcd(e, et)
      if g != 1, do: raise("The maths are broken!")
      rem(x + et, et)
    end
  end

  defmodule Chinese do
    def remainder_brute(mods, remainders) do
      max = Enum.reduce(mods, fn x, acc -> x * acc end)

      Enum.zip(mods, remainders)
      |> Enum.map(fn {m, r} -> Enum.take_every(r..max, m) |> MapSet.new() end)
      |> Enum.reduce(fn set, acc ->
        MapSet.intersection(set, acc)
      end)
      |> MapSet.to_list()
      |> List.first()
    end

    def remainder(mods, remainders) do
      prod =
        Enum.reduce(mods, fn x, acc ->
          x * acc
        end)

      IO.inspect({mods, remainders})

      Enum.zip(mods, remainders)
      |> Enum.reduce(0, fn {mod, remainder}, acc ->
        p = div(prod, mod)
        IO.inspect({mod, remainder, p, Modular.inverse(p, mod)})
        acc + remainder * Modular.inverse(p, mod) * p
      end)
    end
  end

  def part2(args) do
    [_, buses] = String.split(args, "\n", trim: true)

    buses =
      String.split(buses, ",", trim: true)
      |> Enum.with_index()
      |> Enum.filter(fn {x, _} -> x != "x" end)
      |> Enum.map(fn {x, time} ->
        {x, _} = Integer.parse(x)

        {x, time}
      end)

    mods = Enum.map(buses, fn {x, _} -> x end)
    remainders = Enum.map(buses, fn {x, time} -> x - time end)

    Chinese.remainder(mods, remainders)
  end

  def bus_matches(time, {frequency, offset}) do
    rem(time + offset, frequency) == 0
  end
end
