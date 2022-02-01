defmodule SpryCov.MixProject do
  use Mix.Project

  @source_url "https://github.com/tiagoefmoraes/spry_cov"
  @version "0.1.0"

  def project do
    [
      app: :spry_cov,
      version: @version,
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: SpryCov, summary: [threshold: 0], ignore_modules: []],
      preferred_cli_env: [
        "test.watch": :test
      ],
      name: "SpryCov",
      description: "Actionable coverage report with your test results.",
      source_url: @source_url,
      homepage_url: @source_url,
      docs: docs(),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :tools]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.27", only: :dev, runtime: false},
      {:mix_test_watch, "~> 1.0", only: [:dev, :test], runtime: false}
    ]
  end

  defp docs do
    [
      main: "SpryCov",
      source_ref: "v#{@version}",
      formatters: ["html"]
    ]
  end
end
