defmodule AssetSync.Mixfile do
  use Mix.Project

  def project do
    [app: :asset_sync,
     version: "0.0.1",
     elixir: "~> 1.0",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [mod: {AssetSync, []},
     applications: [:sweet_xml, :ex_aws, :httpoison, :poison, :logger, :crypto]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [
      # see: https://github.com/CargoSense/ex_aws/pull/101 TODO: use hex when pr published
      {:ex_aws, nil, [git: "git://github.com/ohr486/ex_aws.git", branch: "fix_s3_endpoint", override: true]},

      {:httpoison, "~> 0.7", optional: true},
      {:poison, "~> 1.2", optional: true},
      {:sweet_xml, "~> 0.5", optional: true},
      {:power_assert, "~> 0.0.6", only: :test},
      {:meck, "~> 0.8.2", only: :test},
    ]
  end
end
