defmodule LegendOfElixir.RemoteServer do
  @node :"server@192.168.244.58"

  def current_state do
    GenServer.call({LegendOfElixir.LocalServer, @node}, :current_state)
  end

  def update_player(id, player_state) do
    GenServer.cast({LegendOfElixir.LocalServer, @node}, {:update_player, id, player_state})
  end
end
