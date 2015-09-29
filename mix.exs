defmodule CKAN.Mixfile do
  use Mix.Project

  def project do
    [app: :ckan,
     version: "0.0.2",
     elixir: "~> 1.1",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: description,
     package: package,
     deps: deps]
  end

  def application do
    [applications: [:logger, :httpotion],
     mod: {CKAN, []}]
  end

  def description do
    "A small library for interacting with CKAN (ckan.org) instances"
  end

  def package do
    [
     files: ["lib", "priv", "mix.exs", "README*", "readme*", "LICENSE*", "license*"],
     maintainers: ["Ross Jones"],
     licenses: ["Apache 2.0"],
     links: %{"GitHub" => "https://github.com/rossjones/ckan_ex"}
    ]
  end

  defp deps do
    [
      {:poison, "~> 1.3"},
      {:ibrowse, github: "cmullaparthi/ibrowse", tag: "v4.2"},
      {:httpotion, "~> 2.1.0"}
    ]
  end
end


