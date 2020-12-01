# Opcodes
# 99 - Halt
# 1 - add from the two following referenced positions,
#     storing in third referenced position
# 2 - multiply from the two following referenced positions,
#     storing in third referenced position
# Step IP by 4

defmodule IntcodeComputer do
  defstruct instruction_pointer: 0, memory: %{}, state: :operational

  def from_list(list) do
    %IntcodeComputer{
      memory:
        Enum.with_index(list)
        |> Enum.map(fn {a, b} -> {b, a} end)
        |> Map.new()
    }
  end

  def with_init_params(computer = %IntcodeComputer{memory: memory}, noun, verb) do
    Map.put(computer, :memory, Map.merge(memory, %{1 => noun, 2 => verb}))
  end

  def run(halted_computer = %IntcodeComputer{state: :halted}) do
    dereference(halted_computer, 0)
  end

  def run(computer = %IntcodeComputer{state: :operational}) do
    run(step(computer))
  end

  defp step(computer = %IntcodeComputer{instruction_pointer: ip, state: :operational}) do
    instruction =
      case dereference(computer, ip) do
        1 ->
          &add/1

        2 ->
          &multiply/1

        99 ->
          &halt/1
      end

    computer
    |> instruction.()
    |> increment_instruction_pointer
  end

  defp add(computer = %IntcodeComputer{}) do
    invoke(computer, fn a, b -> a + b end)
  end

  defp multiply(computer = %IntcodeComputer{}) do
    invoke(computer, fn a, b -> a * b end)
  end

  defp invoke(computer = %IntcodeComputer{memory: memory, instruction_pointer: ip}, func) do
    Map.put(
      computer,
      :memory,
      Map.merge(memory, %{
        dereference(computer, ip + 3) =>
          func.(
            dereference(computer, dereference(computer, ip + 1)),
            dereference(computer, dereference(computer, ip + 2))
          )
      })
    )
  end

  defp halt(computer) do
    Map.put(computer, :state, :halted)
  end

  defp increment_instruction_pointer(computer = %IntcodeComputer{instruction_pointer: ip}) do
    Map.put(computer, :instruction_pointer, ip + 4)
  end

  defp dereference(%IntcodeComputer{memory: memory}, location) do
    Map.fetch!(memory, location)
  end
end

program = [
  1,
  0,
  0,
  3,
  1,
  1,
  2,
  3,
  1,
  3,
  4,
  3,
  1,
  5,
  0,
  3,
  2,
  9,
  1,
  19,
  1,
  19,
  5,
  23,
  1,
  9,
  23,
  27,
  2,
  27,
  6,
  31,
  1,
  5,
  31,
  35,
  2,
  9,
  35,
  39,
  2,
  6,
  39,
  43,
  2,
  43,
  13,
  47,
  2,
  13,
  47,
  51,
  1,
  10,
  51,
  55,
  1,
  9,
  55,
  59,
  1,
  6,
  59,
  63,
  2,
  63,
  9,
  67,
  1,
  67,
  6,
  71,
  1,
  71,
  13,
  75,
  1,
  6,
  75,
  79,
  1,
  9,
  79,
  83,
  2,
  9,
  83,
  87,
  1,
  87,
  6,
  91,
  1,
  91,
  13,
  95,
  2,
  6,
  95,
  99,
  1,
  10,
  99,
  103,
  2,
  103,
  9,
  107,
  1,
  6,
  107,
  111,
  1,
  10,
  111,
  115,
  2,
  6,
  115,
  119,
  1,
  5,
  119,
  123,
  1,
  123,
  13,
  127,
  1,
  127,
  5,
  131,
  1,
  6,
  131,
  135,
  2,
  135,
  13,
  139,
  1,
  139,
  2,
  143,
  1,
  143,
  10,
  0,
  99,
  2,
  0,
  14,
  0
]

range = 0..99

results =
  Stream.flat_map(
    range,
    fn noun ->
      Stream.map(range, fn verb ->
        {noun, verb,
         IntcodeComputer.run(
           IntcodeComputer.from_list(program)
           |> IntcodeComputer.with_init_params(noun, verb)
         )}
      end)
    end
  )

{noun, verb, _} = Enum.find(results, fn {_, _, result} -> result == 19_690_720 end)

IO.inspect(100 * noun + verb)
