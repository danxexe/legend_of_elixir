defmodule LegendOfElixir do
  @moduledoc """
  Starter application using the Scenic framework.
  """

  def start(_type, _args) do
    # load the viewport configuration from config
    main_viewport_config = Application.get_env(:legend_of_elixir, :viewport)

    # start the application with the viewport
    children = [
      {Scenic, viewports: [main_viewport_config]},
      LegendOfElixir.Server,
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
