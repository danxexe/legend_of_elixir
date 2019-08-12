defmodule LegendOfElixir.Scene.Home do
  use Scenic.Scene
  require Logger

  alias Scenic.Graph
  alias Scenic.ViewPort
  alias LegendOfElixir.Server

  import Scenic.Primitives
  # import Scenic.Components

  @note """
    This is a very simple starter application.

    If you want a more full-on example, please start from:

    mix scenic.new.example
  """

  @text_size 24
  @velocity 5

  # ============================================================================
  # setup

  # --------------------------------------------------------
  def init(_, opts) do
    state = Server.current_state

    graph = Graph.build(font: :roboto, font_size: @text_size)

    graph = state.players
    |> Enum.reduce(graph, fn player, graph ->
      graph |> rounded_rectangle({40, 40, 8}, fill: player.color, translate: player.pos, id: player.id)
    end)

    Process.send_after(self(), :tick, 10)

    {:ok, _state = nil, push: graph}
  end

  @controls %{
    "W" => {0, -1},
    "A" => {-1, 0},
    "S" => {0, 1},
    "D" => {1, 0},
  }

  @move_keys @controls |> Map.keys()

  def handle_input(event = {:key, {key, event_type, 0}}, _context, state) when key in ["1", "2"] and event_type in [:press] do
    server_state = Server.current_state

    active_player = %{
      "1" => :player1,
      "2" => :player2,
    } |> Map.get(key)

    Server.update_state(%{server_state | active_player: active_player})

    {:noreply, state}
  end

  def handle_input(event = {:key, {key, event_type, 0}}, _context, state) when key in @move_keys and event_type in [:press, :release] do
    server_state = Server.current_state

    vector = Map.fetch!(@controls, key)

    active_player = server_state.players |> Enum.filter(fn player -> player.id == server_state.active_player end) |> hd

    new_direction = case event_type do
      :press -> active_player |> Map.get(:direction) |> MapSet.put(vector)
      :release -> active_player |> Map.get(:direction) |> MapSet.delete(vector)
    end

    updated_active_player = %{active_player | direction: new_direction}

    other_players = server_state.players |> Enum.reject(fn player -> player.id == server_state.active_player end)

    players = [updated_active_player | other_players] |> Enum.reverse

    Server.update_state(%{server_state | players: players})

    {:noreply, state}
  end

  def handle_input(event, _context, state) do
    Logger.info("Received event: #{inspect(event)}")
    {:noreply, state}
  end

  def handle_info(:tick, state) do
    server_state = Server.current_state

    players = server_state.players
    |> Enum.map(fn player ->
      new_position = player
      |> Map.get(:direction)
      |> Enum.reduce({0,0}, &sum_vector/2)
      |> scale_vector(@velocity)
      |> sum_vector(player.pos)

      %{player | pos: new_position}
    end)


    graph = Graph.build()

    graph = players
    |> Enum.reduce(graph, fn player, graph ->
      graph |> rounded_rectangle({40, 40, 8}, fill: player.color, translate: player.pos, id: player.id)
    end)

    Server.update_state(%{server_state | players: players})

    Process.send_after(self(), :tick, 10)

    {:noreply, state, push: graph}
  end

  def sum_vector({x1, y1}, {x2, y2}) do
    {x1+x2, y1+y2}
  end

  def scale_vector({x,y}, scalar) do
    {x*scalar, y*scalar}
  end
end
