defmodule LegendOfElixir.GraphHelpers do
  import Scenic.Primitives

  def random_object(graph) do
    size = Enum.random(10..40)
    rect = {size, size, 8}
    pos = {
      Enum.random(0..(700 + size)),
      Enum.random(0..(600 + size))
    }
    color = [:sea_green, :green, :olive_drab] |> Enum.random
    graph |> rounded_rectangle(rect, fill: color, stroke: {1, :dark_sea_green}, translate: pos)
  end
end
