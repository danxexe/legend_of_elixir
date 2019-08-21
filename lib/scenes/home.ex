defmodule LegendOfElixir.Scene.Home do
  use Scenic.Scene
  require Logger

  alias Scenic.Graph
  alias LegendOfElixir.RemoteServer, as: Server

  import Scenic.Primitives
  import LegendOfElixir.GraphHelpers

  @text_size 24
  @velocity 5

  @controls %{
    "W" => {0, -1},
    "A" => {-1, 0},
    "S" => {0, 1},
    "D" => {1, 0},
  }

  @move_keys @controls |> Map.keys()

  def child_spec({args, opts}) when is_list(opts) do
    super({args, opts}) |> Map.merge(%{restart: :temporary})
  end

  def init(_args, _opts) do
    {:ok, _state = nil, continue: {:start_tick, 10}}
  end

  def handle_continue({:start_tick, delay}, _state) do
    state = Server.current_state

    graph = Graph.build(clear_color: {0x40, 0x5d, 0x3a}, font: :roboto, font_size: @text_size)

    graph = (1..200) |> Enum.reduce(graph, fn _, graph -> graph |> random_object end)

    graph = state.players
    |> Enum.reduce(graph, fn {player_id, player}, graph ->
      graph |> rounded_rectangle({40, 40, 8}, fill: player.color, stroke: {1, :white}, translate: player.pos, id: player_id)
    end)

    Process.send_after(self(), :tick, delay)

    {:noreply, graph, push: graph}
  end

  def handle_input({:key, {key, event_type, 0}}, _context, state) when key in @move_keys and event_type in [:press, :release] do
    server_state = Server.current_state

    vector = Map.fetch!(@controls, key)

    active_player = server_state.players |> get_in([:player1])

    new_direction = case event_type do
      :press -> active_player |> Map.get(:direction) |> MapSet.put(vector)
      :release -> active_player |> Map.get(:direction) |> MapSet.delete(vector)
    end

    updated_active_player = %{active_player | direction: new_direction}

    Server.update_player(server_state.active_player, updated_active_player)

    {:noreply, state}
  end

  def handle_input(event, _context, state) do
    Logger.info("Received event: #{inspect(event)}")
    {:noreply, state}
  end

  def handle_info(:tick, graph) do
    server_state = Server.current_state

    player = server_state.players
    |> Keyword.get(:player1)

    updated_position = player
    |> Map.get(:direction)
    |> Enum.reduce({0,0}, &sum_vector/2)
    |> scale_vector(@velocity)
    |> sum_vector(player.pos)

    updated_player = %{player | pos: updated_position}

    Server.update_player(:player1, updated_player)

    graph = graph
    |> Graph.modify(:player1, fn rect ->
      %Scenic.Primitive{rect | transforms: %{translate: updated_position}}
    end)

    Process.send_after(self(), :tick, 10)

    {:noreply, graph, push: graph}
  end

  def sum_vector({x1, y1}, {x2, y2}) do
    {x1+x2, y1+y2}
  end

  def scale_vector({x,y}, scalar) do
    {x*scalar, y*scalar}
  end
end
