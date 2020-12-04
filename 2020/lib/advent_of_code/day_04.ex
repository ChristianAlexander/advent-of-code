defmodule AdventOfCode.Day04 do
  @required_fields [
    "byr",
    "iyr",
    "eyr",
    "hgt",
    "hcl",
    "ecl",
    "pid"
  ]

  defp parse_passport(input) do
    String.split(input, "\n\n")
    |> Enum.map(fn passport ->
      passport
      |> String.split(~r/[\n\s]/, trim: true)
      |> Enum.map(fn attribute ->
        attribute
        |> String.split(":")
      end)
      |> Enum.map(fn [a, b] -> {a, b} end)
      |> Map.new()
    end)
  end

  defp numeric_rule(min, max) do
    fn x ->
      {x_int, _} = Integer.parse(x)
      x_int >= min && x_int <= max
    end
  end

  defp set_rule(valid_values) do
    rule_set = MapSet.new(valid_values)
    fn x -> MapSet.member?(rule_set, x) end
  end

  defp regex_rule(regex) do
    fn x -> Regex.match?(regex, x) end
  end

  defp has_required_fields(passport) do
    MapSet.subset?(MapSet.new(@required_fields), MapSet.new(Map.keys(passport)))
  end

  defp height_validator(height_value) do
    with match when not is_nil(match) <-
           Regex.named_captures(~r/^(?<val>\d+)(?<unit>cm|in)$/, height_value),
         val <- Map.get(match, "val"),
         unit <- Map.get(match, "unit") do
      case unit do
        "cm" -> numeric_rule(150, 193).(val)
        "in" -> numeric_rule(59, 76).(val)
        _ -> false
      end
    end
  end

  def part1(args) do
    args
    |> parse_passport
    |> Enum.filter(&has_required_fields/1)
    |> Enum.count()
  end

  def part2(args) do
    validators = %{
      "byr" => numeric_rule(1920, 2002),
      "iyr" => numeric_rule(2010, 2020),
      "eyr" => numeric_rule(2020, 2030),
      "ecl" => set_rule(["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]),
      "hcl" => regex_rule(~r/^#[0-9a-f]{6}$/),
      "pid" => regex_rule(~r/^0*\d{9}$/),
      "hgt" => &height_validator/1
    }

    args
    |> parse_passport
    |> Enum.filter(&has_required_fields/1)
    |> Enum.filter(fn passport ->
      passport
      |> Enum.filter(fn {key, _} -> Map.has_key?(validators, key) end)
      |> Enum.all?(fn {key, value} -> Map.get(validators, key).(value) end)
    end)
    |> Enum.count()
  end
end
