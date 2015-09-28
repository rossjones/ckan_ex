defmodule CKAN.Mixfile do
  use Mix.Project

  def project do
    [app: :ckan,
     version: "0.0.1",
     elixir: "~> 1.1",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  def application do
    [applications: [:logger, :httpotion],
     mod: {CKAN, []}]
  end

  defp deps do
    [
      {:poison, "~> 1.3"},
      {:ibrowse, github: "cmullaparthi/ibrowse", tag: "v4.1.2"},
      {:httpotion, "~> 2.1.0"}
    ]
  end
end
