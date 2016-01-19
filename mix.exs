defmodule Insight.Mixfile do
  use Mix.Project

  def project do
    [app: :insight,
     version: "0.0.1",
     elixir: "~> 1.2",
     description: description,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps,
     package: package]
  end

  defp description do
    """
    Elixir package for consuming any Insight-powered Bitcoin explorer.
    """
  end

  def application do
    [applications: [:logger, :httpoison],
     mod: {GCloudStorage, []}]
  end

  defp package do
    [maintainers: ["Adán Sánchez de Pedro Crespo"],
     licenses: ["MIT"],
     links: []]
  end

  defp deps do
    [{ :httpoison, "~> 0.8.0" },
     { :poison, "~> 1.5"} ]
  end

end
