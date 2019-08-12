defmodule LegendOfElixir.Server do
  use Agent

  @initial_state %{
    active_player: :player1,
    players: [
      %{id: :player1, pos: {50, 450}, direction: MapSet.new([]), color: :red},
      %{id: :player2, pos: {250, 450}, direction: MapSet.new([]), color: :blue},
    ]
  }

  def start_link(_) do
    Agent.start_link(fn -> @initial_state end, name: __MODULE__)
  end

  def current_state do
    Agent.get(__MODULE__, & &1)
  end

  def update_state(new_state) do
    Agent.update(__MODULE__, fn _current_state -> new_state end)
  end

  # TODO:
  # def update_player(id, signature, state) do
  # end
end
