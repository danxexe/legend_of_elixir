defmodule LegendOfElixir.LocalServer do
  use GenServer

  @initial_state %{
    players: [
      # player1: %{pos: {50, 450}, direction: MapSet.new([]), color: :red},
      # player2: %{pos: {250, 450}, direction: MapSet.new([]), color: :blue},
    ]
  }

  def start_link(_) do
    GenServer.start_link(__MODULE__, @initial_state, name: __MODULE__)
  end

  def current_state do
    GenServer.call(__MODULE__, :current_state)
  end

  def update_player(id, player_state) do
    GenServer.cast(__MODULE__, {:update_player, id, player_state})
  end

  @impl true
  def init(init_arg) do
    {:ok, init_arg}
  end

  @impl true
  def handle_call(:current_state, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_cast({:update_player, id, player_state}, state) do
    state = put_in(state, [:players, id], player_state)

    {:noreply, state}
  end
end
