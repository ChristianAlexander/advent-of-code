defmodule Fuel do
  def calculate([]) do
    0
  end

  def calculate([mass | rest]) do
    calculate(mass) + calculate(rest)
  end

  def calculate(mass) do
    max(div(mass, 3) - 2, 0)
  end

  def calculate_with_fuel(0, acc) do
    acc
  end

  def calculate_with_fuel(fuel_mass, acc) do
    new_fuel = calculate(fuel_mass)
    calculate_with_fuel(new_fuel, acc + new_fuel)
  end

  def calculate_with_fuel(fuel_mass) do
    calculate_with_fuel(fuel_mass, fuel_mass)
  end
end

masses = [
  141_107,
  119_016,
  145_241,
  72264,
  116_665,
  81420,
  88513,
  128_809,
  145_471,
  81570,
  124_798,
  75370,
  84988,
  71634,
  135_275,
  96992,
  53376,
  62414,
  148_277,
  135_418,
  82475,
  137_707,
  105_051,
  83450,
  102_673,
  88390,
  100_849,
  94528,
  135_709,
  63945,
  126_413,
  70107,
  84734,
  119_176,
  85769,
  115_276,
  137_511,
  61806,
  92892,
  121_640,
  93726,
  146_526,
  95812,
  132_556,
  103_885,
  78776,
  55826,
  120_257,
  61131,
  79179,
  130_698,
  97153,
  121_985,
  61159,
  103_585,
  148_674,
  84067,
  110_085,
  138_473,
  105_495,
  112_393,
  144_411,
  73328,
  125_955,
  58075,
  136_147,
  124_106,
  81185,
  138_847,
  69814,
  127_104,
  86090,
  67666,
  102_333,
  99546,
  98280,
  99062,
  129_433,
  125_353,
  77609,
  71240,
  71791,
  146_046,
  113_685,
  121_381,
  122_715,
  147_789,
  53981,
  140_926,
  81528,
  121_789,
  106_627,
  73745,
  67509,
  144_140,
  119_238,
  82417,
  129_215,
  75663,
  106_842
]

IO.puts(Enum.sum(masses |> Enum.map(&(&1 |> Fuel.calculate() |> Fuel.calculate_with_fuel()))))
