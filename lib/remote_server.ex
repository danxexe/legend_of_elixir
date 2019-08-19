defmodule LegendOfElixir.RemoteServer do
  def current_state do
    Agent.get({LegendOfElixir.LocalServer, :"server@EB-C02R35H4FVH3"}, & &1)
  end

  def update_player(id, player_state) do
   Agent.update({LegendOfElixir.LocalServer, :"server@EB-C02R35H4FVH3"}, fn state ->
     put_in(state, [:players, id], player_state)
   end)
  end
end
