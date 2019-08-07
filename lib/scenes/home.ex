defmodule LegendOfElixir.Scene.Home do
  use Scenic.Scene
  require Logger

  alias Scenic.Graph
  alias Scenic.ViewPort

  import Scenic.Primitives
  # import Scenic.Components

  @note """
    This is a very simple starter application.

    If you want a more full-on example, please start from:

    mix scenic.new.example
  """

  @text_size 24
  @velocity 10

  # ============================================================================
  # setup

  # --------------------------------------------------------
  def init(_, opts) do
    start_pos = {50, 450}
    state = %{pos: start_pos, direction: MapSet.new([])}

    graph =
      Graph.build(font: :roboto, font_size: @text_size)
      |> rounded_rectangle({100, 200, 8}, fill: :red, translate: start_pos)

    Process.send_after(self(), :tick, 10)

    {:ok, state, push: graph}
  end

  @controls %{
    "W" => {0, -1},
    "A" => {-1, 0},
    "S" => {0, 1},
    "D" => {1, 0},
  }
  
  @move_keys @controls |> Map.keys()

  def handle_input(event = {:key, {key, event_type, 0}}, _context, state) when key in @move_keys and event_type in [:press, :release] do
    # move_to = state |> Map.get(:direction) |> sum_vector(Map.fetch!(@controls, key) |> scale_vector(@velocity))
    
    vector = Map.fetch!(@controls, key)
    
    move_to = case event_type do
      :press -> state |> Map.get(:direction) |> MapSet.put(vector)
      :release -> state |> Map.get(:direction) |> MapSet.delete(vector)
    end

    graph = Graph.build(font: :roboto, font_size: @text_size)
            |> text(inspect(move_to), translate: {50, 50})

    {:noreply, %{state | direction: move_to}, push: graph}
  end

  def handle_input(event, _context, state) do
    Logger.info("Received event: #{inspect(event)}")
    {:noreply, state}
  end
  
  def handle_info(:tick, state) do

    new_position = state 
    |> Map.get(:direction)
    |> Enum.reduce({0,0}, &sum_vector/2)
    |> scale_vector(@velocity)
    |> sum_vector(state.pos)
    
    graph = Graph.build
            |> rounded_rectangle({100, 200, 8}, fill: :red, translate: new_position)
    
    Process.send_after(self(), :tick, 10)
    
    {:noreply, %{state | pos: new_position}, push: graph}
  end
  
  def sum_vector({x1, y1}, {x2, y2}) do
    {x1+x2, y1+y2}
  end
  
  def scale_vector({x,y}, scalar) do
    {x*scalar, y*scalar}
  end
end
