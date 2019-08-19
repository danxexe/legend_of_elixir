defmodule LegendOfElixir.LocalServer do
  use Agent

  @initial_state %{
    active_player: :player1,
    players: [
      player1: %{pos: {50, 450}, direction: MapSet.new([]), color: :red},
      player2: %{pos: {250, 450}, direction: MapSet.new([]), color: :blue},
    ]
  }

  def start_link(_) do
    Agent.start_link(fn -> @initial_state end, name: __MODULE__)
  end

  def current_state do
    Agent.get(__MODULE__, & &1)
  end

  def update_player(id, player_state) do
   Agent.update(__MODULE__, fn state ->
     put_in(state, [:players, id], player_state)
   end)
  end
end
