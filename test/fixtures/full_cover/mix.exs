defmodule FullCover.MixProject do
  use Mix.Project

  def project do
    [
      app: :full_cover,
      version: "0.0.1",
      test_pattern: "*_test_fixture.exs",
      test_coverage: [tool: SpryCov],
      deps: [{:spry_cov, path: "../../../", only: :test}]
    ]
  end
end
