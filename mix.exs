defmodule AssetSync.Mixfile do
  use Mix.Project

  def project do
    [app: :asset_sync,
     version: "0.0.2",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  def application do
    [mod: {AssetSync, []},
     applications: [:sweet_xml, :ex_aws, :httpoison, :poison, :logger, :crypto]]
  end

  defp deps do
    [
      {:ex_aws, "~> 1.0.0-beta1", override: true},
      {:httpoison, "~> 0.9", optional: true},
      {:poison, "~> 2.2", optional: true},
      {:sweet_xml, "~> 0.6", optional: true},
      {:meck, "~> 0.8", only: :test},
    ]
  end
end
