defmodule LegendOfElixir.MixProject do
  use Mix.Project

  def project do
    [
      app: :legend_of_elixir,
      version: "0.1.0",
      elixir: "~> 1.7",
      build_embedded: true,
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {LegendOfElixir, []},
      extra_applications: []
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:scenic, github: "danxexe/scenic", ref: "a17aa97c71c0f7f40c30d62991c5f446070bcc7c", override: true},
      {:scenic_driver_glfw, github: "boydm/scenic_driver_glfw", ref: "e744f89a929278be41339b25364ea84768674359", targets: :host},
    ]
  end
end
