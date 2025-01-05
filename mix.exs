defmodule LangchainTestbed.MixProject do
  use Mix.Project

  def project do
    [
      app: :langchain_testbed,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {LangchainTestbed.Application, []}


    # applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
	#  {:langchain, git: "https://github.com/brainlid/langchain.git", branch: "main"},
     {:langchain, path: "../langchain"},
      {:req, "~> 0.5.2"}

      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
