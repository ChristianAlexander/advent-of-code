defmodule AdventOfCode.Day12 do
  defmodule Part1Ship do
    defstruct direction: :east, location: {0, 0}

    @direction_transforms %{
      east: {0, 1},
      south: {1, 0},
      west: {0, -1},
      north: {-1, 0}
    }

    @directions [:east, :south, :west, :north]

    def handle_instruction(%Part1Ship{direction: direction, location: location} = ship, %{
          instruction: "F",
          distance: distance
        }) do
      %{ship | location: move_in_direction(location, distance, direction)}
    end

    def handle_instruction(%Part1Ship{location: location} = ship, %{
          instruction: "N",
          distance: distance
        }) do
      %{ship | location: move_in_direction(location, distance, :north)}
    end

    def handle_instruction(%Part1Ship{location: location} = ship, %{
          instruction: "E",
          distance: distance
        }) do
      %{ship | location: move_in_direction(location, distance, :east)}
    end

    def handle_instruction(%Part1Ship{location: location} = ship, %{
          instruction: "S",
          distance: distance
        }) do
      %{ship | location: move_in_direction(location, distance, :south)}
    end

    def handle_instruction(%Part1Ship{location: location} = ship, %{
          instruction: "W",
          distance: distance
        }) do
      %{ship | location: move_in_direction(location, distance, :west)}
    end

    def handle_instruction(%Part1Ship{direction: direction} = ship, %{
          instruction: "R",
          distance: distance
        }) do
      %{ship | direction: rotate(direction, "R", distance)}
    end

    def handle_instruction(%Part1Ship{direction: direction} = ship, %{
          instruction: "L",
          distance: distance
        }) do
      %{ship | direction: rotate(direction, "L", distance)}
    end

    def move_in_direction({row, column}, distance, direction) do
      {dr, dc} = Map.get(@direction_transforms, direction, {0, 0})

      {row + dr * distance, column + dc * distance}
    end

    def rotate(from, "L", degrees) do
      directions = Enum.reverse(@directions)
      from = Enum.find_index(directions, &(&1 == from))

      Enum.at(directions, rem(from + div(degrees, 90), length(directions)))
    end

    def rotate(from, "R", degrees) do
      directions = @directions
      from = Enum.find_index(directions, &(&1 == from))

      Enum.at(directions, rem(from + div(degrees, 90), length(directions)))
    end
  end

  defmodule Part2Ship do
    defstruct location: {0, 0}, waypoint: {-1, 10}

    @direction_transforms %{
      east: {0, 1},
      south: {1, 0},
      west: {0, -1},
      north: {-1, 0}
    }

    def handle_instruction(%Part2Ship{location: location, waypoint: waypoint} = ship, %{
          instruction: "F",
          distance: distance
        }) do
      %{ship | location: move_with_transform(location, distance, waypoint)}
    end

    def handle_instruction(%Part2Ship{waypoint: waypoint} = ship, %{
          instruction: "N",
          distance: distance
        }) do
      %{ship | waypoint: move_in_direction(waypoint, distance, :north)}
    end

    def handle_instruction(%Part2Ship{waypoint: waypoint} = ship, %{
          instruction: "E",
          distance: distance
        }) do
      %{ship | waypoint: move_in_direction(waypoint, distance, :east)}
    end

    def handle_instruction(%Part2Ship{waypoint: waypoint} = ship, %{
          instruction: "S",
          distance: distance
        }) do
      %{ship | waypoint: move_in_direction(waypoint, distance, :south)}
    end

    def handle_instruction(%Part2Ship{waypoint: waypoint} = ship, %{
          instruction: "W",
          distance: distance
        }) do
      %{ship | waypoint: move_in_direction(waypoint, distance, :west)}
    end

    def handle_instruction(%Part2Ship{waypoint: waypoint} = ship, %{
          instruction: "R",
          distance: distance
        }) do
      %{ship | waypoint: rotate(waypoint, "R", distance)}
    end

    def handle_instruction(%Part2Ship{waypoint: waypoint} = ship, %{
          instruction: "L",
          distance: distance
        }) do
      %{ship | waypoint: rotate(waypoint, "L", distance)}
    end

    def move_in_direction(location, distance, direction) do
      move_with_transform(location, distance, Map.get(@direction_transforms, direction, {0, 0}))
    end

    def move_with_transform({row, column}, distance, {dr, dc}) do
      {row + dr * distance, column + dc * distance}
    end

    def rotate({row, column}, "L", degrees) do
      radians = :math.pi() / 180 * (-1 * degrees)
      cos = :math.cos(radians)
      sin = :math.sin(radians)

      {round(sin * column + cos * row), round(cos * column - sin * row)}
    end

    def rotate({row, column}, "R", degrees) do
      radians = :math.pi() / 180 * degrees
      cos = :math.cos(radians)
      sin = :math.sin(radians)

      {round(sin * column + cos * row), round(cos * column - sin * row)}
    end
  end

  defmodule Parser do
    def parse({instruction, distance}) do
      {distance, _} = Integer.parse(distance)

      %{
        instruction: instruction,
        distance: distance
      }
    end
  end

  def part1(args) do
    %Part1Ship{location: {a, b}} =
      args
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split_at(&1, 1))
      |> Enum.map(&Parser.parse/1)
      |> Enum.reduce(%Part1Ship{}, fn instruction, ship ->
        Part1Ship.handle_instruction(ship, instruction)
      end)

    abs(a) + abs(b)
  end

  def part2(args) do
    %Part2Ship{location: {a, b}} =
      args
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split_at(&1, 1))
      |> Enum.map(&Parser.parse/1)
      |> Enum.reduce(%Part2Ship{}, fn instruction, ship ->
        Part2Ship.handle_instruction(ship, instruction)
      end)

    abs(a) + abs(b)
  end
end
