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
    state = %{
      player_id: node(),
      player: %{pos: random_position(), direction: MapSet.new([]), color: random_color()},
      graph: Graph.build(clear_color: {0x40, 0x5d, 0x3a}, font: :roboto, font_size: @text_size),
    }

    {:ok, state, continue: {:start_tick, 10}}
  end

  def handle_continue({:start_tick, delay}, state) do
    Server.update_player(state.player_id, state.player)
    server_state = Server.current_state

    graph = state.graph

    graph = (1..200) |> Enum.reduce(graph, fn _, graph -> graph |> random_object end)

    graph = graph
    |> update_players(server_state.players)

    Process.send_after(self(), :tick, delay)

    {:noreply, state |> Map.put(:graph, graph), push: graph}
  end

  def handle_input({:key, {key, event_type, 0}}, _context, state) when key in @move_keys and event_type in [:press, :release] do
    server_state = Server.current_state

    vector = Map.fetch!(@controls, key)

    active_player = server_state.players |> get_in([state.player_id])

    new_direction = case event_type do
      :press -> active_player |> Map.get(:direction) |> MapSet.put(vector)
      :release -> active_player |> Map.get(:direction) |> MapSet.delete(vector)
    end

    updated_active_player = %{active_player | direction: new_direction}

    Server.update_player(state.player_id, updated_active_player)

    {:noreply, state}
  end

  def handle_input(event, _context, state) do
    Logger.info("Received event: #{inspect(event)}")
    {:noreply, state}
  end

  def handle_info(:tick, state) do
    server_state = Server.current_state

    player = server_state.players
    |> Keyword.get(state.player_id)

    updated_position = player
    |> Map.get(:direction)
    |> Enum.reduce({0,0}, &sum_vector/2)
    |> scale_vector(@velocity)
    |> sum_vector(player.pos)

    updated_player = %{player | pos: updated_position}

    Server.update_player(state.player_id, updated_player)

    graph = state.graph
    |> update_players(server_state.players)
    |> Graph.modify(state.player_id, fn rect ->
      %Scenic.Primitive{rect | transforms: %{translate: updated_position}}
    end)

    Process.send_after(self(), :tick, 10)

    {:noreply, state |> Map.put(:graph, graph), push: graph}
  end
end
