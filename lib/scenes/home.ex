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

  # ============================================================================
  # setup

  # --------------------------------------------------------
  def init(_, opts) do
    # get the width and height of the viewport. This is to demonstrate creating
    # a transparent full-screen rectangle to catch user input
    {:ok, %ViewPort.Status{size: {width, height}}} = ViewPort.info(opts[:viewport])

    # show the version of scenic and the glfw driver
    scenic_ver = Application.spec(:scenic, :vsn) |> to_string()
    glfw_ver = Application.spec(:scenic, :vsn) |> to_string()

    start_pos = {50, 450}
    state = %{pos: start_pos}

    graph =
      Graph.build(font: :roboto, font_size: @text_size)
      |> rounded_rectangle({100, 200, 8}, fill: :blue, translate: start_pos)

    {:ok, state, push: graph}
  end

  def handle_input(event = {:key, {key, event_type, 0}}, _context, state) when key in ["W"] and event_type in [:press, :repeat] do
    {x, y} = Map.get(state, :pos)

    new_position = {x, y - 10}

    graph =
      Graph.build(font: :roboto, font_size: @text_size)
      |> rounded_rectangle({100, 200, 8}, fill: :red, translate: new_position)

    Logger.info("Received event: #{inspect(event)}")


    {:noreply, %{pos: new_position}, push: graph}
  end

  def handle_input({:key, {key, event_type, 0}}, _context, state) when key in ["A"] and event_type in [:press, :repeat] do
    {x, y} = Map.get(state, :pos)

    new_position = {x - 10, y}

    graph =
      Graph.build(font: :roboto, font_size: @text_size)
      |> rounded_rectangle({100, 200, 8}, fill: :red, translate: new_position)


    {:noreply, %{pos: new_position}, push: graph}
  end

  def handle_input({:key, {key, event_type, 0}}, _context, state) when key in ["D"] and event_type in [:press, :repeat] do
    {x, y} = Map.get(state, :pos)

    new_position = {x + 10, y}

    graph =
      Graph.build(font: :roboto, font_size: @text_size)
      |> rounded_rectangle({100, 200, 8}, fill: :red, translate: new_position)


    {:noreply, %{pos: new_position}, push: graph}
  end

  def handle_input({:key, {key, event_type, 0}}, _context, state) when key in ["S"] and event_type in [:press, :repeat] do
    {x, y} = Map.get(state, :pos)

    new_position = {x, y + 10}

    graph =
      Graph.build(font: :roboto, font_size: @text_size)
      |> rounded_rectangle({100, 200, 8}, fill: :red, translate: new_position)


    {:noreply, %{pos: new_position}, push: graph}
  end

  def handle_input(event, _context, state) do
    Logger.info("Received event: #{inspect(event)}")
    {:noreply, state}
  end
end
